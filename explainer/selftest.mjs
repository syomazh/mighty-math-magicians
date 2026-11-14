// selftest.mjs — checks the two logic copies are identical and that the logic
// reproduces every row of experiments/E000_first_sanity_check/output.txt.
// Written by moonshotai/kimi-k3.1-pro (Open Math OS worker W005), 2026-11-13.
// Run: node explainer/selftest.mjs
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import vm from 'node:vm';

const here = dirname(fileURLToPath(import.meta.url));
const logicSrc = readFileSync(join(here, 'logic.js'), 'utf8');
const html = readFileSync(join(here, 'index.html'), 'utf8');

// 1. The inline copy must be byte-identical to logic.js.
const begin = html.indexOf('/* LOGIC-BEGIN */');
const end = html.indexOf('/* LOGIC-END */');
if (begin < 0 || end < 0) {
  console.error('FAIL: LOGIC markers not found in index.html');
  process.exit(1);
}
const inline = html.slice(begin + '/* LOGIC-BEGIN */'.length, end);
const norm = (s) => s.replace(/^\s*\n/, '').replace(/\s+$/, '');
if (norm(inline) !== norm(logicSrc)) {
  console.error('FAIL: inline logic copy differs from logic.js');
  process.exit(1);
}
console.log('OK  inline copy matches logic.js');

// Evaluate logic.js in a sandbox and export what we need.
const sandbox = {};
vm.createContext(sandbox);
vm.runInContext(logicSrc + `
  this.api = { digitsOf, digitSum, fussCatalan, vOf, tOfM, createOrbits,
               censusRows, minClassCount, makeLabelledCounter,
               buildCarrySkeleton, carrySequence, carryDigits, CENSUS_CAP };
`, sandbox);
const L = sandbox.api;

// 2. Parse the E000 output.
const output = readFileSync(
  join(here, '..', 'experiments', 'E000_first_sanity_check', 'output.txt'), 'utf8');
const lines = output.split(/\r?\n/);
let p = 0, k = 0, q = 0, failures = 0, rows = 0;
for (const line of lines) {
  let mch = line.match(/^=== p=(\d+), k=(\d+), q=(\d+) ===$/);
  if (mch) {
    p = Number(mch[1]); k = Number(mch[2]); q = Number(mch[3]);
    continue;
  }
  mch = line.match(/^\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(all OK|FAIL)/);
  if (!mch) continue;
  const [, n, m, s, t, C, vp, dmin, orbits, nmin, nminMod, pred, skel] = mch;
  rows++;
  const nn = Number(n), mm = BigInt(m), tt = Number(t);
  const checks = [];
  const push = (name, got, want) => {
    if (String(got) !== String(want)) checks.push(`${name}: got ${got}, want ${want}`);
  };
  push('C_n', L.fussCatalan(q, nn), BigInt(C));
  push('s_p(m)', L.digitSum(mm, p), Number(s));
  push('t', L.tOfM(mm, p), tt);
  push('v_p(C_n)', L.vOf(L.fussCatalan(q, nn), p), Number(vp));

  const cap = L.CENSUS_CAP[p + ',' + k] || 0;
  if (nn <= cap) {
    const orb = L.createOrbits(p, k);
    const data = L.censusRows(orb, nn);
    const minD = data[0].d;
    const nOrb = data.reduce((a, r) => a + r.classes, 0);
    const nMin = data[0].classes;
    push('min d', minD, Number(dmin));
    push('#orbits', nOrb, Number(orbits));
    push('N_min', nMin, Number(nmin));
    push('N_min % p', nMin % p, Number(nminMod));
  }
  // Minimal-class count from the digits alone must match too.
  const mc = L.minClassCount(p, k, mm);
  push('skeleton N_min', mc.count, BigInt(skel));
  push('pred % p', mc.predictedResidue, Number(pred));
  if (checks.length) {
    failures++;
    console.log(`FAIL p=${p} k=${k} n=${nn}: ${checks.join('; ')}`);
  }
}
console.log(`OK  ${rows} E000 rows reproduced`);
if (failures) {
  console.error(`${failures} rows failed`);
  process.exit(1);
}

// 3. Carry animation invariant: after all t collapses one atom of exponent
//    floor(log_p m) remains, and (-1)^t equals the product of signs.
const cases = [
  [2, 1, 6], [2, 1, 10], [3, 1, 8], [5, 1, 3], [2, 2, 4], [3, 2, 5], [2, 1, 11],
];
for (const [pp, kk, nn] of cases) {
  const qq = pp ** kk;
  const mm = BigInt(qq - 1) * BigInt(nn) + 1n;
  const dg = L.digitsOf(mm, pp);
  const exps = [];
  dg.forEach((d, j) => { for (let i = 0; i < d; i++) exps.push(j); });
  const root = L.buildCarrySkeleton(pp, kk, exps);
  const frames = L.carrySequence(pp, kk, root);
  const t = L.tOfM(mm, pp);
  const last = frames[frames.length - 1];
  const leaves = [];
  (function walk(u) { if (u.leaf) leaves.push(u); else u.children.forEach(walk); })(last.tree);
  const okSteps = frames.length - 1 === t;
  const okLeaf = leaves.length === 1;
  const okSign = last.sign === (t % 2 === 0 ? 1 : -1);
  const dig = L.carryDigits(frames, mm, pp);
  const startDigits = dig[0].digits;
  const okStartDigits = startDigits.length === dg.length && startDigits.every((d, j) => d === dg[j]);
  const finalDigits = dig[dig.length - 1].digits;
  const okDigits = finalDigits.every((d, j) => d === (j === dg.length - 1 ? 1 : 0));
  if (!(okSteps && okLeaf && okSign && okDigits && okStartDigits)) {
    console.log(`FAIL carry p=${pp} k=${kk} n=${nn}: steps=${frames.length - 1} (t=${t}) ` +
      `leaves=${leaves.length} sign=${last.sign} digits=${finalDigits} startDigits=${startDigits} expected=${dg}`);
    failures++;
  }
}
if (failures) process.exit(1);
console.log('OK  carry/cherry animation invariants');
console.log('ALL SELFTESTS PASSED');

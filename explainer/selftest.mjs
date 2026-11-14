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
               classVectorOf, carryClassVector, carryClassSequence, CENSUS_CAP };
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

// 3. Reduced carry animation: exactly t class-vector carries leave one atom
//    of class 0, and the running sign is (-1)^t.  Check every E000 row and
//    some larger inputs; no skeleton-tree construction is claimed.
const carryCases = [[null, null, null]];
for (const line of lines) {
  const mch = line.match(/^=== p=(\d+), k=(\d+), q=(\d+) ===$/);
  if (mch) { p = Number(mch[1]); k = Number(mch[2]); q = Number(mch[3]); continue; }
  const row = line.match(/^\s*(\d+)\s+(\d+)\s+/);
  // E000 also has p-power summary rows that are not UI configurations.
  if (row && [2, 3, 5].includes(p) && q === p ** k) carryCases.push([p, k, BigInt(row[2])]);
}
for (const pp of [2, 3, 5]) {
  for (const kk of [1, 2]) {
    const qq = pp ** kk;
    for (const nn of [1, 2, 17, 40, 100, 257]) {
      carryCases.push([pp, kk, BigInt(qq - 1) * BigInt(nn) + 1n]);
    }
  }
}
for (const [pp, kk, mm] of carryCases.slice(1)) {
  const t = L.tOfM(mm, pp);
  const frames = L.carryClassSequence(mm, pp, kk);
  const last = frames[frames.length - 1];
  const expected = new Array(kk).fill(0);
  expected[0] = 1;
  const okSteps = frames.length - 1 === t;
  const okStart = frames[0].a.every((v, c) => v === L.classVectorOf(mm, pp, kk)[c]);
  const okFinal = last.a.every((v, c) => v === expected[c]);
  const okSign = frames.every((fr, i) => fr.sign === (i % 2 === 0 ? 1 : -1));
  const okMoves = frames.every((fr, i) => {
    if (i === 0) return fr.move === null;
    return fr.move.to === (fr.move.from + 1) % kk &&
      fr.a[fr.move.from] === frames[i - 1].a[fr.move.from] - pp + (fr.move.to === fr.move.from ? 1 : 0) &&
      fr.a[fr.move.to] === frames[i - 1].a[fr.move.to] + (fr.move.to === fr.move.from ? 1 - pp : 1);
  });
  const exhausted = L.carryClassVector(last.a, pp, kk) === null;
  if (!(okSteps && okStart && okFinal && okSign && okMoves && exhausted)) {
    console.log(`FAIL class carry p=${pp} k=${kk} m=${mm}: ` +
      JSON.stringify({ okSteps, okStart, okFinal, okSign, okMoves, exhausted, last }));
    failures++;
  }
}
if (failures) process.exit(1);
console.log(`OK  ${carryCases.length - 1} class-vector carry sequences`);
console.log('ALL SELFTESTS PASSED');

/*
 * Pure counting logic for the Problem 137 explainer.
 * Written by moonshotai/kimi-k3.1-pro (Open Math OS worker W005), 2026-11-13.
 * Candidate argument, not yet verified by the team.
 *
 * Everything is exact (BigInt) and free of factorial valuations.
 *
 * A q-ary tree (q = p^k) is a p-ary tree whose leaves sit at depths 0 mod k.
 * p-ary nodes are stored canonically (children up to cyclic rotation), so an
 * object IS a rotation class; d(node) = number of asymmetric nodes beneath it.
 *
 * NOTE: this exact text is inlined into index.html between LOGIC-BEGIN and
 * LOGIC-END; selftest.mjs checks the two copies are identical.
 */

function digitsOf(m, p) {
  const ds = [];
  while (m > 0n) {
    ds.push(Number(m % BigInt(p)));
    m /= BigInt(p);
  }
  return ds.length ? ds : [0];
}

function digitSum(m, p) {
  return digitsOf(m, p).reduce((a, b) => a + b, 0);
}

function fussCatalan(q, n) {
  q = BigInt(q);
  n = BigInt(n);
  let num = 1n;
  for (let i = 0n; i < n; i++) num = (num * (q * n - i)) / (i + 1n);
  return num / ((q - 1n) * n + 1n);
}

function vOf(x, p) {
  let v = 0;
  const bp = BigInt(p);
  while (x > 0n && x % bp === 0n) {
    x /= bp;
    v++;
  }
  return v;
}

function tOfM(m, p) {
  return (digitSum(m, p) - 1) / (p - 1);
}

// Kept for the predictable, bounded inputs of the UI (n <= nMax).
function weakCompositions(total, parts) {
  const out = [];
  const cur = new Array(parts).fill(0);
  (function rec(left, i) {
    if (i === parts - 1) {
      cur[i] = left;
      out.push(cur.slice());
      return;
    }
    for (let v = 0; v <= left; v++) {
      cur[i] = v;
      rec(left - v, i + 1);
    }
  })(total, 0);
  return out;
}

// Per-(p,k) census cap.  Beyond it the UI still shows the exact C_n and the
// minimal-class data from the digits, but says the full census is offline.
const CENSUS_CAP = { '2,1': 16, '3,1': 9, '5,1': 7, '2,2': 8, '3,2': 4 };

function createOrbits(p, k) {
  const q = p ** k;
  const intern = new Map();
  const d = [0];       // id 0 = leaf, d = 0
  const kids = [null]; // canonical child tuple of every internal node
  const byN = [new Map([[0, 1n]])];
  const caps = { p, k, q, d, kids, byN, build: null, census: null };
  caps.nMax = CENSUS_CAP[p + ',' + k] || 5;

  function pnode(kidArr) {
    let key = kidArr;
    for (let i = 1; i < p; i++) {
      const rot = kidArr.slice(i).concat(kidArr.slice(0, i));
      if (rot.join(',') < key.join(',')) key = rot;
    }
    const ks = key.join(',');
    let id = intern.get(ks);
    if (id === undefined) {
      id = d.length;
      intern.set(ks, id);
      const asym = key.every((c) => c === key[0]) ? 0 : 1;
      d.push(key.reduce((a, c) => a + d[c], 0) + asym);
      kids.push(key.slice());
    }
    return id;
  }

  function qnode(kidArr) {
    let level = kidArr;
    for (let r = 0; r < k; r++) {
      const nxt = [];
      for (let i = 0; i < level.length; i += p) nxt.push(pnode(level.slice(i, i + p)));
      level = nxt;
    }
    return level[0];
  }

  function build(n) {
    if (byN[n]) return byN[n];
    for (let j = 0; j < n; j++) build(j);
    const res = new Map();
    const lists = byN.map((mm) => [...mm.entries()]);
    for (const comp of weakCompositions(n - 1, q)) {
      const choices = comp.map((c) => lists[c]);
      const combo = new Array(q);
      (function rec(i, cnt) {
        if (i === q) {
          const id = qnode(combo);
          res.set(id, (res.get(id) || 0n) + cnt);
          return;
        }
        for (const [id, c] of choices[i]) {
          combo[i] = id;
          rec(i + 1, cnt * c);
        }
      })(0, 1n);
    }
    byN[n] = res;
    return res;
  }

  // Exact, complete census for n <= cap (checked by selftest against E000).
  function census(n) {
    if (n > caps.nMax) throw new Error('census beyond configured cap n=' + caps.nMax);
    build(n);
    return byN[n];
  }

  caps.build = build;
  caps.census = census;
  return caps;
}

function censusRows(orb, n) {
  const cls = orb.census(n);
  const rows = new Map();
  for (const [id, cnt] of cls) {
    const dd = orb.d[id];
    if (!rows.has(dd)) rows.set(dd, { d: dd, classes: 0, trees: 0n });
    const r = rows.get(dd);
    r.classes++;
    r.trees += cnt;
  }
  return [...rows.values()].sort((a, b) => a.d - b.d);
}

// --- Labelled skeleton count W(delta,a), exact BigInt rationals ------------

function gcdBig(a, b) {
  if (a < 0n) a = -a;
  while (b) { const t = a % b; a = b; b = t; }
  return a || 1n;
}

function factBig(x) {
  let f = 1n;
  for (let i = 2n; i <= BigInt(x); i++) f *= i;
  return f;
}

function makeLabelledCounter(p, k) {
  const memoW = new Map();
  const memoC = new Map();

  function W(delta, a) {
    const s = a.reduce((x, y) => x + y, 0);
    if (s === 1) {
      const c = a.indexOf(1);
      return (c + delta) % k === 0 ? [1n, 1n] : [0n, 1n];
    }
    const key = delta + '|' + a.join(',');
    if (memoW.has(key)) return memoW.get(key);
    const [n, dn] = conv(p, (delta + 1) % k, a);
    const val = [n, dn * BigInt(p)];
    memoW.set(key, val);
    return val;
  }

  function conv(r, delta, a) {
    const s = a.reduce((x, y) => x + y, 0);
    if (s < r) return [0n, 1n];
    const key = r + '|' + delta + '|' + a.join(',');
    if (memoC.has(key)) return memoC.get(key);
    if (r === 1) {
      const v = W(delta, a);
      memoC.set(key, v);
      return v;
    }
    let tn = 0n, td = 1n;
    const b = new Array(k).fill(0);
    (function rec(i) {
      if (i === k) {
        const sb = b.reduce((x, y) => x + y, 0);
        if (sb === 0 || s - sb < r - 1) return;
        const wb = W(delta, b);
        if (wb[0] === 0n) return;
        const rest = conv(r - 1, delta, a.map((x, j) => x - b[j]));
        const pn = wb[0] * rest[0], pd = wb[1] * rest[1];
        tn = tn * pd + pn * td;
        td = td * pd;
        const g = gcdBig(tn, td);
        if (g > 1n) { tn /= g; td /= g; }
        return;
      }
      for (let v = 0; v <= a[i]; v++) {
        b[i] = v;
        rec(i + 1);
      }
    })(0);
    const val = [tn, td];
    memoC.set(key, val);
    return val;
  }

  function labelledT(delta, a) {
    const [n, dn] = W(delta, a);
    let f = 1n;
    for (const x of a) f *= factBig(x);
    const num = n * f;
    if (num % dn !== 0n) throw new Error('non-integer labelled count');
    return num / dn;
  }

  function atomClasses(m) {
    const dg = digitsOf(m, p);
    const a = new Array(k).fill(0);
    dg.forEach((mj, j) => { a[j % k] += mj; });
    return a;
  }

  return { W, labelledT, atomClasses };
}

// N_min and its residue, straight from the digits of m (memoized recursion).
function minClassCount(p, k, m) {
  const counter = makeLabelledCounter(p, k);
  const a = counter.atomClasses(m);
  const labelled = counter.labelledT(0, a); // integer by construction
  let fact = 1n;
  for (const x of digitsOf(m, p)) fact *= factBig(x);
  if (labelled % fact !== 0n) throw new Error('non-integral skeleton count');
  const count = labelled / fact;
  const t = tOfM(m, p);
  const residue = Number(modInverse(fact, p)) * (t % 2 === 0 ? 1 : p - 1) % p;
  const countModP = Number(count % BigInt(p));
  return { a, count, residue, predictedResidue: residue, countModP };
}

// Modular inverse of a nonzero residue mod a small prime p (brute force).
function modInverse(x, p) {
  const bp = BigInt(p);
  const a = ((x % bp) + bp) % bp;
  if (a === 0n) throw new Error('no inverse of 0 mod p');
  for (let r = 1n; r < bp; r++) if ((a * r) % bp === 1n) return r;
  throw new Error('no inverse found');
}

// --- Trees as plain objects (for drawing and interaction) ------------------
// Node: {leaf:true, exp, depth} | {leaf:false, children:[...], qnode, depth}

function leafObj(exp, depth) {
  return { leaf: true, exp, depth };
}

// Convert a canonical id into a drawable p-ary tree, collapsing complete
// subtrees into single atom leaves labelled by their exponent.
function idToTree(orb, id, depth = 0) {
  if (id === 0) return leafObj(0, depth);
  const ch = orb.kids[id];
  // d == 0 for the whole subtree means "complete": draw it as one atom.
  if (orb.d[id] === 0) return leafObj(exactExponent(orb, id), depth);
  return {
    leaf: false,
    children: ch.map((c) => idToTree(orb, c, depth + 1)),
    qnode: (depth % orb.k) === 0,
    depth,
    asym: !ch.every((c) => c === ch[0]),
  };
}

function exactExponent(orb, id) {
  if (id === 0) return 0;
  return 1 + exactExponent(orb, orb.kids[id][0]);
}

// Symmetry data of a drawable tree: asymmetric nodes, d, class size p^d.
function treeStats(root, p) {
  let d = 0, nodes = 0;
  (function walk(u) {
    if (u.leaf) return;
    nodes++;
    if (u.asym) d++;
    u.children.forEach(walk);
  })(root);
  return { d, nodes, size: BigInt(p) ** BigInt(d) };
}

// Rotate the children of a drawable node in place (cyclic shift by one).
function rotateNode(u) {
  if (!u.leaf) u.children.push(u.children.shift());
}

// Does rotating node u change the (labelled) tree?  Equivalent to asymmetry.
function rotationChanges(u) {
  return !u.leaf && u.children.some((c) => !sameShape(c, u.children[0]));
}

function sameShape(a, b) {
  if (a.leaf !== b.leaf) return false;
  if (a.leaf) return a.exp === b.exp;
  if (a.children.length !== b.children.length) return false;
  return a.children.every((c, i) => sameShape(c, b.children[i]));
}

// A uniformly random q-ary tree with n internal nodes, via the standard
// bijection with p-ary refinement and random child compositions.
function randomQTree(p, k, n, rand = Math.random) {
  const q = p ** k;
  function buildQ(nn) {
    if (nn === 0) return leafObj(0, 0);
    const comp = randomComposition(nn - 1, q, rand);
    const level = comp.map((c) => buildQ(c));
    return refine(level, k);
  }
  function refine(level, kk) {
    if (kk === 0) return level[0];
    const nxt = [];
    for (let i = 0; i < level.length; i += p) {
      nxt.push({
        leaf: false,
        children: level.slice(i, i + p),
        qnode: kk === 1,
        depth: 0,
        asym: false,
      });
    }
    return refine(nxt, kk - 1);
  }
  const root = buildQ(n);
  (function fix(u, depth) {
    if (u.leaf) { u.depth = depth; return; }
    u.depth = depth;
    u.qnode = depth % k === 0;
    u.asym = rotationChanges(u);
    u.children.forEach((c) => fix(c, depth + 1));
  })(root, 0);
  return root;
}

function randomComposition(total, parts, rand) {
  // uniform weak composition (stars and bars)
  const bars = new Set();
  while (bars.size < parts - 1) bars.add(Math.floor(rand() * (total + parts - 1)));
  const b = [...bars].sort((x, y) => x - y);
  const out = [];
  let prev = -1;
  for (const pos of b.concat([total + parts - 1])) {
    out.push(pos - prev - 1);
    prev = pos;
  }
  return out;
}

// The first minimal class (ids with d == t), as a drawable skeleton tree.
function firstMinimalTree(orb, n) {
  const t = tOfM(BigInt(orb.q - 1) * BigInt(n) + 1n, orb.p);
  for (const [id] of orb.census(n)) {
    if (orb.d[id] === t) return idToTree(orb, id);
  }
  return null;
}

// Enumerate up to `limit` minimal skeleton classes for n <= cap.
function minimalTrees(orb, n, limit = 30) {
  const t = tOfM(BigInt(orb.q - 1) * BigInt(n) + 1n, orb.p);
  const out = [];
  for (const [id] of orb.census(n)) {
    if (orb.d[id] === t) {
      out.push(idToTree(orb, id));
      if (out.length >= limit) break;
    }
  }
  return out;
}

// --- Carries on the class vector -------------------------------------------
// The base-p digit m_j contributes m_j atoms of class j (mod k).  A carry
// replaces p atoms of one class by one atom of the next class and flips the
// sign.  No particular skeleton tree is constructed here.

function classVectorOf(m, p, k) {
  const a = new Array(k).fill(0);
  digitsOf(m, p).forEach((mj, j) => { a[j % k] += mj; });
  return a;
}

// Choose the smallest eligible class.  Returns null when no carry is possible.
function carryClassVector(a, p, k) {
  const c = a.findIndex((count) => count >= p);
  if (c < 0) return null;
  const next = a.slice();
  next[c] -= p;
  next[(c + 1) % k]++;
  return { a: next, move: { from: c, to: (c + 1) % k } };
}

// Every carry removes p-1 atoms, so exactly t carries leave one atom.
function carryClassSequence(m, p, k) {
  const frames = [{ a: classVectorOf(m, p, k), sign: 1, move: null }];
  while (frames[frames.length - 1].a.reduce((x, y) => x + y, 0) > 1) {
    const previous = frames[frames.length - 1];
    const step = carryClassVector(previous.a, p, k);
    if (!step) throw new Error('carry stopped before one atom remained');
    frames.push({ a: step.a, sign: -previous.sign, move: step.move });
  }
  return frames;
}

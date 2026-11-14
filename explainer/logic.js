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

// --- Carry / cherry animation ---------------------------------------------
// A labelled skeleton is built by the same memoized split recursion that
// counts W(delta,a).  Each place j of m starts as one abstract atom p^j.
// The physical complete q-ary subtree represented by that atom can sit at
// any depth congruent to -j (mod k), at most j levels below the root.
// A collapse puts a cherry one level higher, so the column place is exp-depth.

function buildCarrySkeleton(p, k, exps) {
  const total = exps.reduce((acc, j) => acc + BigInt(p) ** BigInt(j), 0n);
  const q = p ** k;
  const n = (total - 1n) / BigInt(q - 1);
  if (n < 0n || BigInt(q - 1) * n + 1n !== total) {
    throw new Error('atoms do not sum to 1 mod (q-1)');
  }
  const counter = makeLabelledCounter(p, k);
  const a = new Array(k).fill(0);
  exps.forEach((j) => { a[j % k]++; });
  if (counter.W(0, a)[0] === 0n) return null;

  // Construct a witness for W(delta,a) > 0, keeping each atom's absolute
  // exponent attached while allocating the class counts to child subtrees.
  // The search backtracks on the physical exponent constraints.
  // W-positive does not by itself pin down physical exponents.  Try every
  // consistent partition at the root, backtracking on incomplete witnesses.
  const memo = new Map();
  function search(delta, atoms, depth) {
    const key = delta + '|' + depth + '|' + atoms.map((x) => x.exp).join(',');
    if (memo.has(key)) return memo.get(key);
    if (atoms.length === 1) {
      const x = atoms[0];
      const out = depth <= x.exp && (depth + x.cls) % k === 0
        ? { leaf: true, exp: x.exp, cls: x.cls, depth } : null;
      memo.set(key, out);
      return out;
    }
    const aa = new Array(k).fill(0);
    atoms.forEach((x) => { aa[x.cls]++; });
    if (counter.W(delta, aa)[0] === 0n) { memo.set(key, null); return null; }
    const cd = (delta + 1) % k;
    const parts = [];
    const b = new Array(k).fill(0);
    let result = null;
    function select(r, left) {
      if (result) return;
      if (r === 1) {
        if (left.some((x) => x < 0) || counter.W(cd, left)[0] === 0n) return;
        parts.push(left.slice());
        if (buildChildren()) return true;
        parts.pop();
        return false;
      }
      function choose(c) {
        if (result) return;
        if (c === k) {
          if (b.every((x) => x === 0) || counter.W(cd, b)[0] === 0n) return;
          const rest = left.map((x, j) => x - b[j]);
          if (rest.some((x) => x < 0)) return;
          parts.push(b.slice());
          select(r - 1, rest);
          parts.pop();
          return;
        }
        for (let v = 0; v <= left[c]; v++) {
          b[c] = v;
          choose(c + 1);
          if (result) return;
        }
        b[c] = 0;
      }
      choose(0);
    }
    function buildChildren() {
      const pool = atoms.slice().sort((x, y) => y.exp - x.exp);
      const children = [];
      const orderedParts = parts.slice().reverse();
      for (const part of orderedParts) {
        const sub = [];
        for (let c = 0; c < k; c++) for (let z = 0; z < part[c]; z++) {
          const at = pool.findIndex((x) => x.cls === c);
          sub.push(pool.splice(at, 1)[0]);
        }
        const child = search(cd, sub, depth + 1);
        if (!child) return false;
        children.push(child);
      }
      result = { leaf: false, children, depth, qnode: depth % k === 0, asym: true };
      return true;
    }
    select(p, aa); // p nonempty parts; the last one is the W remainder
    memo.set(key, result || null);
    return result || null;
  }
  const root = search(0, exps.map((exp) => ({ exp, cls: exp % k })), 0);
  if (!root) throw new Error('could not realize these labelled atoms');
  let next = 0;
  (function stamp(u) {
    if (u.leaf) {
      const i = next++;
      u.label = String.fromCharCode(97 + (i % 26)) + (i >= 26 ? String(Math.floor(i / 26)) : '');
    } else u.children.forEach(stamp);
  })(root);
  return root;
}

// Collect every full p-sibling atom cherry at one place.  Rather than compare
// absolute exponents, compare represented exponents j = exp-depth at the
// sibling level; these are the labels cycled by the carry action.
function findCherries(u, p, out = []) {
  if (u.leaf) return out;
  const byPlace = new Map();
  u.children.forEach((c, i) => {
    if (!c.leaf) return;
    const j = c.exp - c.depth;
    if (j < 0) return;
    if (!byPlace.has(j)) byPlace.set(j, []);
    byPlace.get(j).push(i);
  });
  for (const [place, idx] of byPlace) {
    if (idx.length >= p) {
      const leaf = u.children[idx[0]];
      out.push({ node: u, indices: idx.slice(0, p), cls: leaf.cls, exp: leaf.exp, place });
    }
  }
  u.children.forEach((c) => findCherries(c, p, out));
  return out;
}


// At the root a p^k-sized block collapses to one p-ary leaf, not a q-ary
// atom: m ≡ 1 (mod p^k − 1), so the eventual top exponent is a multiple of k.
function topExponent(exp, k) {
  return Math.ceil(exp / k) * k;
}

// Collapse one cherry; returns info about the move.  Mutates the tree.
function collapseCherry(tree, cherry, k) {
  const group = cherry.indices.map((i) => cherry.node.children[i]);
  const exp = group[0].exp;
  const collapsed = {
    leaf: true,
    exp: exp + 1,
    cls: (group[0].cls + 1) % k,
    depth: (cherry.node.depth || 0) + 1,
    label: group.map((g) => g.label).join(''),
    fused: group.map((g) => g.label),
  };
  const rest = cherry.node.children.filter((_, i) => !cherry.indices.includes(i));
  // keep the collapsed leaf at the position of the first cherry member
  const at = Math.min(...cherry.indices);
  rest.splice(Math.min(at, rest.length), 0, collapsed);
  if (rest.length === 1 && cherry.node.isRoot) {
    // The root collapses to a single p-ary leaf.
    return { root: { ...rest[0], depth: 0 }, fromExp: exp, fused: collapsed.fused };
  }
  cherry.node.children = rest;
  return { root: tree, fromExp: exp, fused: collapsed.fused };
}

// Precompute the whole carry sequence as snapshots (deep copies).
function carrySequence(p, k, root) {
  const frames = [{ tree: cloneTree(root), sign: 1, step: 0, move: null }];
  let cur = cloneTree(root);
  cur.isRoot = true;
  let sign = 1, step = 0;
  while (true) {
    const cherries = findCherries(cur, p);
    if (!cherries.length) break;
    // deterministic: smallest class, then leftmost
    cherries.sort((a, b) => a.cls - b.cls);
    const ch = cherries[0];
    const exp = ch.node.children[ch.indices[0]].exp;
    const labels = ch.indices.map((i) => ch.node.children[i].label);
    const res = collapseCherry(cur, ch, k);
    cur = res.root;
    cur.isRoot = true;
    sign = -sign;
    step++;
    frames.push({
      tree: cloneTree(cur), sign, step,
      move: { exp, labels, cls: ch.cls, fused: res.fused },
    });
  }
  return frames;
}

function cloneTree(u) {
  if (u.leaf) return { ...u };
  return { ...u, children: u.children.map(cloneTree) };
}

// Track base-p digit vectors alongside the frames.  An atom of actual size
// p^exp at depth r is a complete q-ary subtree with p^(exp-r) leaves, so its
// place is exp-r (nonnegative by the depth compatibility condition).  Each
// collapse removes p entries in one place and adds one in the next place.
function carryDigits(frames, m, p) {
  const base = digitsOf(m, p);
  function relCounts(u, out) {
    if (u.leaf) {
      const j = u.exp - (u.depth || 0);
      if (j < 0) throw new Error('atom is smaller than its depth permits');
      while (out.length <= j) out.push(0);
      out[j]++;
      return out;
    }
    u.children.forEach((c) => relCounts(c, out));
    return out;
  }
  const seq = frames.map((fr) => {
    const v = relCounts(fr.tree, []);
    while (v.length < base.length) v.push(0);
    // A carry can reach a new highest place late in the sequence.
    while (v.length > 1 && v[v.length - 1] === 0 && v.length > base.length) v.pop();
    return v;
  });
  const out = [{ digits: seq[0].slice(), addedColumn: null }];
  for (let i = 1; i < seq.length; i++) {
    let col = -1;
    for (let j = 0; j < Math.max(seq[i].length, seq[i - 1].length); j++) {
      if ((seq[i - 1][j] || 0) - (seq[i][j] || 0) > 0) { col = j; break; }
    }
    out.push({ digits: seq[i].slice(), addedColumn: col });
  }
  return out;
}

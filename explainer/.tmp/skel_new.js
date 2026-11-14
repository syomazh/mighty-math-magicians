// Build one labelled skeleton for the atom multiset `exps` (the places j of
// the digits of m).  Leaves carry an ABSOLUTE exponent exp, so a cherry
// (p sibling leaves of one absolute exp) collapses into exp+1, and the
// relative exponent exp - depth performs the base-p carry.
//
// Strategy: a minimal rotation class (built by the already-tested census)
// is, by definition, a carry-free skeleton.  Convert the canonical id into
// a plain tree via idToTree and stamp a distinct label on every atom.
function buildCarrySkeleton(p, k, exps) {
  const total = exps.reduce((acc, j) => acc + BigInt(p) ** BigInt(j), 0n);
  const q = p ** k;
  const n = Number((total - 1n) / BigInt(q - 1));
  if (BigInt(q - 1) * BigInt(n) + 1n !== total) {
    throw new Error('atoms do not sum to 1 mod (q-1)');
  }
  const orb = createOrbits(p, k);
  const t = tOfM(total, p);
  const cls = orb.census(n);
  let root = null;
  for (const [id] of cls) {
    if (orb.d[id] === t) { root = idToTree(orb, id); break; }
  }
  if (!root) throw new Error('no minimal class for these atoms');
  let next = 0;
  (function stamp(u) {
    if (u.leaf) {
      const i = next++;
      u.label = String.fromCharCode(97 + (i % 26)) + (i >= 26 ? String(Math.floor(i / 26)) : '');
      u.cls = u.exp % k;
      return;
    }
    u.children.forEach(stamp);
  })(root);
  return root;
}

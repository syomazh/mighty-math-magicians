"""
E006 -- OEIS reconnaissance and two exact checks (worker W016).

Author: Kimi K3.1 Pro (AI, via Open Math OS), 2026-11-13. Not human-reviewed.

Part 1: enumerate rotation classes of k-blocked p-ary trees (class counts, minimal
class counts, d-refined triangles, labelled counts) and print them in a format
suitable for OEIS searches (searches done by fetch_oeis.py).
Part 3a: the odometer ("add 1 mod p^h") on the leaves of the complete p-ary tree
as a product of node rotations; order of the rotation group.
Part 3b: test whether canonical labellings turn cyclic p-ary trees with labelled
leaves into permutations consisting of t p-cycles, bijectively.

Trees: p-ary tree = leaf or p-tuple of subtrees. Rotation class = equivalence
under cyclic rotation of the p children at any node. k-blocked: every leaf at
depth 0 mod k (these are the q-ary trees, q = p^k). Counts should agree with E000.
"""
import itertools
import math
import sys
from collections import defaultdict

CASES = [(2, 1, 11), (3, 1, 8), (5, 1, 6), (7, 1, 5), (2, 2, 7), (3, 2, 5), (2, 3, 5)]


def weak_compositions(total, parts):
    if parts == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in weak_compositions(total - first, parts - 1):
            yield (first,) + rest


def digits(m, p):
    ds = []
    while m:
        ds.append(m % p)
        m //= p
    return ds


class Orbits:
    """Same construction as experiments/E000_first_sanity_check/check.py."""

    def __init__(self, p, k):
        self.p, self.k, self.q = p, k, p ** k
        self.intern = {}
        self.d = [0]
        self.by_n = {0: {0: 1}}

    def pnode(self, kids):
        p = self.p
        key = min(kids[i:] + kids[:i] for i in range(p))
        i = self.intern.get(key)
        if i is None:
            i = len(self.d)
            self.intern[key] = i
            asym = 0 if len(set(key)) == 1 else 1
            self.d.append(sum(self.d[c] for c in key) + asym)
        return i

    def qnode(self, kids):
        level = list(kids)
        for _ in range(self.k):
            level = [self.pnode(tuple(level[i:i + self.p])) for i in range(0, len(level), self.p)]
        return level[0]

    def build(self, n):
        if n in self.by_n:
            return self.by_n[n]
        for j in range(n):
            self.build(j)
        res = defaultdict(int)
        for comp in weak_compositions(n - 1, self.q):
            lists = [list(self.by_n[c].items()) for c in comp]
            for combo in itertools.product(*lists):
                cnt = 1
                for _, c in combo:
                    cnt *= c
                res[self.qnode(tuple(i for i, _ in combo))] += cnt
        self.by_n[n] = dict(res)
        return self.by_n[n]


def classes_by_leaves(p, mmax):
    """Number of rotation classes of p-ary trees with m leaves (no blocking)."""
    intern = {(): 0}
    level = {1: [0]}

    def node(kids):
        key = min(kids[i:] + kids[:i] for i in range(p))
        if key not in intern:
            intern[key] = len(intern)
        return intern[key]

    for m in range(2, mmax + 1):
        s = set()
        for comp in weak_compositions(m, p):
            if any(c < 1 or c >= m for c in comp):
                continue
            for combo in itertools.product(*[level[c] for c in comp]):
                s.add(node(tuple(combo)))
        level[m] = sorted(s)
    return [len(level[m]) for m in range(1, mmax + 1)]


# ---------------------------------------------------------------------------
# Part 1
# ---------------------------------------------------------------------------

def part1():
    print("=" * 78)
    print("PART 1 -- sequences to look up in the OEIS")
    print("=" * 78)
    for p, k, nmax in CASES:
        orb = Orbits(p, k)
        counts, nmins, triangles = [], [], []
        for n in range(1, nmax + 1):
            cls = orb.build(n)
            m = (orb.q - 1) * n + 1
            t = (sum(digits(m, p)) - 1) // (p - 1)
            counts.append(len(cls))
            nmins.append(sum(1 for i in cls if orb.d[i] == t))
            tri = defaultdict(int)
            for i in cls:
                tri[orb.d[i]] += 1
            triangles.append(dict(sorted(tri.items())))
        print(f"\n(p,k)=({p},{k}), q={orb.q}")
        print(f"  class counts by n=1..{nmax}:      {counts}")
        print(f"  minimal class counts N_min:       {nmins}")
        if k == 1 and p in (2, 3):
            print("  triangle N_d (classes with d asymmetric nodes):")
            for n, tri in enumerate(triangles, 1):
                print(f"    n={n:2d} (m={(p-1)*n+1:2d}): {tri}   row sum {sum(tri.values())}")
            for d in range(3):
                print(f"  column d={d}: {[tri.get(d, 0) for tri in triangles]}")

    print("\nLabelled counts T for k=1: T(t) = (pt)!/(t! p^t), t = 0..7")
    for p in (2, 3, 5):
        print(f"  p={p}: {[math.factorial(p*t)//(math.factorial(t)*p**t) for t in range(0, 8)]}")

    print("\nClasses of unblocked p-ary trees by number of leaves m:")
    for p in (2, 3):
        counts = classes_by_leaves(p, 11 if p == 2 else 9)
        print(f"  p={p}, m=1..{len(counts)}: {counts}")


# ---------------------------------------------------------------------------
# Part 3a: odometer
# ---------------------------------------------------------------------------

def check_odometer(p, h):
    """Leaves of the complete p-ary tree of height h are addressed by their root path,
    a base-p string d_0..d_{h-1} with the LEAST significant digit first (d_0 = child
    index at the root); the root-to-leaf order is therefore REVERSED base-p digits
    of the leaf number. Adding 1: rotate every node on the leaf's path whose subtree
    wraps, i.e. every node at depth j with d_0 = ... = d_j = p-1. These rotations
    commute (their support inside the subtree of the deepest rotated node is trivial
    after the deepest rotation, so they can be applied deepest-first).
    Verified against 'add 1 mod p^h' on every leaf."""
    N = p ** h

    def to_digits(x):  # d_0 = least significant = child index at the root
        ds = []
        for _ in range(h):
            ds.append(x % p)
            x //= p
        return ds

    def to_index(ds):
        return sum(d * p ** j for j, d in enumerate(ds))

    def odometer(ds):
        out = list(ds)
        out[0] = (out[0] + 1) % p  # rotation of the deepest node (parent of the leaf)
        j = 0
        while j < h - 1 and ds[j] == p - 1:
            # carry propagates: the node at depth j+1 on the path rotates by +1
            out[j + 1] = (out[j + 1] + 1) % p
            j += 1
        return out

    ok = all(to_index(odometer(to_digits(x))) == (x + 1) % N for x in range(N))
    print(f"  p={p}, h={h}: matches 'add 1 mod {N}' on all {N} leaves: {ok}; "
          f"rotation group order p^((p^h-1)/(p-1)) = {p ** ((N - 1) // (p - 1))}")
    assert ok

    # interpret the digit update as node rotations: trailing p-1 digits of x count the
    # carries, so the nodes at depths h-1 down to h-1-(number of trailing p-1 digits)
    # on the leaf's path rotate by +1; every other node is untouched.
    for x in range(min(N, 2 * p)):
        ds = to_digits(x)
        carry = 0
        for d in ds:
            if d == p - 1:
                carry += 1
            else:
                break
        depths = list(range(h - 1, h - 2 - carry, -1))
        print(f"    leaf {x:3d} digits(lsd first)={ds}: rotate nodes at depths {depths} "
              f"on its path (trailing p-1 digits = {carry})")



def part3a():
    print("\n" + "=" * 78)
    print("PART 3a -- the odometer as a product of rotations")
    print("=" * 78)
    print("Leaf x is addressed by its root path = base-p digits of x, least significant")
    print("digit first (d_0 = child index at the root, d_{h-1} = leaf slot). Adding 1")
    print("rotates by +1 the deepest node on the path (parent of the leaf, depth h-1)")
    print("and then, for every trailing digit equal to p-1, the next node up (carry).")
    print("So the nodes at depths h-1, h-2, ..., h-1-j rotate, where j = number of")
    print("trailing (p-1) digits of x. The root rotates exactly when x = p^h - 1.")
    for p in (2, 3):
        for h in range(1, 5):
            check_odometer(p, h)
    print("The rotation group of the complete tree of height h has one independent Z_p")
    print("generator at each of the 1+p+...+p^(h-1) = (p^h-1)/(p-1) internal nodes;")
    print("its action on the p^h leaves is faithful, and the order is")
    print("p^((p^h-1)/(p-1)) by the wreath-product recursion |G_h| = p*|G_{h-1}|^p.")


# ---------------------------------------------------------------------------
# Part 3b: labelled cyclic p-ary trees vs permutations with t p-cycles
# ---------------------------------------------------------------------------

_LABEL_TREES = {}


def tree_key(x):
    """Total order on trees: leaves (int) sort before internal nodes (tuple)."""
    if isinstance(x, tuple):
        return (1, tuple(tree_key(c) for c in x))
    return (0, x)


def trees_on_labels(p, labels):
    """All canonical cyclic p-ary trees with the given distinct leaf labels.
    A tree is an int (a leaf) or a canonically rotated tuple of p subtrees."""
    labels = tuple(sorted(labels))
    key = (p, labels)
    if key in _LABEL_TREES:
        return _LABEL_TREES[key]
    if len(labels) == 1:
        _LABEL_TREES[key] = {labels[0]}
        return _LABEL_TREES[key]
    out = set()

    def partitions(avail, nparts):
        # unique partitions: smallest available label always in the first part,
        # parts ordered by their smallest label
        if nparts == 1:
            if len(avail) >= 1 and (len(avail) - 1) % (p - 1) == 0:
                yield (tuple(avail),)
            return
        first = avail[0]
        rest = avail[1:]
        for size in range(1, len(avail) - nparts + 2):
            if (size - 1) % (p - 1):
                continue
            for combo in itertools.combinations(rest, size - 1):
                part = (first,) + combo
                remaining = [x for x in rest if x not in combo]
                for tail in partitions(remaining, nparts - 1):
                    yield (part,) + tail

    for parts in partitions(list(labels), p):
        subs = [sorted(trees_on_labels(p, pt), key=repr) for pt in parts]
        for combo in itertools.product(*subs):
            out.add(min((combo[i:] + combo[:i] for i in range(p)), key=tree_key))
    _LABEL_TREES[key] = out
    return out


def collapse_cycles(tree, p, rule):
    """Repeatedly collapse a cherry (internal node whose p children are all leaves)
    to a single new leaf. New leaves (the internal nodes) get canonical labels
    s+1, s+2, ... in collapse order. Return the list of p-cycles: for each internal
    node in collapse order, its p children in cyclic order starting from the
    smallest child label. `rule` picks the next cherry:
      minlabel -- contains the smallest current leaf label;
      minmax   -- smallest maximum leaf label;
      minsum   -- smallest sum of leaf labels;
      minlist  -- lexicographically smallest sorted leaf-label list.
    """
    def build(x):
        if not isinstance(x, tuple):
            return ['L', x]
        return ['I', [build(c) for c in x]]

    root = build(tree)
    cycles = []
    s = sum(1 for _ in iter_leaves(tree))
    next_id = s + 1
    while root[0] == 'I':
        cherries = []

        def walk(node):
            kids = node[1]
            if all(k[0] == 'L' for k in kids):
                cherries.append(node)
            else:
                for k in kids:
                    if k[0] == 'I':
                        walk(k)

        walk(root)
        if rule == 'minlabel':
            cherries.sort(key=lambda nd: min(k[1] for k in nd[1]))
        elif rule == 'minmax':
            cherries.sort(key=lambda nd: max(k[1] for k in nd[1]))
        elif rule == 'minsum':
            cherries.sort(key=lambda nd: sum(k[1] for k in nd[1]))
        elif rule == 'minlist':
            cherries.sort(key=lambda nd: sorted(k[1] for k in nd[1]))
        ch = cherries[0]
        leaf_labels = [k[1] for k in ch[1]]
        i = leaf_labels.index(min(leaf_labels))
        cycles.append(tuple(leaf_labels[i:] + leaf_labels[:i]))
        # collapse: this internal node becomes a leaf with the next canonical label
        ch[0] = 'L'
        ch[1] = next_id
        next_id += 1
    return cycles


def iter_leaves(tree):
    if isinstance(tree, tuple):
        for c in tree:
            yield from iter_leaves(c)
    else:
        yield tree


def cycles_to_perm(cycles, n):
    """One-line permutation of {1..n} given by the cycles; points not appearing in
    any cycle are fixed points."""
    perm = {}
    for cyc in cycles:
        for i, a in enumerate(cyc):
            perm[a] = cyc[(i + 1) % len(cyc)]
    return tuple(perm.get(i, i) for i in range(1, n + 1))


def cycle_lengths(perm):
    seen = [False] * (len(perm) + 1)
    out = []
    for i in range(1, len(perm) + 1):
        if seen[i]:
            continue
        j, length = i, 0
        while not seen[j]:
            seen[j] = True
            j = perm[j - 1]
            length += 1
        out.append(length)
    return sorted(out)


def part3b():
    print("\n" + "=" * 78)
    print("PART 3b -- labelled cyclic p-ary trees vs permutations with t p-cycles")
    print("=" * 78)
    for p, smax in ((2, 6), (3, 7)):
        for s in range(1, smax + 1):
            if (s - 1) % (p - 1):
                continue
            t = (s - 1) // (p - 1)
            trees = sorted(trees_on_labels(p, range(1, s + 1)), key=repr)
            expected = math.factorial(p * t) // (math.factorial(t) * p ** t)
            print(f"\n  p={p}, s={s}, t={t}: #labelled cyclic trees = {len(trees)}, "
                  f"(pt)!/(t!p^t) = {expected}, match = {len(trees) == expected}")
            if t == 0:
                continue
            for rule in ('minlabel', 'minmax', 'minsum', 'minlist'):
                images = {}
                for tr in trees:
                    cycles = collapse_cycles(tr, p, rule)
                    perm = cycles_to_perm(cycles, s + t)
                    images.setdefault(perm, []).append(tr)
                ncoll = sum(len(v) - 1 for v in images.values())
                sample = next(iter(images))
                lens = cycle_lengths(sample)
                used = sorted({a for cy in collapse_cycles(trees[0], p, rule) for a in cy})
                allsupport = set()
                for pm in images:
                    allsupport |= {i for i, v in enumerate(pm, 1) if v != i}
                print(f"    rule={rule:9s}: distinct images {len(images)}/{len(trees)} "
                      f"(collisions {ncoll}); sample cycle lengths {lens}")
                print(f"      support of sample cycles: {used}")
                print(f"      moved points over all images: {len(allsupport)} of {s+t} "
                      f"(points 1..{s+t})")
                if p * t <= 10:
                    target = set()
                    for pm in itertools.permutations(range(1, s + t + 1)):
                        if cycle_lengths(pm) == [p] * t + [1] * (s + t - p * t):
                            target.add(pm)
                    print(f"      target set = perms with {t} cycles of length {p} on {s+t} "
                          f"points: size {len(target)}; images hit {len(set(images) & target)} "
                          f"of them")



if __name__ == "__main__":
    which = sys.argv[1] if len(sys.argv) > 1 else "all"
    if which in ("all", "1"):
        part1()
    if which in ("all", "3a"):
        part3a()
    if which in ("all", "3b"):
        part3b()

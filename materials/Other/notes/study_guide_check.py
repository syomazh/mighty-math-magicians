# Written by Claude Fable 5.2 (orchestrator), 2026-11-13. Recomputes every number used in
# notes/study_guide.md. Run: uv run python notes/study_guide_check.py   (takes a few seconds)
"""
Trees are p-ary: a leaf is the empty tuple (printed as o); a node is a tuple of p trees.
Two trees are in the same class if one is obtained from the other by rotating the children
of nodes.  canon(T) picks one representative per class (smallest rotation at every node).
"""
import itertools
from functools import lru_cache
from math import comb, factorial


def trees(p, n):
    """All p-ary trees with n internal nodes."""
    @lru_cache(maxsize=None)
    def go(n):
        if n == 0:
            return ((),)
        out = []
        for split in compositions(n - 1, p):
            for kids in itertools.product(*[go(c) for c in split]):
                out.append(tuple(kids))
        return tuple(out)
    return go(n)


def compositions(total, parts):
    if parts == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, parts - 1):
            yield (first,) + rest


@lru_cache(maxsize=None)
def canon(T):
    if T == ():
        return ()
    kids = tuple(canon(c) for c in T)
    return min(kids[i:] + kids[:i] for i in range(len(kids)))


@lru_cache(maxsize=None)
def d(T):
    """Number of asymmetric nodes."""
    if T == ():
        return 0
    kids = [canon(c) for c in T]
    return sum(d(c) for c in T) + (0 if len(set(kids)) == 1 else 1)


@lru_cache(maxsize=None)
def leaves(T):
    return 1 if T == () else sum(leaves(c) for c in T)


def show(T):
    return 'o' if T == () else '(' + ' '.join(show(c) for c in T) + ')'


def digits(m, p):
    out = []
    while m:
        out.append(m % p)
        m //= p
    return out


def census(p, n, blocked_k=1):
    """Classes of p-ary trees with n nodes; if blocked_k > 1 keep only trees whose leaves
    all have depth divisible by blocked_k."""
    def ok(T, depth=0):
        if T == ():
            return depth % blocked_k == 0
        return all(ok(c, depth + 1) for c in T)
    cls = {}
    for T in trees(p, n):
        if blocked_k > 1 and not ok(T):
            continue
        cls.setdefault(canon(T), []).append(T)
    return cls


def report(p, n, blocked_k=1, list_trees=False, label=''):
    cls = census(p, n, blocked_k)
    total = sum(len(v) for v in cls.values())
    m = (p - 1) * n + 1
    s = sum(digits(m, p))
    t = (s - 1) // (p - 1)
    print(f"\n--- {label or f'p={p}, {n} nodes'}: {total} trees, {len(cls)} classes, "
          f"m={m} leaves = {digits(m, p)[::-1]} in base {p}, digit sum {s}, t={t}")
    hist = {}
    for c, members in sorted(cls.items(), key=lambda kv: (d(kv[1][0]), show(kv[0]))):
        dd = d(members[0])
        assert len(members) == p ** dd, "class size is not p^d"
        hist[dd] = hist.get(dd, 0) + 1
        if list_trees:
            print(f"   class of size {len(members)} = {p}^{dd}:  " + '   '.join(show(T) for T in members))
    print("   classes by d:", dict(sorted(hist.items())),
          "| check sum of p^d =", sum(cnt * p ** dd for dd, cnt in hist.items()))
    dmin = min(hist)
    print(f"   smallest d = {dmin} (t = {t}); number of classes with d = t: {hist[dmin]}")
    return cls


def atoms_of(T):
    """Sizes (leaf counts) of the maximal complete subtrees of a minimal tree, as a nested list."""
    def complete(T):
        return T == () or (len({canon(c) for c in T}) == 1 and all(complete(c) for c in T))
    if complete(T):
        return leaves(T)
    return [atoms_of(c) for c in T]


def labelled_count(p, k, a):
    """T(a): labelled cyclic p-ary trees, a[c] labels of class c, class-c leaf at depth = -c mod k.
    Brute force over set partitions; fine for the tiny cases used in the guide."""
    labels = [(c, i) for c in range(k) for i in range(a[c])]

    @lru_cache(maxsize=None)
    def count(labset, depth):
        labset = tuple(sorted(labset))
        if len(labset) == 1:
            return 1 if (labset[0][0] + depth) % k == 0 else 0
        total = 0
        # ordered p-tuples of non-empty blocks, then divide by p for rotation
        for assign in itertools.product(range(p), repeat=len(labset)):
            if len(set(assign)) < p:
                continue
            prod = 1
            for b in range(p):
                block = tuple(x for x, g in zip(labset, assign) if g == b)
                prod *= count(block, (depth + 1) % k)
                if prod == 0:
                    break
            total += prod
        assert total % p == 0
        return total // p
    return count(tuple(labels), 0)


if __name__ == "__main__":
    print("EXERCISE DATA FOR notes/study_guide.md")

    print("\n== Catalan numbers and powers of 2 ==")
    for n in range(1, 13):
        C = comb(2 * n, n) // (n + 1)
        v = 0
        x = C
        while x % 2 == 0:
            x //= 2
            v += 1
        print(f"   n={n:>2}  C_n={C:>6}  2-power={v}  n+1={n+1:>2} = {bin(n+1)[2:]:>5} in binary, "
              f"ones={bin(n+1).count('1')}, ones-1={bin(n+1).count('1')-1}")

    report(2, 3, list_trees=True, label="binary trees with 3 nodes")
    report(2, 4, list_trees=True, label="binary trees with 4 nodes")
    for n in (1, 2, 5):
        report(2, n)
    cls = report(2, 6, label="binary trees with 6 nodes")
    print("   minimal classes (d = 2), one representative each, with atom sizes:")
    for c, members in cls.items():
        if d(members[0]) == 2:
            print("     ", show(c), "  atoms:", atoms_of(c))

    report(3, 2, list_trees=True, label="ternary trees with 2 nodes")
    cls = report(3, 3, list_trees=True, label="ternary trees with 3 nodes")
    report(3, 4, label="ternary trees with 4 nodes")

    # q = 4 as binary trees with all leaves at even depth: n q-ary nodes = 3n binary nodes
    cls = report(2, 6, blocked_k=2, label="q=4, 2 nodes  (binary trees with 6 nodes, leaves at even depth)")
    for c in cls:
        print("      representative:", show(c), " atoms:", atoms_of(c))
    cls = report(2, 12, blocked_k=2, label="q=4, 4 nodes  (binary trees with 12 nodes, leaves at even depth)")
    for c, members in cls.items():
        if d(members[0]) == 2:
            print("      minimal representative:", show(c)[:60], "... atoms:", atoms_of(c))

    print("\n== carries: T(a) = number of labelled cyclic trees ==")
    for p, k, a in [(2, 1, (1,)), (2, 1, (2,)), (2, 1, (3,)), (2, 1, (4,)),
                    (3, 1, (1,)), (3, 1, (3,)), (3, 1, (5,)),
                    (2, 2, (1, 0)), (2, 2, (0, 2)), (2, 2, (2, 1)), (2, 2, (2, 0)), (2, 2, (0, 1))]:
        print(f"   p={p} k={k} a={a}:  T = {labelled_count(p, k, a)}")

    print("\n== exact count for q = p:  (pt)!/(t! p^t prod m_j!) ==")
    for p, n in [(2, 6), (3, 8), (3, 6), (5, 3)]:
        m = (p - 1) * n + 1
        dg = digits(m, p)
        t = (sum(dg) - 1) // (p - 1)
        fact = 1
        for x in dg:
            fact *= factorial(x)
        print(f"   p={p} n={n} m={m} digits={dg[::-1]} t={t}: N_min = "
              f"{factorial(p*t)//(factorial(t)*p**t*fact)}")

    print("\n== why p must be prime: 4-tuples ==")
    word = ('A', 'B', 'A', 'B')
    rots = {word[i:] + word[:i] for i in range(4)}
    print(f"   the word {word} has {len(rots)} different rotations (not 1 and not 4)")

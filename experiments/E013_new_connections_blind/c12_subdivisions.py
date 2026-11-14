# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Connections 1 and 2: recursive subdivisions of a square (quadtrees, q = 4)
# and of a triangle (Sierpinski refinement / stacked triangulations, p = 3).
#
# Geometric model, independent of the tree definitions:
#   a picture = the set of addresses of its cells (address = sequence of
#   child positions from the root);
#   a move    = pick a block that has been subdivided and apply a rigid
#               symmetry of that block to everything inside it.
# Claim tested: the orbits of pictures under moves are exactly the rotation
# classes of the brief, they have p^d members, the smallest has p^t members,
# the number of smallest orbits is not divisible by p, so p^t exactly divides
# the number of pictures.
#
# Run from the repository root:
#   uv run python experiments/E013_new_connections_blind/c12_subdivisions.py

import sys
from collections import Counter
from itertools import permutations
from math import factorial

sys.path.insert(0, __file__.rsplit("c12_subdivisions.py", 1)[0])
from trees import (LEAF, canon, d_sigma, digit_sum, digits, fuss_catalan,
                   ordered_trees, t_of, val)

sys.setrecursionlimit(10000)


def picture(T, prefix=()):
    """Set of leaf addresses of an ordered tree."""
    if T == LEAF:
        return frozenset([prefix])
    out = set()
    for i, c in enumerate(T):
        out |= picture(c, prefix + (i,))
    return frozenset(out)


def blocks(P):
    """Addresses of all subdivided blocks (internal nodes) of a picture."""
    out = set()
    for a in P:
        for k in range(len(a)):
            out.add(a[:k])
    return out


def rigid_move(P, w, g):
    """Apply the symmetry g (a permutation of child positions, the same linear
    map at every scale) rigidly to the block with address w."""
    k = len(w)
    out = set()
    for a in P:
        if a[:k] == w:
            out.add(w + tuple(g[x] for x in a[k:]))
        else:
            out.add(a)
    return frozenset(out)


def orbits(pictures, gens):
    """Connected components of the set of pictures under rigid moves."""
    todo = set(pictures)
    comps = []
    while todo:
        start = next(iter(todo))
        comp = {start}
        stack = [start]
        while stack:
            P = stack.pop()
            for w in blocks(P):
                for g in gens:
                    Q = rigid_move(P, w, g)
                    if Q not in comp:
                        comp.add(Q)
                        stack.append(Q)
        assert comp <= todo
        todo -= comp
        comps.append(comp)
    return comps


# ----------------------------------------------------------------------------
# Square.  Child position q <-> quadrant (i, j) = (q & 1, q >> 1), i = x bit.
# 0 = SW, 1 = SE, 2 = NW, 3 = NE.
def quad_perm(f):
    out = []
    for q in range(4):
        i, j = q & 1, q >> 1
        i2, j2 = f(i, j)
        out.append(i2 + 2 * j2)
    return tuple(out)


ROT90 = quad_perm(lambda i, j: (1 - j, i))      # (x, y) -> (1 - y, x)
MIRROR = quad_perm(lambda i, j: (1 - i, j))     # (x, y) -> (1 - x, y)


def group_closure(gens):
    n = len(gens[0])
    ident = tuple(range(n))
    G = {ident}
    frontier = [ident]
    while frontier:
        h = frontier.pop()
        for g in gens:
            k = tuple(g[h[x]] for x in range(n))
            if k not in G:
                G.add(k)
                frontier.append(k)
    return G


def to_binary(T, pairing):
    """Read a 4-ary tree as a binary tree with leaves at even depth.
    pairing = ((a, b), (c, d)): child positions grouped in two pairs."""
    if T == LEAF:
        return LEAF
    (a, b), (c, d) = pairing
    return ((to_binary(T[a], pairing), to_binary(T[b], pairing)),
            (to_binary(T[c], pairing), to_binary(T[d], pairing)))


DIAG = ((0, 3), (1, 2))   # SW+NE | SE+NW : the two diagonals
ROWS = ((0, 1), (2, 3))   # bottom row | top row : "cut in half, then in half"


def check_square(Nmax):
    print("=" * 72)
    print("SQUARE (quadtrees, q = 4 = 2^2)")
    G = group_closure([ROT90, MIRROR])
    print("symmetries of the square acting on the 4 quadrants: order", len(G))
    assert len(G) == 8
    # every symmetry preserves the pair of diagonals {SW,NE}, {SE,NW}
    for g in G:
        img = {frozenset(g[x] for x in pair) for pair in DIAG}
        assert img == {frozenset(pair) for pair in DIAG}
    # and the wreath product C2 wr C2 on the diagonal pairing has order 8 too,
    # so the two groups coincide
    W = group_closure([(3, 1, 2, 0), (0, 2, 1, 3), (1, 0, 3, 2)])
    assert W == G, "D4 on quadrants is not C2 wr C2 on diagonals"
    print("  = C2 wr C2 with blocks the two diagonals: True")
    print()
    print(" N  cells  #quadtrees  v2  t=s2(m)-1  #orbits  orbit sizes (size:count)"
          "  #smallest")
    for N in range(0, Nmax + 1):
        m = 3 * N + 1
        trees = ordered_trees(m, 4)
        C = fuss_catalan(4, N)
        assert len(trees) == C
        pics = {picture(T): T for T in trees}
        assert len(pics) == C          # different trees, different pictures
        comps = orbits(pics.keys(), [ROT90, MIRROR])
        t = t_of(m, 2)
        sizes = Counter()
        for comp in comps:
            cls = {canon(to_binary(pics[P], DIAG)) for P in comp}
            assert len(cls) == 1, "orbit meets two rotation classes"
            d = {d_sigma(to_binary(pics[P], DIAG))[0] for P in comp}
            assert len(d) == 1
            d = d.pop()
            assert len(comp) == 2 ** d, "orbit size is not 2^d"
            sizes[len(comp)] += 1
        # orbits = classes (no class is split into two orbits)
        ncls = len({canon(to_binary(T, DIAG)) for T in trees})
        assert ncls == len(comps)
        smallest = min(sizes)
        assert smallest == 2 ** t
        assert sizes[smallest] % 2 == 1, "number of smallest orbits is even"
        assert val(C, 2) == t
        # the other reading (rows) gives a different partition with the same
        # size statistics
        rows_sizes = Counter()
        byclass = Counter(canon(to_binary(T, ROWS)) for T in trees)
        for c, n in byclass.items():
            rows_sizes[n] += 1
        assert rows_sizes == sizes
        print(f"{N:2d}  {m:5d}  {C:10d}  {val(C, 2):2d}  {t:9d}  {len(comps):7d}  "
              f"{dict(sorted(sizes.items()))}  {sizes[smallest]}")
    print("all assertions passed for N = 0 ..", Nmax)
    print()
    print("number theory only (no enumeration): v2(binom(4N,N)/(3N+1)) = s2(3N+1)-1")
    bad = [N for N in range(0, 3001)
           if val(fuss_catalan(4, N), 2) != digit_sum(3 * N + 1, 2) - 1]
    print("  quadtrees, N = 0..3000: failures:", bad)
    bad = [N for N in range(0, 3001)
           if val(fuss_catalan(8, N), 2) != digit_sum(7 * N + 1, 2) - 1]
    print("  octrees (q = 8), v2(binom(8N,N)/(7N+1)) = s2(7N+1)-1, N = 0..3000:"
          " failures:", bad)
    # the cube: its symmetry group on the 8 octants is NOT the local group
    def oct_perm(f):
        out = []
        for q in range(8):
            x, y, z = q & 1, (q >> 1) & 1, q >> 2
            x2, y2, z2 = f(x, y, z)
            out.append(x2 + 2 * y2 + 4 * z2)
        return tuple(out)
    cube = group_closure([oct_perm(lambda x, y, z: (1 - y, x, z)),
                          oct_perm(lambda x, y, z: (x, 1 - z, y)),
                          oct_perm(lambda x, y, z: (1 - x, y, z))])
    print("  symmetries of the cube on the 8 octants: order", len(cube),
          "; 2-part", 2 ** val(len(cube), 2),
          "; local group C2 wr C2 wr C2 has order 2^7 = 128")


# ----------------------------------------------------------------------------
# Triangle.  Child position i = corner i; rotation by 120 degrees: i -> i+1.
ROT120 = (1, 2, 0)


def check_triangle(Nmax):
    print("=" * 72)
    print("TRIANGLE (corner subdivision / Sierpinski refinement, p = 3)")
    print(" N  cells  #pictures  v3  t  #orbits  orbit sizes (size:count)"
          "  #smallest  predicted mod 3")
    for N in range(0, Nmax + 1):
        m = 2 * N + 1
        trees = ordered_trees(m, 3)
        C = fuss_catalan(3, N)
        assert len(trees) == C
        pics = {picture(T): T for T in trees}
        assert len(pics) == C
        comps = orbits(pics.keys(), [ROT120])
        t = t_of(m, 3)
        sizes = Counter()
        for comp in comps:
            cls = {canon(pics[P]) for P in comp}
            assert len(cls) == 1
            d = {d_sigma(pics[P])[0] for P in comp}
            assert len(d) == 1
            assert len(comp) == 3 ** d.pop()
            sizes[len(comp)] += 1
        assert len({canon(T) for T in trees}) == len(comps)
        smallest = min(sizes)
        assert smallest == 3 ** t
        # Fact 4: number of smallest orbits = (-1)^t / prod a_j!  (mod 3)
        prod_fact = 1
        for a in digits(m, 3):
            prod_fact *= factorial(a)
        pred = ((-1) ** t * pow(prod_fact, -1, 3)) % 3
        assert sizes[smallest] % 3 == pred
        assert val(C, 3) == t
        # C * prod a_j! = (-3)^t  mod 3^(t+1)
        assert (C * prod_fact - (-3) ** t) % 3 ** (t + 1) == 0
        print(f"{N:2d}  {m:5d}  {C:9d}  {val(C, 3):2d}  {t}  {len(comps):7d}  "
              f"{dict(sorted(sizes.items()))}  {sizes[smallest]}  {pred}")
    print("all assertions passed for N = 0 ..", Nmax)


def stacked_graph(T):
    """Edge set of the stacked triangulation coded by a ternary tree.
    Outer triangle 0, 1, 2 (labelled); each internal node puts a new vertex
    in its face and joins it to the three corners."""
    edges = {(0, 1), (0, 2), (1, 2)}
    counter = [3]

    def rec(T, a, b, c):
        if T == LEAF:
            return
        x = counter[0]
        counter[0] += 1
        for v in (a, b, c):
            edges.add((min(v, x), max(v, x)))
        rec(T[0], a, b, x)
        rec(T[1], b, c, x)
        rec(T[2], c, a, x)

    rec(T, 0, 1, 2)
    return edges, counter[0]


def rooted_canonical(edges, n):
    """Canonical form of a graph whose vertices 0,1,2 are fixed (the root
    triangle) and whose other vertices are unlabelled: brute force over all
    relabellings of the inner vertices."""
    best = None
    inner = list(range(3, n))
    for perm in permutations(inner):
        relabel = [0, 1, 2] + list(perm)
        e = tuple(sorted((min(relabel[a], relabel[b]), max(relabel[a], relabel[b]))
                         for a, b in edges))
        if best is None or e < best:
            best = e
    return best


def check_stacked(Nmax):
    print("=" * 72)
    print("STACKED TRIANGULATIONS (planar 3-trees with a labelled outer triangle)")
    print("count of pairwise non-isomorphic rooted graphs, by brute-force "
          "relabelling of inner vertices")
    print(" N  #non-isomorphic rooted graphs  binom(3N,N)/(2N+1)  v3  t")
    for N in range(0, Nmax + 1):
        m = 2 * N + 1
        trees = ordered_trees(m, 3)
        forms = set()
        for T in trees:
            edges, n = stacked_graph(T)
            assert n == N + 3 and len(edges) == 3 * N + 3
            forms.add(rooted_canonical(edges, n))
        C = fuss_catalan(3, N)
        assert len(forms) == C
        t = t_of(m, 3)
        assert val(C, 3) == t
        print(f"{N:2d}  {len(forms):29d}  {C:18d}  {val(C, 3):2d}  {t}")
    print("all assertions passed for N = 0 ..", Nmax)
    bad = [N for N in range(0, 3001)
           if 2 * val(fuss_catalan(3, N), 3) != digit_sum(2 * N + 1, 3) - 1]
    print("number theory only: v3(binom(3N,N)/(2N+1)) = (s3(2N+1)-1)/2, "
          "N = 0..3000: failures:", bad)


if __name__ == "__main__":
    check_square(6)
    check_triangle(7)
    check_stacked(6)

# Written by Claude Fable 5.2 (claude-fable-5-2), 2026-11-15. Not human-reviewed.
# Three small checks behind the outlook slide "From numbers to polynomials" (talk/ in this folder).
#   (a) P_n(x, y) = sum over q-ary plane trees with n internal nodes of x^height * y^(sum of leaf depths),
#       in full, for q = 3, n = 3 (the hand example of the slide) and q = 3, n = 6.
#   (b) The Gaussian binomial [n+m choose n]_x equals the sum over S-E paths in the n x m rectangle of
#       x^(boxes under the path), and the sum of the positions of the E-steps is (boxes above) + n(n-1)/2.
#   (c) Rotating a block of d consecutive steps by one step changes the number of boxes under the path
#       by -a modulo d, a = number of E-steps in the block.
# Run:  uv run python sunday_checks.py     (standard library only)
import itertools, random
from collections import Counter
from functools import lru_cache

# ---------- (a) trees: a tree is represented by the multiset of its leaf depths and its height
@lru_cache(None)
def trees(q, n):
    """Counter {(height, tuple of leaf depths sorted)}: plane q-ary trees with n internal nodes."""
    if n == 0:
        return Counter({(0, (0,)): 1})
    out = Counter()
    def rec(children_left, nodes_left, acc):
        if children_left == 0:
            if nodes_left == 0:
                yield acc
            return
        for j in range(nodes_left + 1):
            yield from rec(children_left - 1, nodes_left - j, acc + (j,))
    for split in rec(q, n - 1, ()):
        parts = [trees(q, j).items() for j in split]
        for combo in itertools.product(*parts):
            mult = 1; h = 0; depths = []
            for (hh, dd), c in combo:
                mult *= c; h = max(h, hh); depths.extend(d + 1 for d in dd)
            out[(h + 1, tuple(sorted(depths)))] += mult
    return out

def P(q, n):
    poly = Counter()
    for (h, depths), c in trees(q, n).items():
        poly[(h, sum(depths))] += c
    return dict(sorted(poly.items()))

def show(poly):
    return " + ".join(f"{c} x^{h} y^{l}" for (h, l), c in poly.items())

print("(a) P_n(x, y) in full")
p3 = P(3, 3)
print("   q=3 n=3:", show(p3), "  total", sum(p3.values()))
assert p3 == {(2, 13): 3, (3, 15): 9}
p6 = P(3, 6)
assert sum(p6.values()) == 1428 and len(p6) == 12
assert all(c % 3 == 0 for c in p6.values())
res = {k: c % 9 for k, c in p6.items() if c % 9}
print("   q=3 n=6:", len(p6), "monomials, total", sum(p6.values()), "; modulo 9:", show(res))
assert res == {(3, 34): 6}

# ---------- (b) Gaussian binomials and area
def gauss(N, n):
    """coefficients of [N choose n]_x by the x-Pascal rule [N,n] = [N-1,n-1] + x^n [N-1,n]"""
    @lru_cache(None)
    def g(N, n):
        if n < 0 or n > N: return ()
        if n == 0 or n == N: return (1,)
        a = g(N - 1, n - 1); b = g(N - 1, n)
        out = [0] * max(len(a), len(b) + n)
        for i, c in enumerate(a): out[i] += c
        for i, c in enumerate(b): out[i + n] += c
        return tuple(out)
    return list(g(N, n))

def under(w):   # boxes under the path: for each E-step, the number of S-steps after it
    s_after = w.count('S'); tot = 0
    for ch in w:
        if ch == 'S': s_after -= 1
        else: tot += s_after
    return tot

def above(w):   # boxes above the path: for each E-step, the number of S-steps before it
    s_before = 0; tot = 0
    for ch in w:
        if ch == 'S': s_before += 1
        else: tot += s_before
    return tot

cases = 0
for N in range(0, 9):
    for n in range(0, N + 1):
        m = N - n
        cu = [0] * (n * m + 1); ca = [0] * (n * m + 1)
        for pos in itertools.combinations(range(N), n):
            w = ['S'] * N
            for i in pos: w[i] = 'E'
            u, a = under(w), above(w)
            assert u + a == n * m
            assert sum(pos) == a + n * (n - 1) // 2
            cu[u] += 1; ca[a] += 1
        assert cu == gauss(N, n) == ca, (N, n)
        cases += 1
print(f"(b) Gaussian binomial = sum of x^(boxes under the path) = sum of x^(boxes above): {cases} pairs (N, n), N <= 8;"
      " sum of positions of E-steps = boxes above + n(n-1)/2 in every path")

# ---------- (c) rotation of a block
random.seed(137)
trials = 0
for _ in range(2000):
    N = random.randint(2, 30)
    w = [random.choice('ES') for _ in range(N)]
    d = random.randint(2, N); j = random.randint(0, N - d)
    block = w[j:j + d]; a = block.count('E')
    w2 = w[:j] + block[-1:] + block[:-1] + w[j + d:]      # every step of the block moves one place later
    assert (under(w2) - under(w) + a) % d == 0
    trials += 1
print(f"(c) rotating a block of d steps by one step changes the boxes under the path by -a mod d: {trials} random cases")
print("all assertions passed")

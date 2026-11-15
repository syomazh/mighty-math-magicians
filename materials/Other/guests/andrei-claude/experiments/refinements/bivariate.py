# Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.
# Run:  uv run python bivariate.py     (needs sympy for part 2)
# Bivariate probes.
# (1) P(x, y) = sum over q-ary trees with n internal nodes of x^height * y^(sum of the depths of the leaves), modulo p^(t+1).
# (2) F_N(x, y) = prod_{i<N} (1 + y x^i): product over the p sub-segments with twisted y, and F_{p^h} = 1 - (-y)^(p^h) mod Phi_{p^h}(x).
# (3) q,t-Catalan numbers (area, bounce) for n <= 6 and Fuss-Narayana numbers: are the coefficients divisible by p^t?
import math, itertools
from collections import defaultdict
from depth_refinement import profiles, digits

print("(1) height and leaf path length, q-ary trees, modulo p^(t+1)")
for (p, k, n) in [(3,1,3),(3,1,6),(2,1,6),(2,1,10),(2,2,4),(3,2,3),(5,1,4),(3,1,8)]:
    q = p**k; m = (q-1)*n + 1; t = (sum(digits(m, p)) - 1)//(p-1)
    P = defaultdict(int)
    for prof, c in profiles(q, n).items():
        P[(len(prof)-1, sum(D*l for D, l in enumerate(prof)))] += c
    assert all(c % p**t == 0 for c in P.values())
    res = {e: c % p**(t+1) for e, c in P.items() if c % p**(t+1)}
    s = " + ".join(f"{c} x^{e[0]} y^{e[1]}" for e, c in sorted(res.items()))
    print(f"   p={p} q={q} n={n}: C={sum(P.values())}, t={t}, {len(P)} monomials;  P = {s}   (mod {p**(t+1)})")

print("(2) F_N(x,y) = prod (1 + y x^i)")
from sympy import symbols, Poly, cyclotomic_poly, expand, rem
x, y = symbols('x y')
F = lambda N, yy=y: expand(math.prod((1 + yy*x**i) for i in range(N)))
for (p, h) in [(2,1),(2,2),(2,3),(3,1),(3,2),(5,1)]:
    lhs = F(p**h); rhs = expand(math.prod(F(p**(h-1), y*x**(j*p**(h-1))) for j in range(p)))
    assert expand(lhs - rhs) == 0
    r = rem(Poly(lhs, x), Poly(cyclotomic_poly(p**h, x), x))
    assert expand(r.as_expr() - (1 - (-y)**(p**h))) == 0
print("   product over sub-segments and reduction modulo Phi_{p^h}(x): ok for p^h in 2,4,8,3,9,5")

print("(3) coefficients of statistics that rotations do not preserve")
def dyck(n):
    def rec(path, up, down):
        if up == n and down == n: yield tuple(path); return
        if up < n: yield from rec(path + [1], up + 1, down)
        if down < up: yield from rec(path + [0], up, down + 1)
    yield from rec([], 0, 0)
def area_bounce(w):
    n = len(w)//2; h = 0; heights = []
    for s in w:
        if s == 1: heights.append(h); h += 1
        else: h -= 1
    area = sum(heights)                      # full cells between path and the lowest path
    # bounce: Haglund's bounce path
    ups = []; cnt = 0; cols = []
    # column heights: number of up-steps before each down-step
    u = 0
    for s in w:
        if s == 1: u += 1
        else: cols.append(u)
    pos, b = 0, 0
    while pos < n:
        pos = cols[pos]; 
        if pos < n: b += n - pos
    return area, b
for n in range(2, 7):
    C = defaultdict(int)
    for w in dyck(n):
        C[area_bounce(w)] += 1
    tot = sum(C.values()); sym = all(C[(a, b)] == C[(b, a)] for (a, b) in list(C))
    print(f"   n={n}: C_n={tot}, q,t-symmetric={sym}, coefficients range {min(C.values())}..{max(C.values())}, gcd of coefficients={math.gcd(*C.values())}")
for (q, n) in [(2,4),(2,6),(3,3),(3,6),(4,4)]:
    row = [math.comb(n, kk)*math.comb((q-1)*n, kk-1)//n for kk in range(1, n+1)]
    assert sum(row) == math.comb(q*n, n)//((q-1)*n+1)
    print(f"   Fuss-Narayana q={q} n={n}: {row}, gcd={math.gcd(*row)}")

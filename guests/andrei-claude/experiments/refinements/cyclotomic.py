# Written by Claude Fable 5.2 (claude-fable-5-2) in the Claude app (cloud session), started by Andrei, 2026-11-14. Not human-reviewed.
# x-binomials [N choose n]_x and the x-Fuss-Catalan polynomial C(x) = [N choose n]_x / [N]_x, N = qn+1:
# (1) the cyclotomic polynomial Phi_{p^i}(x) divides [N choose n]_x exactly c_i times, c_i = carry into digit i of n + m = N in base p;
# (2) the same holds for C(x), which is a polynomial with non-negative coefficients in the cases tested;
# (3) x-Lucas: [N choose n]_x = binom(N div d, n div d) * [N mod d choose n mod d]_x  modulo Phi_d(x), for d = p^i.
import math, sys
from sympy import symbols, Poly, cyclotomic_poly, prod, rem, div, ZZ
x = symbols('x')

def xint(k): return Poly(sum(x**i for i in range(k)), x, domain=ZZ) if k > 0 else Poly(0, x, domain=ZZ)
def xfact(k):
    r = Poly(1, x, domain=ZZ)
    for i in range(1, k+1): r = r * xint(i)
    return r
def xbinom(N, n):
    if n < 0 or n > N: return Poly(0, x, domain=ZZ)
    qq, rr = div(xfact(N), xfact(n) * xfact(N-n)); assert rr.is_zero; return qq
def mult(P, d):
    Phi = Poly(cyclotomic_poly(d, x), x, domain=ZZ); e = 0
    while True:
        qq, rr = div(P, Phi)
        if not rr.is_zero: return e
        P = qq; e += 1
def carries(n, m, p):
    c = [0]; i = 0
    while p**i <= n + m:
        c.append(((n % p**(i+1)) + (m % p**(i+1)) - ((n+m) % p**(i+1))) // p**(i+1)); i += 1
    return c

cnt = 0
for p in (2, 3, 5):
    for N in range(1, 19):
        for n in range(0, N+1):
            B = xbinom(N, n); c = carries(n, N-n, p)
            for i in range(1, len(c)):
                assert mult(B, p**i) == c[i], (p, N, n, i)
                d = p**i; Phi = Poly(cyclotomic_poly(d, x), x, domain=ZZ)
                lhs = rem(B, Phi); rhs = rem(xbinom(N % d, n % d) * math.comb(N//d, n//d), Phi)
                assert lhs == rhs, ("x-Lucas", p, N, n, i)
            cnt += 1
print("x-binomials: multiplicity of Phi_{p^i} = carry c_i, and x-Lucas mod Phi_{p^i}:", cnt, "cases")
for (p, k, n) in [(2,1,3),(2,1,6),(2,1,10),(3,1,3),(3,1,6),(3,1,8),(2,2,4),(3,2,2),(3,2,3),(5,1,4),(2,3,3)]:
    q = p**k; N = q*n + 1; m = N - n
    Cx, r = div(xbinom(N, n), xint(N)); assert r.is_zero
    assert Cx.eval(1) == math.comb(q*n, n)//m and min(Cx.all_coeffs()) >= 0
    c = carries(n, m, p); t = sum(c)
    fac = [i for i in range(1, len(c)) if c[i]]
    assert all(mult(Cx, p**i) == c[i] for i in range(1, len(c)))
    Q = Cx
    for i in fac: Q = div(Q, Poly(cyclotomic_poly(p**i, x), x, domain=ZZ))[0]
    md = [int(dg) for dg in reversed([ (m // p**j) % p for j in range(20) if p**j <= m])]
    rhs = (-1)**t * pow(math.prod(math.factorial((m // p**j) % p) for j in range(20)), -1, p) % p
    assert Q.eval(1) % p == rhs
    print(f"p={p} q={q} n={n}: C(x) has degree {Cx.degree()}, C(1)={Cx.eval(1)}, t={t}, C(x) = " + " ".join(f"Phi_{p**i}" for i in fac) + f" * Q(x), Q(1) mod p = {Q.eval(1) % p}")

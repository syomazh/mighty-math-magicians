# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
"""
E010 -- computer checks for every lemma of the Frobenius proof (paper/frobenius_proof.tex).

Setting. p prime, q = p^k. Lambda = Z[y][[x]], phi(f)(x, y) = f(x^p, y^p),
theta(f) = (f^p - phi(f)) / p.  The deformed system, for delta in Z/k:

    F_delta = [delta = 0] x + phi(F_{delta+1}) + y * theta(F_{delta+1}).

Weight of a monomial x^m y^d:  w = (p-1) d - s_p(m).

Checks (names follow the note):
  L2   F_0(x, p) = G, the Fuss-Catalan series (and every division by p is exact).
  L3   every monomial of every F_delta has weight >= -1.
  L4a  F_delta(x, 0) = alpha_delta = sum of x^(p^j) over j = -delta (mod k).
  L4b  the weight -1 coefficients l_delta(m) satisfy l_delta = alpha_delta + (1/p) * (carry-free
       p-th power of l_{delta+1}), computed literally with the carry-free product.
  H    the labelled system H_delta = z_{-delta} + H_{delta+1}^p / p in Q[[z_0..z_{k-1}]]:
       its Hurwitz coefficients T_delta(a) are integers.
  L5   l_delta(m) * prod m_j! = T_delta(a(m)),  a_c(m) = sum of the digits m_j with j = c (mod k).
  P7   carry operator: T_delta(b + p e_c) + T_delta(b + e_{c+1}) = 0 (mod p) for all b, c, delta.
  P8   T_0(a) = (-1)^t (mod p) if sum a_c p^c = 1 (mod q-1), and T_0(a) = 0 otherwise.
  H4   for random Hurwitz series f without constant term, in two variables:
       f^p / p is a Hurwitz series, and  d^p(f^p/p) - f^(p-1) d^p f + (df)^p  is in p * Hurwitz;
       and g^p - g_0^p is in p * Hurwitz for random g.
  THM  C * prod m_j! = (-p)^t (mod p^(t+1)).
  TREE (meaning, not used by the proof) the coefficient of x^m y^d in F_0 is the number of
       rotation classes with d asymmetric nodes, by brute-force enumeration (E000's Orbits).

The F-recursion code is the one of E003 (same author); everything else is new.
"""
import importlib.util
import itertools
import os
import random
import sys
import time
from fractions import Fraction
from math import comb, factorial, prod

HERE = os.path.dirname(os.path.abspath(__file__))


def digits(m, p):
    ds = []
    while m:
        ds.append(m % p)
        m //= p
    return ds


def sp(m, p):
    return sum(digits(m, p))


# ---------------------------------------------------------------------------------------------
# The deformed system F_delta (polynomials in y packed into one integer per x-coefficient)
# ---------------------------------------------------------------------------------------------
def solve_F(p, k, M):
    nmax = (M - 1) // (p - 1)
    B = p * (nmax + 2) + 32          # bits per y-coefficient; an upper bound on all counts
    mask = (1 << B) - 1
    F = [[0] * (M + 1) for _ in range(k)]
    P = [[[0] * (M + 1) for _ in range(p + 1)] for _ in range(k)]

    def unpack(X):
        out = []
        while X:
            out.append(X & mask)
            X >>= B
        return out

    def frob(X):                      # y -> y^p
        r = 0
        for d, c in enumerate(unpack(X)):
            if c:
                r |= c << (B * p * d)
        return r

    exact = True
    for m in range(1, M + 1):
        for delta in range(k):
            Fd, Pd = F[delta], P[delta]
            for j in range(2, p + 1):
                s = 0
                prev = Pd[j - 1]
                for a in range(1, m - (j - 1) + 1):
                    fa = Fd[a]
                    if fa:
                        pb = prev[m - a]
                        if pb:
                            s += fa * pb
                Pd[j][m] = s
        new = [0] * k
        for delta in range(k):
            src = (delta + 1) % k
            val = 1 if (delta == 0 and m == 1) else 0
            sym = frob(F[src][m // p]) if m % p == 0 else 0
            asym = P[src][p][m] - sym
            # exact division by p, coefficient by coefficient (signed: unpack both parts)
            a_un = unpack(P[src][p][m])
            s_un = unpack(sym)
            L = max(len(a_un), len(s_un))
            a_un += [0] * (L - len(a_un))
            s_un += [0] * (L - len(s_un))
            quo = 0
            for d in range(L):
                diff = a_un[d] - s_un[d]
                if diff % p:
                    exact = False
                quo += (diff // p) << (B * d)
            new[delta] = val + sym + (quo << B)
        for delta in range(k):
            F[delta][m] = new[delta]
            P[delta][1][m] = new[delta]
    return [[unpack(F[delta][m]) for m in range(M + 1)] for delta in range(k)], exact


# ---------------------------------------------------------------------------------------------
# Multivariate power series with Fraction coefficients, truncated at total degree S
# ---------------------------------------------------------------------------------------------
def smul(f, g, S):
    h = {}
    for a, fa in f.items():
        da = sum(a)
        for b, gb in g.items():
            if da + sum(b) > S:
                continue
            c = tuple(x + y for x, y in zip(a, b))
            h[c] = h.get(c, 0) + fa * gb
    return {c: v for c, v in h.items() if v != 0}


def spow(f, n, S, nvars):
    r = {tuple([0] * nvars): Fraction(1)}
    for _ in range(n):
        r = smul(r, f, S)
    return r


def sadd(f, g, cf=1, cg=1):
    h = {a: cf * v for a, v in f.items()}
    for a, v in g.items():
        h[a] = h.get(a, 0) + cg * v
    return {a: v for a, v in h.items() if v != 0}


def sder(f, c, times=1):
    """d/dz_c applied `times` times (ordinary power-series coefficients)."""
    for _ in range(times):
        h = {}
        for a, v in f.items():
            if a[c] == 0:
                continue
            b = list(a)
            b[c] -= 1
            h[tuple(b)] = v * a[c]
        f = h
    return f


def hurwitz(f):
    """Hurwitz coefficients f_a = (ordinary coefficient) * a!."""
    return {a: v * prod(factorial(x) for x in a) for a, v in f.items()}


def solve_H(p, k, S):
    e = lambda c: tuple(1 if i == c else 0 for i in range(k))
    H = [{e((-delta) % k): Fraction(1)} for delta in range(k)]
    while True:
        new = []
        for delta in range(k):
            pw = spow(H[(delta + 1) % k], p, S, k)
            new.append(sadd({e((-delta) % k): Fraction(1)}, pw, 1, Fraction(1, p)))
        if new == H:
            break
        H = new
    return [hurwitz(h) for h in H]


# ---------------------------------------------------------------------------------------------
def run_case(p, k, M, S, tree_n):
    q = p ** k
    res = {}
    t0 = time.time()
    F, exact = solve_F(p, k, M)
    spm = [0] + [sp(m, p) for m in range(1, M + 1)]

    # L2 ---------------------------------------------------------------------------------------
    ok = exact
    n_adm = 0
    for m in range(1, M + 1):
        total = sum(c * p ** d for d, c in enumerate(F[0][m]))
        if (m - 1) % (q - 1) == 0:
            n = (m - 1) // (q - 1)
            n_adm += 1
            ok &= total == comb(q * n, n) // ((q - 1) * n + 1)
        else:
            ok &= total == 0
    res["L2"] = ok

    # L3, L4a ----------------------------------------------------------------------------------
    ok3 = ok4a = True
    n_mon = 0
    for delta in range(k):
        for m in range(1, M + 1):
            poly = F[delta][m]
            for d, c in enumerate(poly):
                if c:
                    n_mon += 1
                    ok3 &= (p - 1) * d - spm[m] >= -1
            c0 = poly[0] if poly else 0
            is_atom = spm[m] == 1 and (len(digits(m, p)) - 1 + delta) % k == 0
            ok4a &= c0 == (1 if is_atom else 0)
    res["L3"], res["L4a"] = ok3, ok4a
    res["monomials"] = n_mon

    # leading coefficients l_delta(m): the coefficient of y^t(m), t(m) = (s_p(m)-1)/(p-1)
    lead = [[0] * (M + 1) for _ in range(k)]
    for delta in range(k):
        for m in range(1, M + 1):
            if (spm[m] - 1) % (p - 1) == 0:
                t = (spm[m] - 1) // (p - 1)
                poly = F[delta][m]
                lead[delta][m] = poly[t] if len(poly) > t else 0

    # L4b: carry-free p-th power, literally ----------------------------------------------------
    def cf_mul(f, g):
        h = [0] * (M + 1)
        for a in range(1, M + 1):
            if f[a]:
                for b in range(1, M + 1 - a):
                    if g[b] and spm[a] + spm[b] == spm[a + b]:      # no carry
                        h[a + b] += f[a] * g[b]
        return h

    ok4b = True
    for delta in range(k):
        src = lead[(delta + 1) % k]
        pw = src
        for _ in range(p - 1):
            pw = cf_mul(pw, src)
        for m in range(1, M + 1):
            is_atom = spm[m] == 1 and (len(digits(m, p)) - 1 + delta) % k == 0
            ok4b &= p * lead[delta][m] == p * (1 if is_atom else 0) + pw[m]
    res["L4b"] = ok4b

    # H: the labelled system ---------------------------------------------------------------------
    T = solve_H(p, k, S)
    okH = all(v.denominator == 1 for h in T for v in h.values())
    res["H"] = okH
    Ti = [{a: int(v) for a, v in h.items()} for h in T]

    # L5 -------------------------------------------------------------------------------------------
    ok5 = True
    n5 = 0
    for delta in range(k):
        for m in range(1, M + 1):
            if (spm[m] - 1) % (p - 1) or spm[m] > S:
                continue
            dg = digits(m, p)
            a = [0] * k
            for j, x in enumerate(dg):
                a[j % k] += x
            n5 += 1
            ok5 &= lead[delta][m] * prod(factorial(x) for x in dg) == Ti[delta].get(tuple(a), 0)
    res["L5"], res["L5_cases"] = ok5, n5

    # P7: carry operator ---------------------------------------------------------------------------
    ok7 = True
    n7 = 0
    for delta in range(k):
        for b in itertools.product(range(S + 1), repeat=k):
            if sum(b) + p > S:
                continue
            for c in range(k):
                up = list(b)
                up[c] += p
                nx = list(b)
                nx[(c + 1) % k] += 1
                n7 += 1
                ok7 &= (Ti[delta].get(tuple(up), 0) + Ti[delta].get(tuple(nx), 0)) % p == 0
    res["P7"], res["P7_cases"] = ok7, n7

    # P8: evaluation -------------------------------------------------------------------------------
    ok8 = True
    n8 = 0
    for a in itertools.product(range(S + 1), repeat=k):
        if not 1 <= sum(a) <= S:
            continue
        val = Ti[0].get(a, 0)
        if sum(x * p ** c for c, x in enumerate(a)) % (q - 1) == 1 % (q - 1):
            t = (sum(a) - 1) // (p - 1)
            n8 += 1
            ok8 &= (sum(a) - 1) % (p - 1) == 0 and (val - (-1) ** t) % p == 0
        else:
            ok8 &= val == 0
    res["P8"], res["P8_cases"] = ok8, n8

    # THM --------------------------------------------------------------------------------------------
    okT = True
    for m in range(1, M + 1, q - 1):
        n = (m - 1) // (q - 1)
        C = comb(q * n, n) // ((q - 1) * n + 1)
        dg = digits(m, p)
        t = (sum(dg) - 1) // (p - 1)
        okT &= (C * prod(factorial(x) for x in dg) - (-p) ** t) % p ** (t + 1) == 0
    res["THM"], res["THM_cases"] = okT, n_adm

    # TREE: brute-force rotation classes (meaning of F_0) ----------------------------------------
    spec = importlib.util.spec_from_file_location(
        "e000", os.path.join(HERE, "..", "E000_first_sanity_check", "check.py"))
    e000 = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(e000)
    orb = e000.Orbits(p, k)
    okTree = True
    for n in range(0, tree_n + 1):
        m = (q - 1) * n + 1
        if m > M:
            break
        hist = {}
        for oid, cnt in orb.build(n).items():
            d = orb.d[oid]
            okTree &= cnt == p ** d
            hist[d] = hist.get(d, 0) + 1
        poly = F[0][m]
        okTree &= hist == {d: c for d, c in enumerate(poly) if c}
    res["TREE"] = okTree
    res["sec"] = time.time() - t0
    return res


def check_H4(p, trials, seed):
    """Random Hurwitz polynomials in two variables; identities of the lemma on Hurwitz series."""
    rng = random.Random(seed)
    nv = 2
    ok = True
    deg = 3
    big = 10 ** 6            # no truncation: polynomials are multiplied exactly
    for _ in range(trials):
        f = {}
        for a in itertools.product(range(deg + 1), repeat=nv):
            if 1 <= sum(a) <= deg and rng.random() < 0.8:
                fa = rng.randint(-5, 5)
                if fa:
                    f[a] = Fraction(fa, prod(factorial(x) for x in a))
        if not f:
            continue
        fp = spow(f, p, big, nv)
        g = {a: v / p for a, v in fp.items()}
        ok &= all(v.denominator == 1 for v in hurwitz(g).values())                 # f^p/p Hurwitz
        for c in range(nv):
            lhs = sder(g, c, p)
            rhs = sadd(smul(spow(f, p - 1, big, nv), sder(f, c, p), big),
                       spow(sder(f, c, 1), p, big, nv), 1, -1)
            diff = hurwitz(sadd(lhs, rhs, 1, -1))
            ok &= all(v.denominator == 1 and v.numerator % p == 0 for v in diff.values())
        # Frobenius on Hurwitz series: g^p = g_0^p mod p
        g0 = rng.randint(-4, 4)
        gg = dict(f)
        gg[(0,) * nv] = Fraction(g0)
        gp = hurwitz(sadd(spow(gg, p, big, nv), {(0,) * nv: Fraction(g0 ** p)}, 1, -1))
        ok &= all(v.denominator == 1 and v.numerator % p == 0 for v in gp.values())
    return ok


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    cases = [  # (p, k, M leaves, S = max degree of the labelled system, n for the brute force)
        (2, 1, 100, 12, 9), (2, 2, 100, 10, 5), (2, 3, 99, 9, 3), (2, 4, 91, 8, 2),
        (3, 1, 91, 15, 6), (3, 2, 89, 13, 3), (3, 3, 79, 11, 2),
        (5, 1, 81, 21, 4), (5, 2, 73, 17, 2), (7, 1, 73, 25, 3), (11, 1, 61, 31, 2),
    ]
    names = ["L2", "L3", "L4a", "L4b", "H", "L5", "P7", "P8", "THM", "TREE"]
    print(f"{'p':>3} {'k':>2} {'M':>4} {'S':>3} " + " ".join(f"{x:>5}" for x in names)
          + f" {'monomials':>9} {'L5 cases':>8} {'P7 cases':>8} {'P8 cases':>8} {'THM cases':>9} {'sec':>5}")
    allok = True
    for p, k, M, S, tn in cases:
        r = run_case(p, k, M, S, tn)
        allok &= all(r[x] for x in names)
        print(f"{p:>3} {k:>2} {M:>4} {S:>3} " + " ".join(f"{'ok' if r[x] else 'FAIL':>5}" for x in names)
              + f" {r['monomials']:>9} {r['L5_cases']:>8} {r['P7_cases']:>8} {r['P8_cases']:>8} "
                f"{r['THM_cases']:>9} {r['sec']:>5.0f}")
        sys.stdout.flush()
    print()
    for p in (2, 3, 5, 7):
        ok = check_H4(p, 30 if p <= 5 else 8, seed=137 + p)
        allok &= ok
        print(f"H4 (Hurwitz identities), p = {p}: {'ok' if ok else 'FAIL'}")
        sys.stdout.flush()
    print("\nOVERALL:", "ALL CHECKS PASSED" if allok else "SOME CHECKS FAILED")

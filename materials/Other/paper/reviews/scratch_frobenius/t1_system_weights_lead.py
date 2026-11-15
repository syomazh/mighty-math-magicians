# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Referee check of paper/frobenius_proof.tex: Lemma (system), Lemma (lower bound), Corollary,
# Lemma (leading part) (i),(ii), and the Theorem, straight from the definitions.
# Run from the repository root:  uv run python paper/reviews/scratch_frobenius/t1_system_weights_lead.py
import sys
import time
from fractions import Fraction
from itertools import product
from math import factorial

from fz_lib import (carry_free, cfpow, compute_F, compute_G, digits, fuss_catalan, padd, peval,
                    pphi, psub, smul, sp, sphi, spow)

CASES = [  # (p, k, N, N_fixedpoint_check)
    (2, 1, 140, 70),
    (2, 2, 140, 70),
    (2, 3, 140, 60),
    (2, 4, 100, 50),
    (3, 1, 170, 90),
    (3, 2, 170, 90),
    (3, 3, 120, 60),
    (5, 1, 190, 130),
    (5, 2, 190, 130),
    (7, 1, 200, 110),
]
if len(sys.argv) > 1 and sys.argv[1] == "quick":
    CASES = [(p, k, min(N, 60), min(M, 40)) for (p, k, N, M) in CASES]
if len(sys.argv) > 1 and sys.argv[1] == "big":
    # F_delta is supported on m = p^(-delta) mod (q-1), so larger q allows much larger N
    CASES = [
        (2, 1, 260, 100),
        (2, 2, 520, 200),
        (2, 3, 800, 300),
        (2, 4, 1100, 400),
        (2, 5, 1300, 400),
        (3, 1, 420, 160),
        (3, 2, 900, 300),
        (3, 3, 1500, 500),
        (5, 1, 640, 250),
        (5, 2, 1900, 700),
        (5, 3, 3200, 700),
        (7, 1, 800, 350),
        (7, 2, 2500, 700),
        (11, 1, 1400, 400),
    ]

ok_all = True


def report(name, ok, extra=""):
    global ok_all
    ok_all = ok_all and ok
    print(f"   {'PASS' if ok else 'FAIL'}  {name} {extra}")


for (p, k, N, NF) in CASES:
    q = p ** k
    t0 = time.time()
    print(f"p={p} k={k} q={q} N={N}")
    F = compute_F(p, k, N)   # raises if theta is not integral

    # --- the system, re-verified with generic series multiplication (independent of the
    #     incremental recursion used to build F)
    ok = True
    for d in range(k):
        e = (d + 1) % k
        Fe = [F[e][m] if m <= NF else [] for m in range(NF + 1)]
        P = spow(Fe, p, NF)
        PH = sphi(Fe, p, NF)
        for m in range(NF + 1):
            diff = psub(P[m], PH[m])
            if any(c % p for c in diff):
                ok = False
            th = [c // p for c in diff]
            rhs = padd(PH[m], [0] + th if th else [])
            if d == 0 and m == 1:
                rhs = padd(rhs, [1])
            if rhs != F[d][m]:
                ok = False
    report("Lemma system: F satisfies (system) (generic multiplication)", ok, f"up to x-degree {NF}")

    # --- F_0(x,p) = G, and g_d = [d=0]x + g_{d+1}^p
    G = compute_G(q, N)
    g = [[peval(F[d][m], p) for m in range(N + 1)] for d in range(k)]
    report("Lemma system: F_0(x,p) = G", g[0] == G)
    # coefficients of G are the Fuss-Catalan numbers (closed formula used ONLY as a cross-check)
    ok = True
    for m in range(1, N + 1):
        if (m - 1) % (q - 1) == 0:
            ok = ok and G[m] == fuss_catalan(q, (m - 1) // (q - 1))
        else:
            ok = ok and G[m] == 0
    report("Statement: [x^m]G = binom(qn,n)/((q-1)n+1), zero off m=(q-1)n+1", ok)

    # --- Lemma lower: every monomial has weight >= -1 ; record whether -1 is attained
    ok = True
    minw = {}
    for d in range(k):
        for m in range(1, N + 1):
            for dd, c in enumerate(F[d][m]):
                if c != 0:
                    w = (p - 1) * dd - sp(m, p)
                    if w < -1:
                        ok = False
                        print("      weight violation", d, m, dd, c)
    report("Lemma lower: all monomials of all F_delta have weight >= -1", ok)

    # all coefficients non-negative? (not claimed; informational)
    nonneg = all(c >= 0 for d in range(k) for m in range(N + 1) for c in F[d][m])
    print(f"         (info) all coefficients of F_delta non-negative: {nonneg}")

    # --- Lemma lead (i): F_delta(x,0)
    ok = True
    for d in range(k):
        for m in range(0, N + 1):
            c0 = F[d][m][0] if F[d][m] else 0
            ds = digits(m, p)
            is_pow = (m >= 1 and sum(ds) == 1)
            j = len(ds) - 1
            want = 1 if (is_pow and (j + d) % k == 0) else 0
            if c0 != want:
                ok = False
    report("Lemma lead(i): F_delta(x,0) = sum_{j = -delta mod k} x^(p^j)", ok)

    # --- ell_delta and Lemma lead (ii), carry-free product computed literally
    ell = []
    for d in range(k):
        row = [0] * (N + 1)
        for m in range(1, N + 1):
            s = sp(m, p)
            if (s - 1) % (p - 1) == 0:
                dd = (s - 1) // (p - 1)
                row[m] = F[d][m][dd] if dd < len(F[d][m]) else 0
        ell.append(row)
    ok = True
    for d in range(k):
        e = (d + 1) % k
        pwr = cfpow(ell[e], p, N, p)
        for m in range(0, N + 1):
            ds = digits(m, p)
            alpha = 1 if (m >= 1 and sum(ds) == 1 and (len(ds) - 1 + d) % k == 0) else 0
            if Fraction(ell[d][m]) != alpha + Fraction(pwr[m], p):
                ok = False
                print("      lead(ii) violation", d, m)
    report("Lemma lead(ii): ell_d = alpha_d + (1/p) ell_{d+1}^{cf p} (all m<=N, all delta)", ok)

    # brute-force the p-fold carry-free power as a sum over p-tuples (small m), to make sure
    # the iterated binary product is what the note means
    MB = {2: 60, 3: 40, 5: 16, 7: 12}.get(p, 0)
    MB = min(MB, N)
    ok = True
    for d in range(k):
        pwr = cfpow(ell[d], p, MB, p)
        for m in range(0, MB + 1):
            tot = 0

            # enumerate compositions of m into p non-negative parts
            def comps(rem, r):
                if r == 1:
                    yield (rem,)
                    return
                for a in range(rem + 1):
                    for rest in comps(rem - a, r - 1):
                        yield (a,) + rest
            for tup in comps(m, p):
                if carry_free(tup, p):
                    pr = 1
                    for a in tup:
                        pr *= ell[d][a]
                        if pr == 0:
                            break
                    tot += pr
            if tot != pwr[m]:
                ok = False
    report("carry-free p-th power: iterated product == literal sum over carry-free p-tuples", ok, f"(m<={MB})")

    # --- Corollary + Theorem, read off F_0
    ok_cor = True
    ok_thm = True
    ok_ct = True
    nmax = (N - 1) // (q - 1)
    for n in range(0, nmax + 1):
        m = (q - 1) * n + 1
        s = sp(m, p)
        assert (s - 1) % (p - 1) == 0
        t = (s - 1) // (p - 1)
        coeffs = F[0][m]
        if any(c != 0 for c in coeffs[:t]):
            ok_cor = False
        C = G[m]
        if C % p ** t != 0:
            ok_cor = False
        prodfact = 1
        for dg in digits(m, p):
            prodfact *= factorial(dg)
        if (C * prodfact - (-p) ** t) % p ** (t + 1) != 0:
            ok_thm = False
            print("      THEOREM violation", n)
        ct = coeffs[t] if t < len(coeffs) else 0
        if ct != ell[0][m] or (C - ct * p ** t) % p ** (t + 1) != 0:
            ok_ct = False
    report("Corollary: y^t | [x^m]F_0 and p^t | C_n", ok_cor, f"(n<={nmax})")
    report("Proof of thm: C_n = ell_0(m) p^t mod p^(t+1)", ok_ct)
    report("Theorem: C_n * prod m_j! = (-p)^t mod p^(t+1)", ok_thm, f"(n<={nmax})")
    print(f"   [{time.time() - t0:.1f}s]")

print("ALL PASS" if ok_all else "SOME FAILED")

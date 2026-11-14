# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Referee check of paper/frobenius_proof.tex, Lemma subst at larger sizes:
#     ell_delta(m) * prod_j m_j!  ==  T_delta(a(m))      for ALL m <= N and ALL delta,
# with ell from F_delta (eq. (system)) and T from H_delta (eq. (H)), both computed from scratch.
# Also the final assembly of the proof of the Theorem, done exactly as the note does it:
#     C_n prod m_j!  =  p^t T_0(a(m))  mod p^(t+1),   T_0(a(m)) = (-1)^t mod p.
# Run from the repository root:  uv run python paper/reviews/scratch_frobenius/t6_subst_bigger.py
import time
from math import factorial

from fz_lib import T_of, compute_F, compute_G, compute_H, digits, peval

ok_all = True
for (p, k, N) in [(2, 1, 200), (2, 2, 520), (2, 3, 800), (2, 4, 1100), (3, 1, 330), (3, 2, 900), (3, 3, 1500),
                  (5, 1, 640), (5, 2, 1900), (7, 1, 800), (7, 2, 2000), (11, 1, 1400)]:
    q = p ** k
    t0 = time.time()
    D = max(sum(digits(m, p)) for m in range(1, N + 1))
    H = compute_H(p, k, D)
    F = compute_F(p, k, N)
    ok = True
    nonzero = 0
    for d in range(k):
        for m in range(1, N + 1):
            ds = digits(m, p)
            s = sum(ds)
            ell = 0
            if (s - 1) % (p - 1) == 0:
                dd = (s - 1) // (p - 1)
                ell = F[d][m][dd] if dd < len(F[d][m]) else 0
            am = [0] * k
            for j, dg in enumerate(ds):
                am[j % k] += dg
            pf = 1
            for dg in ds:
                pf *= factorial(dg)
            if ell:
                nonzero += 1
            if ell * pf != T_of(H[d], am):
                ok = False
                print("      subst violation", p, k, d, m)
    # final assembly
    ok2 = True
    for n in range(0, (N - 1) // (q - 1) + 1):
        m = (q - 1) * n + 1
        ds = digits(m, p)
        t = (sum(ds) - 1) // (p - 1)
        am = [0] * k
        for j, dg in enumerate(ds):
            am[j % k] += dg
        pf = 1
        for dg in ds:
            pf *= factorial(dg)
        T0 = T_of(H[0], am)
        C = peval(F[0][m], p)
        if T0.denominator != 1 or (T0.numerator - (-1) ** t) % p != 0:
            ok2 = False
        if (C * pf - p ** t * T0.numerator) % p ** (t + 1) != 0:
            ok2 = False
    ok_all = ok_all and ok and ok2
    print(f"   {'PASS' if ok else 'FAIL'}  p={p} k={k} q={q}: Lemma subst for all m<={N}, all delta "
          f"(D={D}; {nonzero} non-zero values of ell)   final assembly: {'PASS' if ok2 else 'FAIL'}"
          f"   [{time.time() - t0:.1f}s]")
print("ALL PASS" if ok_all else "SOME FAILED")

# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Referee check of the Theorem of paper/frobenius_proof.tex for large n.
# Part A: C_n from the literal recursion G = x + G^q (no closed formula), moderately large n.
# Part B: C_n from binom(qn,n)/((q-1)n+1) (used here only as a fast way to reach large n; it is
#         cross-checked against the recursion in Part A), n up to a few thousand.
# Run from the repository root:  uv run python paper/reviews/scratch_frobenius/t4_theorem_large.py
import time
from math import factorial

from fz_lib import compute_G, digits, fuss_catalan, sp

ok_all = True


def check(p, q, n, C):
    m = (q - 1) * n + 1
    ds = digits(m, p)
    s = sum(ds)
    if (s - 1) % (p - 1) != 0:
        return False
    t = (s - 1) // (p - 1)
    pf = 1
    for d in ds:
        pf *= factorial(d)
    if pf % p == 0:
        return False
    if (C * pf - (-p) ** t) % p ** (t + 1) != 0:
        return False
    # "in particular": v_p(C) = t
    if C % p ** t != 0 or (C // p ** t) % p == 0:
        return False
    # and C/p^t = (-1)^t / prod m_j!  (mod p)
    if ((C // p ** t) * pf - (-1) ** t) % p != 0:
        return False
    return True


print("Part A: recursion G = x + G^q")
for (p, k, nmax) in [(2, 1, 400), (2, 2, 200), (2, 3, 120), (2, 4, 80), (2, 5, 50), (3, 1, 250), (3, 2, 120),
                     (3, 3, 50), (5, 1, 150), (5, 2, 50), (5, 3, 12), (7, 1, 120), (7, 2, 25), (11, 1, 80),
                     (13, 1, 60)]:
    q = p ** k
    t0 = time.time()
    N = (q - 1) * nmax + 1
    G = compute_G(q, N)
    ok = True
    okf = True
    for m in range(1, N + 1):
        if (m - 1) % (q - 1):
            okf = okf and G[m] == 0
        else:
            n = (m - 1) // (q - 1)
            okf = okf and G[m] == fuss_catalan(q, n)
            ok = ok and check(p, q, n, G[m])
    ok_all = ok_all and ok and okf
    print(f"   {'PASS' if ok else 'FAIL'}  p={p} k={k} q={q}: theorem for n<={nmax};"
          f" G matches closed formula: {okf}   [{time.time() - t0:.1f}s]")

print("Part B: closed formula, large n")
for (p, k, nmax) in [(2, 1, 6000), (2, 2, 4000), (2, 3, 3000), (2, 4, 2000), (2, 5, 1500), (2, 6, 1000),
                     (3, 1, 5000), (3, 2, 3000), (3, 3, 1500), (3, 4, 800), (5, 1, 4000), (5, 2, 2000),
                     (5, 3, 600), (7, 1, 3000), (7, 2, 1200), (11, 1, 2500), (11, 2, 500), (13, 1, 2000),
                     (17, 1, 1500)]:
    q = p ** k
    t0 = time.time()
    bad = [n for n in range(0, nmax + 1) if not check(p, q, n, fuss_catalan(q, n))]
    ok_all = ok_all and not bad
    print(f"   {'PASS' if not bad else 'FAIL'}  p={p} k={k} q={q}: theorem for all n<={nmax}"
          f"  {bad[:5] if bad else ''}   [{time.time() - t0:.1f}s]")

# teeth: the statement with q NOT a power of p (e.g. p=2, q=3 or p=3, q=2) should fail somewhere
for (p, q) in [(2, 3), (3, 2), (2, 6), (3, 4)]:
    bad = [n for n in range(0, 200) if not check(p, q, n, fuss_catalan(q, n))]
    print(f"   teeth: p={p}, q={q} (not a power of p): formula fails for {len(bad)} of 200 values of n")

print("ALL PASS" if ok_all else "SOME FAILED")

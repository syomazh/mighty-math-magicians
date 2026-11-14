# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Referee check of paper/frobenius_proof.tex, Section 6:
#   Lemma H (existence), Lemma subst, Lemma hur (i)-(iv) on random Hurwitz series,
#   Proposition carry (integrality + congruence, all delta, c, b), Proposition eval.
# Run from the repository root:  uv run python paper/reviews/scratch_frobenius/t2_hurwitz_carry_eval.py
import random
import sys
import time
from fractions import Fraction
from itertools import product
from math import factorial

from fz_lib import (T_of, afact, carry_free, cfpow, cfprod, compute_F, compute_H, digits, madd,
                    mderiv, mmul, mpow, mscale, sp, unit)

random.seed(20261114)
ok_all = True


def report(name, ok, extra=""):
    global ok_all
    ok_all = ok_all and ok
    print(f"   {'PASS' if ok else 'FAIL'}  {name} {extra}")


def all_exps(k, D, dmin=0):
    """all a in N^k with dmin <= |a| <= D"""
    def rec(i, rem):
        if i == k - 1:
            for x in range(rem + 1):
                yield (x,)
            return
        for x in range(rem + 1):
            for rest in rec(i + 1, rem - x):
                yield (x,) + rest
    for a in rec(0, D):
        if sum(a) >= dmin:
            yield a


def in_pHur(S, p, D):
    """is the (truncated) series S in p*Hur, looking at degrees <= D ?"""
    for a, v in S.items():
        if sum(a) > D:
            continue
        t = v * afact(a)
        if t.denominator != 1 or t.numerator % p != 0:
            return False
    return True


def in_Hur(S, D):
    for a, v in S.items():
        if sum(a) > D:
            continue
        if (v * afact(a)).denominator != 1:
            return False
    return True


QUICK = len(sys.argv) > 1 and sys.argv[1] == "quick"

# ------------------------------------------------------------------ Lemma hur on random series
print("Lemma hur (random Hurwitz series with integer coefficients in [-6,6])")
for (p, k, D) in [(2, 1, 14), (2, 2, 9), (2, 3, 7), (3, 1, 14), (3, 2, 10), (3, 3, 7), (5, 1, 16), (5, 2, 11), (7, 1, 16)]:
    if QUICK:
        D = min(D, 8)
    ok2 = ok3 = ok4a = ok4b = ok1 = True
    for trial in range(3):
        f = {}
        g = {}
        for a in all_exps(k, D):
            ca = random.randint(-6, 6)
            cb = random.randint(-6, 6)
            if sum(a) > 0 and ca:
                f[a] = Fraction(ca, afact(a))
            if cb:
                g[a] = Fraction(cb, afact(a))
        zero = tuple([0] * k)
        g0 = g.get(zero, Fraction(0))
        # (i) product and derivative stay in Hur
        ok1 = ok1 and in_Hur(mmul(f, g, D), D) and all(in_Hur(mderiv(g, c, k), D - 1) for c in range(k))
        # (ii)
        fp = mpow(f, p, D, k)
        ok2 = ok2 and in_pHur(fp, p, D)
        # (iii)
        gp = mpow(g, p, D, k)
        ok3 = ok3 and in_pHur(madd(gp, {zero: -g0}), p, D)
        # (iv)
        h = mscale(fp, Fraction(1, p))
        fpm1 = mpow(f, p - 1, D, k)
        for c in range(k):
            lhs = mderiv(h, c, k)
            rhs = mmul(fpm1, mderiv(f, c, k), D - 1)
            lhs = {a: v for a, v in lhs.items() if sum(a) <= D - 1}
            ok4a = ok4a and lhs == rhs
            lhs = mderiv(h, c, k, times=p)                      # exact up to degree D-p
            dpf = mderiv(f, c, k, times=p)                      # exact up to degree D-p
            t1 = mmul(fpm1, dpf, D - p)
            t2 = mpow(mderiv(f, c, k), p, D - p, k)             # (d f)^p: d f exact up to D-1
            diff = madd(madd(lhs, mscale(t1, -1)), t2)
            diff = {a: v for a, v in diff.items() if sum(a) <= D - p}
            ok4b = ok4b and in_pHur(diff, p, D - p)
    report(f"p={p} k={k} D={D}: (i) ring/derivative", ok1)
    report(f"p={p} k={k} D={D}: (ii) f^p in p Hur", ok2)
    report(f"p={p} k={k} D={D}: (iii) g^p = g_0 mod p Hur", ok3)
    report(f"p={p} k={k} D={D}: (iv) d(f^p/p) = f^(p-1) df", ok4a)
    report(f"p={p} k={k} D={D}: (iv) d^p(f^p/p) = f^(p-1) d^p f - (df)^p mod p Hur", ok4b)

# teeth: the congruence in (iv) with the wrong sign must fail for odd p
p, k, D = 3, 1, 10
f = {(a,): Fraction(random.randint(1, 5), factorial(a)) for a in range(1, D + 1)}
h = mscale(mpow(f, p, D, k), Fraction(1, p))
lhs = mderiv(h, 0, k, times=p)
t1 = mmul(mpow(f, p - 1, D, k), mderiv(f, 0, k, times=p), D - p)
t2 = mpow(mderiv(f, 0, k), p, D - p, k)
diff_wrong = madd(madd(lhs, mscale(t1, -1)), mscale(t2, -1))
diff_wrong = {a: v for a, v in diff_wrong.items() if sum(a) <= D - p}
print("   teeth: (iv) with +(df)^p instead of -(df)^p holds mod 3?", in_pHur(diff_wrong, p, D - p), "(should be False)")

# ------------------------------------------------------------------ H_delta, carry, eval, subst
CASES = [  # (p, k, D, N for Lemma subst)
    (2, 1, 40, 140),
    (2, 2, 20, 140),
    (2, 3, 13, 140),
    (2, 4, 10, 100),
    (3, 1, 41, 170),
    (3, 2, 21, 170),
    (3, 3, 13, 120),
    (5, 1, 41, 190),
    (5, 2, 21, 190),
    (5, 3, 13, 0),
    (7, 1, 43, 200),
    (7, 2, 19, 0),
]
if QUICK:
    CASES = [(p, k, min(D, 9), min(N, 40)) for (p, k, D, N) in CASES]

for (p, k, D, N) in CASES:
    q = p ** k
    t0 = time.time()
    print(f"p={p} k={k} q={q}: H_delta up to total degree {D}")
    H = compute_H(p, k, D)
    # double-check the fixed point equation once more, at full truncation
    ok = True
    for d in range(k):
        rhs = madd({unit(-d, k): Fraction(1)}, mscale(mpow(H[(d + 1) % k], p, D, k), Fraction(1, p)))
        ok = ok and rhs == H[d]
        zero = tuple([0] * k)
        ok = ok and zero not in H[d]
    report("Lemma H: fixed point of (H), no constant term", ok)

    # integrality
    ok = all(in_Hur(H[d], D) for d in range(k))
    report("Prop carry: all T_delta(a) are integers", ok, f"(|a|<={D})")

    # support: degrees = 1 mod (p-1) (informational)
    supp_ok = all((sum(a) - 1) % (p - 1) == 0 for d in range(k) for a in H[d])
    print(f"         (info) H_delta supported in degrees = 1 mod (p-1): {supp_ok}")

    # carry congruence for all delta, c, b
    ok = True
    cnt = 0
    for d in range(k):
        for c in range(k):
            for b in all_exps(k, D - p):
                a1 = list(b)
                a1[c] += p
                a2 = list(b)
                a2[(c + 1) % k] += 1
                v = T_of(H[d], a1) + T_of(H[d], a2)
                cnt += 1
                if v.denominator != 1 or v.numerator % p != 0:
                    ok = False
                    print("      carry violation", d, c, b)
    report("Prop carry: T_d(b+p e_c) + T_d(b+e_{c+1}) = 0 mod p, all delta,c,b", ok, f"({cnt} triples)")

    # Evaluation
    ok = True
    cnt = 0
    other = {}
    for a in all_exps(k, D, dmin=1):
        val = sum(a[c] * p ** c for c in range(k))
        T0 = T_of(H[0], a)
        if (val - 1) % (q - 1) == 0:
            cnt += 1
            if (sum(a) - 1) % (p - 1) != 0:
                ok = False
                continue
            sign = (-1) ** ((sum(a) - 1) // (p - 1))
            if T0.denominator != 1 or (T0.numerator - sign) % p != 0:
                ok = False
                print("      eval violation", a, T0)
        else:
            r = T0.numerator % p if T0.denominator == 1 else None
            other[r] = other.get(r, 0) + 1
    report("Prop eval: T_0(a) = (-1)^((|a|-1)/(p-1)) mod p under the hypothesis", ok, f"({cnt} vectors a)")
    print(f"         (info) residues of T_0(a) mod p when the hypothesis FAILS: {other}")

    # Lemma subst:  ell_delta(m) prod m_j! = T_delta(a(m))  for all m <= N, all delta
    if N:
        F = compute_F(p, k, N)
        ok = True
        skipped = 0
        for d in range(k):
            for m in range(1, N + 1):
                ds = digits(m, p)
                s = sum(ds)
                if s > D:
                    skipped += 1
                    continue
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
                if ell * pf != T_of(H[d], am):
                    ok = False
                    print("      subst violation", d, m)
        report("Lemma subst: ell_d(m) prod m_j! = T_d(a(m)), all m<=N, all delta", ok,
               f"(N={N}, skipped {skipped} with s_p(m)>D)")
    print(f"   [{time.time() - t0:.1f}s]")

# ------------------------------------------------------------------ the evaluation of u^{cf a}/a! at m (literal)
print("Lemma subst, second half: (u^{cf a}/a!)(m) = [a=a(m)] / prod m_j!  (literal carry-free products)")
for (p, k, M, AD) in [(2, 1, 40, 6), (2, 2, 40, 6), (2, 3, 40, 5), (3, 1, 60, 7), (3, 2, 60, 6), (5, 1, 60, 6), (5, 2, 60, 5)]:
    if QUICK:
        M = min(M, 30)
        AD = min(AD, 4)
    u = []
    for c in range(k):
        row = [0] * (M + 1)
        j = 0
        while p ** j <= M:
            if j % k == c:
                row[p ** j] = 1
            j += 1
        u.append(row)
    ok = True
    for a in all_exps(k, AD):
        h = [0] * (M + 1)
        h[0] = 1
        for c in range(k):
            for _ in range(a[c]):
                h = cfprod(h, u[c], M, p)
        for m in range(0, M + 1):
            ds = digits(m, p)
            am = [0] * k
            for j, dg in enumerate(ds):
                am[j % k] += dg
            pf = 1
            for dg in ds:
                pf *= factorial(dg)
            want = Fraction(1, pf) if tuple(am) == a else Fraction(0)
            if Fraction(h[m], afact(a)) != want:
                ok = False
                print("      violation", p, k, a, m)
    report(f"p={p} k={k}: all |a|<={AD}, all m<={M}", ok)

print("ALL PASS" if ok_all else "SOME FAILED")

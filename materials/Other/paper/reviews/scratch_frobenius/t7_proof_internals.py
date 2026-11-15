# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Referee check of small facts used INSIDE the proofs of paper/frobenius_proof.tex:
#   - Lemma hur(ii): p | (pb)!/(b!)^p for b >= 1, via binom(pb,b) = p binom(pb-1,b-1)
#   - Lemma hur(iv): the classification of the tuples (n_1..n_p), sum p, and the claim that the
#     "other" tuples contribute an element of p^2 Hur
#   - Proposition eval: the reduction a -> a' = a - p e_c + e_{c+1} terminates at e_0 exactly for
#     the vectors satisfying the hypothesis, whichever c is chosen at each step
#   - Lemma lead(ii): in F_{delta+1}, y * mu^p never has weight -1; phi(mu) has weight -1 only for
#     mu = x^(p^j)
# Run from the repository root:  uv run python paper/reviews/scratch_frobenius/t7_proof_internals.py
import random
from fractions import Fraction
from itertools import product
from math import comb, factorial

from fz_lib import afact, compute_F, madd, mderiv, mmul, mpow, mscale, sp

random.seed(7)
ok_all = True


def report(name, ok, extra=""):
    global ok_all
    ok_all = ok_all and ok
    print(f"   {'PASS' if ok else 'FAIL'}  {name} {extra}")


# ---- hur(ii)
ok = True
for p in (2, 3, 5, 7, 11, 13):
    for b in range(1, 120):
        v = factorial(p * b) // factorial(b) ** p
        if v * factorial(b) ** p != factorial(p * b) or v % p != 0:
            ok = False
        if comb(p * b, b) != p * comb(p * b - 1, b - 1):
            ok = False
        if v != comb(p * b, b) * (factorial((p - 1) * b) // factorial(b) ** (p - 1)):
            ok = False
report("hur(ii): (pb)!/(b!)^p is an integer divisible by p; the two displayed identities", ok)

# ---- hur(iv): tuple classification
for p in (2, 3, 5, 7):
    ok = True
    n_one_p = n_all1 = n_other = 0
    for tup in product(range(p + 1), repeat=p):
        if sum(tup) != p:
            continue
        coef = factorial(p)
        for n in tup:
            coef //= factorial(n)
        if max(tup) == p:
            n_one_p += 1
            ok = ok and coef == 1
        elif all(n == 1 for n in tup):
            n_all1 += 1
            ok = ok and coef == factorial(p)
        else:
            n_other += 1
            ok = ok and coef % p == 0 and len(set(tup)) > 1 and max(tup) <= p - 1
            orbit = {tup[i:] + tup[:i] for i in range(p)}
            ok = ok and len(orbit) == p
    ok = ok and n_one_p == p and n_all1 == 1
    report(f"hur(iv) p={p}: {n_one_p} tuples with an entry p, 1 tuple (1..1), {n_other} others (all with p | coefficient, orbit size p)", ok)


def in_mHur(S, mod, D):
    for a, v in S.items():
        if sum(a) > D:
            continue
        t = v * afact(a)
        if t.denominator != 1 or t.numerator % mod != 0:
            return False
    return True


for (p, k, D) in [(2, 1, 14), (3, 1, 15), (5, 1, 17), (2, 2, 9), (3, 2, 10), (7, 1, 17)]:
    ok = True
    for trial in range(3):
        f = {}

        def rec(i, rem, cur):
            if i == k:
                if sum(cur) > 0:
                    c = random.randint(-5, 5)
                    if c:
                        f[tuple(cur)] = Fraction(c, afact(cur))
                return
            for x in range(rem + 1):
                rec(i + 1, rem - x, cur + [x])
        rec(0, D, [])
        for c in range(k):
            lhs = mderiv(mpow(f, p, D, k), c, k, times=p)
            t1 = mscale(mmul(mpow(f, p - 1, D, k), mderiv(f, c, k, times=p), D - p), p)
            t2 = mscale(mpow(mderiv(f, c, k), p, D - p, k), factorial(p))
            diff = madd(madd(lhs, mscale(t1, -1)), mscale(t2, -1))
            diff = {a: v for a, v in diff.items() if sum(a) <= D - p}
            ok = ok and in_mHur(diff, p * p, D - p)
    report(f"hur(iv) p={p} k={k}: d^p(f^p) - p f^(p-1) d^p f - p! (df)^p  lies in p^2 Hur (random f)", ok)

# ---- Proposition eval: the reduction, with a random choice of c at each step
for (p, k, R) in [(2, 1, 60), (2, 2, 40), (2, 3, 25), (3, 1, 60), (3, 2, 40), (3, 3, 20), (5, 1, 80), (5, 2, 40), (7, 2, 40)]:
    q = p ** k
    ok = True
    for _ in range(3000):
        a = [random.randint(0, R) for _ in range(k)]
        if sum(a) == 0:
            continue
        hyp = (sum(a[c] * p ** c for c in range(k)) - 1) % (q - 1) == 0
        steps = 0
        size0 = sum(a)
        while any(x >= p for x in a):
            c = random.choice([c for c in range(k) if a[c] >= p])
            a[c] -= p
            a[(c + 1) % k] += 1
            steps += 1
            if min(a) < 0 or sum(a) < 1:
                ok = False
        ends_e0 = (a == [1] + [0] * (k - 1))
        if ends_e0 != hyp:
            ok = False
        if hyp and steps != (size0 - 1) // (p - 1):
            ok = False
    report(f"eval p={p} k={k}: carries end at e_0 iff the hypothesis holds; number of carries = (|a|-1)/(p-1)", ok)

# ---- Lemma lead(ii): internals on the actual F
for (p, k, N) in [(2, 1, 120), (2, 2, 200), (3, 1, 150), (3, 2, 250), (5, 1, 200), (2, 3, 250)]:
    F = compute_F(p, k, N)
    ok = True
    for d in range(k):
        for m in range(1, N + 1):
            for dd, c in enumerate(F[d][m]):
                if not c:
                    continue
                w = (p - 1) * dd - sp(m, p)
                # y * mu^p
                w_ymup = (p - 1) * (1 + p * dd) - sp(p * m, p)
                if w_ymup <= -1:
                    ok = False
                # phi(mu)
                w_phi = (p - 1) * p * dd - sp(p * m, p)
                if (w_phi == -1) != (dd == 0 and sp(m, p) == 1):
                    ok = False
    report(f"lead(ii) p={p} k={k}: y mu^p never has weight -1; phi(mu) has weight -1 iff mu = x^(p^j)  (monomials of F, m<={N})", ok)

print("ALL PASS" if ok_all else "SOME FAILED")

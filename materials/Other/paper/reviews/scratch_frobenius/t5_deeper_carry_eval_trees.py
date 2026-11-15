# Written by Claude Fable 5.2 (AI, fresh-context referee subagent), 2026-11-14.
# Referee check of paper/frobenius_proof.tex, deeper runs:
#  (a) Proposition carry / Proposition eval at larger total degree, counting the NON-TRIVIAL
#      instances (those where a T-value is non-zero), and testing the weighted-homogeneity
#      observation "T_delta(a) != 0 only if sum a_c p^c = p^(-delta) mod (q-1)" (not in the note).
#  (b) the intermediate congruence  E H_delta = H_{delta+1}^{p-1} E H_{delta+1}  (mod p Hur)
#      from the proof of Proposition carry, and the three displayed congruences before it.
#  (c) Section 8 (not used in the proof): classes of trees under rotation versus [x^m y^d]F_delta.
# Run from the repository root:  uv run python paper/reviews/scratch_frobenius/t5_deeper_carry_eval_trees.py
import time
from fractions import Fraction

from fz_lib import (T_of, afact, compute_F, compute_H, madd, mderiv, mmul, mpow, mscale, unit)

ok_all = True


def report(name, ok, extra=""):
    global ok_all
    ok_all = ok_all and ok
    print(f"   {'PASS' if ok else 'FAIL'}  {name} {extra}")


def all_exps(k, D, dmin=0):
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
    for a, v in S.items():
        if sum(a) > D:
            continue
        t = v * afact(a)
        if t.denominator != 1 or t.numerator % p != 0:
            return False
    return True


print("(a) deeper carry / eval")
for (p, k, D) in [(2, 1, 150), (2, 2, 44), (2, 3, 24), (2, 4, 16), (2, 5, 12),
                  (3, 1, 151), (3, 2, 45), (3, 3, 25), (3, 4, 15),
                  (5, 1, 161), (5, 2, 49), (5, 3, 25),
                  (7, 1, 163), (7, 2, 49), (11, 1, 171), (11, 2, 41), (13, 1, 181)]:
    q = p ** k
    t0 = time.time()
    H = compute_H(p, k, D)
    okI = all((v * afact(a)).denominator == 1 for d in range(k) for a, v in H[d].items())
    # weighted homogeneity (informational, not claimed in the note)
    mod = q - 1
    okW = True
    for d in range(k):
        for a in H[d]:
            val = sum(a[c] * p ** c for c in range(k))
            if mod > 1 and (val - p ** ((-d) % k)) % mod != 0:
                okW = False
    okC = True
    nontriv = 0
    tot = 0
    for d in range(k):
        for c in range(k):
            for b in all_exps(k, D - p):
                a1 = list(b)
                a1[c] += p
                a2 = list(b)
                a2[(c + 1) % k] += 1
                t1 = T_of(H[d], a1)
                t2 = T_of(H[d], a2)
                tot += 1
                if t1 != 0 or t2 != 0:
                    nontriv += 1
                v = t1 + t2
                if v.denominator != 1 or v.numerator % p != 0:
                    okC = False
    okE = True
    cnt = 0
    for a in all_exps(k, D, dmin=1):
        val = sum(a[c] * p ** c for c in range(k))
        if (val - 1) % (q - 1) == 0:
            cnt += 1
            T0 = T_of(H[0], a)
            if (sum(a) - 1) % (p - 1) != 0:
                okE = False
                continue
            sign = (-1) ** ((sum(a) - 1) // (p - 1))
            if T0.denominator != 1 or (T0.numerator - sign) % p != 0:
                okE = False
                print("      eval violation", a)
    print(f" p={p} k={k} q={q} D={D}   [{time.time() - t0:.1f}s]")
    report("integrality of all T_delta(a)", okI)
    report("carry congruence, all delta,c,b", okC, f"({tot} triples, {nontriv} non-trivial)")
    report("evaluation T_0(a) = (-1)^((|a|-1)/(p-1)) mod p", okE, f"({cnt} vectors a satisfy the hypothesis)")
    print(f"         (info) T_delta(a) != 0 only when sum a_c p^c = p^(-delta) mod (q-1): {okW}")

print("(b) the displayed congruences inside the proof of Proposition carry")
for (p, k, D) in [(2, 1, 30), (2, 2, 18), (2, 3, 12), (3, 1, 31), (3, 2, 19), (3, 3, 13), (5, 1, 33), (5, 2, 21)]:
    H = compute_H(p, k, D)
    ok1 = ok2 = ok3 = True
    for d in range(k):
        Hn = H[(d + 1) % k]
        Hpm1 = mpow(Hn, p - 1, D, k)
        for c in range(k):
            c1 = (c + 1) % k
            # first display: exact identity, valid up to degree D-1
            lhs = mderiv(H[d], c1, k)
            rhs = mmul(Hpm1, mderiv(Hn, c1, k), D - 1)
            if unit(-d, k) == unit(c1, k):
                rhs = madd(rhs, {tuple([0] * k): Fraction(1)})
            lhs = {a: v for a, v in lhs.items() if sum(a) <= D - 1}
            ok1 = ok1 and lhs == rhs
            # second display: congruence mod p Hur, valid up to degree D-p
            lhs2 = mderiv(H[d], c, k, times=p)
            t1 = mmul(Hpm1, mderiv(Hn, c, k, times=p), D - p)
            t2 = mpow(mderiv(Hn, c, k), p, D - p, k)
            diff = madd(madd(lhs2, mscale(t1, -1)), t2)
            diff = {a: v for a, v in diff.items() if sum(a) <= D - p}
            ok2 = ok2 and in_pHur(diff, p, D - p)
            # E H_d = H_{d+1}^{p-1} E H_{d+1}  mod p Hur, up to degree D-p
            EH = madd(mderiv(H[d], c, k, times=p), mderiv(H[d], c1, k))
            EHn = madd(mderiv(Hn, c, k, times=p), mderiv(Hn, c1, k))
            diff = madd(EH, mscale(mmul(Hpm1, EHn, D - p), -1))
            diff = {a: v for a, v in diff.items() if sum(a) <= D - p}
            ok3 = ok3 and in_pHur(diff, p, D - p)
    report(f"p={p} k={k} D={D}: d_(c+1) H_d = [c+1=-d] + H^(p-1) d_(c+1) H_(d+1)   (exact)", ok1)
    report(f"p={p} k={k} D={D}: d_c^p H_d = H^(p-1) d_c^p H_(d+1) - (d_c H_(d+1))^p  mod p Hur", ok2)
    report(f"p={p} k={k} D={D}: E H_d = H_(d+1)^(p-1) E H_(d+1)  mod p Hur", ok3)


# ---------------------------------------------------------------- (c) trees (Section 8, not used in the proof)
def trees(p, k, m, depth, memo):
    """all p-ary trees with m leaves, root at depth `depth` (mod k), leaves at depth = 0 mod k"""
    key = (m, depth % k)
    if key in memo:
        return memo[key]
    res = []
    if m == 1 and depth % k == 0:
        res.append(())
    if m >= p:
        def split(r, rem):
            if r == 1:
                yield (rem,)
                return
            for a in range(1, rem - (r - 1) + 1):
                for rest in split(r - 1, rem - a):
                    yield (a,) + rest
        for parts in split(p, m):
            lists = [trees(p, k, a, depth + 1, memo) for a in parts]
            if any(not L for L in lists):
                continue

            def prod(i):
                if i == p:
                    yield ()
                    return
                for t in lists[i]:
                    for rest in prod(i + 1):
                        yield (t,) + rest
            for ch in prod(0):
                res.append(ch)
    memo[key] = res
    return res


def canon(t, cache):
    """canonical representative of the rotation class, and number of asymmetric nodes"""
    if t in cache:
        return cache[t]
    if t == ():
        r = ((), 0)
    else:
        cs = [canon(c, cache) for c in t]
        forms = tuple(c[0] for c in cs)
        asym = sum(c[1] for c in cs)
        if len(set(forms)) > 1:
            asym += 1
        rots = [forms[i:] + forms[:i] for i in range(len(forms))]
        r = (min(rots), asym)
    cache[t] = r
    return r


print("(c) Section 8: rotation classes of trees vs coefficients of F_delta, and class size p^d")
for (p, k, M) in [(2, 1, 11), (3, 1, 15), (2, 2, 16), (5, 1, 17), (2, 3, 22), (3, 2, 17)]:
    F = compute_F(p, k, M)
    ok = True
    oksize = True
    ntrees = 0
    for d in range(k):
        memo = {}
        for m in range(1, M + 1):
            ts = trees(p, k, m, d, memo)
            ntrees += len(ts)
            cache = {}
            classes = {}
            for t in ts:
                c, asym = canon(t, cache)
                classes.setdefault((c, asym), 0)
                classes[(c, asym)] += 1
            count = {}
            for (c, asym), size in classes.items():
                count[asym] = count.get(asym, 0) + 1
                if size != p ** asym:
                    oksize = False
            want = {dd: cc for dd, cc in enumerate(F[d][m]) if cc}
            if count != want:
                ok = False
                print("      mismatch", p, k, d, m, count, want)
    report(f"p={p} k={k}: #classes with m leaves, d asymmetric nodes = [x^m y^d]F_delta (m<={M}, {ntrees} trees)", ok)
    report(f"p={p} k={k}: every class with d asymmetric nodes has exactly p^d trees", oksize)

print("ALL PASS" if ok_all else "SOME FAILED")

# Written by moonshotai/kimi-k3.1-pro (Open Math OS worker W015), 2026-11-13.
# Verifies the Frobenius / recursion proof of Idea 4 in notes/2026-11-13_new_ideas.md.
# All arithmetic exact (Python ints, fractions.Fraction). Not human-verified.
"""
G = sum_m c_m x^m is the generating function of p-ary trees by leaves: G = x + G^p.
c_m = 0 unless m = 1 mod (p-1); c_{(p-1)n+1} = C_n^(p) (Fuss-Catalan).
For q = p^k the depth-counting system F_delta = [delta=0] x + F_{delta+1}^p
gives f_0[(q-1)n+1] = C_n^(q).
Items 1-6 follow briefs/W015_frobenius_proof.md.
"""
from fractions import Fraction
from math import factorial, comb
import sys

PRIMES = [2, 3, 5, 7]
CHECKS = 0
FAILURES = []

def check(cond, msg):
    global CHECKS
    CHECKS += 1
    if not cond:
        FAILURES.append(msg)
        print("FAIL:", msg, flush=True)

def digits(m, p):
    d = []
    while m:
        d.append(m % p)
        m //= p
    return d or [0]

def s_p(m, p):
    return sum(digits(m, p))

def t_of(m, p):
    return (s_p(m, p) - 1) // (p - 1)

def fc(n, q):
    return comb(q * n, n) // ((q - 1) * n + 1)

def is_power_of_p(m, p):
    while m % p == 0:
        m //= p
    return m == 1

def admissible(m, p):
    return m >= 1 and (m - 1) % (p - 1) == 0

# ----------------------------------------------------------------------------
# Implicit series solving: F[m] = sum_{m1+...+mp=m} prod src[m_i] (ordered tuples)
# computed coefficient by coefficient with a factor-DP over previously known
# coefficients.  With src = F itself this gives G = x + G^p (item 1).
# ----------------------------------------------------------------------------
def tuple_coeff(src, p, m, known_upto):
    # sum over ordered p-tuples of src values, indices < known_upto used only.
    nz = [v for v in range(1, known_upto) if src[v]]
    dp = [0] * (m + 1)
    dp[0] = 1
    for _ in range(p):
        ndp = [0] * (m + 1)
        for s in range(m + 1):
            if not dp[s]:
                continue
            ds = dp[s]
            for v in nz:
                if s + v > m:
                    break
                ndp[s + v] += ds * src[v]
        dp = ndp
    return dp[m]

def coeffs_G(p, mmax):
    c = [0] * (mmax + 1)
    c[1] = 1
    for m in range(2, mmax + 1):
        if not admissible(m, p):
            continue
        c[m] = tuple_coeff(c, p, m, m)  # uses c[1..m-1]; c_m term is always 0
    return c

# ----------------------------------------------------------------------------
# Item 1: G mod p = x + x^p + x^(p^2) + ...
# ----------------------------------------------------------------------------
def item1(p, c, mmax):
    for m in range(1, mmax + 1):
        expect = 1 if is_power_of_p(m, p) else 0
        check(c[m] % p == expect,
              f"item1 p={p} m={m}: c_m mod p = {c[m]%p}, expected {expect}")

# ----------------------------------------------------------------------------
# Item 2: necklace recursion
# c_m = [p|m] c_{m/p}^p + p * sum over rotation classes of non-constant p-tuples.
# Brute force over tuples by recursion, grouping rotations.
# ----------------------------------------------------------------------------
def item2(p, c, mmax):
    for m in range(2, mmax + 1):  # recursion is for m > 1; c_1 = 1 is the leaf
        const = c[m // p] ** p if m % p == 0 else 0
        seen = set()
        neck_sum = 0

        def rec(i, rem, acc):
            nonlocal neck_sum
            if i == p:
                if rem:
                    return
                t = acc
                if all(v == t[0] for v in t):
                    return
                if t in seen:
                    return
                rots = [t[j:] + t[:j] for j in range(p)]
                assert len(set(rots)) == p  # non-constant, p prime
                seen.update(rots)
                pr = 1
                for v in t:
                    pr *= c[v]
                neck_sum += pr
                return
            for v in range(rem + 1):
                if v and not c[v]:
                    continue
                rec(i + 1, rem - v, acc + (v,))
        rec(0, m, tuple())
        check(c[m] == const + p * neck_sum,
              f"item2 p={p} m={m}: {c[m]} != {const} + p*{neck_sum}")

# ----------------------------------------------------------------------------
# Item 3: leading coefficients N(m).
# ----------------------------------------------------------------------------
def N_explicit(m, p):
    ds = digits(m, p)
    t = (sum(ds) - 1) // (p - 1)
    num = factorial(p * t)
    den = factorial(t) * p**t
    for d in ds:
        den *= factorial(d)
    assert num % den == 0, (m, p)
    return num // den

def carryfree_compositions(dm, p):
    # ordered p-tuples of nonnegative integers whose digitwise sum is dm
    # (carry-free), enumerated by distributing each digit among p slots.
    slots = [0] * p
    comps = []

    def rec(j):
        if j == len(dm):
            comps.append(tuple(slots))
            return
        d = dm[j]
        if d == 0:
            rec(j + 1)
            return

        def dist(i, left):
            if i == p - 1:
                slots[i] += left * p**j
                rec(j + 1)
                slots[i] -= left * p**j
                return
            for v in range(left + 1):
                slots[i] += v * p**j
                dist(i + 1, left - v)
                slots[i] -= v * p**j
        dist(0, d)
    rec(0)
    return comps

def item3(p, c, mmax):
    N = [None] * (mmax + 1)
    N[1] = 1
    for m in range(2, mmax + 1):
        if not admissible(m, p):
            continue
        if is_power_of_p(m, p):
            N[m] = 1
            continue
        total = Fraction(0)
        for comp in carryfree_compositions(digits(m, p), p):
            if any(v == 0 for v in comp):
                continue
            if any(N[v] is None for v in comp):
                continue  # N(m_i)=0 (inadmissible leaf count) contributes 0
            pr = Fraction(1)
            for v in comp:
                pr *= N[v]
            total += pr
        total /= p
        check(total.denominator == 1,
              f"item3 p={p} m={m}: recursion gives non-integer {total}")
        N[m] = int(total)
    for m in range(1, mmax + 1):
        if not admissible(m, p):
            continue
        t = t_of(m, p)
        check(c[m] % p**t == 0, f"item3 p={p} m={m}: p^t does not divide c_m")
        unit = c[m] // p**t
        check(unit % p == N[m] % p,
              f"item3 p={p} m={m}: c_m/p^t mod p = {unit%p}, N(m) mod p = {N[m]%p}")
        ne = N_explicit(m, p)
        check(N[m] == ne,
              f"item3 p={p} m={m}: recursion N={N[m]} != explicit {ne}")
        check(N[m] % p != 0,
              f"item3 p={p} m={m}: N(m) divisible by p")
    return N

# ----------------------------------------------------------------------------
# Item 4: atom ring Q[u_0..u_J]/(u_j^p), truncated at total degree Dmax.
# Polynomials: dict exponent-tuple -> Fraction, each exponent < p.
# ----------------------------------------------------------------------------
def polymul(a, b, p, J, Dmax):
    out = {}
    for ea, va in a.items():
        da = sum(ea)
        for eb, vb in b.items():
            if da + sum(eb) > Dmax:
                continue
            e = tuple(ea[i] + eb[i] for i in range(J + 1))
            if any(x >= p for x in e):
                continue
            out[e] = out.get(e, Fraction(0)) + va * vb
    return {e: v for e, v in out.items() if v}

def polypow(a, n, p, J, Dmax):
    out = {tuple([0]*(J+1)): Fraction(1)}
    for _ in range(n):
        out = polymul(out, a, p, J, Dmax)
    return out

def item4(p, J, Dmax, c):
    U = {}
    for j in range(J + 1):
        e = [0]*(J+1); e[j] = 1
        U[tuple(e)] = Fraction(1)
    A = {}
    t = 0
    while (p-1)*t + 1 <= Dmax:
        s = (p-1)*t + 1
        coef = Fraction(fc(t, p), p**t)
        for e, v in polypow(U, s, p, J, Dmax).items():
            A[e] = A.get(e, Fraction(0)) + coef * v
        t += 1
    # A = U + A^p / p  (exact identity in the truncated atom ring)
    RHS = dict(U)
    for e, v in polypow(A, p, p, J, Dmax).items():
        RHS[e] = RHS.get(e, Fraction(0)) + v / p
    for e in set(RHS) | set(A):
        if sum(e) > Dmax:
            continue
        check(A.get(e, Fraction(0)) == RHS.get(e, Fraction(0)),
              f"item4 p={p} e={e}: A != U + A^p/p "
              f"({A.get(e,0)} vs {RHS.get(e,0)})")
    # coefficient of prod u_j^{m_j} equals N(m), m = sum m_j p^j
    for e in A:
        m = sum(e[j] * p**j for j in range(J + 1))
        ne = N_explicit(m, p)
        check(A[e] == ne,
              f"item4 p={p} e={e}: coefficient {A[e]} != N(m)={ne} (m={m})")
    # Self-similarity as a ONE-VARIABLE identity A(U) = lam^{-1} G(lam U):
    # coefficient of U^s on the right = c_s * lam^{s-1} = c_s / p^t, s=(p-1)t+1.
    t = 0
    while (p-1)*t + 1 <= Dmax:
        s = (p-1)*t + 1
        check(Fraction(fc(t, p), p**t) == Fraction(c[s], p**t),
              f"item4 selfsimilarity p={p} s={s}: mismatch")
        t += 1
    # Multivariate version: coefficient of prod u_j^{m_j} in lam^{-1}G(lam U)
    # is c_m / p^t exactly.  Compare with A's coefficient N(m): equal mod p,
    # generally NOT equal as rationals.  Report both; check the mod-p equality.
    ndiff = 0
    for e in A:
        m = sum(e[j] * p**j for j in range(J + 1))
        if m > len(c) - 1:
            continue
        tt = t_of(m, p)
        exact = Fraction(c[m], p**tt)
        if exact != A[e]:
            ndiff += 1
        diff = exact - A[e]
        # The mod-p statement requires diff to be p-integral: its reduced
        # denominator must be prime to p.
        den = diff.denominator
        check(den % p != 0,
              f"item4 multivariate self-similarity mod p fails: p={p} e={e} "
              f"c_m/p^t={exact}, N(m)={A[e]}")
    print(f"  item 4: multivariate self-similarity is exact in only "
          f"{len(A)-ndiff}/{len(A)} coefficients; in the rest it holds mod p "
          f"(as predicted by item 3).")
    return A

# ----------------------------------------------------------------------------
# Item 5: k >= 2 system.  F_delta coefficients f_delta[m].
# ----------------------------------------------------------------------------
def coeffs_F(p, k, mmax):
    F = [[0]*(mmax+1) for _ in range(k)]
    F[0][1] = 1
    for m in range(2, mmax + 1):
        for d in range(k):
            F[d][m] = tuple_coeff(F[(d+1) % k], p, m, m)
    return F

def item5(p, k, mmax):
    q = p**k
    F = coeffs_F(p, k, mmax)
    n = 0
    while (q-1)*n + 1 <= mmax:
        m = (q-1)*n + 1
        check(F[0][m] == fc(n, q),
              f"item5 p={p} k={k} n={n}: F_0[m]={F[0][m]} != C_n^(q)={fc(n,q)}")
        n += 1
    # mod p: F_d = sum_{h >= 0, h = -d mod k} x^{p^h}
    for d in range(k):
        for m in range(1, mmax + 1):
            expect = 0
            if is_power_of_p(m, p):
                h, mm = 0, m
                while mm > 1:
                    mm //= p
                    h += 1
                if (h + d) % k == 0:
                    expect = 1
            check(F[d][m] % p == expect,
                  f"item5 p={p} k={k} d={d} m={m}: F_d mod p = {F[d][m]%p}, "
                  f"expected {expect}")
    # leading terms: is v_p(f_0[m]) = t(m), and residue = N(m) mod p?
    anomalies, mismatches, nmatch = [], [], 0
    for m in range(1, mmax + 1):
        if F[0][m] == 0:
            continue
        t = t_of(m, p)
        if F[0][m] % p**t:
            anomalies.append((m, t, F[0][m]))
            continue
        unit = F[0][m] // p**t
        if unit % p == 0:
            anomalies.append((m, t, F[0][m]))
            continue
        res = unit % p
        nm = N_explicit(m, p) % p
        if res != nm:
            mismatches.append((m, t, res, nm))
        else:
            nmatch += 1
    print(f"  item 5 (k={k}): Fuss-Catalan match and mod-p Frobenius checked "
          f"for m <= {mmax}.")
    print(f"  item 5 (k={k}): valuation anomalies: {anomalies}")
    print(f"  item 5 (k={k}): leading residue equals N(m) mod p in {nmatch} "
          f"cases; mismatches (m, t, residue, N(m) mod p): {mismatches[:15]}")
    return F

# ----------------------------------------------------------------------------
# Item 6: data only.  a(m) = c_m/p^t; print a(m) mod p^2 and N(m) mod p^2.
# ----------------------------------------------------------------------------
def item6(p, c, mmax):
    rows = []
    for m in range(1, mmax + 1):
        if not admissible(m, p) or c[m] == 0:
            continue
        t = t_of(m, p)
        a = c[m] // p**t
        rows.append((m, t, N_explicit(m, p) % (p*p), a % (p*p)))
    return rows

def main():
    for p in PRIMES:
        mmax = {2: 150, 3: 90, 5: 45, 7: 40}[p]
        print(f"\n===== p = {p}, m up to {mmax} =====", flush=True)
        c = coeffs_G(p, mmax)
        item1(p, c, mmax)
        print(f"item 1: G mod p checked for m <= {mmax}.", flush=True)
        item2(p, c, {2: 45, 3: 33, 5: 25, 7: 22}[p])
        print(f"item 2: necklace recursion checked.", flush=True)
        item3(p, c, mmax)
        print(f"item 3: N(m) recursion, integrality, congruence, explicit "
              f"formula, primality to p checked.", flush=True)
        J = {2: 5, 3: 3, 5: 2, 7: 2}[p]
        Dmax = {2: 25, 3: 15, 5: 13, 7: 13}[p]
        item4(p, J, Dmax, c)
        print(f"item 4: atom-ring functional equation, N(m) coefficients and "
              f"one-variable self-similarity checked.", flush=True)
        if p in (2, 3):
            item5(p, 2, {2: 150, 3: 90}[p])
        rows = item6(p, c, {2: 45, 3: 40, 5: 25, 7: 22}[p])
        print(f"item 6: data (m, t, N(m) mod p^2, c_m/p^t mod p^2):", flush=True)
        for r in rows:
            print("   ", r, flush=True)
    print(f"\nTotal checks: {CHECKS}; failures: {len(FAILURES)}")
    if FAILURES:
        sys.exit(1)

if __name__ == "__main__":
    main()

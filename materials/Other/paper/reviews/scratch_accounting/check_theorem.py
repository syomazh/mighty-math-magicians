# Written by Claude Fable 5.2 (fresh-context referee subagent), 2026-11-14.
# Referee check of paper/accounting_proof.tex: Theorem 1, Lemma 1 (as identities on numbers),
# Corollary 1, and the "k-blocked" reformulation.  Pure stdlib.  Run: uv run python check_theorem.py
#
# C is computed in two independent ways:
#   (i)  closed form binom(qn, n) / ((q-1)n+1);
#   (ii) from the functional equation T(x) = 1 + x T(x)^q of q-ary trees (no closed form),
#        using the power recurrence  n b_n = sum_{j=1..n} (q j - (n-j)) a_j b_{n-j}  for B = A^q, a_0 = 1.
# and, for small sizes, (iii) by counting k-blocked p-ary trees with m leaves directly.
import sys
from math import comb, factorial

PRIMES = (2, 3, 5, 7)
KS = (1, 2, 3)
NMAX = 60


def digits(m, p):
    d = []
    while m:
        d.append(m % p)
        m //= p
    return d


def vp(x, p):
    assert x != 0
    v = 0
    while x % p == 0:
        x //= p
        v += 1
    return v


def qary_counts(q, nmax):
    """a_n = number of plane q-ary trees with n internal nodes, from T = 1 + x T^q."""
    a = [1]
    b = [1]  # b = a^q, coefficients
    for n in range(1, nmax + 1):
        a.append(b[n - 1])  # a_n = [x^{n-1}] T^q
        # b_n from n b_n = sum_{j=1..n} (q j - (n-j)) a_j b_{n-j}
        s = 0
        for j in range(1, n + 1):
            s += (q * j - (n - j)) * a[j] * b[n - j]
        assert s % n == 0
        b.append(s // n)
    return a


def blocked_count(p, k, mmax):
    """f[m] = number of plane p-ary trees with m leaves, every leaf at depth = 0 mod k.
    F_d(x) = [d == 0] x + F_{d+1}(x)^p  (indices mod k), solved by iteration on truncated series."""
    F = [[0] * (mmax + 1) for _ in range(k)]

    def mul(u, v):
        w = [0] * (mmax + 1)
        for i, ui in enumerate(u):
            if ui:
                for j, vj in enumerate(v):
                    if i + j > mmax:
                        break
                    if vj:
                        w[i + j] += ui * vj
        return w

    def power(u, e):
        r = [0] * (mmax + 1)
        r[0] = 1
        for _ in range(e):
            r = mul(r, u)
        return r

    for _ in range(mmax * k + 2):
        newF = []
        for d in range(k):
            g = power(F[(d + 1) % k], p)
            if d == 0:
                g[1] += 1
            newF.append(g)
        if newF == F:
            break
        F = newF
    return F[0]


def main():
    bad = 0
    checked = 0
    for p in PRIMES:
        for k in KS:
            q = p ** k
            series = qary_counts(q, NMAX)
            for n in range(0, NMAX + 1):
                m = (q - 1) * n + 1
                C = comb(q * n, n) // m
                assert comb(q * n, n) % m == 0
                if C != series[n]:
                    print("MISMATCH closed form vs functional equation", p, k, n)
                    bad += 1
                dg = digits(m, p)
                s = sum(dg)
                assert (s - 1) % (p - 1) == 0 and (m - 1) % (p - 1) == 0 and (m - s) % (p - 1) == 0
                t = (s - 1) // (p - 1)
                N = (m - 1) // (p - 1)
                nu = (m - s) // (p - 1)
                assert t == N - nu
                # nu(m) = internal nodes of the digit forest
                assert nu == sum(mj * (p ** j - 1) // (p - 1) for j, mj in enumerate(dg))
                P = 1
                for mj in dg:
                    P *= factorial(mj)
                # Theorem 1
                if (C * P - (-p) ** t) % p ** (t + 1) != 0:
                    print("THEOREM FAILS", p, k, n)
                    bad += 1
                if vp(C, p) != t:
                    print("VALUATION FAILS", p, k, n)
                    bad += 1
                # Lemma 1, both parts, as number identities
                mf = factorial(m)
                if (mf * C) % p ** N != 0:
                    print("LEMMA 1 integrality fails", p, k, n)
                    bad += 1
                L = mf * C // p ** N
                if (L - (-1) ** N) % p != 0:
                    print("LEMMA 1 congruence fails", p, k, n)
                    bad += 1
                # observation used in the report: L(m) = prod_{i<k} K(p^i n), K(a) = (pa)!/(p^a a!)
                Kprod = 1
                for i in range(k):
                    a = p ** i * n
                    Kprod *= factorial(p * a) // (p ** a * factorial(a))
                if Kprod != L:
                    print("L(m) != prod K(p^i n)", p, k, n)
                    bad += 1
                # Lemma 2 + Lemma 3 as number statements (Corollary 1)
                den = p ** nu * P
                if mf % den != 0:
                    print("LEMMA 2 integrality fails", p, k, n)
                    bad += 1
                Fm = mf // den
                if (Fm - (-1) ** nu) % p != 0:
                    print("LEMMA 3 congruence fails", p, k, n)
                    bad += 1
                # product identity of Section 4
                if C * P * Fm != p ** t * L:
                    print("SECTION 4 identity fails", p, k, n)
                    bad += 1
                checked += 1
    print(f"Theorem 1 / Lemma 1 / Section 4 identity: {checked} triples (p,k,n) checked, "
          f"p in {PRIMES}, k in {KS}, 0 <= n <= {NMAX}; failures: {bad}")

    # Corollary 1 for all m in a range (not only m = (q-1)n+1)
    cbad = 0
    cnt = 0
    for p in PRIMES + (11, 13):
        f = 1
        for m in range(0, 3001):
            if m > 0:
                f *= m
            dg = digits(m, p)
            s = sum(dg)
            nu = (m - s) // (p - 1)
            P = 1
            for mj in dg:
                P *= factorial(mj)
            if f % p ** nu != 0 or (f // p ** nu - (-1) ** nu * P) % p != 0:
                cbad += 1
            # recursion pieces: binom(m, m0) = 1 mod p ; K(a) = (-1)^a mod p ; a + nu(a) = nu(m)
            a, m0 = divmod(m, p)
            if comb(m, m0) % p != 1 % p:
                cbad += 1
            if m <= 600:
                K = factorial(p * a) // (p ** a * factorial(a))
                if (K - (-1) ** a) % p != 0:
                    cbad += 1
            nua = (a - sum(digits(a, p))) // (p - 1)
            if a + nua != nu:
                cbad += 1
            cnt += 1
    print(f"Corollary 1 (v_p(m!) and residue), binom(m,m0)=1, K(a)=(-1)^a, a+nu(a)=nu(m): "
          f"{cnt} pairs (p,m) checked, 0 <= m <= 3000; failures: {cbad}")
    bad += cbad

    # (iii) k-blocked p-ary trees counted directly vs q-ary trees
    bbad = 0
    cases = 0
    for p, k, mmax in ((2, 1, 14), (2, 2, 22), (2, 3, 22), (3, 1, 15), (3, 2, 25), (3, 3, 27),
                       (5, 1, 17), (5, 2, 25), (7, 1, 19)):
        q = p ** k
        f = blocked_count(p, k, mmax)
        for m in range(0, mmax + 1):
            if m >= 1 and (m - 1) % (q - 1) == 0:
                n = (m - 1) // (q - 1)
                want = comb(q * n, n) // m
            else:
                want = 0
            if f[m] != want:
                print("k-blocked count mismatch", p, k, m, f[m], want)
                bbad += 1
            cases += 1
    print(f"k-blocked p-ary trees with m leaves = q-ary trees (and 0 when m != 1 mod q-1): "
          f"{cases} (p,k,m) cases; failures: {bbad}")
    bad += bbad
    print("ALL PASS" if bad == 0 else f"FAILURES: {bad}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

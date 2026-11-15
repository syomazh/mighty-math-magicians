# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Connection 1, continued: q-ary trees with q = p^k read as p-ary trees whose
# leaves all have depth divisible by k (Fact 6), far beyond brute force.
#
# F_j[m](y) = sum of y^d over rotation classes of p-ary trees with m leaves,
# all at depth = j (mod k).  A leaf has depth 0; the children of a tree of
# type j are of type j-1.  Same nested-necklace recursion as classpoly.py.
#
# Checked for (p, k) = (2, 2) quadtrees, (2, 3) octrees, (3, 2) nine-fold
# subdivisions, and m = (q-1)N + 1:
#   F_0[m](p) = binom(qN, N)/((q-1)N+1)            (all q-ary trees)
#   lowest power of y = t = (s_p(m) - 1)/(p - 1)   (smallest orbit = p^t)
#   its coefficient is not divisible by p, and equals (-1)^t/prod a_j! mod p
#   F_0[m](0) = 1 iff m is a power of q.
# Also prints the number of orbits F_0[m](1).
#
#   uv run python experiments/E013_new_connections_blind/c1b_qary_classes.py

import sys
from math import factorial

sys.path.insert(0, __file__.rsplit("c1b_qary_classes.py", 1)[0])
from classpoly import padd, peval, pmul, trim
from trees import digits, fuss_catalan, is_power, t_of


def qary_class_polynomials(p, k, M):
    F = [dict() for _ in range(k)]
    F[0][1] = [1]
    power = {}

    def pw(j, r, n):
        """[x^n] (sum_m F_j[m] x^m)^r"""
        if n < r:
            return []
        if r == 1:
            return F[j].get(n, [])
        key = (j, r, n)
        if key not in power:
            acc = []
            for a in range(1, n - r + 2):
                za = F[j].get(a)
                if za:
                    acc = padd(acc, pmul(za, pw(j, r - 1, n - a)))
            power[key] = acc
        return power[key]

    for m in range(2, M + 1):
        if (m - 1) % (p - 1):
            continue
        for j in range(k):
            src = (j - 1) % k
            sym = []
            if m % p == 0 and (m // p) in F[src]:
                base = F[src][m // p]
                sym = [0] * ((len(base) - 1) * p + 1)
                for i, c in enumerate(base):
                    sym[i * p] = c
            tot = pw(src, p, m)
            diff = padd(tot, [-c for c in sym])
            assert all(c % p == 0 for c in diff)
            res = trim(padd(sym, [0] + [c // p for c in diff]))
            if res:
                F[j][m] = res
    return F[0]


def main():
    for p, k, Nmax, name in ((2, 2, 60, "quadtrees"), (2, 3, 25, "octrees"),
                             (3, 2, 20, "9-ary trees")):
        q = p ** k
        Z = qary_class_polynomials(p, k, (q - 1) * Nmax + 1)
        orbit_counts = []
        for N in range(0, Nmax + 1):
            m = (q - 1) * N + 1
            poly = Z[m]
            t = t_of(m, p)
            assert peval(poly, p) == fuss_catalan(q, N)
            low = min(i for i, c in enumerate(poly) if c)
            assert low == t, (p, k, N, low, t)
            prod_fact = 1
            for a in digits(m, p):
                prod_fact *= factorial(a)
            pred = ((-1) ** t * pow(prod_fact, -1, p)) % p
            assert poly[t] % p == pred, (p, k, N, poly[t], pred)
            assert poly[0] == (1 if is_power(m, q) else 0), (p, k, N)
            orbit_counts.append(peval(poly, 1))
        print(f"q = {q} = {p}^{k} ({name}), N = 0..{Nmax}: number of trees, "
              f"smallest orbit p^t, count of smallest orbits mod p, "
              f"fully symmetric iff m is a power of q: OK")
        print(f"   number of orbits, N = 0..{min(Nmax, 14)}: "
              f"{orbit_counts[:15]}")


if __name__ == "__main__":
    main()

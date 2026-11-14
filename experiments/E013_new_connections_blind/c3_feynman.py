# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Connection 3: tree-level Feynman diagrams of phi^3 theory (zero dimensions).
#
# Classical equation of motion for the action  phi^2/2 - g phi^3/3! - J phi :
#       phi = J + (g/2) phi^2 .
# Its power-series solution is the sum over rooted tree diagrams T (root = the
# external leg, leaves = sources J, cubic vertices) of  g^V J^m / S(T),
# S(T) = symmetry factor = order of the automorphism group of T.
#
# Claims tested (p = 2, m = number of sources, V = m - 1 vertices):
#   (a) S(T) = 2^sigma(T) and the automorphism group acts faithfully on the
#       sources: checked by brute-force counting of leaf-labelled trees.
#   (b) sum_T 1/S(T) = Catalan(m-1) / 2^(m-1) = coefficient of the series.
#   (c) the largest symmetry factor at order J^m is the 2-part of m!
#       (computed by dividing m!, not by Legendre's formula).
#   (d) the number of diagrams with the largest symmetry factor is odd, in
#       fact (2s-3)!! with s = number of ones of m in binary.
#   (e) hence the denominator of the coefficient is exactly that largest
#       symmetry factor.
#
#   uv run python experiments/E013_new_connections_blind/c3_feynman.py

import sys
from collections import Counter, defaultdict
from fractions import Fraction
from math import comb, factorial

sys.path.insert(0, __file__.rsplit("c3_feynman.py", 1)[0])
from trees import LEAF, binary_classes, canon, d_sigma, digit_sum, val


def catalan(n):
    return comb(2 * n, n) // (n + 1)


def labelled_trees(S):
    """All unordered rooted binary trees whose leaves carry the labels in S
    (a sorted tuple), as nested frozensets."""
    if len(S) == 1:
        return [S[0]]
    out = []
    first, rest = S[0], S[1:]
    n = len(rest)
    for mask in range(2 ** n):
        A = (first,) + tuple(rest[i] for i in range(n) if mask >> i & 1)
        B = tuple(rest[i] for i in range(n) if not mask >> i & 1)
        if not B:
            continue
        for ta in labelled_trees(A):
            for tb in labelled_trees(B):
                out.append(frozenset([ta, tb]))
    return out


def shape(t):
    """Forget the labels: canonical ordered tree of a labelled tree."""
    if not isinstance(t, frozenset):
        return LEAF
    a, b = tuple(t)
    return canon((shape(a), shape(b)))


def double_factorial_odd(k):
    """(k)!! for odd k >= -1."""
    out = 1
    while k > 1:
        out *= k
        k -= 2
    return out


def main():
    print("(a) symmetry factor = 2^sigma, faithful on the sources "
          "(brute force over leaf-labelled trees)")
    print(" m  #labelled trees  (2m-3)!!  #shapes  all |Aut| = m!/orbit = 2^sigma")
    for m in range(1, 9):
        lab = labelled_trees(tuple(range(1, m + 1)))
        assert len(lab) == double_factorial_odd(2 * m - 3)
        orbit = Counter(shape(t) for t in lab)
        assert set(orbit) == set(binary_classes(m))
        ok = True
        for T, n in orbit.items():
            assert factorial(m) % n == 0
            aut = factorial(m) // n          # stabiliser in S_m
            ok &= (aut == 2 ** d_sigma(T)[1])
        assert ok
        print(f"{m:2d}  {len(lab):15d}  {double_factorial_odd(2 * m - 3):8d}  "
              f"{len(orbit):7d}  {ok}")

    print()
    print("(b)-(e) series of phi = J + (g/2) phi^2 against the sum over diagrams")
    # coefficients c_m of J^m (g = 1), by iterating the equation
    M = 20
    c = [Fraction(0)] * (M + 1)
    c[1] = Fraction(1)
    for m in range(2, M + 1):
        c[m] = Fraction(1, 2) * sum(c[a] * c[m - a] for a in range(1, m))
    print(" m  #diagrams  coefficient         max S  2-part of m!  "
          "#diagrams with max S  (2s-3)!!  t  v2(Catalan)")
    for m in range(1, M + 1):
        cls = binary_classes(m)
        total = sum(Fraction(1, 2 ** d_sigma(T)[1]) for T in cls)
        assert total == c[m] == Fraction(catalan(m - 1), 2 ** (m - 1))
        assert sum(2 ** d_sigma(T)[0] for T in cls) == catalan(m - 1)
        maxS = max(2 ** d_sigma(T)[1] for T in cls)
        two_part = 2 ** val(factorial(m), 2)
        assert maxS == two_part
        nmax = sum(1 for T in cls if 2 ** d_sigma(T)[1] == maxS)
        s = digit_sum(m, 2)
        assert nmax % 2 == 1
        assert nmax == double_factorial_odd(2 * s - 3)
        assert c[m].denominator == maxS
        t = s - 1
        assert val(catalan(m - 1), 2) == t
        print(f"{m:2d}  {len(cls):9d}  {str(c[m]):18s}  {maxS:5d}  {two_part:12d}  "
              f"{nmax:20d}  {double_factorial_odd(2 * s - 3):8d}  {t}  "
              f"{val(catalan(m - 1), 2)}")
    print("all assertions passed for m = 1 ..", M)


if __name__ == "__main__":
    main()

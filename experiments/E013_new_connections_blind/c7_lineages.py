# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Connection 7: cell lineage trees (developmental biology).
#
# A lineage is a binary tree: node = one cell division, leaf = terminal cell.
# A division is "shape-symmetric" when the two daughters go on to produce
# equivalent sub-lineages, "shape-asymmetric" otherwise.
#
# Checks (p = 2):
#  (1) number of lineage shapes with m terminal cells and no asymmetric
#      division = 1 if m is a power of two, 0 otherwise (Fact 7), m <= 200,
#      from the nested-necklace recursion; brute force for m <= 20;
#  (2) fewest asymmetric divisions = ones(m) - 1 (Fact 2), same ranges;
#  (3) number of ways to orient a lineage shape (which daughter is "anterior")
#      = 2^d, and these add up to the Catalan number (Fact 1), m <= 12;
#  (4) explicit optimal lineages for some cell numbers quoted in the notes
#      (the bound is attained; whether real lineages come near it is NOT
#      tested here: no lineage data were downloaded).
#
#   uv run python experiments/E013_new_connections_blind/c7_lineages.py

import sys
from collections import Counter
from math import comb

sys.path.insert(0, __file__.rsplit("c7_lineages.py", 1)[0])
from classpoly import class_polynomials, peval
from trees import (LEAF, binary_classes, canon, complete_tree, d_sigma,
                   digit_sum, is_power, leaves, ordered_trees)

sys.setrecursionlimit(100000)


def optimal_lineage(m):
    atoms = [complete_tree(2, j) for j in range(m.bit_length()) if m >> j & 1]
    T = atoms[0]
    for A in atoms[1:]:
        T = (A, T)
    return T


def main():
    Z = class_polynomials(2, 200)
    for m in range(1, 201):
        poly = Z[m]
        assert poly[0] == (1 if is_power(m, 2) else 0)
        low = min(i for i, c in enumerate(poly) if c)
        assert low == digit_sum(m, 2) - 1
        assert peval(poly, 2) == comb(2 * (m - 1), m - 1) // m
    print("(1),(2) recursion, m = 1..200: a fully symmetric lineage exists iff "
          "m is a power of 2;")
    print("        fewest asymmetric divisions = ones(m) - 1;  "
          "sum of 2^d = Catalan: OK")
    for m in range(1, 21):
        cls = binary_classes(m)
        hist = Counter(d_sigma(T)[0] for T in cls)
        assert [hist.get(i, 0) for i in range(max(hist) + 1)] == Z[m]
    print("        brute force over all shapes agrees for m = 1..20: OK")

    for m in range(1, 13):
        size = Counter(canon(T) for T in ordered_trees(m, 2))
        assert all(n == 2 ** d_sigma(T)[0] for T, n in size.items())
    print("(3) each shape with d asymmetric divisions has exactly 2^d "
          "orientations, m = 1..12: OK")
    print()
    print("Distribution of the number of asymmetric divisions, small m")
    print("(entry k of the list = number of lineage shapes with k asymmetric "
          "divisions)")
    for m in (4, 5, 6, 7, 8, 12, 16):
        print(f"  m = {m:2d}: {Z[m]}")
    print()
    print("(4) lower bounds for some cell numbers (see the notes for sources)")
    print("     m   binary        ones-1   optimal lineage built, d =")
    for m in (4, 8, 16, 32, 64, 128, 558, 671, 959, 1031, 1090):
        T = optimal_lineage(m)
        assert leaves(T) == m
        d = d_sigma(T)[0]
        assert d == digit_sum(m, 2) - 1
        print(f"  {m:5d}  {m:12b}  {digit_sum(m, 2) - 1:6d}   {d}")


if __name__ == "__main__":
    main()

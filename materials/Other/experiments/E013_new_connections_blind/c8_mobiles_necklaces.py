# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Connection 8: mobiles (rooted trees with cyclically ordered children) and
# necklaces.  A node with p children up to rotation is a necklace of p beads
# whose "colours" are the classes of the subtrees.
#
# Checks:
#  (1) one node: number of necklaces with p beads and k colours, brute force,
#      = (k^p - k)/p + k  (the necklace proof of Fermat's little theorem);
#  (2) the nested-necklace recursion (classpoly.py) reproduces the brute-force
#      classes with their numbers of asymmetric nodes, p = 2, 3, 5;
#  (3) with the recursion, far beyond brute force: Z_m(0) = [m power of p],
#      Z_m(p) = Fuss-Catalan, lowest power of y in Z_m is t, its coefficient
#      is (-1)^t / prod a_j!  (mod p), for p = 2, 3, 5, 7;
#  (4) tree version of Fermat: C = [m is a power of p]  (mod p);
#  (5) the numbers of mobiles Z_m(1), printed for comparison with the OEIS.
#
#   uv run python experiments/E013_new_connections_blind/c8_mobiles_necklaces.py

import sys
from collections import Counter
from itertools import product
from math import factorial

sys.path.insert(0, __file__.rsplit("c8_mobiles_necklaces.py", 1)[0])
from classpoly import class_polynomials, peval
from trees import (canon, d_sigma, digits, fuss_catalan, is_power,
                   ordered_trees, t_of)


def check_necklaces():
    print("(1) necklaces with p beads, k colours, up to rotation")
    for p in (2, 3, 5, 7):
        for k in range(1, 6):
            seen = set()
            for w in product(range(k), repeat=p):
                seen.add(min(w[r:] + w[:r] for r in range(p)))
            assert len(seen) == (k ** p - k) // p + k
            assert (k ** p - k) % p == 0
    print("    brute force = (k^p - k)/p + k for p in {2,3,5,7}, k = 1..5: OK")


def check_recursion_against_brute_force():
    print("(2) nested-necklace recursion against brute-force enumeration")
    for p, Nmax in ((2, 11), (3, 7), (5, 5)):
        Z = class_polynomials(p, (p - 1) * Nmax + 1)
        for N in range(0, Nmax + 1):
            m = (p - 1) * N + 1
            trees = ordered_trees(m, p)
            assert len(trees) == fuss_catalan(p, N)
            cls = {canon(T) for T in trees}
            hist = Counter(d_sigma(T)[0] for T in cls)
            poly = [hist.get(i, 0) for i in range(max(hist) + 1)]
            assert poly == Z[m], (p, m, poly, Z[m])
            # class sizes are p^d
            size = Counter(canon(T) for T in trees)
            assert all(size[c] == p ** d_sigma(c)[0] for c in cls)
        print(f"    p = {p}: N = 0..{Nmax} OK "
              f"(largest case: {fuss_catalan(p, Nmax)} ordered trees)")


def check_facts_far():
    print("(3) Facts 2, 4, 7 from the recursion alone")
    for p, M in ((2, 120), (3, 161), (5, 201), (7, 241)):
        Z = class_polynomials(p, M)
        for m, poly in Z.items():
            N = (m - 1) // (p - 1)
            t = t_of(m, p)
            assert poly[0] == (1 if is_power(m, p) else 0)
            assert peval(poly, p) == fuss_catalan(p, N)
            low = min(i for i, c in enumerate(poly) if c)
            assert low == t
            prod_fact = 1
            for a in digits(m, p):
                prod_fact *= factorial(a)
            pred = ((-1) ** t * pow(prod_fact, -1, p)) % p
            assert poly[t] % p == pred, (p, m, poly[t], pred)
        print(f"    p = {p}: all m <= {M} with m = 1 mod {p - 1} "
              f"({len(Z)} values) OK")


def check_fermat_for_trees():
    print("(4) Fuss-Catalan number = [m is a power of p] (mod p)")
    for p in (2, 3, 5, 7, 11, 13):
        for N in range(0, 2001):
            m = (p - 1) * N + 1
            assert fuss_catalan(p, N) % p == (1 if is_power(m, p) else 0)
    print("    p in {2,3,5,7,11,13}, N = 0..2000: OK")


def print_sequences():
    print("(5) number of mobiles with all hubs p-armed, by number of hubs N")
    for p, M in ((2, 20), (3, 39), (5, 61)):
        Z = class_polynomials(p, M)
        seq = [peval(Z[m], 1) for m in sorted(Z)]
        print(f"    p = {p}: {seq}")


if __name__ == "__main__":
    check_necklaces()
    check_recursion_against_brute_force()
    check_facts_far()
    check_fermat_for_trees()
    print_sequences()

"""Round-3 referee check: (1) the theorem against the closed formula on a wide range;
(2) number of cyclic skeleton trees (independent enumeration) against the predicted residue on a
range beyond the brute-force range, including k = 2, 3, 4; (3) every number in the worked examples.
"""
import os
import sys
from math import comb, factorial

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from verify_classes import World, digits, fuss, sp, check  # noqa: E402
from verify_carry import brute_T, count_T  # noqa: E402


def vp(x, p):
    v = 0
    while x % p == 0:
        x //= p
        v += 1
    return v


def theorem_range():
    cases = 0
    for p in (2, 3, 5, 7, 11, 13):
        for k in (1, 2, 3, 4, 5):
            q = p ** k
            if q > 130:
                continue
            nmax = 1500 if q <= 16 else 400
            for n in range(1, nmax + 1):
                m = (q - 1) * n + 1
                ds = digits(m, p)
                assert (sum(ds) - 1) % (p - 1) == 0
                t = (sum(ds) - 1) // (p - 1)
                C = fuss(q, n)
                assert vp(C, p) == t, (p, k, n)
                prod = 1
                for d in ds:
                    prod *= factorial(d)
                assert (C // p ** t) % p == ((-1) ** t * pow(prod, -1, p)) % p, (p, k, n)
                cases += 1
    print(f"(1) theorem == closed formula (valuation and unit residue) on {cases} triples (p,k,n): OK")


def skeleton_range():
    cases = 0
    biggest = 0
    for (p, k, mmax, smax) in [(2, 1, 300, 7), (2, 2, 3000, 9), (2, 3, 6000, 10), (2, 4, 9000, 10),
                               (3, 1, 400, 7), (3, 2, 3000, 9), (3, 3, 6000, 9),
                               (5, 1, 400, 9), (5, 2, 3000, 9), (7, 1, 400, 7)]:
        q = p ** k
        W = World(p, k)
        for m in range(1, mmax + 1):
            if (m - 1) % (q - 1):
                continue
            ds = digits(m, p)
            s = sum(ds)
            if s > smax:
                continue
            t = (s - 1) // (p - 1)
            N = len(W.skeletons(m))
            biggest = max(biggest, N)
            prod = 1
            for d in ds:
                prod *= factorial(d)
            pred = ((-1) ** t * pow(prod, -1, p)) % p
            assert N % p == pred, (p, k, m, N, pred)
            n = (m - 1) // (q - 1)
            C = fuss(q, n)
            assert (C // p ** t) % p == N % p
            if k == 1:
                assert N * factorial(t) * p ** t * prod == factorial(p * t), (p, m, N)
                if p == 2:
                    df = 1
                    for x in range(2 * s - 3, 0, -2):
                        df *= x
                    assert N == df  # (2s-3)!!, the Deutsch-Sagan / Kersting-Fischer count
            # Prop "Removing labelling": T(a) = N * prod m_j!
            a = [0] * k
            for j, d in enumerate(ds):
                a[j % k] += d
            assert count_T(p, k)(tuple(a), 0) == N * prod, (p, k, m)
            cases += 1
    print(f"(2) #cyclic skeleton trees == predicted residue mod p, == C/p^t mod p, T(a) == N*prod m_j!, "
          f"exact formula for k=1, on {cases} values of m (largest N_min seen: {biggest}): OK")


def root_atoms(S):
    assert S[0] == 'N'
    return tuple(sorted(x[1] for x in S[1:] if x[0] == 'L'))


def examples():
    # --- Example binary (2,1,6)
    assert fuss(2, 6) == 132 and digits(7, 2) == [1, 1, 1] and sp(7, 2) == 3
    W = World(2, 1)
    sk = W.skeletons(7)
    assert len(sk) == 3
    for S in sk:
        # one cherry of two atoms + one atom at the root
        assert len(root_atoms(S)) == 1
        T = W.expand(S)
        assert W.d(T) == 2
        cls = [U for U in W.gen(7, 0) if W.canon(U) == W.canon(T)]
        assert len(cls) == 4
    assert sorted(root_atoms(S)[0] for S in sk) == [0, 1, 2]
    assert 132 // 4 == 33 and 33 % 2 == 1
    assert factorial(4) // (factorial(2) * 2 ** 2) == 3
    print("(3a) binary example: m=7, t=2, three skeletons (remaining atom K_0, K_1, K_2), class size 4, "
          "C_6=132, 132/4=33 odd, 4!/(2! 2^2)=3: OK")

    # --- Example ternary (3,1,8)
    assert 2 * 8 + 1 == 17 and digits(17, 3) == [2, 2, 1]
    assert fuss(3, 8) == 43263 and 43263 // 9 == 4807 and 43263 % 9 == 0 and 4807 % 3 == 1
    assert factorial(6) // (factorial(2) * 9 * (2 * 2 * 1)) == 10
    W = World(3, 1)
    sk = W.skeletons(17)
    assert len(sk) == 10
    by = {}
    for S in sk:
        by[root_atoms(S)] = by.get(root_atoms(S), 0) + 1
    assert by == {(0, 0): 1, (1, 1): 1, (0, 2): 2, (1, 2): 2, (0, 1): 4}, by
    # the two pictured choices of atoms
    assert by[(1, 2)] == 2 and by[(0, 2)] == 2
    T5 = len(brute_T(3, 1, (5,)))
    T3 = len(brute_T(3, 1, (3,)))
    T1 = len(brute_T(3, 1, (1,)))
    assert (T5, T3, T1) == (40, 2, 1)
    assert T5 == 10 * 2 * 2 and (T5 + T3) % 3 == 0 and (T3 + T1) % 3 == 0 and T5 % 3 == 1
    assert pow(4, -1, 3) == 1
    print(f"(3b) ternary example: m=17=122_3, t=2, N_min=10, breakdown by root atoms {by}, "
          f"T(5)={T5}, T(3)={T3}, T(1)={T1}, C=43263, 43263/9=4807 == 1 mod 3: OK")

    # --- Example quaternary (2,2,4)
    assert 3 * 4 + 1 == 13 and digits(13, 2) == [1, 0, 1, 1]
    assert fuss(4, 4) == 140 and 140 // 4 == 35
    W = World(2, 2)
    sk = W.skeletons(13)
    assert len(sk) == 1
    S = next(iter(sk))
    atoms = sorted(W.skel_atoms(S))
    assert atoms == [(0, 2), (2, 2), (3, 1)], atoms  # (height, depth)
    T = W.expand(S)
    depths = sorted(W.leaf_depths(T))
    assert depths == [2] + [4] * 12
    vals = [len(brute_T(2, 2, a)) for a in ((2, 1), (0, 2), (1, 0))]
    assert vals == [1, 1, 1]
    print(f"(3c) quaternary example: m=13=1101_2, t=2, one skeleton with (height,depth) = {atoms}, "
          f"leaf depths of the expansion: one at 2, twelve at 4; T(2,1),T(0,2),T(1,0) = {vals}; C=140, 140/4=35: OK")
    # brute-force confirmation of the three examples' N_min
    assert check(2, 1, 6, verbose=False) == 3
    assert check(3, 1, 8, verbose=False) == 10
    assert check(2, 2, 4, verbose=False) == 1


if __name__ == "__main__":
    theorem_range()
    skeleton_range()
    examples()
    print("ALL FORMULA / EXAMPLE CHECKS PASSED")

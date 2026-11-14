# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Independent of the Kimi worker's run.py
# in this folder (whose intermediate outputs contain failures caused by bugs in its enumerators).
"""
Check of the three lemmas of the accounting proof (notes/2026-11-13_new_ideas.md, Idea 1).

N(m) = (m-1)/(p-1), nu(m) = (m - s_p(m))/(p-1).

L1.  m! * C = p^N(m) * L(m), where L(m) = number of leaf-labelled cyclic k-blocked trees with m
     leaves = T((m,0,...,0)) in the notation of the main proof.  L(m) is computed here by the
     labelled counter of experiment E000 (explicit recursion over set partitions).
L2.  L(m) = (-1)^N(m)  (mod p).
L3.  The set F(m) of digit-forest structures on {1..m} is enumerated EXPLICITLY, and compared
     with m!/(p^nu * prod m_j!), with the recursion binom(m, m_0) * K(m') * |F(m')|, and with
     the residue (-1)^nu (mod p).
"""
import itertools
import os
import sys
from math import comb, factorial, prod

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "E000_first_sanity_check"))
from check import make_labelled_counter  # noqa: E402


def digits(m, p):
    out = []
    while m:
        out.append(m % p)
        m //= p
    return out


def nu(m, p):
    return (m - sum(digits(m, p))) // (p - 1)


# ---- explicit digit forests ---------------------------------------------------------------
def complete_cyclic_trees(points, p):
    """All cyclic complete p-ary tree structures whose leaves are exactly `points` (len = p^j).
    A structure is a point (j = 0) or a tuple of p sub-structures, rotated so that the one
    containing the smallest point comes first."""
    points = tuple(sorted(points))
    if len(points) == 1:
        yield points[0]
        return
    size = len(points) // p
    first = points[0]

    def split(remaining, parts_left, need_first):
        if parts_left == 0:
            yield ()
            return
        if need_first:
            rest = [x for x in remaining if x != first]
            for others in itertools.combinations(rest, size - 1):
                block = (first,) + others
                rem = tuple(x for x in remaining if x not in block)
                for tail in split(rem, parts_left - 1, False):
                    yield (block,) + tail
        else:
            for block in itertools.combinations(remaining, size):
                rem = tuple(x for x in remaining if x not in block)
                for tail in split(rem, parts_left - 1, False):
                    yield (block,) + tail
    for blocks in split(points, p, True):
        for subs in itertools.product(*[list(complete_cyclic_trees(b, p)) for b in blocks]):
            yield tuple(subs)


def digit_forests(m, p):
    """Number of digit-forest structures on {1..m}, by explicit enumeration."""
    dg = digits(m, p)
    count = 0

    def go(remaining, left):
        nonlocal count
        if not remaining:
            count += 1
            return
        x = remaining[0]
        rest = remaining[1:]
        for j, c in enumerate(left):
            if c == 0:
                continue
            size = p ** j
            for others in itertools.combinations(rest, size - 1):
                block = (x,) + others
                ntrees = sum(1 for _ in complete_cyclic_trees(block, p))
                new_left = list(left)
                new_left[j] -= 1
                rem = tuple(y for y in rest if y not in others)
                before = count
                go(rem, new_left)
                count = before + (count - before) * ntrees
    go(tuple(range(1, m + 1)), list(dg))
    return count


if __name__ == "__main__":
    ok = True
    print("L1, L2: labelled trees")
    for p, k, ms in [(2, 1, range(1, 9)), (3, 1, (1, 3, 5, 7, 9)), (5, 1, (1, 5, 9)),
                     (2, 2, (1, 4, 7, 10)), (3, 2, (1, 9)), (2, 3, (1, 8))]:
        q = p ** k
        T = make_labelled_counter(p, k)
        for m in ms:
            n = (m - 1) // (q - 1)
            C = comb(q * n, n) // m
            N = (m - 1) // (p - 1)
            a = tuple([m] + [0] * (k - 1))
            L = T(0, a)
            l1 = factorial(m) * C == p ** N * L
            l2 = L % p == (-1) ** N % p
            ok &= l1 and l2
            print(f"  p={p} k={k} m={m}: C={C} N(m)={N} L(m)={L}  L1 {'ok' if l1 else 'FAIL'}  "
                  f"L2 {'ok' if l2 else 'FAIL'}")
    print("\nL3: explicit digit forests")
    for p, mmax in [(2, 9), (3, 10), (5, 8)]:
        for m in range(1, mmax + 1):
            dg = digits(m, p)
            v = nu(m, p)
            formula = factorial(m) // (p ** v * prod(factorial(x) for x in dg))
            actual = digit_forests(m, p)
            m0, m1 = m % p, m // p
            K = factorial(p * m1) // (p ** m1 * factorial(m1))
            sub = (factorial(m1) // (p ** nu(m1, p) * prod(factorial(x) for x in digits(m1, p)))) if m1 else 1
            rec = comb(m, m0) * K * sub
            good = (actual == formula == rec and actual % p == (-1) ** v % p
                    and comb(m, m0) % p == 1 and K % p == (-1) ** m1 % p)
            ok &= good
            print(f"  p={p} m={m} digits={dg[::-1]} nu={v}: enumerated={actual} formula={formula} "
                  f"recursion={rec} residue={actual % p} expected={(-1) ** v % p}  {'ok' if good else 'FAIL'}")
    print("\nOVERALL:", "ALL CHECKS PASSED" if ok else "SOME CHECKS FAILED")

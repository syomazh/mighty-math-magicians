"""E017 -- the slot count of the path proof, for arbitrary lists of top blocks.

Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.

Goal. Before asking for a Lean proof, test the statement

    minWords(L, n) = slotCount(L, n)

for every list L of block heights (not only the base-p digits of a number) and every n.

  minWords(L, n): the sum over the letter counts a_i of the top blocks (a_i <= p^(L_i), sum n,
      no carries among the a_i, no carries among the p^(L_i) - a_i) of prod minCount(L_i, a_i);
      this is the right side of `card_minimal_words` in lean/MMM/Path/MinCount.lean.
  minCount(h, a): the number of blocks of length p^h with a letters E that attain the bound;
      computed by the recursion proved in Lean (`minCount_mono`, `minCount_succ_eq`) and, as an
      independent check, by enumerating all blocks (small cases).
  slotCount(L, n) = prod_j C(s_j, n_j) * C(s_j - n_j, m_j), with m = len(L) - n,
      s_j = #{i : L_i = j} + p * mu_(j+1),
      mu_j = top_j - floor(n / p^j) - floor(m / p^j)   (0 if negative),
      top_j = sum over the blocks of height h >= j of p^(h - j).
  For the digit list of N, mu_j is the carry into digit j and the product is the note's
  prod_j (N_j + p c_(j+1))! / (n_j! m_j!).
"""
from itertools import product, combinations_with_replacement
from functools import lru_cache
from math import comb, factorial
import sys


def ds(p, x):
    s = 0
    while x:
        s += x % p
        x //= p
    return s


def dig(p, j, x):
    return (x // p ** j) % p


@lru_cache(maxsize=None)
def min_count(p, h, a):
    """minCount by the recursion proved in Lean."""
    if a < 0 or a > p ** h:
        return 0
    if a == 0 or a == p ** h:
        return 1
    q = p ** (h - 1)
    if a % q == 0:
        return comb(p, a // q)
    return p * comb(p - 1, a // q) * min_count(p, h - 1, a % q)


# ---- independent enumeration of blocks ---------------------------------------------------

def blocks(p, h):
    if h == 0:
        return [0, 1]
    sub = blocks(p, h - 1)
    return list(product(sub, repeat=p))


def cnt(u):
    return u if isinstance(u, int) else sum(cnt(v) for v in u)


def canon(u):
    """canonical form of the rotation class and the number d of asymmetric nodes"""
    if isinstance(u, int):
        return u, 0
    cs = [canon(v) for v in u]
    keys = [c[0] for c in cs]
    dsum = sum(c[1] for c in cs)
    sym = all(k == keys[0] for k in keys)
    rots = [tuple(keys[i:] + keys[:i]) for i in range(len(keys))]
    key = min(rots)
    if sym:
        # all sub-blocks equivalent: the note counts d of one of them times p
        return key, cs[0][1] * len(u)
    return key, dsum + 1


def min_count_enum(p, h):
    out = {}
    for u in blocks(p, h):
        a = cnt(u)
        _, d = canon(u)
        if (p - 1) * d + 1 == ds(p, a) + ds(p, p ** h - a):
            out[a] = out.get(a, 0) + 1
    return out


# ---- the two sides --------------------------------------------------------------------------

def min_words(p, L, n):
    N = sum(p ** h for h in L)
    m = N - n
    total = 0

    def rec(i, left, sE, sS, prod_):
        nonlocal total
        if i == len(L):
            if left == 0 and sE == ds(p, n) and sS == ds(p, m):
                total += prod_
            return
        for a in range(0, min(left, p ** L[i]) + 1):
            mc = min_count(p, L[i], a)
            rec(i + 1, left - a, sE + ds(p, a), sS + ds(p, p ** L[i] - a), prod_ * mc)

    rec(0, n, 0, 0, 1)
    return total


def slot_count(p, L, n, B):
    N = sum(p ** h for h in L)
    m = N - n

    def mu(j):
        top = sum(p ** (h - j) for h in L if h >= j)
        return max(0, max(0, top - n // p ** j) - m // p ** j)

    out = 1
    for j in range(B):
        s = L.count(j) + p * mu(j + 1)
        nj, mj = dig(p, j, n), dig(p, j, m)
        out *= comb(s, nj) * (comb(s - nj, mj) if s >= nj else 0)
    return out


def main():
    ok = True
    checks = 0

    # (0) the recursion for minCount against enumeration
    for p, hmax in ((2, 4), (3, 2), (5, 1)):
        for h in range(hmax + 1):
            en = min_count_enum(p, h)
            for a in range(p ** h + 1):
                checks += 1
                if en.get(a, 0) != min_count(p, h, a):
                    ok = False
                    print("MISMATCH minCount", p, h, a, en.get(a, 0), min_count(p, h, a))
    print(f"(0) minCount recursion = enumeration of blocks: {checks} cases")

    # (1) minWords = slotCount for all lists
    c1 = 0
    bad = 0
    for p, hmax, kmax in ((2, 3, 5), (3, 2, 5), (5, 1, 4)):
        for k in range(0, kmax + 1):
            for L in combinations_with_replacement(range(hmax + 1), k):
                L = list(L)
                N = sum(p ** h for h in L)
                B = 1
                while p ** B <= N:
                    B += 1
                for n in range(N + 1):
                    c1 += 1
                    w = min_words(p, L, n)
                    f = slot_count(p, L, n, B)
                    f2 = slot_count(p, L, n, B + 2)
                    if w != f or f != f2:
                        bad += 1
                        ok = False
                        if bad <= 15:
                            print("MISMATCH", p, L, n, "minWords", w, "slotCount", f, f2)
    print(f"(1) minWords = slotCount, all lists (unsorted lists are permutations): {c1} cases, {bad} mismatches")

    # (2) digit lists: the note's product, and the residue modulo p^(c+1)
    c2 = 0
    for p, Nmax in ((2, 70), (3, 90), (5, 130), (7, 120)):
        for N in range(Nmax + 1):
            L = []
            for j in range(12):
                L += [j] * dig(p, j, N)
            B = 1
            while p ** B <= N:
                B += 1
            for n in range(N + 1):
                m = N - n
                c2 += 1
                c = (ds(p, n) + ds(p, m) - ds(p, N)) // (p - 1)
                w = slot_count(p, L, n, B)
                # carries
                carry = [0] * (B + 2)
                for j in range(B + 1):
                    carry[j + 1] = 1 if dig(p, j, n) + dig(p, j, m) + carry[j] >= p else 0
                note = 1
                for j in range(B):
                    note *= factorial(dig(p, j, N) + p * carry[j + 1])
                den = 1
                for j in range(B):
                    den *= factorial(dig(p, j, n)) * factorial(dig(p, j, m))
                if w * den != note:
                    ok = False
                    print("MISMATCH note product", p, N, n, w, note, den)
                dN = 1
                for j in range(B):
                    dN *= factorial(dig(p, j, N))
                mod = p ** (c + 1)
                if (comb(N, n) - w) % mod != 0:
                    ok = False
                    print("MISMATCH binom vs minimal words", p, N, n)
                if (comb(N, n) * den - (-p) ** c * dN) % mod != 0:
                    ok = False
                    print("MISMATCH residue", p, N, n)
                if sum(carry) != c:
                    ok = False
                    print("MISMATCH carries", p, N, n)
    print(f"(2) digit lists: slotCount * prod n_j! m_j! = prod (N_j + p c_(j+1))!, "
          f"binom = slotCount and binom * prod n_j! m_j! = (-p)^c prod N_j!  mod p^(c+1): {c2} cases")

    print("ALL PASS" if ok else "FAILURES")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

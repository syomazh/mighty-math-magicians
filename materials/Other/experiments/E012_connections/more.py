# Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
"""
E012, second part -- exact statements behind further connections (computing, polymers, evolution).

  H. Log Merkle tree. Define M(n): a leaf if n = 1; otherwise (M(k), M(n-k)) with k the largest
     power of two smaller than n. Claim: M(n) is a minimal tree: it has exactly popcount(n) - 1
     asymmetric nodes, and its maximal complete subtrees are one per binary digit 1 of n.
  I. Mountain range. Append leaves one at a time, merging two peaks whenever they have equal
     height. Claim: after n appends the peaks are the binary digits of n, and exactly
     n - popcount(n) merges were made (the carries of counting to n).
  J. Fenwick tree. The loop i -= i & -i visits popcount(n) blocks for a prefix of length n.
  K. Powers. x^n as the product of the squares x^(2^j) over the 1-bits of n (right-to-left binary
     method) is a minimal tree; the left-to-right method, written out as a formula without
     sharing, is not minimal in general (reported, with the first n where it fails).
  L. Branched polymers. The number W(n, f) of ways to join n labelled units, each with f
     distinguishable reactive groups, into a tree-like molecule (one bond uses one group of each
     of two units) equals f^n (fn-n)! / (fn-2n+2)!, and
         W(n, f) / n!  =  f^n * FussCatalan(q = f-1, n) / ((f-2) n + 2).
     Brute force over all labelled trees (Pruefer sequences) for small n and f.
  M. Evolution (Yule model). With P(leaf) = 1 and P(T) = c / (n-1) * P(A) P(B) for a shape T with
     subtrees A, B and n leaves, c = 2 if A and B differ and 1 if they are equal (a uniformly
     random split, then independent subtrees): P(T) = 2^d(T) / prod over nodes (n_v - 1), and the
     probabilities of all shapes with n leaves add up to 1.
"""
import itertools
import sys
from fractions import Fraction
from math import comb, factorial


def popcount(n):
    return bin(n).count("1")


def key(t):
    if t == ():
        return ("L",)
    a, b = key(t[0]), key(t[1])
    return ("N",) + (min(a, b), max(a, b))


def d_of(t):
    if t == ():
        return 0
    return d_of(t[0]) + d_of(t[1]) + (0 if key(t[0]) == key(t[1]) else 1)


def leaves(t):
    return 1 if t == () else leaves(t[0]) + leaves(t[1])


def complete_height(t):
    """Height if t is a complete binary tree, else None."""
    if t == ():
        return 0
    a, b = complete_height(t[0]), complete_height(t[1])
    return a + 1 if a is not None and a == b else None


def atoms(t):
    """Heights of the maximal complete subtrees."""
    h = complete_height(t)
    if h is not None:
        return [h]
    return atoms(t[0]) + atoms(t[1])


def digits_set(n):
    return sorted(j for j in range(n.bit_length()) if n >> j & 1)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.setrecursionlimit(10000)
    ok = True

    # H ---------------------------------------------------------------------------------------
    memo = {1: ()}

    def M(n):
        if n not in memo:
            k = 1 << ((n - 1).bit_length() - 1)          # largest power of two smaller than n
            memo[n] = (M(k), M(n - k))
        return memo[n]

    dmemo = {}

    def d_fast(n):                                       # d of M(n), using the recursion
        if n == 1:
            return 0
        if n not in dmemo:
            k = 1 << ((n - 1).bit_length() - 1)
            dmemo[n] = d_fast(k) + d_fast(n - k) + (0 if k == n - k else 1)
        return dmemo[n]

    okH = True
    for n in range(1, 513):
        t = M(n)
        okH &= leaves(t) == n and d_of(t) == popcount(n) - 1 and sorted(atoms(t)) == digits_set(n)
    for n in range(513, 200001):
        okH &= d_fast(n) == popcount(n) - 1               # M(k) is complete, M(n-k) differs unless n = 2k
    ok &= okH
    print(f"H. log Merkle tree M(n): popcount(n) - 1 asymmetric nodes, atoms = binary digits: "
          f"{'ok' if okH else 'FAIL'}  (explicit trees n <= 512, recursion n <= 200000)")

    # I ---------------------------------------------------------------------------------------
    okI = True
    peaks, merges = [], 0
    for n in range(1, 5001):
        peaks.append(0)
        while len(peaks) >= 2 and peaks[-1] == peaks[-2]:
            h = peaks.pop()
            peaks.pop()
            peaks.append(h + 1)
            merges += 1
        okI &= sorted(peaks) == digits_set(n) and merges == n - popcount(n)
    ok &= okI
    print(f"I. mountain range: peaks = binary digits of n, merges = n - popcount(n), n <= 5000: "
          f"{'ok' if okI else 'FAIL'}")

    # J ---------------------------------------------------------------------------------------
    okJ = True
    for n in range(1, 100001):
        i, blocks = n, 0
        while i > 0:
            i -= i & -i
            blocks += 1
        okJ &= blocks == popcount(n)
    ok &= okJ
    print(f"J. Fenwick prefix of length n visits popcount(n) blocks, n <= 100000: {'ok' if okJ else 'FAIL'}")

    # K ---------------------------------------------------------------------------------------
    def complete(h):
        return () if h == 0 else (complete(h - 1), complete(h - 1))

    def rtl(n):                                           # product of x^(2^j) over the 1-bits
        hs = digits_set(n)
        t = complete(hs[0])
        for h in hs[1:]:
            t = (complete(h), t)
        return t

    def ltr(n):                                           # square, then multiply by x if the bit is 1
        t = ()
        for b in bin(n)[3:]:
            t = (t, t)
            if b == "1":
                t = (t, ())
        return t

    okK = all(leaves(rtl(n)) == n and d_of(rtl(n)) == popcount(n) - 1 for n in range(1, 257))
    first_bad = next(n for n in range(1, 257) if d_of(ltr(n)) != popcount(n) - 1)
    ok &= okK and all(leaves(ltr(n)) == n for n in range(1, 257))
    print(f"K. x^n as a product of repeated squares is a minimal tree, n <= 256: {'ok' if okK else 'FAIL'}; "
          f"the left-to-right method written without sharing first fails at n = {first_bad} "
          f"(d = {d_of(ltr(first_bad))}, minimum {popcount(first_bad) - 1})")

    # L ---------------------------------------------------------------------------------------
    def falling(f, k):
        r = 1
        for i in range(k):
            r *= f - i
        return r

    okL = True
    nL = 0
    for f in (3, 4, 5, 6):
        for n in range(1, 7):
            if n == 1:
                brute = 1
            elif n == 2:
                brute = f * f
            else:
                brute = 0
                for seq in itertools.product(range(n), repeat=n - 2):   # Pruefer: degree = 1 + occurrences
                    deg = [1] * n
                    for v in seq:
                        deg[v] += 1
                    w = 1
                    for dv in deg:
                        w *= falling(f, dv)
                    brute += w
            formula = Fraction(f ** n * factorial(f * n - n), factorial(f * n - 2 * n + 2))
            q = f - 1
            fc = comb(q * n, n) // ((q - 1) * n + 1)
            nL += 1
            okL &= brute == formula and Fraction(brute, factorial(n)) == Fraction(f ** n * fc, (f - 2) * n + 2)
    ok &= okL
    print(f"L. branched polymers: W(n,f) = f^n (fn-n)!/(fn-2n+2)! and W/n! = f^n FussCatalan(f-1,n)/((f-2)n+2): "
          f"{nL} cases (f = 3..6, n <= 6): {'ok' if okL else 'FAIL'}")

    # M ---------------------------------------------------------------------------------------
    shapes = {1: {("L",): (Fraction(1), 0, 1)}}            # key -> (probability, d, product of (n_v - 1))
    okM = True
    for n in range(2, 15):
        cur = {}
        for a in range(1, n // 2 + 1):
            b = n - a
            for ka, (pa, da, qa) in shapes[a].items():
                for kb, (pb, db, qb) in shapes[b].items():
                    if a == b and ka > kb:
                        continue
                    same = ka == kb
                    k = ("N",) + (min(ka, kb), max(ka, kb))
                    p = Fraction(1 if same else 2, n - 1) * pa * pb
                    d = da + db + (0 if same else 1)
                    cur[k] = (p, d, qa * qb * (n - 1))
        shapes[n] = cur
        okM &= sum(v[0] for v in cur.values()) == 1
        okM &= all(v[0] == Fraction(2 ** v[1], v[2]) for v in cur.values())
        okM &= sum(2 ** v[1] for v in cur.values()) == comb(2 * n - 2, n - 1) // n
    ok &= okM
    print(f"M. Yule probabilities P(T) = 2^d / prod (n_v - 1) add up to 1, and sum of 2^d is the Catalan number, "
          f"n <= 14 ({len(shapes[14])} shapes at n = 14): {'ok' if okM else 'FAIL'}")
    print("\nOVERALL:", "ALL CHECKS PASSED" if ok else "SOME CHECKS FAILED")

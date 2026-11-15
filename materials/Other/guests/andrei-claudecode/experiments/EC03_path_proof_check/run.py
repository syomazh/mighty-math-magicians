# EC03 - an independent check of the proof on lattice paths (claim C24 of CLAIMS.md).
# Written by Claude Fable 5.2 (claude-fable-5-2) in Claude Code, started by Andrei, 2026-11-14.
# Not human-reviewed. Standard library only.
# Run from the repository root:  python3 guests/andrei-claudecode/experiments/EC03_path_proof_check/run.py
#
# Written from the statement of C24 and the text of the proof. Of the author's scripts in
# guests/andrei-claude/experiments/path_segments/ I had read the README and the stored output,
# not the code. The classes are found here by a graph search from the moves themselves: there
# is no canonical form and no notion of "asymmetric segment" in this file.
#
# Statement checked. Words of length N with n letters E (1) and m = N - n letters S (0).
# The positions are cut into N_i consecutive segments of length p^i (N_i the base-p digits
# of N, longest first), every segment into p sub-segments, down to single letters. A move
# rotates the p sub-pieces of one segment. Let c be the number of carries when n and m are
# added in base p, c_i the carry into digit i. Then:
#   (1) every class has p^d words with d >= c;
#   (2) the number of classes with exactly p^c words is
#           M = prod_i (N_i + p*c_(i+1))! / (p^c_(i+1) * n_i! * m_i!);
#   (3) binom(N, n)/p^c = M = (-1)^c * prod_i N_i!/(n_i! m_i!)  (mod p);
#   (4) for N = qn + 1, q = p^k: c = t = (s_p((q-1)n+1) - 1)/(p-1), binom(N, n) = N*C, and
#       C/p^t = (-1)^t / prod_j m_j!  (mod p), C the Fuss-Catalan number.

import itertools
import math


def digits(u, p, length):
    return [(u // p**i) % p for i in range(length)]


def moves(N, p):
    """Every move, as a permutation of the positions 0..N-1."""
    perms = []
    L = 0
    while p**L <= N:
        L += 1
    start = 0
    for i in reversed(range(L)):
        for _ in range((N // p**i) % p):
            stack = [(start, p**i)]  # a top segment
            while stack:
                s, ln = stack.pop()
                if ln == 1:
                    continue
                sub = ln // p
                perm = list(range(N))
                for j in range(ln):
                    perm[s + j] = s + (j + sub) % ln
                perms.append(perm)
                for j in range(p):
                    stack.append((s + j * sub, sub))
            start += p**i
    assert start == N
    return perms


def class_sizes(N, n, p):
    """Sizes of all classes of words, by graph search from the moves."""
    perms = moves(N, p)
    seen = set()
    sizes = []
    for E in itertools.combinations(range(N), n):
        w = tuple(1 if i in E else 0 for i in range(N))
        if w in seen:
            continue
        orb = {w}
        todo = [w]
        while todo:
            x = todo.pop()
            for g in perms:
                y = tuple(x[g[i]] for i in range(N))
                if y not in orb:
                    orb.add(y)
                    todo.append(y)
        seen |= orb
        sizes.append(len(orb))
    return sizes


def predicted(N, n, p):
    """(number of carries c, the product M of statement (2), the residue of statement (3))."""
    m = N - n
    L = 2
    while p**(L - 1) <= N:
        L += 1
    nd, md, Nd = digits(n, p, L), digits(m, p, L), digits(N, p, L)
    c = [0] * (L + 1)
    for i in range(L):
        c[i + 1] = (nd[i] + md[i] + c[i] - Nd[i]) // p
        assert c[i + 1] in (0, 1)
    M = 1
    for i in range(L):
        num = M * math.factorial(Nd[i] + p * c[i + 1])
        den = p ** c[i + 1] * math.factorial(nd[i]) * math.factorial(md[i])
        assert num % den == 0, (N, n, p, i)
        M = num // den
    res = (-1) ** sum(c)
    for i in range(L):
        res *= math.factorial(Nd[i]) * pow(math.factorial(nd[i]) * math.factorial(md[i]), -1, p)
    return sum(c), M, res % p


print("EC03 - independent check of the path proof (C24)")
print()
print("Part A - all binomial coefficients binom(N, n), classes by graph search from the moves")
total = 0
for p, NMAX in ((2, 14), (3, 14), (5, 12)):
    cases = 0
    words = 0
    for N in range(1, NMAX + 1):
        for n in range(0, N + 1):
            sizes = class_sizes(N, n, p)
            c, M, res = predicted(N, n, p)
            assert sum(sizes) == math.comb(N, n)
            for s in sizes:  # (1)
                e = 0
                while s % p == 0:
                    s //= p
                    e += 1
                assert s == 1 and e >= c, (N, n, p, sizes)
            assert sizes.count(p**c) == M, (N, n, p, sizes.count(p**c), M)  # (2)
            assert math.comb(N, n) % p**c == 0
            assert (math.comb(N, n) // p**c) % p == res == M % p, (N, n, p)  # (3)
            assert res != 0
            cases += 1
            words += math.comb(N, n)
    total += cases
    print("  p = %d, 1 <= N <= %d, 0 <= n <= N: %d cases, %d words, statements (1)-(3) hold: PASS"
          % (p, NMAX, cases, words))
print("  binomial cases in all: %d" % total)
print()
print("Part B - the Fuss-Catalan case N = qn + 1")
fc = 0
for q, p in ((2, 2), (3, 3), (4, 2), (5, 5), (8, 2), (9, 3)):
    n = 1
    row = []
    while q * n + 1 <= 19:
        N, m = q * n + 1, (q - 1) * n + 1
        C = math.comb(q * n, n) // m
        assert math.comb(q * n, n) % m == 0 and math.comb(N, n) == N * C and N % p == 1
        t = (sum(digits(m, p, 12)) - 1) // (p - 1)
        c, M, res = predicted(N, n, p)
        assert c == t
        sizes = class_sizes(N, n, p)
        assert min(sizes) == p**t and sizes.count(p**t) == M
        want = (-1) ** t
        for dj in digits(m, p, 12):
            want *= pow(math.factorial(dj), -1, p)
        assert C % p**t == 0 and (C // p**t) % p == want % p == M % p, (q, n)
        row.append("n=%d: C=%d=%d^%d*%d, %d smallest classes" % (n, C, p, t, C // p**t, M))
        fc += 1
        n += 1
    print("  q = %d (p = %d): %s" % (q, p, "; ".join(row)))
print("  Fuss-Catalan cases in all: %d, statement (4) holds: PASS" % fc)
print()
print("2 checks, all pass (%d + %d cases)" % (total, fc))

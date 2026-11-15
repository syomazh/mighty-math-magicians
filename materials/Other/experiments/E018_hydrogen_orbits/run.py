# E018: orbits of the leaves ("interchangeable hydrogens") of ternary trees up to rotation, n <= 14 nodes.
# Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.
#
# A class of ternary trees up to rotation is a leaf, or three classes in a cyclic order.
# For a class we compute, by recursion over the tree:
#   d = the number of asymmetric nodes (a node is symmetric if its three subtrees are in the same class);
#   o = the number of orbits of the leaves under the rotations that map the tree to itself:
#       at a symmetric node the orbits are those of one subtree (the three subtrees are permuted cyclically),
#       at an asymmetric node no rotation moves one subtree to another, so the orbits add up.
# Checked for every class with n <= NMAX nodes (m = 2n + 1 leaves, s = digit sum of m in base 3,
# t = (s - 1)/2):  o >= s;  o = s whenever d = t;  and the classes with o = s but d > t are listed.
# Sanity checks: the numbers of classes are A000625, and the sum of 3^d over the classes is binom(3n, n)/(2n+1).
from math import comb

NMAX = 14
A000625 = [1, 1, 1, 2, 5, 11, 28, 74, 199, 551, 1553, 4436, 12832, 37496, 110500]

info = [(0, 0, 1)]          # per class id: (n, d, o); id 0 is the leaf
by_n = {0: [0]}


def digit_sum3(m):
    s = 0
    while m:
        s += m % 3
        m //= 3
    return s


for n in range(1, NMAX + 1):
    seen = set()
    ids = []
    for a in range(n):
        for b in range(n - a):
            c = n - 1 - a - b
            for x in by_n[a]:
                for y in by_n[b]:
                    for z in by_n[c]:
                        canon = min((x, y, z), (y, z, x), (z, x, y))
                        if canon in seen:
                            continue
                        seen.add(canon)
                        sym = (x == y == z)
                        d = info[x][1] + info[y][1] + info[z][1] + (0 if sym else 1)
                        o = info[x][2] if sym else info[x][2] + info[y][2] + info[z][2]
                        info.append((n, d, o))
                        ids.append(len(info) - 1)
    by_n[n] = ids

ok = True
for n in range(NMAX + 1):
    m = 2 * n + 1
    s = digit_sum3(m)
    t = (s - 1) // 2
    cls = [info[i] for i in by_n[n]]
    assert len(cls) == A000625[n], (n, len(cls))
    assert sum(3 ** d for (_, d, _) in cls) == comb(3 * n, n) // (2 * n + 1), n
    below = sum(1 for (_, d, o) in cls if o < s)
    minimal = [(d, o) for (_, d, o) in cls if d == t]
    bad_min = sum(1 for (d, o) in minimal if o != s)
    others = sum(1 for (_, d, o) in cls if o == s and d > t)
    ok = ok and below == 0 and bad_min == 0
    print("n=%2d  m=%2d  s=%d  t=%d  classes=%6d  with o<s: %d  with d=t: %5d (o!=s: %d)  with o=s and d>t: %d"
          % (n, m, s, t, len(cls), below, len(minimal), bad_min, others))
print("all checks passed" if ok else "FAILED")

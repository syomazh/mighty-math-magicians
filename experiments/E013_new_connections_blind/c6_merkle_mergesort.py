# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Connection 6: Merkle hash trees over n leaves when n is not a power of two.
#
# RFC 6962 (Certificate Transparency), section 2.1: for n > 1 let k be the
# largest power of two smaller than n; the tree over n leaves has the tree
# over the first k leaves on the left and the tree over the remaining n - k
# on the right.
#
# Claims tested:
#   - the RFC 6962 tree is a minimal tree of Fact 3: perfect subtrees of sizes
#     given by the binary digits of n, joined by ones(n) - 1 asymmetric nodes;
#   - (brute force, n <= 20) no binary tree on n leaves has fewer asymmetric
#     nodes;
#   - the same shape arises from bottom-up merge sort; top-down merge sort
#     (halve, rounding) gives a minimal tree only for n = 2^k and 2^k - 1
#     in the range tested.
#
#   uv run python experiments/E013_new_connections_blind/c6_merkle_mergesort.py

import sys
from functools import lru_cache

sys.path.insert(0, __file__.rsplit("c6_merkle_mergesort.py", 1)[0])
from trees import LEAF, binary_classes, canon, complete_tree, d_sigma, digit_sum, leaves

sys.setrecursionlimit(100000)


@lru_cache(maxsize=None)
def rfc6962_tree(n):
    if n == 1:
        return LEAF
    k = 1
    while 2 * k < n:
        k *= 2
    return (rfc6962_tree(k), rfc6962_tree(n - k))


def bottom_up_mergesort_tree(n):
    runs = [LEAF] * n
    while len(runs) > 1:
        nxt = []
        for i in range(0, len(runs) - 1, 2):
            nxt.append((runs[i], runs[i + 1]))
        if len(runs) % 2:
            nxt.append(runs[-1])
        runs = nxt
    return runs[0]


@lru_cache(maxsize=None)
def top_down_mergesort_tree(n):
    if n == 1:
        return LEAF
    return (top_down_mergesort_tree((n + 1) // 2), top_down_mergesort_tree(n // 2))


def perfect_subtree_sizes(T):
    """Leaf counts of the maximal perfect (complete) subtrees."""
    j = 0
    m = leaves(T)
    if m & (m - 1) == 0 and T == complete_tree(2, m.bit_length() - 1):
        return [m]
    return perfect_subtree_sizes(T[0]) + perfect_subtree_sizes(T[1])


def main():
    NMAX = 3000
    td_minimal = []
    for n in range(1, NMAX + 1):
        T = rfc6962_tree(n)
        assert leaves(T) == n
        d, s = d_sigma(T)
        t = digit_sum(n, 2) - 1
        assert d == t, (n, d, t)
        sizes = sorted(perfect_subtree_sizes(T))
        assert sizes == sorted(1 << j for j in range(n.bit_length()) if n >> j & 1)
        B = bottom_up_mergesort_tree(n)
        assert d_sigma(B)[0] == t
        assert canon(B) == canon(T)
        if d_sigma(top_down_mergesort_tree(n))[0] == t:
            td_minimal.append(n)
    print(f"RFC 6962 tree on n leaves, n = 1..{NMAX}:")
    print("  asymmetric nodes = ones(n) - 1                      : OK")
    print("  maximal perfect subtrees = binary digits of n       : OK")
    print("  bottom-up merge sort has the same shape             : OK")
    expected = sorted({2 ** k for k in range(0, 12) if 2 ** k <= NMAX} |
                      {2 ** k - 1 for k in range(1, 13) if 2 ** k - 1 <= NMAX})
    print("  top-down merge sort is minimal only for n =", td_minimal)
    print("  these are exactly the n = 2^k and 2^k - 1 in range:",
          td_minimal == expected)
    print()
    print("Brute force over all binary tree shapes (lower bound of Fact 2):")
    print("  n  #shapes  min asymmetric nodes  ones-1  RFC 6962 tree  top-down")
    for n in range(1, 21):
        cls = binary_classes(n)
        md = min(d_sigma(T)[0] for T in cls)
        assert md == digit_sum(n, 2) - 1 == d_sigma(rfc6962_tree(n))[0]
        print(f" {n:2d}  {len(cls):7d}  {md:20d}  {digit_sum(n, 2) - 1:6d}  "
              f"{d_sigma(rfc6962_tree(n))[0]:13d}  "
              f"{d_sigma(top_down_mergesort_tree(n))[0]:8d}")
    print("all assertions passed")


if __name__ == "__main__":
    main()

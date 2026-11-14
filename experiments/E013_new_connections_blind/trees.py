# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Common helpers for experiment E013 (new connections, blind).
# Everything here is written from the definitions in the brief only; no other
# file of the repository was read.  Standard library only.
#
# A p-ary tree is a nested tuple: the leaf is (), a node is a tuple of p trees.

from functools import lru_cache
from itertools import product
from math import comb

LEAF = ()


def digits(m, p):
    """Base-p digits of m, least significant first."""
    out = []
    while m:
        out.append(m % p)
        m //= p
    return out


def digit_sum(m, p):
    return sum(digits(m, p))


def t_of(m, p):
    """t = (s_p(m) - 1)/(p - 1); m must be = 1 mod (p-1)."""
    s = digit_sum(m, p)
    assert (s - 1) % (p - 1) == 0
    return (s - 1) // (p - 1)


def val(n, p):
    """p-adic valuation of a nonzero integer, by repeated division."""
    assert n != 0
    v = 0
    while n % p == 0:
        n //= p
        v += 1
    return v


def fuss_catalan(p, N):
    return comb(p * N, N) // ((p - 1) * N + 1)


def _compositions(m, k):
    """All k-tuples of positive integers with sum m."""
    if k == 1:
        yield (m,)
        return
    for first in range(1, m - k + 2):
        for rest in _compositions(m - first, k - 1):
            yield (first,) + rest


@lru_cache(maxsize=None)
def ordered_trees(m, p):
    """All ordered p-ary trees with m leaves."""
    if m == 1:
        return (LEAF,)
    if m < 1 or (m - 1) % (p - 1) != 0:
        return ()
    out = []
    for parts in _compositions(m, p):
        if any((k - 1) % (p - 1) != 0 for k in parts):
            continue
        for combo in product(*[ordered_trees(k, p) for k in parts]):
            out.append(tuple(combo))
    return tuple(out)


@lru_cache(maxsize=None)
def canon(T):
    """Canonical representative of the rotation class of T."""
    if T == LEAF:
        return LEAF
    cs = tuple(canon(c) for c in T)
    p = len(cs)
    return min(cs[r:] + cs[:r] for r in range(p))


@lru_cache(maxsize=None)
def d_sigma(T):
    """(number of asymmetric nodes, number of symmetric nodes)."""
    if T == LEAF:
        return (0, 0)
    d = s = 0
    for c in T:
        dd, ss = d_sigma(c)
        d += dd
        s += ss
    cs = [canon(c) for c in T]
    if all(c == cs[0] for c in cs):
        s += 1
    else:
        d += 1
    return (d, s)


@lru_cache(maxsize=None)
def leaves(T):
    if T == LEAF:
        return 1
    return sum(leaves(c) for c in T)


@lru_cache(maxsize=None)
def binary_classes(m):
    """Canonical representatives of all rotation classes of binary trees with
    m leaves, generated directly (no enumeration of ordered trees)."""
    if m == 1:
        return (LEAF,)
    out = []
    for a in range(1, m // 2 + 1):
        b = m - a
        A = binary_classes(a)
        B = binary_classes(b)
        if a != b:
            for x in A:
                for y in B:
                    out.append(canon((x, y)))
        else:
            for i, x in enumerate(A):
                for y in A[i:]:
                    out.append(canon((x, y)))
    assert len(set(out)) == len(out)
    return tuple(out)


def complete_tree(p, j):
    T = LEAF
    for _ in range(j):
        T = tuple([T] * p)
    return T


def is_power(m, p):
    while m % p == 0:
        m //= p
    return m == 1

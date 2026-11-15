# Written by mistralai/mistral-large-4-0 (worker W018, blind proof search) on 2026-11-13.
"""Shared helpers: p-adic valuation, digit sums, exact Fuss-Catalan numbers,
generalized Fuss-Catalan family A(b,c), and q-ary tree enumeration."""
from math import comb, factorial
from functools import lru_cache


def v_p(n, p):
    """Exact p-adic valuation of a positive integer n."""
    assert n > 0
    e = 0
    while n % p == 0:
        n //= p
        e += 1
    return e


def s_p(n, p):
    """Sum of base-p digits of n >= 0."""
    s = 0
    while n:
        s += n % p
        n //= p
    return s


def fuss_catalan(n, q):
    """C_n^(q) = binom(qn, n) / ((q-1)n + 1), exact integer."""
    m = (q - 1) * n + 1
    assert comb(q * n, n) % m == 0
    return comb(q * n, n) // m


def fuss_gen(b, c, q):
    """A(b,c) = (c / (qb + c)) * binom(qb + c, b), the generalized Fuss-Catalan
    number (counts 'good' words of length qb+c with b up-steps, Raney lemma).
    Integer for c >= 1. A(b,1) = C_b^(q)."""
    if c <= 0:
        raise ValueError("need c >= 1")
    L = q * b + c
    num = c * comb(L, b)
    assert num % L == 0, (b, c, q)
    return num // L


def trees(n, q):
    """All q-ary trees with exactly n nodes.
    Representation: a tree is None (empty) or a tuple of q children (None or tree)."""
    if n == 0:
        return [None]
    out = []

    def rec(remaining, slots):
        # fill `slots` children whose sizes sum to `remaining`
        if slots == 0:
            if remaining == 0:
                out.append(tuple(cur))
            return
        for sz in range(remaining + 1):
            for sub in trees(sz, q):
                cur.append(sub)
                rec(remaining - sz, slots - 1)
                cur.pop()

    cur = []
    rec(n - 1, q)
    return out


def canon(t):
    """Canonical form of a tree up to isomorphism (sorted children tuples)."""
    if t is None:
        return None
    return tuple(sorted(canon(c) for c in t))


@lru_cache(maxsize=None)
def aut_complete(h, q):
    """|Aut(complete q-ary tree of depth h)| = prod_{i=0}^{h-1} (q!)^{q^i}."""
    res = 1
    for i in range(h):
        res *= factorial(q) ** (q ** i)
    return res


@lru_cache(maxsize=None)
def stab(h, ct, q):
    """|{phi in Aut(complete q-ary tree of depth h) : phi(T) = T}|,
    where ct is the canonical form of a q-ary tree T sitting inside the complete
    tree of depth h (T may be None = no marked nodes)."""
    if ct is None:
        return aut_complete(h, q)
    children = ct  # tuple of length q
    nonempty = [c for c in children if c is not None]
    n_empty = sum(1 for c in children if c is None)
    # group nonempty children by iso class
    from collections import Counter
    classes = Counter(nonempty)
    root_perms = 1
    for cls, mult in classes.items():
        root_perms *= factorial(mult)
    inner = 1
    for c in nonempty:
        inner *= stab(h - 1, c, q)
    return root_perms * inner * aut_complete(h - 1, q) ** n_empty


def orbit_size(t, n, q):
    """Size of the orbit of the q-ary tree t (n nodes) under the full
    automorphism group of the complete q-ary tree of depth n."""
    return aut_complete(n, q) // stab(n, canon(t), q)

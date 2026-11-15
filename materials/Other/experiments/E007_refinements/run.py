# Written by Claude Fable 5.2 (orchestrator), 2026-11-13. Replaces a partial script by a Kimi
# worker that was stopped to save Open Math OS budget. Not human-reviewed.
"""
E007 -- refinements of the divisibility by statistics that rotations preserve.

q = p^k. For a statistic sigma on q-ary trees that is constant on rotation classes, claims
C1 + C2 predict, for every value v:
    p^t divides  #{trees with n nodes and sigma = v},
    and (that number) / p^t  =  #{minimal classes with sigma = v}   (mod p).

This script enumerates all q-ary trees for small n explicitly, computes rotation classes on
the p-ary refinement, and tests for each statistic:
  (i)   it is constant on classes;
  (ii)  every refined count is divisible by p^t;
  (iii) refined count / p^t = number of minimal classes with that value (mod p);
and lists the "tight" values (valuation exactly t).

A q-ary tree is None (empty branch = leaf) or a tuple of q trees.
"""
import itertools
import sys
from collections import Counter, defaultdict
from functools import lru_cache
from math import comb


def digits(m, p):
    out = []
    while m:
        out.append(m % p)
        m //= p
    return out


def vp(x, p):
    if x == 0:
        return 10 ** 9
    v = 0
    while x % p == 0:
        x //= p
        v += 1
    return v


def compositions(total, parts):
    if parts == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, parts - 1):
            yield (first,) + rest


def make(p, k):
    q = p ** k

    @lru_cache(maxsize=None)
    def trees(n):
        if n == 0:
            return (None,)
        out = []
        for split in compositions(n - 1, q):
            for kids in itertools.product(*[trees(c) for c in split]):
                out.append(tuple(kids))
        return tuple(out)

    @lru_cache(maxsize=None)
    def refine(T):
        """q-ary tree -> p-ary tree: leaf = (), node = complete p-ary block of height k."""
        if T is None:
            return ()
        level = [refine(c) for c in T]
        for _ in range(k):
            level = [tuple(level[i:i + p]) for i in range(0, len(level), p)]
        return level[0]

    @lru_cache(maxsize=None)
    def canon(P):
        if P == ():
            return ()
        kids = tuple(canon(c) for c in P)
        return min(kids[i:] + kids[:i] for i in range(p))

    @lru_cache(maxsize=None)
    def dval(P):
        if P == ():
            return 0
        kids = [canon(c) for c in P]
        return sum(dval(c) for c in P) + (0 if len(set(kids)) == 1 else 1)

    return q, trees, refine, canon, dval


# ---- statistics on q-ary trees ---------------------------------------------------------
def height(T):
    return 0 if T is None else 1 + max(height(c) for c in T)


def profile(T):
    cnt = Counter()

    def go(T, depth):
        if T is None:
            return
        cnt[depth] += 1
        for c in T:
            go(c, depth + 1)
    go(T, 0)
    return tuple(cnt[i] for i in range(len(cnt)))


def degree_vector(T):
    """(number of nodes with j non-empty branches) for j = 0..q."""
    cnt = Counter()

    def go(T):
        if T is None:
            return
        cnt[sum(1 for c in T if c is not None)] += 1
        for c in T:
            go(c)
    go(T)
    q = len(T) if T is not None else 0
    return tuple(cnt[j] for j in range(q + 1))


def leaf_depths(T):
    cnt = Counter()

    def go(T, depth):
        if T is None:
            cnt[depth] += 1
            return
        for c in T:
            go(c, depth + 1)
    go(T, 0)
    return tuple(cnt[i] for i in range(max(cnt) + 1))


def childless(T):
    """Number of nodes all of whose branches are empty (a Narayana-type statistic)."""
    if T is None:
        return 0
    return (1 if all(c is None for c in T) else 0) + sum(childless(c) for c in T)


STATS = [("height", height), ("level profile", profile), ("degree vector", degree_vector),
         ("leaves by depth", leaf_depths), ("childless nodes", childless)]


def run(p, k, nmax):
    q, trees, refine, canon, dval = make(p, k)
    print(f"\n=== p={p}, k={k}, q={q} ===")
    ok = True
    for n in range(1, nmax + 1):
        m = (q - 1) * n + 1
        t = (sum(digits(m, p)) - 1) // (p - 1)
        all_trees = trees(n)
        assert len(all_trees) == comb(q * n, n) // m
        cls_of = {T: canon(refine(T)) for T in all_trees}
        d_of = {T: dval(refine(T)) for T in all_trees}
        line = [f"n={n} m={m} t={t} trees={len(all_trees)}"]
        for name, f in STATS:
            by_class = defaultdict(set)
            count = Counter()
            minimal = defaultdict(set)
            for T in all_trees:
                v = f(T)
                by_class[cls_of[T]].add(v)
                count[v] += 1
                if d_of[T] == t:
                    minimal[v].add(cls_of[T])
            constant = all(len(vs) == 1 for vs in by_class.values())
            divisible = all(c % p ** t == 0 for c in count.values())
            residue = all((c // p ** t) % p == len(minimal[v]) % p for v, c in count.items()) if divisible else False
            tight = sorted(v for v, c in count.items() if vp(c, p) == t)
            good = constant and divisible and residue
            ok &= good
            line.append(f"{name}: values={len(count)} tight={len(tight)} {'ok' if good else 'FAIL'}"
                        + ("" if good else f" (const={constant}, div={divisible}, res={residue})"))
            if name in ("height", "childless nodes"):
                detail = ", ".join(f"{v}:{c}" for v, c in sorted(count.items()))
                line.append(f"[{name} counts {detail}; tight {tight}]")
        print("  " + " | ".join(line))
    return ok


if __name__ == "__main__":
    cases = [(2, 1, 9), (3, 1, 6), (5, 1, 4), (2, 2, 5), (3, 2, 3), (2, 3, 3)]
    all_ok = True
    for p, k, nmax in cases:
        all_ok &= run(p, k, nmax)
        sys.stdout.flush()
    print("\nOVERALL:", "ALL CHECKS PASSED" if all_ok else "SOME CHECKS FAILED")

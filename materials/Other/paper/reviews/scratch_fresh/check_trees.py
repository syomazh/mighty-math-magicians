"""Fresh-referee checks, part 1: plane trees, rotation classes, d(T), minimal classes.

Independent of the paper's normal-form lemma: the relation ~ is computed as the
orbit relation of single-node rotations (union-find), then compared with the
canonical form that the normal-form lemma predicts.

Leaf = (), internal node = tuple of p children.
"""
import sys
from functools import lru_cache
from itertools import product
from math import comb, factorial

sys.setrecursionlimit(10000)
LEAF = ()


def digits(m, p):
    out = []
    while m:
        out.append(m % p)
        m //= p
    return out


def s_p(m, p):
    return sum(digits(m, p))


def make_trees(p):
    @lru_cache(maxsize=None)
    def trees(L):
        """all plane p-ary trees with L leaves"""
        if L == 1:
            return (LEAF,)
        if L < p or (L - 1) % (p - 1) != 0:
            return ()
        out = []

        def rec(pos, remaining, acc):
            if pos == p - 1:
                for t in trees(remaining):
                    out.append(tuple(acc) + (t,))
                return
            # each remaining position needs >= 1 leaf
            for a in range(1, remaining - (p - 1 - pos) + 1):
                ts = trees(a)
                if not ts:
                    continue
                for t in ts:
                    rec(pos + 1, remaining - a, acc + [t])

        rec(0, L, [])
        return tuple(out)

    return trees


def leaf_depths(T, d=0, out=None):
    if out is None:
        out = []
    if T == LEAF:
        out.append(d)
    else:
        for c in T:
            leaf_depths(c, d + 1, out)
    return out


def nleaves(T):
    return 1 if T == LEAF else sum(nleaves(c) for c in T)


def single_rotations(T):
    """all trees obtained from T by rotating the children of exactly one node by 1"""
    if T == LEAF:
        return []
    out = [T[1:] + T[:1]]
    for i, c in enumerate(T):
        for c2 in single_rotations(c):
            out.append(T[:i] + (c2,) + T[i + 1:])
    return out


@lru_cache(maxsize=None)
def canon(T):
    """canonical form predicted by the normal-form lemma"""
    if T == LEAF:
        return LEAF
    cs = tuple(canon(c) for c in T)
    p = len(cs)
    return min(cs[r:] + cs[:r] for r in range(p))


@lru_cache(maxsize=None)
def dval(T):
    if T == LEAF:
        return 0
    cs = [canon(c) for c in T]
    asym = 0 if all(c == cs[0] for c in cs) else 1
    return asym + sum(dval(c) for c in T)


def is_complete(T):
    if T == LEAF:
        return True
    return all(c == T[0] for c in T) and is_complete(T[0])


def qary_count(q, n):
    return comb(q * n, n) // ((q - 1) * n + 1)


def expand_qary(q_tree, p, k):
    """blocked form: q-ary tree -> p-ary tree"""
    if q_tree == LEAF:
        return LEAF
    kids = [expand_qary(c, p, k) for c in q_tree]
    for _ in range(k):
        kids = [tuple(kids[i:i + p]) for i in range(0, len(kids), p)]
    assert len(kids) == 1
    return kids[0]


class UF:
    def __init__(self, items):
        self.par = {x: x for x in items}

    def find(self, x):
        while self.par[x] != x:
            self.par[x] = self.par[self.par[x]]
            x = self.par[x]
        return x

    def union(self, a, b):
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.par[ra] = rb


def is_power_of(x, p):
    e = 0
    while x % p == 0:
        x //= p
        e += 1
    return (x == 1), e


def run(p, k, n, full=True):
    q = p ** k
    m = (q - 1) * n + 1
    t = (s_p(m, p) - 1) // (p - 1)
    assert (s_p(m, p) - 1) % (p - 1) == 0
    C = qary_count(q, n)
    trees = make_trees(p)
    all_p = trees(m)
    blocked = [T for T in all_p if all(d % k == 0 for d in leaf_depths(T))]
    # Lemma 2.3: blocked form bijection
    qtrees = make_trees(q)((q - 1) * n + 1)
    img = {expand_qary(Q, p, k) for Q in qtrees}
    assert len(qtrees) == C, (len(qtrees), C)
    assert img == set(blocked), "blocked-form bijection fails"
    # classes by brute force on ALL p-ary trees with m leaves (not only blocked)
    universe = all_p if full else blocked
    uf = UF(universe)
    for T in universe:
        for T2 in single_rotations(T):
            uf.union(T, T2)
    classes = {}
    for T in universe:
        classes.setdefault(uf.find(T), []).append(T)
    # normal form: brute-force classes == canonical-form classes
    by_canon = {}
    for T in universe:
        by_canon.setdefault(canon(T), []).append(T)
    assert sorted(map(sorted, classes.values())) == sorted(map(sorted, by_canon.values())), "normal form fails"
    hist = {}
    nmin_blocked = 0
    for cl in classes.values():
        ds = {dval(T) for T in cl}
        assert len(ds) == 1, "d not class invariant"
        d = ds.pop()
        assert len(cl) == p ** d, ("class size", len(cl), d)
        assert len({tuple(sorted(leaf_depths(T))) for T in cl}) == 1, "leaf depth multiset not invariant"
        assert d >= t or not full, "lower bound"
        assert (d == 0) == is_complete(cl[0])
        bl = all(dd % k == 0 for dd in leaf_depths(cl[0]))
        if bl:
            hist[d] = hist.get(d, 0) + 1
            if d == t:
                nmin_blocked += 1
    total = sum(cnt * p ** d for d, cnt in hist.items())
    assert total == C
    assert min(hist) >= t
    mj = digits(m, p)
    den = 1
    for x in mj:
        den *= factorial(x)
    unit = C // p ** t
    assert C % p ** t == 0
    pred = ((-1) ** t * pow(den, -1, p)) % p
    ok = (unit % p == pred) and (nmin_blocked % p == pred)
    print(f"(p,k,n)=({p},{k},{n}) q={q} m={m} digits(lsb first)={mj} s={s_p(m,p)} t={t} "
          f"C={C} C/p^t={unit} unit mod p={unit % p} predicted={pred} N_min={nmin_blocked} "
          f"blocked classes by d={dict(sorted(hist.items()))} #p-ary trees with m leaves={len(all_p)} OK={ok}")
    assert ok
    return nmin_blocked


if __name__ == "__main__":
    cases = [(2, 1, 3), (2, 1, 6), (3, 1, 2), (3, 1, 3), (2, 2, 2), (2, 2, 3), (3, 2, 2),
             (3, 1, 8), (2, 2, 4), (2, 1, 1), (2, 1, 2), (2, 1, 4), (2, 1, 5), (2, 1, 7), (2, 1, 8), (2, 1, 9),
             (2, 1, 10), (3, 1, 1), (3, 1, 4), (3, 1, 5), (3, 1, 6), (3, 1, 7), (2, 2, 1),
             (2, 3, 1), (5, 1, 1), (5, 1, 2), (5, 1, 3)]
    for c in cases:
        run(*c)
    print("all part-1 checks passed")

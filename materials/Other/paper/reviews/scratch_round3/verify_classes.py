"""Round-3 referee check (fresh reviewer).  Brute force over plane trees.

For each (p, k, n):
  * generate all k-blocked plane p-ary trees with m=(q-1)n+1 leaves (direct generator),
    compare the count with the Fuss-Catalan number, and (small cases) with the image of the
    blocked-form map applied to all plane q-ary trees (Lemma "Blocked form");
  * rotation classes via a canonical form; for small cases cross-check against union-find on
    single-node rotations (the generators (R1)+(R2));
  * class size == p^d (Lemma "Class size"), d constant on classes, d >= t(l), d=0 iff complete
    (Prop "Lower bound"), min d == t;
  * Prop "Local characterization" on every tree and every subtree generated;
  * contraction kappa on minimal trees: atom multiset == digits of m, condition (S),
    constant on classes, injective on classes, image == independently enumerated set of
    cyclic skeleton trees, expansion inverse both ways (Prop "Minimal classes are skeleton trees");
  * N_min == (-1)^t / prod m_j!  (mod p); C/p^t == same; for k=1 the exact count of the Corollary.
"""
import itertools
import sys
import time
from functools import lru_cache
from math import comb, factorial

LEAF = ()


def digits(m, p):
    ds = []
    while m:
        ds.append(m % p)
        m //= p
    return ds


def sp(m, p):
    return sum(digits(m, p))


def fuss(q, n):
    m = (q - 1) * n + 1
    c = comb(q * n, n)
    assert c % m == 0
    return c // m


def comps(m, parts, step):
    """ordered tuples of `parts` positive integers, each == 1 mod step, summing to m"""
    if parts == 1:
        if m >= 1 and (m - 1) % step == 0:
            yield (m,)
        return
    a = 1
    while a <= m - (parts - 1):
        for rest in comps(m - a, parts - 1, step):
            yield (a,) + rest
        a += step


def vec_splits(counts, parts):
    """ordered tuples of `parts` nonzero nonnegative vectors summing to counts"""
    if parts == 1:
        if any(counts):
            yield (counts,)
        return
    ranges = [range(c + 1) for c in counts]
    for v in itertools.product(*ranges):
        if not any(v):
            continue
        rest = tuple(c - x for c, x in zip(counts, v))
        if not any(rest):
            continue
        for tail in vec_splits(rest, parts - 1):
            yield (v,) + tail


class World:
    def __init__(self, p, k):
        self.p, self.k = p, k
        self._gen = {}
        self._canon = {}
        self._d = {}
        self._leaves = {}
        self._comph = {}

    # ---------- generation ----------
    def gen(self, m, phase):
        """plane p-ary trees with m leaves, root at depth == phase mod k, leaves at depth == 0 mod k"""
        key = (m, phase)
        if key in self._gen:
            return self._gen[key]
        p, k = self.p, self.k
        if m == 1:
            res = (LEAF,) if phase % k == 0 else ()
        elif (m - 1) % (p - 1):
            res = ()
        else:
            out = []
            nxt = (phase + 1) % k
            for comp in comps(m, p, p - 1):
                lists = [self.gen(c, nxt) for c in comp]
                if any(not l for l in lists):
                    continue
                out.extend(itertools.product(*lists))
            res = tuple(out)
        self._gen[key] = res
        return res

    # ---------- invariants ----------
    def canon(self, T):
        if T == LEAF:
            return LEAF
        c = self._canon.get(T)
        if c is None:
            ch = tuple(self.canon(x) for x in T)
            c = min(ch[r:] + ch[:r] for r in range(self.p))
            self._canon[T] = c
        return c

    def d(self, T):
        if T == LEAF:
            return 0
        v = self._d.get(T)
        if v is None:
            ch = [self.canon(x) for x in T]
            v = sum(self.d(x) for x in T) + (0 if all(c == ch[0] for c in ch) else 1)
            self._d[T] = v
        return v

    def root_asym(self, T):
        ch = [self.canon(x) for x in T]
        return not all(c == ch[0] for c in ch)

    def leaves(self, T):
        if T == LEAF:
            return 1
        v = self._leaves.get(T)
        if v is None:
            v = sum(self.leaves(x) for x in T)
            self._leaves[T] = v
        return v

    def comph(self, T):
        """height h if T == K_h, else -1"""
        if T == LEAF:
            return 0
        v = self._comph.get(T)
        if v is None:
            hs = [self.comph(x) for x in T]
            v = hs[0] + 1 if hs[0] >= 0 and all(h == hs[0] for h in hs) else -1
            self._comph[T] = v
        return v

    def t_of(self, l):
        s = sp(l, self.p) - 1
        assert s % (self.p - 1) == 0
        return s // (self.p - 1)

    def minimal(self, T):
        return self.d(T) == self.t_of(self.leaves(T))

    def leaf_depths(self, T, depth=0, acc=None):
        if acc is None:
            acc = []
        if T == LEAF:
            acc.append(depth)
        else:
            for x in T:
                self.leaf_depths(x, depth + 1, acc)
        return acc

    # ---------- single-node rotations (generators) ----------
    def neighbours(self, T):
        if T == LEAF:
            return
        yield T[1:] + T[:1]
        for i, x in enumerate(T):
            for y in self.neighbours(x):
                yield T[:i] + (y,) + T[i + 1:]

    # ---------- contraction / expansion ----------
    def kappa(self, T):
        """plane labelled skeleton: ('L', h) or ('N', child, ..., child).  Only for minimal T."""
        h = self.comph(T)
        if h >= 0:
            return ('L', h)
        return ('N',) + tuple(self.kappa(x) for x in T)

    def K(self, h):
        T = LEAF
        for _ in range(h):
            T = (T,) * self.p
        return T

    def expand(self, S):
        if S[0] == 'L':
            return self.K(S[1])
        return tuple(self.expand(x) for x in S[1:])

    def skel_canon(self, S):
        if S[0] == 'L':
            return S
        ch = tuple(self.skel_canon(x) for x in S[1:])
        return ('N',) + min(ch[r:] + ch[:r] for r in range(self.p))

    def skel_atoms(self, S, depth=0, acc=None):
        if acc is None:
            acc = []
        if S[0] == 'L':
            acc.append((S[1], depth))
        else:
            for x in S[1:]:
                self.skel_atoms(x, depth + 1, acc)
        return acc

    def skel_internal(self, S):
        if S[0] == 'L':
            return 0
        return 1 + sum(self.skel_internal(x) for x in S[1:])

    def skeletons(self, m):
        """canonical forms of cyclic skeleton trees for m, enumerated without reference to trees"""
        p, k = self.p, self.k
        ds = tuple(digits(m, p))

        @lru_cache(maxsize=None)
        def gen(counts, phase):
            tot = sum(counts)
            if tot == 1:
                j = counts.index(1)
                return frozenset([('L', j)]) if (phase + j) % k == 0 else frozenset()
            if (tot - 1) % (p - 1):
                return frozenset()
            out = set()
            nxt = (phase + 1) % k
            for split in vec_splits(counts, p):
                lists = [gen(c, nxt) for c in split]
                if any(not l for l in lists):
                    continue
                for ch in itertools.product(*lists):
                    out.add(('N',) + min(ch[r:] + ch[:r] for r in range(p)))
            return frozenset(out)

        return gen(ds, 0)


def qary_trees(q, n):
    """all plane q-ary trees with n internal nodes"""
    @lru_cache(maxsize=None)
    def gen(n):
        if n == 0:
            return (LEAF,)
        out = []

        def rec(parts, left):
            if parts == 1:
                yield (left,)
                return
            for a in range(left + 1):
                for rest in rec(parts - 1, left - a):
                    yield (a,) + rest

        for comp in rec(q, n - 1):
            out.extend(itertools.product(*[gen(c) for c in comp]))
        return tuple(out)

    return gen(n)


def block(T, p, k):
    """blocked-form map: replace each q-ary node by K_k with the q branches at the bottom, left to right"""
    if T == LEAF:
        return LEAF
    layer = [block(x, p, k) for x in T]
    for _ in range(k):
        layer = [tuple(layer[i:i + p]) for i in range(0, len(layer), p)]
    assert len(layer) == 1
    return layer[0]


def check(p, k, n, uf_limit=3000, blocked_limit=30000, verbose=True):
    t0 = time.time()
    q = p ** k
    m = (q - 1) * n + 1
    ds = digits(m, p)
    t = (sum(ds) - 1) // (p - 1)
    assert (sum(ds) - 1) % (p - 1) == 0
    W = World(p, k)
    trees = W.gen(m, 0)
    N = len(trees)
    FC = fuss(q, n)
    assert N == FC, (p, k, n, N, FC)
    assert len(set(trees)) == N

    # Lemma "Blocked form"
    blocked_checked = False
    if N <= blocked_limit:
        img = [block(T, p, k) for T in qary_trees(q, n)]
        assert len(img) == N and len(set(img)) == N and set(img) == set(trees)
        blocked_checked = True

    # classes
    classes = {}
    for T in trees:
        classes.setdefault(W.canon(T), []).append(T)

    # union-find cross-check of the canonical form against the generators
    uf_checked = False
    if N <= uf_limit:
        idx = {T: i for i, T in enumerate(trees)}
        parent = list(range(N))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        for T in trees:
            for U in W.neighbours(T):
                assert U in idx, "rotation left the set of k-blocked trees"
                a, b = find(idx[T]), find(idx[U])
                if a != b:
                    parent[a] = b
        comp = {}
        for T in trees:
            comp.setdefault(find(idx[T]), set()).add(T)
        assert sorted(map(sorted, comp.values())) == sorted(sorted(v) for v in classes.values())
        uf_checked = True

    # class sizes, d-invariance, depth multiset invariance
    dmin = None
    nmin = 0
    hist = {}
    for c, members in classes.items():
        dv = W.d(members[0])
        assert all(W.d(T) == dv for T in members)
        assert len(members) == p ** dv, (p, k, n, len(members), dv)
        if N <= 60000:
            ld = sorted(W.leaf_depths(members[0]))
            assert all(sorted(W.leaf_depths(T)) == ld for T in members)
        assert dv >= t
        hist[dv] = hist.get(dv, 0) + 1
        dmin = dv if dmin is None else min(dmin, dv)
        if dv == t:
            nmin += 1
    assert dmin == t, (p, k, n, dmin, t)
    assert sum(cnt * p ** dv for dv, cnt in hist.items()) == FC

    # Prop "Lower bound" and "Local characterization" on every generated tree (all phases, all sizes)
    nloc = 0
    for (mm, ph), lst in list(W._gen.items()):
        for T in lst:
            l = W.leaves(T)
            assert l == mm
            tt = W.t_of(l)
            dv = W.d(T)
            assert dv >= tt
            assert (dv == 0) == (W.comph(T) >= 0)
            if T != LEAF:
                is_min = dv == tt
                a = [W.leaves(x) for x in T]
                carry_free = sum(sp(x, p) for x in a) == sp(l, p)
                # column criterion of the digit lemma
                L = max(len(digits(x, p)) for x in a)
                col = all(sum((digits(x, p) + [0] * L)[j] for x in a) < p for j in range(L))
                assert carry_free == col
                rhs = (W.comph(T) >= 0) or (W.root_asym(T) and all(W.minimal(x) for x in T) and carry_free)
                assert is_min == rhs, (p, k, T)
                nloc += 1

    # Prop "Minimal classes are skeleton trees"
    skel_indep = W.skeletons(m)
    image = {}
    for c, members in classes.items():
        if W.d(members[0]) != t:
            continue
        ks = set()
        for T in members:
            S = W.kappa(T)
            atoms = W.skel_atoms(S)
            cnt = [0] * len(ds)
            for (j, r) in atoms:
                assert j < len(ds)
                cnt[j] += 1
                assert (r + j) % k == 0, "condition (S) fails"
            assert cnt == ds, "atom multiset != digits"
            assert W.skel_internal(S) == t
            assert W.expand(S) == T, "expansion does not undo contraction"
            ks.add(W.skel_canon(S))
        assert len(ks) == 1, "contraction not constant on a class"
        s = ks.pop()
        assert s not in image, "contraction not injective on classes"
        image[s] = c
    assert set(image) == set(skel_indep), (p, k, n, len(image), len(skel_indep))
    for S in skel_indep:
        T = W.expand(S)
        assert W.leaves(T) == m
        assert all(dd % k == 0 for dd in W.leaf_depths(T))
        assert W.d(T) == t
        assert W.canon(T) == image[S]
        assert W.kappa(T) == S or W.skel_canon(W.kappa(T)) == S

    # congruences
    prod = 1
    for dj in ds:
        prod *= factorial(dj)
    assert prod % p != 0
    pred = ((-1) ** t * pow(prod, -1, p)) % p
    assert nmin % p == pred, (p, k, n, nmin, pred)
    assert FC % (p ** t) == 0 and (FC // p ** t) % p == pred
    exact = None
    if k == 1:
        num = factorial(p * t)
        den = factorial(t) * p ** t * prod
        assert num % den == 0
        exact = num // den
        assert exact == nmin, (p, n, exact, nmin)
    if verbose:
        print(f"p={p} k={k} n={n:2d} m={m:3d} digits(lsb first)={ds} t={t} trees={N} classes={len(classes)} "
              f"N_min={nmin} skeletons={len(skel_indep)} pred_mod_p={pred} d-hist={dict(sorted(hist.items()))} "
              f"[blocked-map:{'y' if blocked_checked else '-'} union-find:{'y' if uf_checked else '-'} "
              f"local-char trees:{nloc}] {time.time() - t0:.1f}s")
    return nmin


if __name__ == "__main__":
    plan = [
        (2, 1, range(1, 13)),
        (3, 1, range(1, 9)),
        (5, 1, range(1, 7)),
        (7, 1, range(1, 6)),
        (2, 2, range(1, 8)),
        (3, 2, range(1, 6)),
        (5, 2, range(1, 4)),
        (2, 3, range(1, 6)),
        (3, 3, range(1, 4)),
        (2, 4, range(1, 5)),
    ]
    if len(sys.argv) > 1 and sys.argv[1] == "quick":
        plan = [(2, 1, range(1, 8)), (3, 1, range(1, 6)), (2, 2, range(1, 5)), (2, 3, range(1, 4)), (3, 2, range(1, 4))]
    total = 0
    for p, k, rng in plan:
        for n in rng:
            check(p, k, n)
            total += 1
    print(f"ALL {total} CASES PASSED")

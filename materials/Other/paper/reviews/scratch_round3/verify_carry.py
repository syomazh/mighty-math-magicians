"""Round-3 referee check: the labelled count T(a), freeness, the carry proposition, terminal vectors.

T(a) = number of isomorphism classes of cyclic p-ary trees whose leaves carry a_c distinct labels of
class c (c in Z_k), a class-c leaf lying at depth == -c (mod k).

Brute force (explicit canonical trees):
  * T(a) for every vector a with sum(a) <= S;
  * Lemma "Terminal vectors": if all a_c < p then T(a) = [a == e_0];
  * Prop "A carry collapses a cherry": for every c with a_c >= p, with sigma the p-cycle on p chosen
    labels of class c: #Fix(sigma) == (p-1) * T(a - p e_c + e_{c+1})  (exactly), every fixed tree has the
    chosen labels as a cherry, and T(a) == -T(a') (mod p);
  * Lemmas "Automorphisms" / "Moving leaves" indirectly through the fixed-point structure;
  * freeness of H (Prop "Removing labelling"): for vectors coming from digits of m, the orbits of
    H = prod S_{m_j} on labelled trees all have size |H|, and #orbits == number of unlabelled skeletons.
Count-only recursion (uses "all p rotations distinct"), cross-validated on the brute-force range, then
used on a larger range for: iterated carries T(a) == (-1)^t (mod p) when m == 1 (mod q-1), and a
counterexample search showing the hypothesis m == 1 (mod q-1) is needed.
"""
import itertools
import sys
from functools import lru_cache
from math import comb, factorial


def digits(m, p):
    ds = []
    while m:
        ds.append(m % p)
        m //= p
    return ds


def set_splits(mask, parts):
    """ordered tuples of `parts` nonempty disjoint submasks with union mask"""
    if parts == 1:
        if mask:
            yield (mask,)
        return
    sub = mask
    while sub:
        rest = mask ^ sub
        if rest:
            for tail in set_splits(rest, parts - 1):
                yield (sub,) + tail
        sub = (sub - 1) & mask


def lab_trees(p, k, cls):
    """canonical forms of labelled cyclic trees; cls[i] = class of label i"""
    s = len(cls)

    @lru_cache(maxsize=None)
    def gen(mask, phase):
        if mask & (mask - 1) == 0:
            i = mask.bit_length() - 1
            return (('L', i),) if (phase + cls[i]) % k == 0 else ()
        cnt = bin(mask).count('1')
        if (cnt - 1) % (p - 1):
            return ()
        out = set()
        nxt = (phase + 1) % k
        low = mask & -mask
        for split in set_splits(mask, p):
            if not split[0] & low:
                continue  # one representative per rotation; canonicalised again below anyway
            lists = [gen(b, nxt) for b in split]
            if any(not l for l in lists):
                continue
            for ch in itertools.product(*lists):
                out.add(('N',) + min(ch[r:] + ch[:r] for r in range(p)))
        return tuple(sorted(out))

    return gen((1 << s) - 1, 0) if s else ()


def relabel(S, perm, p):
    if S[0] == 'L':
        return ('L', perm[S[1]])
    ch = tuple(relabel(x, perm, p) for x in S[1:])
    return ('N',) + min(ch[r:] + ch[:r] for r in range(p))


def cherries(S):
    """list of frozensets of labels of nodes all of whose children are leaves"""
    if S[0] == 'L':
        return []
    out = []
    if all(x[0] == 'L' for x in S[1:]):
        out.append(frozenset(x[1] for x in S[1:]))
    for x in S[1:]:
        out.extend(cherries(x))
    return out


def classes_of(a):
    cls = []
    for c, n in enumerate(a):
        cls.extend([c] * n)
    return cls


def brute_T(p, k, a, cache={}):
    key = (p, k, tuple(a))
    if key not in cache:
        cache[key] = lab_trees(p, k, classes_of(a))
    return cache[key]


def count_T(p, k):
    """count-only recursion: T(a, phase) = (1/p) sum over ordered splits of multinomials * products"""
    @lru_cache(maxsize=None)
    def T(a, phase):
        tot = sum(a)
        if tot == 0:
            return 0
        if tot == 1:
            c = a.index(1)
            return 1 if (phase + c) % k == 0 else 0
        if (tot - 1) % (p - 1):
            return 0
        nxt = (phase + 1) % k
        total = 0

        def rec(rem, parts, weight):
            nonlocal total
            if parts == 1:
                if any(rem):
                    v = T(rem, nxt)
                    if v:
                        total += weight * v
                return
            for v in itertools.product(*[range(x + 1) for x in rem]):
                if not any(v):
                    continue
                rest = tuple(x - y for x, y in zip(rem, v))
                if not any(rest):
                    continue  # the remaining parts must be nonempty
                tv = T(v, nxt)
                if not tv:
                    continue
                w = weight * tv
                for x, y in zip(rem, v):
                    w *= comb(x, y)
                rec(rest, parts - 1, w)

        rec(a, p, 1)
        assert total % p == 0
        return total // p

    return T


def vectors(k, S):
    for a in itertools.product(range(S + 1), repeat=k):
        if 1 <= sum(a) <= S:
            yield a


def brute_checks(p, k, S):
    Tc = count_T(p, k)
    nvec = ncarry = nterm = 0
    for a in vectors(k, S):
        trees = brute_T(p, k, a)
        T = len(trees)
        assert T == Tc(a, 0), (p, k, a, T, Tc(a, 0))
        nvec += 1
        if all(x < p for x in a):
            e0 = tuple(1 if c == 0 else 0 for c in range(k))
            assert T == (1 if a == e0 else 0), (p, k, a, T)
            nterm += 1
        cls = classes_of(a)
        for c in range(k):
            if a[c] < p:
                continue
            chosen = [i for i, x in enumerate(cls) if x == c][:p]
            perm = list(range(len(cls)))
            for j in range(p):
                perm[chosen[j]] = chosen[(j + 1) % p]
            fixed = [S_ for S_ in trees if relabel(S_, perm, p) == S_]
            ap = list(a)
            ap[c] -= p
            ap[(c + 1) % k] += 1
            Tp = len(brute_T(p, k, tuple(ap)))
            assert len(fixed) == (p - 1) * Tp, (p, k, a, c, len(fixed), Tp)
            assert (T + Tp) % p == 0, (p, k, a, c, T, Tp)
            cs = frozenset(chosen)
            assert all(cs in cherries(S_) for S_ in fixed)
            # every tree in which the chosen labels form a cherry in one of the p-1 "affine" orders is fixed:
            ncarry += 1
    print(f"p={p} k={k} total labels <= {S}: {nvec} vectors, {nterm} terminal vectors, {ncarry} carry instances: OK")


def freeness_checks(p, k, mmax):
    """for m <= mmax with s_p(m) small: H-orbits on labelled skeleton trees are free; count orbits"""
    q = p ** k
    done = 0
    for m in range(1, mmax + 1):
        ds = digits(m, p)
        s = sum(ds)
        if s > (7 if p == 2 else 7 if p == 3 else 9):
            continue
        a = [0] * k
        height = []
        for j, dj in enumerate(ds):
            a[j % k] += dj
        # label order must match classes_of(a): sort labels by class, remember heights
        labs = sorted([(j % k, j, i) for j, dj in enumerate(ds) for i in range(dj)])
        height = [j for (_, j, _) in labs]
        trees = brute_T(p, k, tuple(a))
        if not trees:
            assert (m - 1) % (q - 1) != 0 or False, (p, k, m)
            continue
        # H = product of symmetric groups on labels of equal height
        groups = {}
        for i, h in enumerate(height):
            groups.setdefault(h, []).append(i)
        perms = [{}]
        for h, idxs in groups.items():
            new = []
            for base in perms:
                for pi in itertools.permutations(idxs):
                    dct = dict(base)
                    dct.update(dict(zip(idxs, pi)))
                    new.append(dct)
            perms = new
        H = len(perms)
        assert H == eval('*'.join(str(factorial(d)) for d in ds))
        tset = set(trees)
        seen = set()
        orbits = 0
        for S_ in trees:
            if S_ in seen:
                continue
            orb = {relabel(S_, [pi[i] for i in range(len(height))], p) for pi in perms}
            assert orb <= tset
            assert len(orb) == H, (p, k, m, len(orb), H)  # free
            seen |= orb
            orbits += 1
        # unlabelled skeletons: forget labels to heights
        def forget(S_):
            if S_[0] == 'L':
                return ('L', height[S_[1]])
            ch = tuple(forget(x) for x in S_[1:])
            return ('N',) + min(ch[r:] + ch[:r] for r in range(p))
        unl = {forget(S_) for S_ in trees}
        assert len(unl) == orbits == len(trees) // H
        t = (s - 1) // (p - 1)
        if (m - 1) % (q - 1) == 0:
            assert len(trees) % p == (-1) ** t % p, (p, k, m)
        done += 1
    print(f"p={p} k={k} m <= {mmax}: freeness of H and orbit count == unlabelled skeleton count on {done} values of m: OK")


def iterated(p, k, mmax):
    """T(a) == (-1)^t mod p for m == 1 mod (q-1); and what happens otherwise"""
    q = p ** k
    Tc = count_T(p, k)
    good = bad_hyp = 0
    for m in range(1, mmax + 1):
        ds = digits(m, p)
        s = sum(ds)
        if s > (13 if p == 2 else 11 if p == 3 else 9):
            continue
        a = [0] * k
        for j, dj in enumerate(ds):
            a[j % k] += dj
        T = Tc(tuple(a), 0)
        if (m - 1) % (q - 1) == 0:
            t = (s - 1) // (p - 1)
            assert T % p == (-1) ** t % p, (p, k, m, T)
            # carry chain, any order: first available class
            b = list(a)
            r = 0
            while any(x >= p for x in b):
                c = max(i for i, x in enumerate(b) if x >= p)
                b[c] -= p
                b[(c + 1) % k] += 1
                r += 1
            assert b == [1] + [0] * (k - 1) and r == t, (p, k, m, b, r, t)
            good += 1
        else:
            # no k-blocked tree with m leaves exists; the carry chain must end at a terminal vector != e_0
            assert T == 0, (p, k, m, T)
            bad_hyp += 1
    print(f"p={p} k={k} m <= {mmax}: T(a) == (-1)^t mod p on {good} values with m == 1 mod (q-1); "
          f"T(a) == 0 on {bad_hyp} values with m != 1 mod (q-1) (hypothesis is needed)")


if __name__ == "__main__":
    brute_checks(2, 1, 7)
    brute_checks(2, 2, 7)
    brute_checks(2, 3, 6)
    brute_checks(3, 1, 7)
    brute_checks(3, 2, 7)
    brute_checks(3, 3, 5)
    brute_checks(5, 1, 5)
    brute_checks(5, 2, 5)
    freeness_checks(2, 1, 130)
    freeness_checks(2, 2, 130)
    freeness_checks(2, 3, 130)
    freeness_checks(3, 1, 250)
    freeness_checks(3, 2, 250)
    freeness_checks(5, 1, 130)
    for (p, k, mm) in [(2, 1, 600), (2, 2, 600), (2, 3, 600), (2, 4, 600), (3, 1, 800), (3, 2, 800), (3, 3, 800),
                       (5, 1, 700), (5, 2, 700), (7, 1, 400)]:
        iterated(p, k, mm)
    print("ALL CARRY CHECKS PASSED")

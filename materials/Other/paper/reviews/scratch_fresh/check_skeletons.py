"""Fresh-referee checks, part 2: cyclic labelled trees T(a), skeleton trees, the
carry congruence, the fixed-point count, automorphism lemmas, the digit lemma,
termination of the carry process, exact count for k=1.

A labelled plane tree is a nested tuple whose leaves are labels (cls, idx)
(or, for skeletons with indistinguishable atoms, plain integers = atom heights).
"""
import sys
from functools import lru_cache
from itertools import permutations, product
from math import comb, factorial

sys.path.insert(0, __file__.rsplit("\\", 1)[0].rsplit("/", 1)[0])
from check_trees import make_trees, LEAF, digits, s_p, run as run_trees, canon as canon_plain, dval, leaf_depths


def is_leaf(x, labelled=True):
    return not (isinstance(x, tuple) and len(x) > 0 and isinstance(x[0], tuple) is not None and _is_node(x))


def _is_node(x):
    # nodes are tuples tagged with a leading marker "N"
    return isinstance(x, tuple) and len(x) > 0 and x[0] == "N"


def node(children):
    return ("N",) + tuple(children)


def kids(x):
    return x[1:]


def ccanon(x):
    """canonical form of a labelled cyclic tree (leaves = arbitrary comparable labels wrapped as ('L', label))"""
    if not _is_node(x):
        return x
    cs = tuple(ccanon(c) for c in kids(x))
    p = len(cs)
    return node(min(cs[r:] + cs[:r] for r in range(p)))


def fill(shape, labels_iter):
    if shape == LEAF:
        return ("L", next(labels_iter))
    return node(fill(c, labels_iter) for c in shape)


def label_depths(x, d=0, out=None):
    if out is None:
        out = []
    if not _is_node(x):
        out.append((x[1], d))
    else:
        for c in kids(x):
            label_depths(c, d + 1, out)
    return out


def brute_labelled(p, k, a):
    """set of canonical labelled cyclic trees counted by T(a); labels are (cls, idx)"""
    labels = [(c, i) for c in range(k) for i in range(a[c])]
    s = len(labels)
    trees = make_trees(p)
    out = set()
    if s == 0:
        return out
    for shape in trees(s):
        depths = leaf_depths(shape)  # left-to-right
        for perm in permutations(labels):
            if all((d + lab[0]) % k == 0 for lab, d in zip(perm, depths)):
                out.add(ccanon(fill(shape, iter(perm))))
    return out


def make_T(p, k):
    """T(a) by a recurrence (independent of the carry argument):
    N(b, delta) = number of labelled cyclic trees on a label set with class vector b whose root is at depth = delta mod k.
    A non-leaf cyclic tree = ordered p-tuple of trees on disjoint nonempty label sets, modulo rotation (free, since the sets are disjoint)."""

    @lru_cache(maxsize=None)
    def N(b, delta):
        s = sum(b)
        if s == 0:
            return 0
        if s == 1:
            c = b.index(1)
            return 1 if (delta + c) % k == 0 else 0
        if (s - 1) % (p - 1) != 0:
            return 0
        # ordered p-tuples of nonempty vectors summing to b, weighted by multinomials
        total = ordered(b, p, (delta + 1) % k)
        assert total % p == 0
        return total // p

    @lru_cache(maxsize=None)
    def ordered(b, parts, delta):
        """number of ways to split label set (vector b) into `parts` ordered nonempty blocks and put a tree on each"""
        if parts == 0:
            return 1 if sum(b) == 0 else 0
        if sum(b) < parts:
            return 0
        tot = 0
        for sub in product(*[range(x + 1) for x in b]):
            if sum(sub) == 0 or sum(b) - sum(sub) < parts - 1:
                continue
            w = N(tuple(sub), delta)
            if w == 0:
                continue
            ways = 1
            for x, y in zip(b, sub):
                ways *= comb(x, y)
            rest = tuple(x - y for x, y in zip(b, sub))
            tot += ways * w * ordered(rest, parts - 1, delta)
        return tot

    return lambda a: N(tuple(a), 0)


def check_T_bruteforce():
    print("-- T(a): recurrence vs brute force enumeration of canonical labelled cyclic trees")
    for p, k, maxs in [(2, 1, 6), (2, 2, 6), (2, 3, 6), (3, 1, 7), (3, 2, 7), (5, 1, 5), (5, 2, 5)]:
        T = make_T(p, k)
        cnt = 0
        for a in product(range(maxs + 1), repeat=k):
            if not (1 <= sum(a) <= maxs):
                continue
            bf = len(brute_labelled(p, k, a))
            assert bf == T(a), (p, k, a, bf, T(a))
            cnt += 1
        print(f"   p={p} k={k}: {cnt} vectors with total <= {maxs} agree")


def check_carry():
    print("-- carry congruence T(a) = (p-1) T(a') mod p, all classes c with a_c >= p (incl. wrap-around c=k-1)")
    for p, k, bound in [(2, 1, 14), (2, 2, 9), (2, 3, 6), (3, 1, 15), (3, 2, 8), (3, 3, 5), (5, 1, 17), (5, 2, 9), (7, 1, 15)]:
        T = make_T(p, k)
        n = 0
        nz = 0
        for a in product(range(bound + 1), repeat=k):
            for c in range(k):
                if a[c] >= p:
                    a2 = list(a)
                    a2[c] -= p
                    a2[(c + 1) % k] += 1
                    lhs, rhs = T(a), T(tuple(a2))
                    assert (lhs - (p - 1) * rhs) % p == 0, (p, k, a, c, lhs, rhs)
                    n += 1
                    nz += (lhs % p != 0)
        print(f"   p={p} k={k} entries<= {bound}: {n} (a,c) pairs checked, {nz} with T(a) nonzero mod p")


def check_fixed_points():
    print("-- exact fixed-point count |Fix(sigma)| = (p-1) T(a') by brute force")
    for p, k, vecs in [
        (2, 1, [(2,), (3,), (4,), (5,), (6,)]),
        (2, 2, [(2, 1), (0, 2), (2, 0), (1, 2), (3, 1), (2, 3), (4, 1), (3, 3), (2, 2), (1, 4)]),
        (3, 1, [(3,), (5,), (7,)]),
        (3, 2, [(3, 2), (0, 3), (3, 0), (1, 4), (4, 1), (3, 4), (4, 3), (6, 1), (1, 6)]),
        (5, 1, [(5,)]),
        (5, 2, [(0, 5), (5, 0), (5, 4), (4, 5)]),
    ]:
        T = make_T(p, k)
        for a in vecs:
            X = brute_labelled(p, k, a)
            assert len(X) == T(a)
            for c in range(k):
                if a[c] < p:
                    continue
                chosen = [(c, i) for i in range(p)]
                sig = {chosen[i]: chosen[(i + 1) % p] for i in range(p)}

                def relabel(x):
                    if not _is_node(x):
                        return ("L", sig.get(x[1], x[1]))
                    return node(relabel(y) for y in kids(x))

                fixed = [x for x in X if ccanon(relabel(x)) == x]
                a2 = list(a)
                a2[c] -= p
                a2[(c + 1) % k] += 1
                assert len(fixed) == (p - 1) * T(tuple(a2)), (p, k, a, c, len(fixed), T(tuple(a2)))
                # every fixed tree has the chosen labels as the full child set of one node
                for x in fixed:
                    assert has_cherry(x, set(chosen)), (p, k, a, c, x)
                assert (len(X) - len(fixed)) % p == 0
                print(f"   p={p} k={k} a={a} c={c}: T(a)={len(X)} |Fix|={len(fixed)} (p-1)T(a')={(p-1)*T(tuple(a2))} a'={tuple(a2)}")


def has_cherry(x, labelset):
    if not _is_node(x):
        return False
    ks = kids(x)
    if all(not _is_node(y) for y in ks) and {y[1] for y in ks} == labelset:
        return True
    return any(has_cherry(y, labelset) for y in ks)


def check_termination_and_T():
    print("-- carry process from the digits of m=(q-1)n+1: terminal vector e_0, #carries = t, T(a) = (-1)^t mod p; all orders of carries")
    for p, k in [(2, 1), (2, 2), (2, 3), (2, 4), (3, 1), (3, 2), (3, 3), (5, 1), (5, 2), (7, 1), (7, 2)]:
        q = p ** k
        T = make_T(p, k)
        for n in range(0, 400):
            m = (q - 1) * n + 1
            dg = digits(m, p)
            a = [0] * k
            for j, x in enumerate(dg):
                a[j % k] += x
            t = (sum(dg) - 1) // (p - 1)
            # explore every possible order of carries
            seen = set()
            stack = [(tuple(a), 0)]
            while stack:
                b, r = stack.pop()
                if (b, r) in seen:
                    continue
                seen.add((b, r))
                cs = [c for c in range(k) if b[c] >= p]
                if not cs:
                    e0 = tuple(1 if c == 0 else 0 for c in range(k))
                    assert b == e0 and r == t, (p, k, n, b, r, t)
                for c in cs:
                    b2 = list(b)
                    b2[c] -= p
                    b2[(c + 1) % k] += 1
                    stack.append((tuple(b2), r + 1))
            if sum(a) <= (9 if p == 2 else 11):
                assert (T(tuple(a)) - (-1) ** t) % p == 0, (p, k, n, a, T(tuple(a)))
        print(f"   p={p} k={k}: n=0..399 OK")
    # the literal statement fails without m = 1 mod (q-1):
    p, k, m = 2, 2, 2
    T = make_T(p, k)
    print(f"   (hypothesis check) p=2,k=2,m=2: a=(0,1), t=0, T(a)={T((0,1))} (so the hypothesis m=1 mod q-1 is needed in the statement)")


def check_skeletons_and_Nmin():
    print("-- N_min (brute-force classes of blocked trees) vs #unlabelled skeletons vs T(a)/prod m_j!, plus exact count for k=1")
    for p, k, n in [(2, 1, 3), (2, 1, 6), (3, 1, 2), (3, 1, 3), (2, 2, 2), (2, 2, 3), (3, 2, 2), (3, 1, 8), (2, 2, 4),
                    (2, 1, 10), (3, 1, 6), (5, 1, 3), (2, 1, 4), (2, 1, 5), (3, 1, 5), (3, 1, 7)]:
        q = p ** k
        m = (q - 1) * n + 1
        dg = digits(m, p)
        t = (sum(dg) - 1) // (p - 1)
        # labelled trees: labels (height j, idx)
        atoms = [(j, i) for j, x in enumerate(dg) for i in range(x)]
        s = len(atoms)
        trees = make_trees(p)
        lab = set()
        unl = set()
        for shape in trees(s):
            depths = leaf_depths(shape)
            for perm in permutations(atoms):
                if all((d + at[0]) % k == 0 for at, d in zip(perm, depths)):
                    lab.add(ccanon(fill(shape, iter(perm))))
                    unl.add(ccanon(fill(shape, iter([at[0] for at in perm]))))
        den = 1
        for x in dg:
            den *= factorial(x)
        a = [0] * k
        for j, x in enumerate(dg):
            a[j % k] += x
        T = make_T(p, k)
        assert len(lab) == T(tuple(a))
        assert len(lab) == den * len(unl), "H-action not free?"
        # S1 for every unlabelled skeleton
        for x in unl:
            assert s1_holds(x)
        # expansion of each unlabelled skeleton is a minimal k-blocked tree with m leaves, distinct classes
        exp_classes = set()
        for x in unl:
            E = expand(x, p)
            assert all(d % k == 0 for d in leaf_depths(E))
            assert len(leaf_depths(E)) == m
            assert dval(E) == t
            exp_classes.add(canon_plain(E))
        assert len(exp_classes) == len(unl)
        nmin = run_trees(p, k, n, full=False) if True else None
        assert nmin == len(unl), (nmin, len(unl))
        msg = f"   (p,k,n)=({p},{k},{n}): m={m} a={tuple(a)} T(a)={len(lab)} prod m_j!={den} skeletons={len(unl)} N_min={nmin}"
        if k == 1:
            exact = factorial(p * t) // (factorial(t) * p ** t * den)
            assert factorial(p * t) % (factorial(t) * p ** t * den) == 0
            assert exact == nmin
            msg += f" exact formula={exact}"
        print(msg)


def s1_holds(x):
    if not _is_node(x):
        return True
    cs = [ccanon(c) for c in kids(x)]
    if all(c == cs[0] for c in cs):
        return False
    return all(s1_holds(c) for c in kids(x))


def complete(h, p):
    T = LEAF
    for _ in range(h):
        T = tuple([T] * p)
    return T


def expand(x, p):
    if not _is_node(x):
        return complete(x[1], p)
    return tuple(expand(c, p) for c in kids(x))


def check_digit_lemma():
    print("-- digit lemma for r summands (r<=4), p in {2,3,5}: subadditivity, multiple of p-1, equality iff no carries")
    for p in (2, 3, 5):
        for r in (2, 3, 4):
            rng = range(0, {2: 40, 3: 18, 4: 9}[r] if p != 2 else {2: 64, 3: 20, 4: 10}[r])
            for tup in product(rng, repeat=r):
                lhs = s_p(sum(tup), p)
                rhs = sum(s_p(x, p) for x in tup)
                assert lhs <= rhs and (rhs - lhs) % (p - 1) == 0
                L = max(len(digits(x, p)) for x in tup) if any(tup) else 0
                nocarry = all(sum((x // p ** j) % p for x in tup) < p for j in range(L + 1))
                assert (lhs == rhs) == nocarry, (p, tup)
    print("   OK")


# ---- automorphisms of unlabelled cyclic trees (Lemma 5.1, Lemma 5.3) ----

def leaves_of(shape, path=()):
    if shape == LEAF:
        return [path]
    out = []
    for i, c in enumerate(shape):
        out += leaves_of(c, path + (i,))
    return out


def isos(A, B):
    """all cyclic isomorphisms A -> B as dicts path->path on ALL nodes (incl. leaves)"""
    if A == LEAF or B == LEAF:
        return [{(): ()}] if A == B else []
    p = len(A)
    res = []
    for r in range(p):
        # child i of A goes to child (i+r) of B
        parts = []
        ok = True
        for i in range(p):
            sub = isos(A[i], B[(i + r) % p])
            if not sub:
                ok = False
                break
            parts.append(sub)
        if not ok:
            continue
        for combo in product(*parts):
            mp = {(): ()}
            for i, sm in enumerate(combo):
                for a_, b_ in sm.items():
                    mp[(i,) + a_] = ((i + r) % p,) + b_
            res.append(mp)
    return res


def check_automorphisms():
    print("-- automorphism groups of unlabelled cyclic trees: order is a power of p; leaf-fixing => identity; moving-leaf lemma")
    for p, maxL in [(2, 9), (3, 11), (5, 13)]:
        trees = make_trees(p)
        seen = set()
        ngroups = 0
        nmoving = 0
        for L in range(1, maxL + 1):
            for shape in trees(L):
                cf = canon_plain(shape)
                if cf in seen:
                    continue
                seen.add(cf)
                auts = isos(shape, shape)
                if len(auts) > 20000:
                    continue
                g = len(auts)
                x = g
                while x % p == 0:
                    x //= p
                assert x == 1, (p, shape, g)
                lv = leaves_of(shape)
                ident = 0
                for al in auts:
                    moved = [l for l in lv if al[l] != l]
                    if not moved:
                        assert all(al[v] == v for v in al)
                        ident += 1
                    # alpha^p == 1 ?
                    def power_is_identity(al):
                        for v in al:
                            w = v
                            for _ in range(p):
                                w = al[w]
                            if w != v:
                                return False
                        return True
                    if len(moved) == p and power_is_identity(al):
                        parents = {l[:-1] for l in moved}
                        assert len(parents) == 1, (p, shape, moved)
                        nmoving += 1
                assert ident == 1
                ngroups += 1
        print(f"   p={p}: {ngroups} cyclic tree shapes up to {maxL} leaves; {nmoving} automorphisms with alpha^p=1 moving exactly p leaves, all are sibling sets")


def composite_sanity():
    print("-- sanity: with composite arity 4 the class-size lemma fails (shows the script can detect failure)")
    trees = make_trees(4)
    from check_trees import UF, single_rotations
    U = trees(10)
    uf = UF(U)
    for T in U:
        for T2 in single_rotations(T):
            uf.union(T, T2)
    sizes = {}
    for T in U:
        sizes.setdefault(uf.find(T), 0)
        sizes[uf.find(T)] += 1
    print("   4-ary trees with 10 leaves: class sizes", sorted(set(sizes.values())))


if __name__ == "__main__":
    check_digit_lemma()
    check_T_bruteforce()
    check_carry()
    check_fixed_points()
    check_termination_and_T()
    check_skeletons_and_Nmin()
    check_automorphisms()
    composite_sanity()
    print("all part-2 checks passed")

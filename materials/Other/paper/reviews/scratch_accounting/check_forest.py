# Written by Claude Fable 5.2 (fresh-context referee subagent), 2026-11-14.
# Referee check of paper/accounting_proof.tex, Section 3: Lemma 2, Lemma 3 (with both sub-claims)
# and the recursion (1), by explicit enumeration of digit-forest structures.  Pure stdlib.
# Run: uv run python check_forest.py
#
# A cyclic complete p-ary tree of height j on a point set is stored canonically: height 0 = the point
# (an int); height j = a p-tuple of canonical trees of height j-1, rotated so that the child containing
# the smallest point comes first.  A digit-forest structure is a frozenset of such trees.
import itertools
import sys
from math import comb, factorial


def digits(m, p):
    d = []
    while m:
        d.append(m % p)
        m //= p
    return d


def nu(m, p):
    return (m - sum(digits(m, p))) // (p - 1)


# ---------- constructive enumeration (does not use the symmetric group) ----------
def ordered_blocks(points, size, nblocks):
    """All ways to split the tuple `points` into an ORDERED sequence of nblocks blocks of given size."""
    if nblocks == 0:
        yield ()
        return
    for blk in itertools.combinations(points, size):
        s = set(blk)
        rest = tuple(x for x in points if x not in s)
        for tail in ordered_blocks(rest, size, nblocks - 1):
            yield (blk,) + tail


def trees_on(points, p, j):
    """All cyclic complete p-ary trees of height j with leaf set `points` (sorted tuple), canonical form."""
    if j == 0:
        yield points[0]
        return
    size = p ** (j - 1)
    mn, rest = points[0], points[1:]
    for c1 in itertools.combinations(rest, size - 1):
        s = set(c1)
        first = (mn,) + c1
        remaining = tuple(x for x in rest if x not in s)
        for tail in ordered_blocks(remaining, size, p - 1):
            for kids in itertools.product(*[list(trees_on(b, p, j - 1)) for b in (first,) + tail]):
                yield tuple(kids)


def forests(points, counts, p):
    """All digit-forest structures on `points` (sorted tuple) with counts[j] trees of height j."""
    if not points:
        yield frozenset()
        return
    mn, rest = points[0], points[1:]
    for j, cj in enumerate(counts):
        if cj == 0:
            continue
        for c in itertools.combinations(rest, p ** j - 1):
            s = set(c)
            block = (mn,) + c
            remaining = tuple(x for x in rest if x not in s)
            nc = list(counts)
            nc[j] -= 1
            for tr in trees_on(block, p, j):
                for f in forests(remaining, nc, p):
                    yield f | {tr}


# ---------- action of permutations ----------
def recanon(tr, perm):
    """Relabel leaves by perm (dict or list) and return (min leaf, canonical form)."""
    if not isinstance(tr, tuple):
        v = perm[tr]
        return v, v
    kids = [recanon(c, perm) for c in tr]
    i = min(range(len(kids)), key=lambda t: kids[t][0])
    kids = kids[i:] + kids[:i]
    return kids[0][0], tuple(r for _, r in kids)


def act(struct, perm):
    return frozenset(recanon(tr, perm)[1] for tr in struct)


def height(tr):
    h = 0
    while isinstance(tr, tuple):
        tr = tr[0]
        h += 1
    return h


def leaves(tr):
    if not isinstance(tr, tuple):
        return [tr]
    out = []
    for c in tr:
        out.extend(leaves(c))
    return out


# ---------- decomposition of Lemma 3 ----------
def decompose(struct):
    """(R, set of cherries as canonical cyclic p-tuples, contracted structure on cherry labels).
    A cherry is labelled by its smallest point."""
    R = frozenset(tr for tr in struct if not isinstance(tr, tuple))
    cherries = set()

    def contract(tr):
        if not isinstance(tr[0], tuple):          # lowest internal node: children are points
            cherries.add(tr)
            return tr[0]                          # canonical form has the smallest point first
        return tuple(contract(c) for c in tr)

    contracted = frozenset(contract(tr) for tr in struct if isinstance(tr, tuple))
    return R, frozenset(cherries), contracted


def perms_all_cycles_p(points, p):
    """All permutations of `points` with every cycle of length p, as frozensets of cyclic p-tuples
    (smallest element first)."""
    if not points:
        yield frozenset()
        return
    mn, rest = points[0], points[1:]
    for others in itertools.permutations(rest, p - 1):
        s = set(others)
        remaining = tuple(x for x in rest if x not in s)
        cyc = (mn,) + others
        for tail in perms_all_cycles_p(remaining, p):
            yield tail | {cyc}


def cycles_to_map(cycs):
    mp = {}
    for cyc in cycs:
        for i, x in enumerate(cyc):
            mp[x] = cyc[(i + 1) % len(cyc)]
    return mp


def main():
    bad = 0
    limits = {2: 12, 3: 11, 5: 11, 7: 11}
    perm_limit = 9   # full S_m orbit/stabiliser check for m <= perm_limit
    Fsize = {}
    print("Lemma 2 / Lemma 3 by enumeration of digit-forest structures")
    for p, mmax in limits.items():
        for m in range(0, mmax + 1):
            dg = digits(m, p)
            pts = tuple(range(m))
            F = list(forests(pts, dg, p))
            Fset = set(F)
            if len(Fset) != len(F):
                print("  enumeration produced duplicates", p, m)
                bad += 1
            Fsize[(p, m)] = len(Fset)
            P = 1
            for mj in dg:
                P *= factorial(mj)
            v = nu(m, p)
            # Lemma 2 (count form)
            ok2 = factorial(m) == p ** v * P * len(Fset)
            # Lemma 3
            ok3 = (len(Fset) - (-1) ** v) % p == 0
            msg = f"  p={p} m={m}: |F(m)|={len(Fset)}, nu={v}; Lemma 2 count {'ok' if ok2 else 'FAILS'}; " \
                  f"Lemma 3 {'ok' if ok3 else 'FAILS'}"
            bad += (not ok2) + (not ok3)
            # Lemma 2 (action form): transitivity and stabiliser by brute force over S_m
            if 1 <= m <= perm_limit:
                base = F[0]
                orbit = set()
                stab = 0
                stab_ok = True
                for perm in itertools.permutations(range(m)):
                    img = act(base, perm)
                    orbit.add(img)
                    if img == base:
                        stab += 1
                        # the note's description of the stabiliser: each tree goes to a tree of the same height
                        for tr in base:
                            if recanon(tr, perm)[1] not in base or height(recanon(tr, perm)[1]) != height(tr):
                                stab_ok = False
                trans = orbit == Fset
                okst = stab == p ** v * P and stab_ok
                msg += f"; S_m transitive {'ok' if trans else 'FAILS'}; |stabiliser|={stab} " \
                       f"{'ok' if okst else 'FAILS'}"
                bad += (not trans) + (not okst)
                # second base point, to make sure the stabiliser order does not depend on the structure
                if len(F) > 1:
                    base2 = F[len(F) // 2]
                    stab2 = sum(1 for perm in itertools.permutations(range(m)) if act(base2, perm) == base2)
                    if stab2 != stab:
                        print("  stabiliser order depends on the structure?!", p, m, stab, stab2)
                        bad += 1
            # recursion (1): bijection F(m) <-> {R} x {cherry groupings} x F(a)
            a, m0 = divmod(m, p)
            triples = set()
            Rs = set()
            groupings = set()
            valid = True
            Fa_cache = {}
            for X in F:
                R, ch, con = decompose(X)
                if len(R) != m0 or len(ch) != a:
                    valid = False
                rest = sorted(set(pts) - set(R))
                # cherries partition the complement of R into p-sets
                flat = sorted(x for cyc in ch for x in cyc)
                if flat != rest or any(len(cyc) != p for cyc in ch):
                    valid = False
                # contracted structure is a digit-forest structure on the cherry labels
                labels = tuple(sorted(cyc[0] for cyc in ch))
                if labels not in Fa_cache:
                    Fa_cache[labels] = set(forests(labels, digits(a, p), p))
                if con not in Fa_cache[labels]:
                    valid = False
                triples.add((R, ch, con))
                Rs.add(R)
                groupings.add((R, ch))
            inj = len(triples) == len(F)
            K_enum = None
            if p * a <= 12 and factorial(p * a) // (p ** a * factorial(a)) <= 300000:
                K_enum = sum(1 for _ in perms_all_cycles_p(tuple(range(p * a)), p))
            K_formula = factorial(p * a) // (p ** a * factorial(a))
            Fa = Fsize[(p, a)]
            okrec = (valid and inj and len(Rs) == comb(m, m0)
                     and len(groupings) == comb(m, m0) * K_formula
                     and len(F) == comb(m, m0) * K_formula * Fa
                     and (K_enum is None or K_enum == K_formula))
            msg += f"; recursion (1) bijection [binom={comb(m, m0)}, K({a})={K_formula}" \
                   f"{'' if K_enum is None else ' (enumerated)'}, |F({a})|={Fa}] {'ok' if okrec else 'FAILS'}"
            bad += (not okrec)
            print(msg)

    # automorphisms of one cyclic complete tree: "a free choice of a rotation at each internal node"
    print("Automorphisms of a cyclic complete tree of height j: free rotations give distinct leaf permutations")
    for p, j in ((2, 1), (2, 2), (2, 3), (2, 4), (3, 1), (3, 2), (5, 1), (5, 2), (7, 1)):
        n_leaves = p ** j
        e = (p ** j - 1) // (p - 1)

        # plane representative: leaves 0..p^j-1 in order; node = (start, height)
        def build(start, h):
            if h == 0:
                return start
            return tuple(build(start + i * p ** (h - 1), h - 1) for i in range(p))

        base = build(0, j)
        base_c = recanon(base, list(range(n_leaves)))[1]
        nodes = []

        def collect(start, h):
            if h == 0:
                return
            nodes.append((start, h))
            for i in range(p):
                collect(start + i * p ** (h - 1), h - 1)

        collect(0, j)
        assert len(nodes) == e

        def apply(rots, start, h, out):
            """leaf order after rotating node (start,h) by rots[...] and recursing: writes images."""
            # returns list of leaves of the rotated subtree, left to right
            if h == 0:
                return [start]
            r = rots[(start, h)]
            kids = [apply(rots, start + i * p ** (h - 1), h - 1, out) for i in range(p)]
            kids = kids[r:] + kids[:r]
            return [x for kid in kids for x in kid]

        seen = set()
        all_auto = True
        for choice in itertools.product(range(p), repeat=e):
            rots = dict(zip(nodes, choice))
            order = apply(rots, 0, j, None)
            # permutation: leaf at position i of the base goes to the point now standing at position i
            perm = [None] * n_leaves
            for pos, x in enumerate(order):
                perm[x] = pos
            seen.add(tuple(perm))
            if recanon(base_c, perm)[1] != base_c:
                all_auto = False
        ok = len(seen) == p ** e and all_auto
        extra = ""
        if n_leaves <= 9:
            brute = sum(1 for perm in itertools.permutations(range(n_leaves)) if recanon(base_c, perm)[1] == base_c)
            ok = ok and brute == p ** e
            extra = f"; brute force over S_{n_leaves}: {brute}"
        print(f"  p={p} j={j}: {p}^{e}={p ** e}; distinct permutations from free rotations: {len(seen)}; "
              f"all are automorphisms: {all_auto}{extra}; {'ok' if ok else 'FAILS'}")
        bad += (not ok)

    # the two Z_p actions of Lemma 3
    print("Z_p action on m0-subsets of {1..pa+m0} through (1 2 ... p)")
    nsub = 0
    for p in (2, 3, 5, 7):
        for a in range(1, 5):
            for m0 in range(0, p):
                n = p * a + m0
                if comb(n, m0) > 400000:
                    continue
                c = list(range(n))
                for i in range(p):
                    c[i] = (i + 1) % p
                subsets = set(itertools.combinations(range(n), m0))
                fixed = 0
                okk = True
                for S in subsets:
                    img = tuple(sorted(c[x] for x in S))
                    if img not in subsets:
                        okk = False
                    if img == S:
                        fixed += 1
                        if any(x < p for x in S):
                            okk = False
                    else:
                        # orbit has exactly p elements
                        orb = {S}
                        cur = img
                        while cur != S:
                            orb.add(cur)
                            cur = tuple(sorted(c[x] for x in cur))
                        if len(orb) != p:
                            okk = False
                if fixed != comb(p * (a - 1) + m0, m0) or (len(subsets) - fixed) % p or not okk \
                        or comb(n, m0) % p != 1 % p:
                    print("  FAILS", p, a, m0)
                    bad += 1
                nsub += 1
    print(f"  {nsub} cases (p,a,m0) checked: action well defined, orbits of size 1 or p, "
          f"fixed subsets = subsets avoiding 1..p, count = binom(p(a-1)+m0, m0)")

    print("Z_p action by conjugation with c=(1 2 ... p) on permutations of {1..pa} with all cycles of length p")
    for p, amax in ((2, 6), (3, 4), (5, 2), (7, 1)):
        Kprev = 1
        for a in range(1, amax + 1):
            n = p * a
            S = set(perms_all_cycles_p(tuple(range(n)), p))
            K = len(S)
            c = list(range(n))
            for i in range(p):
                c[i] = (i + 1) % p
            fixed = 0
            okk = True
            for cycs in S:
                # conjugate: relabel every point x by c[x]
                img = set()
                for cyc in cycs:
                    t = tuple(c[x] for x in cyc)
                    i = t.index(min(t))
                    img.add(t[i:] + t[:i])
                img = frozenset(img)
                if img not in S:
                    okk = False
                if img == cycs:
                    fixed += 1
                    mp = cycles_to_map(cycs)
                    # note's description: preserves {1..p} and acts there as c^u, u != 0
                    if not all(mp[x] < p for x in range(p)):
                        okk = False
                    else:
                        u = mp[0]
                        if u == 0 or any(mp[x] != (x + u) % p for x in range(p)):
                            okk = False
            ok = okk and fixed == (p - 1) * Kprev and (K - fixed) % p == 0 and (K - (-1) ** a) % p == 0 \
                and K == factorial(n) // (p ** a * factorial(a))
            print(f"  p={p} a={a}: K(a)={K}; fixed={fixed}; (p-1)K(a-1)={(p - 1) * Kprev}; "
                  f"K(a)=(-1)^a mod p: {(K - (-1) ** a) % p == 0}; {'ok' if ok else 'FAILS'}")
            bad += (not ok)
            Kprev = K

    print("ALL PASS" if bad == 0 else f"FAILURES: {bad}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

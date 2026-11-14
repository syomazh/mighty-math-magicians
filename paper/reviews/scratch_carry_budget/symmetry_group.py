"""
Referee scratch code (AI-written).
Written by a fresh-context Claude subagent (Claude Fable 5.2) on 2026-11-14, acting as an
independent referee of notes/2026-11-14_carry_budget.md. Not human-verified.

Tests the assertions of Consequence 3 of the note.  The note does not define "the symmetry
group of a tree"; the definition used here is the referee's reading:

    Aut(leaf) = {id};
    an automorphism of a node T = (T_0..T_{p-1}) is a shift r together with rotation
    isomorphisms T_(i+r) -> T_i for every i (it exists only if T_(i+r) ~ T_i for all i).

Every automorphism is recorded as the permutation it induces on the m leaves.  Checked on one
representative of every rotation class (with |Aut| below a size cap):

  (a) the number of automorphisms is p^sigma (sigma = number of symmetric nodes);
  (b) they induce pairwise different leaf permutations (the action on the leaves is faithful);
  (c) the set of permutations contains the identity and is closed under composition (a group);
  (d) sigma <= v_p(m!), with equality (Aut is a Sylow p-subgroup of S_m) iff d(T) = t.

Usage (from the repository root):
    uv run python paper/reviews/scratch_carry_budget/symmetry_group.py
"""
import os
import sys
import random
import itertools
from math import factorial
from functools import lru_cache

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check_facts import sp, vp, Classes  # noqa: E402


def run(p, M, cap):
    C = Classes(p)
    for m in range(p, M + 1, p - 1):
        C.extend(m)

    @lru_cache(maxsize=None)
    def nleaves(T):
        return 1 if T == () else sum(nleaves(c) for c in T)

    @lru_cache(maxsize=None)
    def isos(T, U):
        """All rotation isomorphisms T -> U, each as a tuple f with f[leaf of T] = leaf of U
        (leaves numbered left to right)."""
        if T == () and U == ():
            return ((0,),)
        if T == () or U == ():
            return ()
        offT = [0]
        for c in T:
            offT.append(offT[-1] + nleaves(c))
        offU = [0]
        for c in U:
            offU.append(offU[-1] + nleaves(c))
        if offT[-1] != offU[-1]:
            return ()
        res = []
        for r in range(p):
            lists = [isos(T[(i + r) % p], U[i]) for i in range(p)]
            if any(len(l) == 0 for l in lists):
                continue
            for combo in itertools.product(*lists):
                f = [None] * offT[-1]
                for i in range(p):
                    src = (i + r) % p
                    g = combo[i]
                    for x, y in enumerate(g):
                        f[offT[src] + x] = offU[i] + y
                res.append(tuple(f))
        return tuple(res)

    rng = random.Random(12345)
    n_checked = 0
    n_skipped = 0
    n_sylow = 0
    problems = []
    for cid in range(len(C.kids)):
        m = C.m[cid]
        sigma = C.sigma[cid]
        d = C.d[cid]
        t = (sp(m, p) - 1) // (p - 1)
        v = vp(factorial(m), p)
        if sigma > v:
            problems.append(("sigma > v_p(m!)", cid))
        if (sigma == v) != (d == t):
            problems.append(("Sylow <=> minimal fails", cid))
        if p ** sigma > cap:
            n_skipped += 1
            continue
        T = C.tree(cid)
        auts = isos(T, T)
        aset = set(auts)
        if len(auts) != p ** sigma:
            problems.append(("|Aut| != p^sigma", cid))
        if len(aset) != len(auts):
            problems.append(("action on leaves not faithful", cid))
        if any(sorted(f) != list(range(m)) for f in auts):
            problems.append(("not a permutation of the leaves", cid))
        if tuple(range(m)) not in aset:
            problems.append(("identity missing", cid))
        # closure under composition: all pairs if small, random pairs otherwise
        lst = list(aset)
        if len(lst) <= 81:
            pairs = [(f, g) for f in lst for g in lst]
        else:
            pairs = [(rng.choice(lst), rng.choice(lst)) for _ in range(3000)]
        for f, g in pairs:
            h = tuple(f[g[x]] for x in range(m))
            if h not in aset:
                problems.append(("not closed under composition", cid))
                break
        n_checked += 1
        if sigma == v:
            n_sylow += 1
    print(f"p = {p}, up to {M} leaves: {len(C.kids)} classes; group built explicitly for "
          f"{n_checked} (|Aut| <= {cap}), skipped {n_skipped}; "
          f"{n_sylow} of the built groups are Sylow; problems: {len(problems)}")
    for pr in problems[:10]:
        print("   ", pr, C.tree(pr[1]))
    sys.stdout.flush()


if __name__ == "__main__":
    run(2, 14, 2 ** 11)
    run(3, 21, 3 ** 9)
    run(5, 29, 5 ** 6)
    run(7, 25, 7 ** 3)

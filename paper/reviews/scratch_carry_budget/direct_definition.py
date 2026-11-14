"""
Referee scratch code (AI-written).
Written by a fresh-context Claude subagent (Claude Fable 5.2) on 2026-11-14, acting as an
independent referee of notes/2026-11-14_carry_budget.md. Not human-verified.

Second, deliberately naive check that does NOT use canonical forms:
  * generates every p-ary tree (as a nested tuple, leaf = ()) with m leaves,
  * implements rotation equivalence literally from the definition
        T ~ T'  iff both leaves, or neither is and there is r with T'_i ~ T_(i+r) for all i,
  * decides "symmetric" by pairwise equivalence of the p subtrees,
  * checks Facts 1-3 and Consequences 1-2 of the note on EVERY tree (not only one per class),
  * groups the trees into classes with the literal relation and checks: the relation is an
    equivalence relation, d is constant on classes, each class has exactly p^d trees, and the
    number of classes agrees with the canonical-form enumeration of check_facts.py.

Usage (from the repository root):
    uv run python paper/reviews/scratch_carry_budget/direct_definition.py
"""
import os
import sys
import itertools
from functools import lru_cache

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check_facts import digits, sp, add_carries, Classes  # noqa: E402

sys.setrecursionlimit(10000)


def all_trees_factory(p):
    @lru_cache(maxsize=None)
    def all_trees(m):
        if m == 1:
            return ((),)
        res = []

        def rec(slots, remaining, cur):
            if slots == 1:
                if remaining >= 1 and (remaining - 1) % (p - 1) == 0:
                    for T in all_trees(remaining):
                        res.append(cur + (T,))
                return
            for size in range(1, remaining - (slots - 1) + 1, p - 1):
                for T in all_trees(size):
                    rec(slots - 1, remaining - size, cur + (T,))

        rec(p, m, ())
        return tuple(res)

    return all_trees


def make_equiv(p):
    @lru_cache(maxsize=None)
    def equiv(T, U):
        """T ~ U, literally: U_i ~ T_(i+r) for all i, for some shift r."""
        if T == () and U == ():
            return True
        if T == () or U == ():
            return False
        for r in range(p):
            if all(equiv(T[(i + r) % p], U[i]) for i in range(p)):
                return True
        return False

    return equiv


def run(p, M):
    all_trees = all_trees_factory(p)
    equiv = make_equiv(p)

    @lru_cache(maxsize=None)
    def leaves(T):
        return 1 if T == () else sum(leaves(c) for c in T)

    @lru_cache(maxsize=None)
    def complete_height(T):
        if T == ():
            return 0
        hs = [complete_height(c) for c in T]
        return hs[0] + 1 if hs[0] >= 0 and all(h == hs[0] for h in hs) else -1

    @lru_cache(maxsize=None)
    def symmetric(T):
        return all(equiv(T[i], T[j]) for i in range(p) for j in range(i + 1, p))

    @lru_cache(maxsize=None)
    def an(T):
        """(N, sigma, d, carr, A, B, cond1, cond2, symkids_complete, fact2_ok)"""
        if T == ():
            return (0, 0, 0, 0, 0, 0, True, True, True, True)
        parts = [an(c) for c in T]
        ms = [leaves(c) for c in T]
        m = sum(ms)
        cv, _ = add_carries(ms, p)                      # simulated addition, amount carried
        cv_formula = (sum(sp(x, p) for x in ms) - sp(m, p))
        assert cv_formula == cv * (p - 1)
        sym = symmetric(T)
        N = sum(x[0] for x in parts) + 1
        sigma = sum(x[1] for x in parts) + (1 if sym else 0)
        d = sum(x[2] for x in parts) + (0 if sym else 1)
        carr = sum(x[3] for x in parts) + cv
        A = sum(x[4] for x in parts)
        B = sum(x[5] for x in parts)
        f2 = all(x[9] for x in parts)
        if sym:
            b = ms[0]
            f2 = f2 and all(x == b for x in ms) and cv == sp(b, p) and cv >= 1
            A += sp(b, p) - 1
        else:
            B += cv
        cond1 = all(x[6] for x in parts) and (sym or cv == 0)
        cond2 = all(x[7] for x in parts) and ((not sym) or sp(ms[0], p) == 1)
        skc = all(x[8] for x in parts) and ((not sym) or all(complete_height(c) >= 0 for c in T))
        return (N, sigma, d, carr, A, B, cond1, cond2, skc, f2)

    C = Classes(p)
    print(f"\n=== p = {p}: every tree, literal definition, up to {M} leaves ===")
    for m in range(1, M + 1, p - 1):
        if m > 1:
            canon_ids = C.extend(m)
        else:
            canon_ids = [0]
        trees = all_trees(m)
        nu = (m - sp(m, p)) // (p - 1)
        t = (sp(m, p) - 1) // (p - 1)
        bad = []
        n_min = 0
        for T in trees:
            N, sigma, d, carr, A, B, cond1, cond2, skc, f2 = an(T)
            ok = True
            ok &= (N * (p - 1) == m - 1)
            ok &= (carr == nu)                          # Fact 1
            ok &= f2                                    # Fact 2
            ok &= (d - t == nu - sigma == A + B) and A >= 0 and B >= 0   # Fact 3
            ok &= (d >= t)                              # Consequence 1
            ok &= ((d == t) == (cond1 and cond2))       # Consequence 2 (iff)
            if d == t:
                n_min += 1
                ok &= skc                               # children of symmetric nodes complete
            if not ok:
                bad.append(T)
        # classes by the literal relation
        reps = []
        members = []
        for T in trees:
            for i, R in enumerate(reps):
                if equiv(R, T):
                    members[i].append(T)
                    break
            else:
                reps.append(T)
                members.append([T])
        class_ok = True
        for R, mem in zip(reps, members):
            dR = an(R)[2]
            if any(an(T)[2] != dR for T in mem):
                class_ok = False
            if len(mem) != p ** dR:
                class_ok = False
            # symmetric + transitive within the class (spot check: all pairs for small classes)
            if len(mem) <= 60:
                for X in mem:
                    for Y in mem:
                        if not equiv(X, Y):
                            class_ok = False
        # reflexive
        if any(not equiv(T, T) for T in trees):
            class_ok = False
        print(f"m={m:>3}: trees={len(trees):>7} classes(literal)={len(reps):>5} "
              f"classes(canonical)={len(canon_ids):>5} minimal trees={n_min:>6} "
              f"violations={len(bad)} class checks={'OK' if class_ok else 'FAIL'} "
              f"count match={'OK' if len(reps) == len(canon_ids) else 'FAIL'}")
        if bad:
            print("   first violating tree:", bad[0])
        sys.stdout.flush()


if __name__ == "__main__":
    args = sys.argv[1:] or ["2:11", "3:15", "5:25", "7:19"]
    for a in args:
        p, M = map(int, a.split(":"))
        run(p, M)

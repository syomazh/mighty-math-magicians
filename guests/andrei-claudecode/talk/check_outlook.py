#!/usr/bin/env python3
# Written by Claude Fable 5.2 (claude-fable-5-2) in Claude Code, started by Andrei, 2026-11-15.
# Not human-reviewed.
"""Checks of the two formulas on outlook_slide.tex (the slide "What comes next").

Run from this folder:

    python3 check_outlook.py > check_outlook_output.txt

Row 2 of the slide: the number of q-ary trees with n_i internal nodes at depth i is
prod_i binom(q n_i, n_(i+1)), and p^t divides it (q a power of p, t as in the theorem).
Row 3 of the slide: C/p^t = N_t + p N_(t+1) modulo p^2, where N_d is the number of
rotation classes with d asymmetric nodes.

Rows 1 and 4 are not checked here. Row 1 (weighted numbers) rests on the team's
experiments/E002_extensions; row 4 is a question.

The trees are listed by make_intro.py. Standard library only. About 20 seconds.
"""

from collections import Counter
from math import comb

from make_intro import LEAF, count_by_recursion, digits, trees, vp

RESULTS = []


def check(name, ok, detail=""):
    RESULTS.append(ok)
    print(f"{'PASS' if ok else 'FAIL'}  {name}" + (f"   {detail}" if detail else ""))


def t_of(q, p, n):
    s = sum(digits((q - 1) * n + 1, p))
    assert (s - 1) % (p - 1) == 0
    return (s - 1) // (p - 1)


# ---------------------------------------------------------------- row 2: level profiles


def profile(t):
    """Number of internal nodes at depth 0, 1, 2, ..."""
    prof = []

    def walk(t, depth):
        if t == LEAF:
            return
        if depth == len(prof):
            prof.append(0)
        prof[depth] += 1
        for c in t:
            walk(c, depth + 1)

    walk(t, 0)
    return tuple(prof)


def profiles(q, n):
    """All sequences 1 = n_0, n_1, ... of positive integers with sum n and n_(i+1) <= q n_i."""
    def extend(prefix, left):
        if left == 0:
            yield tuple(prefix)
            return
        for nxt in range(1, min(left, q * prefix[-1]) + 1):
            yield from extend(prefix + [nxt], left - nxt)

    yield from extend([1], n - 1)


def product(q, prof):
    out = 1
    for a, b in zip(prof, prof[1:]):
        out *= comb(q * a, b)
    return out


def row2():
    ok = True
    for q, nmax in ((2, 8), (3, 5), (4, 4)):
        for n in range(1, nmax + 1):
            counted = Counter(profile(t) for t in trees(q, n))
            ok &= set(counted) == set(profiles(q, n))
            ok &= all(counted[pr] == product(q, pr) for pr in counted)
    check("2a trees with n_i internal nodes at depth i: listing them gives prod binom(q n_i, n_(i+1))"
          "  (q = 2, n <= 8; q = 3, n <= 5; q = 4, n <= 4)", ok)

    ok, cases, tight = True, 0, 0
    for q, p, nmax in ((2, 2, 18), (3, 3, 13), (4, 2, 12), (5, 5, 10), (8, 2, 9), (9, 3, 9)):
        T = count_by_recursion(q, nmax)
        for n in range(1, nmax + 1):
            t = t_of(q, p, n)
            total = 0
            for pr in profiles(q, n):
                x = product(q, pr)
                total += x
                cases += 1
                ok &= x % p ** t == 0
                tight += x % p ** (t + 1) != 0
            ok &= total == T[n]
    check("2b p^t divides prod binom(q n_i, n_(i+1)) for every profile, and the products add up "
          "to the number of trees  (q = 2, n <= 18; 3, <= 13; 4, <= 12; 5, <= 10; 8 and 9, <= 9)",
          ok, f"{cases} profiles, {tight} of them with the power of p exactly t")


# ---------------------------------------------------------------- row 3: classes by d


def canon(t, memo={}):
    """A normal form of the rotation class: rotate the children of every node to the least tuple."""
    if t == LEAF:
        return LEAF
    if t not in memo:
        kids = tuple(canon(c) for c in t)
        memo[t] = min(kids[r:] + kids[:r] for r in range(len(kids)))
    return memo[t]


def asymmetric_nodes(t):
    """Number of internal nodes whose subtrees are not all equivalent."""
    if t == LEAF:
        return 0
    return (len({canon(c) for c in t}) > 1) + sum(asymmetric_nodes(c) for c in t)


def row3():
    ok_size, ok_bound, ok_mod = True, True, True
    lines = []
    for p, nmax in ((2, 11), (3, 7), (5, 4)):
        for n in range(1, nmax + 1):
            fam = trees(p, n)
            size = Counter(canon(t) for t in fam)           # class -> number of trees in it
            d_of = {}
            for t in fam:
                d_of.setdefault(canon(t), asymmetric_nodes(t))
            ok_size &= all(size[c] == p ** d_of[c] for c in size)
            N = Counter(d_of.values())                       # d -> number of classes
            t = t_of(p, p, n)
            ok_bound &= min(N) == t and N[t] % p != 0
            C = len(fam)
            ok_mod &= C % p ** t == 0 and (C // p ** t - N[t] - p * N[t + 1]) % p ** 2 == 0
            if (p, n) in ((2, 6), (3, 5), (3, 7)):
                lines.append(f"   p = q = {p}, n = {n}: {C} trees, t = {t}, classes by d: "
                             + ", ".join(f"N_{d} = {N[d]}" for d in sorted(N)))
    check("3a a rotation class with d asymmetric nodes has exactly p^d trees"
          "  (p = q = 2, n <= 11; 3, n <= 7; 5, n <= 4)", ok_size)
    check("3b the least d is t, and the number of classes with d = t is not divisible by p", ok_bound)
    check("3c C/p^t = N_t + p N_(t+1) modulo p^2", ok_mod)
    print("\n".join(lines))


def main():
    print("# Output of check_outlook.py, a script written by Claude Fable 5.2 in Claude Code, "
          "started by Andrei, 2026-11-15. Not human-reviewed.")
    row2()
    row3()
    print(f"\n{len(RESULTS)} checks, {sum(RESULTS)} passed")
    return 0 if all(RESULTS) else 1


if __name__ == "__main__":
    raise SystemExit(main())

# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Connection 5: double-and-add (Egyptian multiplication, square-and-multiply,
# exact doublings in binary floating point).
#
# A binary tree with m leaves is a way to compute m*x by additions (or x^m by
# multiplications).  Symmetric node = doubling (squaring); asymmetric node =
# a genuine addition (multiplication).
#
# Checks:
#  (1) the binary method (Egyptian multiplication) is a tree with exactly
#      ones(m) - 1 genuine additions, for m = 1..5000;
#  (2) by brute force over all tree shapes, m = 1..20, no tree has fewer, and
#      the optimal trees are exactly those of Fact 3; their number is (2s-3)!!;
#  (3) CAVEAT: if intermediate results may be reused (addition chains, not
#      trees), fewer genuine additions can suffice.  Exhaustive search with
#      free doublings, m <= 64, at most 3 genuine additions;
#  (4) IEEE-754 doubles: a symmetric node never rounds; the number of rounding
#      errors when summing m copies of x along T is at most d(T).
#
#   uv run python experiments/E013_new_connections_blind/c5_double_and_add.py

import random
import sys
from fractions import Fraction
from functools import lru_cache

sys.path.insert(0, __file__.rsplit("c5_double_and_add.py", 1)[0])
from trees import (LEAF, binary_classes, canon, complete_tree, d_sigma,
                   digit_sum, leaves)

sys.setrecursionlimit(100000)


def egyptian_tree(m):
    """Doublings 1, 2, 4, ... of x, then add those selected by the binary
    digits of m, smallest first (as on the Rhind papyrus: tick the rows, add
    them up)."""
    atoms = [complete_tree(2, j) for j in range(m.bit_length()) if m >> j & 1]
    T = atoms[0]
    for A in atoms[1:]:
        T = (A, T)
    return T


def odd_double_factorial(k):
    out = 1
    while k > 1:
        out *= k
        k -= 2
    return out


@lru_cache(maxsize=None)
def is_complete(T):
    if T == LEAF:
        return True
    return T[0] == T[1] and is_complete(T[0])


@lru_cache(maxsize=None)
def is_fact3_form(T):
    if T == LEAF:
        return True
    a, b = T
    if canon(a) == canon(b):
        return is_complete(T)
    return (leaves(a) & leaves(b)) == 0 and is_fact3_form(a) and is_fact3_form(b)


def check_binary_method():
    for m in range(1, 5001):
        T = egyptian_tree(m)
        assert leaves(T) == m
        d, s = d_sigma(T)
        assert d == digit_sum(m, 2) - 1
        assert d + s == m - 1
    print("(1) binary method = tree with ones(m)-1 genuine additions and "
          "m - ones(m) doublings (counted in the tree): m = 1..5000 OK")


def check_brute_force():
    print("(2) brute force over all tree shapes")
    print("  m  #shapes  min genuine additions  ones-1  #optimal  (2s-3)!!")
    for m in range(1, 21):
        cls = binary_classes(m)
        ds = [d_sigma(T)[0] for T in cls]
        md = min(ds)
        s = digit_sum(m, 2)
        opt = [T for T in cls if d_sigma(T)[0] == md]
        assert md == s - 1
        assert set(opt) == {T for T in cls if is_fact3_form(T)}
        assert len(opt) == odd_double_factorial(2 * s - 3)
        assert canon(egyptian_tree(m)) in opt
        print(f" {m:2d}  {len(cls):7d}  {md:21d}  {s - 1:6d}  {len(opt):8d}  "
              f"{odd_double_factorial(2 * s - 3):8d}")
    print("  all assertions passed for m = 1..20")


def check_chains(M=64, K=3):
    """Minimal number of genuine (non-doubling) additions needed to reach m
    when every computed number may be reused and doublings are free."""
    best = {}
    seen = set()

    def available(state):
        out = set()
        for odd, e in state:
            v = odd << e
            while v <= M:
                out.add(v)
                v <<= 1
        return sorted(out)

    def norm(v):
        e = 0
        while v % 2 == 0:
            v //= 2
            e += 1
        return v, e

    def rec(state, k):
        key = (state, k)
        if key in seen:
            return
        seen.add(key)
        av = available(state)
        for v in av:
            if best.get(v, 99) > k:
                best[v] = k
        if k == K:
            return
        avs = set(av)
        st = dict(state)
        for i, x in enumerate(av):
            for y in av[i + 1:]:
                z = x + y
                if z > M or z in avs:
                    continue
                odd, e = norm(z)
                st2 = dict(st)
                if odd not in st2 or st2[odd] > e:
                    st2[odd] = e
                rec(frozenset(st2.items()), k + 1)

    rec(frozenset({(1, 0)}), 0)
    print(f"(3) with reuse of intermediate results (free doublings), m <= {M}:")
    strict = []
    for m in range(1, M + 1):
        tree_cost = digit_sum(m, 2) - 1
        chain_cost = best.get(m)
        if chain_cost is None:
            assert tree_cost > K
            continue
        assert chain_cost <= tree_cost
        if chain_cost < tree_cost:
            strict.append((m, tree_cost, chain_cost))
    unreached = [m for m in range(1, M + 1) if m not in best]
    print("    m where a chain with reuse beats every tree "
          "(m, tree optimum, chain optimum):")
    print("   ", strict)
    print("    m not reached with <=", K, "genuine additions:", unreached)
    print("    first such m:", strict[0] if strict else None)


def check_floating_point(Mmax=12, samples=200, seed=20261114):
    rng = random.Random(seed)
    xs = []
    for _ in range(samples):
        mant = rng.getrandbits(52) | (1 << 52)          # 53 significant bits
        if rng.random() < 0.5:
            mant |= 1                                    # odd: no spare bits
        xs.append(float(mant) * 2.0 ** rng.randint(-40, 40))
    xs += [1.0, 3.0, 0.1, 1e-3, float(2 ** 53 - 1)]

    def run(T, x):
        """Returns (float value, exact Fraction value of the float computation,
        number of inexact additions, number of inexact additions at symmetric
        nodes)."""
        if T == LEAF:
            return x, 0, 0
        a, b = T
        va, ia, sa = run(a, x)
        vb, ib, sb = run(b, x)
        v = va + vb
        inexact = Fraction(v) != Fraction(va) + Fraction(vb)
        sym = canon(a) == canon(b)
        if sym:
            assert va == vb, "equivalent subtrees gave different floats"
        return v, ia + ib + inexact, sa + sb + (inexact and sym)

    print(f"(4) IEEE doubles, {len(xs)} values of x, all tree shapes up to "
          f"m = {Mmax}")
    print("  m  #shapes  rounding at a symmetric node  max #roundings<=d(T)  "
          "min over shapes of worst-case #roundings  ones-1")
    for m in range(1, Mmax + 1):
        cls = binary_classes(m)
        sym_bad = 0
        ok = True
        worst = {}
        for T in cls:
            d = d_sigma(T)[0]
            w = 0
            for x in xs:
                v, inex, symin = run(T, x)
                sym_bad += symin
                ok &= inex <= d
                w = max(w, inex)
            worst[T] = w
        assert sym_bad == 0 and ok
        print(f" {m:2d}  {len(cls):7d}  {sym_bad:28d}  {ok!s:20s}  "
              f"{min(worst.values()):40d}  {digit_sum(m, 2) - 1}")
    print("  no symmetric node ever rounded; #roundings <= d(T) always")


if __name__ == "__main__":
    check_binary_method()
    check_brute_force()
    check_chains()
    check_floating_point()

# Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context,
# given only a brief) on 2026-11-14. Not human-reviewed.
#
# Connection 4: cascaded harmonic generation in nonlinear optics.
#
# The photon of the m-th harmonic is made of m pump photons, fused two at a
# time (second-order processes).  Its "genealogy" is a binary tree with m
# leaves.  A node whose two inputs have the same frequency is a doubling
# (second-harmonic generation, SHG); a node whose inputs have different
# frequencies is sum-frequency generation (SFG).
#
#   d(T) = asymmetric nodes  (the two inputs do not come from identical chains)
#   u(T) = nodes whose inputs have different frequencies (different leaf counts)
#   u(T) <= d(T).
#
# Claims tested for m = 1..20:
#   min d = min u = (number of ones of m in binary) - 1,
#   the schemes that minimise u are exactly those that minimise d,
#   and they are exactly "double up to 2^j for each binary digit of m, then
#   add frequencies that never coincide" (Fact 3).
#
#   uv run python experiments/E013_new_connections_blind/c4_harmonics.py

import sys
from functools import lru_cache

sys.path.insert(0, __file__.rsplit("c4_harmonics.py", 1)[0])
from trees import LEAF, binary_classes, canon, d_sigma, digit_sum, leaves


@lru_cache(maxsize=None)
def u_count(T):
    if T == LEAF:
        return 0
    a, b = T
    return u_count(a) + u_count(b) + (1 if leaves(a) != leaves(b) else 0)


@lru_cache(maxsize=None)
def is_fact3_form(T):
    """Skeleton-with-atoms form, tested structurally: T is a complete tree, or
    its root joins two such trees whose leaf counts share no binary digit."""
    if T == LEAF:
        return True
    a, b = T
    if canon(a) == canon(b):
        # root symmetric: must be a complete tree
        return is_complete(T)
    return (leaves(a) & leaves(b)) == 0 and is_fact3_form(a) and is_fact3_form(b)


@lru_cache(maxsize=None)
def is_complete(T):
    if T == LEAF:
        return True
    a, b = T
    return a == b and is_complete(a)


def formula(T):
    """Scheme in the notation of laser engineering: 1 = pump, (a+b)."""
    if T == LEAF:
        return "1"
    a, b = T
    la, lb = leaves(a), leaves(b)
    if la < lb:
        a, b, la, lb = b, a, lb, la
    fa = formula(a) if la > 1 else "1"
    fb = formula(b) if lb > 1 else "1"
    op = "SHG" if la == lb else "SFG"
    return f"{op}[{fa},{fb}]"


def main():
    print(" m  binary     #schemes  min d  min u  ones-1  #min-d  #min-u  "
          "same set  all Fact-3 form")
    for m in range(1, 21):
        cls = binary_classes(m)
        ds = {T: d_sigma(T)[0] for T in cls}
        us = {T: u_count(T) for T in cls}
        assert all(us[T] <= ds[T] for T in cls)
        t = digit_sum(m, 2) - 1
        md, mu = min(ds.values()), min(us.values())
        Dmin = {T for T in cls if ds[T] == md}
        Umin = {T for T in cls if us[T] == mu}
        F3 = {T for T in cls if is_fact3_form(T)}
        assert md == mu == t
        assert Dmin == Umin == F3
        print(f"{m:2d}  {m:9b}  {len(cls):8d}  {md:5d}  {mu:5d}  {t:6d}  "
              f"{len(Dmin):6d}  {len(Umin):6d}  {Dmin == Umin!s:8s}  {Dmin == F3}")
    print("all assertions passed for m = 1 .. 20")
    print()
    print("All schemes for the 3rd to 7th harmonic (1 = one pump photon):")
    for m in range(3, 8):
        t = digit_sum(m, 2) - 1
        print(f" harmonic {m}  (lower bound on SFG stages: {t})")
        for T in sorted(binary_classes(m), key=lambda T: (u_count(T), d_sigma(T)[0])):
            mark = "  <- minimal" if u_count(T) == t else ""
            print(f"   d={d_sigma(T)[0]} u={u_count(T)}  {formula(T)}{mark}")


if __name__ == "__main__":
    main()

"""
Referee scratch code (AI-written).
Written by a fresh-context Claude subagent (Claude Fable 5.2) on 2026-11-14, acting as an
independent referee of notes/2026-11-14_carry_budget.md. Not human-verified.

Sanity checks that the tests in check_facts.py have teeth, and smallest examples quoted in
the review:

 1. If "number of carries" is read as "number of columns that carry" (instead of the total
    amount carried), Fact 1 and Fact 2 FAIL for p >= 3.  Smallest classes where the two
    readings differ.
 2. Both bullets of Consequence 2 are needed: smallest class satisfying bullet 1 only, and
    smallest class satisfying bullet 2 only (neither is minimal).
 3. The spoken sentence "what is left over, t nodes, must be asymmetric" is a lower bound,
    not an equality: smallest class with d > t.

Usage (from the repository root):
    uv run python paper/reviews/scratch_carry_budget/sanity_examples.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check_facts import Classes, sp, digits  # noqa: E402


def show(C, cid):
    def s(c):
        if c == 0:
            return "*"
        return "(" + "".join(s(x) for x in C.kids[c]) + ")"
    return s(cid)


def run(p, M):
    C = Classes(p)
    for m in range(p, M + 1, p - 1):
        C.extend(m)
    print(f"\n--- p = {p}, up to {M} leaves, {len(C.kids)} classes ---")
    first = {}
    for cid in range(len(C.kids)):
        m = C.m[cid]
        nu = (m - sp(m, p)) // (p - 1)
        t = (sp(m, p) - 1) // (p - 1)
        d = C.d[cid]
        if C.cols[cid] != nu and "cols" not in first:
            first["cols"] = cid
            print(f"1. columns-reading fails Fact 1: m = {m} (base {p}: {digits(m, p)[::-1]}), "
                  f"nu = {nu}, total amount carried = {C.carr[cid]}, carrying columns = {C.cols[cid]}"
                  f"\n   tree {show(C, cid)}")
        if C.cond1[cid] and not C.cond2[cid] and "b1" not in first:
            first["b1"] = cid
            print(f"2a. bullet 1 holds, bullet 2 fails: m = {m}, d = {d}, t = {t}\n   tree {show(C, cid)}")
        if C.cond2[cid] and not C.cond1[cid] and "b2" not in first:
            first["b2"] = cid
            print(f"2b. bullet 2 holds, bullet 1 fails: m = {m}, d = {d}, t = {t}\n   tree {show(C, cid)}")
        if d > t and "exc" not in first:
            first["exc"] = cid
            print(f"3. d > t: m = {m}, d = {d}, t = {t}\n   tree {show(C, cid)}")
    for k in ("cols", "b1", "b2", "exc"):
        if k not in first:
            print(f"   (no example of type {k} in this range)")


if __name__ == "__main__":
    run(2, 12)
    run(3, 21)
    run(5, 49)

"""
Referee scratch code (AI-written).
Written by a fresh-context Claude subagent (Claude Fable 5.2) on 2026-11-14, acting as an
independent referee of notes/2026-11-14_carry_budget.md. Not human-verified.

Side question for the oral exam: where does the note use that p is prime?
This runs the same per-class checks (Facts 1-3, Consequences 1-2 with "symmetric" = all
subtrees pairwise rotation-equivalent, digits in base p) for COMPOSITE arity p = 4, 6.
Expected from reading the proofs: Facts 1-3 and Consequences 1-2 never use primality.
What does need p prime is outside those facts: the class of T has p^d(T) trees, and the
symmetry group has order p^sigma (Consequence 3).  The script reports both.

Usage (from the repository root):
    uv run python paper/reviews/scratch_carry_budget/composite_base.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check_facts import Classes, fuss  # noqa: E402


def run(p, M):
    C = Classes(p)
    n = 1
    size_formula_ok = True
    for m in range(p, M + 1, p - 1):
        ids = C.extend(m)
        n += len(ids)
        N = (m - 1) // (p - 1)
        if sum(p ** C.d[c] for c in ids) != fuss(p, N):
            size_formula_ok = False
    print(f"arity {p} (composite), up to {M} leaves: {n} classes; "
          f"violations of Facts 1-3 / Consequences 1-2: {dict(C.viol) if C.viol else 'none'}; "
          f"'class size = p^d' (sum p^d = number of trees) holds for all m: {size_formula_ok}")


if __name__ == "__main__":
    run(4, 34)
    run(6, 41)

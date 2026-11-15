# W024 — Lean: the closed formula for the number of p-ary trees (Fuss–Catalan)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Goal

In the Lean project `lean/`, the number of `p`-ary plane trees is defined by counting trees (`MMM.PTree p`, `PTree.leaves` in `lean/MMM/Trees.lean`). Prove the classical closed formula: the number of `p`-ary trees with `n` internal nodes, that is with `(p - 1) * n + 1` leaves, is the Fuss–Catalan number `binom(p n, n) / ((p - 1) n + 1)`. This is a known theorem; Mathlib has it only for `p = 2` (Catalan numbers). It is a hard formalization. A partial result that is honest about what is missing is useful.

## Files you own (create and edit only these)

- `lean/MMM/FussFormula.lean` (you may add more files named `lean/MMM/FussFormula*.lean`)

Do not edit any other file.

## Deliverable (exact statement, in `namespace MMM.PTree`)

```lean
theorem fuss_catalan_formula {p : ℕ} (hp : 2 ≤ p) (n : ℕ) :
    ((p - 1) * n + 1) * Nat.card {T : PTree p // T.leaves = (p - 1) * n + 1} =
      Nat.choose (p * n) n
```

Sanity checks: `p = 2, n = 2`: `3 * 2 = 6 = choose 4 2`. `p = 3, n = 2`: `5 * 3 = 15 = choose 6 2`. `p = 3, n = 3`: `7 * 12 = 84 = choose 9 3`.

## What exists (read these first)

- `lean/MMM/Trees.lean`: `PTree p` (constructors `leaf`, `node (f : Fin p → PTree p)`), `leaves`, `nodes`.
- `lean/MMM/Divisibility.lean`: `leaves_pos`, `child_leaves_lt`, `finite_leaves_eq` (finitely many trees with `m` leaves).
- `lean/MMM/Catalan.lean`: the case `p = 2` through Mathlib's `BinaryTree` and `catalan` (`card_binary_trees`).
- Mathlib: `Mathlib/Combinatorics/Enumerative/Catalan/Basic.lean` proves `catalan_eq_centralBinom_div` by an auxiliary rational function and a telescoping sum; `.../Catalan/Tree.lean` counts binary trees; `Mathlib/Combinatorics/Enumerative/DyckWord.lean` counts Dyck words. Grep Mathlib for anything on Fuss–Catalan numbers, Raney's lemma (cycle lemma), Lagrange inversion, or the Hagen–Rothe identity before you choose a route.

## Routes (choose one, or another you trust)

1. **Recursion plus a binomial identity.** (a) Show that the number `a m` of trees with `m` leaves satisfies `a 1 = 1` and `a m = ∑` over `p`-tuples of positive numbers with sum `m` of the product of the `a`'s (for `m ≥ 2`), or the equivalent recursion in the number of nodes. (b) Show that `F n := choose (p n) n / ((p - 1) n + 1)` satisfies the same recursion (the Fuss–Catalan convolution, a case of the Hagen–Rothe identity). (c) Conclude by strong induction.
2. **Cycle lemma (Raney).** Among the `(p - 1) n + 1` cyclic shifts of a word with `n` letters of weight `p - 1` and `(p - 1) n + 1` letters of weight `-1`, exactly one is a Łukasiewicz word; trees correspond to Łukasiewicz words; there are `choose (p n + 1) n`-many words in total.
3. A generalisation of Mathlib's telescoping proof for Catalan numbers.

## Acceptable partial results (in this order of value)

- The full theorem.
- The theorem with one clearly stated pure identity about binomial coefficients (no trees in it) as an explicit hypothesis, plus the recursion (1a) fully proved.
- The recursion (1a) alone, fully proved, with a precise statement of what remains.

## Environment

- Lean 4 (`leanprover/lean4:v4.36.0-rc2`) with Mathlib of November 2026. Lean is not on the PATH. From Git Bash:

      cd lean
      export PATH="$USERPROFILE/.elan/bin:$PATH"
      lake env lean MMM/FussFormula.lean -o .lake/build/lib/lean/MMM/FussFormula.olean

- **Never** run `lake build`, `lake update`, `lake exe cache get`, or anything that downloads. Never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`.
- Run one compile at a time. Other agents compile on the same small machine: a compile usually takes 10 to 60 seconds, sometimes a few minutes. Be patient; do not start a second compile while one runs.
- Mathlib sources are in `lean/.lake/packages/mathlib/Mathlib`. This Mathlib is newer than most training data and many names have changed (for example `Set.mem_setOf_eq` is now `Set.mem_ofPred_eq`). **Grep Mathlib for a lemma before you use it; do not guess names.** Use slim imports, never `import Mathlib`.
- Python is available as `uv run python ...` from the repository root if you want to test an identity numerically before proving it; put scripts in `experiments/E015_fuss_formula/` (create it, with a short `README.md`).

## Rules

- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. If a lemma will not go through, keep the file compiling by stating it as an explicit hypothesis of the theorems that need it, and say exactly which one in your report. Do not weaken the deliverable silently.
- Start each file with a comment that names your model, the date 2026-11-14 and "not human-reviewed".
- No git commands that change anything (`add`, `commit`, `push`, `checkout`, `stash`, ...). Do not launch other workers or agents.
- Work in short steps and save the file often, so that a restart can continue from it. Time box: stop after about 80 minutes and report where you are.

## Report

Which files exist and whether they compile (paste the compile output), the exact statements proved, every hypothesis left open with its exact statement, the route you took and why, and the output of `#print axioms` for your main theorem.

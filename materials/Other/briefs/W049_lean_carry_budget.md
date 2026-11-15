# W049 — Lean: the carry budget (claim C19)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker".

## What this is

`report/report.tex`, subsection "The carry budget: a second proof of the lower bound" (search for `sec:carrybudget`; read Facts 1 to 3 and the two consequences). It is a second proof of the bound d(T) ≥ t, with an exact formula for the difference, and it has been checked only by AI readers and by computation. This brief asks for it in Lean.

For a node v with children v_1, …, v_p and m_v leaves below it, put (p − 1)·c(v) = s_p(m_(v_1)) + … + s_p(m_(v_p)) − s_p(m_v) ≥ 0. Fact 1: the sum of (p − 1)·c(v) over all nodes is m − s_p(m). Fact 2: at a symmetric node, whose children all have b leaves, (p − 1)·c(v) = (p − 1)·s_p(b) ≥ p − 1. Fact 3: (p − 1)·d(T) + 1 − s_p(m) = Σ over symmetric nodes of (p − 1)(s_p(b_v) − 1) + Σ over asymmetric nodes of (p − 1)·c(v), every term ≥ 0.

## What exists (read first; change none)

`lean/MMM/Trees.lean`: `PTree p` (`leaf`, `node f`), `leaves`, `nodes`, `Rot`, `Symmetric f := ∀ i j, Rot (f i) (f j)`, `d` (the number of asymmetric nodes: `(node f).d = (∑ i, (f i).d) + if Symmetric f then 0 else 1`, with `d_node_symm`, `d_node_asymm`), `Rot.leaves_eq`, and `lower_bound (hp : 2 ≤ p) (T) : ds p T.leaves ≤ (p - 1) * T.d + 1` (its proof shows how the symmetric and the asymmetric case are handled). `lean/MMM/Digits.lean`: `ds`, `ds_one`, `ds_base_mul` (s_p(p·n) = s_p(n)), `ds_add_le`, `ds_sum_le`, `ds_pos`; `lean/MMM/DigitsCarry.lean`: `ds_pow`; in `lean/MMM/Frob/Lead.lean`: `eq_pow_of_ds_eq_one` (digit sum 1 means a power of p; do not import that file if a short direct proof is easier, or import it if it is cheap).

The project is on **Lean v4.35.0 with Mathlib v4.35.0**; lemma names must be checked in `lean/.lake/packages/mathlib/Mathlib`.

## File you own

`lean/MMM/CarryBudget.lean` (new; namespace `MMM.PTree`, `variable {p : ℕ}`). Nothing else.

## Statements

```lean
/-- (p - 1) · c(v): how much the digit sum drops when the leaf counts of the children are added. -/
def drop (f : Fin p → PTree p) : ℕ := (∑ i, ds p (f i).leaves) - ds p (∑ i, (f i).leaves)

/-- The sum of the drops over all nodes. -/
def totalDrop : PTree p → ℕ
  | leaf => 0
  | node f => (∑ i, (f i).totalDrop) + drop f

open Classical in
/-- What is left of the budget: drop - (p - 1) at the symmetric nodes, drop at the asymmetric ones. -/
noncomputable def slack : PTree p → ℕ
  | leaf => 0
  | node f => (∑ i, (f i).slack) + if Symmetric f then drop f - (p - 1) else drop f

/-- Fact 1: the budget is fixed. -/
theorem totalDrop_add_ds (hp : 2 ≤ p) (T : PTree p) : T.totalDrop + ds p T.leaves = T.leaves

/-- Fact 2: a symmetric node always carries. -/
theorem drop_of_symmetric [NeZero p] (hp : 2 ≤ p) (f : Fin p → PTree p) (hs : Symmetric f) :
    drop f = (p - 1) * ds p (f 0).leaves
theorem le_drop_of_symmetric [NeZero p] (hp : 2 ≤ p) (f : Fin p → PTree p) (hs : Symmetric f) :
    p - 1 ≤ drop f

/-- Fact 3: the excess formula. -/
theorem excess (hp : 2 ≤ p) (T : PTree p) : (p - 1) * T.d + 1 = ds p T.leaves + T.slack

/-- Consequence (2): the trees that attain the bound. -/
theorem d_eq_iff_slack (hp : 2 ≤ p) (T : PTree p) (t : ℕ) (ht : (p - 1) * t + 1 = ds p T.leaves) :
    T.d = t ↔ T.slack = 0
theorem slack_node_eq_zero_iff [NeZero p] (hp : 2 ≤ p) (f : Fin p → PTree p) :
    (node f).slack = 0 ↔
      (∀ i, (f i).slack = 0) ∧
        ((Symmetric f → ds p (f 0).leaves = 1) ∧ (¬ Symmetric f → drop f = 0))
```

(`(0 : Fin p)` needs `[NeZero p]`; inside proofs you can get the instance from `hp` as `lower_bound` does. If `(f 0)` is awkward, use any index and say so. Adjust `open Classical` to match how `d` is defined so that the two `if` agree.)

## Proof plan

- `totalDrop_add_ds`: induction on T. For a node, `ds p (∑ leaves) ≤ ∑ ds p (leaves)` (`ds_sum_le`), so the subtraction in `drop` is not truncated; add the induction hypotheses of the children.
- `drop_of_symmetric`: all children have the same number b of leaves (`Rot.leaves_eq`), the sums are `p * ds p b` and `ds p (p * b) = ds p b` (`Finset.sum_const`, `Finset.card_univ`, `Fintype.card_fin`, `ds_base_mul`); `p * x - x = (p - 1) * x`. Then `ds p b ≥ 1` (`ds_pos`; a tree has at least one leaf: `leaves_pos` in `lean/MMM/Divisibility.lean`).
- `excess`: induction on T, cases `Symmetric f` or not, as in `lower_bound`; with the same facts about truncation. It may be easier to prove first the identity `(p - 1) * T.d + T.totalDrop = T.slack + (p - 1) * T.nodes'` for a suitable count of nodes, or directly the statement by induction: for a node, `(p - 1) * d + 1 = (p - 1) * ∑ d_i + [asym](p - 1) + 1`, and by induction `(p - 1) * d_i + 1 = ds (leaves_i) + slack_i`, so `(p - 1) * ∑ d_i + p = ∑ ds (leaves_i) + ∑ slack_i`; now `∑ ds (leaves_i) = ds (leaves) + drop f`, and in the symmetric case `drop f ≥ p - 1`. Arithmetic with `omega` after naming the sums; mind `p = (p - 1) + 1`.
- The last two from `excess` and the definitions (`Nat.add_eq_zero_iff`; `drop f - (p - 1) = 0` with `p - 1 ≤ drop f` gives `drop f = p - 1`, that is `(p - 1) * ds p b = p - 1`, so `ds p b = 1`).

## Order of work, and what to do if it does not all fit

In the order above. Keep the file compiling. If something cannot be proved, leave it out and say so.

## Environment and rules

Lean is not on the PATH: `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/CarryBudget.lean -o .lake/build/lib/lean/MMM/CarryBudget.olean`. **Never run `lake build`, `lake update` or anything that downloads; never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean` or any existing file.** Grep Mathlib for every lemma name. No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`; no theorem with conclusion `True`. The file starts with a comment naming Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-15, not human-reviewed. No git command that changes anything. Other agents compile on this laptop: one compile at a time.

## Report

For each statement: done or not, the exact statement as in the file, the compile result, `#print axioms` for `excess`, every change to a statement of this brief and why, what you did not verify.

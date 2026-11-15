/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator, brief W049), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **The carry budget (claim C19): a second proof of the lower bound, with the exact excess.**

For a node `v` of a `p`-ary tree with children `v_1, …, v_p`, and `m_w` the number of leaves below
`w`, put

    drop(v) = s_p(m_(v_1)) + … + s_p(m_(v_p)) - s_p(m_v)        ( = (p - 1) · c(v) in the report ),

the amount by which the digit sum drops when the leaf counts of the children are added. Then

* Fact 1 (`totalDrop_add_ds`): the sum of the drops over all nodes is `m - s_p(m)`;
* Fact 2 (`drop_of_symmetric`, `le_drop_of_symmetric`): at a symmetric node, whose children all
  have `b` leaves, the drop is `(p - 1) · s_p(b) ≥ p - 1`;
* Fact 3 (`excess`): `(p - 1) · d(T) + 1 = s_p(m) + slack(T)`, where `slack` adds
  `drop - (p - 1)` over the symmetric nodes and `drop` over the asymmetric nodes;
* consequences: the lower bound again (`ds_leaves_le_of_excess`), and the trees that attain it
  (`d_eq_iff_slack`, `slack_node_eq_zero_iff`).

The report (`report/report.tex`, subsection "The carry budget") divides by `p - 1`; here nothing is
divided, so every statement is the report's statement multiplied by `p - 1`. Subtraction is the
truncated subtraction of `ℕ`; it is never truncated where it is used (`drop_add_ds`,
`le_drop_of_symmetric`). No factorial and no valuation is used, and `p` need not be prime.
-/
import MMM.Trees
import MMM.Divisibility

namespace MMM

namespace PTree

variable {p : ℕ}

/-- `(p - 1) · c(v)`: how much the digit sum drops when the leaf counts of the children are
added. -/
def drop (f : Fin p → PTree p) : ℕ := (∑ i, ds p (f i).leaves) - ds p (∑ i, (f i).leaves)

/-- The sum of the drops over all nodes. -/
def totalDrop : PTree p → ℕ
  | leaf => 0
  | node f => (∑ i, (f i).totalDrop) + drop f

open Classical in
/-- What is left of the budget: `drop - (p - 1)` at the symmetric nodes, `drop` at the asymmetric
ones. -/
noncomputable def slack : PTree p → ℕ
  | leaf => 0
  | node f => (∑ i, (f i).slack) + if Symmetric f then drop f - (p - 1) else drop f

@[simp] theorem totalDrop_leaf : (leaf : PTree p).totalDrop = 0 := rfl

theorem totalDrop_node (f : Fin p → PTree p) :
    (node f).totalDrop = (∑ i, (f i).totalDrop) + drop f := rfl

@[simp] theorem slack_leaf : (leaf : PTree p).slack = 0 := rfl

theorem slack_node_symm (f : Fin p → PTree p) (h : Symmetric f) :
    (node f).slack = (∑ i, (f i).slack) + (drop f - (p - 1)) := by
  simp [slack, h]

theorem slack_node_asymm (f : Fin p → PTree p) (h : ¬ Symmetric f) :
    (node f).slack = (∑ i, (f i).slack) + drop f := by
  simp [slack, h]

/-- The subtraction in `drop` is not truncated: digit sums are subadditive. -/
theorem drop_add_ds (hp : 2 ≤ p) (f : Fin p → PTree p) :
    drop f + ds p (∑ i, (f i).leaves) = ∑ i, ds p (f i).leaves :=
  Nat.sub_add_cancel (ds_sum_le hp _ _)

/-- **Fact 1: the budget is fixed.** The drops of all the nodes add up to `m - s_p(m)`. -/
theorem totalDrop_add_ds (hp : 2 ≤ p) (T : PTree p) : T.totalDrop + ds p T.leaves = T.leaves := by
  induction T with
  | leaf => simp [ds_one hp]
  | node f ih =>
    rw [totalDrop_node, leaves_node, add_assoc, drop_add_ds hp, ← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun i _ => ih i)

/-- **Fact 2: a symmetric node always carries.** Its children all have the same number `b` of
leaves, and the drop is `p · s_p(b) - s_p(p b) = (p - 1) · s_p(b)`. -/
theorem drop_of_symmetric [NeZero p] (hp : 2 ≤ p) (f : Fin p → PTree p) (hs : Symmetric f) :
    drop f = (p - 1) * ds p (f 0).leaves := by
  have hb : ∀ i, (f i).leaves = (f 0).leaves := fun i => (hs i 0).leaves_eq
  have hb' : ∀ i, ds p (f i).leaves = ds p (f 0).leaves := fun i => by rw [hb i]
  have h1 : ∑ i, ds p (f i).leaves = p * ds p (f 0).leaves := by
    rw [Finset.sum_congr rfl (fun i _ => hb' i)]
    simp
  have h2 : ∑ i, (f i).leaves = p * (f 0).leaves := by
    rw [Finset.sum_congr rfl (fun i _ => hb i)]
    simp
  unfold drop
  rw [h1, h2, ds_base_mul hp, Nat.sub_one_mul]

/-- Fact 2, the inequality: the drop at a symmetric node is at least `p - 1` (at least one
carry). -/
theorem le_drop_of_symmetric [NeZero p] (hp : 2 ≤ p) (f : Fin p → PTree p) (hs : Symmetric f) :
    p - 1 ≤ drop f := by
  rw [drop_of_symmetric hp f hs]
  exact Nat.le_mul_of_pos_right _ (ds_pos hp _ (leaves_pos _))

/-- **Fact 3: the excess formula.** `(p - 1) · d(T) + 1 - s_p(m)` is the slack: the sum of
`(p - 1)(s_p(b_v) - 1)` over the symmetric nodes and of the drops over the asymmetric nodes. -/
theorem excess (hp : 2 ≤ p) (T : PTree p) : (p - 1) * T.d + 1 = ds p T.leaves + T.slack := by
  have : NeZero p := ⟨by omega⟩
  induction T with
  | leaf => simp [ds_one hp]
  | node f ih =>
    have hsum : (p - 1) * (∑ i, (f i).d) + p
        = (∑ i, ds p (f i).leaves) + ∑ i, (f i).slack := by
      calc (p - 1) * (∑ i, (f i).d) + p = ∑ i : Fin p, ((p - 1) * (f i).d + 1) := by
            rw [Finset.sum_add_distrib, ← Finset.mul_sum]
            simp
        _ = ∑ i, (ds p (f i).leaves + (f i).slack) := Finset.sum_congr rfl (fun i _ => ih i)
        _ = (∑ i, ds p (f i).leaves) + ∑ i, (f i).slack := Finset.sum_add_distrib
    have hdrop := drop_add_ds hp f
    by_cases hs : Symmetric f
    · -- symmetric node: the drop is at least `p - 1`, and `p - 1` of it pays for the node
      have hle := le_drop_of_symmetric hp f hs
      rw [d_node_symm f hs, slack_node_symm f hs, leaves_node]
      omega
    · -- asymmetric node: the whole drop is slack
      rw [d_node_asymm f hs, slack_node_asymm f hs, leaves_node, Nat.mul_add, Nat.mul_one]
      omega

/-- **Consequence (1): the lower bound again**, read off from the excess formula
(the same statement as `lower_bound`). -/
theorem ds_leaves_le_of_excess (hp : 2 ≤ p) (T : PTree p) :
    ds p T.leaves ≤ (p - 1) * T.d + 1 := by
  rw [excess hp T]
  exact Nat.le_add_right _ _

/-- **Consequence (2): the trees that attain the bound** are those without slack. -/
theorem d_eq_iff_slack (hp : 2 ≤ p) (T : PTree p) (t : ℕ) (ht : (p - 1) * t + 1 = ds p T.leaves) :
    T.d = t ↔ T.slack = 0 := by
  have h := excess hp T
  rw [← ht] at h
  constructor
  · intro hd
    rw [hd] at h
    omega
  · intro hs
    rw [hs] at h
    have hpos : 0 < p - 1 := by omega
    exact Nat.eq_of_mul_eq_mul_left hpos (by omega)

/-- Consequence (2), node by node: a node has no slack exactly when its children have none and
either it is symmetric with children whose number of leaves has digit sum `1` (a power of `p`),
or it is asymmetric and the leaf counts of its children are added without a carry. -/
theorem slack_node_eq_zero_iff [NeZero p] (hp : 2 ≤ p) (f : Fin p → PTree p) :
    (node f).slack = 0 ↔
      (∀ i, (f i).slack = 0) ∧
        ((Symmetric f → ds p (f 0).leaves = 1) ∧ (¬ Symmetric f → drop f = 0)) := by
  have hsum0 : (∑ i, (f i).slack) = 0 ↔ ∀ i, (f i).slack = 0 := by
    rw [Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => Nat.zero_le _)]
    simp
  by_cases hs : Symmetric f
  · have hd := drop_of_symmetric hp f hs
    have hle := le_drop_of_symmetric hp f hs
    rw [slack_node_symm f hs, Nat.add_eq_zero_iff, hsum0]
    refine and_congr_right (fun _ => ?_)
    constructor
    · intro h
      refine ⟨fun _ => ?_, fun hn => absurd hs hn⟩
      have h1 : (p - 1) * ds p (f 0).leaves = (p - 1) * 1 := by omega
      exact Nat.eq_of_mul_eq_mul_left (by omega) h1
    · intro h
      rw [hd, h.1 hs]
      omega
  · rw [slack_node_asymm f hs, Nat.add_eq_zero_iff, hsum0]
    refine and_congr_right (fun _ => ?_)
    constructor
    · intro h
      exact ⟨fun hn => absurd hn hs, fun _ => h⟩
    · intro h
      exact h.2 hs

end PTree

end MMM

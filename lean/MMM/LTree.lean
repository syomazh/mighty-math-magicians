/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

`p`-ary trees whose leaves carry labels. Two uses:

* labels = natural numbers read as *types*: a leaf of type `j` stands for the complete tree with
  `p ^ j` leaves (an "atom"). This is how Step 3 of the paper describes the minimal trees.
* labels pairwise distinct (`Good`): the labelled trees of Step 4 (the cherry collapse).

This file contains only the definitions shared by the files that build on it.
-/
import MMM.Trees
import Mathlib.Data.Finset.Union

namespace MMM

/-- A `p`-ary tree whose leaves carry labels from `α`. -/
inductive LTree (p : ℕ) (α : Type) : Type
  | leaf : α → LTree p α
  | node : (Fin p → LTree p α) → LTree p α

namespace LTree

variable {p : ℕ} {α β : Type}

/-- The number of internal nodes. -/
def nodes : LTree p α → ℕ
  | leaf _ => 0
  | node f => (∑ i, (f i).nodes) + 1

/-- The set of labels that occur at the leaves. -/
def lab [DecidableEq α] : LTree p α → Finset α
  | leaf a => {a}
  | node f => Finset.univ.biUnion fun i => (f i).lab

/-- The labels of the leaves are pairwise distinct. -/
def Good [DecidableEq α] : LTree p α → Prop
  | leaf _ => True
  | node f => (∀ i, (f i).Good) ∧ ∀ i j, i ≠ j → Disjoint (f i).lab (f j).lab

/-- Rename the labels. -/
def map (g : α → β) : LTree p α → LTree p β
  | leaf a => leaf (g a)
  | node f => node fun i => (f i).map g

/-- **Rotation equivalence** for labelled trees, in the same normal form as `PTree.Rot`:
equal leaves are equivalent; two nodes are equivalent when, after a cyclic shift `r` of the
children of the first, the children are equivalent one by one. -/
inductive Rot : LTree p α → LTree p α → Prop
  | leaf (a : α) : Rot (leaf a) (leaf a)
  | node (f g : Fin p → LTree p α) (r : Fin p) (h : ∀ i, Rot (f (i + r)) (g i)) :
      Rot (node f) (node g)

@[simp] theorem nodes_leaf (a : α) : (leaf a : LTree p α).nodes = 0 := rfl
@[simp] theorem nodes_node (f : Fin p → LTree p α) : (node f).nodes = (∑ i, (f i).nodes) + 1 := rfl
@[simp] theorem map_leaf (g : α → β) (a : α) : (leaf a : LTree p α).map g = leaf (g a) := rfl
@[simp] theorem map_node (g : α → β) (f : Fin p → LTree p α) :
    (node f).map g = node fun i => (f i).map g := rfl

section dec

variable [DecidableEq α]

@[simp] theorem lab_leaf (a : α) : (leaf a : LTree p α).lab = {a} := rfl
@[simp] theorem lab_node (f : Fin p → LTree p α) :
    (node f).lab = Finset.univ.biUnion fun i => (f i).lab := rfl
@[simp] theorem good_leaf (a : α) : (leaf a : LTree p α).Good := trivial
theorem good_node (f : Fin p → LTree p α) :
    (node f).Good ↔ (∀ i, (f i).Good) ∧ ∀ i j, i ≠ j → Disjoint (f i).lab (f j).lab := Iff.rfl

/-- Every tree has at least one label. -/
theorem lab_nonempty [NeZero p] (T : LTree p α) : T.lab.Nonempty := by
  induction T with
  | leaf a => simp
  | node f ih =>
    obtain ⟨x, hx⟩ := ih 0
    exact ⟨x, by simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and]; exact ⟨0, hx⟩⟩

end dec

end LTree

end MMM

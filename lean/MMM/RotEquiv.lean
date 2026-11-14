/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

Rotation equivalence is an equivalence relation, and the number `d` of asymmetric nodes is the
same for equivalent trees (Lemmas "Normal form" and "d is a class invariant" of the paper).
-/
import MMM.Trees

namespace MMM

namespace PTree

variable {p : ℕ} [NeZero p]

theorem Rot.refl (T : PTree p) : Rot T T := by
  induction T with
  | leaf => exact Rot.leaf
  | node f ih => exact Rot.node f f 0 (fun i => by simpa using ih i)

theorem Rot.symm {S T : PTree p} (h : Rot S T) : Rot T S := by
  induction h with
  | leaf => exact Rot.leaf
  | node f g r _ ih =>
    refine Rot.node g f (-r) (fun i => ?_)
    have h1 := ih (i + -r)
    simpa using h1

theorem Rot.trans {S T U : PTree p} (h1 : Rot S T) (h2 : Rot T U) : Rot S U := by
  induction h1 generalizing U with
  | leaf => exact h2
  | node f g r _ ih =>
    cases h2 with
    | node _ k r' h2' =>
      refine Rot.node f k (r' + r) (fun i => ?_)
      have h3 := ih (i + r') (h2' i)
      simpa [add_assoc] using h3

/-- Rotation equivalence as a setoid. -/
def rotSetoid (p : ℕ) [NeZero p] : Setoid (PTree p) where
  r := Rot
  iseqv := ⟨Rot.refl, Rot.symm, Rot.trans⟩

/-- If the children of two nodes correspond up to a shift, one is symmetric iff the other is. -/
theorem symmetric_iff_of_rot {f g : Fin p → PTree p} {r : Fin p}
    (h : ∀ i, Rot (f (i + r)) (g i)) : Symmetric f ↔ Symmetric g := by
  constructor
  · intro hs i j
    exact ((h i).symm.trans (hs (i + r) (j + r))).trans (h j)
  · intro hg i j
    have hi := h (i - r)
    have hj := h (j - r)
    simp only [sub_add_cancel] at hi hj
    exact (hi.trans (hg _ _)).trans hj.symm

/-- Equivalent trees have the same number of asymmetric nodes. -/
theorem Rot.d_eq {S T : PTree p} (h : Rot S T) : S.d = T.d := by
  induction h with
  | leaf => rfl
  | node f g r h ih =>
    have hsum : ∑ i, (f i).d = ∑ i, (g i).d := by
      rw [← Finset.sum_congr rfl (fun i _ => ih i)]
      exact (Fintype.sum_equiv (Equiv.addRight r) (fun i => (f (i + r)).d)
        (fun i => (f i).d) (fun i => rfl)).symm
    have hsym := symmetric_iff_of_rot h
    by_cases hs : Symmetric f
    · rw [d_node_symm f hs, d_node_symm g (hsym.mp hs), hsum]
    · rw [d_node_asymm f hs, d_node_asymm g (fun hg => hs (hsym.mpr hg)), hsum]

end PTree

end MMM

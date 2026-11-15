/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.
Axiom audit for the statements added on 2026-11-15 around the main proof:
the exact number of minimal classes for q = p (claim C8; `ExactCount.lean`, brief W048) and the
carry budget (claim C19; `CarryBudget.lean`, brief W049).
-/
import MMM.ExactCount
import MMM.CarryBudget

#print axioms MMM.card_labelled_mul_factorial
#print axioms MMM.card_minimal_mul_factorials
#print axioms MMM.card_minimal_classes_mul
#print axioms MMM.PTree.totalDrop_add_ds
#print axioms MMM.PTree.drop_of_symmetric
#print axioms MMM.PTree.excess
#print axioms MMM.PTree.d_eq_iff_slack
#print axioms MMM.PTree.slack_node_eq_zero_iff

-- Two instances of the exact count, to see that the statement is not empty:
-- p = 2, m = 3 leaves (t = 1): N_min · 1! · 2 · (1! · 1!) = 2!, so N_min = 1;
-- p = 3, m = 5 leaves (t = 1): N_min · 1! · 3 · (2! · 1!) = 3!, so N_min = 1.
example : Nat.card (Quotient (MMM.PTree.rotSetoidOn (MMM.PTree.IsMinimal (p := 2) 3 1))) = 1 := by
  have : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  have h := MMM.card_minimal_classes_mul 2 3 1 (by decide)
  have h2 : (1 : ℕ).factorial * 2 ^ 1 * ∏ j ∈ Finset.range 3, (MMM.dig 2 j 3).factorial = 2 := by
    decide
  rw [h2] at h
  have h3 : (2 * 1).factorial = 2 := by decide
  rw [h3] at h
  omega

example : Nat.card (Quotient (MMM.PTree.rotSetoidOn (MMM.PTree.IsMinimal (p := 3) 5 1))) = 1 := by
  have : Fact (Nat.Prime 3) := ⟨Nat.prime_three⟩
  have h := MMM.card_minimal_classes_mul 3 5 1 (by decide)
  have h2 : (1 : ℕ).factorial * 3 ^ 1 * ∏ j ∈ Finset.range 5, (MMM.dig 3 j 5).factorial = 6 := by
    decide
  rw [h2] at h
  have h3 : (3 * 1).factorial = 6 := by decide
  rw [h3] at h
  omega

/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.
Axiom audit for the statements added on 2026-11-15 around the main proof:
the exact number of minimal classes for q = p (claim C8; `ExactCount.lean`, brief W048) and the
carry budget (claim C19; `CarryBudget.lean`, brief W049), the congruence for rotation-closed
families (claim C11; `Closed.lean`) and the level profiles (claim C10; `Profile.lean`; brief W047).
-/
import MMM.ExactCount
import MMM.CarryBudget
import MMM.Closed
import MMM.Profile
import MMM.Weighted
import MMM.Frob.Deps

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

-- Closed families (C11) and level profiles (C10)
#print axioms MMM.PTree.card_closed_modEq_classes
#print axioms MMM.PTree.Rot.prof_eq
#print axioms MMM.PTree.card_prof
#print axioms MMM.PTree.pow_dvd_card_prof
#print axioms MMM.pow_dvd_prod_choose_profile

-- The divisibility of the profile products comes from the rotation classes: no declaration of
-- Mathlib about valuations, factorials or the divisibility of binomial coefficients is referred to.
#project_modules MMM.pow_dvd_prod_choose_profile
#external_consts_matching MMM.pow_dvd_prod_choose_profile "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson" "factorial"

-- An instance: p = 2, k = 1, the profile 1, 2, 1, 0 (four nodes, five leaves, 5 = 101 in base 2,
-- t = 1): 2 divides binom(2, 2) * binom(4, 1) * binom(2, 0) = 4.
example : 2 ^ 1 ∣ ∏ i ∈ Finset.range 3,
    Nat.choose (2 ^ 1 * (fun i : ℕ => if i = 0 then 1 else if i = 1 then 2 else if i = 2 then 1 else 0) i)
      ((fun i : ℕ => if i = 0 then 1 else if i = 1 then 2 else if i = 2 then 1 else 0) (i + 1)) := by
  have : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  exact MMM.pow_dvd_prod_choose_profile 2 1 Nat.one_pos 3 _ (by decide) (by decide) 1 (by decide)

-- Weights that rotations do not change (`Weighted.lean`, brief W051)
#print axioms MMM.dvd_sum_of_classes
#print axioms MMM.PTree.pow_dvd_sum_weight_of_closed
#print axioms MMM.PTree.depthWeight_node
#print axioms MMM.PTree.pow_dvd_sum_depthWeight
#print axioms MMM.PTree.finsum_depthWeight_one
#external_consts_matching MMM.PTree.pow_dvd_sum_depthWeight "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson" "factorial"

-- Full closures (through Mathlib), as in `MMM/Frob/Axioms.lean`.
#closure_consts_matching MMM.card_minimal_classes_mul "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.PTree.excess "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.PTree.card_closed_modEq_classes "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.pow_dvd_prod_choose_profile "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.PTree.pow_dvd_sum_depthWeight "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"

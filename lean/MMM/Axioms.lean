/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14.
Prints the axioms each main theorem depends on. A machine-checked theorem should list only
Lean's standard axioms (`propext`, `Classical.choice`, `Quot.sound`) and never `sorryAx`.
-/
import MMM.Blocked
import MMM.Exact
import MMM.ExactB

-- digit sums
#print axioms MMM.ds_add_le
#print axioms MMM.ds_sum_le
-- Step 2: the lower bound
#print axioms MMM.PTree.Rot.leaves_eq
#print axioms MMM.PTree.lower_bound
#print axioms MMM.PTree.t_le_d
-- rotation equivalence is an equivalence relation; d is a class invariant
#print axioms MMM.PTree.Rot.refl
#print axioms MMM.PTree.Rot.symm
#print axioms MMM.PTree.Rot.trans
#print axioms MMM.PTree.Rot.d_eq
-- Step 1: class size
#print axioms MMM.PTree.symmetric_of_shift
#print axioms MMM.PTree.card_class
-- divisibility
#print axioms MMM.PTree.finite_leaves_eq
#print axioms MMM.PTree.pow_dvd_card_trees
-- prime powers (blocked trees): divisibility only
#print axioms MMM.PTree.Rot.blockedAt
#print axioms MMM.PTree.pow_dvd_card_blocked_trees
-- p = 2: Catalan numbers, divisibility (a statement in Mathlib's vocabulary only)
#print axioms MMM.PTree.card_binary_trees
#print axioms MMM.two_pow_dvd_catalan
#print axioms MMM.two_pow_digitSum_sub_one_dvd_catalan
-- reduction to the minimal trees
#print axioms MMM.PTree.pow_dvd_card_of_closed
#print axioms MMM.PTree.card_trees_modEq_minimal
#print axioms MMM.PTree.card_trees_modEq_classes
#print axioms MMM.PTree.exact_of_classes
-- carry-free sums
#print axioms MMM.dig_sum
#print axioms MMM.ds_sum_pow
#print axioms MMM.ds_sum_of_dig_lt
#print axioms MMM.eq_of_dig_eq
-- Step 3: minimal trees and atoms
#print axioms MMM.PTree.tight_symm_d_zero
#print axioms MMM.PTree.tight_asymm
#print axioms MMM.PTree.eq_complete_of_d_eq_zero
#print axioms MMM.LTree.minimalEquiv
#print axioms MMM.LTree.cnt_eq_dig
#print axioms MMM.LTree.typed_iff_cnt
#print axioms MMM.LTree.good_lab_iff
-- equal atoms
#print axioms MMM.LTree.card_retype
#print axioms MMM.LTree.card_refine
#print axioms MMM.LTree.exists_distinct
-- Step 4: labelled trees and the cherry collapse
#print axioms MMM.LTree.card_class
#print axioms MMM.LTree.finite_good
#print axioms MMM.LTree.cherry_of_fixed
#print axioms MMM.LTree.labelled_valuation
#print axioms MMM.step4
-- the exact valuation, q = p
#print axioms MMM.PTree.exact_valuation
#print axioms MMM.PTree.multiplicity_card_trees
#print axioms MMM.PTree.fussCatalan_valuation
#print axioms MMM.multiplicity_two_catalan

-- concrete instances
-- 7 = 111 in base 2, so 2 ^ 2 divides C_6 = 132
example : 2 ^ 2 ∣ catalan 6 := MMM.two_pow_dvd_catalan 6 2 (by simp)
-- and 2 ^ 2 is the exact power: v_2(C_6) = 3 - 1
example : multiplicity 2 (catalan 6) = 2 := by
  have h := MMM.multiplicity_two_catalan 6
  simpa using h
-- C_7 = 429 is odd: 8 = 1000 in base 2
example : multiplicity 2 (catalan 7) = 0 := by
  have h := MMM.multiplicity_two_catalan 7
  simpa using h

-- table entries of the README not printed above (audit, point 4)
#print axioms MMM.ds_base_mul
#print axioms MMM.ds_add_eq
#print axioms MMM.dig_sum_pow
#print axioms MMM.LTree.ds_wt
#print axioms MMM.LTree.d_realize

-- prime powers q = p ^ k
#print axioms MMM.PTree.card_modEq_minimal_of_closed
#print axioms MMM.LTree.card_minimal_blocked
#print axioms MMM.LTree.exists_distinct_blocked
#print axioms MMM.LTree.labelled_valuation_blocked
#print axioms MMM.step4B
#print axioms MMM.PTree.card_pow_ary_eq_card_blocked
#print axioms MMM.PTree.leaves_eq_nodes
#print axioms MMM.PTree.fussCatalan_valuation_nodes
#print axioms MMM.PTree.exact_valuation_blocked
#print axioms MMM.PTree.exact_valuation_primePower
#print axioms MMM.PTree.problem137_leaves
#print axioms MMM.PTree.problem137

-- concrete instances for q = 4 (p = 2, k = 2): there are 4 quaternary trees with 2 nodes
-- (7 = 111 in base 2, so v_2 = 2) and 22 with 3 nodes (10 = 1010 in base 2, so v_2 = 1)
example : multiplicity 2 (Nat.card {T : MMM.PTree (2 ^ 2) // T.nodes = 2}) = 2 := by
  have h := MMM.PTree.problem137 (p := 2) 2 2 (by omega)
  have hd : (Nat.digits 2 ((2 ^ 2 - 1) * 2 + 1)).sum = 3 := by simp
  rw [hd] at h
  omega
example : multiplicity 2 (Nat.card {T : MMM.PTree (2 ^ 2) // T.nodes = 3}) = 1 := by
  have h := MMM.PTree.problem137 (p := 2) 2 3 (by omega)
  have hd : (Nat.digits 2 ((2 ^ 2 - 1) * 3 + 1)).sum = 2 := by simp
  rw [hd] at h
  omega
-- q = 9 (p = 3, k = 2): 9 nonary trees with 2 nodes (17 = 122 in base 3, so v_3 = 2)
example : multiplicity 3 (Nat.card {T : MMM.PTree (3 ^ 2) // T.nodes = 2}) = 2 := by
  have h := MMM.PTree.problem137 (p := 3) 2 2 (by omega)
  have hd : (Nat.digits 3 ((3 ^ 2 - 1) * 2 + 1)).sum = 5 := by simp
  rw [hd] at h
  omega

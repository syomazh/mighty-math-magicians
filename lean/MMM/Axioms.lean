/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14.
Prints the axioms each main theorem depends on. A machine-checked theorem should list only
Lean's standard axioms (`propext`, `Classical.choice`, `Quot.sound`) and never `sorryAx`.
-/
import MMM.Blocked
import MMM.Catalan

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
-- prime powers (blocked trees)
#print axioms MMM.PTree.Rot.blockedAt
#print axioms MMM.PTree.pow_dvd_card_blocked_trees
-- p = 2: Catalan numbers (a statement in Mathlib's vocabulary only)
#print axioms MMM.PTree.card_binary_trees
#print axioms MMM.two_pow_dvd_catalan
#print axioms MMM.two_pow_digitSum_sub_one_dvd_catalan

-- a concrete instance: 7 = 111 in base 2, so 2 ^ 2 divides C_6 = 132
example : 2 ^ 2 ∣ catalan 6 := MMM.two_pow_dvd_catalan 6 2 (by simp)

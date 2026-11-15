/-
Written by Kimi K3.1 Pro, 2026-11-14. Not human-reviewed.
Axiom audit for the currently checked Frobenius-start results.
Extended by the orchestrator (Claude Fable 5.2) on review: the import now reaches
Uniqueness.lean and the last three lines were added.
-/
import MMM.Frob.Divisibility
import MMM.Frob.Lead
import MMM.Frob.Problem137
import MMM.Frob.Deps

#print axioms MMM.Frob.modSeries_frobeniusLift
#print axioms MMM.Frob.exists_frobenius_sub_eq_natCast_mul
#print axioms MMM.Frob.mul_natCast_prime_cancel
#print axioms MMM.Frob.theta_spec
#print axioms MMM.Frob.theta_zero
#print axioms MMM.Frob.theta_one
#print axioms MMM.Frob.theta_X
#print axioms MMM.Frob.theta_coeff_X
#print axioms MMM.Frob.theta_add
#print axioms MMM.Frob.theta_mul
#print axioms MMM.Frob.theta_system_eq
#print axioms MMM.Frob.finsuppAntidiag_sum_range
#print axioms MMM.Frob.coeff_pow_lower
#print axioms MMM.Frob.coeff_theta_lower
#print axioms MMM.Frob.cyclicSystem_unique
#print axioms MMM.Frob.exists_unique_cyclicSystem
#print axioms MMM.Frob.evalY_solution
#print axioms MMM.Frob.evalY0_cyclicRHS_expand
#print axioms MMM.Frob.weight_solution
#print axioms MMM.Frob.X_pow_dvd_coeff_solution
#print axioms MMM.Frob.pow_dvd_coeff_evalY_solution
#print axioms MMM.Frob.treeGF_eq
#print axioms MMM.Frob.evalY_solution_eq_treeGF
#print axioms MMM.Frob.pow_dvd_card_blocked_frobenius
#print axioms MMM.Frob.evalY0_solution
#print axioms MMM.Frob.lead_C_X_mul_theta
#print axioms MMM.Frob.lead_solution

-- Added by the orchestrator (Claude Fable 5.2), 2026-11-15: the rest of the Frobenius proof.
#print axioms MMM.Frob.IsDer.iterate_pow_prime
#print axioms MMM.Frob.eval_of_carry
#print axioms MMM.Frob.exists_unique_Hfam
#print axioms MMM.Frob.T_rec
#print axioms MMM.Frob.carry
#print axioms MMM.Frob.lead_mul_digitFact
#print axioms MMM.Frob.residue_frobenius
#print axioms MMM.Frob.exact_valuation_blocked_frobenius
#print axioms MMM.Frob.residue_fussCatalan_frobenius
#print axioms MMM.Frob.problem137_fussCatalan_exact_frobenius
#print axioms MMM.Frob.problem137_fussCatalan_frobenius

-- Dependency audit (`Deps.lean`): which modules of the project the theorems reach.
#project_modules MMM.Frob.residue_frobenius
#project_consts_in MMM.Frob.residue_frobenius MMM.Blocked
#project_consts_in MMM.Frob.residue_frobenius MMM.Divisibility
#project_consts_in MMM.Frob.residue_frobenius MMM.Trees
#project_modules MMM.Frob.problem137_fussCatalan_frobenius
#project_modules MMM.problem137_fussCatalan

-- "No factorial valuation", as far as Lean can list it: the declarations outside the project that
-- the proofs refer to directly and whose names contain one of these strings. Expected: no
-- `padicValNat`, no `factorization`, nothing of Legendre, Kummer or Lucas, no `dvd_choose`;
-- `multiplicity` only for the form of the final statement; `Nat.Prime.dvd_factorial`
-- (p ∣ n! ↔ p ≤ n) to say that p does not divide j! for j < p; Wilson's theorem for the residue.
#external_consts_matching MMM.problem137_fussCatalan "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson"
#external_consts_matching MMM.residue_fussCatalan "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson"
#external_consts_matching MMM.Frob.problem137_fussCatalan_frobenius "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson"
#external_consts_matching MMM.Frob.residue_fussCatalan_frobenius "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson"

/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
Axiom audit for the path proof (claim C24), parts 1 and 2 (workers W032 and W033, Kimi K3.1 Pro) and parts 3 to 5 (Claude agents, briefs W041, W043, W044; `Final.lean` by the orchestrator).
-/
import MMM.Path.Final
import MMM.Frob.Deps

#print axioms MMM.Path.cntE_eq_of_eqv
#print axioms MMM.Path.d_eq_of_eqv
#print axioms MMM.Path.card_class
#print axioms MMM.Path.lower_bound
#print axioms MMM.Path.pow_dvd_card
#print axioms MMM.Path.card_cntE
#print axioms MMM.Path.card_classW
#print axioms MMM.Path.lower_boundW
#print axioms MMM.Path.card_cntEW
#print axioms MMM.Path.exists_blocks
#print axioms MMM.Path.kummer_dvd
#print axioms MMM.Path.choose_modEq_minimal
#print axioms MMM.Path.minBlk_succ_iff
#print axioms MMM.Path.dW_eq_iff
#print axioms MMM.Path.card_minimal_words
#print axioms MMM.Path.choose_modEq_sum_minCount
#print axioms MMM.Path.minCount_mono
#print axioms MMM.Path.minCount_succ_eq
#print axioms MMM.Path.minWords_eq_slotCount
#print axioms MMM.Path.slotCount_digits
#print axioms MMM.Path.factorial_add_prime_modEq
#print axioms MMM.Path.kummer_exact
#print axioms MMM.Path.choose_residue
#print axioms MMM.Path.residue_fussCatalan_path
#print axioms MMM.Path.problem137_fussCatalan_exact_path
#print axioms MMM.Path.problem137_fussCatalan_path

-- Dependency audit (`MMM/Frob/Deps.lean`): which modules of the project the path proof reaches,
-- and which declarations of Mathlib about valuations, factorials or binomial divisibility it
-- refers to directly. Expected: no file of the tree proof except the tree-count formula
-- (`FussFormula.lean`) and arithmetic lemmas; no `padicValNat`, no `factorization`, nothing of
-- Legendre, Kummer or Lucas, no `dvd_choose`; `Nat.Prime.dvd_factorial` and Wilson's theorem.
#project_modules MMM.Path.kummer_exact
#project_modules MMM.Path.problem137_fussCatalan_path
#external_consts_matching MMM.Path.kummer_exact "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson"
#external_consts_matching MMM.Path.choose_residue "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson"
#external_consts_matching MMM.Path.problem137_fussCatalan_path "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson"
#print axioms MMM.Path.kummer_exact_digits
#print axioms MMM.Path.multiplicity_choose_eq_carries
#print axioms MMM.Path.choose_residue_digits

-- Full closures (through Mathlib), as in `MMM/Frob/Axioms.lean`.
#closure_consts_matching MMM.Path.kummer_exact "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.Path.choose_residue "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.Path.problem137_fussCatalan_path "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.Path.residue_fussCatalan_path "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"

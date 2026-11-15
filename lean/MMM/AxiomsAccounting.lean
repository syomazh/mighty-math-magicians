/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.

Axiom and dependency audit for the accounting proof (`MMM/Accounting.lean` and the files it joins).
The build prints, for each theorem, the axioms it depends on; then the modules of the project that
the final theorem reaches, and the declarations outside the project, in its full closure through
Mathlib and the core library, whose names contain one of the listed strings.
-/
import MMM.Accounting
import MMM.Frob.Deps

#print axioms MMM.LTree.blockedL_zero_iff_shape
#print axioms MMM.LTree.card_good_lab_blocked_eq
#print axioms MMM.factorial_mul_card_blocked_modEq
#print axioms MMM.nodes_eq_nu_add
#print axioms MMM.residue_of_L1_of_legendre
#print axioms MMM.Kcount_mul
#print axioms MMM.forestCount_eq
#print axioms MMM.factorial_eq_forestCount
#print axioms MMM.forestCount_modEq_of
#print axioms MMM.Kcount_eq_W
#print axioms MMM.Acc.choose_congruence
#print axioms MMM.Acc.Kcount_congruence
#print axioms MMM.Acc.legendre_accounting
#print axioms MMM.Acc.residue_accounting
#print axioms MMM.Acc.residue_fussCatalan_accounting
#print axioms MMM.Acc.problem137_fussCatalan_exact_accounting
#print axioms MMM.Acc.problem137_fussCatalan_accounting

-- Which modules of the project the final theorem reaches.
#project_modules MMM.Acc.problem137_fussCatalan_accounting

-- Declarations outside the project that the theorems refer to directly, by name.
#external_consts_matching MMM.Acc.problem137_fussCatalan_accounting "padicval" "multiplicity" "factorization" "legendre" "kummer" "lucas" "dvd_choose" "dvd_factorial" "wilson"

-- The full closure, through Mathlib and the core library.
#closure_consts_matching MMM.Acc.residue_accounting "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.Acc.residue_fussCatalan_accounting "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.Acc.problem137_fussCatalan_accounting "multiplicity_choose" "multiplicity_factorial" "padicval" "legendre" "kummer" "lucas" "dvd_choose_pow" "add_pow_char" "add_pow_expchar"
#closure_consts_matching MMM.Acc.problem137_fussCatalan_accounting "wilson"

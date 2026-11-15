/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.

The number K(a) of the accounting proof (Appendix C of the report, proof of Lemma L4):
the permutations of p·a points all of whose cycles have length p.
Only the definition is here, so that the files that prove things about it can be written
independently of each other.
-/
import Mathlib.GroupTheory.Perm.Cycle.Type

namespace MMM

/-- K(a): the number of permutations of `p * a` points all of whose cycles have length `p`. -/
noncomputable def Kcount (p a : ℕ) : ℕ :=
  Nat.card {π : Equiv.Perm (Fin (p * a)) // π.cycleType = Multiset.replicate a p}

end MMM

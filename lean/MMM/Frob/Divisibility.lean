/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
The divisibility half of the main theorem, by the Frobenius route: the family F_δ of
`Existence.lean`, its weight bound (`Weight.lean`, worker W034) and the identification of
its value at y = p with the generating function of the trees (`TreeGF.lean`, worker W035).
No symmetry of trees is used.
-/
import MMM.Frob.Weight
import MMM.Frob.TreeGF

namespace MMM.Frob

open MMM PTree

/-- If s_p(m) = (p - 1) t + 1, then p^t divides the number of p-ary trees with m leaves whose
leaves, seen from offset δ, all sit at a depth divisible by k. For δ = 0 these are the q-ary
trees with q = p^k (see `card_pow_ary_eq_card_blocked` in `MMM/BlockedForm.lean`). -/
theorem pow_dvd_card_blocked_int (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ m t : ℕ)
    (ht : ds p m = (p - 1) * t + 1) :
    (p : ℤ) ^ t ∣ (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} : ℤ) := by
  have h := pow_dvd_coeff_evalY_solution p k (δ : ZMod k) m t ht
  rw [evalY_solution_eq_treeGF p k δ] at h
  simpa [treeGF, PowerSeries.coeff_mk] using h

theorem pow_dvd_card_blocked_frobenius (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ m t : ℕ)
    (ht : ds p m = (p - 1) * t + 1) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} := by
  have h := pow_dvd_card_blocked_int p k δ m t ht
  exact_mod_cast h

end MMM.Frob

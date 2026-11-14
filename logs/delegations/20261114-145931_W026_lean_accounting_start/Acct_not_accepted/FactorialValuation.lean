/-
Written by `open-math — kimi-k3.1-pro` (model `moonshotai/kimi-k3.1-pro`), 2026-11-14; not human-reviewed.

Factorial valuation via Mathlib — the valuation half of the corollary "Legendre's
formula, with its residue" of `paper/accounting_proof.tex`.

We do NOT prove Legendre by symmetry here; we quote Mathlib's theorem
`Nat.Prime.sub_one_mul_multiplicity_factorial` (which is Legendre) and derive
`v_p(m!) = ν(m)` where `ν(m) = (m − s_p(m))/(p − 1)`. The residue part of the
corollary needs Lemmas L3+L4 and is not proved in this file; the header says so.

Hygiene: slim imports; no `sorry`/`axiom`/`admit`/`native_decide`.
-/
import MMM.Digits
import MMM.Acct.Basic
import Mathlib.Data.Nat.Multiplicity
import Mathlib.NumberTheory.Padics.PadicVal.Basic

namespace MMM.Acct

open MMM

/-- `v_p(m!) = ν(m) = (m − s_p(m))/(p − 1)` — Legendre's formula, valuation part.

Mathlib gives `(p−1) * v_p(m!) = m − s_p(m)` as
`Nat.Prime.sub_one_mul_multiplicity_factorial`. We transport it to `ν(m)` using
`MMM.Acct.sub_one_mul_nu`. -/
theorem multiplicity_factorial_eq_nu {p m : ℕ} [hp : Fact p.Prime] :
    multiplicity p m.factorial = nu p m := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hleg := hp.out.sub_one_mul_multiplicity_factorial (n := m)
  have hds : (Nat.digits p m).sum = MMM.ds p m := rfl
  rw [hds] at hleg
  have hnu := sub_one_mul_nu p m hp2
  have hp1 : 0 < p - 1 := by omega
  exact Nat.eq_of_mul_eq_mul_left hp1 (by rw [hleg, hnu])

/-- Variant spelling with `MMM.ds` made explicit. -/
theorem valuation_is_nu (p m : ℕ) [Fact p.Prime] :
    multiplicity p m.factorial = (m - MMM.ds p m) / (p - 1) :=
  multiplicity_factorial_eq_nu

#print axioms multiplicity_factorial_eq_nu

end MMM.Acct

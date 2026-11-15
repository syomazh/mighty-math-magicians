/-
Written by Kimi K3.1 Pro (an Open Math OS worker, brief W057a), 2026-11-15. Not human-reviewed.

Legendre's formula as in the accounting proof (Appendix C of the report, `paper/accounting_proof.tex`).

With `K(a)` = the real count of permutations of `p * a` points all of whose cycles have length `p`
(`MMM.LegendreDefs`), we prove `K(a) * a! * p^a = (p*a)!` from Mathlib's formula for the number of
permutations of a given cycle type (`Equiv.Perm.card_of_cycleType_mul_eq`). This counting identity
is the text's statement; the proof here is the textbook cycle-index count, which is what the text
implicitly uses. The binomial congruence `binom(p*a+r, r) ≡ 1` and the group-action congruence
`K(a) ≡ (-1)^a` are taken as hypotheses for L4; separately we also supply `K(a) ≡ (-1)^a` via
Wilson's theorem (`Kcount_eq_W`, NOT the text's argument: the text conjugates by a p-cycle).
The recursion for `forestCount` and Lemma L3's identity
`m! = p^ν(m) * ∏ (m_j)! * forestCount m` are exactly the text's argument.
-/
import MMM.LegendreDefs
import MMM.Dwork
import Mathlib.GroupTheory.Perm.Centralizer

namespace MMM

open Equiv

open scoped Finset

/-! ### K(a) as a real count -/

/-- p·a points are grouped into a cyclically ordered p-sets in K(a) ways: K(a) · a! · p^a = (p a)!. -/
theorem Kcount_mul (p : ℕ) [Fact p.Prime] (a : ℕ) :
    Kcount p a * (a.factorial * p ^ a) = (p * a).factorial := by
  have hp2 : 2 ≤ p := (Fact.out : Nat.Prime p).two_le
  classical
  set m : Multiset ℕ := Multiset.replicate a p with hm
  have hsum : m.sum = a * p := by
    have h := Multiset.sum_replicate a p
    rw [smul_eq_mul] at h
    simp [hm, h]
  have hprod : m.prod = p ^ a := by simp [hm, Multiset.prod_replicate]
  have hcard : Fintype.card (Fin (p * a)) = p * a := by simp
  have hcond : m.sum ≤ Fintype.card (Fin (p * a)) ∧ ∀ b ∈ m, 2 ≤ b := by
    constructor
    · rw [hsum, hcard, Nat.mul_comm a p]
    · intro b hb
      rw [hm, Multiset.mem_replicate] at hb
      exact hb.2 ▸ hp2
  have hcount_toFin : ∏ n ∈ m.toFinset, (m.count n).factorial = a.factorial := by
    rcases Nat.eq_zero_or_pos a with rfl | ha
    · simp [hm]
    · have hd : m.toFinset = {p} := by
        ext b
        simp only [Multiset.mem_toFinset, hm, Multiset.mem_replicate, Finset.mem_singleton]
        constructor
        · rintro ⟨_, rfl⟩; rfl
        · rintro rfl; exact ⟨Nat.pos_iff_ne_zero.mp ha, rfl⟩
      rw [hd]
      simp [hm, Multiset.count_replicate_self]
  have hcount : (Kcount p a : ℕ) =
      #({g : Equiv.Perm (Fin (p * a)) | g.cycleType = m} : Finset (Equiv.Perm (Fin (p * a)))) := by
    rw [Kcount, Nat.card_eq_fintype_card, Fintype.card_subtype]
  have hmul := Equiv.Perm.card_of_cycleType_mul_eq (Fin (p * a)) m
  rw [ite_eq_left hcond, hcard, ← hcount] at hmul
  have hsub : p * a - m.sum = 0 := by rw [hsum, Nat.mul_comm a p, Nat.sub_self]
  rw [hsub, hprod, hcount_toFin] at hmul
  have h2 := hmul
  simp at h2
  calc Kcount p a * (a.factorial * p ^ a)
      = Kcount p a * (p ^ a * a.factorial) := by ring
    _ = (p * a).factorial := h2

/-! ### The forest count -/

/-- The number of digit-forest structures on m points, by the recursion of Lemma L3:
1 for m = 0 or p < 2, and binom(m, m % p) · K(m / p) · (the number for m / p) otherwise. -/
noncomputable def forestCount (p : ℕ) : ℕ → ℕ
  | m =>
    if m = 0 ∨ p < 2 then 1
    else Nat.choose m (m % p) * Kcount p (m / p) * forestCount p (m / p)
  termination_by m => m
  decreasing_by
    rename_i hm
    have hp2 : 2 ≤ p := by
      simp only [not_or, not_lt] at hm
      exact hm.2
    have hm0 : 0 < m := Nat.pos_of_ne_zero (by simp at hm; exact hm.1)
    exact Nat.div_lt_self hm0 hp2

theorem forestCount_zero (p : ℕ) : forestCount p 0 = 1 := by
  unfold forestCount
  simp

theorem forestCount_eq (p : ℕ) (hp : 2 ≤ p) (m : ℕ) (hm : 0 < m) :
    forestCount p m = Nat.choose m (m % p) * Kcount p (m / p) * forestCount p (m / p) := by
  conv_lhs => unfold forestCount
  have hcond : ¬ (m = 0 ∨ p < 2) := by
    rintro (h | h)
    · omega
    · omega
  exact ite_eq_right hcond

/-! ### Lemma L3 -/

/-- **Lemma L3.** -/
theorem factorial_eq_forestCount (p : ℕ) [Fact p.Prime] (m : ℕ) :
    m.factorial = p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * forestCount p m := by
  have hp2 : 2 ≤ p := (Fact.out : Nat.Prime p).two_le
  have hp0 : 0 < p := by omega
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    have hr : m % p < p := Nat.mod_lt _ hp0
    have hm : m = p * (m / p) + m % p := (Nat.div_add_mod m p).symm
    rcases Nat.eq_zero_or_pos m with rfl | hm0
    · have hnu0 : nu p 0 = 0 := by
        simp [nu, ds]
      simp [Nat.factorial_zero, forestCount_zero, hnu0]
    · have halt : m / p < m := Nat.div_lt_self hm0 hp2
      have iha := ih (m / p) halt
      set a := m / p with ha_def
      set r := m % p with hr_def
      have hnu : nu p m = a + nu p a := by
        conv_lhs => rw [hm]
        exact nu_mul_add hp2 a r hr
      have hprod : (∏ j ∈ Finset.range m, (dig p j m).factorial) =
          r.factorial * ∏ j ∈ Finset.range a, (dig p j a).factorial := by
        conv_lhs => rw [hm]
        exact prod_dig_mul_add hp2 a r hr
      have hmfact : m.factorial = (Nat.choose m r) * r.factorial * (p * a).factorial := by
        have hmr : m - r = p * a := by rw [hm]; omega
        have h := Nat.choose_mul_factorial_mul_factorial (show r ≤ m by omega) (k := r)
        rw [hmr] at h
        rw [← h]
      have hk : (p * a).factorial = Kcount p a * (a.factorial * p ^ a) :=
        (Kcount_mul p a).symm
      rw [hmfact, hk, iha, hnu, hprod, pow_add, forestCount_eq p hp2 m hm0, ha_def, hr_def]
      ring

/-! ### Lemma L4 from the two congruences -/

/-- **Lemma L4, from its two congruences.** -/
theorem forestCount_modEq_of (p : ℕ) [Fact p.Prime]
    (hK : ∀ a, (Kcount p a : ZMod p) = (-1) ^ a)
    (hC : ∀ a r, r < p → ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1) (m : ℕ) :
    (forestCount p m : ZMod p) = (-1) ^ nu p m := by
  have hp2 : 2 ≤ p := (Fact.out : Nat.Prime p).two_le
  have hp0 : 0 < p := by omega
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    have hr : m % p < p := Nat.mod_lt _ hp0
    have hm : m = p * (m / p) + m % p := (Nat.div_add_mod m p).symm
    rcases Nat.eq_zero_or_pos m with rfl | hm0
    · have hnu0 : nu p 0 = 0 := by
        simp [nu, ds]
      simp [forestCount_zero, hnu0]
    · have halt : m / p < m := Nat.div_lt_self hm0 hp2
      have iha := ih (m / p) halt
      set a := m / p with ha_def
      set r := m % p with hr_def
      have hnu : nu p m = a + nu p a := by
        conv_lhs => rw [hm]
        exact nu_mul_add hp2 a r hr
      rw [forestCount_eq p hp2 m hm0]
      have hCm : ((Nat.choose m r : ℕ) : ZMod p) = 1 := by
        conv_lhs => rw [hm]
        exact hC a r hr
      push_cast
      rw [hCm, hK a, iha, hnu, pow_add]
      ring

/-- K(a) is the number W(a) of `Dwork.lean` (both satisfy x · a! · p^a = (p a)!), hence K(a) ≡ (-1)^a
by Wilson's theorem. This is NOT the text's argument (conjugation by a p-cycle). -/
theorem Kcount_eq_W (p : ℕ) [Fact p.Prime] (a : ℕ) : Kcount p a = W p a := by
  have hp0 : 0 < p := by have := (Fact.out : Nat.Prime p).two_le; omega
  have hK := Kcount_mul p a
  have hW := factorial_mul_eq hp0 a
  -- hK : Kcount p a * (a! * p^a) = (p*a)!
  -- hW : (p*a)! = p^a * a! * W p a
  rw [hW] at hK
  have hpos : 0 < a.factorial * p ^ a := by positivity
  exact Nat.eq_of_mul_eq_mul_right hpos (by rw [hK]; ring)

theorem Kcount_modEq_wilson (p : ℕ) [Fact p.Prime] (a : ℕ) : (Kcount p a : ZMod p) = (-1) ^ a := by
  rw [Kcount_eq_W]; exact W_cast a

/-- Legendre's formula with its residue, by the recursion of the accounting proof; the two
congruences are hypotheses. -/
theorem factorial_eq_pow_mul_prod_mul_sym_of (p : ℕ) [Fact p.Prime]
    (hK : ∀ a, (Kcount p a : ZMod p) = (-1) ^ a)
    (hC : ∀ a r, r < p → ((Nat.choose (p * a + r) r : ℕ) : ZMod p) = 1) (m : ℕ) :
    ∃ u : ℕ, m.factorial = p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m :=
  ⟨forestCount p m, factorial_eq_forestCount p m, forestCount_modEq_of p hK hC m⟩


end MMM

/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
The last step of the Frobenius proof (`paper/frobenius_proof.tex`, Theorem "Residue"): for
m ≡ 1 (mod p^k - 1) with s_p(m) = (p - 1) t + 1, the number C of p-ary trees with m leaves, all
at a depth divisible by k (these are the q-ary trees, q = p^k), satisfies

    C · ∏_j m_j!  ≡  (-p)^t   (mod p^(t+1)),

hence p^t divides C exactly. No symmetry of trees is used. The pieces:

* `Weight.lean`: the coefficient of x^m in F_0 is divisible by y^t;
* `TreeGF.lean`: F_0 at y = p is the generating function of these trees;
* `Subst.lean`: the leading coefficient times ∏ m_j! is the coefficient T_0(a(m)) of the
  labelled series;
* `Carry.lean` and `Eval.lean`: T_0(a) ≡ (-1)^((|a| - 1)/(p - 1)) modulo p.
-/
import MMM.Frob.FinalGlue
import MMM.Frob.Carry
import MMM.Frob.Divisibility

namespace MMM.Frob

open MMM PTree

/-- The coefficients of the family H satisfy the recursion that `Subst.lean` asks for. -/
theorem labelledRec_T (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] : LabelledRec p k (T p k) := by
  refine ⟨fun δ => T_zero δ, fun δ a => ?_⟩
  have h := T_rec p k δ a
  unfold tuplesOf mmultinomial
  convert h using 2

/-- T_0(a(m)) modulo p. -/
theorem T_digitVec_modEq (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (m t : ℕ)
    (hmod : m ≡ 1 [MOD p ^ k - 1]) (ht : ds p m = (p - 1) * t + 1) :
    T p k 0 (digitVec p k m) ≡ (-1) ^ t [ZMOD p] := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hm : 0 < m := by
    rcases Nat.eq_zero_or_pos m with h | h
    · subst h
      rw [ds_zero] at ht
      omega
    · exact h
  have h1 : T p k 0 (Pi.single (0 : ZMod k) 1) = 1 := by
    rw [T_single]
    simp
  have hw : wt p k (digitVec p k m) ≡ 1 [MOD p ^ k - 1] := (wt_digitVec p k m).trans hmod
  have h := eval_of_carry p k (T p k 0) h1 (fun b c => carry p k 0 c b) (digitVec p k m)
    (digitVec_ne_zero hp k hm) hw
  rw [sum_digitVec hp k m, ht, Nat.add_sub_cancel, Nat.mul_div_cancel_left t (by omega)] at h
  exact h

/-- The residue, given the passage from the leading part to the labelled series. -/
theorem residue_frobenius_of (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (m t : ℕ)
    (hmod : m ≡ 1 [MOD p ^ k - 1]) (ht : ds p m = (p - 1) * t + 1)
    (hsub : lead p (solution p k 0) m * (digitFact p m : ℤ) = T p k 0 (digitVec p k m)) :
    (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} : ℤ) * (digitFact p m : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hcard : (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} : ℤ) =
      Polynomial.eval (p : ℤ) ((solution p k (0 : ZMod k)).coeff m) := by
    have h := evalY_solution_eq_treeGF p k 0
    rw [Nat.cast_zero] at h
    have heval : (evalY p (solution p k (0 : ZMod k))).coeff m =
        Polynomial.eval (p : ℤ) ((solution p k (0 : ZMod k)).coeff m) := by simp [evalY]
    rw [h] at heval
    rw [← heval]
    simp [treeGF, PowerSeries.coeff_mk]
  have hX : (Polynomial.X : Polynomial ℤ) ^ t ∣ (solution p k (0 : ZMod k)).coeff m :=
    X_pow_dvd_coeff_solution p k 0 m t ht
  have h1 := eval_modEq_of_X_pow_dvd ((solution p k (0 : ZMod k)).coeff m) (p : ℤ) t hX
  have hlead : lead p (solution p k (0 : ZMod k)) m =
      ((solution p k (0 : ZMod k)).coeff m).coeff t := lead_eq_coeff hp _ m t ht
  have h2 : ((solution p k (0 : ZMod k)).coeff m).coeff t * (digitFact p m : ℤ) ≡
      (-1) ^ t [ZMOD p] := by
    rw [← hlead, hsub]
    exact T_digitVec_modEq p k m t hmod ht
  have h3 := h2.mul_left' (c := (p : ℤ) ^ t)
  have h4 := h1.mul_right (digitFact p m : ℤ)
  rw [hcard]
  refine h4.trans ?_
  have e : (-(p : ℤ)) ^ t = (p : ℤ) ^ t * (-1) ^ t := by
    rw [← mul_pow]
    congr 1
    ring
  rw [e, pow_succ, mul_assoc]
  exact h3

/-- **The residue, by the Frobenius proof.** For m ≡ 1 (mod p^k - 1) with
s_p(m) = (p - 1) t + 1, the number C of p-ary trees with m leaves, all at depths divisible by k,
satisfies C · ∏_j m_j! ≡ (-p)^t (mod p^(t+1)). -/
theorem residue_frobenius (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (m t : ℕ)
    (hmod : m ≡ 1 [MOD p ^ k - 1]) (ht : ds p m = (p - 1) * t + 1) :
    (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} : ℤ) * (digitFact p m : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] :=
  residue_frobenius_of p k m t hmod ht
    (lead_mul_digitFact p k (T p k) (labelledRec_T p k) 0 m)

/-- Exactness from the residue: p^(t+1) does not divide the number of trees. -/
theorem not_pow_succ_dvd_of_residue (p : ℕ) [Fact p.Prime] (C D t : ℕ)
    (h : (C : ℤ) * (D : ℤ) ≡ (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)]) : ¬ p ^ (t + 1) ∣ C := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  intro hdvd
  have h1 : (p : ℤ) ^ (t + 1) ∣ (C : ℤ) * (D : ℤ) :=
    Dvd.dvd.mul_right (by exact_mod_cast hdvd) _
  have h2 : (p : ℤ) ^ (t + 1) ∣ (-(p : ℤ)) ^ t := by
    have h3 := Int.modEq_iff_dvd.mp h
    have h4 := dvd_add h1 h3
    rwa [add_sub_cancel] at h4
  have h5 : (p : ℤ) ^ (t + 1) ∣ (p : ℤ) ^ t :=
    dvd_trans h2 (pow_dvd_pow_of_dvd (neg_dvd.mpr dvd_rfl) t)
  have h6 : p ^ (t + 1) ∣ p ^ t := by exact_mod_cast h5
  have h7 := Nat.le_of_dvd (pow_pos (by omega) t) h6
  have h8 : p ^ t < p ^ (t + 1) := Nat.pow_lt_pow_right (by omega) (Nat.lt_succ_self t)
  omega

/-- **The exact power of p, by the Frobenius proof**: p^t divides the number of these trees and
p^(t+1) does not. -/
theorem exact_valuation_blocked_frobenius (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (m t : ℕ)
    (hmod : m ≡ 1 [MOD p ^ k - 1]) (ht : ds p m = (p - 1) * t + 1) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} :=
  ⟨pow_dvd_card_blocked_frobenius p k 0 m t ht,
    not_pow_succ_dvd_of_residue p _ _ t (residue_frobenius p k m t hmod ht)⟩

end MMM.Frob

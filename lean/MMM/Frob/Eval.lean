/-
Started by Kimi K3.1 Pro (Open Math OS worker W039, cut off), finished by Claude Fable 5.2
(a subagent of the orchestrator), 2026-11-14. Not human-reviewed.

Proposition "Evaluation" (`prop:eval` of `paper/frobenius_proof.tex`), stated for an arbitrary
function `T0` on multi-indices that satisfies the carry congruence and takes the value 1 at the
unit vector e_0. Self-contained: Mathlib only.
-/
import Mathlib.Tactic

namespace MMM.Frob

/-- The weight Σ_c a_c p^c of a multi-index. -/
def wt (p k : ℕ) [NeZero k] (a : ZMod k → ℕ) : ℕ := ∑ c, a c * p ^ c.val

/-- Reducing a weight modulo `p - 1` gives the total size. -/
theorem wt_modEq_sum (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (a : ZMod k → ℕ) :
    wt p k a ≡ ∑ c, a c [MOD p - 1] := by
  classical
  have hp : p ≡ 1 [MOD p - 1] := Nat.modEq_sub (Fact.out : p.Prime).one_le
  unfold wt
  induction (Finset.univ : Finset (ZMod k)) using Finset.induction_on with
  | empty => exact Nat.ModEq.rfl
  | @insert c s hc ih =>
    simp only [Finset.sum_insert hc]
    simpa using (Nat.ModEq.rfl.mul (hp.pow c.val)).add ih

theorem sum_modEq_one_of_wt (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (a : ZMod k → ℕ)
    (hw : wt p k a ≡ 1 [MOD p ^ k - 1]) : (∑ c, a c) ≡ 1 [MOD p - 1] := by
  exact (wt_modEq_sum p k a).symm.trans (hw.of_dvd (Nat.sub_one_dvd_pow_sub_one p k))

/-! ### Sums and weights of `b + n e_c` -/

lemma sum_add_apply {k : ℕ} [NeZero k] (a b : ZMod k → ℕ) :
    ∑ d, (a + b) d = (∑ d, a d) + ∑ d, b d := by
  simp only [Pi.add_apply, Finset.sum_add_distrib]

lemma smul_single_one {k : ℕ} [NeZero k] (c : ZMod k) (n : ℕ) :
    (n • Pi.single c 1 : ZMod k → ℕ) = Pi.single c n := by
  funext d
  simp [Pi.single_apply]

lemma wt_add (p k : ℕ) [NeZero k] (a b : ZMod k → ℕ) :
    wt p k (a + b) = wt p k a + wt p k b := by
  simp only [wt, Pi.add_apply, add_mul, Finset.sum_add_distrib]

lemma wt_single (p k : ℕ) [NeZero k] (c : ZMod k) (n : ℕ) :
    wt p k (Pi.single c n) = n * p ^ c.val := by
  unfold wt
  rw [Finset.sum_eq_single c]
  · rw [Pi.single_eq_same]
  · intro d _ hd
    rw [Pi.single_eq_of_ne hd, zero_mul]
  · intro h
    exact absurd (Finset.mem_univ c) h

/-! ### The weight is unchanged by a carry, modulo `p ^ k - 1` -/

lemma val_add_one {k : ℕ} [NeZero k] (c : ZMod k) : (c + 1).val = (c.val + 1) % k := by
  rw [ZMod.val_add, ZMod.val_one_eq_one_mod, Nat.add_mod_mod]

lemma pow_mod_modEq (p k m : ℕ) (hp : 0 < p) : p ^ (m % k) ≡ p ^ m [MOD p ^ k - 1] := by
  have h1 : p ^ k ≡ 1 [MOD p ^ k - 1] := Nat.modEq_sub (Nat.one_le_pow _ _ hp)
  have h2 : p ^ m = (p ^ k) ^ (m / k) * p ^ (m % k) := by
    rw [← pow_mul, ← pow_add, Nat.div_add_mod]
  have h3 := (h1.pow (m / k)).mul_right (p ^ (m % k))
  rw [one_pow, one_mul, ← h2] at h3
  exact h3.symm

lemma carry_weight_modEq (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k]
    (b : ZMod k → ℕ) (c : ZMod k) :
    wt p k (b + Pi.single (c + 1) 1) ≡ wt p k (b + p • Pi.single c 1)
      [MOD p ^ k - 1] := by
  rw [smul_single_one, wt_add, wt_add, wt_single, wt_single, one_mul, val_add_one, ← pow_succ']
  exact (pow_mod_modEq p k (c.val + 1) (Fact.out : p.Prime).pos).add_left _

/-! ### A multi-index with all entries below `p` and weight ≡ 1 is the unit vector e_0 -/

lemma pred_mul_geom_sum (p k : ℕ) (hp : 0 < p) :
    (p - 1) * ∑ i ∈ Finset.range k, p ^ i + 1 = p ^ k := by
  obtain ⟨q, rfl⟩ : ∃ q, p = q + 1 := ⟨p - 1, by omega⟩
  simp only [Nat.add_sub_cancel]
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, mul_add, add_right_comm, ih]
    ring

lemma sum_zmod_val (k : ℕ) [NeZero k] (f : ℕ → ℕ) :
    ∑ c : ZMod k, f c.val = ∑ i ∈ Finset.range k, f i := by
  refine Finset.sum_nbij' (fun c => c.val) (fun i => (i : ZMod k)) ?_ ?_ ?_ ?_ ?_
  · intro c _
    exact Finset.mem_range.mpr (ZMod.val_lt c)
  · intro i _
    exact Finset.mem_univ _
  · intro c _
    exact ZMod.natCast_zmod_val c
  · intro i hi
    exact ZMod.val_cast_of_lt (Finset.mem_range.mp hi)
  · intro c _
    rfl

lemma wt_le_of_lt (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (a : ZMod k → ℕ)
    (h : ∀ c, a c < p) : wt p k a ≤ p ^ k - 1 := by
  have hp : 0 < p := (Fact.out : p.Prime).pos
  have h1 : wt p k a ≤ ∑ c : ZMod k, (p - 1) * p ^ c.val :=
    Finset.sum_le_sum fun c _ => Nat.mul_le_mul_right _ (by have := h c; omega)
  have h3 : ∑ c : ZMod k, p ^ c.val = ∑ i ∈ Finset.range k, p ^ i :=
    sum_zmod_val k (fun i => p ^ i)
  rw [← Finset.mul_sum, h3] at h1
  have h2 := pred_mul_geom_sum p k hp
  omega

lemma eq_one_of_modEq {N W : ℕ} (h1 : 1 ≤ W) (h2 : W ≤ N) (h : W ≡ 1 [MOD N]) : W = 1 := by
  rcases Nat.lt_or_ge N 2 with hN | hN
  · omega
  · have h1N : 1 % N = 1 := Nat.mod_eq_of_lt (by omega)
    unfold Nat.ModEq at h
    rw [h1N] at h
    rcases Nat.lt_or_eq_of_le h2 with h3 | h3
    · rw [Nat.mod_eq_of_lt h3] at h
      exact h
    · rw [h3, Nat.mod_self] at h
      omega

lemma eq_single_of_wt_eq_one (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (a : ZMod k → ℕ)
    (h : wt p k a = 1) : a = Pi.single 0 1 := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hle : ∀ c, a c * p ^ c.val ≤ 1 := fun c => by
    rw [← h]
    exact Finset.single_le_sum_of_canonicallyOrdered (f := fun c => a c * p ^ c.val)
      (Finset.mem_univ c)
  have hz : ∀ c, c ≠ 0 → a c = 0 := by
    intro c hc
    have hv : c.val ≠ 0 := fun h0 => hc ((ZMod.val_eq_zero c).mp h0)
    have h2 : 2 ≤ p ^ c.val :=
      calc 2 ≤ p := hp
        _ = p ^ 1 := (pow_one p).symm
        _ ≤ p ^ c.val := Nat.pow_le_pow_right (by omega) (by omega)
    by_contra hne
    have h3 : 1 * 2 ≤ a c * p ^ c.val := Nat.mul_le_mul (by omega) h2
    have h4 := hle c
    omega
  have h0 : a 0 = 1 := by
    have h5 : wt p k a = a 0 * p ^ (0 : ZMod k).val := by
      unfold wt
      exact Finset.sum_eq_single 0 (fun c _ hc => by rw [hz c hc, zero_mul])
        (fun h => absurd (Finset.mem_univ _) h)
    rw [ZMod.val_zero, pow_zero, mul_one] at h5
    omega
  funext d
  by_cases hd : d = 0
  · rw [hd, Pi.single_eq_same, h0]
  · rw [hz d hd, Pi.single_eq_of_ne hd]

/-! ### The evaluation -/

/-- Proposition "Evaluation": a function `T0` on multi-indices with `T0 e_0 = 1` that satisfies
the carry congruence `T0 (b + p e_c) + T0 (b + e_{c+1}) ≡ 0 (mod p)` is determined modulo `p` on
the multi-indices `a ≠ 0` of weight ≡ 1 modulo `p ^ k - 1`: there it is a sign. -/
theorem eval_of_carry (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (T0 : (ZMod k → ℕ) → ℤ)
    (h1 : T0 (Pi.single 0 1) = 1)
    (hcarry : ∀ (b : ZMod k → ℕ) (c : ZMod k),
      (p : ℤ) ∣ T0 (b + p • Pi.single c 1) + T0 (b + Pi.single (c + 1) 1))
    (a : ZMod k → ℕ) (ha : a ≠ 0) (hw : wt p k a ≡ 1 [MOD p ^ k - 1]) :
    T0 a ≡ (-1) ^ (((∑ c, a c) - 1) / (p - 1)) [ZMOD p] := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  suffices H : ∀ n : ℕ, ∀ a : ZMod k → ℕ, (∑ c, a c) = n → a ≠ 0 →
      wt p k a ≡ 1 [MOD p ^ k - 1] → T0 a ≡ (-1) ^ ((n - 1) / (p - 1)) [ZMOD p] from
    H _ a rfl ha hw
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro a hn ha hw
    by_cases hbig : ∃ c, p ≤ a c
    · -- Some entry is at least p: carry.
      obtain ⟨c, hc⟩ := hbig
      obtain ⟨b, hb⟩ : ∃ b : ZMod k → ℕ, a = b + p • Pi.single c 1 := by
        refine ⟨fun d => a d - (Pi.single c p : ZMod k → ℕ) d, ?_⟩
        rw [smul_single_one]
        funext d
        show a d = (a d - (Pi.single c p : ZMod k → ℕ) d) + (Pi.single c p : ZMod k → ℕ) d
        refine (Nat.sub_add_cancel ?_).symm
        by_cases hd : d = c
        · rw [hd, Pi.single_eq_same]
          exact hc
        · rw [Pi.single_eq_of_ne hd]
          exact Nat.zero_le _
      subst hb
      have hsum : ∑ d, (b + p • Pi.single c 1 : ZMod k → ℕ) d = (∑ d, b d) + p := by
        rw [smul_single_one, sum_add_apply, Fintype.sum_pi_single']
      have hsum' : ∑ d, (b + Pi.single (c + 1) 1 : ZMod k → ℕ) d = (∑ d, b d) + 1 := by
        rw [sum_add_apply, Fintype.sum_pi_single']
      rw [hsum] at hn
      generalize (∑ d, b d) = m at hsum' hn
      have hne' : b + Pi.single (c + 1) 1 ≠ 0 := by
        intro h0
        rw [h0] at hsum'
        simp at hsum'
      have hw' : wt p k (b + Pi.single (c + 1) 1) ≡ 1 [MOD p ^ k - 1] :=
        (carry_weight_modEq p k b c).trans hw
      have hdvd : p - 1 ∣ m := by
        have h := sum_modEq_one_of_wt p k _ hw'
        rw [hsum'] at h
        have h' : m + 1 ≡ 0 + 1 [MOD p - 1] := by rwa [zero_add]
        exact Nat.modEq_zero_iff_dvd.mp (Nat.ModEq.add_right_cancel' 1 h')
      obtain ⟨t, rfl⟩ := hdvd
      have hIH := ih ((p - 1) * t + 1) (by omega) _ hsum' hne' hw'
      have e1 : ((p - 1) * t + 1 - 1) / (p - 1) = t := by
        rw [Nat.add_sub_cancel]
        exact Nat.mul_div_cancel_left t (by omega)
      have e2 : (n - 1) / (p - 1) = t + 1 := by
        have h : n - 1 = (p - 1) * (t + 1) := by
          rw [mul_add, mul_one]
          omega
        rw [h]
        exact Nat.mul_div_cancel_left _ (by omega)
      rw [e1] at hIH
      rw [e2]
      have hcar := hcarry b c
      rw [Int.modEq_iff_dvd] at hIH ⊢
      have key : (-1 : ℤ) ^ (t + 1) - T0 (b + p • Pi.single c 1) =
          -((-1) ^ t - T0 (b + Pi.single (c + 1) 1)) -
            (T0 (b + p • Pi.single c 1) + T0 (b + Pi.single (c + 1) 1)) := by
        ring
      rw [key]
      exact dvd_sub (dvd_neg.mpr hIH) hcar
    · -- Every entry is below p: then a = e_0.
      push Not at hbig
      have hpos : 1 ≤ wt p k a := by
        obtain ⟨c, hc⟩ : ∃ c, a c ≠ 0 := by
          by_contra hall
          push Not at hall
          exact ha (funext hall)
        calc 1 ≤ a c * p ^ c.val :=
              Nat.one_le_iff_ne_zero.mpr (Nat.mul_ne_zero hc (pow_ne_zero _ (by omega)))
          _ ≤ wt p k a :=
              Finset.single_le_sum_of_canonicallyOrdered (f := fun c => a c * p ^ c.val)
                (Finset.mem_univ c)
      have hW : wt p k a = 1 := eq_one_of_modEq hpos (wt_le_of_lt p k a hbig) hw
      have ha1 := eq_single_of_wt_eq_one p k a hW
      subst ha1
      rw [Fintype.sum_pi_single'] at hn
      rw [← hn]
      have key : T0 (Pi.single 0 1) = (-1) ^ ((1 - 1) / (p - 1)) := by
        rw [h1]
        simp
      calc T0 (Pi.single 0 1) = (-1) ^ ((1 - 1) / (p - 1)) := key
        _ ≡ (-1) ^ ((1 - 1) / (p - 1)) [ZMOD p] := Int.ModEq.refl _

end MMM.Frob

/-
Written by moonshotai/kimi-k3.1-pro (AI, worker W028), 2026-11-14. Machine-checked by Lean when
this file compiles; not human-reviewed.

  **Legendre's formula with its residue, and the Dwork form** (claim C20):

      m! = p ^ ν(m) * ∏_j (m_j)! * u,   u ≡ (-1) ^ ν(m)   (mod p),

where `ν(m) = (m - s_p(m)) / (p - 1)` is the exponent of `p` in `m!`, and

      #(q-ary trees with m leaves) * m! ≡ (-p) ^ N   (mod p ^ (N + 1)),  N = (m - 1) / (p - 1).

The first is proved by strong induction on `m`, writing `m = p * a + r` and using Wilson's theorem
for each block of `p - 1` consecutive factors. The second combines it with
`PTree.residue_primePower`.
-/
import MMM.ResidueB
import MMM.Exact
import MMM.DigitsFree
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Data.Nat.Factorial.BigOperators
import Mathlib.Data.Nat.Prime.Factorial
import Mathlib.NumberTheory.Wilson
import Mathlib.Tactic.LinearCombination

namespace MMM

/-- `ν(m) = (m - s_p(m)) / (p - 1)`: the exponent of `p` in `m!`. -/
def nu (p m : ℕ) : ℕ := (m - ds p m) / (p - 1)

section Helpers

variable {p : ℕ}

/-- The product of the non-multiples of `p` in the ranges `[pc+1, pc+p-1]`, `c < a`. -/
def W (p a : ℕ) : ℕ := ∏ c ∈ Finset.range a, ∏ s ∈ Finset.range (p - 1), (p * c + s + 1)

/-- Splitting off the top block. -/
lemma W_succ (p a : ℕ) : W p (a + 1) = W p a * ∏ s ∈ Finset.range (p - 1), (p * a + s + 1) := by
  unfold W
  exact Finset.prod_range_succ _ a

/-- A remainder of the factorial: the top `r` factors above `a`. -/
def V (a r : ℕ) : ℕ := ∏ s ∈ Finset.range r, (a + s + 1)

lemma V_zero (a : ℕ) : V a 0 = 1 := by simp [V]

lemma V_succ (a r : ℕ) : V a (r + 1) = V a r * (a + r + 1) := by
  unfold V
  exact Finset.prod_range_succ _ r

/-- `V a r` is the ascending factorial `(a + 1).ascFactorial r`. -/
lemma V_eq_ascFactorial (a r : ℕ) : V a r = (a + 1).ascFactorial r := by
  rw [Nat.ascFactorial_eq_prod_range]
  unfold V
  exact Finset.prod_congr rfl (fun s _ => by ring)

/-- `V a r = r! * choose (a + r) r`. -/
lemma V_eq_factorial_mul_choose (a r : ℕ) :
    V a r = r.factorial * (a + r).choose r := by
  rw [V_eq_ascFactorial, Nat.ascFactorial_eq_factorial_mul_choose]

/-- Appending one factor at a time: `(a + r)! = a! * V a r`. -/
lemma factorial_add_eq (a r : ℕ) : (a + r).factorial = a.factorial * V a r := by
  induction r with
  | zero => simp [V_zero]
  | succ r ih =>
    rw [← Nat.add_assoc, Nat.factorial_succ, ih, V_succ]
    ring

/-- The top `p` factors above `p * a` split into the block and the extra factor `p * (a + 1)`. -/
lemma V_block (hp : 0 < p) (a : ℕ) :
    V (p * a) p = (∏ s ∈ Finset.range (p - 1), (p * a + s + 1)) * (p * (a + 1)) := by
  obtain ⟨b, rfl⟩ : ∃ b, p = b + 1 := ⟨p - 1, by omega⟩
  have hb : b + 1 - 1 = b := by omega
  rw [V_succ, hb]
  have hlast : (b + 1) * a + b + 1 = (b + 1) * (a + 1) := by ring
  rw [hlast]
  rfl

/-- The factorial split: `(p * a)! = p ^ a * a! * W p a`. -/
lemma factorial_mul_eq (hp : 0 < p) : ∀ a : ℕ, (p * a).factorial = p ^ a * a.factorial * W p a := by
  intro a
  induction a with
  | zero => simp [W]
  | succ a ih =>
    have hstep : (p * (a + 1)).factorial = (p * a).factorial * V (p * a) p := by
      have h : p * (a + 1) = p * a + p := by ring
      rw [h, factorial_add_eq]
    rw [hstep, ih, V_block hp, W_succ, Nat.factorial_succ, pow_succ]
    ring

/-- Each block is `(p - 1)!` modulo `p`. -/
lemma block_modEq (a : ℕ) :
    (∏ s ∈ Finset.range (p - 1), (p * a + s + 1) : ℕ) ≡ (p - 1).factorial [MOD p] := by
  have h1 : (∏ s ∈ Finset.range (p - 1), (p * a + s + 1) : ℕ) ≡
      ∏ s ∈ Finset.range (p - 1), (s + 1) [MOD p] :=
    Nat.ModEq.prod (fun s _ => by
      have h0 : p * a ≡ 0 [MOD p] := Nat.modEq_zero_iff_dvd.mpr (dvd_mul_right p a)
      have h := h0.add_right (s + 1)
      rw [zero_add] at h
      calc p * a + s + 1 = p * a + (s + 1) := by ring
        _ ≡ s + 1 [MOD p] := h)
  rwa [Finset.prod_range_add_one_eq_factorial] at h1

/-- `W p a` is `(-1) ^ a` in `ZMod p` (Wilson). -/
lemma W_cast [hp : Fact p.Prime] (a : ℕ) : (W p a : ZMod p) = (-1) ^ a := by
  induction a with
  | zero => simp [W]
  | succ a ih =>
    have hblock : ((∏ s ∈ Finset.range (p - 1), (p * a + s + 1) : ℕ) : ZMod p) = -1 := by
      have h : ((∏ s ∈ Finset.range (p - 1), (p * a + s + 1) : ℕ) : ZMod p) =
          ((p - 1).factorial : ZMod p) := (ZMod.natCast_eq_natCast_iff _ _ _).mpr (block_modEq a)
      rw [h, ZMod.wilsons_lemma]
    rw [W_succ, Nat.cast_mul, ih, hblock, pow_succ]

/-- `V (p * a) r` is `r!` in `ZMod p`. -/
lemma V_cast (a r : ℕ) : (V (p * a) r : ZMod p) = (r.factorial : ZMod p) := by
  have h : V (p * a) r ≡ r.factorial [MOD p] := by
    unfold V
    have h1 : (∏ s ∈ Finset.range r, (p * a + s + 1) : ℕ) ≡
        ∏ s ∈ Finset.range r, (s + 1) [MOD p] :=
      Nat.ModEq.prod (fun s _ => by
        have h0 : p * a ≡ 0 [MOD p] := Nat.modEq_zero_iff_dvd.mpr (dvd_mul_right p a)
        have h := h0.add_right (s + 1)
        rw [zero_add] at h
        calc p * a + s + 1 = p * a + (s + 1) := by ring
          _ ≡ s + 1 [MOD p] := h)
    rwa [Finset.prod_range_add_one_eq_factorial] at h1
  exact (ZMod.natCast_eq_natCast_iff _ _ _).mpr h

/-- The binomial coefficient `choose (p * a + r) r` is `1` in `ZMod p` for `r < p`. -/
lemma choose_cast [hp : Fact p.Prime] {r : ℕ} (hr : r < p) (a : ℕ) :
    (((p * a + r).choose r : ℕ) : ZMod p) = 1 := by
  have hcast : (V (p * a) r : ZMod p) =
      (r.factorial : ZMod p) * (((p * a + r).choose r : ℕ) : ZMod p) := by
    rw [V_eq_factorial_mul_choose]; push_cast; ring
  rw [V_cast] at hcast
  have hunit : IsUnit (r.factorial : ZMod p) :=
    (ZMod.isUnit_iff_coprime _ _).mpr (hp.out.coprime_factorial_of_lt hr).symm
  have h1 : (r.factorial : ZMod p) * (((p * a + r).choose r : ℕ) : ZMod p) =
      (r.factorial : ZMod p) * 1 := by
    rw [mul_one]
    exact hcast.symm
  exact hunit.mul_left_cancel h1

/-- `a + 1 ≤ p ^ a` for `2 ≤ p`. -/
lemma succ_le_pow (hp : 2 ≤ p) (a : ℕ) : a + 1 ≤ p ^ a := by
  induction a with
  | zero => simp
  | succ a ih =>
    calc a + 1 + 1 ≤ (a + 1) + (a + 1) := by omega
      _ ≤ p ^ a + p ^ a := Nat.add_le_add ih ih
      _ = 2 * p ^ a := by ring
      _ ≤ p * p ^ a := Nat.mul_le_mul_right _ hp
      _ = p ^ (a + 1) := by rw [pow_succ]; ring

/-- `p * a + r < p ^ (a + 1)` for `r < p`, `2 ≤ p`. -/
lemma mul_add_lt_pow (hp : 2 ≤ p) {r : ℕ} (hr : r < p) (a : ℕ) :
    p * a + r < p ^ (a + 1) := by
  calc p * a + r < p * a + p := by omega
    _ = p * (a + 1) := by ring
    _ ≤ p * p ^ a := Nat.mul_le_mul_left _ (succ_le_pow hp a)
    _ = p ^ (a + 1) := by rw [pow_succ]; ring

/-- The digit product of `m = p * a + r` re-indexes as `r! * (digit product of a)`. -/
lemma prod_dig_mul_add (hp : 2 ≤ p) (a r : ℕ) (hr : r < p) :
    (∏ j ∈ Finset.range (p * a + r), (dig p j (p * a + r)).factorial) =
      r.factorial * ∏ j ∈ Finset.range a, (dig p j a).factorial := by
  by_cases hm0 : p * a + r = 0
  · have ha0 : a = 0 := by
      rcases Nat.eq_zero_or_pos a with h | h
      · exact h
      · exfalso
        have : 0 < p := by omega
        have : 0 < p * a := Nat.mul_pos this h
        omega
    have hr0 : r = 0 := by omega
    subst ha0 hr0
    simp
  have hposm : 0 < p * a + r := Nat.pos_of_ne_zero hm0
  have hpos : 0 < p := by omega
  have ha_div : (p * a + r) / p = a := by
    rw [Nat.mul_add_div hpos, Nat.div_eq_of_lt hr, add_zero]
  have hm_mod : (p * a + r) % p = r := by
    rw [Nat.mul_add_mod, Nat.mod_eq_of_lt hr]
  have H : ∀ n : ℕ, (∏ j ∈ Finset.range (n + 1), (dig p j (p * a + r)).factorial) =
      r.factorial * ∏ j ∈ Finset.range n, (dig p j a).factorial := by
    intro n
    induction n with
    | zero => simp [dig_zero, hm_mod]
    | succ n ih =>
      rw [Finset.prod_range_succ, ih, Finset.prod_range_succ, dig_succ, ha_div]
      ring
  have hle : a + 1 ≤ p * a + r := by
    rcases Nat.eq_zero_or_pos a with rfl | ha1
    · simp only [mul_zero, zero_add] at hposm ⊢
      omega
    · have := Nat.mul_le_mul_right a hp
      omega
  have hpad : (∏ j ∈ Finset.range (a + 1), (dig p j (p * a + r)).factorial) =
      ∏ j ∈ Finset.range (p * a + r), (dig p j (p * a + r)).factorial := by
    refine Finset.prod_subset (Finset.range_subset_range.mpr hle) ?_
    intro x hxT hxS
    rw [Finset.mem_range] at hxT
    rw [Finset.mem_range] at hxS
    have hlt : p * a + r < p ^ x :=
      (mul_add_lt_pow hp hr a).trans_le (Nat.pow_le_pow_right hpos (by omega))
    rw [dig_eq_zero_of_lt hlt, Nat.factorial_zero]
  rw [← hpad, H a]

/-- The digit sum never exceeds the number. -/
lemma ds_le (hp : 2 ≤ p) : ∀ n : ℕ, ds p n ≤ n := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp
    · rw [ds_rec hp]
      have h1 := ih (n / p) (Nat.div_lt_self hn (by omega))
      have h2 : n / p + n % p ≤ n := by
        have h := Nat.div_add_mod n p
        have h3 : n / p ≤ p * (n / p) := by
          calc n / p = 1 * (n / p) := (one_mul _).symm
            _ ≤ p * (n / p) := Nat.mul_le_mul_right _ (by omega : 1 ≤ p)
        omega
      omega

/-- `ν(p * a + r) = a + ν(a)` for `r < p`. -/
lemma nu_mul_add (hp : 2 ≤ p) (a r : ℕ) (hr : r < p) :
    nu p (p * a + r) = a + nu p a := by
  have hpos : 0 < p := by omega
  have ha_div : (p * a + r) / p = a := by
    rw [Nat.mul_add_div hpos, Nat.div_eq_of_lt hr, add_zero]
  have hm_mod : (p * a + r) % p = r := by
    rw [Nat.mul_add_mod, Nat.mod_eq_of_lt hr]
  have hds : ds p (p * a + r) = r + ds p a := by
    rw [ds_rec hp, hm_mod, ha_div]
  have h1 : p * a + r - ds p (p * a + r) = (p - 1) * a + (a - ds p a) := by
    have hle := ds_le hp a
    have hpa : (p - 1) * a = p * a - a := by rw [Nat.sub_mul, one_mul]
    have hfa : a ≤ p * a := Nat.le_mul_of_pos_left a hpos
    calc p * a + r - ds p (p * a + r) = p * a + r - (r + ds p a) := by rw [hds]
      _ = p * a - ds p a := by omega
      _ = (p * a - a) + (a - ds p a) := by omega
      _ = (p - 1) * a + (a - ds p a) := by rw [← hpa]
  unfold nu
  rw [h1]
  rw [show (p - 1) * a + (a - ds p a) = (a - ds p a) + a * (p - 1) by ring]
  rw [Nat.add_mul_div_right _ _ (show 0 < p - 1 by omega), add_comm]

end Helpers

/-- **Legendre's formula with its residue**: `m! = p ^ ν(m) * ∏ m_j! * u` with
`u ≡ (-1) ^ ν(m)`. -/
theorem factorial_eq_pow_mul_prod_mul (p : ℕ) [Fact p.Prime] (m : ℕ) :
    ∃ u : ℕ, m.factorial =
        p ^ nu p m * (∏ j ∈ Finset.range m, (dig p j m).factorial) * u ∧
      (u : ZMod p) = (-1) ^ nu p m := by
  have hp2 : 2 ≤ p := (Fact.out : Nat.Prime p).two_le
  have hp0 : 0 < p := by omega
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    have hr : m % p < p := Nat.mod_lt _ hp0
    have hm : m = p * (m / p) + m % p := (Nat.div_add_mod m p).symm
    rcases Nat.eq_zero_or_pos (m / p) with ha | ha
    · -- `m < p`: `ν = 0` and the product is `m!`
      have hmr : m = m % p := by
        rw [ha, mul_zero, zero_add] at hm
        exact hm
      have hmp : m < p := by omega
      have hprod : (∏ j ∈ Finset.range m, (dig p j m).factorial) = m.factorial := by
        have h := prod_dig_mul_add hp2 0 (m % p) hr
        simp at h
        rw [hmr]
        exact h
      refine ⟨1, ?_, ?_⟩
      · rw [hprod]
        have hnu : nu p m = 0 := by simp [nu, ds_of_lt hp2 hmp]
        rw [hnu]
        simp
      · have hnu : nu p m = 0 := by simp [nu, ds_of_lt hp2 hmp]
        rw [hnu]
        simp
    · -- `m = p * a + r` with `a ≥ 1`, so `a < m`
      have hm0 : 0 < m := by
        rcases Nat.eq_zero_or_pos m with h | h
        · rw [h] at ha; simp at ha
        · exact h
      have halt : m / p < m := Nat.div_lt_self hm0 hp2
      obtain ⟨ua, hfacta, huca⟩ := ih (m / p) halt
      set a := m / p with ha_def
      set r := m % p with hr_def
      have hnu : nu p m = a + nu p a := by
        conv_lhs => rw [hm]
        exact nu_mul_add hp2 a r hr
      have hprod : (∏ j ∈ Finset.range m, (dig p j m).factorial) =
          r.factorial * ∏ j ∈ Finset.range a, (dig p j a).factorial := by
        conv_lhs => rw [hm]
        exact prod_dig_mul_add hp2 a r hr
      refine ⟨ua * W p a * (p * a + r).choose r, ?_, ?_⟩
      · have hfactm : m.factorial = (p * a).factorial * V (p * a) r := by
          rw [hm, factorial_add_eq]
        rw [hfactm, factorial_mul_eq hp0 a, hfacta, V_eq_factorial_mul_choose, hprod, hnu]
        ring
      · have huc : ((ua * W p a * (p * a + r).choose r : ℕ) : ZMod p) =
            ((-1) ^ nu p a) * ((-1) ^ a) * 1 := by
          push_cast
          rw [huca, W_cast, choose_cast hr]
        rw [huc, hnu]
        ring

/-- **The Dwork form (claim C20)**: `#trees * m! ≡ (-p) ^ N (mod p ^ (N + 1))`,
`N = (m - 1) / (p - 1)`. -/
theorem dwork_form (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (m : ℕ) (hm0 : 0 < m)
    (hm : m ≡ 1 [MOD p ^ k - 1]) :
    (Nat.card {T : PTree (p ^ k) // T.leaves = m} : ℤ) * (m.factorial : ℤ) ≡
      (-(p : ℤ)) ^ ((m - 1) / (p - 1)) [ZMOD (p : ℤ) ^ ((m - 1) / (p - 1) + 1)] := by
  have hp2 : 2 ≤ p := (Fact.out : Nat.Prime p).two_le
  -- `p - 1 ∣ p ^ k - 1`, hence `m ≡ 1 (mod p - 1)`
  have hp1 : p ≡ 1 [MOD p - 1] :=
    ((Nat.modEq_iff_dvd' (by omega : 1 ≤ p)).mpr (dvd_refl _)).symm
  have hpk : 1 ≡ p ^ k [MOD p - 1] := by
    have := hp1.pow k
    rw [one_pow] at this
    exact this.symm
  have hdvd : p - 1 ∣ p ^ k - 1 := (Nat.modEq_iff_dvd' (Nat.one_le_pow _ _ (by omega))).mp hpk
  have hm1 : m ≡ 1 [MOD p - 1] := hm.of_dvd hdvd
  have hpos : 0 < ds p m := ds_pos hp2 _ hm0
  have h1 : ds p m ≡ 1 [MOD p - 1] := (ds_modEq hp2 _).trans hm1
  obtain ⟨t, ht⟩ := (Nat.modEq_iff_dvd' (by omega : 1 ≤ ds p m)).mp h1.symm
  have ht' : (p - 1) * t + 1 = ds p m := by omega
  -- the exponent splits as `ν + t`
  have hN : (m - 1) / (p - 1) = nu p m + t := by
    have hsplit : m - 1 = (m - ds p m) + t * (p - 1) := by
      have ht2 : t * (p - 1) = ds p m - 1 := by rw [mul_comm]; exact ht.symm
      have hle := ds_le hp2 m
      omega
    unfold nu
    rw [hsplit]
    exact Nat.add_mul_div_right _ _ (by omega)
  obtain ⟨u, hfact, huc⟩ := factorial_eq_pow_mul_prod_mul p m
  have hres := PTree.residue_primePower (p := p) k hk m t ht' hm
  obtain ⟨e, he⟩ := Int.modEq_iff_dvd.mp hres
  have hu : (p : ℤ) ∣ (u : ℤ) - (-1) ^ nu p m := by
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    push_cast
    rw [huc]
    ring
  obtain ⟨w, hw⟩ := hu
  have hfact' : (m.factorial : ℤ) =
      (p : ℤ) ^ nu p m * ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) * (u : ℤ) := by
    exact_mod_cast hfact
  rw [Int.modEq_iff_dvd, hN]
  refine ⟨(u : ℤ) * e - (-1 : ℤ) ^ t * w, ?_⟩
  rw [hfact', neg_pow (p : ℤ) (nu p m + t)]
  rw [neg_pow (p : ℤ) t] at he
  linear_combination ((p : ℤ) ^ nu p m * (u : ℤ)) * he +
    (-((p : ℤ) ^ nu p m * ((-1 : ℤ) ^ t * (p : ℤ) ^ t))) * hw

end MMM

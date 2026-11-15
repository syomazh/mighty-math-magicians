/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W043), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **The count of the minimal words, part 1: the recursion for `minWords`.**

`minWords p L n` (defined in `SlotsDef.lean`) is a sum over the letter counts of the top blocks.
This file turns it into a recursion on the list `L`:

* `cfConv`: the "carry-free convolution" of two counting functions: the letter counts `a` and
  `b = n - a` of two parts may be put side by side when `a + b` has no carry and the numbers of
  letters S have no carry (`cfCond`). It is associative (`cfConv_assoc`).
* `minWords_nil`, `minWords_cons`: `minWords p (h :: L)` is the convolution of `minCount p h` and
  `minWords p L` (Step 1 of the brief).
* `minWords_append`: `minWords p (L₁ ++ L₂)` is the convolution of `minWords p L₁` and
  `minWords p L₂` (Step 2).
* `minWords_replicate`: `p` blocks of height `h` side by side are a mixed block of height
  `h + 1` (Step 3; this is `minCount_succ`).
* `minWords_cons_succ`, `minWords_cons_zero`: the first block is all E, all S, or mixed (Step 4).

No factorial and no valuation is used; `p` needs not be prime.
-/
import MMM.Path.SlotsDef

namespace MMM.Path

open MMM

variable {p : ℕ}

section conv

/-- Letter counts `a` (out of `X` letters) and `b` (out of `Y` letters) may be put side by side:
there is no carry in `a + b`, and none in `(X - a) + (Y - b)`. -/
def cfCond (p X Y a b : ℕ) : Prop :=
  a ≤ X ∧ b ≤ Y ∧ ds p a + ds p b = ds p (a + b) ∧
    ds p (X - a) + ds p (Y - b) = ds p (X + Y - (a + b))

instance (p X Y a b : ℕ) : Decidable (cfCond p X Y a b) := by
  unfold cfCond
  infer_instance

/-- The carry-free convolution of two counting functions. -/
def cfConv (p X Y : ℕ) (f g : ℕ → ℕ) (n : ℕ) : ℕ :=
  ∑ a ∈ Finset.range (n + 1), if cfCond p X Y a (n - a) then f a * g (n - a) else 0

/-- No carries among three numbers, bracketed either way. -/
theorem cf_three (hp : 2 ≤ p) (a b c : ℕ) :
    (ds p a + ds p (b + c) = ds p (a + (b + c)) ∧ ds p b + ds p c = ds p (b + c)) ↔
      (ds p (a + b) + ds p c = ds p (a + b + c) ∧ ds p a + ds p b = ds p (a + b)) := by
  have h1 := ds_add_le hp a (b + c)
  have h2 := ds_add_le hp b c
  have h3 := ds_add_le hp (a + b) c
  have h4 := ds_add_le hp a b
  have e : a + (b + c) = a + b + c := (Nat.add_assoc a b c).symm
  rw [e] at h1 ⊢
  constructor <;> rintro ⟨h5, h6⟩ <;> constructor <;> omega

theorem cfCond_assoc (hp : 2 ≤ p) (X Y Z a b c : ℕ) :
    (cfCond p X (Y + Z) a (b + c) ∧ cfCond p Y Z b c) ↔
      (cfCond p (X + Y) Z (a + b) c ∧ cfCond p X Y a b) := by
  unfold cfCond
  constructor
  · rintro ⟨⟨h1, h2, h3, h4⟩, h5, h6, h7, h8⟩
    have e1 : Y + Z - (b + c) = (Y - b) + (Z - c) := by omega
    have e2 : X + (Y + Z) - (a + (b + c)) = (X - a) + ((Y - b) + (Z - c)) := by omega
    have e3 : X + Y - (a + b) = (X - a) + (Y - b) := by omega
    have e4 : X + Y + Z - (a + b + c) = (X - a) + (Y - b) + (Z - c) := by omega
    rw [e1] at h4 h8
    rw [e2] at h4
    obtain ⟨k1, k2⟩ := (cf_three hp a b c).mp ⟨h3, h7⟩
    obtain ⟨k3, k4⟩ := (cf_three hp (X - a) (Y - b) (Z - c)).mp ⟨h4, h8⟩
    refine ⟨⟨by omega, h6, k1, ?_⟩, h1, h5, k2, ?_⟩
    · rw [e3, e4]
      exact k3
    · rw [e3]
      exact k4
  · rintro ⟨⟨h1, h2, h3, h4⟩, h5, h6, h7, h8⟩
    have e1 : Y + Z - (b + c) = (Y - b) + (Z - c) := by omega
    have e2 : X + (Y + Z) - (a + (b + c)) = (X - a) + ((Y - b) + (Z - c)) := by omega
    have e3 : X + Y - (a + b) = (X - a) + (Y - b) := by omega
    have e4 : X + Y + Z - (a + b + c) = (X - a) + (Y - b) + (Z - c) := by omega
    rw [e3] at h4 h8
    rw [e4] at h4
    obtain ⟨k1, k2⟩ := (cf_three hp a b c).mpr ⟨h3, h7⟩
    obtain ⟨k3, k4⟩ := (cf_three hp (X - a) (Y - b) (Z - c)).mpr ⟨h4, h8⟩
    refine ⟨⟨h5, by omega, k1, ?_⟩, h6, h2, k2, ?_⟩
    · rw [e1, e2]
      exact k3
    · rw [e1]
      exact k4

/-- A double sum over `a ≤ s ≤ n`, reindexed by `a` and `b = s - a`. -/
theorem sum_range_sum_range (G : ℕ → ℕ → ℕ) (n : ℕ) :
    ∑ s ∈ Finset.range (n + 1), ∑ a ∈ Finset.range (s + 1), G a (s - a) =
      ∑ a ∈ Finset.range (n + 1), ∑ b ∈ Finset.range (n - a + 1), G a b := by
  induction n with
  | zero => simp
  | succ n ih =>
    have hl : ∑ s ∈ Finset.range (n + 1 + 1), ∑ a ∈ Finset.range (s + 1), G a (s - a) =
        (∑ s ∈ Finset.range (n + 1), ∑ a ∈ Finset.range (s + 1), G a (s - a)) +
          ∑ a ∈ Finset.range (n + 1 + 1), G a (n + 1 - a) := Finset.sum_range_succ _ _
    have hr : ∑ a ∈ Finset.range (n + 1 + 1), ∑ b ∈ Finset.range (n + 1 - a + 1), G a b =
        (∑ a ∈ Finset.range (n + 1), ∑ b ∈ Finset.range (n + 1 - a + 1), G a b) +
          ∑ b ∈ Finset.range (n + 1 - (n + 1) + 1), G (n + 1) b := Finset.sum_range_succ _ _
    have h1 : ∀ a ∈ Finset.range (n + 1), ∑ b ∈ Finset.range (n + 1 - a + 1), G a b =
        ∑ b ∈ Finset.range (n - a + 1), G a b + G a (n + 1 - a) := by
      intro a ha
      have ha' : a < n + 1 := Finset.mem_range.mp ha
      have e : n + 1 - a = (n - a) + 1 := by omega
      rw [e, Finset.sum_range_succ]
    have h2 : ∑ a ∈ Finset.range (n + 1 + 1), G a (n + 1 - a) =
        (∑ a ∈ Finset.range (n + 1), G a (n + 1 - a)) + G (n + 1) (n + 1 - (n + 1)) :=
      Finset.sum_range_succ _ _
    have h3 : ∑ b ∈ Finset.range (n + 1 - (n + 1) + 1), G (n + 1) b = G (n + 1) 0 := by
      rw [Nat.sub_self]
      simp
    rw [hl, hr, ih, Finset.sum_congr rfl h1, Finset.sum_add_distrib, h2, h3, Nat.sub_self]
    omega

/-- The summand of the reindexed right side of `cfConv_assoc`. -/
def assocG (p X Y Z n : ℕ) (f g k : ℕ → ℕ) (a b : ℕ) : ℕ :=
  if cfCond p (X + Y) Z (a + b) (n - (a + b)) then
    (if cfCond p X Y a b then f a * g b else 0) * k (n - (a + b)) else 0

theorem ite_ite_assoc {c1 c2 c3 c4 : Prop} [Decidable c1] [Decidable c2] [Decidable c3]
    [Decidable c4] (hiff : (c1 ∧ c2) ↔ (c3 ∧ c4)) (u v w : ℕ) :
    (if c1 then u * (if c2 then v * w else 0) else 0) =
      (if c3 then (if c4 then u * v else 0) * w else 0) := by
  by_cases hc : c1 ∧ c2
  · obtain ⟨h3, h4⟩ := hiff.mp hc
    rw [ite_eq_left hc.1, ite_eq_left hc.2, ite_eq_left h3, ite_eq_left h4, Nat.mul_assoc]
  · have hc' : ¬ (c3 ∧ c4) := fun h => hc (hiff.mpr h)
    have hl : (if c1 then u * (if c2 then v * w else 0) else 0) = 0 := by
      by_cases h1 : c1
      · have h2 : ¬ c2 := fun h2 => hc ⟨h1, h2⟩
        rw [ite_eq_left h1, ite_eq_right h2, Nat.mul_zero]
      · rw [ite_eq_right h1]
    have hr : (if c3 then (if c4 then u * v else 0) * w else 0) = 0 := by
      by_cases h3 : c3
      · have h4 : ¬ c4 := fun h4 => hc' ⟨h3, h4⟩
        rw [ite_eq_left h3, ite_eq_right h4, Nat.zero_mul]
      · rw [ite_eq_right h3]
    rw [hl, hr]

/-- **The carry-free convolution is associative.** -/
theorem cfConv_assoc (hp : 2 ≤ p) (X Y Z : ℕ) (f g k : ℕ → ℕ) (n : ℕ) :
    cfConv p X (Y + Z) f (cfConv p Y Z g k) n = cfConv p (X + Y) Z (cfConv p X Y f g) k n := by
  have hL : cfConv p X (Y + Z) f (cfConv p Y Z g k) n =
      ∑ a ∈ Finset.range (n + 1), ∑ b ∈ Finset.range (n - a + 1),
        (if cfCond p X (Y + Z) a (n - a) then
          f a * (if cfCond p Y Z b (n - a - b) then g b * k (n - a - b) else 0) else 0) := by
    unfold cfConv
    refine Finset.sum_congr rfl (fun a _ => ?_)
    by_cases hc : cfCond p X (Y + Z) a (n - a)
    · rw [ite_eq_left hc, Finset.mul_sum]
      exact Finset.sum_congr rfl (fun b _ => (ite_eq_left hc).symm)
    · rw [ite_eq_right hc]
      exact (Finset.sum_eq_zero (fun b _ => ite_eq_right hc)).symm
  have hR : cfConv p (X + Y) Z (cfConv p X Y f g) k n =
      ∑ s ∈ Finset.range (n + 1), ∑ a ∈ Finset.range (s + 1), assocG p X Y Z n f g k a (s - a) := by
    unfold cfConv
    refine Finset.sum_congr rfl (fun s _ => ?_)
    have hG : ∀ a ∈ Finset.range (s + 1), assocG p X Y Z n f g k a (s - a) =
        (if cfCond p (X + Y) Z s (n - s) then
          (if cfCond p X Y a (s - a) then f a * g (s - a) else 0) * k (n - s) else 0) := by
      intro a ha
      have ha' : a < s + 1 := Finset.mem_range.mp ha
      have e : a + (s - a) = s := by omega
      unfold assocG
      rw [e]
    rw [Finset.sum_congr rfl hG]
    by_cases hc : cfCond p (X + Y) Z s (n - s)
    · rw [ite_eq_left hc, Finset.sum_mul]
      exact Finset.sum_congr rfl (fun a _ => (ite_eq_left hc).symm)
    · rw [ite_eq_right hc]
      exact (Finset.sum_eq_zero (fun a _ => ite_eq_right hc)).symm
  rw [hL, hR, sum_range_sum_range]
  refine Finset.sum_congr rfl (fun a ha => Finset.sum_congr rfl (fun b hb => ?_))
  have ha' : a < n + 1 := Finset.mem_range.mp ha
  have hb' : b < n - a + 1 := Finset.mem_range.mp hb
  have e1 : n - a = b + (n - a - b) := by omega
  have e2 : n - (a + b) = n - a - b := by omega
  have hiff : (cfCond p X (Y + Z) a (n - a) ∧ cfCond p Y Z b (n - a - b)) ↔
      (cfCond p (X + Y) Z (a + b) (n - a - b) ∧ cfCond p X Y a b) := by
    have h := cfCond_assoc hp X Y Z a b (n - a - b)
    rw [← e1] at h
    exact h
  unfold assocG
  rw [e2]
  exact ite_ite_assoc hiff _ _ _

theorem cfConv_congr_left (X Y : ℕ) (f f' g : ℕ → ℕ) (n : ℕ) (hf : ∀ a, a ≤ X → f a = f' a) :
    cfConv p X Y f g n = cfConv p X Y f' g n := by
  unfold cfConv
  refine Finset.sum_congr rfl (fun a _ => ?_)
  by_cases hc : cfCond p X Y a (n - a)
  · rw [ite_eq_left hc, ite_eq_left hc, hf a hc.1]
  · rw [ite_eq_right hc, ite_eq_right hc]

theorem cfConv_add_left (X Y : ℕ) (f₁ f₂ g : ℕ → ℕ) (n : ℕ) :
    cfConv p X Y (fun a => f₁ a + f₂ a) g n = cfConv p X Y f₁ g n + cfConv p X Y f₂ g n := by
  unfold cfConv
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl (fun a _ => ?_)
  by_cases hc : cfCond p X Y a (n - a)
  · rw [ite_eq_left hc, ite_eq_left hc, ite_eq_left hc]
    exact Nat.add_mul _ _ _
  · rw [ite_eq_right hc, ite_eq_right hc, ite_eq_right hc]

theorem cfConv_delta_zero (X Y : ℕ) (g : ℕ → ℕ) (n : ℕ) :
    cfConv p X Y (fun a => if a = 0 then 1 else 0) g n = if cfCond p X Y 0 n then g n else 0 := by
  unfold cfConv
  rw [Finset.sum_eq_single 0]
  · simp
  · intro a _ ha
    simp [ha]
  · intro h0
    exact absurd (Finset.mem_range.mpr (Nat.succ_pos n)) h0

theorem cfConv_delta (X Y : ℕ) (g : ℕ → ℕ) (n : ℕ) :
    cfConv p X Y (fun a => if a = X then 1 else 0) g n =
      if X ≤ n ∧ cfCond p X Y X (n - X) then g (n - X) else 0 := by
  unfold cfConv
  by_cases hX : X ≤ n
  · rw [Finset.sum_eq_single X]
    · simp [hX]
    · intro a _ ha
      simp [ha]
    · intro h0
      exact absurd (Finset.mem_range.mpr (Nat.lt_succ_of_le hX)) h0
  · rw [ite_eq_right (fun h => hX h.1)]
    refine Finset.sum_eq_zero (fun a ha => ?_)
    have ha' : a < n + 1 := Finset.mem_range.mp ha
    have hne : a ≠ X := by omega
    simp [hne]

end conv

section digits

/-- Digit `H` of `n` is not 0 exactly when `p^H` can be subtracted from `n` without borrowing. -/
theorem one_le_dig_iff (hp : 2 ≤ p) :
    ∀ (H n : ℕ), 1 ≤ dig p H n ↔ p ^ H ≤ n ∧ ds p (n - p ^ H) + 1 = ds p n := by
  have hp0 : 0 < p := by omega
  have hback : ∀ (H n : ℕ), p ^ H ≤ n ∧ ds p (n - p ^ H) + 1 = ds p n → 1 ≤ dig p H n := by
    rintro H n ⟨hle, hds⟩
    have e : p ^ H + (n - p ^ H) = n := by omega
    have hcf : ds p (p ^ H + (n - p ^ H)) = ds p (p ^ H) + ds p (n - p ^ H) := by
      rw [e, ds_pow hp]
      omega
    have h1 := dig_add hp H _ _ hcf
    rw [e, dig_pow hp, ite_eq_left rfl] at h1
    omega
  intro H
  induction H with
  | zero =>
    intro n
    refine ⟨fun hd => ?_, hback 0 n⟩
    rw [dig_zero] at hd
    have hlt := Nat.mod_lt n hp0
    have hdm := Nat.div_add_mod n p
    have hmle := Nat.mod_le n p
    have e : n - 1 = p * (n / p) + (n % p - 1) := by omega
    have h1 : (n - 1) % p = n % p - 1 := by
      rw [e, Nat.mul_add_mod]
      exact Nat.mod_eq_of_lt (by omega)
    have h2 : (n - 1) / p = n / p := by
      rw [e, Nat.mul_add_div hp0, Nat.div_eq_of_lt (show n % p - 1 < p by omega), Nat.add_zero]
    rw [pow_zero, ds_rec hp (n - 1), ds_rec hp n, h1, h2]
    omega
  | succ H ih =>
    intro n
    refine ⟨fun hd => ?_, hback (H + 1) n⟩
    rw [dig_succ] at hd
    obtain ⟨hle, hds⟩ := (ih (n / p)).mp hd
    have hq := Nat.div_add_mod n p
    have hlt := Nat.mod_lt n hp0
    have hms : p * (n / p - p ^ H) = p * (n / p) - p * p ^ H := Nat.mul_sub p (n / p) (p ^ H)
    have hmul2 : p * p ^ H ≤ p * (n / p) := Nat.mul_le_mul_left p hle
    have e : n - p * p ^ H = p * (n / p - p ^ H) + n % p := by omega
    have e1 : (n - p * p ^ H) % p = n % p := by
      rw [e, Nat.mul_add_mod]
      exact Nat.mod_eq_of_lt hlt
    have e2 : (n - p * p ^ H) / p = n / p - p ^ H := by
      rw [e, Nat.mul_add_div hp0, Nat.div_eq_of_lt hlt, Nat.add_zero]
    rw [pow_succ']
    refine ⟨by omega, ?_⟩
    rw [ds_rec hp (n - p * p ^ H), ds_rec hp n, e1, e2]
    omega

theorem cfConv_delta_pow (hp : 2 ≤ p) (H Y : ℕ) (g : ℕ → ℕ) (n : ℕ) (hn : n ≤ p ^ H + Y) :
    cfConv p (p ^ H) Y (fun a => if a = p ^ H then 1 else 0) g n =
      if 1 ≤ dig p H n then g (n - p ^ H) else 0 := by
  rw [cfConv_delta]
  by_cases hd : 1 ≤ dig p H n
  · obtain ⟨hle, hds⟩ := (one_le_dig_iff hp H n).mp hd
    have e : p ^ H + (n - p ^ H) = n := by omega
    have e2 : Y - (n - p ^ H) = p ^ H + Y - n := by omega
    have hc : p ^ H ≤ n ∧ cfCond p (p ^ H) Y (p ^ H) (n - p ^ H) := by
      refine ⟨hle, le_rfl, by omega, ?_, ?_⟩
      · rw [e, ds_pow hp]
        omega
      · rw [e, Nat.sub_self, ds_zero, e2, Nat.zero_add]
    rw [ite_eq_left hc, ite_eq_left hd]
  · have hc : ¬ (p ^ H ≤ n ∧ cfCond p (p ^ H) Y (p ^ H) (n - p ^ H)) := by
      rintro ⟨hle, -, -, h3, -⟩
      have e : p ^ H + (n - p ^ H) = n := by omega
      rw [e, ds_pow hp] at h3
      exact hd ((one_le_dig_iff hp H n).mpr ⟨hle, by omega⟩)
    rw [ite_eq_right hc, ite_eq_right hd]

theorem cfConv_delta_zero_pow (hp : 2 ≤ p) (H Y : ℕ) (g : ℕ → ℕ) (n : ℕ) (hn : n ≤ p ^ H + Y) :
    cfConv p (p ^ H) Y (fun a => if a = 0 then 1 else 0) g n =
      if 1 ≤ dig p H (p ^ H + Y - n) then g n else 0 := by
  rw [cfConv_delta_zero]
  by_cases hd : 1 ≤ dig p H (p ^ H + Y - n)
  · obtain ⟨hle, hds⟩ := (one_le_dig_iff hp H _).mp hd
    have e : p ^ H + Y - n - p ^ H = Y - n := by omega
    rw [e] at hds
    have hc : cfCond p (p ^ H) Y 0 n := by
      refine ⟨Nat.zero_le _, by omega, ?_, ?_⟩
      · rw [ds_zero, Nat.zero_add, Nat.zero_add]
      · rw [Nat.sub_zero, Nat.zero_add, ds_pow hp]
        omega
    rw [ite_eq_left hc, ite_eq_left hd]
  · have hc : ¬ cfCond p (p ^ H) Y 0 n := by
      rintro ⟨-, h2, -, h4⟩
      rw [Nat.sub_zero, Nat.zero_add, ds_pow hp] at h4
      have e : p ^ H + Y - n - p ^ H = Y - n := by omega
      exact hd ((one_le_dig_iff hp H _).mpr ⟨by omega, by rw [e]; omega⟩)
    rw [ite_eq_right hc, ite_eq_right hd]

end digits

section tuples

variable [NeZero p]

/-- `minWords` for heights given by a function on `Fin k`. -/
noncomputable def mwF (p : ℕ) [NeZero p] (k : ℕ) (hts : Fin k → ℕ) (n : ℕ) : ℕ :=
  ∑ a ∈ (Finset.Nat.antidiagonalTuple k n).filter (fun a =>
      (∀ i, a i ≤ p ^ hts i) ∧ ∑ i, ds p (a i) = ds p n ∧
      ∑ i, ds p (p ^ hts i - a i) = ds p (∑ i, p ^ hts i - n)),
    ∏ i, minCount p (hts i) (a i)

omit [NeZero p] in
theorem sum_pow_get (L : List ℕ) : ∑ i : Fin L.length, p ^ L.get i = len p L :=
  sum_fin_get L (fun h => p ^ h)

theorem minWords_eq_mwF (L : List ℕ) (n : ℕ) : minWords p L n = mwF p L.length L.get n := by
  unfold minWords mwF
  rw [← sum_pow_get L]

theorem mwF_congr {k k' : ℕ} (e : k = k') (hts : Fin k → ℕ) (hts' : Fin k' → ℕ)
    (hh : ∀ i, hts i = hts' (Fin.cast e i)) (n : ℕ) : mwF p k hts n = mwF p k' hts' n := by
  subst e
  have h1 : hts = hts' := funext (fun i => by simpa using hh i)
  rw [h1]

theorem mwF_eq_zero_of_lt (k : ℕ) (hts : Fin k → ℕ) (n : ℕ) (hn : ∑ i, p ^ hts i < n) :
    mwF p k hts n = 0 := by
  unfold mwF
  rw [Finset.filter_eq_empty_iff.mpr, Finset.sum_empty]
  intro a ha hP
  have h1 : ∑ i, a i = n := Finset.Nat.mem_antidiagonalTuple.mp ha
  have h2 : ∑ i, a i ≤ ∑ i, p ^ hts i := Finset.sum_le_sum (fun i _ => hP.1 i)
  omega

theorem mwF_zero (hts : Fin 0 → ℕ) (n : ℕ) : mwF p 0 hts n = if n = 0 then 1 else 0 := by
  unfold mwF
  rcases n with _ | n
  · simp
  · simp

/-- A sum over tuples of length `k + 1`, by the first entry. -/
theorem sum_tuple_succ {k : ℕ} (n : ℕ) (S : Finset (Fin (k + 1) → ℕ))
    (S' : ℕ → Finset (Fin k → ℕ))
    (hS : ∀ (a0 : ℕ) (a' : Fin k → ℕ),
      (Fin.cons a0 a' : Fin (k + 1) → ℕ) ∈ S ↔ a0 ≤ n ∧ a' ∈ S' a0)
    (F : (Fin (k + 1) → ℕ) → ℕ) :
    ∑ a ∈ S, F a = ∑ a0 ∈ Finset.range (n + 1), ∑ a' ∈ S' a0, F (Fin.cons a0 a') := by
  have hmap : ∀ a ∈ S, a 0 ∈ Finset.range (n + 1) := by
    intro a ha
    have h1 : (Fin.cons (a 0) (Fin.tail a) : Fin (k + 1) → ℕ) ∈ S := by
      rw [Fin.cons_self_tail]
      exact ha
    exact Finset.mem_range.mpr (Nat.lt_succ_of_le ((hS _ _).mp h1).1)
  rw [← Finset.sum_fiberwise_of_maps_to hmap F]
  refine Finset.sum_congr rfl (fun a0 ha0 => ?_)
  refine Finset.sum_nbij' (fun a => Fin.tail a) (fun a' => Fin.cons a0 a') ?_ ?_ ?_ ?_ ?_
  · intro a ha
    obtain ⟨haS, ha0'⟩ := Finset.mem_filter.mp ha
    have h1 : (Fin.cons a0 (Fin.tail a) : Fin (k + 1) → ℕ) ∈ S := by
      rw [← ha0', Fin.cons_self_tail]
      exact haS
    exact ((hS _ _).mp h1).2
  · intro a' ha'
    exact Finset.mem_filter.mpr
      ⟨(hS _ _).mpr ⟨Nat.lt_succ_iff.mp (Finset.mem_range.mp ha0), ha'⟩, Fin.cons_zero _ _⟩
  · intro a ha
    obtain ⟨-, ha0'⟩ := Finset.mem_filter.mp ha
    show (Fin.cons a0 (Fin.tail a) : Fin (k + 1) → ℕ) = a
    rw [← ha0', Fin.cons_self_tail]
  · intro a' _
    exact Fin.tail_cons _ _
  · intro a ha
    obtain ⟨-, ha0'⟩ := Finset.mem_filter.mp ha
    show F a = F (Fin.cons a0 (Fin.tail a))
    rw [← ha0', Fin.cons_self_tail]

omit [NeZero p] in
/-- A tuple `Fin.cons a0 a'` belongs to the index set of `mwF p (k + 1) (Fin.cons h hts) n`
exactly when `a0` and `n - a0` may be put side by side and `a'` belongs to the index set of
`mwF p k hts (n - a0)`. -/
theorem mem_cons_filter (hp : 2 ≤ p) (k h : ℕ) (hts : Fin k → ℕ) (n a0 : ℕ) (a' : Fin k → ℕ) :
    (Fin.cons a0 a' : Fin (k + 1) → ℕ) ∈
        (Finset.Nat.antidiagonalTuple (k + 1) n).filter (fun a =>
          (∀ i, a i ≤ p ^ (Fin.cons h hts : Fin (k + 1) → ℕ) i) ∧
          ∑ i, ds p (a i) = ds p n ∧
          ∑ i, ds p (p ^ (Fin.cons h hts : Fin (k + 1) → ℕ) i - a i) =
            ds p (∑ i, p ^ (Fin.cons h hts : Fin (k + 1) → ℕ) i - n)) ↔
      a0 ≤ n ∧ cfCond p (p ^ h) (∑ i, p ^ hts i) a0 (n - a0) ∧
        a' ∈ (Finset.Nat.antidiagonalTuple k (n - a0)).filter (fun a =>
          (∀ i, a i ≤ p ^ hts i) ∧ ∑ i, ds p (a i) = ds p (n - a0) ∧
          ∑ i, ds p (p ^ hts i - a i) = ds p (∑ i, p ^ hts i - (n - a0))) := by
  simp only [Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple, Fin.sum_univ_succ,
    Fin.cons_zero, Fin.cons_succ, Fin.forall_fin_succ, cfCond]
  have f2 : ds p (∑ i, a' i) ≤ ∑ i, ds p (a' i) := ds_sum_le hp _ _
  have f1 := ds_add_le hp a0 (∑ i, a' i)
  constructor
  · rintro ⟨hsum, ⟨h0, hle⟩, hE, hS⟩
    have hY : ∑ i, a' i ≤ ∑ i, p ^ hts i := Finset.sum_le_sum (fun i _ => hle i)
    have hsub : ∑ i, (p ^ hts i - a' i) = ∑ i, p ^ hts i - ∑ i, a' i :=
      Finset.sum_tsub_distrib _ (fun i _ => hle i)
    have f4 : ds p (∑ i, (p ^ hts i - a' i)) ≤ ∑ i, ds p (p ^ hts i - a' i) :=
      ds_sum_le hp _ _
    rw [hsub] at f4
    have f3 := ds_add_le hp (p ^ h - a0) (∑ i, p ^ hts i - ∑ i, a' i)
    have e : n - a0 = ∑ i, a' i := by omega
    have e2 : p ^ h - a0 + (∑ i, p ^ hts i - ∑ i, a' i) = p ^ h + ∑ i, p ^ hts i - n := by
      omega
    rw [e2] at f3
    rw [hsum] at f1
    rw [e, hsum]
    exact ⟨by omega, ⟨h0, hY, by omega, by omega⟩, rfl, hle, by omega, by omega⟩
  · rintro ⟨hn, ⟨h0, hY, hE, hS⟩, hsum, hle, hE', hS'⟩
    have e : a0 + (n - a0) = n := by omega
    rw [e] at hE hS
    exact ⟨by omega, ⟨h0, hle⟩, by omega, by omega⟩

/-- **Step 1 for heights given by a function.** -/
theorem mwF_cons (hp : 2 ≤ p) (k h : ℕ) (hts : Fin k → ℕ) (n : ℕ) :
    mwF p (k + 1) (Fin.cons h hts) n =
      cfConv p (p ^ h) (∑ i, p ^ hts i) (minCount p h) (mwF p k hts) n := by
  rw [mwF]
  rw [sum_tuple_succ n _ (fun a0 => if cfCond p (p ^ h) (∑ i, p ^ hts i) a0 (n - a0) then
      (Finset.Nat.antidiagonalTuple k (n - a0)).filter (fun a =>
        (∀ i, a i ≤ p ^ hts i) ∧ ∑ i, ds p (a i) = ds p (n - a0) ∧
        ∑ i, ds p (p ^ hts i - a i) = ds p (∑ i, p ^ hts i - (n - a0))) else ∅)]
  · unfold cfConv
    refine Finset.sum_congr rfl (fun a0 _ => ?_)
    by_cases hc : cfCond p (p ^ h) (∑ i, p ^ hts i) a0 (n - a0)
    · rw [ite_eq_left hc, ite_eq_left hc, mwF, Finset.mul_sum]
      refine Finset.sum_congr rfl (fun a' _ => ?_)
      rw [Fin.prod_univ_succ]
      simp only [Fin.cons_zero, Fin.cons_succ]
    · rw [ite_eq_right hc, ite_eq_right hc, Finset.sum_empty]
  · intro a0 a'
    rw [mem_cons_filter hp k h hts n a0 a']
    by_cases hc : cfCond p (p ^ h) (∑ i, p ^ hts i) a0 (n - a0)
    · rw [ite_eq_left hc]
      exact ⟨fun h1 => ⟨h1.1, h1.2.2⟩, fun h1 => ⟨h1.1, hc, h1.2⟩⟩
    · rw [ite_eq_right hc]
      exact ⟨fun h1 => absurd h1.2.1 hc, fun h1 => by simp at h1⟩

end tuples

section lists

variable [NeZero p]

omit [NeZero p] in
theorem len_cons (h : ℕ) (L : List ℕ) : len p (h :: L) = p ^ h + len p L := by
  simp [len]

omit [NeZero p] in
theorem len_nil : len p ([] : List ℕ) = 0 := by
  simp [len]

omit [NeZero p] in
theorem len_replicate (t h : ℕ) : len p (List.replicate t h) = t * p ^ h := by
  simp [len]

theorem get_cons_eq (h : ℕ) (L : List ℕ) :
    ((h :: L).get : Fin (L.length + 1) → ℕ) = Fin.cons h L.get := by
  funext i
  refine Fin.cases ?_ (fun j => ?_) i
  · rfl
  · rfl

/-- **Step 1.** The empty list. -/
theorem minWords_nil (n : ℕ) : minWords p [] n = if n = 0 then 1 else 0 := by
  rw [minWords_eq_mwF]
  exact mwF_zero _ n

/-- **Step 1.** Removing the first top block: `minWords p (h :: L)` is the carry-free
convolution of `minCount p h` and `minWords p L`. -/
theorem minWords_cons (hp : 2 ≤ p) (h : ℕ) (L : List ℕ) (n : ℕ) :
    minWords p (h :: L) n = cfConv p (p ^ h) (len p L) (minCount p h) (minWords p L) n := by
  have e1 : minWords p (h :: L) n = mwF p (L.length + 1) (Fin.cons h L.get) n :=
    (minWords_eq_mwF (h :: L) n).trans
      (congrArg (fun f => mwF p (L.length + 1) f n) (get_cons_eq h L))
  have e2 : mwF p L.length L.get = minWords p L :=
    funext (fun n' => (minWords_eq_mwF L n').symm)
  rw [e1, mwF_cons hp, e2, sum_pow_get]

theorem minWords_eq_zero_of_lt (L : List ℕ) (n : ℕ) (hn : len p L < n) : minWords p L n = 0 := by
  rw [minWords_eq_mwF]
  exact mwF_eq_zero_of_lt _ _ _ (by rw [sum_pow_get]; exact hn)

/-- **Step 2.** Appending lists. -/
theorem minWords_append (hp : 2 ≤ p) (L₁ L₂ : List ℕ) :
    ∀ n, minWords p (L₁ ++ L₂) n =
      cfConv p (len p L₁) (len p L₂) (minWords p L₁) (minWords p L₂) n := by
  induction L₁ with
  | nil =>
    intro n
    have e2 : cfConv p 0 (len p L₂) (minWords p []) (minWords p L₂) n =
        cfConv p 0 (len p L₂) (fun a => if a = 0 then 1 else 0) (minWords p L₂) n :=
      cfConv_congr_left 0 _ _ _ _ n (fun a _ => minWords_nil a)
    rw [List.nil_append, len_nil, e2, cfConv_delta_zero]
    by_cases hn : n ≤ len p L₂
    · have hc : cfCond p 0 (len p L₂) 0 n := by
        refine ⟨le_rfl, hn, ?_, ?_⟩
        · rw [ds_zero, Nat.zero_add, Nat.zero_add]
        · rw [Nat.sub_zero, ds_zero, Nat.zero_add, Nat.zero_add, Nat.zero_add]
      rw [ite_eq_left hc]
    · rw [ite_eq_right (fun hc => hn hc.2.1)]
      exact minWords_eq_zero_of_lt L₂ n (by omega)
  | cons h L₁ ih =>
    intro n
    have e1 : minWords p (L₁ ++ L₂) =
        cfConv p (len p L₁) (len p L₂) (minWords p L₁) (minWords p L₂) := funext ih
    have e2 : cfConv p (p ^ h) (len p L₁) (minCount p h) (minWords p L₁) =
        minWords p (h :: L₁) := funext (fun n' => (minWords_cons hp h L₁ n').symm)
    rw [List.cons_append, minWords_cons hp, e1, len_append, cfConv_assoc hp, e2, len_cons]

theorem mwF_const_mixed (hp : 2 ≤ p) (h a : ℕ) (ha : 0 < a ∧ a < p ^ (h + 1)) :
    mwF p p (fun _ => h) a = minCount p (h + 1) a := by
  have e : ∑ _i : Fin p, p ^ h = p ^ (h + 1) := by simp [pow_succ']
  rw [minCount_succ hp h a ha]
  simp only [mwF, e]

theorem mwF_const_zero (hp : 2 ≤ p) (h : ℕ) : mwF p p (fun _ => h) 0 = 0 := by
  have e : ∑ _i : Fin p, p ^ h = p ^ (h + 1) := by simp [pow_succ']
  unfold mwF
  rw [Finset.filter_eq_empty_iff.mpr, Finset.sum_empty]
  intro c hc hP
  have hc0 : ∀ j, c j = 0 := fun j =>
    (Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => Nat.zero_le _)).mp
      (Finset.Nat.mem_antidiagonalTuple.mp hc) j (Finset.mem_univ j)
  have hB : ∑ j, ds p (p ^ h - c j) = ds p (∑ _i : Fin p, p ^ h - 0) := hP.2.2
  rw [e, Nat.sub_zero, ds_pow hp] at hB
  have h1 : ∑ j, ds p (p ^ h - c j) = ∑ _j : Fin p, 1 :=
    Finset.sum_congr rfl (fun j _ => by rw [hc0 j, Nat.sub_zero, ds_pow hp h])
  rw [h1] at hB
  simp at hB
  omega

theorem mwF_const_pow (hp : 2 ≤ p) (h : ℕ) : mwF p p (fun _ => h) (p ^ (h + 1)) = 0 := by
  unfold mwF
  rw [Finset.filter_eq_empty_iff.mpr, Finset.sum_empty]
  intro c hc hP
  have hle : ∀ j, c j ≤ p ^ h := hP.1
  have hsum : ∑ j, c j = ∑ _j : Fin p, p ^ h := by
    rw [Finset.Nat.mem_antidiagonalTuple.mp hc]
    simp [pow_succ']
  have hcp : ∀ j, c j = p ^ h := fun j =>
    (Finset.sum_eq_sum_iff_of_le (fun i _ => hle i)).mp hsum j (Finset.mem_univ j)
  have hA : ∑ j, ds p (c j) = ds p (p ^ (h + 1)) := hP.2.1
  have h1 : ∑ j, ds p (c j) = ∑ _j : Fin p, 1 :=
    Finset.sum_congr rfl (fun j _ => by rw [hcp j, ds_pow hp h])
  rw [h1, ds_pow hp] at hA
  simp at hA
  omega

theorem minWords_replicate_eq (h a : ℕ) :
    minWords p (List.replicate p h) a = mwF p p (fun _ => h) a := by
  rw [minWords_eq_mwF]
  exact mwF_congr (by simp) _ _ (fun i => by simp) a

/-- **Step 3.** `p` blocks of height `h` side by side are a mixed block of height `h + 1`. -/
theorem minWords_replicate (hp : 2 ≤ p) (h a : ℕ) (ha : a ≤ p ^ (h + 1)) :
    minWords p (List.replicate p h) a =
      if 0 < a ∧ a < p ^ (h + 1) then minCount p (h + 1) a else 0 := by
  rw [minWords_replicate_eq]
  by_cases hmix : 0 < a ∧ a < p ^ (h + 1)
  · rw [ite_eq_left hmix]
    exact mwF_const_mixed hp h a hmix
  · rw [ite_eq_right hmix]
    rcases Nat.eq_zero_or_pos a with h0 | h0
    · rw [h0]
      exact mwF_const_zero hp h
    · have h1 : a = p ^ (h + 1) := by omega
      rw [h1]
      exact mwF_const_pow hp h

/-- A block of height `h + 1` is all S, all E, or mixed. -/
theorem minCount_succ_split (hp : 2 ≤ p) (h a : ℕ) (ha : a ≤ p ^ (h + 1)) :
    minCount p (h + 1) a =
      (if a = 0 then 1 else 0) + (if a = p ^ (h + 1) then 1 else 0) +
        minWords p (List.replicate p h) a := by
  have hq : 0 < p ^ (h + 1) := pow_pos (by omega) _
  rw [minWords_replicate hp h a ha]
  by_cases h0 : a = 0
  · have i1 : (if a = 0 then 1 else 0) = 1 := ite_eq_left h0
    have i2 : (if a = p ^ (h + 1) then 1 else 0) = 0 := ite_eq_right (by omega)
    have i3 : (if 0 < a ∧ a < p ^ (h + 1) then minCount p (h + 1) a else 0) = 0 :=
      ite_eq_right (by omega)
    rw [i1, i2, i3, minCount_mono hp (h + 1) a (Or.inl h0)]
  · by_cases h1 : a = p ^ (h + 1)
    · have i1 : (if a = 0 then 1 else 0) = 0 := ite_eq_right h0
      have i2 : (if a = p ^ (h + 1) then 1 else 0) = 1 := ite_eq_left h1
      have i3 : (if 0 < a ∧ a < p ^ (h + 1) then minCount p (h + 1) a else 0) = 0 :=
        ite_eq_right (by omega)
      rw [i1, i2, i3, minCount_mono hp (h + 1) a (Or.inr h1)]
    · have i1 : (if a = 0 then 1 else 0) = 0 := ite_eq_right h0
      have i2 : (if a = p ^ (h + 1) then 1 else 0) = 0 := ite_eq_right h1
      have i3 : (if 0 < a ∧ a < p ^ (h + 1) then minCount p (h + 1) a else 0) =
          minCount p (h + 1) a := ite_eq_left (by omega)
      rw [i1, i2, i3, Nat.zero_add]

/-- **Step 4.** The first block, of height `h + 1`, is all E, all S, or mixed; a mixed block is
replaced by `p` blocks of height `h`. -/
theorem minWords_cons_succ (hp : 2 ≤ p) (h : ℕ) (L : List ℕ) (n : ℕ)
    (hn : n ≤ p ^ (h + 1) + len p L) :
    minWords p ((h + 1) :: L) n =
      (if 1 ≤ dig p (h + 1) n then minWords p L (n - p ^ (h + 1)) else 0) +
      (if 1 ≤ dig p (h + 1) (p ^ (h + 1) + len p L - n) then minWords p L n else 0) +
      minWords p (List.replicate p h ++ L) n := by
  have e1 : cfConv p (p ^ (h + 1)) (len p L) (minCount p (h + 1)) (minWords p L) n =
      cfConv p (p ^ (h + 1)) (len p L)
        (fun a => ((if a = 0 then 1 else 0) + (if a = p ^ (h + 1) then 1 else 0)) +
          minWords p (List.replicate p h) a) (minWords p L) n :=
    cfConv_congr_left _ _ _ _ _ n (fun a ha => minCount_succ_split hp h a ha)
  have e2 : len p (List.replicate p h) = p ^ (h + 1) := by
    rw [len_replicate, pow_succ']
  rw [minWords_cons hp, e1, cfConv_add_left, cfConv_add_left, cfConv_delta_zero_pow hp _ _ _ _ hn,
    cfConv_delta_pow hp _ _ _ _ hn, minWords_append hp, e2]
  omega

/-- **Step 4.** The first block, of height 0, is one letter: E or S. -/
theorem minWords_cons_zero (hp : 2 ≤ p) (L : List ℕ) (n : ℕ) (hn : n ≤ 1 + len p L) :
    minWords p (0 :: L) n =
      (if 1 ≤ dig p 0 n then minWords p L (n - 1) else 0) +
      (if 1 ≤ dig p 0 (1 + len p L - n) then minWords p L n else 0) := by
  have e1 : cfConv p (p ^ 0) (len p L) (minCount p 0) (minWords p L) n =
      cfConv p (p ^ 0) (len p L)
        (fun a => (if a = 0 then 1 else 0) + (if a = p ^ 0 then 1 else 0)) (minWords p L) n := by
    refine cfConv_congr_left _ _ _ _ _ n (fun a ha => ?_)
    rw [pow_zero] at ha ⊢
    rcases Nat.eq_zero_or_pos a with h0 | h0
    · have i1 : (if a = 0 then 1 else 0) = 1 := ite_eq_left h0
      have i2 : (if a = 1 then 1 else 0) = 0 := ite_eq_right (by omega)
      rw [i1, i2, minCount_mono hp 0 a (Or.inl h0)]
    · have h1 : a = 1 := by omega
      have i1 : (if a = 0 then 1 else 0) = 0 := ite_eq_right (by omega)
      have i2 : (if a = 1 then 1 else 0) = 1 := ite_eq_left h1
      rw [i1, i2, minCount_mono hp 0 a (Or.inr (by rw [h1, pow_zero]))]
  have hn' : n ≤ p ^ 0 + len p L := by rw [pow_zero]; exact hn
  rw [minWords_cons hp, e1, cfConv_add_left, cfConv_delta_zero_pow hp _ _ _ _ hn',
    cfConv_delta_pow hp _ _ _ _ hn', pow_zero]
  omega

end lists

end MMM.Path

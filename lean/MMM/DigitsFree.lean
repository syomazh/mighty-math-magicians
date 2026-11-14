/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

More on digits, for the case of repeated atoms (digits up to `p - 1`):

* if in every position the digits of the summands add up to less than `p`, the sum is carry-free;
* a number is determined by its digits;
* the digit sum is the sum of the digits.
-/
import MMM.DigitsCarry

namespace MMM

/-- If the digits of `a` and `b` add up to less than `p` in every position, there is no carry. -/
theorem ds_add_of_dig_lt {p : ℕ} (hp : 2 ≤ p) : ∀ (n a b : ℕ), a + b = n →
    (∀ j, dig p j a + dig p j b < p) → ds p (a + b) = ds p a + ds p b := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro a b h hd
    rcases Nat.eq_zero_or_pos n with hn | hn
    · have ha : a = 0 := by omega
      have hb : b = 0 := by omega
      subst ha hb
      simp
    · have hp0 : 0 < p := by omega
      have h0 : a % p + b % p < p := by simpa using hd 0
      have hdiv := Nat.add_div (a := a) (b := b) hp0
      have hmod := Nat.add_mod_eq_ite (m := a) (n := b) (k := p)
      have hc : ¬ p ≤ a % p + b % p := by omega
      simp only [hc, ↓reduceIte] at hdiv hmod
      have hlt : a / p + b / p < n := by
        have : (a + b) / p < n := by rw [h]; exact Nat.div_lt_self hn (by omega)
        omega
      have h2 := ih (a / p + b / p) hlt (a / p) (b / p) rfl
        (fun j => by rw [← dig_succ, ← dig_succ]; exact hd (j + 1))
      rw [ds_rec hp (a + b), ds_rec hp a, ds_rec hp b, hdiv, hmod, add_zero, h2]
      omega

/-- The same for a finite sum. -/
theorem ds_sum_of_dig_lt {p : ℕ} (hp : 2 ≤ p) {ι : Type*} (s : Finset ι) (f : ι → ℕ)
    (h : ∀ j, ∑ i ∈ s, dig p j (f i) < p) : ds p (∑ i ∈ s, f i) = ∑ i ∈ s, ds p (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
    have hs : ∀ j, ∑ i ∈ s, dig p j (f i) < p := fun j => by
      have := h j
      rw [Finset.sum_insert ha] at this
      omega
    have e := ih hs
    rw [Finset.sum_insert ha, Finset.sum_insert ha, ← e]
    refine ds_add_of_dig_lt hp _ _ _ rfl (fun j => ?_)
    have := h j
    rw [Finset.sum_insert ha] at this
    rw [dig_sum hp s f e j]
    exact this

/-- Numbers below `p ^ B` with the same digits are equal. -/
theorem eq_of_dig_eq_of_lt {p : ℕ} (hp : 2 ≤ p) : ∀ (B n m : ℕ), n < p ^ B → m < p ^ B →
    (∀ j, dig p j n = dig p j m) → n = m := by
  intro B
  induction B with
  | zero =>
    intro n m hn hm _
    simp at hn hm
    omega
  | succ B ih =>
    intro n m hn hm h
    have hp0 : 0 < p := by omega
    have h0 : n % p = m % p := by simpa using h 0
    have h1 : n / p = m / p := by
      refine ih _ _ ?_ ?_ (fun j => by rw [← dig_succ, ← dig_succ]; exact h (j + 1))
      · rw [Nat.div_lt_iff_lt_mul hp0, ← pow_succ]; exact hn
      · rw [Nat.div_lt_iff_lt_mul hp0, ← pow_succ]; exact hm
    have e1 := Nat.div_add_mod n p
    have e2 := Nat.div_add_mod m p
    rw [h0, h1] at e1
    omega

/-- **A number is determined by its base-`p` digits.** -/
theorem eq_of_dig_eq {p : ℕ} (hp : 2 ≤ p) (n m : ℕ) (h : ∀ j, dig p j n = dig p j m) : n = m := by
  have h1 : n < p ^ (n + m) :=
    (Nat.lt_pow_self (by omega : 1 < p)).trans_le (Nat.pow_le_pow_right (by omega) (by omega))
  have h2 : m < p ^ (n + m) :=
    (Nat.lt_pow_self (by omega : 1 < p)).trans_le (Nat.pow_le_pow_right (by omega) (by omega))
  exact eq_of_dig_eq_of_lt hp (n + m) n m h1 h2 h

/-- The digit sum is the sum of the digits. -/
theorem ds_eq_sum_dig {p : ℕ} (hp : 2 ≤ p) : ∀ (B m : ℕ), m < p ^ B →
    ds p m = ∑ j ∈ Finset.range B, dig p j m := by
  intro B
  induction B with
  | zero =>
    intro m hm
    have : m = 0 := by simpa using hm
    subst this
    simp
  | succ B ih =>
    intro m hm
    have hp0 : 0 < p := by omega
    have h1 : m / p < p ^ B := by
      rw [Nat.div_lt_iff_lt_mul hp0, ← pow_succ]; exact hm
    rw [ds_rec hp, ih _ h1, Finset.sum_range_succ', dig_zero, add_comm]
    congr 1
    exact Finset.sum_congr rfl (fun j _ => (dig_succ p j m).symm)

/-- A digit beyond the length of the number is zero. -/
theorem dig_eq_zero_of_lt {p : ℕ} {j m : ℕ} (h : m < p ^ j) : dig p j m = 0 := by
  unfold dig
  rw [Nat.div_eq_of_lt h, Nat.zero_mod]

end MMM

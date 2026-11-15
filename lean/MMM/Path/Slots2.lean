/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W043), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **The count of the minimal words, part 2: the recursion for `slotCount`.**

`slotCount p L n B` (defined in `SlotsDef.lean`) is a product over the levels `j < B` of
`fac p L n j = choose s_j n_j * choose (s_j - n_j) m_j`. This file proves that it satisfies the
same three-term recursion as `minWords` (Step 5 of the brief): removing the first block `H`,

* the block is all E (digit `H` of `n` is not 0): every `muAt` is unchanged, and at level `H`
  both the number of slots and the digit of `n` drop by 1 (`slotCount_E`);
* the block is all S: the same for the letters S (`slotCount_S`);
* the block is mixed and is replaced by `p` blocks of height `H - 1`: the number of slots at
  level `H` drops by 1 and the other levels are unchanged, except when there are too few
  slots, and then both sides are 0 (`slotCount_M`);

and the three terms add up by the Pascal rule for trinomial coefficients
(`trinomial_pascal`): `slotCount_cons_succ`, `slotCount_cons_zero`.

Binomial coefficients are used only through the Pascal rule `Nat.choose_succ_succ` and
`Nat.choose_eq_zero_of_lt`. No factorial and no valuation is used; `p` needs not be prime.
-/
import MMM.Path.Slots1

namespace MMM.Path

open MMM

variable {p : ℕ}

/-- The factor of `slotCount` at level `j`. -/
def fac (p : ℕ) (L : List ℕ) (n j : ℕ) : ℕ :=
  (slotsAt p L n j).choose (dig p j n) *
    (slotsAt p L n j - dig p j n).choose (dig p j (len p L - n))

theorem slotCount_eq_prod (L : List ℕ) (n B : ℕ) :
    slotCount p L n B = ∏ j ∈ Finset.range B, fac p L n j := rfl

theorem slotCount_split (L : List ℕ) (n B H : ℕ) (hH : H < B) :
    slotCount p L n B = fac p L n H * ∏ j ∈ (Finset.range B).erase H, fac p L n j := by
  rw [slotCount_eq_prod, Finset.mul_prod_erase _ _ (Finset.mem_range.mpr hH)]

section lists

theorem count_cons' (H j : ℕ) (L : List ℕ) :
    (H :: L).count j = (if H = j then 1 else 0) + L.count j := by
  rw [List.count_cons]
  by_cases h : H = j
  · simp [h, Nat.add_comm]
  · simp [h]

theorem count_replicate' (t h j : ℕ) :
    (List.replicate t h).count j = if h = j then t else 0 := by
  rw [List.count_replicate]
  by_cases hh : h = j
  · simp [hh]
  · simp [hh]

theorem topAt_nil (j : ℕ) : topAt p [] j = 0 := by
  simp [topAt]

theorem topAt_cons (H : ℕ) (L : List ℕ) (j : ℕ) :
    topAt p (H :: L) j = (if j ≤ H then p ^ (H - j) else 0) + topAt p L j := by
  unfold topAt
  by_cases h : j ≤ H
  · simp [h]
  · simp [h]

theorem topAt_append (L₁ L₂ : List ℕ) (j : ℕ) :
    topAt p (L₁ ++ L₂) j = topAt p L₁ j + topAt p L₂ j := by
  simp [topAt]

theorem topAt_replicate (t h j : ℕ) :
    topAt p (List.replicate t h) j = t * (if j ≤ h then p ^ (h - j) else 0) := by
  induction t with
  | zero => simp [topAt]
  | succ t ih =>
    rw [List.replicate_succ, topAt_cons, ih]
    ring

theorem topAt_zero (L : List ℕ) : topAt p L 0 = len p L := by
  induction L with
  | nil => simp [topAt, len]
  | cons H L ih => rw [topAt_cons, ih, len_cons, ite_eq_left (Nat.zero_le H), Nat.sub_zero]

/-- The blocks of height at least `j` are those of height `j` and those of height at least
`j + 1`. -/
theorem topAt_succ (L : List ℕ) (j : ℕ) :
    topAt p L j = L.count j + p * topAt p L (j + 1) := by
  induction L with
  | nil => simp [topAt]
  | cons H L ih =>
    rw [topAt_cons, topAt_cons, ih, count_cons']
    rcases Nat.lt_trichotomy j H with hlt | heq | hgt
    · have e : H - j = (H - (j + 1)) + 1 := by omega
      rw [ite_eq_left (show j ≤ H by omega), ite_eq_left (show j + 1 ≤ H by omega),
        ite_eq_right (show ¬ H = j by omega), e, pow_succ']
      ring
    · rw [heq, ite_eq_left (le_refl H), ite_eq_right (show ¬ H + 1 ≤ H by omega),
        ite_eq_left rfl, Nat.sub_self, pow_zero]
      ring
    · rw [ite_eq_right (show ¬ j ≤ H by omega), ite_eq_right (show ¬ j + 1 ≤ H by omega),
        ite_eq_right (show ¬ H = j by omega)]
      ring

theorem topAt_eq_zero (hp : 2 ≤ p) (L : List ℕ) (B j : ℕ) (hB : len p L < p ^ B) (hj : B ≤ j) :
    topAt p L j = 0 := by
  induction L with
  | nil => exact topAt_nil j
  | cons H L ih =>
    rw [len_cons] at hB
    have hH : H < B := by
      by_contra hcon
      have h1 : p ^ B ≤ p ^ H := Nat.pow_le_pow_right (by omega) (by omega)
      omega
    rw [topAt_cons, ite_eq_right (show ¬ j ≤ H by omega), ih (by omega), Nat.zero_add]

theorem len_replicate_append (h : ℕ) (L : List ℕ) :
    len p (List.replicate p h ++ L) = len p ((h + 1) :: L) := by
  rw [len_append, len_replicate, len_cons, pow_succ']

/-- Replacing a block of height `h + 1` by `p` blocks of height `h` changes `topAt` only at
level `h + 1`. -/
theorem topAt_mixed (h : ℕ) (L : List ℕ) (j : ℕ) :
    topAt p ((h + 1) :: L) j =
      (if j = h + 1 then 1 else 0) + topAt p (List.replicate p h ++ L) j := by
  rw [topAt_cons, topAt_append, topAt_replicate]
  rcases Nat.lt_trichotomy j (h + 1) with hlt | heq | hgt
  · have e : h + 1 - j = (h - j) + 1 := by omega
    rw [ite_eq_left (show j ≤ h + 1 by omega), ite_eq_right (show ¬ j = h + 1 by omega),
      ite_eq_left (show j ≤ h by omega), e, pow_succ']
    ring
  · rw [heq, ite_eq_left (le_refl (h + 1)), ite_eq_left rfl,
      ite_eq_right (show ¬ h + 1 ≤ h by omega), Nat.sub_self, pow_zero]
    ring
  · rw [ite_eq_right (show ¬ j ≤ h + 1 by omega), ite_eq_right (show ¬ j = h + 1 by omega),
      ite_eq_right (show ¬ j ≤ h by omega)]
    ring

end lists

section digits

/-- A carry-free sum is divided by `p^j` term by term. -/
theorem div_pow_add (hp : 2 ≤ p) : ∀ (j a b : ℕ), ds p (a + b) = ds p a + ds p b →
    (a + b) / p ^ j = a / p ^ j + b / p ^ j := by
  intro j
  induction j with
  | zero =>
    intro a b _
    simp
  | succ j ih =>
    intro a b h
    obtain ⟨-, h2, h3⟩ := ds_add_eq hp h
    rw [pow_succ', ← Nat.div_div_eq_div_mul, ← Nat.div_div_eq_div_mul,
      ← Nat.div_div_eq_div_mul, h2]
    exact ih _ _ h3

theorem pow_div_pow (hp : 2 ≤ p) (H j : ℕ) :
    p ^ H / p ^ j = if j ≤ H then p ^ (H - j) else 0 := by
  by_cases h : j ≤ H
  · rw [ite_eq_left h, Nat.pow_div h (by omega)]
  · have hlt : p ^ H < p ^ j := Nat.pow_lt_pow_right (by omega) (by omega)
    rw [ite_eq_right h, Nat.div_eq_of_lt hlt]

theorem cf_pow_div (hp : 2 ≤ p) (H x j : ℕ)
    (hcf : ds p (p ^ H + x) = ds p (p ^ H) + ds p x) :
    (p ^ H + x) / p ^ j = (if j ≤ H then p ^ (H - j) else 0) + x / p ^ j := by
  rw [div_pow_add hp j _ _ hcf, pow_div_pow hp]

theorem cf_pow_dig (hp : 2 ≤ p) (H x j : ℕ)
    (hcf : ds p (p ^ H + x) = ds p (p ^ H) + ds p x) :
    dig p j (p ^ H + x) = (if H = j then 1 else 0) + dig p j x := by
  rw [dig_add hp j _ _ hcf, dig_pow hp]

/-- If digit `H` of `n` is not 0, then `p^H` and `n - p^H` add up to `n` without carries. -/
theorem cf_of_one_le_dig (hp : 2 ≤ p) (H n : ℕ) (hd : 1 ≤ dig p H n) :
    p ^ H ≤ n ∧ ds p (p ^ H + (n - p ^ H)) = ds p (p ^ H) + ds p (n - p ^ H) := by
  obtain ⟨hle, hds⟩ := (one_le_dig_iff hp H n).mp hd
  have e : p ^ H + (n - p ^ H) = n := by omega
  refine ⟨hle, ?_⟩
  rw [e, ds_pow hp]
  omega

end digits

section relations

/-- Removing a block of height `H` that is all E: the slots and the digits of `n` change only at
level `H`, by 1. -/
theorem rel_cons_E (hp : 2 ≤ p) (H : ℕ) (L : List ℕ) (x j : ℕ)
    (hcf : ds p (p ^ H + x) = ds p (p ^ H) + ds p x) :
    slotsAt p (H :: L) (p ^ H + x) j = (if H = j then 1 else 0) + slotsAt p L x j ∧
      dig p j (p ^ H + x) = (if H = j then 1 else 0) + dig p j x ∧
      len p (H :: L) - (p ^ H + x) = len p L - x := by
  have hlen : len p (H :: L) - (p ^ H + x) = len p L - x := by
    rw [len_cons]
    omega
  have hmu : ∀ i, muAt p (H :: L) (p ^ H + x) i = muAt p L x i := by
    intro i
    unfold muAt
    rw [topAt_cons, cf_pow_div hp H x i hcf, hlen]
    generalize (if i ≤ H then p ^ (H - i) else 0) = c
    omega
  refine ⟨?_, cf_pow_dig hp H x j hcf, hlen⟩
  unfold slotsAt
  rw [count_cons', hmu, Nat.add_assoc]

/-- Removing a block of height `H` that is all S. -/
theorem rel_cons_S (hp : 2 ≤ p) (H : ℕ) (L : List ℕ) (n j : ℕ) (hn : n ≤ len p L)
    (hcf : ds p (p ^ H + (len p L - n)) = ds p (p ^ H) + ds p (len p L - n)) :
    slotsAt p (H :: L) n j = (if H = j then 1 else 0) + slotsAt p L n j ∧
      dig p j (len p (H :: L) - n) = (if H = j then 1 else 0) + dig p j (len p L - n) := by
  have hlen : len p (H :: L) - n = p ^ H + (len p L - n) := by
    rw [len_cons]
    omega
  have hmu : ∀ i, muAt p (H :: L) n i = muAt p L n i := by
    intro i
    unfold muAt
    rw [topAt_cons, hlen, cf_pow_div hp H _ i hcf]
    generalize (if i ≤ H then p ^ (H - i) else 0) = c
    omega
  refine ⟨?_, ?_⟩
  · unfold slotsAt
    rw [count_cons', hmu, Nat.add_assoc]
  · rw [hlen]
    exact cf_pow_dig hp H _ j hcf

theorem muAt_mixed_ne (h : ℕ) (L : List ℕ) (n j : ℕ) (hj : j ≠ h + 1) :
    muAt p ((h + 1) :: L) n j = muAt p (List.replicate p h ++ L) n j := by
  unfold muAt
  rw [topAt_mixed, len_replicate_append, ite_eq_right hj, Nat.zero_add]

theorem slotsAt_mixed_ne (h : ℕ) (L : List ℕ) (n j : ℕ) (hj1 : j ≠ h) (hj2 : j ≠ h + 1) :
    slotsAt p ((h + 1) :: L) n j = slotsAt p (List.replicate p h ++ L) n j := by
  unfold slotsAt
  rw [muAt_mixed_ne h L n (j + 1) (by omega), count_cons', List.count_append, count_replicate',
    ite_eq_right (show ¬ h + 1 = j by omega), ite_eq_right (show ¬ h = j by omega)]

theorem slotsAt_mixed_top (h : ℕ) (L : List ℕ) (n : ℕ) :
    slotsAt p ((h + 1) :: L) n (h + 1) =
      1 + slotsAt p (List.replicate p h ++ L) n (h + 1) := by
  unfold slotsAt
  rw [muAt_mixed_ne h L n (h + 1 + 1) (by omega), count_cons', List.count_append,
    count_replicate', ite_eq_left rfl, ite_eq_right (show ¬ h = h + 1 by omega), Nat.zero_add,
    Nat.add_assoc]

theorem slotsAt_mixed_low (h : ℕ) (L : List ℕ) (n : ℕ)
    (hgood : n / p ^ (h + 1) + (len p ((h + 1) :: L) - n) / p ^ (h + 1) + 1 ≤
      topAt p ((h + 1) :: L) (h + 1)) :
    slotsAt p ((h + 1) :: L) n h = slotsAt p (List.replicate p h ++ L) n h := by
  have hmu : muAt p ((h + 1) :: L) n (h + 1) =
      1 + muAt p (List.replicate p h ++ L) n (h + 1) := by
    have ht := topAt_mixed (p := p) h L (h + 1)
    rw [ite_eq_left rfl] at ht
    unfold muAt
    rw [len_replicate_append]
    omega
  unfold slotsAt
  rw [hmu, count_cons', List.count_append, count_replicate',
    ite_eq_right (show ¬ h + 1 = h by omega), ite_eq_left rfl, Nat.mul_add, Nat.mul_one]
  omega

theorem one_le_slotsAt_cons (H : ℕ) (L : List ℕ) (n : ℕ) : 1 ≤ slotsAt p (H :: L) n H := by
  unfold slotsAt
  rw [count_cons', ite_eq_left rfl]
  omega

/-- When level `j + 1` has enough slots, the number of slots at level `j` is what it should
be: slots = E-atoms + S-atoms + mixed segments. -/
theorem slotsAt_add (L : List ℕ) (n j : ℕ)
    (hadm : n / p ^ (j + 1) + (len p L - n) / p ^ (j + 1) ≤ topAt p L (j + 1)) :
    slotsAt p L n j + n / p ^ j + (len p L - n) / p ^ j =
      topAt p L j + dig p j n + dig p j (len p L - n) := by
  have hd : ∀ x : ℕ, x / p ^ j = dig p j x + p * (x / p ^ (j + 1)) := by
    intro x
    unfold dig
    rw [pow_succ, ← Nat.div_div_eq_div_mul]
    exact (Nat.mod_add_div (x / p ^ j) p).symm
  have hmul : p * (topAt p L (j + 1) - n / p ^ (j + 1) - (len p L - n) / p ^ (j + 1)) +
      p * (n / p ^ (j + 1)) + p * ((len p L - n) / p ^ (j + 1)) = p * topAt p L (j + 1) := by
    rw [← Nat.mul_add, ← Nat.mul_add]
    congr 1
    omega
  unfold slotsAt muAt
  rw [topAt_succ L j, hd n, hd (len p L - n)]
  omega

theorem fac_eq_zero_of_lt (L : List ℕ) (n j : ℕ)
    (h : slotsAt p L n j < dig p j n + dig p j (len p L - n)) : fac p L n j = 0 := by
  unfold fac
  by_cases h1 : slotsAt p L n j < dig p j n
  · rw [Nat.choose_eq_zero_of_lt h1, Nat.zero_mul]
  · rw [Nat.choose_eq_zero_of_lt
      (show slotsAt p L n j - dig p j n < dig p j (len p L - n) by omega), Nat.mul_zero]

/-- If some level `j` has too few slots, a factor of `slotCount` at a level `≥ j` is 0: take
the highest such level. -/
theorem exists_fac_eq_zero (L : List ℕ) (n B : ℕ) (hn : n ≤ len p L)
    (hB : len p L < p ^ B) :
    ∀ (d j : ℕ), j + d = B → topAt p L j < n / p ^ j + (len p L - n) / p ^ j →
      ∃ j0, j ≤ j0 ∧ j0 < B ∧ fac p L n j0 = 0 := by
  intro d
  induction d with
  | zero =>
    intro j hj hv
    exfalso
    have hj' : j = B := by omega
    rw [hj', Nat.div_eq_of_lt (show n < p ^ B by omega),
      Nat.div_eq_of_lt (show len p L - n < p ^ B by omega)] at hv
    omega
  | succ d ih =>
    intro j hj hv
    by_cases hv' : topAt p L (j + 1) < n / p ^ (j + 1) + (len p L - n) / p ^ (j + 1)
    · obtain ⟨j0, h1, h2, h3⟩ := ih (j + 1) (by omega) hv'
      exact ⟨j0, by omega, h2, h3⟩
    · have hs := slotsAt_add (p := p) L n j (by omega)
      exact ⟨j, le_refl j, by omega, fac_eq_zero_of_lt L n j (by omega)⟩

end relations

section pascal

theorem choose_mul_choose_eq_zero (σ a b : ℕ) (h : σ < a + b) :
    σ.choose a * (σ - a).choose b = 0 := by
  by_cases h1 : σ < a
  · rw [Nat.choose_eq_zero_of_lt h1, Nat.zero_mul]
  · rw [Nat.choose_eq_zero_of_lt (show σ - a < b by omega), Nat.mul_zero]

theorem choose_succ_ite (m b : ℕ) :
    (m + 1).choose b = (if 1 ≤ b then m.choose (b - 1) else 0) + m.choose b := by
  rcases b with _ | b
  · simp
  · rw [ite_eq_left (Nat.succ_le_succ (Nat.zero_le b)), Nat.add_sub_cancel,
      Nat.choose_succ_succ]

/-- **The Pascal rule for trinomial coefficients:** among `σ + 1` slots choose `a` and then
`b`; the last slot is one of the `a`, one of the `b`, or neither. -/
theorem trinomial_pascal (σ a b : ℕ) :
    (σ + 1).choose a * (σ + 1 - a).choose b =
      (if 1 ≤ a then σ.choose (a - 1) * (σ - (a - 1)).choose b else 0) +
      (if 1 ≤ b then σ.choose a * (σ - a).choose (b - 1) else 0) +
      σ.choose a * (σ - a).choose b := by
  rcases a with _ | a
  · have i1 : (if 1 ≤ 0 then σ.choose (0 - 1) * (σ - (0 - 1)).choose b else 0) = 0 :=
      ite_eq_right (by omega)
    rw [i1, Nat.choose_zero_right, Nat.choose_zero_right, Nat.sub_zero, Nat.sub_zero,
      choose_succ_ite σ b]
    split_ifs <;> ring
  · have i1 : (if 1 ≤ a + 1 then σ.choose (a + 1 - 1) * (σ - (a + 1 - 1)).choose b else 0) =
        σ.choose a * (σ - a).choose b := by
      rw [ite_eq_left (show 1 ≤ a + 1 by omega), Nat.add_sub_cancel]
    have e : σ + 1 - (a + 1) = σ - a := by omega
    rw [i1, e, Nat.choose_succ_succ]
    by_cases hle : a + 1 ≤ σ
    · have e2 : σ - (a + 1) + 1 = σ - a := by omega
      have k := choose_succ_ite (σ - (a + 1)) b
      rw [e2] at k
      rw [Nat.add_mul, k]
      split_ifs <;> ring
    · rw [Nat.choose_eq_zero_of_lt (show σ < a + 1 by omega)]
      simp

/-- The three terms of the recursion, put together by the Pascal rule. -/
theorem assemble (s a b P E S M : ℕ) (hs : 1 ≤ s)
    (hE : 1 ≤ a → E = (s - 1).choose (a - 1) * (s - 1 - (a - 1)).choose b * P)
    (hS : 1 ≤ b → S = (s - 1).choose a * (s - 1 - a).choose (b - 1) * P)
    (hM : M = (s - 1).choose a * (s - 1 - a).choose b * P) :
    s.choose a * (s - a).choose b * P =
      (if 1 ≤ a then E else 0) + (if 1 ≤ b then S else 0) + M := by
  obtain ⟨σ, rfl⟩ : ∃ σ, s = σ + 1 := ⟨s - 1, by omega⟩
  rw [Nat.add_sub_cancel] at hE hS hM
  rw [trinomial_pascal σ a b, Nat.add_mul, Nat.add_mul, hM]
  congr 1
  congr 1
  · by_cases h : 1 ≤ a
    · rw [ite_eq_left h, ite_eq_left h, hE h]
    · rw [ite_eq_right h, ite_eq_right h, Nat.zero_mul]
  · by_cases h : 1 ≤ b
    · rw [ite_eq_left h, ite_eq_left h, hS h]
    · rw [ite_eq_right h, ite_eq_right h, Nat.zero_mul]

end pascal

section recursion

/-- The term "the first block is all E". -/
theorem slotCount_E (hp : 2 ≤ p) (H : ℕ) (L : List ℕ) (x B : ℕ) (hH : H < B)
    (hcf : ds p (p ^ H + x) = ds p (p ^ H) + ds p x) :
    slotCount p L x B =
      (slotsAt p (H :: L) (p ^ H + x) H - 1).choose (dig p H (p ^ H + x) - 1) *
        (slotsAt p (H :: L) (p ^ H + x) H - 1 - (dig p H (p ^ H + x) - 1)).choose
          (dig p H (len p (H :: L) - (p ^ H + x))) *
      ∏ j ∈ (Finset.range B).erase H, fac p (H :: L) (p ^ H + x) j := by
  have hrel := fun j => rel_cons_E hp H L x j hcf
  have hprod : ∏ j ∈ (Finset.range B).erase H, fac p L x j =
      ∏ j ∈ (Finset.range B).erase H, fac p (H :: L) (p ^ H + x) j := by
    refine Finset.prod_congr rfl (fun j hj => ?_)
    have hjH : j ≠ H := Finset.ne_of_mem_erase hj
    obtain ⟨h1, h2, h3⟩ := hrel j
    unfold fac
    rw [h1, h2, h3, ite_eq_right (fun h => hjH h.symm), Nat.zero_add, Nat.zero_add]
  obtain ⟨h1, h2, h3⟩ := hrel H
  rw [slotCount_split L x B H hH, hprod, h1, h2, h3, ite_eq_left rfl]
  unfold fac
  rw [Nat.add_sub_cancel_left, Nat.add_sub_cancel_left]

/-- The term "the first block is all S". -/
theorem slotCount_S (hp : 2 ≤ p) (H : ℕ) (L : List ℕ) (n B : ℕ) (hH : H < B)
    (hn : n ≤ len p L)
    (hcf : ds p (p ^ H + (len p L - n)) = ds p (p ^ H) + ds p (len p L - n)) :
    slotCount p L n B =
      (slotsAt p (H :: L) n H - 1).choose (dig p H n) *
        (slotsAt p (H :: L) n H - 1 - dig p H n).choose
          (dig p H (len p (H :: L) - n) - 1) *
      ∏ j ∈ (Finset.range B).erase H, fac p (H :: L) n j := by
  have hrel := fun j => rel_cons_S hp H L n j hn hcf
  have hprod : ∏ j ∈ (Finset.range B).erase H, fac p L n j =
      ∏ j ∈ (Finset.range B).erase H, fac p (H :: L) n j := by
    refine Finset.prod_congr rfl (fun j hj => ?_)
    have hjH : j ≠ H := Finset.ne_of_mem_erase hj
    obtain ⟨h1, h2⟩ := hrel j
    unfold fac
    rw [h1, h2, ite_eq_right (fun h => hjH h.symm), Nat.zero_add, Nat.zero_add]
  obtain ⟨h1, h2⟩ := hrel H
  rw [slotCount_split L n B H hH, hprod, h1, h2, ite_eq_left rfl]
  unfold fac
  rw [Nat.add_sub_cancel_left, Nat.add_sub_cancel_left]

/-- The term "the first block is mixed": it is replaced by `p` blocks one level down. -/
theorem slotCount_M (h : ℕ) (L : List ℕ) (n B : ℕ) (hH : h + 1 < B)
    (hn : n ≤ len p ((h + 1) :: L)) (hB : len p ((h + 1) :: L) < p ^ B) :
    slotCount p (List.replicate p h ++ L) n B =
      (slotsAt p ((h + 1) :: L) n (h + 1) - 1).choose (dig p (h + 1) n) *
        (slotsAt p ((h + 1) :: L) n (h + 1) - 1 - dig p (h + 1) n).choose
          (dig p (h + 1) (len p ((h + 1) :: L) - n)) *
      ∏ j ∈ (Finset.range B).erase (h + 1), fac p ((h + 1) :: L) n j := by
  have hlen := len_replicate_append (p := p) h L
  have htop := slotsAt_mixed_top (p := p) h L n
  have hfacH : fac p (List.replicate p h ++ L) n (h + 1) =
      (slotsAt p ((h + 1) :: L) n (h + 1) - 1).choose (dig p (h + 1) n) *
        (slotsAt p ((h + 1) :: L) n (h + 1) - 1 - dig p (h + 1) n).choose
          (dig p (h + 1) (len p ((h + 1) :: L) - n)) := by
    unfold fac
    rw [htop, Nat.add_sub_cancel_left, hlen]
  rw [slotCount_split _ n B (h + 1) hH, hfacH]
  by_cases hgood : n / p ^ (h + 1) + (len p ((h + 1) :: L) - n) / p ^ (h + 1) + 1 ≤
      topAt p ((h + 1) :: L) (h + 1)
  · -- enough slots: the other levels are unchanged
    congr 1
    refine Finset.prod_congr rfl (fun j hj => ?_)
    have hjH : j ≠ h + 1 := Finset.ne_of_mem_erase hj
    unfold fac
    rw [hlen]
    by_cases hjh : j = h
    · rw [hjh, slotsAt_mixed_low h L n hgood]
    · rw [slotsAt_mixed_ne h L n j hjh hjH]
  · -- too few slots: both sides are 0
    by_cases hadm : n / p ^ (h + 1 + 1) + (len p ((h + 1) :: L) - n) / p ^ (h + 1 + 1) ≤
        topAt p ((h + 1) :: L) (h + 1 + 1)
    · have hs := slotsAt_add ((h + 1) :: L) n (h + 1) hadm
      have hz : (slotsAt p ((h + 1) :: L) n (h + 1) - 1).choose (dig p (h + 1) n) *
          (slotsAt p ((h + 1) :: L) n (h + 1) - 1 - dig p (h + 1) n).choose
            (dig p (h + 1) (len p ((h + 1) :: L) - n)) = 0 :=
        choose_mul_choose_eq_zero _ _ _ (by omega)
      rw [hz, Nat.zero_mul, Nat.zero_mul]
    · obtain ⟨j0, hj1, hj2, hj3⟩ := exists_fac_eq_zero ((h + 1) :: L) n B hn hB
        (B - (h + 1 + 1)) (h + 1 + 1) (by omega) (by omega)
      have hmem : j0 ∈ (Finset.range B).erase (h + 1) :=
        Finset.mem_erase.mpr ⟨by omega, Finset.mem_range.mpr hj2⟩
      have hfe : fac p (List.replicate p h ++ L) n j0 = fac p ((h + 1) :: L) n j0 := by
        unfold fac
        rw [hlen, slotsAt_mixed_ne h L n j0 (by omega) (by omega)]
      rw [Finset.prod_eq_zero hmem (hfe.trans hj3), Finset.prod_eq_zero hmem hj3, Nat.mul_zero]

/-- The recursion for `slotCount`, with the third term `M` left open. -/
theorem slotCount_cons_core (hp : 2 ≤ p) (H : ℕ) (L : List ℕ) (n B : ℕ)
    (hn : n ≤ p ^ H + len p L) (hB : p ^ H + len p L < p ^ B) (M : ℕ)
    (hM : M = (slotsAt p (H :: L) n H - 1).choose (dig p H n) *
        (slotsAt p (H :: L) n H - 1 - dig p H n).choose (dig p H (len p (H :: L) - n)) *
      ∏ j ∈ (Finset.range B).erase H, fac p (H :: L) n j) :
    slotCount p (H :: L) n B =
      (if 1 ≤ dig p H n then slotCount p L (n - p ^ H) B else 0) +
      (if 1 ≤ dig p H (p ^ H + len p L - n) then slotCount p L n B else 0) + M := by
  have hlen : len p (H :: L) = p ^ H + len p L := len_cons H L
  have hH : H < B := by
    by_contra hcon
    have h1 : p ^ B ≤ p ^ H := Nat.pow_le_pow_right (by omega) (by omega)
    omega
  rw [slotCount_split (H :: L) n B H hH, ← hlen]
  refine assemble _ _ _ _ _ _ _ (one_le_slotsAt_cons H L n) (fun hd => ?_) (fun hd => ?_) hM
  · obtain ⟨hle, hcf⟩ := cf_of_one_le_dig hp H n hd
    have hE := slotCount_E hp H L (n - p ^ H) B hH hcf
    have en : p ^ H + (n - p ^ H) = n := by omega
    rw [en] at hE
    exact hE
  · rw [hlen] at hd
    obtain ⟨hle, hcf⟩ := cf_of_one_le_dig hp H _ hd
    have hnL : n ≤ len p L := by omega
    have ey : p ^ H + len p L - n - p ^ H = len p L - n := by omega
    rw [ey] at hcf
    exact slotCount_S hp H L n B hH hnL hcf

/-- **Step 5.** The recursion for `slotCount`, first block of height `h + 1`. -/
theorem slotCount_cons_succ (hp : 2 ≤ p) (h : ℕ) (L : List ℕ) (n B : ℕ)
    (hn : n ≤ p ^ (h + 1) + len p L) (hB : p ^ (h + 1) + len p L < p ^ B) :
    slotCount p ((h + 1) :: L) n B =
      (if 1 ≤ dig p (h + 1) n then slotCount p L (n - p ^ (h + 1)) B else 0) +
      (if 1 ≤ dig p (h + 1) (p ^ (h + 1) + len p L - n) then slotCount p L n B else 0) +
      slotCount p (List.replicate p h ++ L) n B := by
  have hlen : len p ((h + 1) :: L) = p ^ (h + 1) + len p L := len_cons (h + 1) L
  have hH : h + 1 < B := by
    by_contra hcon
    have h1 : p ^ B ≤ p ^ (h + 1) := Nat.pow_le_pow_right (by omega) (by omega)
    omega
  exact slotCount_cons_core hp (h + 1) L n B hn hB _
    (slotCount_M h L n B hH (by rw [hlen]; exact hn) (by rw [hlen]; exact hB))

/-- **Step 5.** The recursion for `slotCount`, first block of height 0: there is no third
term. -/
theorem slotCount_cons_zero (hp : 2 ≤ p) (L : List ℕ) (n B : ℕ)
    (hn : n ≤ 1 + len p L) (hB : 1 + len p L < p ^ B) :
    slotCount p (0 :: L) n B =
      (if 1 ≤ dig p 0 n then slotCount p L (n - 1) B else 0) +
      (if 1 ≤ dig p 0 (1 + len p L - n) then slotCount p L n B else 0) := by
  have hlen : len p (0 :: L) = 1 + len p L := by rw [len_cons, pow_zero]
  have hB1 : 1 ≤ B := by
    rcases Nat.eq_zero_or_pos B with h0 | h0
    · rw [h0, pow_zero] at hB
      omega
    · exact h0
  have hn' : n ≤ len p (0 :: L) := by rw [hlen]; exact hn
  have hB' : len p (0 :: L) < p ^ B := by rw [hlen]; exact hB
  have hM : (0 : ℕ) = (slotsAt p (0 :: L) n 0 - 1).choose (dig p 0 n) *
      (slotsAt p (0 :: L) n 0 - 1 - dig p 0 n).choose (dig p 0 (len p (0 :: L) - n)) *
      ∏ j ∈ (Finset.range B).erase 0, fac p (0 :: L) n j := by
    by_cases hadm : n / p ^ (0 + 1) + (len p (0 :: L) - n) / p ^ (0 + 1) ≤
        topAt p (0 :: L) (0 + 1)
    · have hs := slotsAt_add (0 :: L) n 0 hadm
      rw [pow_zero, Nat.div_one, Nat.div_one, topAt_zero] at hs
      have h1 := one_le_slotsAt_cons (p := p) 0 L n
      have hz : (slotsAt p (0 :: L) n 0 - 1).choose (dig p 0 n) *
          (slotsAt p (0 :: L) n 0 - 1 - dig p 0 n).choose (dig p 0 (len p (0 :: L) - n)) = 0 :=
        choose_mul_choose_eq_zero _ _ _ (by omega)
      rw [hz, Nat.zero_mul]
    · obtain ⟨j0, hj1, hj2, hj3⟩ := exists_fac_eq_zero (0 :: L) n B hn' hB'
        (B - (0 + 1)) (0 + 1) (by omega) (by omega)
      have hmem : j0 ∈ (Finset.range B).erase 0 :=
        Finset.mem_erase.mpr ⟨by omega, Finset.mem_range.mpr hj2⟩
      rw [Finset.prod_eq_zero hmem hj3, Nat.mul_zero]
  have hcore := slotCount_cons_core hp 0 L n B (by rw [pow_zero]; exact hn)
    (by rw [pow_zero]; exact hB) 0 hM
  rw [pow_zero, Nat.add_zero] at hcore
  exact hcore

end recursion

end MMM.Path

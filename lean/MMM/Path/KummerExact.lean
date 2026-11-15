/-
Written by Claude Fable 5.2 (a subagent of the orchestrator, brief W044), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **Kummer's theorem with its residue, from the count of the minimal words.**

The note `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex`: Lemma `lem:carries`,
the congruence of Proposition `prop:count`, and Theorem `thm:binom`.

Everything here is proved from `SlotHyp p`, the statement that `Slots.lean` proves (the number of
minimal words over the top blocks `L` is `slotCount p L n B`). This file does not import
`Slots.lean`.

* `exists_digit_blocks`: the base-p digits of `N` as a list of block heights, with the number of
  blocks of each height and the quantity `topAt`.
* `carryAt`, `carryAt_zero`, `carryAt_le_one`, `carryAt_rec`, `sum_carryAt`: the carries of the
  addition `n + (N - n)` in base p (Lemma `lem:carries`).
* `slotCount_digits`: for the digit list, `slotCount * ∏ n_j! m_j! = ∏_j (N_j + p c_(j+1))!`.
* `factorial_add_prime_modEq`: `(r + p)! ≡ -p r!  (mod p²)` for `r < p` (Wilson's theorem).
* `choose_residue_of`: `binom(N, n) ∏ n_j! m_j! ≡ (-p)^c ∏ N_j!  (mod p^(c+1))`.
* `kummer_exact_of`: `p^c` is the exact power of `p` in `binom(N, n)`.

No Mathlib theorem about the valuation of a factorial or of a binomial coefficient is used, and
no theorem of Lucas or Kummer. From Mathlib's number theory: Wilson's theorem
(`ZMod.wilsons_lemma`), and `Nat.Prime.dvd_factorial` (a prime divides `r!` only if `r ≥ p`).
-/
import MMM.Path.SlotsDef
import MMM.DigitsFree
import Mathlib.NumberTheory.Wilson
import Mathlib.Data.Nat.Prime.Factorial

namespace MMM.Path

open MMM

variable {p : ℕ}

/-- The statement of `Slots.lean`. -/
def SlotHyp (p : ℕ) [NeZero p] : Prop :=
  ∀ (L : List ℕ) (n B : ℕ), n ≤ len p L → len p L < p ^ B → minWords p L n = slotCount p L n B

/-! ### The digit list

The helper lemmas with general names are `private`: `Slots.lean` is written at the same time in
the same namespace, and a later file imports both. -/

private theorem topAt_nil (j : ℕ) : topAt p [] j = 0 := by simp [topAt]

private theorem topAt_append (A B : List ℕ) (j : ℕ) :
    topAt p (A ++ B) j = topAt p A j + topAt p B j := by
  simp [topAt]

private theorem topAt_zero (L : List ℕ) : topAt p L 0 = len p L := by
  simp [topAt, len]

private theorem topAt_cons (a : ℕ) (L : List ℕ) (j : ℕ) :
    topAt p (a :: L) j = (if j ≤ a then p ^ (a - j) else 0) + topAt p L j := by
  unfold topAt
  rw [List.filter_cons]
  by_cases h : j ≤ a <;> simp [h]

private theorem topAt_map_succ (L : List ℕ) (j : ℕ) :
    topAt p (L.map (· + 1)) (j + 1) = topAt p L j := by
  induction L with
  | nil => simp [topAt]
  | cons a L ih =>
    rw [List.map_cons, topAt_cons, topAt_cons, ih]
    simp

private theorem topAt_replicate_zero (m j : ℕ) :
    topAt p (List.replicate m 0) (j + 1) = 0 := by
  simp [topAt]

/-- The base-p digits of `N` as a list of block heights: `dig p j N` blocks of height `j`. -/
theorem exists_digit_blocks (hp : 2 ≤ p) (N : ℕ) :
    ∃ L : List ℕ, len p L = N ∧ L.length = ds p N ∧ (∀ j, L.count j = dig p j N) ∧
      ∀ j, topAt p L j = N / p ^ j := by
  induction N using Nat.strong_induction_on with
  | _ N ih =>
    by_cases hN : N = 0
    · subst hN
      exact ⟨[], by simp [len], by simp [ds_zero], fun j => by simp [dig],
        fun j => by simp [topAt_nil]⟩
    · obtain ⟨L, hL, hd, hcount, htop⟩ := ih (N / p) (Nat.div_lt_self (Nat.pos_of_ne_zero hN) hp)
      have hlen : len p (L.map (· + 1) ++ List.replicate (N % p) 0) = N := by
        rw [len_append, len_map_succ, len_replicate_zero, hL]
        exact Nat.div_add_mod N p
      refine ⟨L.map (· + 1) ++ List.replicate (N % p) 0, hlen, ?_, ?_, ?_⟩
      · rw [List.length_append, List.length_map, List.length_replicate, ds_rec hp N, hd, add_comm]
      · intro j
        rw [List.count_append]
        rcases j with _ | j
        · have h0 : List.count 0 (L.map (· + 1)) = 0 :=
            List.count_eq_zero_of_not_mem (by simp)
          rw [h0, List.count_replicate_self, dig_zero, zero_add]
        · have h1 : List.count (j + 1) (L.map (· + 1)) = List.count j L :=
            List.count_map_of_injective L (· + 1) (fun a b h => Nat.succ_injective h) j
          have h2 : List.count (j + 1) (List.replicate (N % p) 0) = 0 :=
            List.count_eq_zero_of_not_mem (by simp [List.mem_replicate])
          rw [h1, h2, add_zero, hcount, dig_succ]
      · intro j
        rcases j with _ | j
        · rw [topAt_zero, hlen, pow_zero, Nat.div_one]
        · rw [topAt_append, topAt_map_succ, topAt_replicate_zero, add_zero, htop, pow_succ',
            Nat.div_div_eq_div_mul]

/-! ### The carries (Lemma `lem:carries`) -/

/-- The carry into digit j when n and N - n are added in base p. -/
def carryAt (p N n j : ℕ) : ℕ := N / p ^ j - n / p ^ j - (N - n) / p ^ j

/-- The quotients of `N`, `n`, `N - n` by `p ^ j` and the carry; the carry is 0 or 1. -/
theorem div_eq_add_carryAt (hp : 2 ≤ p) {N n : ℕ} (hn : n ≤ N) (j : ℕ) :
    N / p ^ j = n / p ^ j + (N - n) / p ^ j + carryAt p N n j ∧ carryAt p N n j ≤ 1 := by
  have hpos : 0 < p ^ j := Nat.pow_pos (by omega)
  have h := Nat.add_div (a := n) (b := N - n) hpos
  rw [Nat.add_sub_cancel' hn] at h
  unfold carryAt
  split_ifs at h <;> omega

/-- There is no carry into digit 0. (The hypothesis is that of the brief; the proof does not
need it, because the subtraction is truncated.) -/
theorem carryAt_zero {N n : ℕ} (hn : n ≤ N) : carryAt p N n 0 = 0 := by
  simp [carryAt]

theorem carryAt_le_one (hp : 2 ≤ p) {N n : ℕ} (hn : n ≤ N) (j : ℕ) : carryAt p N n j ≤ 1 :=
  (div_eq_add_carryAt hp hn j).2

/-- `x / p ^ j = x_j + p * (x / p ^ (j + 1))`. -/
private theorem div_pow_eq_dig_add (p x j : ℕ) :
    x / p ^ j = dig p j x + p * (x / p ^ (j + 1)) := by
  unfold dig
  rw [pow_succ, ← Nat.div_div_eq_div_mul, add_comm]
  exact (Nat.div_add_mod _ p).symm

/-- The carry recursion of Lemma `lem:carries`. -/
theorem carryAt_rec (hp : 2 ≤ p) {N n : ℕ} (hn : n ≤ N) (j : ℕ) :
    dig p j N + p * carryAt p N n (j + 1) = dig p j n + dig p j (N - n) + carryAt p N n j := by
  have h0 := (div_eq_add_carryAt hp hn j).1
  have h1 := (div_eq_add_carryAt hp hn (j + 1)).1
  rw [div_pow_eq_dig_add p N j, div_pow_eq_dig_add p n j, div_pow_eq_dig_add p (N - n) j, h1,
    Nat.mul_add, Nat.mul_add] at h0
  omega

/-- `(p - 1) * (x / p + x / p² + …) + s_p(x) = x`. -/
private theorem sum_div_pow_add_ds (hp : 2 ≤ p) : ∀ (B x : ℕ), x < p ^ B →
    (p - 1) * ∑ j ∈ Finset.range B, x / p ^ (j + 1) + ds p x = x := by
  intro B
  induction B with
  | zero =>
    intro x hx
    have : x = 0 := by simpa using hx
    subst this
    simp
  | succ B ih =>
    intro x hx
    have hp0 : 0 < p := by omega
    have h1 : x / p < p ^ B := by
      rw [Nat.div_lt_iff_lt_mul hp0, ← pow_succ]; exact hx
    have h2 := ih (x / p) h1
    have h3 : ∑ j ∈ Finset.range (B + 1), x / p ^ (j + 1) =
        x / p + ∑ j ∈ Finset.range B, x / p / p ^ (j + 1) := by
      rw [Finset.sum_range_succ', zero_add, pow_one, add_comm]
      congr 1
      exact Finset.sum_congr rfl (fun j _ => by
        rw [Nat.div_div_eq_div_mul, ← pow_succ'])
    rw [h3, ds_rec hp x, Nat.mul_add]
    have h4 := Nat.div_add_mod x p
    obtain ⟨r, hr⟩ : ∃ r, p = r + 1 := ⟨p - 1, by omega⟩
    have h5 : p * (x / p) = (p - 1) * (x / p) + x / p := by
      rw [hr]; simp [Nat.add_mul]
    omega

/-- The number of carries, through the digit sums. -/
theorem sum_carryAt (hp : 2 ≤ p) {N n : ℕ} (hn : n ≤ N) (B : ℕ) (hB : N < p ^ B) :
    (p - 1) * ∑ j ∈ Finset.range B, carryAt p N n (j + 1) + ds p N = ds p n + ds p (N - n) := by
  have hN := sum_div_pow_add_ds hp B N hB
  have hn' := sum_div_pow_add_ds hp B n (lt_of_le_of_lt hn hB)
  have hm' := sum_div_pow_add_ds hp B (N - n) (lt_of_le_of_lt (Nat.sub_le N n) hB)
  have hsum : ∑ j ∈ Finset.range B, N / p ^ (j + 1) =
      ∑ j ∈ Finset.range B, n / p ^ (j + 1) + ∑ j ∈ Finset.range B, (N - n) / p ^ (j + 1) +
        ∑ j ∈ Finset.range B, carryAt p N n (j + 1) := by
    rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun j _ => (div_eq_add_carryAt hp hn (j + 1)).1)
  rw [hsum, Nat.mul_add, Nat.mul_add] at hN
  omega

/-! ### The value of the count for the digit list -/

/-- ∏_j x_j!: the product of the factorials of the base-p digits. -/
def digFact (p x : ℕ) : ℕ := ∏ j ∈ Finset.range (x + 1), (dig p j x).factorial

/-- The product of the factorials of the digits, over any range that contains all digits. -/
theorem digFact_eq_prod_range (hp : 2 ≤ p) (x B : ℕ) (hx : x < p ^ B) :
    digFact p x = ∏ j ∈ Finset.range B, (dig p j x).factorial := by
  have key : ∀ B₁ B₂ : ℕ, B₁ ≤ B₂ → x < p ^ B₁ →
      ∏ j ∈ Finset.range B₁, (dig p j x).factorial =
        ∏ j ∈ Finset.range B₂, (dig p j x).factorial := by
    intro B₁ B₂ h12 hx1
    refine Finset.prod_subset (Finset.range_mono h12) (fun j _ hj => ?_)
    have hj' : B₁ ≤ j := by simpa using hj
    rw [dig_eq_zero_of_lt (lt_of_lt_of_le hx1 (Nat.pow_le_pow_right (by omega) hj')),
      Nat.factorial_zero]
  have hx0 : x < p ^ (x + 1) :=
    (Nat.lt_pow_self (by omega : 1 < p)).trans_le (Nat.pow_le_pow_right (by omega) (by omega))
  unfold digFact
  rcases le_total B (x + 1) with h | h
  · exact (key B (x + 1) h hx).symm
  · exact key (x + 1) B h hx0

/-- Choosing `a` and then `b` among `s` slots, when at most one slot is left over. -/
private theorem choose_mul_choose_mul_factorial {s a b : ℕ} (h : s ≤ a + b + 1) (hab : a + b ≤ s) :
    s.choose a * (s - a).choose b * (a.factorial * b.factorial) = s.factorial := by
  have h1 := Nat.choose_mul_factorial_mul_factorial (n := s) (k := a) (by omega)
  have h2 := Nat.choose_mul_factorial_mul_factorial (n := s - a) (k := b) (by omega)
  have h3 : (s - a - b).factorial = 1 := Nat.factorial_eq_one.mpr (by omega)
  rw [h3, mul_one] at h2
  rw [← h1, ← h2]
  ring

/-- The note's count: for the digit list, slotCount · ∏ n_j! m_j! = ∏_j (N_j + p c_(j+1))!. -/
theorem slotCount_digits (hp : 2 ≤ p) (N n B : ℕ) (hn : n ≤ N) (hB : N < p ^ B) (L : List ℕ)
    (hL : len p L = N) (hcount : ∀ j, L.count j = dig p j N)
    (htop : ∀ j, topAt p L j = N / p ^ j) :
    slotCount p L n B * (digFact p n * digFact p (N - n)) =
      ∏ j ∈ Finset.range B, (dig p j N + p * carryAt p N n (j + 1)).factorial := by
  have hmu : ∀ j, muAt p L n j = carryAt p N n j := fun j => by
    unfold muAt carryAt
    rw [htop, hL]
  have hslots : ∀ j, slotsAt p L n j = dig p j N + p * carryAt p N n (j + 1) := fun j => by
    unfold slotsAt
    rw [hcount, hmu]
  rw [digFact_eq_prod_range hp n B (lt_of_le_of_lt hn hB),
    digFact_eq_prod_range hp (N - n) B (lt_of_le_of_lt (Nat.sub_le N n) hB)]
  unfold slotCount
  rw [← Finset.prod_mul_distrib, ← Finset.prod_mul_distrib]
  refine Finset.prod_congr rfl (fun j _ => ?_)
  rw [hslots, hL]
  have hrec := carryAt_rec hp hn j
  have hc1 := carryAt_le_one hp hn j
  exact choose_mul_choose_mul_factorial (by omega) (by omega)

/-! ### Wilson's step and the residue -/

/-- Wilson: (r + p)! ≡ -p · r!  (mod p²) for r < p. (The proof does not use `hr`: the congruence
holds for every `r`. The hypothesis is that of the brief, and the only case used.) -/
theorem factorial_add_prime_modEq [hp : Fact p.Prime] (r : ℕ) (hr : r < p) :
    ((r + p).factorial : ℤ) ≡ -(p : ℤ) * (r.factorial : ℤ) [ZMOD (p : ℤ) ^ 2] := by
  have hp0 : p ≠ 0 := hp.out.ne_zero
  obtain ⟨A, hA⟩ : ∃ A : ℕ, A = (p - 1).factorial * (p + 1).ascFactorial r := ⟨_, rfl⟩
  obtain ⟨R, hR⟩ : ∃ R : ℕ, R = r.factorial := ⟨_, rfl⟩
  -- (r + p)! = p * ((p - 1)! * ∏_{i < r} (p + 1 + i))
  have h1 : (r + p).factorial = p * A := by
    rw [hA, add_comm, ← Nat.factorial_mul_ascFactorial, ← Nat.mul_factorial_pred hp0, mul_assoc]
  -- modulo p the second factor is -r!, by Wilson's theorem
  have h2 : ((A : ℕ) : ZMod p) = -((R : ℕ) : ZMod p) := by
    rw [hA, hR, Nat.cast_mul, ZMod.wilsons_lemma, Nat.ascFactorial_eq_prod_range,
      ← Finset.prod_range_add_one_eq_factorial, Nat.cast_prod, Nat.cast_prod, neg_one_mul]
    congr 1
    refine Finset.prod_congr rfl (fun i _ => ?_)
    rw [Nat.cast_add, Nat.cast_add, ZMod.natCast_self, zero_add, Nat.cast_add, add_comm]
  have h3 : (p : ℤ) ∣ (A : ℤ) + (R : ℤ) := by
    apply (ZMod.intCast_zmod_eq_zero_iff_dvd _ p).mp
    rw [Int.cast_add, Int.cast_natCast, Int.cast_natCast, h2, neg_add_cancel]
  obtain ⟨e, he⟩ := h3
  rw [h1, ← hR]
  refine Int.modEq_iff_dvd.mpr ⟨-e, ?_⟩
  rw [Nat.cast_mul]
  linear_combination (-(p : ℤ)) * he

/-- Congruences of the shape `x ≡ (-P)^a u (mod P^(a+1))` can be multiplied. -/
private theorem modEq_mul_neg_pow (P : ℤ) {x y u v : ℤ} {a b : ℕ}
    (hx : x ≡ (-P) ^ a * u [ZMOD P ^ (a + 1)]) (hy : y ≡ (-P) ^ b * v [ZMOD P ^ (b + 1)]) :
    x * y ≡ (-P) ^ (a + b) * (u * v) [ZMOD P ^ (a + b + 1)] := by
  obtain ⟨e, he⟩ := Int.modEq_iff_dvd.mp hx
  obtain ⟨f, hf⟩ := Int.modEq_iff_dvd.mp hy
  refine Int.modEq_iff_dvd.mpr ⟨(-1) ^ a * u * f + (-1) ^ b * e * v - P * e * f, ?_⟩
  have hx' : x = (-P) ^ a * u - P ^ (a + 1) * e := by linear_combination -he
  have hy' : y = (-P) ^ b * v - P ^ (b + 1) * f := by linear_combination -hf
  rw [hx', hy', neg_pow P a, neg_pow P b, neg_pow P (a + b)]
  ring

/-- The product of the factorials `(N_j + p c_(j+1))!` modulo `p ^ (c + 1)`: each carry
contributes a factor `-p`, by Wilson's theorem. -/
private theorem prod_factorial_modEq [hp : Fact p.Prime] (f g : ℕ → ℕ) (hf : ∀ j, f j < p)
    (hg : ∀ j, g j ≤ 1) (B : ℕ) :
    ((∏ j ∈ Finset.range B, (f j + p * g j).factorial : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ (∑ j ∈ Finset.range B, g j) *
        ((∏ j ∈ Finset.range B, (f j).factorial : ℕ) : ℤ)
      [ZMOD (p : ℤ) ^ (∑ j ∈ Finset.range B, g j + 1)] := by
  induction B with
  | zero =>
    rw [Finset.prod_range_zero, Finset.sum_range_zero, Finset.prod_range_zero, pow_zero,
      Nat.cast_one, mul_one]
  | succ B ih =>
    rw [Finset.prod_range_succ, Finset.sum_range_succ, Finset.prod_range_succ, Nat.cast_mul,
      Nat.cast_mul]
    refine modEq_mul_neg_pow (p : ℤ) ih ?_
    rcases Nat.le_one_iff_eq_zero_or_eq_one.mp (hg B) with h | h
    · rw [h, mul_zero, add_zero, pow_zero, one_mul]
    · rw [h, mul_one, pow_one]
      exact factorial_add_prime_modEq (f B) (hf B)

/-- Theorem `thm:binom`, the residue (Anton, Stickelberger, Hensel), given the count. -/
theorem choose_residue_of [hp : Fact p.Prime] (H : SlotHyp p) (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + ds p N = ds p n + ds p (N - n)) :
    (N.choose n : ℤ) * ((digFact p n * digFact p (N - n) : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ c * (digFact p N : ℤ) [ZMOD (p : ℤ) ^ (c + 1)] := by
  have hp2 : 2 ≤ p := hp.out.two_le
  obtain ⟨L, hL, hlen, hcount, htop⟩ := exists_digit_blocks hp2 N
  have hB : N < p ^ (N + 1) :=
    (Nat.lt_pow_self (by omega : 1 < p)).trans_le (Nat.pow_le_pow_right (by omega) (by omega))
  have hn' : n ≤ len p L := hL.symm ▸ hn
  have hc' : (p - 1) * c + L.length = ds p n + ds p (len p L - n) := by
    rw [hlen, hL]
    exact hc
  -- the binomial coefficient is the count modulo p^(c+1)
  have h1 : N.choose n ≡ slotCount p L n (N + 1) [MOD p ^ (c + 1)] := by
    have h := choose_modEq_minWords L n c hn' hc'
    rw [H L n (N + 1) hn' (hL.symm ▸ hB), hL] at h
    exact h
  have h2 : ((N.choose n : ℕ) : ℤ) ≡ ((slotCount p L n (N + 1) : ℕ) : ℤ)
      [ZMOD (p : ℤ) ^ (c + 1)] := by
    have h := Int.natCast_modEq_iff.mpr h1
    rw [Nat.cast_pow] at h
    exact h
  have h3 := h2.mul_right (((digFact p n * digFact p (N - n) : ℕ)) : ℤ)
  rw [← Nat.cast_mul (slotCount p L n (N + 1)),
    slotCount_digits hp2 N n (N + 1) hn hB L hL hcount htop] at h3
  refine h3.trans ?_
  -- the number of carries
  have hS : ∑ j ∈ Finset.range (N + 1), carryAt p N n (j + 1) = c := by
    have h := sum_carryAt hp2 hn (N + 1) hB
    have h' : (p - 1) * ∑ j ∈ Finset.range (N + 1), carryAt p N n (j + 1) = (p - 1) * c := by
      omega
    exact Nat.eq_of_mul_eq_mul_left (by omega) h'
  have h4 := prod_factorial_modEq (p := p) (fun j => dig p j N)
    (fun j => carryAt p N n (j + 1)) (fun j => dig_lt hp2 j N)
    (fun j => carryAt_le_one hp2 hn (j + 1)) (N + 1)
  rw [hS] at h4
  exact h4

/-- A prime does not divide a product of factorials of digits. -/
theorem coprime_digFact [hp : Fact p.Prime] (x : ℕ) : Nat.Coprime p (digFact p x) := by
  unfold digFact
  refine Nat.Coprime.prod_right (fun j _ => ?_)
  rw [hp.out.coprime_iff_not_dvd, hp.out.dvd_factorial]
  exact not_le.mpr (dig_lt hp.out.two_le j x)

/-- Theorem `thm:binom`, Kummer's theorem: p^c is the exact power of p in the binomial
coefficient. -/
theorem kummer_exact_of [hp : Fact p.Prime] (H : SlotHyp p) (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + ds p N = ds p n + ds p (N - n)) :
    p ^ c ∣ N.choose n ∧ ¬ p ^ (c + 1) ∣ N.choose n := by
  refine ⟨kummer_dvd N n c hn hc.le, fun hdvd => ?_⟩
  have hres := choose_residue_of H N n c hn hc
  obtain ⟨e, he⟩ := Int.modEq_iff_dvd.mp hres
  obtain ⟨d, hd⟩ := hdvd
  have hd' : ((N.choose n : ℕ) : ℤ) = (p : ℤ) ^ (c + 1) * d := by
    rw [hd, Nat.cast_mul, Nat.cast_pow]
  have hneg : (-(p : ℤ)) ^ c = (-1) ^ c * (p : ℤ) ^ c := by rw [neg_pow]
  rw [hd', hneg] at he
  have h1 : (p : ℤ) ^ c * ((-1) ^ c * (digFact p N : ℤ)) =
      (p : ℤ) ^ c * ((p : ℤ) *
        ((d : ℤ) * ((digFact p n * digFact p (N - n) : ℕ) : ℤ) + e)) := by
    linear_combination he
  have h2 := mul_left_cancel₀ (pow_ne_zero c (by exact_mod_cast hp.out.ne_zero)) h1
  have h3 : (p : ℤ) ∣ (digFact p N : ℤ) := by
    have h4 : (p : ℤ) ∣ (-1) ^ c * (digFact p N : ℤ) := ⟨_, h2⟩
    have h5 := Dvd.dvd.mul_left h4 ((-1) ^ c)
    rw [← mul_assoc, ← mul_pow] at h5
    simpa using h5
  exact (hp.out.coprime_iff_not_dvd.mp (coprime_digFact N)) (Int.natCast_dvd_natCast.mp h3)

end MMM.Path

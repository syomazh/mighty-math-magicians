/-
Written by Claude Fable 5.2 (a subagent of the orchestrator, brief W044), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **Problem 137 by the path proof, stated with Mathlib's definitions only, given the count.**

For a prime `p`, `q = p ^ k` with `k ≥ 1`, and the Fuss–Catalan number
`C = binom(q n, n) / ((q - 1) n + 1)`, from `SlotHyp p` (the count of the minimal words, the
statement of `Slots.lean`, which this file does not import):

* `residue_fussCatalan_path_of`:  `C * ∏ (digits of (q - 1) n + 1)! ≡ (-p) ^ t  (mod p ^ (t + 1))`;
* `problem137_fussCatalan_exact_path_of`:  `p ^ t ∣ C` and `p ^ (t + 1) ∤ C`, where
  `(p - 1) t + 1 = s_p((q - 1) n + 1)`;
* `problem137_fussCatalan_path_of`:  `(p - 1) * v_p(C) + 1 = s_p((q - 1) n + 1)`.

The proof is the last section of the note
`guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex`: with `N = q n + 1`,
`binom(N, n) = N * C`, the digits of `N` are a 1 followed by zeros and the digits of `n`, so the
addition `n + ((q - 1) n + 1)` has `t` carries; Kummer's theorem with its residue
(`KummerExact.lean`) and `N ≡ 1 (mod p)` give the statements.

What is borrowed from the files of the tree proof has nothing to do with rotations of trees:

* `PTree.choose_div_eq_card`, `PTree.card_nodes_mul_eq_choose` (`FussFormula.lean`): `C` is the
  number of `q`-ary trees with `n` internal nodes, and `(q n + 1) * C = binom(q n + 1, n)`;
* `PTree.prod_dig_eq_digits` (`ResidueForms.lean`), `multiplicity_eq_of_exact`
  (`ExactCond.lean`), `ds_modEq` (`Exact.lean`): arithmetic.

`multiplicity` occurs only in the statement and the last step of the last theorem.
-/
import MMM.Path.KummerExact
import MMM.FussFormula
import MMM.ResidueForms
import MMM.ExactCond
import MMM.Exact
import Mathlib.RingTheory.Coprime.Lemmas

namespace MMM.Path

open MMM

/- Two instances `Fact p.Prime → NeZero p` are in scope here: this folder's
(`Path/ClassSize.lean`) and the tree proof's (`MMM/ClassSize.lean`, through the imports). Prefer
this folder's, so that `SlotHyp p` below is literally the `SlotHyp p` of `KummerExact.lean` and
the theorems reach nothing in `MMM/ClassSize.lean`. (`NeZero p` is a proposition: the two
instances are equal, the choice changes no meaning.) -/
attribute [local instance 2000] instNeZeroOfPrimePath

section digits

variable {p : ℕ}

/-! The helper lemmas with general names are `private` (see `KummerExact.lean`). -/

/-- `s_p(p x + r) = r + s_p(x)` for a digit `r`. -/
private theorem ds_mul_add (hp : 2 ≤ p) (x r : ℕ) (hr : r < p) :
    ds p (p * x + r) = r + ds p x := by
  rw [ds_rec hp (p * x + r), Nat.mul_add_mod, Nat.mod_eq_of_lt hr, Nat.mul_add_div (by omega),
    Nat.div_eq_of_lt hr, add_zero]

/-- The digits of `p x + r` are the digit `r` and then the digits of `x`. -/
private theorem digFact_mul_add (hp : 2 ≤ p) (x r : ℕ) (hr : r < p) :
    digFact p (p * x + r) = r.factorial * digFact p x := by
  have hx : x < p ^ (x + 1) :=
    (Nat.lt_pow_self (by omega : 1 < p)).trans_le (Nat.pow_le_pow_right (by omega) (by omega))
  have hx' : p * x + r < p ^ (x + 1 + 1) := by
    rw [pow_succ' p (x + 1)]
    have h : p * (x + 1) ≤ p * p ^ (x + 1) := Nat.mul_le_mul_left p hx
    rw [Nat.mul_add] at h
    omega
  rw [digFact_eq_prod_range hp _ _ hx', digFact_eq_prod_range hp _ _ hx,
    Finset.prod_range_succ', dig_zero, Nat.mul_add_mod, Nat.mod_eq_of_lt hr, mul_comm]
  congr 1
  refine Finset.prod_congr rfl (fun j _ => ?_)
  rw [dig_succ, Nat.mul_add_div (by omega), Nat.div_eq_of_lt hr, add_zero]

private theorem ds_pow_mul (hp : 2 ≤ p) (k x : ℕ) : ds p (p ^ k * x) = ds p x := by
  induction k with
  | zero => simp
  | succ k ih => rw [pow_succ', mul_assoc, ds_base_mul hp, ih]

private theorem digFact_pow_mul (hp : 2 ≤ p) (k x : ℕ) : digFact p (p ^ k * x) = digFact p x := by
  induction k with
  | zero => simp
  | succ k ih =>
    have h := digFact_mul_add hp (p ^ k * x) 0 (by omega)
    rw [add_zero, Nat.factorial_zero, one_mul, ih] at h
    rw [pow_succ', mul_assoc, h]

/-- The digit sum of `N = q n + 1`: one more than that of `n`. -/
private theorem ds_pow_mul_add_one (hp : 2 ≤ p) (k n : ℕ) (hk : 0 < k) :
    ds p (p ^ k * n + 1) = 1 + ds p n := by
  obtain ⟨k', rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
  rw [pow_succ', mul_assoc, ds_mul_add hp _ 1 (by omega), ds_pow_mul hp]

/-- The digits of `N = q n + 1` are a 1, zeros, and the digits of `n`. -/
private theorem digFact_pow_mul_add_one (hp : 2 ≤ p) (k n : ℕ) (hk : 0 < k) :
    digFact p (p ^ k * n + 1) = digFact p n := by
  obtain ⟨k', rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
  rw [pow_succ', mul_assoc, digFact_mul_add hp _ 1 (by omega), digFact_pow_mul hp,
    Nat.factorial_one, one_mul]

/-- `digFact` is the product of the factorials of Mathlib's digit list. -/
theorem digFact_eq_digits (hp : 2 ≤ p) (m : ℕ) :
    digFact p m = ((Nat.digits p m).map Nat.factorial).prod := by
  rw [← PTree.prod_dig_eq_digits p m hp]
  unfold digFact
  rw [Finset.prod_range_succ, dig_eq_zero_of_lt (Nat.lt_pow_self (by omega : 1 < p)),
    Nat.factorial_zero, mul_one]

end digits

/-- The exact power of `p` in the Fuss–Catalan number and its residue, in the notation of
`KummerExact.lean`, given the count. -/
theorem fussCatalan_exact_residue_of (p : ℕ) [hp : Fact p.Prime] (H : SlotHyp p) (k n t : ℕ)
    (hk : 0 < k) (ht : (p - 1) * t + 1 = ds p ((p ^ k - 1) * n + 1)) :
    (p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
      ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) ∧
    ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
        (digFact p ((p ^ k - 1) * n + 1) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hq : 1 ≤ p ^ k := Nat.one_le_pow _ _ hp.out.pos
  obtain ⟨C, hC⟩ : ∃ C, C = Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) := ⟨_, rfl⟩
  rw [← hC]
  -- binom(N, n) = N * C for N = q n + 1
  have hNC : (p ^ k * n + 1) * C = Nat.choose (p ^ k * n + 1) n := by
    rw [hC, PTree.choose_div_eq_card hq n]
    exact PTree.card_nodes_mul_eq_choose hq n
  have hqn : p ^ k * n = (p ^ k - 1) * n + n := by
    have h : (p ^ k - 1 + 1) * n = p ^ k * n := by rw [Nat.sub_add_cancel hq]
    rw [Nat.add_mul, Nat.one_mul] at h
    omega
  have hm : p ^ k * n + 1 - n = (p ^ k - 1) * n + 1 := by omega
  have hn : n ≤ p ^ k * n + 1 := by omega
  -- the addition n + ((q - 1) n + 1) has t carries
  have hc : (p - 1) * t + ds p (p ^ k * n + 1) = ds p n + ds p (p ^ k * n + 1 - n) := by
    rw [hm, ds_pow_mul_add_one hp2 k n hk, ← ht]
    omega
  obtain ⟨e1, e2⟩ := kummer_exact_of H (p ^ k * n + 1) n t hn hc
  have hres := choose_residue_of H (p ^ k * n + 1) n t hn hc
  rw [← hNC] at e1 e2 hres
  rw [hm, digFact_pow_mul_add_one hp2 k n hk] at hres
  obtain ⟨Dm, hDm⟩ : ∃ Dm, Dm = digFact p ((p ^ k - 1) * n + 1) := ⟨_, rfl⟩
  rw [← hDm] at hres ⊢
  obtain ⟨k', rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
  -- p does not divide N
  have hcop : Nat.Coprime p (p ^ (k' + 1) * n + 1) := by
    rw [hp.out.coprime_iff_not_dvd, pow_succ', mul_assoc]
    intro h
    have h1 : p ∣ 1 := (Nat.dvd_add_right (dvd_mul_right p _)).mp h
    have h2 := Nat.le_of_dvd Nat.one_pos h1
    omega
  have hpt : p ^ t ∣ C := (Nat.Coprime.pow_left t hcop).dvd_of_dvd_mul_left e1
  refine ⟨⟨hpt, fun h => e2 (Dvd.dvd.mul_left h _)⟩, ?_⟩
  -- the residue: cancel ∏ n_j!, then use N ≡ 1 (mod p) and p^t ∣ C
  obtain ⟨e, he⟩ := Int.modEq_iff_dvd.mp hres
  have hcopZ : IsCoprime ((p : ℤ) ^ (t + 1)) (digFact p n : ℤ) := by
    have h := Nat.Coprime.pow_left (t + 1) (coprime_digFact (p := p) n)
    exact_mod_cast Nat.isCoprime_iff_coprime.mpr h
  have h1 : (p : ℤ) ^ (t + 1) ∣
      ((-(p : ℤ)) ^ t - ((p ^ (k' + 1) * n + 1 : ℕ) : ℤ) * (C : ℤ) * (Dm : ℤ)) *
        (digFact p n : ℤ) :=
    ⟨e, by rw [← he]; push_cast; ring⟩
  obtain ⟨f, hf⟩ := hcopZ.dvd_of_dvd_mul_right h1
  obtain ⟨c', hc'⟩ := hpt
  refine Int.modEq_iff_dvd.mpr ⟨f + (p : ℤ) ^ k' * (n : ℤ) * (c' : ℤ) * (Dm : ℤ), ?_⟩
  rw [hc'] at hf ⊢
  push_cast at hf ⊢
  linear_combination hf

/-- **The residue of the Fuss–Catalan number, by the path proof, given the count.** -/
theorem residue_fussCatalan_path_of (p : ℕ) [hp : Fact p.Prime] (H : SlotHyp p) (k n t : ℕ)
    (hk : 0 < k) (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    ((Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) : ℕ) : ℤ) *
        ((((Nat.digits p ((p ^ k - 1) * n + 1)).map Nat.factorial).prod : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  rw [← digFact_eq_digits hp.out.two_le]
  exact (fussCatalan_exact_residue_of p H k n t hk ht).2

/-- **Problem 137 by the path proof, without conventions, given the count**: `p ^ t` is the
exact power of `p` in the Fuss–Catalan number. -/
theorem problem137_fussCatalan_exact_path_of (p : ℕ) [hp : Fact p.Prime] (H : SlotHyp p)
    (k n t : ℕ) (hk : 0 < k)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) :
    p ^ t ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) ∧
      ¬ p ^ (t + 1) ∣ Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1) :=
  (fussCatalan_exact_residue_of p H k n t hk ht).1

/-- **Problem 137 by the path proof, given the count**: `(p - 1) * v_p(C) + 1 =
s_p((q - 1) n + 1)` for the Fuss–Catalan number `C = binom(q n, n) / ((q - 1) n + 1)`,
`q = p ^ k`. -/
theorem problem137_fussCatalan_path_of (p : ℕ) [hp : Fact p.Prime] (H : SlotHyp p) (k n : ℕ)
    (hk : 0 < k) :
    (p - 1) * multiplicity p (Nat.choose (p ^ k * n) n / ((p ^ k - 1) * n + 1)) + 1 =
      (Nat.digits p ((p ^ k - 1) * n + 1)).sum := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hp1 : p ≡ 1 [MOD p - 1] :=
    ((Nat.modEq_iff_dvd' (by omega : 1 ≤ p)).mpr (dvd_refl _)).symm
  have hpk : 1 ≡ p ^ k [MOD p - 1] := by
    have h := hp1.pow k
    rw [one_pow] at h
    exact h.symm
  have hdvd : p - 1 ∣ p ^ k - 1 := (Nat.modEq_iff_dvd' (Nat.one_le_pow _ _ (by omega))).mp hpk
  have hm1 : (p ^ k - 1) * n + 1 ≡ 1 [MOD p - 1] := by
    have h : (p ^ k - 1) * n + 1 ≡ 0 + 1 [MOD p - 1] :=
      (Nat.modEq_zero_iff_dvd.mpr (Dvd.dvd.mul_right hdvd n)).add_right 1
    rw [zero_add] at h
    exact h
  have hpos : 0 < ds p ((p ^ k - 1) * n + 1) := ds_pos hp2 _ (Nat.succ_pos _)
  have h1 : ds p ((p ^ k - 1) * n + 1) ≡ 1 [MOD p - 1] := (ds_modEq hp2 _).trans hm1
  obtain ⟨t, ht⟩ := (Nat.modEq_iff_dvd' (by omega : 1 ≤ ds p ((p ^ k - 1) * n + 1))).mp h1.symm
  have ht' : (p - 1) * t + 1 = ds p ((p ^ k - 1) * n + 1) := by omega
  obtain ⟨e1, e2⟩ := problem137_fussCatalan_exact_path_of p H k n t hk ht'
  rw [multiplicity_eq_of_exact e1 e2, ht']
  rfl

end MMM.Path

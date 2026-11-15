/-
Written by Kimi K3.1 Pro (AI, worker W033), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

Words made of blocks: product formula for an equivalence class, digit-sum bound,
and binomial counting. No factorial valuations are used.
-/
import MMM.Path.Count
import Mathlib.Data.Fintype.Pi

namespace MMM.Path

open MMM Polynomial

variable {p : ℕ}

/-- A word cut into top blocks of heights L. -/
def Word (p : ℕ) (L : List ℕ) : Type := (i : Fin L.length) → Blk p (L.get i)

/-- Total number of letters in a word. -/
def len (p : ℕ) (L : List ℕ) : ℕ := (L.map (fun h => p ^ h)).sum

/-- Number of letters E in a word. -/
def cntEW {p : ℕ} {L : List ℕ} (w : Word p L) : ℕ := ∑ i, cntE _ (w i)

/-- Blockwise rotation equivalence. -/
def EqvW {p : ℕ} [NeZero p] {L : List ℕ} (w w' : Word p L) : Prop :=
  ∀ i, Eqv _ (w i) (w' i)

/-- Total number of asymmetric blocks. -/
noncomputable def dW {p : ℕ} [NeZero p] {L : List ℕ} (w : Word p L) : ℕ :=
  ∑ i, d _ (w i)

instance instFintypeWord [NeZero p] (L : List ℕ) : Fintype (Word p L) :=
  inferInstanceAs (Fintype ((i : Fin L.length) → Blk p (L.get i)))

instance instFiniteWord [NeZero p] (L : List ℕ) : Finite (Word p L) := inferInstance

/-- A finite sum indexed by the positions of a list is its list sum. -/
theorem sum_fin_get {M : Type*} [AddCommMonoid M] (L : List ℕ) (f : ℕ → M) :
    ∑ i : Fin L.length, f (L.get i) = (L.map f).sum := by
  induction L with
  | nil => simp
  | cons a L ih => simp [Fin.sum_univ_succ]

/-- The generating function of the number of letters E in words. -/
theorem genfun_word [NeZero p] (L : List ℕ) :
    ∑ w : Word p L, (X : ℕ[X]) ^ cntEW w = (1 + X) ^ len p L := by
  simp only [cntEW, ← Finset.prod_pow_eq_pow_sum]
  calc
    (∑ w : Word p L, ∏ i, (X : ℕ[X]) ^ cntE _ (w i)) =
        ∏ i : Fin L.length, ∑ u : Blk p (L.get i), (X : ℕ[X]) ^ cntE _ u :=
      (Fintype.prod_sum (f := fun i (u : Blk p (L.get i)) => (X : ℕ[X]) ^ cntE _ u)).symm
    _ = ∏ i, (1 + X) ^ (p ^ L.get i) := by
      exact Finset.prod_congr rfl (fun i _ => genfun_blk (L.get i))
    _ = (1 + X) ^ len p L := by
      rw [Finset.prod_pow_eq_pow_sum, sum_fin_get, len]

/-- The number of words with `n` letters E is a binomial coefficient. -/
theorem card_cntEW [NeZero p] (L : List ℕ) (n : ℕ) :
    Nat.card {w : Word p L // cntEW w = n} = (len p L).choose n := by
  classical
  have hc := congrArg (fun f : ℕ[X] => f.coeff n) (genfun_word (p := p) L)
  rw [Polynomial.coeff_one_add_X_pow] at hc
  simp only [Nat.cast_id] at hc
  have hc' : (len p L).choose n = (Finset.univ.filter (fun w : Word p L => cntEW w = n)).card := by
    rw [← hc, Finset.card_filter, coeff_sum']
    apply Finset.sum_congr rfl
    intro w _
    by_cases hw : cntEW w = n
    · simp [hw]
    · have hw' : n ≠ cntEW w := Ne.symm hw
      simp [hw, hw']
  rw [Nat.card_eq_fintype_card]
  exact (Fintype.card_subtype (fun w : Word p L => cntEW w = n)).trans hc'.symm

/-- The word class is the product of the block classes. -/
theorem card_classW [Fact p.Prime] {L : List ℕ} (w : Word p L) :
    Nat.card {w' : Word p L // EqvW w w'} = p ^ dW w := by
  let e : {w' : Word p L // EqvW w w'} ≃
      ((i : Fin L.length) → {v : Blk p (L.get i) // Eqv _ (w i) v}) :=
    { toFun := fun w' i => ⟨w'.1 i, w'.2 i⟩
      invFun := fun v => ⟨fun i => (v i).1, fun i => (v i).2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  rw [Nat.card_congr e, Nat.card_pi, dW]
  simp_rw [card_class]
  exact Finset.prod_pow_eq_pow_sum _ _ _

/-- The complement to the letters E is the sum of the complements in the blocks. -/
theorem len_sub_cntEW [NeZero p] {L : List ℕ} (w : Word p L) :
    len p L - cntEW w = ∑ i, (p ^ L.get i - cntE _ (w i)) := by
  rw [Finset.sum_tsub_distrib _ (fun i _ => cntE_le _ (w i))]
  simp only [cntEW, len, sum_fin_get]

/-- Equivalent words have the same number of letters E. -/
theorem cntEW_eq_of_eqv [NeZero p] {L : List ℕ} {w w' : Word p L} (hw : EqvW w w') :
    cntEW w = cntEW w' :=
  Finset.sum_congr rfl (fun i _ => cntE_eq_of_eqv (hw i))

/-- The digit-sum bound for all blocks of a word. -/
theorem lower_boundW [NeZero p] (hp : 2 ≤ p) {L : List ℕ} (w : Word p L) :
    ds p (cntEW w) + ds p (len p L - cntEW w) ≤ (p - 1) * dW w + L.length := by
  rw [len_sub_cntEW]
  calc
    _ ≤ (∑ i, ds p (cntE _ (w i))) + ∑ i, ds p (p ^ L.get i - cntE _ (w i)) :=
      Nat.add_le_add (ds_sum_le hp _ _) (ds_sum_le hp _ _)
    _ = ∑ i, (ds p (cntE _ (w i)) + ds p (p ^ L.get i - cntE _ (w i))) :=
      Finset.sum_add_distrib.symm
    _ ≤ ∑ i, ((p - 1) * d _ (w i) + 1) :=
      Finset.sum_le_sum (fun i _ => lower_bound hp _ (w i))
    _ = (p - 1) * dW w + L.length := by
      simp [Finset.sum_add_distrib, ← Finset.mul_sum, dW]

end MMM.Path


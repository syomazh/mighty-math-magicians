/-
Written by Kimi K3.1 Pro (AI, worker W033), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

The generating function for the number of letters E in a block, and the resulting
binomial count. The proof uses only polynomial coefficients and finite products;
no factorial valuations or theorems about divisibility of binomial coefficients.
-/
import MMM.Path.Bound
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Polynomial.Coeff
import Mathlib.Data.Fintype.Card

namespace MMM.Path

open MMM Polynomial

variable {p : ℕ}

/-- Blocks of a fixed height form a finite type. -/
instance instFintypeBlk : ∀ (h : ℕ), Fintype (Blk p h)
  | 0 => inferInstanceAs (Fintype Bool)
  | h + 1 => by
    haveI := instFintypeBlk h
    exact inferInstanceAs (Fintype (Fin p → Blk p h))

attribute [local simp] Blk cntE

/-- Coefficients commute with a finite sum of polynomials. -/
theorem coeff_sum' {ι : Type*} (n : ℕ) (s : Finset ι) (f : ι → ℕ[X]) :
    (∑ u ∈ s, f u).coeff n = ∑ u ∈ s, (f u).coeff n := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih => simp only [Finset.sum_insert ha, coeff_add, ih]

/-- The generating function for the number of letters E. -/
theorem genfun_blk [NeZero p] : ∀ h : ℕ,
    ∑ u : Blk p h, (X : ℕ[X]) ^ cntE h u = (1 + X) ^ (p ^ h) := by
  intro h
  induction h with
  | zero =>
    rw [Fintype.sum_bool]
    simp [add_comm]
  | succ h ih =>
    simp only [← Finset.prod_pow_eq_pow_sum]
    calc
      (∑ u : Fin p → Blk p h, ∏ j, (X : ℕ[X]) ^ cntE h (u j)) =
          ∏ j : Fin p, ∑ u : Blk p h, (X : ℕ[X]) ^ cntE h u :=
        (Fintype.prod_sum (f := fun _ (u : Blk p h) => (X : ℕ[X]) ^ cntE h u)).symm
      _ = ((1 + X) ^ (p ^ h)) ^ p := by simp [ih]
      _ = (1 + X) ^ (p ^ (h + 1)) := by rw [← pow_mul, pow_succ, mul_comm]

/-- The number of blocks with `n` letters E is the corresponding binomial coefficient. -/
theorem card_cntE [NeZero p] (h n : ℕ) :
    Nat.card {u : Blk p h // cntE h u = n} = (p ^ h).choose n := by
  classical
  have hc := congrArg (fun f : ℕ[X] => f.coeff n) (genfun_blk (p := p) h)
  rw [Polynomial.coeff_one_add_X_pow] at hc
  simp only [Nat.cast_id] at hc
  have hc' : (p ^ h).choose n = (Finset.univ.filter (fun u : Blk p h => cntE h u = n)).card := by
    rw [← hc, Finset.card_filter, coeff_sum']
    apply Finset.sum_congr rfl
    intro u _
    by_cases hu : cntE h u = n
    · simp [hu]
    · have hu' : n ≠ cntE h u := Ne.symm hu
      simp [hu, hu']
  rw [Nat.card_eq_fintype_card]
  exact (Fintype.card_subtype (fun u : Blk p h => cntE h u = n)).trans hc'.symm

/-- Divisibility for one block, restated via the binomial count. -/
theorem pow_dvd_choose_pow [Fact p.Prime] (h n c : ℕ)
    (hc : ds p n + ds p (p ^ h - n) = (p - 1) * c + 1) (hn : n ≤ p ^ h) :
    p ^ c ∣ (p ^ h).choose n := by
  rw [← card_cntE h n]
  exact pow_dvd_card h n c hc hn

end MMM.Path

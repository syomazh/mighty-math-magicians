/-
Written by Kimi K3.1 Pro (AI, worker W032), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Lower bound for one block (the note's Lemma `lem:bound`).**  For `p ≥ 2`, every block `u`
  of length `p^h` satisfies

      s_p(cntE u) + s_p(p^h - cntE u) ≤ (p - 1) * d h u + 1.

The proof is by induction on `h`, exactly as `MMM/Trees.lean` (`PTree.lower_bound`), using
subadditivity of digit sums at an asymmetric block and `s(p b) = s(b)` at a symmetric block.
No factorial and no valuation is used; `p` needs not be prime.
-/
import MMM.Path.Block
import MMM.Path.ClassSize
import MMM.DigitsCarry
import MMM.Counting
import Mathlib.Data.Fintype.Pi

namespace MMM.Path

open MMM

variable {p : ℕ}

/-- **The lower bound (Lemma `lem:bound`, one block).** -/
theorem lower_bound [NeZero p] (hp : 2 ≤ p) : ∀ (h : ℕ) (u : Blk p h),
    ds p (cntE h u) + ds p (p ^ h - cntE h u) ≤ (p - 1) * d h u + 1 := by
  intro h
  induction h with
  | zero =>
    intro b
    show ds p (if b then 1 else 0) + ds p (1 - (if b then 1 else 0)) ≤ (p - 1) * 0 + 1
    cases b <;> simp [ds_one hp, ds_zero]
  | succ h ih =>
    intro u
    by_cases hs : Sym h u
    · -- symmetric block: every sub-block has the same `cntE` and the same `cntS`
      rw [d_succ_symm u hs]
      let i0 : Fin p := ⟨0, by omega⟩
      have hb : ∀ i, cntE h (u i) = cntE h (u i0) := fun i => cntE_eq_of_eqv (hs i i0)
      have hS : ∀ i, p ^ h - cntE h (u i) = p ^ h - cntE h (u i0) := fun i => by rw [hb i]
      have hsumE : cntE (h + 1) u = p * cntE h (u i0) := by
        show (∑ i, cntE h (u i)) = p * cntE h (u i0)
        rw [Finset.sum_congr rfl (fun i _ => hb i)]
        simp
      have hsumS : p ^ (h + 1) - cntE (h + 1) u = p * (p ^ h - cntE h (u i0)) := by
        rw [hsumE, pow_succ']
        have h0 : cntE h (u i0) ≤ p ^ h := cntE_le h (u i0)
        have hmul : p * cntE h (u i0) ≤ p * p ^ h := Nat.mul_le_mul_left _ h0
        rw [Nat.mul_sub]
      rw [hsumS, hsumE, ds_base_mul hp, ds_base_mul hp]
      have h0 := ih (u i0)
      have hle : d h (u i0) ≤ ∑ i, d h (u i) :=
        Finset.single_le_sum (f := fun i => d h (u i)) (fun _ _ => Nat.zero_le _)
          (Finset.mem_univ i0)
      calc ds p (cntE h (u i0)) + ds p (p ^ h - cntE h (u i0))
          ≤ (p - 1) * d h (u i0) + 1 := h0
        _ ≤ (p - 1) * (∑ i, d h (u i)) + 1 := by
            exact Nat.add_le_add_right (Nat.mul_le_mul_left _ hle) 1
    · -- asymmetric block: digit sums are subadditive
      rw [d_succ_asymm u hs]
      have hE : ds p (cntE (h + 1) u) ≤ ∑ i, ds p (cntE h (u i)) :=
        ds_sum_le hp _ _
      have hS : ds p (p ^ (h + 1) - cntE (h + 1) u) ≤ ∑ i, ds p (p ^ h - cntE h (u i)) := by
        have hsplit : p ^ (h + 1) - cntE (h + 1) u = ∑ i, (p ^ h - cntE h (u i)) := by
          have hle : ∀ i, cntE h (u i) ≤ p ^ h := fun i => cntE_le h (u i)
          have hsum : ∑ i, (p ^ h - cntE h (u i)) = p ^ (h + 1) - ∑ i, cntE h (u i) := by
            rw [Finset.sum_tsub_distrib _ (fun i _ => hle i)]
            simp [pow_succ']
          rw [hsum]
        rw [hsplit]
        exact ds_sum_le hp _ _
      calc ds p (cntE (h + 1) u) + ds p (p ^ (h + 1) - cntE (h + 1) u)
          ≤ (∑ i, ds p (cntE h (u i))) + ∑ i, ds p (p ^ h - cntE h (u i)) :=
            Nat.add_le_add hE hS
        _ = ∑ i, (ds p (cntE h (u i)) + ds p (p ^ h - cntE h (u i))) :=
            (Finset.sum_add_distrib).symm
        _ ≤ ∑ i : Fin p, ((p - 1) * d h (u i) + 1) := Finset.sum_le_sum (fun i _ => ih (u i))
        _ = (p - 1) * (∑ i, d h (u i)) + p := by
            rw [Finset.sum_add_distrib, ← Finset.mul_sum]
            simp
        _ = (p - 1) * ((∑ i, d h (u i)) + 1) + 1 := by
            have : p = (p - 1) + 1 := by omega
            rw [Nat.mul_add, Nat.mul_one]
            omega

end MMM.Path
namespace MMM.Path

variable {p : ℕ}

/-- Blocks form a finite type. -/
instance instFiniteBlk : ∀ (h : ℕ), Finite (Blk p h)
  | 0 => inferInstanceAs (Finite Bool)
  | h + 1 => by
    haveI := instFiniteBlk h
    exact inferInstanceAs (Finite (Fin p → Blk p h))

/-- **Divisibility from symmetry, for one block.** If `ds p n + ds p (p^h - n) = (p-1)*c + 1`
and `n ≤ p^h`, then `p^c` divides the number of blocks of length `p^h` with exactly `n` letters E. -/
theorem pow_dvd_card [hp : Fact p.Prime] (h n c : ℕ)
    (hc : ds p n + ds p (p ^ h - n) = (p - 1) * c + 1) (hn : n ≤ p ^ h) :
    p ^ c ∣ Nat.card {u : Blk p h // cntE h u = n} := by
  haveI : Finite (Blk p h) := instFiniteBlk h
  haveI : NeZero p := ⟨hp.out.ne_zero⟩
  let s : Setoid {u : Blk p h // cntE h u = n} :=
    ⟨fun a b => Eqv h a.1 b.1,
      ⟨fun a => Eqv.refl h a.1, fun hab => hab.symm, fun h1 h2 => h1.trans h2⟩⟩
  haveI : Fintype (Quotient s) := Fintype.ofFinite _
  have key : Nat.card {u : Blk p h // cntE h u = n} =
      ∑ cl : Quotient s, Nat.card {x : {u : Blk p h // cntE h u = n} // Quotient.mk s x = cl} := by
    rw [← Nat.card_sigma]
    exact Nat.card_congr (Equiv.sigmaFiberEquiv (Quotient.mk s)).symm
  rw [key]
  refine Finset.dvd_sum (fun cl _ => ?_)
  induction cl using Quotient.inductionOn with
  | _ u =>
    have e : {x : {u' : Blk p h // cntE h u' = n} // Quotient.mk s x = Quotient.mk s u} ≃
        {v : Blk p h // Eqv h u.1 v} :=
      { toFun := fun x => ⟨x.1.1, (Quotient.exact x.2).symm⟩
        invFun := fun v => ⟨⟨v.1, (cntE_eq_of_eqv v.2).symm.trans u.2⟩, Quotient.sound v.2.symm⟩
        left_inv := fun x => rfl
        right_inv := fun v => rfl }
    rw [Nat.card_congr e, card_class]
    refine pow_dvd_pow p ?_
    have hlb := lower_bound hp.out.two_le h u.1
    rw [u.2] at hlb
    have hcd : (p - 1) * c + 1 ≤ (p - 1) * d h u.1 + 1 := by rw [← hc]; exact hlb
    have hpos : 0 < p - 1 := by have := hp.out.two_le; omega
    exact Nat.le_of_mul_le_mul_left (by omega) hpos

end MMM.Path

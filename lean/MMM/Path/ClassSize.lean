/-
Written by Kimi K3.1 Pro (AI, worker W032), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Class size for one block:** for a prime `p`, the rotation class of a block `u` of length `p^h`
  has exactly `p ^ d h u` elements (the note's Lemma `lem:size`, restricted to one block).

Proof: at a symmetric block the class is the product of the classes of the sub-blocks; at an
asymmetric block the `p` rotations give `p` disjoint copies of that product (a non-trivial shift
that preserved the sub-blocks up to equivalence would make all sub-blocks equivalent, because `p`
is prime). This mirrors `MMM/ClassSize.lean` step by step.
-/
import MMM.Path.Block
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.GroupTheory.SpecificGroups.Cyclic.Subgroup

namespace MMM.Path

variable {p : ℕ}

section prime

variable [hp : Fact p.Prime]

instance instNeZeroOfPrimePath : NeZero p := ⟨hp.out.ne_zero⟩

/-- If a non-zero shift `s` preserves the sub-blocks up to equivalence, the block is symmetric.
This is where `p` prime is used: the shifts with this property form a subgroup of `Z/p`. -/
theorem sym_of_shift {h : ℕ} {u : Blk p (h + 1)} {s : Fin p} (hs : s ≠ 0)
    (hshift : ∀ i, Eqv h (u i) (u (i + s))) : Sym h u := by
  let H : AddSubgroup (Fin p) :=
    { carrier := {x | ∀ i, Eqv h (u i) (u (i + x))}
      zero_mem' := fun i => by simpa using Eqv.refl h (u i)
      add_mem' := fun {a b} ha hb i => by
        have h1 := (ha i).trans (hb (i + a))
        simpa [add_assoc] using h1
      neg_mem' := fun {a} ha i => by
        have h1 := (ha (i + -a)).symm
        simpa using h1 }
  have : Fact (Nat.card (Fin p)).Prime := ⟨by simpa using hp.out⟩
  have hsH : s ∈ H := hshift
  rcases AddSubgroup.eq_bot_or_eq_top_of_prime_card H with hH | hH
  · rw [hH, AddSubgroup.mem_bot] at hsH
    exact absurd hsH hs
  · intro i j
    have hmem : j - i ∈ H := by rw [hH]; exact AddSubgroup.mem_top _
    have h1 := hmem i
    simpa using h1

/-- The class of a block of positive height, described by its sub-blocks. -/
def classEquiv {h : ℕ} (u : Blk p (h + 1)) :
    {v : Blk p (h + 1) // Eqv (h + 1) v u} ≃
      {g : Fin p → Blk p h // ∃ r, ∀ i, Eqv h (g (i + r)) (u i)} where
  toFun v := ⟨v.1, Eqv_succ.mp v.2⟩
  invFun g := ⟨g.1, Eqv_succ.mpr g.2⟩
  left_inv := by
    rintro ⟨v, hv⟩
    rfl
  right_inv := by
    rintro ⟨g, hg⟩
    rfl

/-- **Class size (Lemma `lem:size`, one block).** The rotation class of `u` has exactly
`p ^ d h u` elements. -/
theorem card_class : ∀ (h : ℕ) (u : Blk p h), Nat.card {v : Blk p h // Eqv h u v} = p ^ d h u := by
  intro h
  induction h with
  | zero =>
    intro u
    have : Subsingleton {v : Blk p 0 // Eqv 0 u v} :=
      ⟨by
        rintro ⟨a, ha⟩ ⟨b, hb⟩
        have hab : a = b := (Eqv_zero.mp ha).symm.trans (Eqv_zero.mp hb)
        exact Subtype.ext hab⟩
    have : Nonempty {v : Blk p 0 // Eqv 0 u v} := ⟨⟨u, Eqv.refl 0 u⟩⟩
    simp
  | succ h ih =>
    intro u
    -- switch to the `{v // Eqv h v u}` formulation used by `classEquiv`
    have hre : Nat.card {v : Blk p (h + 1) // Eqv (h + 1) u v} =
        Nat.card {v : Blk p (h + 1) // Eqv (h + 1) v u} :=
      Nat.card_congr (Equiv.subtypeEquivRight (fun v => ⟨Eqv.symm, Eqv.symm⟩))
    rw [hre, Nat.card_congr (classEquiv u)]
    -- the product of the classes of the sub-blocks
    have hprod : Nat.card {g : Fin p → Blk p h // ∀ i, Eqv h (g i) (u i)} =
        p ^ ∑ i, d h (u i) := by
      have hih : ∀ i, Nat.card {v : Blk p h // Eqv h v (u i)} = p ^ d h (u i) := by
        intro i
        rw [Nat.card_congr (Equiv.subtypeEquivRight
          (p := fun v : Blk p h => Eqv h v (u i))
          (q := fun v : Blk p h => Eqv h (u i) v)
          (fun v => ⟨Eqv.symm, Eqv.symm⟩))]
        exact ih (u i)
      rw [Nat.card_congr (Equiv.subtypePiEquivPi (p := fun i (v : Blk p h) => Eqv h v (u i))),
        Nat.card_pi]
      simp only [hih]
      exact Finset.prod_pow_eq_pow_sum _ _ _
    by_cases hs : Sym h u
    · -- symmetric block: a shift changes nothing
      rw [d_succ_symm u hs, ← hprod]
      refine Nat.card_congr (Equiv.subtypeEquivRight (fun g => ?_))
      constructor
      · rintro ⟨r, hr⟩ i
        have h1 := hr (i - r)
        simp only [sub_add_cancel] at h1
        exact h1.trans (hs (i - r) i)
      · intro hg
        exact ⟨0, fun i => by simpa using hg i⟩
    · -- asymmetric block: p disjoint copies
      rw [d_succ_asymm u hs, pow_succ, ← hprod]
      have hcard : Nat.card (Fin p × {g : Fin p → Blk p h // ∀ i, Eqv h (g i) (u i)}) =
          p ^ (∑ i, d h (u i)) * p := by
        rw [Nat.card_prod, hprod]
        simp [mul_comm]
      rw [← hprod] at hcard
      rw [← hcard]
      symm
      let φ : Fin p × {g : Fin p → Blk p h // ∀ i, Eqv h (g i) (u i)} →
          {g : Fin p → Blk p h // ∃ r, ∀ i, Eqv h (g (i + r)) (u i)} :=
        fun x => ⟨fun i => x.2.1 (i - x.1), ⟨x.1, fun i => by simpa using x.2.2 i⟩⟩
      refine Nat.card_eq_of_bijective φ ⟨?_, ?_⟩
      · -- injective
        rintro ⟨r1, g1, h1⟩ ⟨r2, g2, h2⟩ heq
        have hfun : ∀ i, g1 (i - r1) = g2 (i - r2) := fun i => congrFun (congrArg Subtype.val heq) i
        have hr : r1 = r2 := by
          by_contra hne
          apply hs
          refine sym_of_shift (s := r1 - r2) (sub_ne_zero.mpr hne) (fun i => ?_)
          have e := hfun (i + r1)
          simp only [add_sub_cancel_right] at e
          have e' : g1 i = g2 (i + (r1 - r2)) := by
            rw [e]; congr 1; abel
          have a := (h1 i).symm
          rw [e'] at a
          exact a.trans (h2 (i + (r1 - r2)))
        subst hr
        have hg : g1 = g2 := by
          funext i
          have e := hfun (i + r1)
          simpa using e
        subst hg
        rfl
      · -- surjective
        rintro ⟨g, r, hr⟩
        refine ⟨(r, ⟨fun i => g (i + r), hr⟩), ?_⟩
        apply Subtype.ext
        funext i
        simp [φ]

end prime

end MMM.Path

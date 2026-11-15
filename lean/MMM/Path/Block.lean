/-
Written by Kimi K3.1 Pro (AI, worker W032), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

Words on one block of length `p^h` (a complete `p`-ary tree of height `h` with a letter at each
leaf), rotation equivalence `Eqv`, the number `d` of asymmetric blocks, and their basic properties:
`Eqv` is an equivalence relation, and equivalent blocks have the same number of letters E and the
same `d`.

This is the path analogue of `MMM/Trees.lean` and `MMM/RotEquiv.lean`, following the note
`guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex` (Sections 3 and 4).
No factorial and no valuation is used.

Deviation from the brief: the definitions are marked `@[reducible]` so that the type `Blk p 0`
unifies with `Bool` (needed for `if b then 1 else 0`). The statements are unchanged.
-/
import MMM.Digits
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Group.Fin.Basic
import Mathlib.Data.Fintype.BigOperators

namespace MMM.Path

/-- A word on a block of length p^h: a complete p-ary tree of height h with a letter at each leaf.
`true` is the letter E, `false` the letter S. -/
@[reducible] def Blk (p : ℕ) : ℕ → Type
  | 0 => Bool
  | h + 1 => Fin p → Blk p h

/-- Number of letters E. -/
@[reducible] def cntE {p : ℕ} : (h : ℕ) → Blk p h → ℕ
  | 0, b => if b then 1 else 0
  | h + 1, u => ∑ j, cntE h (u j)

/-- Equivalence under rotations of the p sub-blocks of any block, in normal form
(rotate at the top, then recursively inside). -/
def Eqv {p : ℕ} [NeZero p] : (h : ℕ) → Blk p h → Blk p h → Prop
  | 0, a, b => a = b
  | h + 1, u, v => ∃ r : Fin p, ∀ j, Eqv h (u (j + r)) (v j)

/-- A block of length p^(h+1) is symmetric if its p sub-blocks are equivalent to one another. -/
def Sym {p : ℕ} [NeZero p] (h : ℕ) (u : Blk p (h + 1)) : Prop := ∀ i j, Eqv h (u i) (u j)

/-- Number of asymmetric blocks inside u (u itself included). -/
noncomputable def d {p : ℕ} [NeZero p] : (h : ℕ) → Blk p h → ℕ
  | 0, _ => 0
  | h + 1, u => (∑ j, d h (u j)) + (by classical exact if Sym h u then 0 else 1)

variable {p : ℕ}

section basic

@[simp] theorem cntE_zero (b : Blk p 0) : cntE 0 b = if b then 1 else 0 := rfl

@[simp] theorem cntE_succ {h : ℕ} (u : Blk p (h + 1)) : cntE (h + 1) u = ∑ j, cntE h (u j) := rfl

variable [NeZero p]

@[simp] theorem Eqv_zero {a b : Blk p 0} : Eqv 0 a b ↔ a = b := Iff.rfl

theorem Eqv_succ {h : ℕ} {u v : Blk p (h + 1)} :
    Eqv (h + 1) u v ↔ ∃ r : Fin p, ∀ j, Eqv h (u (j + r)) (v j) := Iff.rfl

@[simp] theorem d_zero (b : Blk p 0) : d 0 b = 0 := rfl

theorem d_succ_symm {h : ℕ} (u : Blk p (h + 1)) (hs : Sym h u) :
    d (h + 1) u = ∑ j, d h (u j) := by
  simp [d, hs]

theorem d_succ_asymm {h : ℕ} (u : Blk p (h + 1)) (hs : ¬ Sym h u) :
    d (h + 1) u = (∑ j, d h (u j)) + 1 := by
  simp [d, hs]

/-- A height-0 block has at most one letter E. -/
theorem cntE_le_zero (b : Blk p 0) : cntE 0 b ≤ 1 := by
  show (if b then 1 else 0) ≤ 1
  cases b <;> simp

/-- The number of letters E is at most the total number `p^h` of letters. -/
theorem cntE_le : ∀ (h : ℕ) (u : Blk p h), cntE h u ≤ p ^ h := by
  intro h
  induction h with
  | zero => intro b; simpa using cntE_le_zero b
  | succ h ih =>
    intro u
    rw [cntE_succ, pow_succ']
    calc ∑ j, cntE h (u j) ≤ ∑ _j : Fin p, p ^ h :=
          Finset.sum_le_sum (fun j _ => ih (u j))
      _ = p * p ^ h := by simp

/-- Total letters: the number of letters S. -/
def cntS (h : ℕ) (u : Blk p h) : ℕ := p ^ h - cntE h u

omit [NeZero p] in
@[simp] theorem cntS_eq (h : ℕ) (u : Blk p h) : cntS h u = p ^ h - cntE h u := rfl

end basic

section equiv

variable [NeZero p]

theorem Eqv.refl (h : ℕ) (u : Blk p h) : Eqv h u u := by
  induction h with
  | zero => exact Eqv_zero.mpr rfl
  | succ h ih => exact Eqv_succ.mpr ⟨0, fun j => by simpa using ih (u j)⟩

theorem Eqv.symm {h : ℕ} {u v : Blk p h} (he : Eqv h u v) : Eqv h v u := by
  induction h with
  | zero => exact Eqv_zero.mpr (Eqv_zero.mp he).symm
  | succ h ih =>
    obtain ⟨r, hr⟩ := Eqv_succ.mp he
    refine Eqv_succ.mpr ⟨-r, fun j => ?_⟩
    have h1 := ih (hr (j + -r))
    simpa using h1

theorem Eqv.trans {h : ℕ} {u v w : Blk p h} (h1 : Eqv h u v) (h2 : Eqv h v w) : Eqv h u w := by
  induction h with
  | zero => exact Eqv_zero.mpr ((Eqv_zero.mp h1).trans (Eqv_zero.mp h2))
  | succ h ih =>
    obtain ⟨r, hr⟩ := Eqv_succ.mp h1
    obtain ⟨r', hr'⟩ := Eqv_succ.mp h2
    refine Eqv_succ.mpr ⟨r' + r, fun j => ?_⟩
    have h3 := ih (hr (j + r')) (hr' j)
    simpa [add_assoc] using h3

/-- Rotation equivalence as a setoid. -/
def eqvSetoid (p : ℕ) [NeZero p] (h : ℕ) : Setoid (Blk p h) where
  r := Eqv h
  iseqv := ⟨Eqv.refl h, Eqv.symm, Eqv.trans⟩

/-- Equivalent blocks have the same number of letters E. -/
theorem cntE_eq_of_eqv {h : ℕ} {u v : Blk p h} (he : Eqv h u v) : cntE h u = cntE h v := by
  induction h with
  | zero => rw [Eqv_zero.mp he]
  | succ h ih =>
    obtain ⟨r, hr⟩ := Eqv_succ.mp he
    show (∑ j, cntE h (u j)) = ∑ j, cntE h (v j)
    rw [← Finset.sum_congr rfl (fun j _ => ih (hr j))]
    exact (Fintype.sum_equiv (Equiv.addRight r) (fun j => cntE h (u (j + r)))
      (fun j => cntE h (u j)) (fun j => rfl)).symm

/-- Equivalent blocks have the same number of letters S. -/
theorem cntS_eq_of_eqv {h : ℕ} {u v : Blk p h} (he : Eqv h u v) : cntS h u = cntS h v := by
  simp only [cntS_eq, cntE_eq_of_eqv he]

/-- If the sub-blocks of two blocks correspond up to a shift, one is symmetric iff the other is. -/
theorem sym_iff_of_eqv {h : ℕ} {u v : Blk p (h + 1)} {r : Fin p}
    (hr : ∀ j, Eqv h (u (j + r)) (v j)) : Sym h u ↔ Sym h v := by
  constructor
  · intro hs i j
    exact ((hr i).symm.trans (hs (i + r) (j + r))).trans (hr j)
  · intro hv i j
    have hi := hr (i - r)
    have hj := hr (j - r)
    simp only [sub_add_cancel] at hi hj
    exact (hi.trans (hv _ _)).trans hj.symm

/-- Equivalent blocks have the same number of asymmetric blocks. -/
theorem d_eq_of_eqv {h : ℕ} {u v : Blk p h} (he : Eqv h u v) : d h u = d h v := by
  induction h with
  | zero => rfl
  | succ h ih =>
    obtain ⟨r, hr⟩ := Eqv_succ.mp he
    have hsum : ∑ j, d h (u j) = ∑ j, d h (v j) := by
      rw [← Finset.sum_congr rfl (fun j _ => ih (hr j))]
      exact (Fintype.sum_equiv (Equiv.addRight r) (fun j => d h (u (j + r)))
        (fun j => d h (u j)) (fun j => rfl)).symm
    have hsym := sym_iff_of_eqv hr
    by_cases hs : Sym h u
    · rw [d_succ_symm u hs, d_succ_symm v (hsym.mp hs), hsum]
    · rw [d_succ_asymm u hs, d_succ_asymm v (fun hv => hs (hsym.mpr hv)), hsum]

end equiv

end MMM.Path

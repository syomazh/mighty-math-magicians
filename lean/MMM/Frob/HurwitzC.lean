/-
Written by Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-14. Not human-reviewed.

The commutative ring of Hurwitz series in finitely many variables, its partial derivations
`∂/∂z_c`, and the facts about p-th powers of Lemma `lem:hur` of `paper/frobenius_proof.tex`
(the statements of brief `briefs/W037_lean_frobenius_hurwitz.md`).  It was written under brief
`briefs/W042_lean_frobenius_carry.md`, because `Hurwitz.lean` (the file of brief W037) did not
contain the derivations and the p-th powers when the work on W042 started.

A Hurwitz series is given by its integer coefficient function `a ↦ f_a` (the coefficient of
`z^a / a!`).  The product is the binomial convolution, the derivative is the shift by a unit
vector.

Provenance of the parts.  The construction of the ring in the section `Construction` (the map
`toQ` into `MvPowerSeries ι ℚ`, its injectivity and its compatibilities with the operations) is
adapted from `Hurwitz.lean`, written by Kimi K3.1 Pro on the same day; the changes are that the
operations are local instances, so that outside that section every operation on `Hur ι` comes
from the `CommRing` instance, and that the names are in the namespace `MMM.Frob.Hur`.
Everything after that section is new.

This file does not import `Hurwitz.lean`.  The two files define the same structure
`MMM.Frob.Hur` and cannot be imported together.
-/
import Mathlib.RingTheory.MvPowerSeries.Derivative
import Mathlib.Data.Finsupp.Antidiagonal
import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.Ring.InjSurj
import Mathlib.Algebra.BigOperators.Field
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

set_option linter.unusedSectionVars false

noncomputable section

namespace MMM.Frob

/-- A Hurwitz series in variables indexed by `ι`: `coeff a` is the integer coefficient of
`z^a / a!`. -/
@[ext]
structure Hur (ι : Type*) where
  coeff : (ι → ℕ) → ℤ

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- Product of binomial coefficients. -/
def mchoose (a b : ι → ℕ) : ℕ := ∏ i, (a i).choose (b i)

namespace Hur

/-! ### The construction of the ring (adapted from `Hurwitz.lean`) -/

section Construction

local instance : Zero (Hur ι) := ⟨⟨fun _ => 0⟩⟩
local instance : One (Hur ι) := ⟨⟨fun a => if a = 0 then 1 else 0⟩⟩
local instance : Add (Hur ι) := ⟨fun f g => ⟨fun a => f.coeff a + g.coeff a⟩⟩
local instance : Neg (Hur ι) := ⟨fun f => ⟨fun a => -f.coeff a⟩⟩
local instance : Sub (Hur ι) := ⟨fun f g => ⟨fun a => f.coeff a - g.coeff a⟩⟩
local instance : Mul (Hur ι) :=
  ⟨fun f g => ⟨fun a => ∑ b ∈ Fintype.piFinset (fun i => Finset.range (a i + 1)),
    (mchoose a b : ℤ) * f.coeff b * g.coeff (a - b)⟩⟩
local instance : SMul ℕ (Hur ι) := ⟨fun n f => ⟨fun a => n * f.coeff a⟩⟩
local instance : SMul ℤ (Hur ι) := ⟨fun n f => ⟨fun a => n * f.coeff a⟩⟩
local instance : Pow (Hur ι) ℕ := ⟨fun f n => npowRec n f⟩
local instance : NatCast (Hur ι) := ⟨fun n => ⟨fun a => if a = 0 then n else 0⟩⟩
local instance : IntCast (Hur ι) := ⟨fun n => ⟨fun a => if a = 0 then n else 0⟩⟩

@[local simp] theorem coeff_zero_raw (a : ι → ℕ) : (0 : Hur ι).coeff a = 0 := rfl

@[local simp] theorem coeff_one_raw (a : ι → ℕ) :
    (1 : Hur ι).coeff a = if a = 0 then 1 else 0 := rfl

@[local simp] theorem coeff_add_raw (f g : Hur ι) (a : ι → ℕ) :
    (f + g).coeff a = f.coeff a + g.coeff a := rfl

@[local simp] theorem coeff_neg_raw (f : Hur ι) (a : ι → ℕ) :
    (-f).coeff a = -f.coeff a := rfl

@[local simp] theorem coeff_sub_raw (f g : Hur ι) (a : ι → ℕ) :
    (f - g).coeff a = f.coeff a - g.coeff a := rfl

@[local simp] theorem coeff_nsmul_raw (n : ℕ) (f : Hur ι) (a : ι → ℕ) :
    (n • f).coeff a = n * f.coeff a := rfl

@[local simp] theorem coeff_zsmul_raw (n : ℤ) (f : Hur ι) (a : ι → ℕ) :
    (n • f).coeff a = n * f.coeff a := rfl

@[local simp] theorem coeff_mul_raw (f g : Hur ι) (a : ι → ℕ) :
    (f * g).coeff a = ∑ b ∈ Fintype.piFinset (fun i => Finset.range (a i + 1)),
      (mchoose a b : ℤ) * f.coeff b * g.coeff (a - b) := rfl

@[local simp] theorem coeff_natCast_raw (n : ℕ) (a : ι → ℕ) :
    ((n : Hur ι)).coeff a = if a = 0 then (n : ℤ) else 0 := rfl

@[local simp] theorem coeff_intCast_raw (n : ℤ) (a : ι → ℕ) :
    ((n : Hur ι)).coeff a = if a = 0 then n else 0 := rfl

/-- `∏ i, (a i)!`. -/
def factorialProd (a : ι → ℕ) : ℕ := ∏ i, (a i).factorial

@[simp] theorem factorialProd_zero : factorialProd (ι := ι) (fun _ => 0) = 1 := by
  simp [factorialProd]

theorem factorialProd_ne_zero (a : ι → ℕ) : factorialProd a ≠ 0 := by
  classical
  unfold factorialProd
  exact Finset.prod_ne_zero_iff.mpr (fun i _ => (a i).factorial_ne_zero)

/-- Map a Hurwitz series into `MvPowerSeries ι ℚ` by dividing each coefficient by the product
of the factorials. -/
def toQ (f : Hur ι) : MvPowerSeries ι ℚ :=
  fun α => (f.coeff (Finsupp.equivFunOnFinite α) : ℚ) /
    (factorialProd (Finsupp.equivFunOnFinite α) : ℚ)

theorem toQ_apply (f : Hur ι) (α : ι →₀ ℕ) :
    toQ f α = (f.coeff (Finsupp.equivFunOnFinite α) : ℚ) /
      (factorialProd (Finsupp.equivFunOnFinite α) : ℚ) := rfl

theorem toQ_at (f : Hur ι) (a : ι → ℕ) :
    toQ f (Finsupp.equivFunOnFinite.symm a) = (f.coeff a : ℚ) / (factorialProd a : ℚ) := by
  rw [toQ_apply, Equiv.apply_symm_apply]

theorem toQ_injective : Function.Injective (toQ : Hur ι → MvPowerSeries ι ℚ) := by
  intro f g h
  ext a
  have h' := congrFun h (Finsupp.equivFunOnFinite.symm a)
  rw [toQ_at, toQ_at] at h'
  have hden : (factorialProd a : ℚ) ≠ 0 := by
    exact_mod_cast factorialProd_ne_zero a
  have h'' := div_eq_div_iff hden hden |>.mp h'
  have hcast : ((f.coeff a : ℤ) : ℚ) = ((g.coeff a : ℤ) : ℚ) := by
    have := mul_right_cancel₀ hden h''
    exact_mod_cast this
  exact_mod_cast hcast

theorem toQ_zero : toQ (0 : Hur ι) = 0 := by
  funext α
  rw [toQ_apply, coeff_zero_raw, Int.cast_zero, zero_div]
  rfl

theorem toQ_add (f g : Hur ι) : toQ (f + g) = toQ f + toQ g := by
  funext α
  rw [toQ_apply, coeff_add_raw]
  show ((f.coeff _ + g.coeff _ : ℤ) : ℚ) / _ = toQ f α + toQ g α
  rw [toQ_apply, toQ_apply, ← add_div]
  push_cast
  ring

theorem toQ_neg (f : Hur ι) : toQ (-f) = -toQ f := by
  funext α
  rw [toQ_apply, coeff_neg_raw]
  show ((-f.coeff _ : ℤ) : ℚ) / _ = -(toQ f α)
  rw [toQ_apply, ← neg_div]
  push_cast
  ring

theorem toQ_sub (f g : Hur ι) : toQ (f - g) = toQ f - toQ g := by
  funext α
  rw [toQ_apply, coeff_sub_raw]
  show ((f.coeff _ - g.coeff _ : ℤ) : ℚ) / _ = toQ f α - toQ g α
  rw [toQ_apply, toQ_apply, ← sub_div]
  push_cast
  ring

theorem toQ_one : toQ (1 : Hur ι) = 1 := by
  funext α
  rw [toQ_apply]
  change ((if Finsupp.equivFunOnFinite α = (0 : ι → ℕ) then (1 : ℤ) else 0 : ℤ) : ℚ) /
      (factorialProd (Finsupp.equivFunOnFinite α) : ℚ)
    = (1 : MvPowerSeries ι ℚ) α
  have h_one : (1 : MvPowerSeries ι ℚ) α = if α = 0 then 1 else 0 :=
    MvPowerSeries.coeff_one (n := α)
  rw [h_one]
  by_cases hα : α = 0
  · subst hα
    have h_eq : Finsupp.equivFunOnFinite (0 : ι →₀ ℕ) = (0 : ι → ℕ) := rfl
    have h_eq' : (0 : ι → ℕ) = (fun _ => 0) := rfl
    rw [h_eq, h_eq', factorialProd_zero]
    push_cast
    simp
  · have hneq : Finsupp.equivFunOnFinite α ≠ (0 : ι → ℕ) := by
      intro heq
      apply hα
      have heq' : Finsupp.equivFunOnFinite.symm (Finsupp.equivFunOnFinite α) =
          Finsupp.equivFunOnFinite.symm (0 : ι → ℕ) := by rw [heq]
      rw [Equiv.symm_apply_apply] at heq'
      rw [heq']
      ext i
      rfl
    rw [ite_eq_right hα, ite_eq_right hneq]
    simp

/-- For `b + c = a`, `mchoose a b * b! * c! = a!`. -/
theorem factorial_factorial_choose {a b c : ι → ℕ} (h : b + c = a) :
    mchoose a b * factorialProd b * factorialProd c = factorialProd a := by
  classical
  simp only [mchoose, factorialProd, ← Finset.prod_mul_distrib]
  apply Finset.prod_congr rfl
  intro i _
  have hi : b i + c i = a i := congrFun h i
  have hle : b i ≤ a i := by omega
  have hi_result : (a i).choose (b i) * (b i).factorial * (c i).factorial = (a i).factorial := by
    have h := Nat.choose_mul_factorial_mul_factorial hle
    have hc : c i = a i - b i := by omega
    rw [hc, h]
  simpa [mul_assoc] using hi_result

/-- Reindexing a sum over an antidiagonal of `ι →₀ ℕ` as a sum over a box. -/
theorem antidiagonal_sum_eq_piFinset_sum {M : Type*} [AddCommMonoid M]
    (α : ι →₀ ℕ) (T : (ι →₀ ℕ) → (ι →₀ ℕ) → M) :
    ∑ p ∈ Finset.antidiagonal α, T p.1 p.2
      = ∑ b ∈ Fintype.piFinset (fun i => Finset.range ((Finsupp.equivFunOnFinite α) i + 1)),
          T (Finsupp.equivFunOnFinite.symm b)
            (Finsupp.equivFunOnFinite.symm ((Finsupp.equivFunOnFinite α) - b)) := by
  classical
  refine Finset.sum_bij (s := Finset.antidiagonal α)
    (t := Fintype.piFinset (fun i => Finset.range ((Finsupp.equivFunOnFinite α) i + 1)))
    (i := fun p _ => Finsupp.equivFunOnFinite p.1) ?_ ?_ ?_ ?_
  · intro p hp
    rw [Finset.mem_antidiagonal] at hp
    obtain ⟨β, γ⟩ := p
    rw [Fintype.mem_piFinset]
    intro i
    rw [Finset.mem_range]
    have hi : (β + γ) i = α i := by rw [hp]
    simp only [Finsupp.add_apply] at hi
    change (Finsupp.equivFunOnFinite β) i + 1 ≤ (Finsupp.equivFunOnFinite α) i + 1
    have hi' : (Finsupp.equivFunOnFinite β) i + (Finsupp.equivFunOnFinite γ) i =
        (Finsupp.equivFunOnFinite α) i := hi
    omega
  · intro p hp q hq heq
    rw [Finset.mem_antidiagonal] at hp
    rw [Finset.mem_antidiagonal] at hq
    obtain ⟨β1, γ1⟩ := p
    obtain ⟨β2, γ2⟩ := q
    simp only at heq
    have hβ : β1 = β2 := Finsupp.equivFunOnFinite.injective heq
    have hγ : γ1 = γ2 := by
      have h2 : β1 + γ1 = α := hp
      have h2' : β2 + γ2 = α := hq
      have : β1 + γ2 = α := hβ ▸ h2'
      exact add_left_cancel (h2.trans this.symm)
    rw [hβ, hγ]
  · intro b hb
    have hb_le : ∀ i, b i ≤ (Finsupp.equivFunOnFinite α) i := by
      intro i
      have := (Fintype.mem_piFinset).mp hb i
      simp only [Finset.mem_range] at this
      omega
    refine ⟨(Finsupp.equivFunOnFinite.symm b, Finsupp.equivFunOnFinite.symm
      ((Finsupp.equivFunOnFinite α) - b)), ?_, rfl⟩
    rw [Finset.mem_antidiagonal]
    ext i
    simp only [Finsupp.add_apply]
    change b i + ((Finsupp.equivFunOnFinite α) i - b i) = (Finsupp.equivFunOnFinite α) i
    have := hb_le i
    omega
  · intro p hp
    obtain ⟨β, γ⟩ := p
    rw [Finset.mem_antidiagonal] at hp
    simp only
    rw [Equiv.symm_apply_apply]
    have hαγ : (Finsupp.equivFunOnFinite α) - (Finsupp.equivFunOnFinite β) =
        Finsupp.equivFunOnFinite γ := by
      funext i
      have hi : (β + γ) i = α i := by rw [hp]
      simp only [Finsupp.add_apply] at hi
      have hi' : (Finsupp.equivFunOnFinite β) i + (Finsupp.equivFunOnFinite γ) i =
          (Finsupp.equivFunOnFinite α) i := hi
      show (Finsupp.equivFunOnFinite α) i - (Finsupp.equivFunOnFinite β) i =
          (Finsupp.equivFunOnFinite γ) i
      omega
    rw [hαγ, Equiv.symm_apply_apply]

/-- `toQ` respects multiplication. -/
theorem toQ_mul (f g : Hur ι) : toQ (f * g) = toQ f * toQ g := by
  classical
  funext α
  set a : ι → ℕ := Finsupp.equivFunOnFinite α with ha
  show ((f * g).coeff a : ℚ) / (factorialProd a : ℚ) = (toQ f * toQ g) α
  rw [coeff_mul_raw]
  push_cast
  rw [Finset.sum_div]
  have hLHS : ∑ b ∈ Fintype.piFinset (fun i => Finset.range (a i + 1)),
        (mchoose a b : ℚ) * (f.coeff b : ℚ) * (g.coeff (a - b) : ℚ) / (factorialProd a : ℚ)
      = ∑ b ∈ Fintype.piFinset (fun i => Finset.range (a i + 1)),
          (f.coeff b : ℚ) / factorialProd b *
            ((g.coeff (a - b) : ℚ) / factorialProd (a - b)) := by
    apply Finset.sum_congr rfl
    intro b hb
    have hb_le : ∀ i, b i ≤ a i := by
      intro i
      have := (Fintype.mem_piFinset).mp hb i
      simp only [Finset.mem_range] at this
      omega
    have hbadd : b + (a - b) = a := by
      funext i
      simp only [Pi.add_apply, Pi.sub_apply]
      have := hb_le i
      omega
    have hfact : mchoose a b * factorialProd b * factorialProd (a - b) = factorialProd a :=
      factorial_factorial_choose hbadd
    have hfa : (factorialProd a : ℚ) =
        (mchoose a b : ℚ) * (factorialProd b : ℚ) * (factorialProd (a - b) : ℚ) := by
      have : ((mchoose a b * factorialProd b * factorialProd (a - b) : ℕ) : ℚ) =
          (factorialProd a : ℚ) := by
        exact_mod_cast hfact
      push_cast at this
      linarith
    have hb_ne : (factorialProd b : ℚ) ≠ 0 := by exact_mod_cast factorialProd_ne_zero b
    have hcb_ne : (factorialProd (a - b) : ℚ) ≠ 0 := by
      exact_mod_cast factorialProd_ne_zero (a - b)
    have hmc : (mchoose a b : ℚ) =
        (factorialProd a : ℚ) / ((factorialProd b : ℚ) * (factorialProd (a - b) : ℚ)) := by
      rw [hfa]
      field_simp
    rw [hmc]
    have ha_ne : (factorialProd a : ℚ) ≠ 0 := by exact_mod_cast factorialProd_ne_zero a
    field_simp
  rw [hLHS]
  have hmul : (toQ f * toQ g) α =
      ∑ p ∈ Finset.antidiagonal α, toQ f p.1 * toQ g p.2 := by
    exact MvPowerSeries.coeff_mul (n := α) (φ := toQ f) (ψ := toQ g)
  rw [hmul]
  rw [antidiagonal_sum_eq_piFinset_sum α (fun β γ => toQ f β * toQ g γ)]
  apply Finset.sum_congr rfl
  intro b _
  have h1 : toQ f (Finsupp.equivFunOnFinite.symm b) = (f.coeff b : ℚ) / factorialProd b :=
    toQ_at f b
  have h2 : toQ g (Finsupp.equivFunOnFinite.symm (a - b)) =
      (g.coeff (a - b) : ℚ) / factorialProd (a - b) := toQ_at g (a - b)
  rw [h1, h2]

theorem toQ_nsmul (n : ℕ) (f : Hur ι) : toQ (n • f) = n • toQ f := by
  induction n with
  | zero =>
    have h : ((0 : ℕ) • f) = (0 : Hur ι) := by ext a; simp [coeff_nsmul_raw]
    rw [h, toQ_zero, zero_smul]
  | succ n ih =>
    have h : ((n + 1 : ℕ) • f) = (n • f) + f := by
      ext a
      simp [coeff_nsmul_raw, coeff_add_raw]
      ring
    rw [h, toQ_add, ih, succ_nsmul]

theorem toQ_natCast (n : ℕ) : toQ ((n : Hur ι)) = (n : MvPowerSeries ι ℚ) := by
  induction n with
  | zero =>
    have h : ((0 : ℕ) : Hur ι) = 0 := by ext a; simp [coeff_natCast_raw]
    rw [h, toQ_zero]
    norm_cast
  | succ n ih =>
    have h : ((n + 1 : ℕ) : Hur ι) = (n : Hur ι) + 1 := by
      ext a
      simp [coeff_natCast_raw, coeff_add_raw]
      split_ifs
      · ring
      · rfl
    rw [h, toQ_add, toQ_one, ih]
    norm_cast

theorem toQ_pow (f : Hur ι) (n : ℕ) : toQ (f ^ n) = (toQ f) ^ n := by
  induction n with
  | zero => exact toQ_one
  | succ n ih =>
    change toQ (npowRec (n + 1) f) = (toQ f) ^ (n + 1)
    rw [npowRec.eq_def, toQ_mul]
    have ihp : toQ (npowRec n f) = (toQ f) ^ n := ih
    rw [ihp, pow_succ]

theorem toQ_intCast (n : ℤ) : toQ ((n : Hur ι)) = (n : MvPowerSeries ι ℚ) := by
  cases n with
  | ofNat n =>
    change toQ ((n : Hur ι)) = (n : MvPowerSeries ι ℚ)
    exact toQ_natCast n
  | negSucc n =>
    have h : ((Int.negSucc n : ℤ) : Hur ι) = -((n + 1 : ℕ) : Hur ι) := by
      ext a
      simp [coeff_intCast_raw, coeff_neg_raw, coeff_natCast_raw, Int.negSucc_eq]
      split_ifs
      · ring
      · rfl
    rw [h, toQ_neg, toQ_natCast]
    push_cast
    rfl

theorem toQ_zsmul (n : ℤ) (f : Hur ι) : toQ (n • f) = n • toQ f := by
  funext a
  change ((n • f).coeff (Finsupp.equivFunOnFinite a) : ℚ) /
    (factorialProd (Finsupp.equivFunOnFinite a) : ℚ) =
    (MvPowerSeries.coeff a) (n • toQ f)
  rw [coeff_zsmul_raw]
  push_cast
  rw [mul_div_assoc]
  rw [map_zsmul]
  convert (Int.cast_smul_eq_zsmul ℚ n ((toQ f) a)).symm using 2 <;> rfl

/-- The ring of Hurwitz series: transported along `toQ` from the power series over `ℚ`. -/
instance instCommRing : CommRing (Hur ι) :=
  Function.Injective.commRing toQ toQ_injective toQ_zero toQ_one toQ_add toQ_mul
    toQ_neg toQ_sub toQ_nsmul toQ_zsmul toQ_pow toQ_natCast toQ_intCast

end Construction

/-! From here on every operation on `Hur ι` is the one of the `CommRing` instance. -/

theorem toQ_add' (f g : Hur ι) : toQ (f + g) = toQ f + toQ g := toQ_add f g

theorem toQ_mul' (f g : Hur ι) : toQ (f * g) = toQ f * toQ g := toQ_mul f g

end Hur

open Hur

/-! ### Target 1: the coefficients of the ring operations -/

theorem coeff_zero' (a : ι → ℕ) : (0 : Hur ι).coeff a = 0 := rfl

theorem coeff_one' (a : ι → ℕ) : (1 : Hur ι).coeff a = if a = 0 then 1 else 0 := rfl

theorem coeff_add' (f g : Hur ι) (a : ι → ℕ) : (f + g).coeff a = f.coeff a + g.coeff a := rfl

theorem coeff_neg' (f : Hur ι) (a : ι → ℕ) : (-f).coeff a = -f.coeff a := rfl

theorem coeff_sub' (f g : Hur ι) (a : ι → ℕ) : (f - g).coeff a = f.coeff a - g.coeff a := rfl

theorem coeff_nsmul' (n : ℕ) (f : Hur ι) (a : ι → ℕ) : (n • f).coeff a = n * f.coeff a := rfl

theorem coeff_mul' (f g : Hur ι) (a : ι → ℕ) :
    (f * g).coeff a = ∑ b ∈ Fintype.piFinset (fun i => Finset.range (a i + 1)),
      (mchoose a b : ℤ) * f.coeff b * g.coeff (a - b) := rfl

/-! ### Target 2: the constant term and the variables -/

/-- The box of the multi-indices below `0` is `{0}`. -/
theorem box_zero :
    Fintype.piFinset (fun i : ι => Finset.range ((0 : ι → ℕ) i + 1)) = {0} := by
  ext b
  simp only [Fintype.mem_piFinset, Pi.zero_apply, zero_add, Finset.range_one,
    Finset.mem_singleton]
  exact ⟨fun h => funext h, fun h i => by rw [h]; rfl⟩

/-- The constant coefficient, as a ring homomorphism. -/
def constCoeff : Hur ι →+* ℤ where
  toFun f := f.coeff 0
  map_one' := by rw [coeff_one', ite_eq_left rfl]
  map_mul' f g := by
    have h0 : (0 : ι → ℕ) - 0 = 0 := by funext i; rfl
    rw [coeff_mul', box_zero, Finset.sum_singleton, h0]
    simp [mchoose]
  map_zero' := rfl
  map_add' f g := rfl

theorem constCoeff_apply (f : Hur ι) : constCoeff f = f.coeff 0 := rfl

/-- The variable `z_c`. -/
def var (c : ι) : Hur ι := ⟨fun a => if a = Pi.single c 1 then 1 else 0⟩

theorem coeff_var (c : ι) (a : ι → ℕ) :
    (var c).coeff a = if a = Pi.single c 1 then 1 else 0 := rfl

theorem coeff_pow_zero (f : Hur ι) (n : ℕ) : (f ^ n).coeff 0 = (f.coeff 0) ^ n :=
  map_pow constCoeff f n

/-! ### Target 3: the derivations -/

/-- `∂/∂z_c`: on coefficients it is the shift by the unit vector `e_c`. -/
def der (c : ι) (f : Hur ι) : Hur ι := ⟨fun a => f.coeff (a + Pi.single c 1)⟩

theorem coeff_der (c : ι) (f : Hur ι) (a : ι → ℕ) :
    (der c f).coeff a = f.coeff (a + Pi.single c 1) := rfl

namespace Hur

theorem factorialProd_add_single (a : ι → ℕ) (c : ι) :
    factorialProd (a + Pi.single c 1) = factorialProd a * (a c + 1) := by
  unfold factorialProd
  rw [← Finset.mul_prod_erase Finset.univ _ (Finset.mem_univ c),
    ← Finset.mul_prod_erase Finset.univ (fun i => (a i).factorial) (Finset.mem_univ c)]
  have h : ∀ i ∈ Finset.univ.erase c,
      ((a + Pi.single c 1 : ι → ℕ) i).factorial = (a i).factorial := by
    intro i hi
    rw [Pi.add_apply, Pi.single_eq_of_ne (Finset.ne_of_mem_erase hi), add_zero]
  rw [Finset.prod_congr rfl h, Pi.add_apply, Pi.single_eq_same, Nat.factorial_succ]
  ring

/-- Through `toQ` the shift of the coefficients is the partial derivative of power series. -/
theorem toQ_der (c : ι) (f : Hur ι) : toQ (der c f) = MvPowerSeries.pderiv c (toQ f) := by
  funext α
  have h1 : (MvPowerSeries.pderiv c (toQ f)) α =
      toQ f (α + Finsupp.single c 1) * ((α c : ℚ) + 1) :=
    MvPowerSeries.coeff_pderiv (toQ f) α
  have h2 : (Finsupp.equivFunOnFinite (α + Finsupp.single c 1) : ι → ℕ) =
      Finsupp.equivFunOnFinite α + Pi.single c 1 := by
    funext i
    show α i + Finsupp.single c 1 i = α i + (Pi.single c 1 : ι → ℕ) i
    rw [Finsupp.single_apply, Pi.single_apply]
    simp only [eq_comm]
  rw [h1, toQ_apply, toQ_apply, h2, factorialProd_add_single, coeff_der]
  have hden : (factorialProd (Finsupp.equivFunOnFinite α) : ℚ) ≠ 0 := by
    exact_mod_cast factorialProd_ne_zero _
  have hac : ((Finsupp.equivFunOnFinite α) c : ℚ) + 1 ≠ 0 := by positivity
  have hαc : (Finsupp.equivFunOnFinite α) c = α c := rfl
  rw [← hαc]
  push_cast
  field_simp

end Hur

theorem der_add (c : ι) (f g : Hur ι) : der c (f + g) = der c f + der c g := rfl

theorem der_mul (c : ι) (f g : Hur ι) : der c (f * g) = der c f * g + f * der c g := by
  apply toQ_injective
  rw [toQ_der, toQ_mul', toQ_add', toQ_mul', toQ_mul', toQ_der, toQ_der, Derivation.leibniz]
  simp only [smul_eq_mul]
  ring

theorem der_one (c : ι) : der c (1 : Hur ι) = 0 := by
  ext a
  rw [coeff_der, coeff_one', coeff_zero', ite_eq_right]
  intro h
  have h' := congrFun h c
  simp at h'

theorem der_zero (c : ι) : der c (0 : Hur ι) = 0 := rfl

theorem der_nsmul (c : ι) (n : ℕ) (f : Hur ι) : der c (n • f) = n • der c f := rfl

theorem der_comm (c c' : ι) (f : Hur ι) : der c (der c' f) = der c' (der c f) := by
  ext a
  rw [coeff_der, coeff_der, coeff_der, coeff_der, add_right_comm]

theorem der_var (c c' : ι) : der c (var c') = if c = c' then 1 else 0 := by
  ext a
  rw [coeff_der, coeff_var]
  by_cases h : c = c'
  · subst h
    rw [ite_eq_left rfl, coeff_one']
    by_cases ha : a = 0
    · subst ha
      simp
    · rw [ite_eq_right ha, ite_eq_right]
      intro h2
      apply ha
      funext i
      have h3 := congrFun h2 i
      simp only [Pi.add_apply] at h3
      simpa using h3
  · rw [ite_eq_right h, coeff_zero', ite_eq_right]
    intro h2
    have h3 := congrFun h2 c
    simp [Pi.single_eq_of_ne h] at h3

theorem der_pow_succ (c : ι) (f : Hur ι) (n : ℕ) :
    der c (f ^ (n + 1)) = (n + 1) • (f ^ n * der c f) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [pow_succ, der_mul, ih]
    simp only [nsmul_eq_mul]
    push_cast
    ring

/-- `der_pow_succ` for an exponent that is known to be positive. -/
theorem der_pow_pos (c : ι) (f : Hur ι) {n : ℕ} (hn : 0 < n) :
    der c (f ^ n) = n • (f ^ (n - 1) * der c f) := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
  rw [der_pow_succ, Nat.add_sub_cancel]

theorem coeff_eq_der (f : Hur ι) (a : ι → ℕ) (c : ι) (hc : 0 < a c) :
    f.coeff a = (der c f).coeff (a - Pi.single c 1) := by
  rw [coeff_der]
  congr 1
  funext i
  simp only [Pi.add_apply, Pi.sub_apply]
  by_cases h : i = c
  · subst h
    rw [Pi.single_eq_same]
    omega
  · rw [Pi.single_eq_of_ne h]
    omega

/-! ### Target 4: p-th powers -/

theorem dvd_coeff_pow_prime {p : ℕ} [Fact p.Prime] (f : Hur ι) (a : ι → ℕ) (ha : a ≠ 0) :
    (p : ℤ) ∣ (f ^ p).coeff a := by
  have hp : p.Prime := Fact.out
  obtain ⟨c, hc⟩ := Function.ne_iff.mp ha
  have hc' : 0 < a c := Nat.pos_of_ne_zero hc
  rw [coeff_eq_der _ a c hc', der_pow_pos c f hp.pos, coeff_nsmul']
  exact dvd_mul_right _ _

theorem coeff_pow_prime_modEq {p : ℕ} [Fact p.Prime] (f : Hur ι) (a : ι → ℕ) :
    (f ^ p).coeff a ≡ (if a = 0 then f.coeff 0 else 0) [ZMOD p] := by
  by_cases ha : a = 0
  · subst ha
    rw [ite_eq_left rfl, coeff_pow_zero]
    exact Int.ModEq.pow_prime_eq_self Fact.out _
  · rw [ite_eq_right ha]
    exact Int.modEq_zero_iff_dvd.mpr (dvd_coeff_pow_prime f a ha)

/-- For `f` without constant term, `f ^ p / p`. -/
def divPow (p : ℕ) [Fact p.Prime] (f : Hur ι) : Hur ι := ⟨fun a => (f ^ p).coeff a / p⟩

theorem coeff_divPow (p : ℕ) [Fact p.Prime] (f : Hur ι) (a : ι → ℕ) :
    (divPow p f).coeff a = (f ^ p).coeff a / p := rfl

theorem divPow_spec {p : ℕ} [Fact p.Prime] (f : Hur ι) (hf : f.coeff 0 = 0) :
    p • divPow p f = f ^ p := by
  have hp : p.Prime := Fact.out
  ext a
  rw [coeff_nsmul', coeff_divPow]
  apply Int.mul_ediv_cancel'
  by_cases ha : a = 0
  · subst ha
    rw [coeff_pow_zero, hf, zero_pow hp.ne_zero]
    exact dvd_zero _
  · exact dvd_coeff_pow_prime f a ha

theorem divPow_coeff_zero {p : ℕ} [Fact p.Prime] (f : Hur ι) (hf : f.coeff 0 = 0) :
    (divPow p f).coeff 0 = 0 := by
  have hp : p.Prime := Fact.out
  rw [coeff_divPow, coeff_pow_zero, hf, zero_pow hp.ne_zero, Int.zero_ediv]

theorem nsmul_left_cancel_hur {n : ℕ} (hn : n ≠ 0) {f g : Hur ι} : n • f = n • g → f = g := by
  intro h
  ext a
  have h' : (n • f).coeff a = (n • g).coeff a := by rw [h]
  rw [coeff_nsmul', coeff_nsmul'] at h'
  exact mul_left_cancel₀ (Nat.cast_ne_zero.mpr hn) h'

theorem der_divPow {p : ℕ} [Fact p.Prime] (c : ι) (f : Hur ι) (hf : f.coeff 0 = 0) :
    der c (divPow p f) = f ^ (p - 1) * der c f := by
  have hp : p.Prime := Fact.out
  apply nsmul_left_cancel_hur hp.ne_zero
  rw [← der_nsmul, divPow_spec f hf, der_pow_pos c f hp.pos]

end MMM.Frob

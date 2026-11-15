/-
Written by Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-14. Not human-reviewed.

Lemma `lem:H` of `paper/frobenius_proof.tex` (brief `briefs/W042_lean_frobenius_carry.md`,
part 1): the unique family of Hurwitz series `H_δ`, `δ ∈ ZMod k`, without constant terms, with

  `H_δ = z_(-δ) + H_(δ+1)^p / p`,

and its coefficients `T_δ(a)`.  The ring of Hurwitz series is the one of `HurwitzC.lean`.

Method.  `Hur.VanishBelow N f` says that all coefficients of `f` of total degree `< N` vanish.
A product of a series vanishing below `M` and a series vanishing below `N` vanishes below
`M + N`.  From `f ^ p - g ^ p = (f - g) * ∑ i < p, f ^ i * g ^ (p - 1 - i)` it follows that
`divPow p` gains one degree of agreement between two series without constant term
(`Hur.divPow_sub_divPow`).  Existence: the iterates `Hiter` of the right-hand side, starting
from `0`, stabilise coefficient by coefficient.  Uniqueness: the same lemma and induction on the
degree.
-/
import MMM.Frob.HurwitzC
import Mathlib.Algebra.Ring.GeomSum
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.Abel

set_option linter.unusedSectionVars false

noncomputable section

namespace MMM.Frob

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

namespace Hur

/-! ### Series without terms of low degree -/

/-- All coefficients of `f` at multi-indices of total degree `< N` vanish. -/
def VanishBelow (N : ℕ) (f : Hur ι) : Prop := ∀ b : ι → ℕ, ∑ i, b i < N → f.coeff b = 0

theorem VanishBelow.mono {M N : ℕ} (h : M ≤ N) {f : Hur ι} (hf : VanishBelow N f) :
    VanishBelow M f :=
  fun b hb => hf b (lt_of_lt_of_le hb h)

theorem vanishBelow_zero_left (f : Hur ι) : VanishBelow 0 f :=
  fun _ hb => absurd hb (Nat.not_lt_zero _)

theorem vanishBelow_zero (N : ℕ) : VanishBelow N (0 : Hur ι) := fun _ _ => rfl

theorem VanishBelow.add {N : ℕ} {f g : Hur ι} (hf : VanishBelow N f) (hg : VanishBelow N g) :
    VanishBelow N (f + g) := by
  intro b hb
  rw [coeff_add', hf b hb, hg b hb, add_zero]

/-- A multi-index of total degree `0` is `0`. -/
theorem eq_zero_of_sum_lt_one {b : ι → ℕ} (hb : ∑ i, b i < 1) : b = 0 := by
  funext i
  have h : b i ≤ ∑ j, b j :=
    Finset.single_le_sum (f := b) (fun _ _ => Nat.zero_le _) (Finset.mem_univ i)
  simp only [Pi.zero_apply]
  omega

theorem vanishBelow_one_iff {f : Hur ι} : VanishBelow 1 f ↔ f.coeff 0 = 0 := by
  constructor
  · intro h
    exact h 0 (by simp)
  · intro h b hb
    rw [eq_zero_of_sum_lt_one hb, h]

/-- The degrees below which two series vanish add up in their product. -/
theorem VanishBelow.mul {M N : ℕ} {f g : Hur ι} (hf : VanishBelow M f) (hg : VanishBelow N g) :
    VanishBelow (M + N) (f * g) := by
  intro b hb
  rw [coeff_mul']
  apply Finset.sum_eq_zero
  intro b' hb'
  have hle : ∀ i, b' i ≤ b i := by
    intro i
    have h := Fintype.mem_piFinset.mp hb' i
    rw [Finset.mem_range] at h
    omega
  have hsum : ∑ i, b' i + ∑ i, (b - b') i = ∑ i, b i := by
    rw [← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun i _ => ?_
    have h := hle i
    simp only [Pi.sub_apply]
    omega
  by_cases h1 : ∑ i, b' i < M
  · rw [hf b' h1, mul_zero, zero_mul]
  · rw [hg (b - b') (by omega), mul_zero]

/-- The `n`-th power of a series without constant term vanishes below `n`. -/
theorem VanishBelow.pow {f : Hur ι} (hf : VanishBelow 1 f) (n : ℕ) : VanishBelow n (f ^ n) := by
  induction n with
  | zero => exact vanishBelow_zero_left _
  | succ n ih =>
    rw [pow_succ]
    exact ih.mul hf

theorem VanishBelow.of_nsmul {n N : ℕ} (hn : n ≠ 0) {f : Hur ι} (h : VanishBelow N (n • f)) :
    VanishBelow N f := by
  intro b hb
  have h' := h b hb
  rw [coeff_nsmul'] at h'
  exact (mul_eq_zero.mp h').resolve_left (Nat.cast_ne_zero.mpr hn)

/-- For `f` without constant term, `f ^ p / p` has no terms of degree `< p`. -/
theorem divPow_vanishBelow {p : ℕ} [Fact p.Prime] {f : Hur ι} (hf : f.coeff 0 = 0) :
    VanishBelow p (divPow p f) := by
  have hp : p.Prime := Fact.out
  apply VanishBelow.of_nsmul hp.ne_zero
  rw [divPow_spec f hf]
  exact (vanishBelow_one_iff.mpr hf).pow p

/-- The key lemma: if two series without constant term agree in all degrees `< N`, then their
p-th powers divided by `p` agree in all degrees `≤ N`. -/
theorem divPow_sub_divPow {p : ℕ} [Fact p.Prime] {N : ℕ} {f g : Hur ι} (hf : f.coeff 0 = 0)
    (hg : g.coeff 0 = 0) (h : VanishBelow N (f - g)) :
    VanishBelow (N + 1) (divPow p f - divPow p g) := by
  have hp : p.Prime := Fact.out
  apply VanishBelow.of_nsmul hp.ne_zero
  rw [smul_sub, divPow_spec f hf, divPow_spec g hg, ← (Commute.all f g).mul_geom_sum₂]
  apply h.mul
  rw [vanishBelow_one_iff, ← constCoeff_apply, map_sum]
  apply Finset.sum_eq_zero
  intro i hi
  rw [map_mul, map_pow, map_pow, constCoeff_apply, constCoeff_apply, hf, hg]
  have hi' := Finset.mem_range.mp hi
  have h2 := hp.two_le
  by_cases h0 : i = 0
  · rw [zero_pow (by omega : p - 1 - i ≠ 0), mul_zero]
  · rw [zero_pow h0, zero_mul]

theorem coeff_var_zero (c : ι) : (var c).coeff 0 = 0 := by
  rw [coeff_var, ite_eq_right]
  intro h
  have h' := congrFun h c
  simp at h'

theorem sum_single_one (c : ι) : ∑ i, (Pi.single c 1 : ι → ℕ) i = 1 := by
  simp [Pi.single_apply]

end Hur

open Hur

/-! ### Existence: the iterates of the right-hand side -/

section Family

variable (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k]

/-- The `n`-th iterate of the right-hand side of the equation of Lemma "H", starting from 0. -/
def Hiter : ℕ → ZMod k → Hur (ZMod k)
  | 0 => fun _ => 0
  | n + 1 => fun δ => var (-δ) + divPow p (Hiter n (δ + 1))

theorem Hiter_zero (δ : ZMod k) : Hiter p k 0 δ = 0 := rfl

theorem Hiter_succ (n : ℕ) (δ : ZMod k) :
    Hiter p k (n + 1) δ = var (-δ) + divPow p (Hiter p k n (δ + 1)) := rfl

theorem Hiter_coeff_zero (n : ℕ) (δ : ZMod k) : (Hiter p k n δ).coeff 0 = 0 := by
  induction n generalizing δ with
  | zero => rfl
  | succ n ih =>
    rw [Hiter_succ, coeff_add', coeff_var_zero, divPow_coeff_zero _ (ih (δ + 1)), add_zero]

/-- Two consecutive iterates agree in all degrees `≤ n`. -/
theorem Hiter_succ_sub (n : ℕ) (δ : ZMod k) :
    VanishBelow (n + 1) (Hiter p k (n + 1) δ - Hiter p k n δ) := by
  induction n generalizing δ with
  | zero =>
    rw [vanishBelow_one_iff, coeff_sub', Hiter_coeff_zero, Hiter_coeff_zero, sub_zero]
  | succ n ih =>
    have h : Hiter p k (n + 1 + 1) δ - Hiter p k (n + 1) δ =
        divPow p (Hiter p k (n + 1) (δ + 1)) - divPow p (Hiter p k n (δ + 1)) := by
      rw [Hiter_succ p k (n + 1) δ, Hiter_succ p k n δ]
      abel
    rw [h]
    exact divPow_sub_divPow (Hiter_coeff_zero p k _ _) (Hiter_coeff_zero p k _ _) (ih (δ + 1))

/-- The iterates from the `n`-th on agree in all degrees `≤ n`. -/
theorem Hiter_sub_of_le {n m : ℕ} (h : n ≤ m) (δ : ZMod k) :
    VanishBelow (n + 1) (Hiter p k m δ - Hiter p k n δ) := by
  induction m, h using Nat.le_induction with
  | base =>
    rw [sub_self]
    exact vanishBelow_zero _
  | succ m hm ih =>
    have h' : Hiter p k (m + 1) δ - Hiter p k n δ =
        (Hiter p k (m + 1) δ - Hiter p k m δ) + (Hiter p k m δ - Hiter p k n δ) := by abel
    rw [h']
    exact ((Hiter_succ_sub p k m δ).mono (by omega)).add ih

/-- The coefficient at `a` of the `n`-th iterate no longer changes once `n` is at least the
total degree of `a`. -/
theorem Hiter_coeff_stable {n : ℕ} (a : ZMod k → ℕ) (h : ∑ i, a i ≤ n) (δ : ZMod k) :
    (Hiter p k n δ).coeff a = (Hiter p k (∑ i, a i) δ).coeff a := by
  have h' := Hiter_sub_of_le p k h δ a (Nat.lt_succ_self _)
  rwa [coeff_sub', sub_eq_zero] at h'

/-- The family `H_δ` of Lemma "H": the coefficientwise limit of the iterates. -/
def Hfam : ZMod k → Hur (ZMod k) :=
  fun δ => ⟨fun a => (Hiter p k (∑ i, a i) δ).coeff a⟩

theorem Hfam_coeff (δ : ZMod k) (a : ZMod k → ℕ) :
    (Hfam p k δ).coeff a = (Hiter p k (∑ i, a i) δ).coeff a := rfl

variable {p k}

theorem Hfam_coeff_zero (δ : ZMod k) : (Hfam p k δ).coeff 0 = 0 := by
  rw [Hfam_coeff]
  exact Hiter_coeff_zero p k _ δ

/-- The limit agrees with the `n`-th iterate in all degrees `≤ n`. -/
theorem Hfam_sub_Hiter (n : ℕ) (δ : ZMod k) :
    VanishBelow (n + 1) (Hfam p k δ - Hiter p k n δ) := by
  intro b hb
  rw [coeff_sub', Hfam_coeff, ← Hiter_coeff_stable p k (n := n) b (by omega) δ, sub_self]

theorem Hfam_eq (δ : ZMod k) : Hfam p k δ = var (-δ) + divPow p (Hfam p k (δ + 1)) := by
  ext a
  have h1 : (Hfam p k δ).coeff a = (Hiter p k (∑ i, a i + 1) δ).coeff a := by
    rw [Hfam_coeff]
    exact (Hiter_coeff_stable p k a (Nat.le_succ _) δ).symm
  have h2 := divPow_sub_divPow (p := p) (Hfam_coeff_zero (δ + 1))
    (Hiter_coeff_zero p k (∑ i, a i) (δ + 1)) (Hfam_sub_Hiter (∑ i, a i) (δ + 1)) a (by omega)
  rw [coeff_sub', sub_eq_zero] at h2
  rw [h1, Hiter_succ, coeff_add', coeff_add', h2]

/-! ### Uniqueness -/

theorem Hfam_unique (H H' : ZMod k → Hur (ZMod k))
    (h0 : ∀ δ, (H δ).coeff 0 = 0) (hH : ∀ δ, H δ = var (-δ) + divPow p (H (δ + 1)))
    (h0' : ∀ δ, (H' δ).coeff 0 = 0) (hH' : ∀ δ, H' δ = var (-δ) + divPow p (H' (δ + 1))) :
    H = H' := by
  have key : ∀ N : ℕ, ∀ δ, VanishBelow N (H δ - H' δ) := by
    intro N
    induction N with
    | zero => exact fun δ => vanishBelow_zero_left _
    | succ N ih =>
      intro δ
      have h : H δ - H' δ = divPow p (H (δ + 1)) - divPow p (H' (δ + 1)) := by
        conv_lhs => rw [hH δ, hH' δ]
        abel
      rw [h]
      exact divPow_sub_divPow (h0 _) (h0' _) (ih (δ + 1))
  funext δ
  ext a
  have h := key (∑ i, a i + 1) δ a (Nat.lt_succ_self _)
  rwa [coeff_sub', sub_eq_zero] at h

variable (p k)

/-- Lemma "H": the unique family without constant terms with `H_δ = z_(-δ) + H_(δ+1)^p / p`. -/
theorem exists_unique_Hfam :
    ∃! H : ZMod k → Hur (ZMod k),
      (∀ δ, (H δ).coeff 0 = 0) ∧ ∀ δ, H δ = var (-δ) + divPow p (H (δ + 1)) :=
  ⟨Hfam p k, ⟨Hfam_coeff_zero, Hfam_eq⟩,
    fun H' h => Hfam_unique H' (Hfam p k) h.1 h.2 Hfam_coeff_zero Hfam_eq⟩

/-! ### The coefficients -/

/-- `T_δ(a)`: the coefficient of `z^a / a!` in `H_δ`. -/
def T (δ : ZMod k) (a : ZMod k → ℕ) : ℤ :=
  (Hfam p k δ).coeff a

variable {p k}

theorem T_zero (δ : ZMod k) : T p k δ 0 = 0 := Hfam_coeff_zero δ

theorem T_single (δ c : ZMod k) : T p k δ (Pi.single c 1) = if c = -δ then 1 else 0 := by
  have hp : p.Prime := Fact.out
  have h1 : (divPow p (Hfam p k (δ + 1))).coeff (Pi.single c 1) = 0 :=
    divPow_vanishBelow (Hfam_coeff_zero (δ + 1)) _
      (by rw [sum_single_one]; exact hp.one_lt)
  unfold T
  rw [Hfam_eq δ, coeff_add', coeff_var, h1, add_zero]
  by_cases h : c = -δ
  · rw [ite_eq_left h, ite_eq_left (by rw [h])]
  · rw [ite_eq_right h, ite_eq_right]
    intro h2
    apply h
    by_contra hne
    have h3 := congrFun h2 c
    rw [Pi.single_eq_same, Pi.single_eq_of_ne hne] at h3
    exact one_ne_zero h3

end Family

end MMM.Frob

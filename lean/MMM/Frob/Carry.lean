/-
Written by Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-14. Not human-reviewed.

Brief `briefs/W042_lean_frobenius_carry.md`, parts 2 and 3; the last section of
`paper/frobenius_proof.tex`.  The ring of Hurwitz series is the one of `HurwitzC.lean`, the
family `Hfam` and its coefficients `T` are those of `HFamily.lean`.

* `coeff_prod_fin`: the coefficient of a product of `p` Hurwitz series, as a sum over the
  `p`-tuples of multi-indices with a given sum, with a product of multinomial coefficients.
* `T_rec`: the explicit recursion for the coefficients `T_δ(a)` of the family `H_δ`.
* `isDer_der`, `iterate_der_divPow`: Lemma "hur" (iv), second formula, from
  `IsDer.iterate_pow_prime` of `PowDeriv.lean`.
* `carry`: Proposition "The carry operator",
  `p ∣ T_δ(b + p e_c) + T_δ(b + e_(c+1))`.

The proof of `carry` follows the note, with one simplification: the note applies the congruence
`E H_δ ≡ H_(δ+1)^(p-1) · E H_(δ+1)` `k` times to return to `δ`, and then iterates; here it is
applied `n` times along `δ, δ+1, …, δ+n` (`carry_aux`), which shows directly that `E H_δ` is
congruent modulo `p` to a series without terms of degree `< n`, for every `n`.
-/
import MMM.Frob.HFamily
import MMM.Frob.PowDeriv
import Mathlib.NumberTheory.Wilson

set_option linter.unusedSectionVars false

noncomputable section

namespace MMM.Frob

open Hur

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

namespace Hur

/-! ### Tuples of multi-indices with a given sum -/

/-- The `p`-tuples of multi-indices with sum `a`.  (The bound on the entries follows from the
condition on the sum; it makes the set finite by construction.) -/
def tupleBox (p : ℕ) (a : ι → ℕ) : Finset (Fin p → ι → ℕ) :=
  (Fintype.piFinset fun _ : Fin p => Fintype.piFinset fun c => Finset.range (a c + 1)).filter
    (fun u => ∑ i, u i = a)

theorem mem_tupleBox {p : ℕ} {a : ι → ℕ} {u : Fin p → ι → ℕ} :
    u ∈ tupleBox p a ↔ ∑ i, u i = a := by
  unfold tupleBox
  rw [Finset.mem_filter, and_iff_right_iff_imp]
  intro h
  rw [Fintype.mem_piFinset]
  intro i
  rw [Fintype.mem_piFinset]
  intro c
  rw [Finset.mem_range, Nat.lt_succ_iff, ← h, Finset.sum_apply]
  exact Finset.single_le_sum (f := fun j => u j c) (fun _ _ => Nat.zero_le _) (Finset.mem_univ i)

theorem mem_box {a b : ι → ℕ} :
    b ∈ Fintype.piFinset (fun i => Finset.range (a i + 1)) ↔ ∀ i, b i ≤ a i := by
  simp only [Fintype.mem_piFinset, Finset.mem_range, Nat.lt_succ_iff]

/-- The tuples of length `p + 1` with sum `a`, sorted by their first entry. -/
theorem sum_tupleBox_succ {M : Type*} [AddCommMonoid M] (p : ℕ) (a : ι → ℕ)
    (G : (Fin (p + 1) → ι → ℕ) → M) :
    ∑ u ∈ tupleBox (p + 1) a, G u =
      ∑ b ∈ Fintype.piFinset (fun i => Finset.range (a i + 1)),
        ∑ v ∈ tupleBox p (a - b), G (Fin.cons b v) := by
  rw [Finset.sum_sigma']
  refine Finset.sum_nbij' (fun u => ⟨u 0, Fin.tail u⟩) (fun x => Fin.cons x.1 x.2) ?_ ?_ ?_ ?_ ?_
  · intro u hu
    have hu' : u 0 + ∑ i : Fin p, u i.succ = a := by
      rw [← Fin.sum_univ_succ]
      exact mem_tupleBox.mp hu
    subst hu'
    simp only [Finset.mem_sigma, mem_box, mem_tupleBox, Fin.tail]
    refine ⟨fun i => ?_, ?_⟩
    · rw [Pi.add_apply]
      exact Nat.le_add_right _ _
    · funext i
      simp only [Pi.add_apply, Pi.sub_apply]
      omega
  · rintro ⟨b, v⟩ hx
    simp only [Finset.mem_sigma, mem_box, mem_tupleBox] at hx
    rw [mem_tupleBox, Fin.sum_univ_succ]
    simp only [Fin.cons_zero, Fin.cons_succ]
    rw [hx.2]
    funext i
    have h := hx.1 i
    simp only [Pi.add_apply, Pi.sub_apply]
    omega
  · intro u _
    exact Fin.cons_self_tail u
  · rintro ⟨b, v⟩ _
    simp
  · intro u _
    simp

/-- The multinomial coefficient of one component of a tuple with one more entry. -/
theorem multinomial_cons_apply (p : ℕ) (b : ι → ℕ) (v : Fin p → ι → ℕ) (c : ι) :
    Nat.multinomial Finset.univ (fun i => (Fin.cons b v : Fin (p + 1) → ι → ℕ) i c) =
      (b c + ∑ j, v j c).choose (b c) * Nat.multinomial Finset.univ (fun j => v j c) := by
  have h : (fun i => (Fin.cons b v : Fin (p + 1) → ι → ℕ) i c) =
      (Fin.cons (b c) (fun j => v j c) : Fin (p + 1) → ℕ) := by
    funext i
    refine Fin.cases ?_ (fun j => ?_) i
    · rfl
    · rfl
  rw [h, multinomial_cons_fin]

/-- `coeff_prod_fin`, with the index set written as `tupleBox`. -/
theorem coeff_prod_tupleBox (p : ℕ) (f : Fin p → Hur ι) (a : ι → ℕ) :
    (∏ i, f i).coeff a =
      ∑ u ∈ tupleBox p a,
        ((∏ c, Nat.multinomial Finset.univ (fun i => u i c) : ℕ) : ℤ) *
          ∏ i, (f i).coeff (u i) := by
  induction p generalizing a with
  | zero =>
    rw [Finset.univ_eq_empty, Finset.prod_empty, coeff_one']
    by_cases ha : a = 0
    · subst ha
      have h : tupleBox 0 (0 : ι → ℕ) = {default} := by
        ext u
        rw [mem_tupleBox, Finset.mem_singleton]
        exact ⟨fun _ => Subsingleton.elim _ _, fun _ => by simp⟩
      rw [ite_eq_left rfl, h, Finset.sum_singleton]
      simp
    · have h : tupleBox 0 a = ∅ := by
        ext u
        simp only [mem_tupleBox, Finset.univ_eq_empty, Finset.sum_empty, Finset.notMem_empty,
          iff_false]
        exact fun h => ha h.symm
      rw [ite_eq_right ha, h, Finset.sum_empty]
  | succ p ih =>
    rw [Fin.prod_univ_succ, coeff_mul', sum_tupleBox_succ]
    refine Finset.sum_congr rfl fun b hb => ?_
    rw [ih (fun i => f i.succ) (a - b), Finset.mul_sum]
    refine Finset.sum_congr rfl fun v hv => ?_
    have hv' : ∑ j, v j = a - b := mem_tupleBox.mp hv
    have hb' : ∀ i, b i ≤ a i := mem_box.mp hb
    have hm : (∏ c, Nat.multinomial Finset.univ
          (fun i => (Fin.cons b v : Fin (p + 1) → ι → ℕ) i c)) =
        mchoose a b * ∏ c, Nat.multinomial Finset.univ (fun j => v j c) := by
      unfold mchoose
      rw [← Finset.prod_mul_distrib]
      refine Finset.prod_congr rfl fun c _ => ?_
      have h1 : b c + ∑ j, v j c = a c := by
        have h2 := congrFun hv' c
        rw [Finset.sum_apply, Pi.sub_apply] at h2
        have h3 := hb' c
        omega
      rw [multinomial_cons_apply, h1]
    rw [hm, Fin.prod_univ_succ]
    simp only [Fin.cons_zero, Fin.cons_succ]
    push_cast
    ring

end Hur

/-! ### Part 2: the coefficient of a product, and the explicit recursion -/

/-- Coefficient of a product of p Hurwitz series. -/
theorem coeff_prod_fin {ι : Type*} [Fintype ι] [DecidableEq ι] (p : ℕ) (f : Fin p → Hur ι)
    (a : ι → ℕ) :
    (∏ i, f i).coeff a =
      ∑ u ∈ (Fintype.piFinset fun _ : Fin p =>
              Fintype.piFinset fun c => Finset.range (a c + 1)).filter
              (fun u => ∑ i, u i = a),
        ((∏ c, Nat.multinomial Finset.univ (fun i => u i c) : ℕ) : ℤ) *
          ∏ i, (f i).coeff (u i) :=
  coeff_prod_tupleBox p f a

/-- The explicit recursion for the coefficients of the family `H_δ`. -/
theorem T_rec (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ : ZMod k) (a : ZMod k → ℕ) :
    (p : ℤ) * T p k δ a = (p : ℤ) * (if a = Pi.single (-δ) 1 then 1 else 0) +
      ∑ u ∈ (Fintype.piFinset fun _ : Fin p =>
              Fintype.piFinset fun c => Finset.range (a c + 1)).filter
              (fun u => ∑ i, u i = a),
        ((∏ c, Nat.multinomial Finset.univ (fun i => u i c) : ℕ) : ℤ) *
          ∏ i, T p k (δ + 1) (u i) := by
  have h1 : (p : ℤ) * T p k δ a = (p • Hfam p k δ).coeff a := (coeff_nsmul' p _ a).symm
  rw [h1, Hfam_eq δ, smul_add, divPow_spec _ (Hfam_coeff_zero (δ + 1)), coeff_add',
    coeff_nsmul', coeff_var, ← Fin.prod_const p (Hfam p k (δ + 1)), coeff_prod_fin]
  rfl

/-! ### Part 3: Lemma "hur" (iv) -/

theorem isDer_der {ι : Type*} [Fintype ι] [DecidableEq ι] (c : ι) :
    IsDer (der c : Hur ι → Hur ι) :=
  ⟨der_add c, der_mul c⟩

/-- Lemma "hur" (iv), second formula. -/
theorem iterate_der_divPow {ι : Type*} [Fintype ι] [DecidableEq ι] (p : ℕ) [Fact p.Prime] (c : ι)
    (f : Hur ι) (hf : f.coeff 0 = 0) :
    ∃ r : Hur ι, (der c)^[p] (divPow p f) =
      f ^ (p - 1) * (der c)^[p] f + (p - 1).factorial • (der c f) ^ p + p • r := by
  have hp : p.Prime := Fact.out
  obtain ⟨r, hr⟩ := (isDer_der c).iterate_pow_prime p f
  refine ⟨r, nsmul_left_cancel_hur hp.ne_zero ?_⟩
  rw [← (isDer_der c).iterate_map_nsmul p p (divPow p f), divPow_spec f hf, hr, smul_add,
    smul_add, ← Nat.mul_factorial_pred hp.ne_zero, mul_smul, sq, mul_smul]

/-! ### Part 3: the carry congruence -/

namespace Hur

/-- All coefficients of `f` are divisible by `p`: `f ∈ p·Hur`. -/
def DvdAll (p : ℕ) (f : Hur ι) : Prop := ∀ a, (p : ℤ) ∣ f.coeff a

theorem dvdAll_zero (p : ℕ) : DvdAll p (0 : Hur ι) := fun _ => dvd_zero _

theorem dvdAll_nsmul (p : ℕ) (r : Hur ι) : DvdAll p (p • r) := by
  intro a
  rw [coeff_nsmul']
  exact dvd_mul_right _ _

theorem DvdAll.add {p : ℕ} {f g : Hur ι} (hf : DvdAll p f) (hg : DvdAll p g) :
    DvdAll p (f + g) := by
  intro a
  rw [coeff_add']
  exact dvd_add (hf a) (hg a)

/-- `p·Hur` is an ideal. -/
theorem DvdAll.mul_left {p : ℕ} {f : Hur ι} (hf : DvdAll p f) (g : Hur ι) :
    DvdAll p (g * f) := by
  intro a
  rw [coeff_mul']
  exact Finset.dvd_sum fun b _ => Dvd.dvd.mul_left (hf _) _

/-- The coefficients of an iterated derivative. -/
theorem coeff_iterate_der (c : ι) (n : ℕ) (f : Hur ι) (b : ι → ℕ) :
    ((der c)^[n] f).coeff b = f.coeff (b + n • Pi.single c 1) := by
  induction n generalizing f with
  | zero => rw [Function.iterate_zero_apply, zero_smul, add_zero]
  | succ n ih => rw [Function.iterate_succ_apply, ih, coeff_der, succ_nsmul, add_assoc]

/-- The derivatives of order at least 2 of a variable vanish. -/
theorem iterate_der_var {n : ℕ} (hn : 2 ≤ n) (c c' : ι) : (der c)^[n] (var c') = 0 := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 2 := ⟨n - 2, by omega⟩
  have h : der c (if c = c' then (1 : Hur ι) else 0) = 0 := by
    split_ifs
    · exact der_one c
    · exact der_zero c
  rw [Function.iterate_succ_apply, Function.iterate_succ_apply, der_var, h,
    (isDer_der c).iterate_map_zero]

/-- Wilson's theorem as a congruence of integers. -/
theorem wilson_int (p : ℕ) [Fact p.Prime] : (((p - 1).factorial : ℕ) : ℤ) ≡ -1 [ZMOD p] := by
  rw [← ZMod.intCast_eq_intCast_iff]
  push_cast
  exact ZMod.wilsons_lemma p

end Hur

section Carry

variable (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k]

/-- The operator `E = ∂_c^p + ∂_(c+1)` of Proposition "The carry operator". -/
def carryOp (c : ZMod k) (f : Hur (ZMod k)) : Hur (ZMod k) :=
  (der c)^[p] f + der (c + 1) f

theorem coeff_carryOp (c : ZMod k) (f : Hur (ZMod k)) (b : ZMod k → ℕ) :
    (carryOp p k c f).coeff b =
      f.coeff (b + p • Pi.single c 1) + f.coeff (b + Pi.single (c + 1) 1) := by
  unfold carryOp
  rw [coeff_add', coeff_iterate_der, coeff_der]

/-- One step of the proof of the carry congruence:
`E H_δ ≡ H_(δ+1)^(p-1) · E H_(δ+1)` modulo `p·Hur`. -/
theorem carry_step (δ c : ZMod k) :
    DvdAll p (carryOp p k c (Hfam p k δ) -
      Hfam p k (δ + 1) ^ (p - 1) * carryOp p k c (Hfam p k (δ + 1))) := by
  have hp : p.Prime := Fact.out
  have hg0 : (Hfam p k (δ + 1)).coeff 0 = 0 := Hfam_coeff_zero (δ + 1)
  obtain ⟨r, hr⟩ := iterate_der_divPow p c (Hfam p k (δ + 1)) hg0
  have h1 : (der c)^[p] (Hfam p k δ) =
      Hfam p k (δ + 1) ^ (p - 1) * (der c)^[p] (Hfam p k (δ + 1)) +
        (p - 1).factorial • (der c (Hfam p k (δ + 1))) ^ p + p • r := by
    rw [Hfam_eq δ, (isDer_der c).iterate_map_add, iterate_der_var hp.two_le, zero_add, hr]
  have h2 : der (c + 1) (Hfam p k δ) =
      (if c + 1 = -δ then 1 else 0) +
        Hfam p k (δ + 1) ^ (p - 1) * der (c + 1) (Hfam p k (δ + 1)) := by
    rw [Hfam_eq δ, der_add, der_var, der_divPow _ _ hg0]
  have h3 : carryOp p k c (Hfam p k δ) -
      Hfam p k (δ + 1) ^ (p - 1) * carryOp p k c (Hfam p k (δ + 1)) =
      ((if c + 1 = -δ then (1 : Hur (ZMod k)) else 0) +
        (p - 1).factorial • (der c (Hfam p k (δ + 1))) ^ p) + p • r := by
    unfold carryOp
    rw [h1, h2]
    ring
  rw [h3]
  refine DvdAll.add ?_ (dvdAll_nsmul p r)
  intro a
  have hiff : c = -(δ + 1) ↔ c + 1 = -δ := by
    constructor
    · intro h
      rw [h]
      ring
    · intro h
      rw [eq_sub_of_add_eq h]
      ring
  have hc0 : (der c (Hfam p k (δ + 1))).coeff 0 = if c + 1 = -δ then 1 else 0 := by
    have h := T_single (p := p) (δ + 1) c
    rw [coeff_der, zero_add]
    exact h.trans (if_congr hiff rfl rfl)
  have hconst : (if c + 1 = -δ then (1 : Hur (ZMod k)) else 0).coeff a =
      if a = 0 then (if c + 1 = -δ then 1 else 0) else 0 := by
    by_cases h : c + 1 = -δ
    · rw [ite_eq_left h, ite_eq_left h, coeff_one']
    · rw [ite_eq_right h, ite_eq_right h, coeff_zero', ite_self]
  have hF := coeff_pow_prime_modEq (p := p) (der c (Hfam p k (δ + 1))) a
  rw [hc0] at hF
  have h4 := (Int.ModEq.refl
    (n := (p : ℤ)) (if a = 0 then (if c + 1 = -δ then (1 : ℤ) else 0) else 0)).add
      ((wilson_int p).mul hF)
  rw [coeff_add', coeff_nsmul', hconst]
  rw [show (if a = 0 then (if c + 1 = -δ then (1 : ℤ) else 0) else 0) +
      -1 * (if a = 0 then (if c + 1 = -δ then (1 : ℤ) else 0) else 0) = 0 by ring] at h4
  exact Int.modEq_zero_iff_dvd.mp h4

/-- For every `n`, `E H_δ` is congruent modulo `p·Hur` to a series without terms of degree
`< n`. -/
theorem carry_aux (c : ZMod k) (n : ℕ) :
    ∀ δ : ZMod k, ∃ R : Hur (ZMod k), VanishBelow n R ∧
      DvdAll p (carryOp p k c (Hfam p k δ) - R) := by
  have hp : p.Prime := Fact.out
  induction n with
  | zero =>
    intro δ
    refine ⟨carryOp p k c (Hfam p k δ), vanishBelow_zero_left _, ?_⟩
    rw [sub_self]
    exact dvdAll_zero p
  | succ n ih =>
    intro δ
    obtain ⟨R, hR, hdvd⟩ := ih (δ + 1)
    refine ⟨Hfam p k (δ + 1) ^ (p - 1) * R, ?_, ?_⟩
    · have h1 : VanishBelow 1 (Hfam p k (δ + 1) ^ (p - 1)) :=
        ((vanishBelow_one_iff.mpr (Hfam_coeff_zero (δ + 1))).pow (p - 1)).mono
          (by have := hp.two_le; omega)
      rw [add_comm n 1]
      exact h1.mul hR
    · have h2 := (carry_step p k δ c).add (hdvd.mul_left (Hfam p k (δ + 1) ^ (p - 1)))
      have h3 : carryOp p k c (Hfam p k δ) - Hfam p k (δ + 1) ^ (p - 1) * R =
          (carryOp p k c (Hfam p k δ) -
            Hfam p k (δ + 1) ^ (p - 1) * carryOp p k c (Hfam p k (δ + 1))) +
          Hfam p k (δ + 1) ^ (p - 1) * (carryOp p k c (Hfam p k (δ + 1)) - R) := by ring
      rw [h3]
      exact h2

/-- Proposition "The carry operator". -/
theorem carry (δ c : ZMod k) (b : ZMod k → ℕ) :
    (p : ℤ) ∣ T p k δ (b + p • Pi.single c 1) + T p k δ (b + Pi.single (c + 1) 1) := by
  obtain ⟨R, hR, hdvd⟩ := carry_aux p k c (∑ i, b i + 1) δ
  have h := hdvd b
  rw [coeff_sub', hR b (Nat.lt_succ_self _), sub_zero, coeff_carryOp] at h
  exact h

end Carry

end MMM.Frob

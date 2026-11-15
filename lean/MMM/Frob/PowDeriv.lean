/-
Written by Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-14. Not human-reviewed.

The p-th derivative of a p-th power, for a derivation `D` of a commutative ring `R`
(brief `briefs/W038_lean_frobenius_powderiv.md`; Lemma `lem:hur` (iv) of
`paper/frobenius_proof.tex`).  The file is self-contained: it imports nothing from the project.

Contents:
* `IsDer D`: `D : R → R` is additive and satisfies the product rule;
* `IsDer.iterate_mul`: Leibniz' rule for two factors;
* `IsDer.iterate_prod`: Leibniz' rule for `m` factors, as a sum over
  `Finset.Nat.antidiagonalTuple m n` with multinomial coefficients;
* `sum_cyclic_invariant`: fact E2 of the note (non-constant `p`-tuples fall into orbits of
  `p` under the cyclic shift) as a statement about sums;
* `IsDer.iterate_pow_prime`: `D^[p] (u ^ p) = p • (u ^ (p - 1) * D^[p] u) + p ! • (D u) ^ p`
  modulo `p ^ 2`.
-/
import Mathlib.Data.Nat.Choose.Multinomial
import Mathlib.Data.Nat.Prime.Factorial
import Mathlib.Data.Fin.Tuple.NatAntidiagonal
import Mathlib.GroupTheory.Perm.Cycle.Type

namespace MMM.Frob

/-- A derivation given as a plain function: additive, with the product rule. -/
structure IsDer {R : Type*} [CommRing R] (D : R → R) : Prop where
  add : ∀ a b, D (a + b) = D a + D b
  mul : ∀ a b, D (a * b) = D a * b + a * D b

variable {R : Type*} [CommRing R]

namespace IsDer

variable {D : R → R}

/-! ### Elementary properties of a derivation and of its iterates -/

theorem map_zero (hD : IsDer D) : D 0 = 0 := by
  have h := hD.add 0 0
  rw [add_zero] at h
  exact left_eq_add.mp h

theorem map_one (hD : IsDer D) : D 1 = 0 := by
  have h := hD.mul 1 1
  rw [mul_one, mul_one, one_mul] at h
  exact left_eq_add.mp h

theorem map_nsmul (hD : IsDer D) (n : ℕ) (a : R) : D (n • a) = n • D a := by
  induction n with
  | zero => simp [hD.map_zero]
  | succ n ih => rw [succ_nsmul, hD.add, ih, succ_nsmul]

theorem map_sum (hD : IsDer D) {ι : Type*} (s : Finset ι) (f : ι → R) :
    D (∑ i ∈ s, f i) = ∑ i ∈ s, D (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [hD.map_zero]
  | insert a s ha ih => rw [Finset.sum_insert ha, hD.add, ih, Finset.sum_insert ha]

theorem iterate_map_zero (hD : IsDer D) (n : ℕ) : D^[n] 0 = 0 :=
  Function.iterate_fixed hD.map_zero n

/-- Every iterate of positive order kills `1`. -/
theorem iterate_succ_map_one (hD : IsDer D) (n : ℕ) : D^[n + 1] 1 = 0 := by
  rw [Function.iterate_succ_apply, hD.map_one, hD.iterate_map_zero]

theorem iterate_map_add (hD : IsDer D) (n : ℕ) (a b : R) :
    D^[n] (a + b) = D^[n] a + D^[n] b := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [Function.iterate_succ_apply', ih, hD.add]

theorem iterate_map_nsmul (hD : IsDer D) (n k : ℕ) (a : R) :
    D^[n] (k • a) = k • D^[n] a := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [Function.iterate_succ_apply', ih, hD.map_nsmul]

theorem iterate_map_sum (hD : IsDer D) (n : ℕ) {ι : Type*} (s : Finset ι) (f : ι → R) :
    D^[n] (∑ i ∈ s, f i) = ∑ i ∈ s, D^[n] (f i) := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [Function.iterate_succ_apply', ih, hD.map_sum]

/-! ### Leibniz' rule for two factors -/

/-- Leibniz' rule for two factors. -/
theorem iterate_mul (hD : IsDer D) (n : ℕ) (a b : R) :
    D^[n] (a * b) = ∑ i ∈ Finset.range (n + 1), (n.choose i) • (D^[i] a * D^[n - i] b) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Function.iterate_succ_apply', ih, hD.map_sum]
    have h1 : ∀ i ∈ Finset.range (n + 1), D (n.choose i • (D^[i] a * D^[n - i] b)) =
        n.choose i • (D^[i + 1] a * D^[n - i] b) +
          n.choose i • (D^[i] a * D^[n + 1 - i] b) := by
      intro i hi
      have hi' : i ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
      rw [hD.map_nsmul, hD.mul, smul_add, Function.iterate_succ_apply', Nat.succ_sub hi',
        Function.iterate_succ_apply']
    rw [Finset.sum_congr rfl h1, Finset.sum_add_distrib]
    rw [Finset.sum_range_succ' (fun i => (n + 1).choose i • (D^[i] a * D^[n + 1 - i] b)) (n + 1)]
    rw [Finset.sum_range_succ' (fun i => n.choose i • (D^[i] a * D^[n + 1 - i] b)) n]
    simp only [Nat.choose_succ_succ', add_smul, Finset.sum_add_distrib, Nat.choose_zero_right,
      Nat.add_sub_add_right]
    rw [Finset.sum_range_succ (fun i => n.choose (i + 1) • (D^[i + 1] a * D^[n - i] b)) n,
      Nat.choose_succ_self, zero_smul, add_zero, add_assoc]

/-! ### Leibniz' rule for `m` factors -/

end IsDer

/-- The tuples of length `m + 1` with sum `n`, sorted by their first entry. -/
theorem sum_antidiagonalTuple_succ {M : Type*} [AddCommMonoid M] (m n : ℕ)
    (G : (Fin (m + 1) → ℕ) → M) :
    ∑ c ∈ Finset.Nat.antidiagonalTuple (m + 1) n, G c =
      ∑ i ∈ Finset.range (n + 1), ∑ c ∈ Finset.Nat.antidiagonalTuple m (n - i),
        G (Fin.cons i c) := by
  rw [Finset.sum_sigma']
  refine Finset.sum_nbij' (fun c => ⟨c 0, Fin.tail c⟩) (fun x => Fin.cons x.1 x.2) ?_ ?_ ?_ ?_ ?_
  · intro c hc
    have hc' : c 0 + ∑ i : Fin m, c i.succ = n := by
      rw [← Fin.sum_univ_succ]; exact Finset.Nat.mem_antidiagonalTuple.mp hc
    simp only [Finset.mem_sigma, Finset.mem_range, Finset.Nat.mem_antidiagonalTuple, Fin.tail]
    omega
  · rintro ⟨i, c⟩ hx
    simp only [Finset.mem_sigma, Finset.mem_range, Finset.Nat.mem_antidiagonalTuple] at hx
    simp only [Finset.Nat.mem_antidiagonalTuple, Fin.sum_cons]
    omega
  · intro c _
    exact Fin.cons_self_tail c
  · rintro ⟨i, c⟩ _
    simp
  · intro c _
    simp

/-- The multinomial coefficient of a tuple with one more entry. -/
theorem multinomial_cons_fin (m i : ℕ) (c : Fin m → ℕ) :
    Nat.multinomial Finset.univ (Fin.cons i c : Fin (m + 1) → ℕ) =
      (i + ∑ j, c j).choose i * Nat.multinomial Finset.univ c := by
  have hpos : 0 < ∏ j, ((Fin.cons i c : Fin (m + 1) → ℕ) j).factorial :=
    Finset.prod_pos fun j _ => Nat.factorial_pos _
  have hsymm : (i + ∑ j, c j).choose i = (i + ∑ j, c j).choose (∑ j, c j) :=
    Nat.choose_symm_add
  apply Nat.eq_of_mul_eq_mul_left hpos
  rw [hsymm, Nat.multinomial_spec, Fin.prod_univ_succ, Fin.sum_univ_succ]
  simp only [Fin.cons_zero, Fin.cons_succ]
  rw [← Nat.add_choose_mul_factorial_mul_factorial i (∑ j, c j),
    ← Nat.multinomial_spec Finset.univ c]
  ring

namespace IsDer

variable {D : R → R}

/-- Leibniz' rule for `m` factors. -/
theorem iterate_prod (hD : IsDer D) (m n : ℕ) (f : Fin m → R) :
    D^[n] (∏ i, f i) =
      ∑ c ∈ Finset.Nat.antidiagonalTuple m n,
        (Nat.multinomial Finset.univ c) • ∏ i, D^[c i] (f i) := by
  induction m generalizing n with
  | zero =>
    cases n with
    | zero => simp
    | succ n => simp [hD.iterate_succ_map_one]
  | succ m ih =>
    rw [Fin.prod_univ_succ, hD.iterate_mul, sum_antidiagonalTuple_succ]
    refine Finset.sum_congr rfl fun i hi => ?_
    have hi' : i ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
    rw [ih (n - i) (fun j => f j.succ), Finset.mul_sum, Finset.smul_sum]
    refine Finset.sum_congr rfl fun c hc => ?_
    have hc' : ∑ j, c j = n - i := Finset.Nat.mem_antidiagonalTuple.mp hc
    rw [multinomial_cons_fin, hc', Nat.add_sub_of_le hi', Fin.prod_univ_succ]
    simp only [Fin.cons_zero, Fin.cons_succ, nsmul_eq_mul, Nat.cast_mul]
    ring

end IsDer

/-! ### Cyclic shifts of `p`-tuples (fact E2) -/

open Fin.NatCast in
/-- A finite set of `p`-tuples that is closed under the cyclic shift and contains no constant
tuple has a number of elements divisible by `p`. -/
theorem card_dvd_of_shift_invariant (p : ℕ) [Fact p.Prime] {α : Type*} [DecidableEq α]
    (T : Finset (Fin p → α)) (hT : ∀ c ∈ T, (fun i => c (i + 1)) ∈ T)
    (hne : ∀ c ∈ T, ¬ ∀ i j, c i = c j) : p ∣ T.card := by
  let f : T → T := fun c => ⟨fun i => c.1 (i + 1), hT c.1 c.2⟩
  have hf : ∀ (c : T) (i : Fin p), (f c).1 i = c.1 (i + 1) := fun _ _ => rfl
  have hiter : ∀ (k : ℕ) (c : T) (i : Fin p), (f^[k] c).1 i = c.1 (i + (k : Fin p)) := by
    intro k
    induction k with
    | zero => intro c i; simp
    | succ k ih =>
      intro c i
      rw [Function.iterate_succ_apply, ih (f c) i, hf, Nat.cast_succ, add_assoc]
  have hfp : f^[p ^ 1] = id := by
    funext c
    apply Subtype.ext
    funext i
    rw [pow_one, hiter, Fin.natCast_self, add_zero]
    rfl
  have hmod := Equiv.Perm.card_fixedPoints_modEq (f := f) (p := p) (n := 1) hfp
  have hempty : IsEmpty (Function.fixedPoints f) := by
    refine ⟨fun ⟨c, hc⟩ => hne c.1 c.2 ?_⟩
    have h0 : ∀ i : Fin p, c.1 i = c.1 0 := by
      intro i
      have h := hiter i.val c 0
      rw [Function.iterate_fixed hc, Fin.cast_val_eq_self, zero_add] at h
      exact h.symm
    intro i j
    rw [h0 i, h0 j]
  rw [Fintype.card_eq_zero_iff.mpr hempty, Fintype.card_coe] at hmod
  exact (Nat.modEq_zero_iff_dvd).mp hmod

/-- Fact E2 as a statement about sums: over a set of p-tuples that is closed under the cyclic
shift and contains no constant tuple, a shift-invariant function sums to a multiple of p. -/
theorem sum_cyclic_invariant {M : Type*} [AddCommGroup M] (p : ℕ) [Fact p.Prime] {α : Type*}
    [DecidableEq α] (S : Finset (Fin p → α))
    (hS : ∀ c ∈ S, (fun i => c (i + 1)) ∈ S)
    (F : (Fin p → α) → M) (hF : ∀ c ∈ S, F (fun i => c (i + 1)) = F c)
    (hne : ∀ c ∈ S, ¬ ∀ i j, c i = c j) : ∃ r : M, ∑ c ∈ S, F c = p • r := by
  classical
  have key : ∀ y : M, p ∣ (S.filter (fun c => F c = y)).card := by
    intro y
    refine card_dvd_of_shift_invariant p _ ?_ ?_
    · intro c hc
      rw [Finset.mem_filter] at hc ⊢
      exact ⟨hS c hc.1, (hF c hc.1).trans hc.2⟩
    · intro c hc
      exact hne c (Finset.mem_filter.mp hc).1
  choose k hk using key
  refine ⟨∑ y ∈ S.image F, k y • y, ?_⟩
  rw [← Finset.sum_fiberwise_of_maps_to (g := F) (t := S.image F)
    (fun c hc => Finset.mem_image_of_mem F hc) F, Finset.smul_sum]
  refine Finset.sum_congr rfl fun y _ => ?_
  rw [Finset.sum_congr rfl (fun c hc => (Finset.mem_filter.mp hc).2), Finset.sum_const, hk y,
    mul_smul]

/-! ### The tuples of `p` natural numbers with sum `p` -/

/-- The tuples with sum `n` that have an entry equal to `n` are the tuples `Pi.single i n`. -/
theorem filter_exists_eq_antidiagonalTuple (m n : ℕ) :
    (Finset.Nat.antidiagonalTuple m n).filter (fun c => ∃ i, c i = n) =
      Finset.univ.image (fun i : Fin m => (Pi.single i n : Fin m → ℕ)) := by
  ext c
  simp only [Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple, Finset.mem_image,
    Finset.mem_univ, true_and]
  constructor
  · rintro ⟨hsum, i, hi⟩
    refine ⟨i, ?_⟩
    funext j
    by_cases hj : j = i
    · rw [hj, Pi.single_eq_same]
      exact hi.symm
    · rw [Pi.single_eq_of_ne hj]
      have h := Finset.add_sum_erase Finset.univ c (Finset.mem_univ i)
      rw [hsum, hi] at h
      have hle : c j ≤ ∑ x ∈ Finset.univ.erase i, c x :=
        Finset.single_le_sum (f := c) (fun _ _ => Nat.zero_le _)
          (Finset.mem_erase.mpr ⟨hj, Finset.mem_univ j⟩)
      omega
  · rintro ⟨i, rfl⟩
    exact ⟨by simp, i, by simp⟩

theorem pi_single_left_injective (m : ℕ) {n : ℕ} (hn : n ≠ 0) :
    Function.Injective (fun i : Fin m => (Pi.single i n : Fin m → ℕ)) := by
  intro i j h
  have h' := congrFun h i
  simp only [Pi.single_eq_same] at h'
  by_contra hij
  rw [Pi.single_eq_of_ne hij] at h'
  exact hn h'

/-- The product of the derivatives along `Pi.single i n`. -/
theorem prod_iterate_single (D : R → R) (m n : ℕ) (i : Fin m) (u : R) :
    ∏ j, D^[(Pi.single i n : Fin m → ℕ) j] u = u ^ (m - 1) * D^[n] u := by
  rw [← Finset.mul_prod_erase Finset.univ _ (Finset.mem_univ i), Pi.single_eq_same]
  have h : ∀ j ∈ Finset.univ.erase i, D^[(Pi.single i n : Fin m → ℕ) j] u = u := by
    intro j hj
    rw [Pi.single_eq_of_ne (Finset.ne_of_mem_erase hj), Function.iterate_zero_apply]
  rw [Finset.prod_congr rfl h, Finset.prod_const, Finset.card_erase_of_mem (Finset.mem_univ i),
    Finset.card_univ, Fintype.card_fin, mul_comm]

/-- The only constant tuple of `p` numbers with sum `p` is `(1, …, 1)`. -/
theorem filter_const_antidiagonalTuple {p : ℕ} (hp : p.Prime) :
    ((Finset.Nat.antidiagonalTuple p p).filter (fun c => ¬ ∃ i, c i = p)).filter
      (fun c => ∀ i j, c i = c j) = {fun _ => 1} := by
  ext c
  simp only [Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple, Finset.mem_singleton]
  constructor
  · rintro ⟨⟨hsum, -⟩, hconst⟩
    funext i
    have h : ∑ j, c j = p * c i := by
      rw [Finset.sum_congr rfl (fun j _ => hconst j i), Finset.sum_const, Finset.card_univ,
        Fintype.card_fin, smul_eq_mul]
    rw [hsum] at h
    exact Nat.eq_of_mul_eq_mul_left hp.pos (by rw [mul_one]; exact h.symm)
  · rintro rfl
    refine ⟨⟨by simp, ?_⟩, fun _ _ => rfl⟩
    rintro ⟨_, h⟩
    exact hp.one_lt.ne h

theorem multinomial_const_one (p : ℕ) :
    Nat.multinomial Finset.univ (fun _ : Fin p => 1) = p.factorial := by
  simp [Nat.multinomial]

/-- A tuple of `p` numbers with sum `p`, none of which is `p`, has a multinomial coefficient
divisible by `p`. -/
theorem dvd_multinomial_of_ne {p : ℕ} (hp : p.Prime) (c : Fin p → ℕ) (hsum : ∑ i, c i = p)
    (hlt : ¬ ∃ i, c i = p) : p ∣ Nat.multinomial Finset.univ c := by
  have hspec := Nat.multinomial_spec Finset.univ c
  rw [hsum] at hspec
  have h1 : p ∣ (∏ i, (c i).factorial) * Nat.multinomial Finset.univ c := by
    rw [hspec]; exact Nat.dvd_factorial hp.pos le_rfl
  rcases (Nat.Prime.dvd_mul hp).mp h1 with h | h
  · exfalso
    obtain ⟨i, -, hi⟩ := (Prime.dvd_finsetProd_iff hp.prime _).mp h
    have h2 : p ≤ c i := (Nat.Prime.dvd_factorial hp).mp hi
    have hle : c i ≤ ∑ j, c j :=
      Finset.single_le_sum (f := c) (fun _ _ => Nat.zero_le _) (Finset.mem_univ i)
    exact hlt ⟨i, by omega⟩
  · exact h

/-- The multinomial coefficient is invariant under the cyclic shift. -/
theorem multinomial_shift (p : ℕ) [NeZero p] (c : Fin p → ℕ) :
    Nat.multinomial Finset.univ (fun i => c (i + 1)) = Nat.multinomial Finset.univ c := by
  unfold Nat.multinomial
  rw [Fintype.sum_equiv (Equiv.addRight (1 : Fin p)) (fun i => c (i + 1)) c (fun i => rfl),
    Fintype.prod_equiv (Equiv.addRight (1 : Fin p)) (fun i => (c (i + 1)).factorial)
      (fun i => (c i).factorial) (fun i => rfl)]

/-- The tuples that are neither `Pi.single i p` nor `(1, …, 1)` contribute a multiple of
`p ^ 2`. -/
theorem exists_sum_rest (D : R → R) (p : ℕ) [Fact p.Prime] (u : R) :
    ∃ r : R, ∑ c ∈ ((Finset.Nat.antidiagonalTuple p p).filter (fun c => ¬ ∃ i, c i = p)).filter
        (fun c => ¬ ∀ i j, c i = c j),
      (Nat.multinomial Finset.univ c) • ∏ i, D^[c i] u = p • (p • r) := by
  have hp : p.Prime := Fact.out
  have hmem : ∀ c : Fin p → ℕ,
      c ∈ ((Finset.Nat.antidiagonalTuple p p).filter (fun c => ¬ ∃ i, c i = p)).filter
        (fun c => ¬ ∀ i j, c i = c j) ↔
      (∑ i, c i = p ∧ ¬ ∃ i, c i = p) ∧ ¬ ∀ i j, c i = c j := by
    intro c
    simp only [Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple]
  have hsum_shift : ∀ c : Fin p → ℕ, ∑ i, c (i + 1) = ∑ i, c i := fun c =>
    Fintype.sum_equiv (Equiv.addRight (1 : Fin p)) (fun i => c (i + 1)) c (fun i => rfl)
  let F : (Fin p → ℕ) → R := fun c => (Nat.multinomial Finset.univ c / p) • ∏ i, D^[c i] u
  have hF : ∀ c : Fin p → ℕ, F (fun i => c (i + 1)) = F c := by
    intro c
    show (Nat.multinomial Finset.univ (fun i => c (i + 1)) / p) • ∏ i, D^[c (i + 1)] u =
      (Nat.multinomial Finset.univ c / p) • ∏ i, D^[c i] u
    rw [multinomial_shift, Fintype.prod_equiv (Equiv.addRight (1 : Fin p))
      (fun i => D^[c (i + 1)] u) (fun i => D^[c i] u) (fun i => rfl)]
  obtain ⟨r, hr⟩ := sum_cyclic_invariant p
    (((Finset.Nat.antidiagonalTuple p p).filter (fun c => ¬ ∃ i, c i = p)).filter
        (fun c => ¬ ∀ i j, c i = c j))
    (by
      intro c hc
      rw [hmem] at hc ⊢
      obtain ⟨⟨h1, h2⟩, h3⟩ := hc
      refine ⟨⟨(hsum_shift c).trans h1, fun ⟨i, hi⟩ => h2 ⟨i + 1, hi⟩⟩, fun h => h3 fun i j => ?_⟩
      have h4 := h (i - 1) (j - 1)
      simpa only [sub_add_cancel] using h4)
    F (fun c _ => hF c) (fun c hc => ((hmem c).mp hc).2)
  refine ⟨r, ?_⟩
  rw [← hr, Finset.smul_sum]
  refine Finset.sum_congr rfl fun c hc => ?_
  obtain ⟨⟨h1, h2⟩, -⟩ := (hmem c).mp hc
  show _ = p • ((Nat.multinomial Finset.univ c / p) • ∏ i, D^[c i] u)
  rw [← mul_smul, Nat.mul_div_cancel' (dvd_multinomial_of_ne hp c h1 h2)]

/-! ### The p-th derivative of a p-th power -/

namespace IsDer

variable {D : R → R}

/-- The identity behind Lemma "hur" (iv). -/
theorem iterate_pow_prime (hD : IsDer D) (p : ℕ) [Fact p.Prime] (u : R) :
    ∃ r : R, D^[p] (u ^ p) =
      p • (u ^ (p - 1) * D^[p] u) + p.factorial • (D u) ^ p + (p ^ 2) • r := by
  have hp : p.Prime := Fact.out
  obtain ⟨r, hr⟩ := exists_sum_rest D p u
  refine ⟨r, ?_⟩
  have h0 : D^[p] (u ^ p) = ∑ c ∈ Finset.Nat.antidiagonalTuple p p,
      (Nat.multinomial Finset.univ c) • ∏ i, D^[c i] u := by
    rw [← Fin.prod_const p u, hD.iterate_prod]
  have hA : ∑ c ∈ (Finset.Nat.antidiagonalTuple p p).filter (fun c => ∃ i, c i = p),
      (Nat.multinomial Finset.univ c) • ∏ i, D^[c i] u = p • (u ^ (p - 1) * D^[p] u) := by
    rw [filter_exists_eq_antidiagonalTuple,
      Finset.sum_image (fun i _ j _ h => pi_single_left_injective p hp.ne_zero h)]
    simp only [Nat.multinomial_single, prod_iterate_single, one_smul, Finset.sum_const,
      Finset.card_univ, Fintype.card_fin]
  have hB : ∑ c ∈ ((Finset.Nat.antidiagonalTuple p p).filter (fun c => ¬ ∃ i, c i = p)).filter
        (fun c => ∀ i j, c i = c j),
      (Nat.multinomial Finset.univ c) • ∏ i, D^[c i] u = p.factorial • (D u) ^ p := by
    rw [filter_const_antidiagonalTuple hp, Finset.sum_singleton, multinomial_const_one]
    simp
  rw [h0, ← Finset.sum_filter_add_sum_filter_not (Finset.Nat.antidiagonalTuple p p)
      (fun c => ∃ i, c i = p),
    ← Finset.sum_filter_add_sum_filter_not
      ((Finset.Nat.antidiagonalTuple p p).filter (fun c => ¬ ∃ i, c i = p))
      (fun c => ∀ i j, c i = c j),
    hA, hB, hr, sq, mul_smul, add_assoc]

end IsDer

end MMM.Frob

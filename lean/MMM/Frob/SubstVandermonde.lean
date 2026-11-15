/-
Started by Kimi K3.1 Pro (Open Math OS worker W040, cut off), continued by Claude Fable 5.2
(a subagent of the orchestrator), 2026-11-14. Not human-reviewed.
(This file was written entirely by Claude Fable 5.2.)

The regrouping identity ("Vandermonde, class by class") behind Lemma "From the leading part to
the labelled series" (`Subst.lean`), in a form that does not mention the definitions of
`Subst.lean`.

Instead of a Vandermonde identity for multinomial coefficients, the proof uses the multinomial
theorem twice and compares coefficients:

* `sum_cfTuples_weighted`: in a commutative semiring, for `m < p ^ N` and elements `y i j`,
  `∑_c (∏_j multinomial (digits j of c)) ∏_i ∏_j y i j ^ (digit j of c i) = ∏_j (∑_i y i j) ^ m_j`,
  the sum over the carry-free `p`-tuples `c` of `m` (induction on `N`, one digit at a time);
* `prod_sum_pow_eq_sum_tuples`: `∏_d (∑_i x i d) ^ a d = ∑_u (∏_d multinomial (u · d)) ∏ x ^ u`,
  the sum over the `p`-tuples `u` of multi-indices with sum `a`;
* `monomial_extract`: an identity between integer combinations of monomials that holds in the
  polynomial ring `ℤ[X_(i,d)]` holds with the monomials replaced by arbitrary integers
  (the monomials are a basis);
* `sum_cfTuples_regroup`: the result, for an arbitrary function `G` of a `p`-tuple of
  multi-indices.
-/
import MMM.Frob.SubstDigits
import Mathlib.RingTheory.MvPolynomial.Basic

namespace MMM.Frob

open MMM

variable {p : ℕ}

/-- The multinomial theorem, for a sum of `p` terms indexed by `Fin p`. -/
lemma sum_antidiagonalTuple_multinomial {R : Type*} [CommSemiring R] (y : Fin p → R) (n : ℕ) :
    ∑ e ∈ Finset.Nat.antidiagonalTuple p n,
        ((Nat.multinomial Finset.univ e : ℕ) : R) * ∏ i, y i ^ e i = (∑ i, y i) ^ n := by
  rw [Finset.sum_pow_eq_sum_piAntidiag, Finset.piAntidiag_univ_fin_eq_antidiagonalTuple]

/-- The digit-by-digit multinomial expansion over carry-free tuples. -/
theorem sum_cfTuples_weighted (hp : 2 ≤ p) {R : Type*} [CommSemiring R] :
    ∀ (N m : ℕ), m < p ^ N → ∀ y : Fin p → ℕ → R,
      ∑ c ∈ cfTuples p m,
          ((∏ j ∈ Finset.range N, Nat.multinomial Finset.univ (fun i => dig p j (c i)) : ℕ) : R) *
            ∏ i, ∏ j ∈ Finset.range N, y i j ^ dig p j (c i) =
        ∏ j ∈ Finset.range N, (∑ i, y i j) ^ dig p j m := by
  intro N
  induction N with
  | zero =>
    intro m hm y
    have hm0 : m = 0 := by simpa using hm
    subst hm0
    simp [cfTuples_zero]
  | succ N ih =>
    intro m hm y
    have hp0 : 0 < p := by omega
    have hdiv : m / p < p ^ N := by
      rw [Nat.div_lt_iff_lt_mul hp0, ← pow_succ]; exact hm
    have hsummand : ∀ c : Fin p → ℕ,
        ((∏ j ∈ Finset.range (N + 1),
              Nat.multinomial Finset.univ (fun i => dig p j (c i)) : ℕ) : R) *
            ∏ i, ∏ j ∈ Finset.range (N + 1), y i j ^ dig p j (c i) =
          (((Nat.multinomial Finset.univ (fun i => c i % p) : ℕ) : R) *
              ∏ i, y i 0 ^ (c i % p)) *
            (((∏ j ∈ Finset.range N,
                Nat.multinomial Finset.univ (fun i => dig p j (c i / p)) : ℕ) : R) *
              ∏ i, ∏ j ∈ Finset.range N, y i (j + 1) ^ dig p j (c i / p)) := by
      intro c
      simp only [Finset.prod_range_succ', dig_succ, dig_zero, Finset.prod_mul_distrib]
      push_cast
      ring
    refine (Finset.sum_congr rfl (fun c _ => hsummand c)).trans ?_
    refine (sum_cfTuples_divMod hp m (fun e c' =>
      (((Nat.multinomial Finset.univ e : ℕ) : R) * ∏ i, y i 0 ^ e i) *
        (((∏ j ∈ Finset.range N,
            Nat.multinomial Finset.univ (fun i => dig p j (c' i)) : ℕ) : R) *
          ∏ i, ∏ j ∈ Finset.range N, y i (j + 1) ^ dig p j (c' i)))).trans ?_
    rw [← Finset.sum_mul_sum, sum_antidiagonalTuple_multinomial,
      ih (m / p) hdiv (fun i j => y i (j + 1)), Finset.prod_range_succ']
    simp only [dig_succ, dig_zero]
    exact mul_comm _ _

/-- Regrouping a product over positions by the class of the position. -/
lemma prod_pow_class {M ι : Type*} [CommMonoid M] [Fintype ι] [DecidableEq ι] (κ : ℕ → ι)
    (N : ℕ) (f : ι → M) (g : ℕ → ℕ) :
    ∏ d, f d ^ (∑ j ∈ Finset.range N, if κ j = d then g j else 0) =
      ∏ j ∈ Finset.range N, f (κ j) ^ g j := by
  simp_rw [← Finset.prod_pow_eq_pow_sum]
  rw [Finset.prod_comm]
  refine Finset.prod_congr rfl (fun j _ => ?_)
  rw [Finset.prod_eq_single (κ j)]
  · simp
  · intro d _ hd
    simp [Ne.symm hd]
  · intro h
    exact absurd (Finset.mem_univ _) h

/-- The multinomial theorem for a product of powers of sums: the coefficients are the products
of multinomial coefficients, and the exponents are the `p`-tuples of multi-indices with sum `a`. -/
theorem prod_sum_pow_eq_sum_tuples {R ι : Type*} [CommSemiring R] [Fintype ι] [DecidableEq ι]
    (a : ι → ℕ) (x : Fin p → ι → R) :
    ∏ d, (∑ i, x i d) ^ a d =
      ∑ u ∈ (Fintype.piFinset fun _ : Fin p => Fintype.piFinset fun d =>
            Finset.range (a d + 1)).filter (fun u => ∑ i, u i = a),
        ((∏ d, Nat.multinomial Finset.univ (fun i => u i d) : ℕ) : R) *
          ∏ i, ∏ d, x i d ^ u i d := by
  have h1 : ∀ d, (∑ i, x i d) ^ a d =
      ∑ v ∈ Finset.Nat.antidiagonalTuple p (a d),
        ((Nat.multinomial Finset.univ v : ℕ) : R) * ∏ i, x i d ^ v i :=
    fun d => (sum_antidiagonalTuple_multinomial (fun i => x i d) (a d)).symm
  rw [Finset.prod_congr rfl (fun d _ => h1 d), Finset.prod_univ_sum]
  refine Finset.sum_nbij' (fun w i d => w d i) (fun u d i => u i d) ?_ ?_ ?_ ?_ ?_
  · intro w hw
    rw [Fintype.mem_piFinset] at hw
    have hw' : ∀ d, ∑ i, w d i = a d := fun d => Finset.Nat.mem_antidiagonalTuple.mp (hw d)
    rw [Finset.mem_filter, Fintype.mem_piFinset]
    refine ⟨fun i => Fintype.mem_piFinset.mpr (fun d => Finset.mem_range.mpr ?_), ?_⟩
    · have h2 : w d i ≤ ∑ i, w d i :=
        Finset.single_le_sum (f := fun i => w d i) (fun _ _ => Nat.zero_le _) (Finset.mem_univ i)
      have h3 := hw' d
      omega
    · funext d
      rw [Finset.sum_apply]
      exact hw' d
  · intro u hu
    rw [Finset.mem_filter] at hu
    rw [Fintype.mem_piFinset]
    intro d
    rw [Finset.Nat.mem_antidiagonalTuple]
    have h2 := congrFun hu.2 d
    rwa [Finset.sum_apply] at h2
  · intro w _
    rfl
  · intro u _
    rfl
  · intro w _
    rw [Finset.prod_mul_distrib, Nat.cast_prod]
    congr 1
    exact Finset.prod_comm

open MvPolynomial in
/-- **Comparing coefficients.** An identity between two integer combinations of monomials in the
variables `x i d` that holds in the polynomial ring holds with every monomial `∏ x i d ^ u i d`
replaced by an arbitrary integer `G u`. -/
theorem monomial_extract {ι κ α β : Type*} [Fintype ι] [Fintype κ] [DecidableEq ι]
    [DecidableEq κ] (A : Finset α) (B : Finset β) (n : α → ℕ) (n' : β → ℕ)
    (e : α → ι → κ → ℕ) (e' : β → ι → κ → ℕ)
    (h : ∀ x : ι → κ → MvPolynomial (ι × κ) ℤ,
      ∑ t ∈ A, (n t : MvPolynomial (ι × κ) ℤ) * ∏ i, ∏ d, x i d ^ e t i d =
        ∑ t ∈ B, (n' t : MvPolynomial (ι × κ) ℤ) * ∏ i, ∏ d, x i d ^ e' t i d)
    (G : (ι → κ → ℕ) → ℤ) :
    ∑ t ∈ A, (n t : ℤ) * G (e t) = ∑ t ∈ B, (n' t : ℤ) * G (e' t) := by
  classical
  let toFs : (ι → κ → ℕ) → (ι × κ →₀ ℕ) :=
    fun u => Finsupp.equivFunOnFinite.symm (fun q => u q.1 q.2)
  have hmono : ∀ u : ι → κ → ℕ,
      ∏ i, ∏ d, (X (i, d) : MvPolynomial (ι × κ) ℤ) ^ u i d = monomial (toFs u) 1 := by
    intro u
    rw [monomial_eq, C_1, one_mul, Finsupp.prod_fintype _ _ (fun _ => pow_zero _),
      Fintype.prod_prod_type]
    rfl
  let L : MvPolynomial (ι × κ) ℤ →ₗ[ℤ] ℤ :=
    (basisMonomials (ι × κ) ℤ).constr ℤ (fun s => G (fun i d => s (i, d)))
  have hL : ∀ u : ι → κ → ℕ, L (monomial (toFs u) 1) = G u := by
    intro u
    have h2 := (basisMonomials (ι × κ) ℤ).constr_basis ℤ (fun s => G (fun i d => s (i, d)))
      (toFs u)
    rw [coe_basisMonomials] at h2
    exact h2
  have h' := congrArg L (h (fun i d => X (i, d)))
  simp only [hmono, map_sum, ← nsmul_eq_mul, map_nsmul, hL] at h'
  simpa [nsmul_eq_mul] using h'

/-- The regrouping identity as an identity between monomials in a commutative semiring: both
sides are the expansion of `∏_d (∑_i x i d) ^ (class sum d of the digits of m)`. -/
theorem sum_cfTuples_poly (hp : 2 ≤ p) {R ι : Type*} [CommSemiring R] [Fintype ι]
    [DecidableEq ι] (κ : ℕ → ι) (N m : ℕ) (hm : m < p ^ N) (x : Fin p → ι → R) :
    ∑ c ∈ cfTuples p m,
        ((∏ j ∈ Finset.range N, Nat.multinomial Finset.univ (fun i => dig p j (c i)) : ℕ) : R) *
          ∏ i, ∏ d, x i d ^ (∑ j ∈ Finset.range N, if κ j = d then dig p j (c i) else 0) =
      ∑ u ∈ (Fintype.piFinset fun _ : Fin p => Fintype.piFinset fun d =>
            Finset.range ((∑ j ∈ Finset.range N, if κ j = d then dig p j m else 0) + 1)).filter
          (fun u => ∑ i, u i = fun d => ∑ j ∈ Finset.range N, if κ j = d then dig p j m else 0),
        ((∏ d, Nat.multinomial Finset.univ (fun i => u i d) : ℕ) : R) *
          ∏ i, ∏ d, x i d ^ u i d := by
  have h := sum_cfTuples_weighted hp N m hm (fun i j => x i (κ j))
  have h2 := prod_pow_class κ N (fun d => ∑ i, x i d) (fun j => dig p j m)
  have h3 := prod_sum_pow_eq_sum_tuples
    (fun d => ∑ j ∈ Finset.range N, if κ j = d then dig p j m else 0) x
  refine Eq.trans ?_ h3
  refine Eq.trans ?_ h2.symm
  refine Eq.trans ?_ h
  refine Finset.sum_congr rfl (fun c _ => ?_)
  refine congrArg (fun z => _ * z) ?_
  refine Finset.prod_congr rfl (fun i _ => ?_)
  exact prod_pow_class κ N (fun d => x i d) (fun j => dig p j (c i))

/-- **The regrouping identity.** Let the positions `j < N` be sorted into classes by `κ`. For an
arbitrary function `G` of a `p`-tuple of multi-indices, the sum over the carry-free `p`-tuples
`c` of `m`, with weights `∏_j multinomial (digits j of c)`, of `G` at the class sums of the digits
of the `c i`, is the sum over the `p`-tuples `u` of multi-indices whose sum is the vector of class
sums of the digits of `m`, with weights `∏_d multinomial (u · d)`, of `G u`. -/
theorem sum_cfTuples_regroup (hp : 2 ≤ p) {ι : Type*} [Fintype ι] [DecidableEq ι] (κ : ℕ → ι)
    (N m : ℕ) (hm : m < p ^ N) (G : (Fin p → ι → ℕ) → ℤ) :
    ∑ c ∈ cfTuples p m,
        ((∏ j ∈ Finset.range N, Nat.multinomial Finset.univ (fun i => dig p j (c i)) : ℕ) : ℤ) *
          G (fun i d => ∑ j ∈ Finset.range N, if κ j = d then dig p j (c i) else 0) =
      ∑ u ∈ (Fintype.piFinset fun _ : Fin p => Fintype.piFinset fun d =>
            Finset.range ((∑ j ∈ Finset.range N, if κ j = d then dig p j m else 0) + 1)).filter
          (fun u => ∑ i, u i = fun d => ∑ j ∈ Finset.range N, if κ j = d then dig p j m else 0),
        ((∏ d, Nat.multinomial Finset.univ (fun i => u i d) : ℕ) : ℤ) * G u := by
  have key : ∀ x : Fin p → ι → MvPolynomial (Fin p × ι) ℤ, _ :=
    fun x => sum_cfTuples_poly hp κ N m hm x
  -- the finite sets, coefficients and exponents are read off from `key` by unification
  have key2 := monomial_extract (ι := Fin p) (κ := ι) _ _ _ _ _ _ key G
  exact key2

end MMM.Frob

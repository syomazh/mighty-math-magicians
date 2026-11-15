/-
Started by Kimi K3.1 Pro (Open Math OS worker W040, cut off), continued by Claude Fable 5.2
(a subagent of the orchestrator), 2026-11-14. Not human-reviewed.
(Kimi K3.1 Pro wrote the five definitions, as given in the brief, and the first helper lemmas up
to `digitVec_eq_range`; Claude Fable 5.2 repaired those and wrote everything after them.)

Lemma "From the leading part to the labelled series" (`lem:subst` of `paper/frobenius_proof.tex`):

  `lead p (solution p k δ) m * ∏_j m_j! = T δ (a(m))`,

where `m_j` are the base-`p` digits of `m`, `a(m)` adds them up according to the residue class of
their position modulo `k`, and `T` is any family satisfying the recursion `LabelledRec` of the
coefficients of the labelled series `H_δ = z_(-δ) + H_(δ+1)^p / p`.

The note proves this through a ring homomorphism into an algebra with a carry-free product. Here
the proof is a direct strong induction on `m` (brief `briefs/W040_lean_frobenius_subst.md`):

* fact 1, `alpha_mul_digitFact`: the unit term;
* fact 2, `mem_cfTuples_iff_dig` (in `SubstDigits.lean`), `le_of_mem_cfTuples`,
  `digitVec_eq_sum_of_mem_cfTuples`, `digitFact_eq_of_mem_cfTuples`: carry-free tuples are digit
  matrices;
* fact 3, `sum_cfTuples_digitVec` and its special case `vandermonde_digits`: the regrouping
  identity. It is proved in `SubstVandermonde.lean` by comparing coefficients in two multinomial
  expansions of the same product, not through a Vandermonde identity;
* `lead_mul_digitFact`: the lemma.

No factorial valuation is used.
-/
import MMM.Frob.Lead
import MMM.DigitsFree
import MMM.Frob.SubstVandermonde
import Mathlib.Data.Nat.Choose.Multinomial
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace MMM.Frob

open Classical

/-- Base-p digits of a number, added up in each residue class of positions. -/
def digitVec (p k : ℕ) (m : ℕ) : ZMod k → ℕ :=
  fun c => ∑ j ∈ Finset.range (m + 1), if (j : ZMod k) = c then dig p j m else 0

/-- Product of the factorials of the base-p digits. -/
def digitFact (p m : ℕ) : ℕ := ∏ j ∈ Finset.range (m + 1), (dig p j m).factorial

/-- Bounded ordered tuples of multi-indices with prescribed sum. -/
def tuplesOf (p : ℕ) {ι : Type*} [Fintype ι] [DecidableEq ι] (a : ι → ℕ) :
    Finset (Fin p → ι → ℕ) :=
  (Fintype.piFinset fun _ : Fin p => Fintype.piFinset fun c => Finset.range (a c + 1)).filter
    (fun u => ∑ i, u i = a)

/-- The product of the componentwise multinomial coefficients. -/
def mmultinomial {p : ℕ} {ι : Type*} [Fintype ι] (u : Fin p → ι → ℕ) : ℕ :=
  ∏ c, Nat.multinomial Finset.univ (fun i => u i c)

/-- The coefficient recursion of the labelled exponential generating series. -/
def LabelledRec (p k : ℕ) [NeZero k] (T : ZMod k → (ZMod k → ℕ) → ℤ) : Prop :=
  (∀ δ, T δ 0 = 0) ∧
  ∀ δ a, (p : ℤ) * T δ a =
    (p : ℤ) * (if a = Pi.single (-δ) 1 then 1 else 0) +
      ∑ u ∈ tuplesOf p a, (mmultinomial u : ℤ) * ∏ i, T (δ + 1) (u i)

variable {p k m : ℕ}

/-! ### Digits beyond the length of a number -/

lemma lt_pow_succ (hp : 2 ≤ p) (m : ℕ) : m < p ^ (m + 1) :=
  (Nat.lt_pow_self (by omega)).trans_le (Nat.pow_le_pow_right (by omega) (by omega))

lemma ds_eq_sum_dig_range (hp : 2 ≤ p) (m : ℕ) :
    ds p m = ∑ j ∈ Finset.range (m + 1), dig p j m :=
  MMM.ds_eq_sum_dig hp (m + 1) m (lt_pow_succ hp m)

lemma digitVec_zero (p k : ℕ) : digitVec p k 0 = 0 := by
  funext c
  simp [digitVec]

lemma digitFact_zero (p : ℕ) : digitFact p 0 = 1 := by
  simp [digitFact]

/-- The range of positions in `digitFact` may be enlarged. -/
lemma digitFact_eq_range (hp : 2 ≤ p) {n N : ℕ} (h : n < N) :
    digitFact p n = ∏ j ∈ Finset.range N, (dig p j n).factorial := by
  unfold digitFact
  apply Finset.prod_subset
  · exact Finset.range_mono (by omega)
  · intro j hj hnj
    simp only [Finset.mem_range, not_lt] at hj hnj
    rw [dig_eq_zero_of_lt ((lt_pow_succ hp n).trans_le
      (Nat.pow_le_pow_right (by omega) (by omega))), Nat.factorial_zero]

/-- The range of positions in `digitVec` may be enlarged. -/
lemma digitVec_eq_range (hp : 2 ≤ p) {n N : ℕ} (h : n < N) (c : ZMod k) :
    digitVec p k n c = ∑ j ∈ Finset.range N, if (j : ZMod k) = c then dig p j n else 0 := by
  unfold digitVec
  apply Finset.sum_subset
  · exact Finset.range_mono (by omega)
  · intro j hj hnj
    simp only [Finset.mem_range, not_lt] at hj hnj
    rw [dig_eq_zero_of_lt ((lt_pow_succ hp n).trans_le
      (Nat.pow_le_pow_right (by omega) (by omega))), ite_self]

/-! ### Fact 1: the unit term -/

/-- The entries of `digitVec` add up to the digit sum. -/
lemma digitVec_sum_eq_ds (hp : 2 ≤ p) (k m : ℕ) [NeZero k] : ∑ c, digitVec p k m c = ds p m := by
  unfold digitVec
  rw [Finset.sum_comm]
  simp only [Finset.sum_ite_eq, Finset.mem_univ, ite_true]
  exact (ds_eq_sum_dig_range hp m).symm

lemma digitFact_pow (hp : 2 ≤ p) (j : ℕ) : digitFact p (p ^ j) = 1 := by
  unfold digitFact
  apply Finset.prod_eq_one
  intro i _
  rw [dig_pow hp]
  split_ifs <;> rfl

lemma digitVec_pow (hp : 2 ≤ p) (k j : ℕ) :
    digitVec p k (p ^ j) = Pi.single (j : ZMod k) 1 := by
  funext c
  unfold digitVec
  simp only [dig_pow hp]
  rw [Finset.sum_eq_single j]
  · by_cases hc : (j : ZMod k) = c
    · subst hc
      simp
    · simp [hc, Ne.symm hc]
  · intro i _ hi
    simp [Ne.symm hi]
  · intro h
    have h1 : j < p ^ j := Nat.lt_pow_self (by omega)
    exact absurd (Finset.mem_range.mpr (by omega)) h

/-- **Fact 1 (the unit term).** `α_δ(m) ∏_j m_j! = [a(m) = e_(-δ)]`. -/
theorem alpha_mul_digitFact (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ : ZMod k) (m : ℕ) :
    alpha p k δ m * (digitFact p m : ℤ) =
      if digitVec p k m = Pi.single (-δ) 1 then 1 else 0 := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  by_cases hpow : ∃ j : ℕ, m = p ^ j
  · obtain ⟨j, rfl⟩ := hpow
    rw [digitFact_pow hp, digitVec_pow hp]
    by_cases h : (j : ZMod k) + δ = 0
    · have hex : ∃ i : ℕ, p ^ j = p ^ i ∧ (i : ZMod k) + δ = 0 := ⟨j, rfl, h⟩
      have hα : alpha p k δ (p ^ j) = 1 := by
        unfold alpha
        exact ite_eq_left hex
      have hj : (j : ZMod k) = -δ := eq_neg_of_add_eq_zero_left h
      rw [hα, hj, ite_eq_left rfl]
      simp
    · have hex : ¬∃ i : ℕ, p ^ j = p ^ i ∧ (i : ZMod k) + δ = 0 := by
        rintro ⟨i, hi, hiδ⟩
        have hji : j = i := pow_inj hp hi
        subst hji
        exact h hiδ
      have hα : alpha p k δ (p ^ j) = 0 := by
        unfold alpha
        exact ite_eq_right hex
      have hne : ¬(Pi.single (j : ZMod k) 1 : ZMod k → ℕ) = Pi.single (-δ) 1 := by
        intro heq
        have h1 := congrFun heq (j : ZMod k)
        rw [Pi.single_eq_same] at h1
        by_cases hj : (j : ZMod k) = -δ
        · exact h (by rw [hj]; simp)
        · rw [Pi.single_eq_of_ne hj] at h1
          exact one_ne_zero h1
      rw [hα, ite_eq_right hne, zero_mul]
  · rw [alpha_of_non_power hpow, zero_mul, ite_eq_right]
    intro heq
    apply hpow
    have hds : ds p m = 1 := by
      rw [← digitVec_sum_eq_ds hp k m, heq]
      simp
    exact eq_pow_of_ds_eq_one hp m hds

/-! ### Fact 2: carry-free tuples are digit matrices

`mem_cfTuples_iff_dig` (`SubstDigits.lean`): a tuple with sum `m` is in the index set of `cfpow`
exactly when the digits add up position by position; `le_of_mem_cfTuples`: its entries are at
most `m`. -/

/-- `cfpow` is a sum over `cfTuples`. -/
lemma cfpow_eq_sum_cfTuples (p : ℕ) (g : ℕ → ℤ) (m : ℕ) :
    cfpow p g m = ∑ c ∈ cfTuples p m, ∏ i, g (c i) := rfl

/-- **Fact 2.** For a carry-free tuple, `a(m) = ∑_i a(c_i)`. -/
theorem digitVec_eq_sum_of_mem_cfTuples (hp : 2 ≤ p) (k : ℕ) {c : Fin p → ℕ}
    (hc : c ∈ cfTuples p m) : digitVec p k m = ∑ i, digitVec p k (c i) := by
  funext d
  rw [Finset.sum_apply]
  have h1 : ∀ i, digitVec p k (c i) d =
      ∑ j ∈ Finset.range (m + 1), if (j : ZMod k) = d then dig p j (c i) else 0 :=
    fun i => digitVec_eq_range hp (Nat.lt_succ_of_le (le_of_mem_cfTuples hc i)) d
  rw [Finset.sum_congr rfl (fun i _ => h1 i), Finset.sum_comm]
  show (∑ j ∈ Finset.range (m + 1), if (j : ZMod k) = d then dig p j m else 0) = _
  refine Finset.sum_congr rfl (fun j _ => ?_)
  by_cases hj : (j : ZMod k) = d
  · simp only [ite_eq_left hj]
    exact (sum_dig_of_mem_cfTuples hp hc j).symm
  · simp only [ite_eq_right hj]
    simp

/-- **Fact 2.** For a carry-free tuple, `∏_j m_j!` is the product of the multinomial coefficients
of the columns of digits, times the `∏_j (c_i)_j!`. -/
theorem digitFact_eq_of_mem_cfTuples (hp : 2 ≤ p) {c : Fin p → ℕ} (hc : c ∈ cfTuples p m) :
    digitFact p m =
      (∏ j ∈ Finset.range (m + 1), Nat.multinomial Finset.univ (fun i => dig p j (c i))) *
        ∏ i, digitFact p (c i) := by
  have h1 : ∀ i, digitFact p (c i) = ∏ j ∈ Finset.range (m + 1), (dig p j (c i)).factorial :=
    fun i => digitFact_eq_range hp (Nat.lt_succ_of_le (le_of_mem_cfTuples hc i))
  rw [Finset.prod_congr rfl (fun i _ => h1 i)]
  exact prod_factorial_dig_of_mem_cfTuples hp hc (m + 1)

/-! ### Fact 3: regrouping -/

/-- **Fact 3 (regrouping), for an arbitrary function `G`.** The sum over the carry-free tuples
`c` of `m`, weighted by the multinomial coefficients of the columns of digits, of `G (a(c_i))_i`,
is the sum over the splittings `u` of `a(m)`, weighted by `mmultinomial u`, of `G u`. -/
theorem sum_cfTuples_digitVec (hp : 2 ≤ p) (k : ℕ) [NeZero k] (m : ℕ)
    (G : (Fin p → ZMod k → ℕ) → ℤ) :
    ∑ c ∈ cfTuples p m,
        ((∏ j ∈ Finset.range (m + 1),
            Nat.multinomial Finset.univ (fun i => dig p j (c i)) : ℕ) : ℤ) *
          G (fun i => digitVec p k (c i)) =
      ∑ u ∈ tuplesOf p (digitVec p k m), (mmultinomial u : ℤ) * G u := by
  have h := sum_cfTuples_regroup hp (fun j : ℕ => (j : ZMod k)) (m + 1) m (lt_pow_succ hp m) G
  refine Eq.trans ?_ h
  refine Finset.sum_congr rfl (fun c hc => ?_)
  have hL : (fun i => digitVec p k (c i)) = (fun i d =>
      ∑ j ∈ Finset.range (m + 1), if (j : ZMod k) = d then dig p j (c i) else 0) := by
    funext i d
    exact digitVec_eq_range hp (Nat.lt_succ_of_le (le_of_mem_cfTuples hc i)) d
  rw [hL]

/-- **Fact 3 (regrouping), as in the brief.** For a splitting `u` of `a(m)`, the multinomial
coefficients of the columns of digits, added up over the carry-free tuples `c` of `m` with
`a(c_i) = u_i` for all `i`, give `mmultinomial u`. -/
theorem vandermonde_digits (hp : 2 ≤ p) (k : ℕ) [NeZero k] (m : ℕ) (u : Fin p → ZMod k → ℕ)
    (hu : u ∈ tuplesOf p (digitVec p k m)) :
    ∑ c ∈ (cfTuples p m).filter (fun c => ∀ i, digitVec p k (c i) = u i),
        ∏ j ∈ Finset.range (m + 1), Nat.multinomial Finset.univ (fun i => dig p j (c i)) =
      mmultinomial u := by
  have h := sum_cfTuples_digitVec hp k m (fun v => if v = u then 1 else 0)
  have hL : ∑ c ∈ cfTuples p m,
        ((∏ j ∈ Finset.range (m + 1),
            Nat.multinomial Finset.univ (fun i => dig p j (c i)) : ℕ) : ℤ) *
          (if (fun i => digitVec p k (c i)) = u then 1 else 0) =
      ((∑ c ∈ (cfTuples p m).filter (fun c => ∀ i, digitVec p k (c i) = u i),
        ∏ j ∈ Finset.range (m + 1),
          Nat.multinomial Finset.univ (fun i => dig p j (c i)) : ℕ) : ℤ) := by
    rw [Finset.sum_filter, Nat.cast_sum]
    refine Finset.sum_congr rfl (fun c _ => ?_)
    by_cases hc : ∀ i, digitVec p k (c i) = u i
    · rw [ite_eq_left (funext hc), ite_eq_left hc, mul_one]
    · rw [ite_eq_right (fun h' => hc (fun i => congrFun h' i)), ite_eq_right hc, mul_zero,
        Nat.cast_zero]
  have hR : ∑ v ∈ tuplesOf p (digitVec p k m),
        (mmultinomial v : ℤ) * (if v = u then 1 else 0) = (mmultinomial u : ℤ) := by
    rw [Finset.sum_eq_single u]
    · rw [ite_eq_left rfl, mul_one]
    · intro v _ hv
      rw [ite_eq_right hv, mul_zero]
    · intro h'
      exact absurd hu h'
  have h2 := hL.symm.trans (h.trans hR)
  exact_mod_cast h2

/-! ### The lemma -/

/-- **Lemma "From the leading part to the labelled series"** (`lem:subst`):
`ℓ_δ(m) ∏_j m_j! = T_δ(a(m))`, for every family `T` satisfying the recursion of the labelled
series. Strong induction on `m`, for all `δ` at once, from `lead_solution` and facts 1, 2, 3. -/
theorem lead_mul_digitFact (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k]
    (T : ZMod k → (ZMod k → ℕ) → ℤ) (hT : LabelledRec p k T) (δ : ZMod k) (m : ℕ) :
    lead p (solution p k δ) m * (digitFact p m : ℤ) = T δ (digitVec p k m) := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  induction m using Nat.strong_induction_on generalizing δ with
  | _ m ih =>
    rcases Nat.eq_zero_or_pos m with rfl | hm
    · have h0 : lead p (solution p k δ) 0 = 0 := by simp [lead]
      rw [digitVec_zero, hT.1 δ, h0, zero_mul]
    · have hp0 : (p : ℤ) ≠ 0 := by exact_mod_cast (by omega : p ≠ 0)
      apply mul_left_cancel₀ hp0
      rw [hT.2 δ (digitVec p k m), ← mul_assoc, lead_solution, add_mul, mul_assoc,
        alpha_mul_digitFact]
      congr 1
      refine Eq.trans ?_ (sum_cfTuples_digitVec hp k m (fun u => ∏ i, T (δ + 1) (u i)))
      rw [cfpow_eq_sum_cfTuples, Finset.sum_mul]
      refine Finset.sum_congr rfl (fun c hc => ?_)
      have hprod : ∏ i, (lead p (solution p k (δ + 1)) (c i) * (digitFact p (c i) : ℤ)) =
          ∏ i, T (δ + 1) (digitVec p k (c i)) := by
        by_cases h0 : ∃ i, c i = 0
        · -- an entry 0: both products vanish
          obtain ⟨i0, hi0⟩ := h0
          have h1 : lead p (solution p k (δ + 1)) (c i0) * (digitFact p (c i0) : ℤ) = 0 := by
            rw [hi0]
            simp [lead]
          have h2 : T (δ + 1) (digitVec p k (c i0)) = 0 := by
            rw [hi0, digitVec_zero]
            exact hT.1 (δ + 1)
          rw [Finset.prod_eq_zero (Finset.mem_univ i0) h1,
            Finset.prod_eq_zero (Finset.mem_univ i0) h2]
        · -- all entries positive: they are smaller than `m`, and the induction applies
          refine Finset.prod_congr rfl (fun i _ => ih (c i) ?_ (δ + 1))
          have : Nontrivial (Fin p) := Fin.nontrivial_iff_two_le.mpr hp
          obtain ⟨i', hi'⟩ := exists_ne i
          have hsum : ∑ x, c x = m := (mem_cfTuples.mp hc).1
          have hsplit := Finset.add_sum_erase Finset.univ c (Finset.mem_univ i)
          have hle : c i' ≤ ∑ x ∈ Finset.univ.erase i, c x :=
            Finset.single_le_sum (fun _ _ => Nat.zero_le _)
              (Finset.mem_erase.mpr ⟨hi', Finset.mem_univ i'⟩)
          have hpos : c i' ≠ 0 := fun h => h0 ⟨i', h⟩
          omega
      show (∏ i, lead p (solution p k (δ + 1)) (c i)) * (digitFact p m : ℤ) =
        ((∏ j ∈ Finset.range (m + 1),
            Nat.multinomial Finset.univ (fun i => dig p j (c i)) : ℕ) : ℤ) *
          ∏ i, T (δ + 1) (digitVec p k (c i))
      rw [digitFact_eq_of_mem_cfTuples hp hc, ← hprod, Finset.prod_mul_distrib]
      push_cast
      ring

#print axioms lead_mul_digitFact

end MMM.Frob

/-
Written by Kimi K3.1 Pro (AI, worker W035), 2026-11-14. Not human-reviewed.

The generating function of blocked p-ary trees, its cyclic coefficient system,
uniqueness of that system, and the identification with the specialised Frobenius
solution at y = p.
-/
import MMM.Blocked
import MMM.Reduction
import MMM.Frob.Special
import Mathlib.Data.Fin.Tuple.NatAntidiagonal
import Mathlib.Algebra.Order.Antidiag.Pi
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Finsupp.Fin

set_option maxHeartbeats 800000

namespace MMM.Frob

open MMM MMM.PTree
open Finset

/-- Generating function of the p-ary trees whose leaves, seen from offset δ, all sit at a depth
divisible by k: the coefficient of x^m is the number of such trees with m leaves. -/
noncomputable def treeGF (p k δ : ℕ) : PowerSeries ℤ :=
  PowerSeries.mk fun m => (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} : ℤ)

variable {p k δ m : ℕ}

theorem finiteBlocked (hp : 2 ≤ p) (k δ m : ℕ) :
    Finite {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} := by
  have hsub : {T : PTree p | T.leaves = m ∧ BlockedAt k δ T}.Finite :=
    (finite_leaves_eq hp m).subset (fun _ h => h.1)
  exact hsub.to_subtype

@[simp] theorem treeGF_coeff (p k δ m : ℕ) :
    (treeGF p k δ).coeff m =
      (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} : ℤ) := by
  simp [treeGF]

theorem treeGF_coeff_zero (hp : 2 ≤ p) : (treeGF p k δ).coeff 0 = 0 := by
  rw [treeGF_coeff]
  have h : IsEmpty {T : PTree p // T.leaves = 0 ∧ BlockedAt k δ T} := by
    refine ⟨fun T => ?_⟩
    haveI : NeZero p := ⟨by omega⟩
    have hpos := leaves_pos T.1
    rw [T.2.1] at hpos
    exact Nat.not_lt_zero _ hpos
  simp [Nat.card_eq_zero.mpr (Or.inl h)]


/-- Extend a tuple by zero to a finitely supported function. -/
noncomputable def finsuppOfTuple (u : Fin p → ℕ) : ℕ →₀ ℕ :=
  Finsupp.onFinset (range p) (fun i => if h : i < p then u ⟨i, h⟩ else 0)
    (fun i => by
      simp only [mem_range]
      intro hi
      by_contra hnot
      simp only [dif_neg hnot, ne_eq, not_true_eq_false] at hi)

@[simp] theorem finsuppOfTuple_apply_lt (u : Fin p → ℕ) (i : ℕ) (hi : i < p) :
    finsuppOfTuple u i = u ⟨i, hi⟩ := by
  simp [finsuppOfTuple, Finsupp.onFinset_apply, dif_pos hi]

@[simp] theorem finsuppOfTuple_apply_ge (u : Fin p → ℕ) (i : ℕ) (hi : ¬ i < p) :
    finsuppOfTuple u i = 0 := by
  classical
  simp [finsuppOfTuple, Finsupp.onFinset_apply, dif_neg hi]

@[simp] theorem finsuppOfTuple_coe (u : Fin p → ℕ) (i : Fin p) :
    finsuppOfTuple u (i : ℕ) = u i := by
  convert finsuppOfTuple_apply_lt u i i.isLt

@[simp] theorem finsuppOfTuple_tupleOfFinsupp {l : ℕ →₀ ℕ}
    (hl : l.support ⊆ range p) :
    finsuppOfTuple (p := p) (fun i : Fin p => l i) = l := by
  ext i
  by_cases hi : i < p
  · rw [finsuppOfTuple_apply_lt _ _ hi]
  · rw [finsuppOfTuple_apply_ge _ _ hi]
    exact (Finsupp.notMem_support_iff.mp (fun hmem => hi (mem_range.mp (hl hmem)))).symm

@[simp] theorem finsuppOfTuple_support (u : Fin p → ℕ) :
    (finsuppOfTuple u).support ⊆ range p := by
  intro i hi
  rw [mem_range]
  by_contra h
  exact (Finsupp.mem_support_iff.mp hi) (finsuppOfTuple_apply_ge u i h)

@[simp] theorem sum_finsuppOfTuple (u : Fin p → ℕ) :
    ∑ i ∈ range p, finsuppOfTuple u i = ∑ i, u i := by
  rw [← Fin.sum_univ_eq_sum_range (fun i => finsuppOfTuple u i) p]
  apply Finset.sum_congr rfl
  intro i _
  exact finsuppOfTuple_coe u i

@[simp] theorem mem_finsuppAntidiag_finsuppOfTuple {u : Fin p → ℕ} {m : ℕ} :
    finsuppOfTuple u ∈ finsuppAntidiag (range p) m ↔ ∑ i, u i = m := by
  rw [mem_finsuppAntidiag, and_iff_left (finsuppOfTuple_support u), sum_finsuppOfTuple]

@[simp] theorem sum_tupleOfFinsupp {l : ℕ →₀ ℕ} {m : ℕ}
    (hl : l ∈ finsuppAntidiag (range p) m) : ∑ i : Fin p, l i = m := by
  rw [← sum_finsuppOfTuple (p := p) (fun i => l i),
    finsuppOfTuple_tupleOfFinsupp (mem_finsuppAntidiag.mp hl).2]
  exact (mem_finsuppAntidiag.mp hl).1

noncomputable instance fintypeTupleSum (p m : ℕ) : Fintype {u : Fin p → ℕ // ∑ i, u i = m} := by
  classical
  let s : Finset (Fin p → ℕ) := Nat.antidiagonalTuple p m
  have hsub : {u : Fin p → ℕ // ∑ i, u i = m} ≃ ↥s :=
    { toFun := fun u => ⟨u.1, Finset.Nat.mem_antidiagonalTuple.mpr u.2⟩
      invFun := fun u => ⟨u.1, Finset.Nat.mem_antidiagonalTuple.mp u.2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  exact Fintype.ofEquiv ↥s hsub.symm

lemma coeff_pow_tuple (f : PowerSeries ℤ) (p m : ℕ) :
    (f ^ p).coeff m =
      ∑ u : {u : Fin p → ℕ // ∑ i, u i = m}, ∏ i, f.coeff (u.1 i) := by
  classical
  letI := fintypeTupleSum p m
  rw [PowerSeries.coeff_pow]
  let g : (Fin p → ℕ) → ℤ := fun u => ∏ i, f.coeff (u i)
  calc
    (∑ l ∈ finsuppAntidiag (range p) m, ∏ i ∈ range p, f.coeff (l i)) =
        ∑ l ∈ (finsuppAntidiag (range p) m).attach, g (fun i : Fin p => l.1 i) := by
      rw [← Finset.sum_attach]
      apply Finset.sum_congr rfl
      intro l hl
      dsimp [g]
      apply Finset.prod_bij (fun i _ => (⟨i, by simpa using ‹i ∈ range p›⟩ : Fin p))
      · intro i hi
        simp
      · intro i hi j hj heq
        exact Fin.ext_iff.mp heq
      · intro j hj
        exact ⟨(j : ℕ), mem_range.mpr j.isLt, rfl⟩
      · intro i hi
        rfl
    _ = ∑ u : {u : Fin p → ℕ // ∑ i, u i = m}, g u.1 := by
      let e : {l : ℕ →₀ ℕ // l ∈ finsuppAntidiag (range p) m} ≃
          {u : Fin p → ℕ // ∑ i, u i = m} :=
        { toFun := fun l => ⟨fun i : Fin p => l.1 i, sum_tupleOfFinsupp l.2⟩
          invFun := fun u => ⟨finsuppOfTuple u.1,
            mem_finsuppAntidiag_finsuppOfTuple.mpr u.2⟩
          left_inv := by
            intro l
            apply Subtype.ext
            exact finsuppOfTuple_tupleOfFinsupp (mem_finsuppAntidiag.mp l.2).2
          right_inv := by
            intro u
            apply Subtype.ext
            funext i
            exact finsuppOfTuple_coe u.1 i }
      exact Fintype.sum_equiv e _ _ (fun l => rfl)
    _ = ∑ u : {u : Fin p → ℕ // ∑ i, u i = m}, ∏ i, f.coeff (u.1 i) := rfl


/-- Split a tree with `m` leaves, blocked at `δ`, into a leaf or a family of blocked subtrees. -/
noncomputable def blockedTreeEquiv (hp : 2 ≤ p) (k δ m : ℕ) :
    {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} ≃
      ({u : Unit // k ∣ δ ∧ m = 1}) ⊕
        {f : Fin p → PTree p // (∀ i, BlockedAt k (δ + 1) (f i)) ∧
          (∑ i, (f i).leaves = m)} := by
  classical
  let A := {T : PTree p // T.leaves = m ∧ BlockedAt k δ T}
  let B := {u : Unit // k ∣ δ ∧ m = 1}
  let C := {f : Fin p → PTree p // (∀ i, BlockedAt k (δ + 1) (f i)) ∧
    (∑ i, (f i).leaves = m)}
  let e : A ≃ B ⊕ C :=
    { toFun := fun T => by
        cases hT : T.1 with
        | leaf =>
          apply Sum.inl
          refine ⟨(), ?_⟩
          have hb : BlockedAt (p := p) k δ PTree.leaf := by simpa [hT] using T.2.2
          have hl : m = 1 := by simpa [hT] using T.2.1.symm
          exact ⟨hb, hl⟩
        | node f =>
          apply Sum.inr
          refine ⟨f, ?_, ?_⟩
          · have hb : BlockedAt k δ (PTree.node f) := by simpa [hT] using T.2.2
            exact hb
          · have hl : (PTree.node f).leaves = m := by simpa [hT] using T.2.1
            simpa using hl
      invFun := fun x => match x with
        | Sum.inl u => ⟨PTree.leaf, by
            have hu : k ∣ δ ∧ m = 1 := u.2
            exact ⟨by simpa [hu.2], hu.1⟩⟩
        | Sum.inr f => ⟨PTree.node f.1, by simpa using f.2.2, f.2.1⟩
      left_inv := by
        rintro ⟨T, hT⟩
        cases T with
        | leaf => rfl
        | node f => rfl
      right_inv := by
        rintro (u | f)
        · rfl
        · rfl }
  exact e

theorem card_leaf_condition (k δ m : ℕ) :
    Nat.card {u : Unit // k ∣ δ ∧ m = 1} = if k ∣ δ ∧ m = 1 then 1 else 0 := by
  by_cases h : k ∣ δ ∧ m = 1
  · rw [if_pos h]
    apply Nat.card_eq_one_iff_unique.mpr
    refine ⟨⟨fun a b => ?_⟩, ⟨⟨(), h⟩⟩⟩
    apply Subtype.ext
    cases a
    cases b
    rfl
  · rw [if_neg h]
    apply Nat.card_eq_zero.mpr
    left
    exact ⟨fun u => h u.2⟩

/-- Tuples of blocked subtrees with a fixed leaf composition, equivalent to functions from
`Fin p` into the corresponding blocked-tree subtypes. -/
noncomputable def forestOfCompEquiv (hp : 2 ≤ p) (k δ : ℕ) (u : Fin p → ℕ) :
    {f : Fin p → PTree p // (∀ i, (f i).leaves = u i) ∧ (∀ i, BlockedAt k δ (f i))} ≃
      (∀ i : Fin p, {T : PTree p // T.leaves = u i ∧ BlockedAt k δ T}) :=
  { toFun := fun f i => ⟨f.1 i, f.2.1 i, f.2.2 i⟩
    invFun := fun g => ⟨fun i => (g i).1, fun i => (g i).2.1, fun i => (g i).2.2⟩
    left_inv := by
      intro f
      rfl
    right_inv := by
      intro g
      funext i
      rfl }

theorem card_forestOfComp (hp : 2 ≤ p) (k δ : ℕ) (u : Fin p → ℕ) :
    Nat.card {f : Fin p → PTree p // (∀ i, (f i).leaves = u i) ∧
      (∀ i, BlockedAt k δ (f i))} =
      ∏ i, Nat.card {T : PTree p // T.leaves = u i ∧ BlockedAt k δ T} := by
  classical
  rw [Nat.card_congr (forestOfCompEquiv hp k δ u)]
  exact Nat.card_pi

theorem finiteForestComp (hp : 2 ≤ p) (k δ : ℕ) (u : Fin p → ℕ) :
    Finite {f : Fin p → PTree p // (∀ i, (f i).leaves = u i) ∧
      (∀ i, BlockedAt k δ (f i))} := by
  classical
  letI (i : Fin p) : Finite {T : PTree p // T.leaves = u i ∧ BlockedAt k δ T} :=
    finiteBlocked hp k δ (u i)
  haveI : Finite (∀ i : Fin p, {T : PTree p // T.leaves = u i ∧ BlockedAt k δ T}) :=
    Pi.finite
  exact (forestOfCompEquiv hp k δ u).finite_iff.mpr inferInstance

noncomputable def fintypeForestComp (hp : 2 ≤ p) (k δ : ℕ) (u : Fin p → ℕ) :
    Fintype {f : Fin p → PTree p // (∀ i, (f i).leaves = u i) ∧
      (∀ i, BlockedAt k δ (f i))} := by
  letI := finiteForestComp hp k δ u
  exact Fintype.ofFinite _


/-- Node forests with a fixed total number of leaves split according to their leaf composition. -/
noncomputable def nodeForestFiberEquiv (hp : 2 ≤ p) (k δ m : ℕ) :
    {f : Fin p → PTree p // (∀ i, BlockedAt k δ (f i)) ∧ ∑ i, (f i).leaves = m} ≃
      Σ u : {u : Fin p → ℕ // ∑ i, u i = m},
        {f : Fin p → PTree p // (∀ i, (f i).leaves = u.1 i) ∧
          (∀ i, BlockedAt k δ (f i))} := by
  classical
  exact
    { toFun := fun f =>
        ⟨⟨fun i => (f.1 i).leaves, f.2.2⟩,
          ⟨f.1, fun i => rfl, f.2.1⟩⟩
      invFun := fun x =>
        ⟨x.2.1, x.2.2.2, by
          have h := x.1.2
          simp only [← x.2.2.1] at h
          exact h⟩
      left_inv := by
        intro f
        rfl
      right_inv := by
        rintro ⟨⟨u, hu⟩, ⟨f, hf, hb⟩⟩
        have huf : ∀ i, (f i).leaves = u i := hf
        have hu' : u = fun i => (f i).leaves := by
          funext i
          exact (huf i).symm
        subst hu'
        rfl }
theorem finiteNodeForest (hp : 2 ≤ p) (k δ m : ℕ) :
    Finite {f : Fin p → PTree p // (∀ i, BlockedAt k δ (f i)) ∧ ∑ i, (f i).leaves = m} := by
  classical
  letI := fintypeTupleSum p m
  letI (u : {u : Fin p → ℕ // ∑ i, u i = m}) :
      Finite {f : Fin p → PTree p // (∀ i, (f i).leaves = u.1 i) ∧
        (∀ i, BlockedAt k δ (f i))} := by
    letI (i : Fin p) : Finite {T : PTree p // T.leaves = u.1 i ∧ BlockedAt k δ T} :=
      finiteBlocked hp k δ (u.1 i)
    haveI : Finite (∀ i : Fin p, {T : PTree p // T.leaves = u.1 i ∧ BlockedAt k δ T}) :=
      Pi.finite
    exact (forestOfCompEquiv hp k δ u.1).finite_iff.mpr inferInstance
  exact (nodeForestFiberEquiv hp k δ m).finite_iff.mpr inferInstance

theorem treeGF_eq (hp : 2 ≤ p) (k δ : ℕ) :
    treeGF p k δ = (if k ∣ δ then PowerSeries.X else 0) + (treeGF p k (δ + 1)) ^ p := by
  classical
  apply PowerSeries.ext
  intro m
  letI : Finite {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} := finiteBlocked hp k δ m
  letI : Finite {f : Fin p → PTree p // (∀ i, BlockedAt k (δ + 1) (f i)) ∧
    ∑ i, (f i).leaves = m} := finiteNodeForest hp k (δ + 1) m
  have hcard : Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k δ T} =
      Nat.card {u : Unit // k ∣ δ ∧ m = 1} +
        Nat.card {f : Fin p → PTree p // (∀ i, BlockedAt k (δ + 1) (f i)) ∧
          ∑ i, (f i).leaves = m} := by
    rw [← Nat.card_sum]
    exact Nat.card_congr (blockedTreeEquiv hp k δ m)
  have hnode : Nat.card {f : Fin p → PTree p // (∀ i, BlockedAt k (δ + 1) (f i)) ∧
      ∑ i, (f i).leaves = m} =
      ∑ u : {u : Fin p → ℕ // ∑ i, u i = m},
        Nat.card {f : Fin p → PTree p // (∀ i, (f i).leaves = u.1 i) ∧
          (∀ i, BlockedAt k (δ + 1) (f i))} := by
    letI := fintypeTupleSum p m
    letI (u : {u : Fin p → ℕ // ∑ i, u i = m}) :
        Finite {f : Fin p → PTree p // (∀ i, (f i).leaves = u.1 i) ∧
          (∀ i, BlockedAt k (δ + 1) (f i))} := finiteForestComp hp k (δ + 1) u.1
    rw [Nat.card_congr (nodeForestFiberEquiv hp k (δ + 1) m), Nat.card_sigma]
  rw [treeGF_coeff, map_add, coeff_pow_tuple]
  have hX : ((if k ∣ δ then PowerSeries.X else 0 : PowerSeries ℤ).coeff m) =
      (if k ∣ δ then (if m = 1 then (1 : ℤ) else 0) else 0) := by
    by_cases h : k ∣ δ
    · rw [if_pos h, if_pos h]
      exact PowerSeries.coeff_X m
    · rw [if_neg h, if_neg h]
      rfl
  rw [hX]
  have hleaf : (Nat.card {u : Unit // k ∣ δ ∧ m = 1} : ℤ) =
      ((if k ∣ δ then (if m = 1 then (1 : ℤ) else 0) else 0)) := by
    rw [card_leaf_condition]
    by_cases h : k ∣ δ ∧ m = 1
    · simp [h, h.1, h.2]
    · simp [h]
      by_cases hkd : k ∣ δ
      · simp [hkd]
        intro hm
        exact h ⟨hkd, hm⟩
      · simp [hkd]
  have hnode' : (Nat.card {f : Fin p → PTree p // (∀ i, BlockedAt k (δ + 1) (f i)) ∧
      ∑ i, (f i).leaves = m} : ℤ) =
      ∑ u : {u : Fin p → ℕ // ∑ i, u i = m},
        ∏ i, (treeGF p k (δ + 1)).coeff (u.1 i) := by
    rw [hnode]
    push_cast
    apply Finset.sum_congr rfl
    intro u _
    rw [card_forestOfComp hp]
    simp [treeGF_coeff]
  rw [hcard]
  push_cast
  rw [hleaf, hnode']

/-- Shifting the offset by the period does not change whether a tree is blocked. -/
theorem blockedAt_add_period (k δ : ℕ) (T : PTree p) :
    BlockedAt k (δ + k) T ↔ BlockedAt k δ T := by
  induction T generalizing δ with
  | leaf => simp [BlockedAt, Nat.dvd_add_self_right]
  | node f ih =>
    simp only [BlockedAt]
    constructor
    · intro h i
      apply (ih i (δ + 1)).mp
      simpa only [add_assoc, add_comm k 1] using h i
    · intro h i
      convert (ih i (δ + 1)).mpr (h i) using 1 <;> omega

theorem treeGF_add_period (k δ : ℕ) : treeGF p k (δ + k) = treeGF p k δ := by
  apply PowerSeries.ext
  intro m
  simp only [treeGF_coeff, blockedAt_add_period]

/-- Positive coefficients of a power of two zero-constant series depend only on lower
coefficients, provided the exponent is at least two. -/
lemma coeff_pow_lower_nat {p m : ℕ} (hp : 2 ≤ p) {f g : PowerSeries ℤ}
    (_hm : 0 < m) (hf : f.coeff 0 = 0) (hg : g.coeff 0 = 0)
    (h : ∀ j < m, f.coeff j = g.coeff j) :
    (f ^ p).coeff m = (g ^ p).coeff m := by
  classical
  rw [coeff_pow_tuple, coeff_pow_tuple]
  apply Finset.sum_congr rfl
  intro u hu
  by_cases hz : ∃ i, u.1 i = 0
  · obtain ⟨i, hi⟩ := hz
    have hzero (r : PowerSeries ℤ) (hr : r.coeff 0 = 0) :
        ∏ j, r.coeff (u.1 j) = 0 := by
      apply Finset.prod_eq_zero (Finset.mem_univ i)
      rw [hi]
      exact hr
    rw [hzero f hf, hzero g hg]
  · push Not at hz
    apply Finset.prod_congr rfl
    intro i _
    apply h
    have hlt : u.1 i < ∑ j, u.1 j := by
      obtain ⟨j, hj⟩ : ∃ j : Fin p, j ≠ i := by
        by_contra hall
        push Not at hall
        have hcard : Fintype.card (Fin p) = 1 := by
          rw [Fintype.card_eq_one_iff]
          exact ⟨i, fun j => hall j⟩
        simp only [Fintype.card_fin] at hcard
        omega
      rw [← Finset.sum_erase_add _ _ (Finset.mem_univ i)]
      have hpos : 0 < ∑ j ∈ Finset.univ.erase i, u.1 j := by
        apply Finset.sum_pos
        · intro j _
          exact Nat.pos_of_ne_zero (hz j)
        · exact ⟨j, Finset.mem_erase.mpr ⟨hj, Finset.mem_univ j⟩⟩
      omega
    simpa only [u.2] using hlt

/-- Uniqueness for the specialised system: two families of integer power series without constant
term that satisfy `G δ = [k ∣ δ] x + (G (δ + 1))^p` are equal. -/
theorem treeSystem_unique (hp : 2 ≤ p) {G H : ℕ → PowerSeries ℤ}
    (hG0 : ∀ δ, (G δ).coeff 0 = 0) (hH0 : ∀ δ, (H δ).coeff 0 = 0)
    (hG : ∀ δ, G δ = (if k ∣ δ then PowerSeries.X else 0) + (G (δ + 1)) ^ p)
    (hH : ∀ δ, H δ = (if k ∣ δ then PowerSeries.X else 0) + (H (δ + 1)) ^ p) : G = H := by
  funext δ
  apply PowerSeries.ext
  intro m
  induction m using Nat.strong_induction_on generalizing δ with
  | ind m ih =>
    by_cases hm : m = 0
    · subst m
      rw [hG0, hH0]
    rw [hG δ, hH δ, map_add, map_add]
    congr 1
    apply coeff_pow_lower_nat hp (m := m)
    · exact Nat.pos_of_ne_zero hm
    · exact hG0 _
    · exact hH0 _
    · intro j hj
      exact ih j hj (δ + 1)

/-- The note's `F_0(x, p) = G(x)`, for every offset. -/
theorem evalY_solution_eq_treeGF (p : ℕ) [Fact p.Prime] (k : ℕ) [NeZero k] (δ : ℕ) :
    evalY p (solution p k (δ : ZMod k)) = treeGF p k δ := by
  have hp : 2 ≤ p := (Fact.out : p.Prime).two_le
  let G : ℕ → PowerSeries ℤ := fun n => evalY p (solution p k (n : ZMod k))
  let H : ℕ → PowerSeries ℤ := treeGF p k
  have hG0 : ∀ n, (G n).coeff 0 = 0 := by
    intro n
    simp only [G, evalY, PowerSeries.coeff_map]
    rw [solution_zeroConstant]
    simp
  have hH0 : ∀ n, (H n).coeff 0 = 0 := fun _ => treeGF_coeff_zero hp
  have hG : ∀ n, G n = (if k ∣ n then PowerSeries.X else 0) + (G (n + 1)) ^ p := by
    intro n
    dsimp only [G]
    rw [evalY_solution, Nat.cast_add, Nat.cast_one]
    simp only [ZMod.natCast_eq_zero_iff]
  have hH : ∀ n, H n = (if k ∣ n then PowerSeries.X else 0) + (H (n + 1)) ^ p := by
    intro n
    exact treeGF_eq hp k n
  have hGH : G = H := treeSystem_unique hp hG0 hH0 hG hH
  exact congrFun hGH δ

end MMM.Frob

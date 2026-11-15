/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W047), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **Level profiles of trees (claim C10 of the ledger).**

The *level profile* of a tree is the number of its internal nodes at each depth.

* Part 2. `prof T i`: the number of internal nodes of `T` at depth `i`. Rotation-equivalent trees
  have the same profile (`Rot.prof_eq`): a rotation does not change the depth of any node.
* Part 3. For any arity `q`, the number of `q`-ary trees with the profile `n 0 = 1, n 1, ...,
  n L = 0` is `∏ i < L, binom(q * n i, n (i + 1))` (`card_prof`): at depth `i + 1` there are
  `q * n i` places, and `n (i + 1)` of them are chosen to be nodes.
* Part 4. For a prime `p` and `q = p ^ k`, `k ≥ 1`, every such product of binomial coefficients is
  divisible by `p ^ t`, where `(p - 1) * t + 1` is the base-`p` digit sum of `(q - 1) * N + 1`,
  `N = ∑ i < L, n i` (`pow_dvd_prod_choose_profile`; the statement uses Mathlib's definitions only).

The proof of Part 4 is by tree symmetry: the `q`-ary trees with a given profile are, through the
blocked form (`expand`, `MMM/BlockedForm.lean`), a family of `p`-ary trees with `(q - 1) * N + 1`
leaves that is closed under rotation; a rotation class has `p ^ d` trees with `d ≥ t`
(`pow_dvd_card_of_closed`, `t_le_d`). No theorem about the valuation of a factorial or of a
binomial coefficient is used (no Legendre, Kummer or Lucas).
-/
import MMM.ReductionB
import MMM.ExactB
import Mathlib.Data.Fintype.Powerset

namespace MMM

namespace PTree

variable {p : ℕ}

/-! ### Part 2: the level profile, and rotations -/

/-- The number of internal nodes of a tree at depth `i`. -/
def prof : PTree p → ℕ → ℕ
  | leaf, _ => 0
  | node _, 0 => 1
  | node f, i + 1 => ∑ j, prof (f j) i

@[simp] theorem prof_leaf (i : ℕ) : prof (leaf : PTree p) i = 0 := by
  cases i <;> rfl

@[simp] theorem prof_node_zero (f : Fin p → PTree p) : prof (node f) 0 = 1 := rfl

theorem prof_node_succ (f : Fin p → PTree p) (i : ℕ) :
    prof (node f) (i + 1) = ∑ j, prof (f j) i := rfl

/-- **Rotations keep the level profile.** -/
theorem Rot.prof_eq [NeZero p] {S T : PTree p} (h : Rot S T) : prof S = prof T := by
  induction h with
  | leaf => rfl
  | node f g r _ ih =>
    funext i
    cases i with
    | zero => rfl
    | succ i =>
      have h1 : ∑ j, prof (g j) i = ∑ j, prof (f (j + r)) i :=
        Finset.sum_congr rfl (fun j _ => (congrFun (ih j) i).symm)
      have h2 : ∑ j, prof (f (j + r)) i = ∑ j, prof (f j) i :=
        Fintype.sum_equiv (Equiv.addRight r) (fun j => prof (f (j + r)) i)
          (fun j => prof (f j) i) (fun j => rfl)
      rw [prof_node_succ, prof_node_succ, h1, h2]

/-- A tree with no node at depth `L` has no node at any depth `≥ L`: the profile up to such an `L`
is the whole profile. -/
theorem prof_eq_zero_of_le : ∀ (T : PTree p) (L i : ℕ), prof T L = 0 → L ≤ i → prof T i = 0 := by
  intro T
  induction T with
  | leaf =>
    intro L i _ _
    exact prof_leaf i
  | node f ih =>
    intro L i hL hi
    cases L with
    | zero =>
      rw [prof_node_zero] at hL
      exact absurd hL one_ne_zero
    | succ L =>
      obtain ⟨i', rfl⟩ : ∃ i', i = i' + 1 := ⟨i - 1, by omega⟩
      rw [prof_node_succ] at hL ⊢
      exact Finset.sum_eq_zero (fun j _ =>
        ih j L i' (Finset.sum_eq_zero_iff.mp hL j (Finset.mem_univ j)) (by omega))

/-! ### Part 3: the number of trees with a given profile

The count is done for families of trees (forests) indexed by any finite type `ι`: a family is the
choice of the set `S` of the positions that are nodes, together with the family of the subtrees of
these nodes, which is indexed by `S × Fin q` and has the profile shifted by one level. -/

section forest

variable {q : ℕ} {ι : Type}

/-- Is the tree a node? -/
def isNode : PTree q → Bool
  | leaf => false
  | node _ => true

/-- The subtrees of the trees at the positions of `S`. -/
def chOn (S : Finset ι) (f : ι → PTree q) : {j // j ∈ S} × Fin q → PTree q :=
  fun x => kids (f x.1.1) x.2

/-- The family with nodes at the positions of `S`, with the given subtrees, and leaves at the
other positions. -/
def glue [DecidableEq ι] (S : Finset ι) (g : {j // j ∈ S} × Fin q → PTree q) : ι → PTree q :=
  fun j => if h : j ∈ S then node (fun c => g (⟨j, h⟩, c)) else leaf

theorem glue_of_mem [DecidableEq ι] (S : Finset ι) (g : {j // j ∈ S} × Fin q → PTree q) {j : ι}
    (h : j ∈ S) : glue S g j = node (fun c => g (⟨j, h⟩, c)) := dite_eq_left h

theorem glue_of_not_mem [DecidableEq ι] (S : Finset ι) (g : {j // j ∈ S} × Fin q → PTree q)
    {j : ι} (h : j ∉ S) : glue S g j = leaf := dite_eq_right h

theorem chOn_glue [DecidableEq ι] (S : Finset ι) (g : {j // j ∈ S} × Fin q → PTree q) :
    chOn S (glue S g) = g := by
  funext ⟨⟨j, hj⟩, c⟩
  show kids (glue S g j) c = g (⟨j, hj⟩, c)
  rw [glue_of_mem S g hj]
  rfl

variable [Fintype ι]

/-- The profile of a family of trees: the sum of the profiles. -/
def fprof (f : ι → PTree q) (i : ℕ) : ℕ := ∑ j, prof (f j) i

/-- The positions of a family at which the tree is a node. -/
def nodeSet (f : ι → PTree q) : Finset ι := Finset.univ.filter (fun j => (f j).isNode = true)

variable [DecidableEq ι]

theorem nodeSet_glue (S : Finset ι) (g : {j // j ∈ S} × Fin q → PTree q) :
    nodeSet (glue S g) = S := by
  ext j
  simp only [nodeSet, Finset.mem_filter, Finset.mem_univ, true_and]
  by_cases h : j ∈ S
  · rw [glue_of_mem S g h]
    exact ⟨fun _ => h, fun _ => rfl⟩
  · rw [glue_of_not_mem S g h]
    exact ⟨fun h' => (by cases h'), fun h' => absurd h' h⟩

theorem glue_chOn (f : ι → PTree q) : glue (nodeSet f) (chOn (nodeSet f) f) = f := by
  funext j
  by_cases h : j ∈ nodeSet f
  · rw [glue_of_mem _ _ h]
    have h' : (f j).isNode = true := by
      simpa only [nodeSet, Finset.mem_filter, Finset.mem_univ, true_and] using h
    show node (fun c => kids (f j) c) = f j
    cases hfj : f j with
    | leaf => rw [hfj] at h'; cases h'
    | node F => rfl
  · rw [glue_of_not_mem _ _ h]
    have h' : ¬ (f j).isNode = true := by
      simpa only [nodeSet, Finset.mem_filter, Finset.mem_univ, true_and] using h
    cases hfj : f j with
    | leaf => rfl
    | node F => rw [hfj] at h'; exact absurd rfl h'

theorem glue_chOn_of_eq (f : ι → PTree q) (S : Finset ι) (h : nodeSet f = S) :
    glue S (chOn S f) = f := by
  subst h
  exact glue_chOn f

/-- At depth `0` the profile of a family counts its nodes. -/
theorem fprof_glue_zero (S : Finset ι) (g : {j // j ∈ S} × Fin q → PTree q) :
    fprof (glue S g) 0 = S.card := by
  have h1 : ∀ j, j ∉ S → prof (glue S g j) 0 = 0 := fun j hj => by
    rw [glue_of_not_mem S g hj, prof_leaf]
  have h2 : ∀ j, j ∈ S → prof (glue S g j) 0 = 1 := fun j hj => by
    rw [glue_of_mem S g hj, prof_node_zero]
  calc fprof (glue S g) 0 = ∑ j ∈ S, prof (glue S g j) 0 :=
        (Finset.sum_subset (Finset.subset_univ S) (fun j _ hj => h1 j hj)).symm
    _ = ∑ _j ∈ S, 1 := Finset.sum_congr rfl (fun j hj => h2 j hj)
    _ = S.card := by simp

/-- At depth `i + 1` the profile of a family is the profile at depth `i` of the subtrees of its
nodes. -/
theorem fprof_glue_succ (S : Finset ι) (g : {j // j ∈ S} × Fin q → PTree q) (i : ℕ) :
    fprof (glue S g) (i + 1) = fprof g i := by
  have h1 : ∀ j, j ∉ S → prof (glue S g j) (i + 1) = 0 := fun j hj => by
    rw [glue_of_not_mem S g hj, prof_leaf]
  have h2 : ∀ j : {j // j ∈ S}, prof (glue S g j.1) (i + 1) = ∑ c, prof (g (j, c)) i := by
    rintro ⟨j, hj⟩
    rw [glue_of_mem S g hj, prof_node_succ]
  calc fprof (glue S g) (i + 1) = ∑ j ∈ S, prof (glue S g j) (i + 1) :=
        (Finset.sum_subset (Finset.subset_univ S) (fun j _ hj => h1 j hj)).symm
    _ = ∑ j : {j // j ∈ S}, prof (glue S g j.1) (i + 1) :=
        (Finset.sum_coe_sort S (fun j => prof (glue S g j) (i + 1))).symm
    _ = ∑ j : {j // j ∈ S}, ∑ c, prof (g (j, c)) i := Finset.sum_congr rfl (fun j _ => h2 j)
    _ = fprof g i := (Fintype.sum_prod_type (fun x => prof (g x) i)).symm

/-- The profile condition for a family, in terms of its set of nodes and their subtrees. -/
theorem glue_cond (S : Finset ι) (g : {j // j ∈ S} × Fin q → PTree q) (L : ℕ) (n : ℕ → ℕ) :
    (∀ i, i ≤ L + 1 → fprof (glue S g) i = n i) ↔
      (S.card = n 0 ∧ ∀ i, i ≤ L → fprof g i = n (i + 1)) := by
  constructor
  · intro h
    refine ⟨?_, fun i hi => ?_⟩
    · rw [← fprof_glue_zero S g]
      exact h 0 (Nat.zero_le _)
    · rw [← fprof_glue_succ S g i]
      exact h (i + 1) (by omega)
  · rintro ⟨h0, h1⟩ i hi
    cases i with
    | zero => rw [fprof_glue_zero]; exact h0
    | succ i => rw [fprof_glue_succ]; exact h1 i (by omega)

/-- The families with a given profile and a given set `S` of nodes are the families of subtrees,
indexed by `S × Fin q`, with the shifted profile (and there are none unless `S` has `n 0`
elements). -/
def fiberEquiv (L : ℕ) (n : ℕ → ℕ) (S : Finset ι) :
    {x : {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} // nodeSet x.1 = S} ≃
      {g : {j // j ∈ S} × Fin q → PTree q //
        S.card = n 0 ∧ ∀ i, i ≤ L → fprof g i = n (i + 1)} where
  toFun x := ⟨chOn S x.1.1, by
    have h : ∀ i, i ≤ L + 1 → fprof (glue S (chOn S x.1.1)) i = n i := by
      rw [glue_chOn_of_eq x.1.1 S x.2]
      exact x.1.2
    exact (glue_cond S _ L n).mp h⟩
  invFun g := ⟨⟨glue S g.1, (glue_cond S g.1 L n).mpr g.2⟩, nodeSet_glue S g.1⟩
  left_inv x := Subtype.ext (Subtype.ext (glue_chOn_of_eq x.1.1 S x.2))
  right_inv g := Subtype.ext (chOn_glue S g.1)

end forest

/-- **The number of families of trees with a given profile.** If `n L = 0`, the families of
`q`-ary trees indexed by `ι` whose profile is `n 0, ..., n L` are finitely many, and their number
is `binom(#ι, n 0) * ∏ i < L, binom(q * n i, n (i + 1))`. -/
theorem forest_prof_card (q : ℕ) : ∀ (L : ℕ) (ι : Type) [Fintype ι] [DecidableEq ι] (n : ℕ → ℕ),
    n L = 0 →
    Finite {f : ι → PTree q // ∀ i, i ≤ L → fprof f i = n i} ∧
      Nat.card {f : ι → PTree q // ∀ i, i ≤ L → fprof f i = n i} =
        (Fintype.card ι).choose (n 0) *
          ∏ i ∈ Finset.range L, (q * n i).choose (n (i + 1)) := by
  intro L
  induction L with
  | zero =>
    intro ι _ _ n hn
    -- the only such family is the family of leaves
    have huniq : ∀ f : {f : ι → PTree q // ∀ i, i ≤ 0 → fprof f i = n i},
        f.1 = fun _ => leaf := by
      rintro ⟨f, hf⟩
      funext j
      have h0 : ∑ j, prof (f j) 0 = 0 := by
        have := hf 0 le_rfl
        rw [hn] at this
        exact this
      have h1 : prof (f j) 0 = 0 := Finset.sum_eq_zero_iff.mp h0 j (Finset.mem_univ j)
      show f j = leaf
      cases hfj : f j with
      | leaf => rfl
      | node F =>
        rw [hfj, prof_node_zero] at h1
        exact absurd h1 one_ne_zero
    have hsub : Subsingleton {f : ι → PTree q // ∀ i, i ≤ 0 → fprof f i = n i} :=
      ⟨fun a b => Subtype.ext ((huniq a).trans (huniq b).symm)⟩
    have hne : Nonempty {f : ι → PTree q // ∀ i, i ≤ 0 → fprof f i = n i} :=
      ⟨⟨fun _ => leaf, fun i hi => by
        have hi0 : i = 0 := by omega
        subst hi0
        rw [hn]
        simp [fprof]⟩⟩
    refine ⟨inferInstance, ?_⟩
    rw [Nat.card_eq_one_iff_unique.mpr ⟨hsub, hne⟩, hn]
    simp
  | succ L ih =>
    intro ι _ _ n hn
    -- the number of families of subtrees, once the set of nodes is chosen
    have hc : ∀ S : Finset ι, S.card = n 0 →
        Finite {g : {j // j ∈ S} × Fin q → PTree q // ∀ i, i ≤ L → fprof g i = n (i + 1)} ∧
          Nat.card {g : {j // j ∈ S} × Fin q → PTree q // ∀ i, i ≤ L → fprof g i = n (i + 1)} =
            (∏ i ∈ Finset.range L, (q * n (i + 1)).choose (n (i + 1 + 1))) *
              (q * n 0).choose (n (0 + 1)) := by
      intro S hS
      have ih' : Finite {g : {j // j ∈ S} × Fin q → PTree q //
            ∀ i, i ≤ L → fprof g i = n (i + 1)} ∧
          Nat.card {g : {j // j ∈ S} × Fin q → PTree q // ∀ i, i ≤ L → fprof g i = n (i + 1)} =
            (Fintype.card ({j // j ∈ S} × Fin q)).choose (n (0 + 1)) *
              ∏ i ∈ Finset.range L, (q * n (i + 1)).choose (n (i + 1 + 1)) :=
        ih ({j // j ∈ S} × Fin q) (fun i => n (i + 1)) hn
      have hcard : Fintype.card ({j // j ∈ S} × Fin q) = q * n 0 := by
        rw [Fintype.card_prod, Fintype.card_coe, Fintype.card_fin, hS, mul_comm]
      refine ⟨ih'.1, ?_⟩
      rw [ih'.2, hcard, mul_comm]
    -- the families with a given set `S` of nodes
    have hfib : ∀ S : Finset ι,
        Finite {x : {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} // nodeSet x.1 = S} ∧
          Nat.card {x : {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} //
              nodeSet x.1 = S} =
            if S.card = n 0 then
              (∏ i ∈ Finset.range L, (q * n (i + 1)).choose (n (i + 1 + 1))) *
                (q * n 0).choose (n (0 + 1))
            else 0 := by
      intro S
      by_cases hS : S.card = n 0
      · have e := (fiberEquiv (q := q) L n S).trans
          (Equiv.subtypeEquivRight (fun g : {j // j ∈ S} × Fin q → PTree q =>
            and_iff_right (b := ∀ i, i ≤ L → fprof g i = n (i + 1)) hS))
        have hfin := (hc S hS).1
        refine ⟨Finite.of_equiv _ e.symm, ?_⟩
        rw [ite_eq_left hS, Nat.card_congr e, (hc S hS).2]
      · have hemp : IsEmpty {x : {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} //
            nodeSet x.1 = S} := ⟨fun x => hS (fiberEquiv L n S x).2.1⟩
        refine ⟨inferInstance, ?_⟩
        rw [ite_eq_right hS, Nat.card_of_isEmpty]
    have hfinfib : ∀ S : Finset ι,
        Finite {x : {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} // nodeSet x.1 = S} :=
      fun S => (hfib S).1
    refine ⟨Finite.of_equiv _ (Equiv.sigmaFiberEquiv
      (fun x : {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} => nodeSet x.1)), ?_⟩
    -- sum over the sets `S`
    have hsum : Nat.card {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} =
        ∑ S : Finset ι, Nat.card
          {x : {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} // nodeSet x.1 = S} := by
      rw [← Nat.card_sigma]
      exact Nat.card_congr (Equiv.sigmaFiberEquiv
        (fun x : {f : ι → PTree q // ∀ i, i ≤ L + 1 → fprof f i = n i} => nodeSet x.1)).symm
    rw [hsum, Finset.sum_congr rfl (fun S _ => (hfib S).2), Finset.sum_ite, Finset.sum_const_zero,
      add_zero, Finset.sum_const, smul_eq_mul, Finset.univ_filter_card_eq,
      Finset.card_powersetCard, Finset.card_univ, Finset.prod_range_succ']

/-- A tree as a family of one tree. -/
def profUnitEquiv (q L : ℕ) (n : ℕ → ℕ) :
    {T : PTree q // ∀ i, i ≤ L → prof T i = n i} ≃
      {f : Unit → PTree q // ∀ i, i ≤ L → fprof f i = n i} where
  toFun T := ⟨fun _ => T.1, fun i hi => by
    rw [← T.2 i hi]
    simp [fprof]⟩
  invFun f := ⟨f.1 (), fun i hi => by
    rw [← f.2 i hi]
    simp [fprof]⟩
  left_inv _ := rfl
  right_inv _ := rfl

/-- The trees with a given profile `n 0, ..., n L`, `n L = 0`, are finitely many. -/
theorem finite_prof (q L : ℕ) (n : ℕ → ℕ) (hL : n L = 0) :
    Finite {T : PTree q // ∀ i, i ≤ L → prof T i = n i} :=
  have := (forest_prof_card q L Unit n hL).1
  Finite.of_equiv _ (profUnitEquiv q L n).symm

/-- **The number of trees with a given level profile.** For a profile `n 0 = 1, n 1, ..., n L = 0`,
the number of `q`-ary trees with `n i` internal nodes at depth `i` for every `i ≤ L` (and hence
with no node at any depth `≥ L`) is `∏ i < L, binom(q * n i, n (i + 1))`. -/
theorem card_prof (q : ℕ) (hq : 1 ≤ q) (L : ℕ) (n : ℕ → ℕ) (h0 : n 0 = 1) (hL : n L = 0) :
    Nat.card {T : PTree q // ∀ i, i ≤ L → prof T i = n i} =
      ∏ i ∈ Finset.range L, Nat.choose (q * n i) (n (i + 1)) := by
  have _ := hq
  rw [Nat.card_congr (profUnitEquiv q L n), (forest_prof_card q L Unit n hL).2, h0]
  simp

/-! ### Part 4: divisibility of the profile counts for `q = p ^ k`, from the rotation classes -/

/-- A tree with no node at depth `L` has all its nodes at the depths `< L`. -/
theorem nodes_eq_sum_prof {q : ℕ} : ∀ (T : PTree q) (L : ℕ), prof T L = 0 →
    T.nodes = ∑ i ∈ Finset.range L, prof T i := by
  intro T
  induction T with
  | leaf =>
    intro L _
    simp [nodes]
  | node f ih =>
    intro L hL
    cases L with
    | zero =>
      rw [prof_node_zero] at hL
      exact absurd hL one_ne_zero
    | succ L =>
      rw [prof_node_succ] at hL
      have hch : ∀ j, prof (f j) L = 0 := fun j =>
        Finset.sum_eq_zero_iff.mp hL j (Finset.mem_univ j)
      have h1 : ∑ i ∈ Finset.range L, prof (node f) (i + 1) = ∑ j, (f j).nodes := by
        simp only [prof_node_succ]
        rw [Finset.sum_comm]
        exact Finset.sum_congr rfl (fun j _ => (ih j L (hch j)).symm)
      rw [Finset.sum_range_succ', prof_node_zero, h1, nodes_node', Nat.add_comm]

/-- The profile of `build j g` from depth `j` on: the nodes of the trees `g x`. -/
theorem prof_build : ∀ (j : ℕ) (g : Fin (p ^ j) → PTree p) (i : ℕ),
    prof (build j g) (j + i) = ∑ x, prof (g x) i := by
  intro j
  induction j with
  | zero =>
    intro g i
    rw [build_zero, Nat.zero_add]
    symm
    rw [Fintype.sum_eq_single (⟨0, by simp⟩ : Fin (p ^ 0))]
    intro x hx
    exact absurd (fin_pow_zero x) hx
  | succ j ih =>
    intro g i
    have e : j + 1 + i = (j + i) + 1 := by omega
    rw [build_succ, e, prof_node_succ, ← Equiv.sum_comp (idx p j) (fun y => prof (g y) i),
      Fintype.sum_prod_type]
    exact Finset.sum_congr rfl (fun c _ => ih _ i)

/-- The profile of the expanded tree at the depths `k * i` is the profile of the `p ^ k`-ary
tree (`k ≥ 1`): a `p ^ k`-ary node at depth `i` becomes a complete `p`-ary tree of height `k`
whose root is at depth `k * i`. -/
theorem prof_expand {k : ℕ} (hk : 0 < k) : ∀ (T : PTree (p ^ k)) (i : ℕ),
    prof (expand k T) (k * i) = prof T i := by
  obtain ⟨k', rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
  intro T
  induction T with
  | leaf =>
    intro i
    rw [expand_leaf, prof_leaf, prof_leaf]
  | node f ih =>
    intro i
    cases i with
    | zero =>
      rw [expand_node, build_succ]
      rfl
    | succ i =>
      have e : (k' + 1) * (i + 1) = (k' + 1) + (k' + 1) * i := by
        rw [Nat.mul_succ, Nat.add_comm]
      rw [expand_node, e, prof_build, prof_node_succ]
      exact Finset.sum_congr rfl (fun x _ => ih x i)

/-- **Claim C10, for trees.** For a prime `p` and `q = p ^ k`, `k ≥ 1`: the number of `q`-ary
trees with the level profile `n 0, ..., n L` (`n L = 0`) is divisible by `p ^ t`, where
`(p - 1) * t + 1` is the base-`p` digit sum of `(q - 1) * N + 1`, `N = ∑ i < L, n i`.
Proved from the rotation classes of the corresponding `p`-ary trees. -/
theorem pow_dvd_card_prof [hp : Fact p.Prime] (k : ℕ) (hk : 0 < k) (L : ℕ) (n : ℕ → ℕ)
    (hL : n L = 0) (t : ℕ)
    (ht : (p - 1) * t + 1 = ds p ((p ^ k - 1) * (∑ i ∈ Finset.range L, n i) + 1)) :
    p ^ t ∣ Nat.card {T : PTree (p ^ k) // ∀ i, i ≤ L → prof T i = n i} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hq : 1 ≤ p ^ k := Nat.one_le_pow _ _ hp.out.pos
  -- the corresponding family of `p`-ary trees: it is finite and closed under rotation, and each
  -- of its trees has at least `t` asymmetric nodes
  have hfin : Finite {U : PTree p // U.leaves = (p ^ k - 1) * (∑ i ∈ Finset.range L, n i) + 1 ∧
      (BlockedAt k 0 U ∧ ∀ i, i ≤ L → prof U (k * i) = n i)} :=
    finite_of_leaves _ _
  have hdiv : p ^ t ∣ Nat.card {U : PTree p //
      U.leaves = (p ^ k - 1) * (∑ i ∈ Finset.range L, n i) + 1 ∧
        (BlockedAt k 0 U ∧ ∀ i, i ≤ L → prof U (k * i) = n i)} := by
    refine pow_dvd_card_of_closed (fun U : PTree p =>
      U.leaves = (p ^ k - 1) * (∑ i ∈ Finset.range L, n i) + 1 ∧
        (BlockedAt k 0 U ∧ ∀ i, i ≤ L → prof U (k * i) = n i)) ?_ t ?_
    · rintro S T h ⟨hl, hb, hpr⟩
      refine ⟨h.leaves_eq.trans hl, (h.blockedAt 0).mpr hb, fun i hi => ?_⟩
      rw [h.prof_eq]
      exact hpr i hi
    · rintro T ⟨hl, -, -⟩
      exact t_le_d hp2 T t (by rw [hl]; exact ht)
  -- the blocked form: `expand` is a bijection from the `q`-ary trees with the profile `n` onto it
  have hcard : Nat.card {T : PTree (p ^ k) // ∀ i, i ≤ L → prof T i = n i} =
      Nat.card {U : PTree p // U.leaves = (p ^ k - 1) * (∑ i ∈ Finset.range L, n i) + 1 ∧
        (BlockedAt k 0 U ∧ ∀ i, i ≤ L → prof U (k * i) = n i)} := by
    refine Nat.card_congr (Equiv.ofBijective
      (fun T => ⟨expand k T.1, ?_, blockedAt_expand k T.1 0 (dvd_zero k), fun i hi => ?_⟩)
      ⟨?_, ?_⟩)
    · -- the number of leaves: `(q - 1) * (number of nodes) + 1`
      have hTL : prof T.1 L = 0 := by rw [T.2 L le_rfl, hL]
      rw [leaves_expand, leaves_eq_nodes hq T.1, nodes_eq_sum_prof T.1 L hTL,
        Finset.sum_congr rfl (fun i hi => T.2 i (le_of_lt (Finset.mem_range.mp hi)))]
    · rw [prof_expand hk]
      exact T.2 i hi
    · intro T1 T2 h
      exact Subtype.ext (expand_injective hk _ _ (congrArg Subtype.val h))
    · rintro ⟨U, hl, hb, hpr⟩
      obtain ⟨T', hT'⟩ := exists_expand hk _ U rfl hb
      refine ⟨⟨T', fun i hi => ?_⟩, Subtype.ext hT'⟩
      rw [← prof_expand hk T' i, hT']
      exact hpr i hi
  rw [hcard]
  exact hdiv

end PTree

/-- **Claim C10: every level-profile count of `q`-ary trees, `q = p ^ k`, is divisible by
`p ^ t`.** For a prime `p`, `k ≥ 1` and numbers `n 0 = 1, n 1, ..., n L = 0`, the product
`∏ i < L, binom(p ^ k * n i, n (i + 1))` is divisible by `p ^ t`, where `(p - 1) * t + 1` is the
base-`p` digit sum of `(p ^ k - 1) * (n 0 + ... + n (L - 1)) + 1`. The statement uses Mathlib's
definitions only; the proof is by the rotation classes of trees (`PTree.pow_dvd_card_prof`) and
uses no theorem about the valuation of a factorial or of a binomial coefficient. -/
theorem pow_dvd_prod_choose_profile (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (L : ℕ)
    (n : ℕ → ℕ) (h0 : n 0 = 1) (hL : n L = 0) (t : ℕ)
    (ht : (p - 1) * t + 1 =
      (Nat.digits p ((p ^ k - 1) * (∑ i ∈ Finset.range L, n i) + 1)).sum) :
    p ^ t ∣ ∏ i ∈ Finset.range L, Nat.choose (p ^ k * n i) (n (i + 1)) := by
  have hq : 1 ≤ p ^ k := Nat.one_le_pow _ _ (Fact.out (p := p.Prime)).pos
  rw [← PTree.card_prof (p ^ k) hq L n h0 hL]
  exact PTree.pow_dvd_card_prof k hk L n hL t ht

end MMM

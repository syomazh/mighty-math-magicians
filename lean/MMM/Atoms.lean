/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Step 3 of the main proof: the minimal trees are built from the digits of `m`.**

A *typed tree* is a `p`-ary tree whose leaves carry a number `j`, read as "an atom with `p ^ j`
leaves" (`LTree p ℕ`). `realize` replaces each typed leaf by the complete tree of that height.
A typed tree is *carry-free* when at each node the weights of the children add up without carry.

Checked here, for `p ≥ 2`:

* `minimalEquiv`: `realize` is a bijection from the carry-free typed trees of weight `m` onto
  the trees with `m` leaves that attain the lower bound (the minimal trees);
* `cnt_eq_dig`: a carry-free typed tree of weight `m` has exactly `m_j` leaves of type `j`,
  where `m_j` is the `j`-th base-`p` digit of `m`;
* `ds_wt`, `d_realize`: it has `t` nodes, all of which stay asymmetric in the realized tree;
* `good_lab_iff`: if the digits of `m` are 0 or 1, the carry-free typed trees of weight `m` are
  exactly the trees whose leaves are labelled, without repetition, by the positions of the
  digits 1.
-/
import MMM.Minimal
import MMM.LTree

namespace MMM

namespace LTree

variable {p : ℕ}

/-- The weight: the number of leaves once every leaf of type `j` is replaced by `p ^ j` leaves. -/
def wt : LTree p ℕ → ℕ
  | leaf j => p ^ j
  | node f => ∑ i, (f i).wt

/-- At every node, the weights of the children add up without carry. -/
def CarryFree : LTree p ℕ → Prop
  | leaf _ => True
  | node f => (∀ i, (f i).CarryFree) ∧ ds p (∑ i, (f i).wt) = ∑ i, ds p (f i).wt

/-- Replace each leaf of type `j` by the complete tree of height `j`. -/
def realize : LTree p ℕ → PTree p
  | leaf j => PTree.complete j
  | node f => PTree.node fun i => (f i).realize

/-- The number of leaves of type `j`. -/
def cnt (j : ℕ) : LTree p ℕ → ℕ
  | leaf i => if i = j then 1 else 0
  | node f => ∑ i, (f i).cnt j

@[simp] theorem wt_leaf (j : ℕ) : (leaf j : LTree p ℕ).wt = p ^ j := rfl
@[simp] theorem wt_node (f : Fin p → LTree p ℕ) : (node f).wt = ∑ i, (f i).wt := rfl
@[simp] theorem realize_leaf (j : ℕ) : (leaf j : LTree p ℕ).realize = PTree.complete j := rfl
@[simp] theorem realize_node (f : Fin p → LTree p ℕ) :
    (node f).realize = PTree.node fun i => (f i).realize := rfl
@[simp] theorem cnt_leaf (j i : ℕ) : (leaf i : LTree p ℕ).cnt j = if i = j then 1 else 0 := rfl
@[simp] theorem cnt_node (j : ℕ) (f : Fin p → LTree p ℕ) :
    (node f).cnt j = ∑ i, (f i).cnt j := rfl
theorem carryFree_node (f : Fin p → LTree p ℕ) : (node f).CarryFree ↔
    (∀ i, (f i).CarryFree) ∧ ds p (∑ i, (f i).wt) = ∑ i, ds p (f i).wt := Iff.rfl

/-- The realized tree has `wt` leaves. -/
theorem leaves_realize (U : LTree p ℕ) : U.realize.leaves = U.wt := by
  induction U with
  | leaf j => simp [PTree.leaves_complete]
  | node f ih => simp [ih]

/-- A carry-free typed tree with `n` nodes has weight of digit sum `(p - 1) * n + 1`. -/
theorem ds_wt (hp : 2 ≤ p) (U : LTree p ℕ) (h : U.CarryFree) :
    ds p U.wt = (p - 1) * U.nodes + 1 := by
  induction U with
  | leaf j => simp [ds_pow hp]
  | node f ih =>
    obtain ⟨hc, hds⟩ := h
    rw [wt_node, hds, Finset.sum_congr rfl (fun i _ => ih i (hc i)), Finset.sum_add_distrib,
      ← Finset.mul_sum, nodes_node, Nat.mul_add, Nat.mul_one]
    simp
    omega

/-- The root of a realized carry-free node is asymmetric. -/
theorem not_symmetric_realize (hp : 2 ≤ p) (f : Fin p → LTree p ℕ) (h : (node f).CarryFree) :
    ¬ PTree.Symmetric fun i => (f i).realize := by
  have : NeZero p := ⟨by omega⟩
  intro hs
  have hb : ∀ i, (f i).wt = (f 0).wt := fun i => by
    have h1 := (hs i 0).leaves_eq
    simpa [leaves_realize] using h1
  have hds := h.2
  have hsum : ∑ i, (f i).wt = p * (f 0).wt := by
    rw [Finset.sum_congr rfl (fun i _ => hb i)]
    simp
  have hsum2 : ∑ i, ds p (f i).wt = p * ds p (f 0).wt := by
    rw [Finset.sum_congr rfl (fun i _ => by rw [hb i])]
    simp
  rw [hsum, ds_base_mul hp, hsum2] at hds
  have hpos : 0 < ds p (f 0).wt := by
    refine ds_pos hp _ ?_
    rw [← leaves_realize]
    exact PTree.leaves_pos _
  have h2 : 2 * ds p (f 0).wt ≤ p * ds p (f 0).wt := Nat.mul_le_mul_right _ hp
  omega

/-- In the realized tree the asymmetric nodes are exactly the nodes of the typed tree. -/
theorem d_realize (hp : 2 ≤ p) (U : LTree p ℕ) (h : U.CarryFree) : U.realize.d = U.nodes := by
  have : NeZero p := ⟨by omega⟩
  induction U with
  | leaf j => simp [PTree.d_complete]
  | node f ih =>
    rw [realize_node, PTree.d_node_asymm _ (not_symmetric_realize hp f h), nodes_node,
      Finset.sum_congr rfl (fun i _ => ih i (h.1 i))]

/-- The realized tree attains the lower bound. -/
theorem tight_realize (hp : 2 ≤ p) (U : LTree p ℕ) (h : U.CarryFree) : U.realize.Tight := by
  unfold PTree.Tight
  rw [d_realize hp U h, leaves_realize, ds_wt hp U h]

/-- Different carry-free typed trees give different trees. -/
theorem realize_injective (hp : 2 ≤ p) : ∀ U V : LTree p ℕ, U.CarryFree → V.CarryFree →
    U.realize = V.realize → U = V := by
  have : NeZero p := ⟨by omega⟩
  intro U
  induction U with
  | leaf j =>
    intro V _ hV h
    cases V with
    | leaf j' =>
      have h1 := congrArg PTree.leaves h
      simp only [realize_leaf, PTree.leaves_complete] at h1
      rw [Nat.pow_right_injective hp h1]
    | node g =>
      have h1 := congrArg PTree.d h
      rw [d_realize hp _ hV] at h1
      simp [PTree.d_complete] at h1
  | node f ih =>
    intro V hU hV h
    cases V with
    | leaf j' =>
      have h1 := congrArg PTree.d h
      rw [d_realize hp _ hU] at h1
      simp [PTree.d_complete] at h1
    | node g =>
      simp only [realize_node, PTree.node.injEq] at h
      congr 1
      funext i
      exact ih i (g i) (hU.1 i) (hV.1 i) (congrFun h i)

/-- Every tree that attains the lower bound is the realization of a carry-free typed tree. -/
theorem exists_realize (hp : 2 ≤ p) : ∀ T : PTree p, T.Tight →
    ∃ U : LTree p ℕ, U.CarryFree ∧ U.realize = T := by
  have : NeZero p := ⟨by omega⟩
  intro T
  induction T with
  | leaf => intro _; exact ⟨leaf 0, trivial, rfl⟩
  | node f ih =>
    intro ht
    by_cases hs : PTree.Symmetric f
    · obtain ⟨j, hj⟩ := PTree.eq_complete_of_d_eq_zero hp _ (PTree.tight_symm_d_zero hp f hs ht)
      exact ⟨leaf j, trivial, hj.symm⟩
    · obtain ⟨hch, hds⟩ := PTree.tight_asymm hp f hs ht
      choose U hU using fun i => ih i (hch i)
      refine ⟨node U, ⟨fun i => (hU i).1, ?_⟩, ?_⟩
      · have hw : ∀ i, (U i).wt = (f i).leaves := fun i => by rw [← leaves_realize, (hU i).2]
        simp only [hw]
        exact hds
      · rw [realize_node]
        congr 1
        funext i
        exact (hU i).2

/-- **Step 3.** The minimal trees with `m` leaves are, one to one, the carry-free typed trees
of weight `m`. -/
noncomputable def minimalEquiv (hp : 2 ≤ p) (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    {U : LTree p ℕ // U.CarryFree ∧ U.wt = m} ≃ {T : PTree p // PTree.IsMinimal m t T} :=
  Equiv.ofBijective
    (fun U => ⟨U.1.realize, by rw [leaves_realize]; exact U.2.2,
      (PTree.tight_iff_d hp ht _ (by rw [leaves_realize]; exact U.2.2)).mp
        (tight_realize hp U.1 U.2.1)⟩)
    ⟨fun U V h => Subtype.ext (realize_injective hp U.1 V.1 U.2.1 V.2.1 (congrArg Subtype.val h)),
      fun T => by
        obtain ⟨U, hU, hUT⟩ := exists_realize hp T.1 ((PTree.tight_iff_d hp ht T.1 T.2.1).mpr T.2.2)
        exact ⟨⟨U, hU, by rw [← leaves_realize, hUT]; exact T.2.1⟩, Subtype.ext hUT⟩⟩

/-- **The atoms are the digits.** A carry-free typed tree of weight `m` has exactly `m_j` leaves
of type `j`, where `m_j` is the `j`-th base-`p` digit of `m`. -/
theorem cnt_eq_dig (hp : 2 ≤ p) (U : LTree p ℕ) (h : U.CarryFree) (j : ℕ) :
    U.cnt j = dig p j U.wt := by
  induction U with
  | leaf i => simp [dig_pow hp]
  | node f ih =>
    rw [cnt_node, wt_node, dig_sum hp Finset.univ _ h.2 j]
    exact Finset.sum_congr rfl (fun i _ => ih i (h.1 i))

/-! ### Distinct types: the labelled trees of Step 4 -/

/-- The weight of a tree with pairwise distinct types. -/
theorem wt_eq_sum_lab (U : LTree p ℕ) (h : U.Good) : U.wt = ∑ j ∈ U.lab, p ^ j := by
  induction U with
  | leaf j => simp
  | node f ih =>
    rw [wt_node, lab_node, Finset.sum_biUnion (fun i _ j _ hij => h.2 i j hij)]
    exact Finset.sum_congr rfl (fun i _ => ih i (h.1 i))

/-- A tree with pairwise distinct types is carry-free. -/
theorem carryFree_of_good (hp : 2 ≤ p) (U : LTree p ℕ) (h : U.Good) : U.CarryFree := by
  induction U with
  | leaf j => trivial
  | node f ih =>
    refine ⟨fun i => ih i (h.1 i), ?_⟩
    have hw : ∀ i, (f i).wt = ∑ j ∈ (f i).lab, p ^ j := fun i => wt_eq_sum_lab _ (h.1 i)
    simp only [hw, ds_sum_pow hp]
    rw [← Finset.sum_biUnion (fun i _ j _ hij => h.2 i j hij), ds_sum_pow hp,
      Finset.card_biUnion (fun i _ j _ hij => h.2 i j hij)]

/-- A type occurs in the tree exactly when its count is positive. -/
theorem mem_lab_iff (U : LTree p ℕ) (j : ℕ) : j ∈ U.lab ↔ 0 < U.cnt j := by
  induction U with
  | leaf i =>
    simp only [lab_leaf, Finset.mem_singleton, cnt_leaf]
    constructor
    · intro h; simp [h]
    · intro h
      by_contra hne
      have : i ≠ j := fun e => hne e.symm
      simp [this] at h
  | node f ih =>
    simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and, cnt_node]
    rw [Finset.sum_pos_iff_of_nonneg (fun _ _ => Nat.zero_le _)]
    simp only [Finset.mem_univ, true_and]
    exact exists_congr ih

/-- If no type occurs twice, the tree is `Good`. -/
theorem good_of_cnt_le_one : ∀ U : LTree p ℕ, (∀ j, U.cnt j ≤ 1) → U.Good := by
  intro U
  induction U with
  | leaf i => intro _; trivial
  | node f ih =>
    intro h
    have hle : ∀ i j, (f i).cnt j ≤ (node f).cnt j := fun i j =>
      Finset.single_le_sum (f := fun i => (f i).cnt j) (fun _ _ => Nat.zero_le _)
        (Finset.mem_univ i)
    refine ⟨fun i => ih i (fun j => (hle i j).trans (h j)), fun i i' hii => ?_⟩
    rw [Finset.disjoint_left]
    intro j hj hj'
    rw [mem_lab_iff] at hj hj'
    have h2 : (f i).cnt j + (f i').cnt j ≤ (node f).cnt j := by
      rw [cnt_node, ← Finset.sum_pair (f := fun i => (f i).cnt j) hii]
      exact Finset.sum_le_sum_of_subset (Finset.subset_univ _)
    have := h j
    omega

/-- **Digits 0 and 1.** For `m = ∑_{j ∈ D} p ^ j`, the carry-free typed trees of weight `m` are
exactly the trees whose leaves are labelled by `D` without repetition. -/
theorem good_lab_iff (hp : 2 ≤ p) (D : Finset ℕ) (U : LTree p ℕ) :
    (U.Good ∧ U.lab = D) ↔ (U.CarryFree ∧ U.wt = ∑ j ∈ D, p ^ j) := by
  constructor
  · rintro ⟨hg, rfl⟩
    exact ⟨carryFree_of_good hp U hg, wt_eq_sum_lab U hg⟩
  · rintro ⟨hc, hw⟩
    have hcnt : ∀ j, U.cnt j = if j ∈ D then 1 else 0 := fun j => by
      rw [cnt_eq_dig hp U hc, hw, dig_sum_pow hp]
    refine ⟨good_of_cnt_le_one U (fun j => by rw [hcnt]; split <;> omega), ?_⟩
    ext j
    rw [mem_lab_iff, hcnt]
    split <;> simp_all

end LTree

end MMM

/-
Written by Claude Fable 5.2 (AI, a forked instance of the orchestrator), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

Rotation equivalence for trees with labelled leaves (`LTree`), for use in Step 4 of the main
proof (the cherry collapse):

* `Rot` is an equivalence relation and preserves the label set, `Good` and the number of nodes;
* a tree with pairwise distinct labels (`Good`) and `t` nodes has `(p - 1) * t + 1` labels;
* the rotation class of a `Good` tree with `t` nodes has exactly `p ^ t` trees (every node of
  such a tree is asymmetric, because different children carry different labels);
* there are finitely many `Good` trees with a given label set;
* renaming the labels (`map`) is compatible with all of this.
-/
import MMM.LTree
import MMM.Counting
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Set.Finite.Lattice
import Mathlib.Data.Finset.Powerset
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Nat.Prime.Defs

namespace MMM

namespace LTree

variable {p : ℕ} {α β γ : Type}

/-! ### Rotation equivalence is an equivalence relation -/

section rot

variable [NeZero p]

theorem Rot.refl (T : LTree p α) : Rot T T := by
  induction T with
  | leaf a => exact Rot.leaf a
  | node f ih => exact Rot.node f f 0 (fun i => by simpa using ih i)

theorem Rot.symm {S T : LTree p α} (h : Rot S T) : Rot T S := by
  induction h with
  | leaf a => exact Rot.leaf a
  | node f g r _ ih =>
    refine Rot.node g f (-r) (fun i => ?_)
    have h1 := ih (i + -r)
    simpa using h1

theorem Rot.trans {S T U : LTree p α} (h1 : Rot S T) (h2 : Rot T U) : Rot S U := by
  induction h1 generalizing U with
  | leaf a => exact h2
  | node f g r _ ih =>
    cases h2 with
    | node _ k r' h2' =>
      refine Rot.node f k (r' + r) (fun i => ?_)
      have h3 := ih (i + r') (h2' i)
      simpa [add_assoc] using h3

omit [NeZero p] in
/-- A tree equivalent to a leaf is that leaf. -/
theorem Rot.eq_leaf {S : LTree p α} {a : α} (h : Rot S (LTree.leaf a)) : S = LTree.leaf a := by
  cases h
  rfl

theorem Rot.nodes_eq {S T : LTree p α} (h : Rot S T) : S.nodes = T.nodes := by
  induction h with
  | leaf a => rfl
  | node f g r _ ih =>
    simp only [nodes_node]
    congr 1
    rw [← Finset.sum_congr rfl (fun i _ => ih i)]
    exact (Fintype.sum_equiv (Equiv.addRight r) (fun i => (f (i + r)).nodes)
      (fun i => (f i).nodes) (fun i => rfl)).symm

variable [DecidableEq α]

theorem Rot.lab_eq {S T : LTree p α} (h : Rot S T) : S.lab = T.lab := by
  induction h with
  | leaf a => rfl
  | node f g r _ ih =>
    ext x
    simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and]
    constructor
    · rintro ⟨i, hi⟩
      refine ⟨i - r, ?_⟩
      have h1 := ih (i - r)
      rw [sub_add_cancel] at h1
      rw [← h1]
      exact hi
    · rintro ⟨i, hi⟩
      exact ⟨i + r, by rw [ih i]; exact hi⟩

theorem Rot.good {S T : LTree p α} (h : Rot S T) : S.Good → T.Good := by
  induction h with
  | leaf a => exact id
  | node f g r h ih =>
    intro hf
    rw [good_node] at hf ⊢
    refine ⟨fun i => ih i (hf.1 (i + r)), fun i j hij => ?_⟩
    rw [← (h i).lab_eq, ← (h j).lab_eq]
    exact hf.2 (i + r) (j + r) (fun e => hij (add_right_cancel e))

end rot

/-! ### Good trees: counting labels -/

/-- In `Fin p` with `p ≥ 2` every element has a different one next to it. -/
theorem exists_ne (hp : 2 ≤ p) (i : Fin p) : ∃ j : Fin p, j ≠ i := by
  by_cases h : i.val = 0
  · exact ⟨⟨1, by omega⟩, fun h' => by
      have := congrArg Fin.val h'
      simp at this
      omega⟩
  · exact ⟨⟨0, by omega⟩, fun h' => by
      have := congrArg Fin.val h'
      simp at this
      omega⟩

theorem eq_leaf_of_nodes_eq_zero {T : LTree p α} (h : T.nodes = 0) : ∃ a, T = leaf a := by
  cases T with
  | leaf a => exact ⟨a, rfl⟩
  | node f => simp at h

section good

variable [DecidableEq α]

theorem lab_child_subset (f : Fin p → LTree p α) (i : Fin p) : (f i).lab ⊆ (node f).lab := by
  intro x hx
  simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and]
  exact ⟨i, hx⟩

/-- A `Good` tree with `t` nodes has `(p - 1) * t + 1` labels. -/
theorem Good.card_lab (hp : 2 ≤ p) {T : LTree p α} (h : T.Good) :
    (p - 1) * T.nodes + 1 = T.lab.card := by
  induction T with
  | leaf a => simp
  | node f ih =>
    rw [good_node] at h
    rw [lab_node, Finset.card_biUnion (fun i _ j _ hij => h.2 i j hij), nodes_node,
      ← Finset.sum_congr rfl (fun i _ => ih i (h.1 i)), Finset.sum_add_distrib, ← Finset.mul_sum]
    simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul, mul_one]
    have : p = (p - 1) + 1 := by omega
    rw [Nat.mul_add, Nat.mul_one]
    omega

/-- A `Good` tree with a single label is a leaf. -/
theorem Good.eq_leaf_of_card_lab_eq_one (hp : 2 ≤ p) {T : LTree p α} (h : T.Good)
    (h1 : T.lab.card = 1) : ∃ a, T = leaf a := by
  apply eq_leaf_of_nodes_eq_zero
  have h2 := h.card_lab hp
  rw [h1] at h2
  have hpos : 0 < p - 1 := by omega
  rcases Nat.eq_zero_or_pos T.nodes with h0 | h0
  · exact h0
  · have := Nat.mul_pos hpos h0
    omega

end good

/-! ### Class size -/

/-- The children of a node (a dummy family for a leaf). -/
def kids : LTree p α → Fin p → LTree p α
  | leaf a => fun _ => leaf a
  | node g => g

/-- The class of `node f`, described by the children. -/
def classEquiv (f : Fin p → LTree p α) :
    {S : LTree p α // Rot S (node f)} ≃
      {g : Fin p → LTree p α // ∃ r, ∀ i, Rot (g (i + r)) (f i)} where
  toFun S := ⟨kids S.1, by
    obtain ⟨S, hS⟩ := S
    cases hS with
    | node _ _ r h => exact ⟨r, h⟩⟩
  invFun g := ⟨node g.1, by
    obtain ⟨g, r, h⟩ := g
    exact Rot.node g f r h⟩
  left_inv := by
    rintro ⟨S, hS⟩
    cases hS
    rfl
  right_inv := by
    rintro ⟨g, hg⟩
    rfl

/-- **Class size for labelled trees.** The rotation class of a `Good` tree with `t` nodes has
exactly `p ^ t` trees. -/
theorem card_class [NeZero p] [DecidableEq α] {T : LTree p α} (hT : T.Good) :
    Nat.card {S : LTree p α // Rot S T} = p ^ T.nodes := by
  induction T with
  | leaf a =>
    have : Subsingleton {S : LTree p α // Rot S (leaf a)} :=
      ⟨by
        rintro ⟨S, hS⟩ ⟨S', hS'⟩
        cases hS
        cases hS'
        rfl⟩
    have : Nonempty {S : LTree p α // Rot S (leaf a)} := ⟨⟨leaf a, Rot.leaf a⟩⟩
    simp
  | node f ih =>
    rw [good_node] at hT
    rw [Nat.card_congr (classEquiv f)]
    have ih' : ∀ i, Nat.card {S : LTree p α // Rot S (f i)} = p ^ (f i).nodes :=
      fun i => ih i (hT.1 i)
    -- the product of the classes of the children
    have hprod : Nat.card {g : Fin p → LTree p α // ∀ i, Rot (g i) (f i)} =
        p ^ ∑ i, (f i).nodes := by
      rw [Nat.card_congr (Equiv.subtypePiEquivPi (p := fun i (S : LTree p α) => Rot S (f i))),
        Nat.card_pi]
      simp only [ih']
      exact Finset.prod_pow_eq_pow_sum _ _ _
    rw [nodes_node, pow_succ, ← hprod]
    have hcard : Nat.card (Fin p × {g : Fin p → LTree p α // ∀ i, Rot (g i) (f i)}) =
        p ^ (∑ i, (f i).nodes) * p := by
      rw [Nat.card_prod, hprod]
      simp [mul_comm]
    rw [← hprod] at hcard
    rw [← hcard]
    symm
    let φ : Fin p × {g : Fin p → LTree p α // ∀ i, Rot (g i) (f i)} →
        {g : Fin p → LTree p α // ∃ r, ∀ i, Rot (g (i + r)) (f i)} :=
      fun x => ⟨fun i => x.2.1 (i - x.1), ⟨x.1, fun i => by simpa using x.2.2 i⟩⟩
    refine Nat.card_eq_of_bijective φ ⟨?_, ?_⟩
    · -- injective: two different shifts would make two different children carry the same labels
      rintro ⟨r1, g1, h1⟩ ⟨r2, g2, h2⟩ heq
      have hfun : ∀ i, g1 (i - r1) = g2 (i - r2) :=
        fun i => congrFun (congrArg Subtype.val heq) i
      have hr : r1 = r2 := by
        by_contra hne
        have e := hfun (0 + r1)
        simp only [add_sub_cancel_right] at e
        have e' : g1 0 = g2 (0 + (r1 - r2)) := by
          rw [e, add_sub_assoc]
        have a : Rot (f 0) (f (0 + (r1 - r2))) := by
          have a := (h1 0).symm
          rw [e'] at a
          exact a.trans (h2 (0 + (r1 - r2)))
        have hne' : (0 : Fin p) ≠ 0 + (r1 - r2) := by
          intro h
          apply hne
          have h0 : r1 - r2 = 0 := by simpa using h.symm
          exact sub_eq_zero.mp h0
        have hd := hT.2 0 (0 + (r1 - r2)) hne'
        rw [← a.lab_eq] at hd
        exact (lab_nonempty (f 0)).ne_empty ((Finset.disjoint_self_iff_empty _).mp hd)
      subst hr
      have hg : g1 = g2 := by
        funext i
        have e := hfun (i + r1)
        simpa using e
      subst hg
      rfl
    · -- surjective
      rintro ⟨g, r, h⟩
      refine ⟨(r, ⟨fun i => g (i + r), h⟩), ?_⟩
      apply Subtype.ext
      funext i
      simp [φ]

/-! ### Finiteness -/

section finite

variable [DecidableEq α]

/-- There are finitely many `Good` trees with a given label set (`p ≥ 2`). -/
theorem finite_good_set (hp : 2 ≤ p) :
    ∀ (n : ℕ) (S : Finset α), S.card = n → {T : LTree p α | T.Good ∧ T.lab = S}.Finite := by
  have : NeZero p := ⟨by omega⟩
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro S hS
    have hsub : (⋃ S' ∈ {S' : Finset α | S' ⊂ S},
        {T : LTree p α | T.Good ∧ T.lab = S'}).Finite := by
      refine Set.Finite.biUnion ?_
        (fun S' hS' => ih S'.card (by rw [← hS]; exact Finset.card_lt_card hS') S' rfl)
      refine (Finset.finite_toSet S.powerset).subset (fun S' hS' => ?_)
      have h1 : S' ⊂ S := hS'
      simpa using h1.subset
    refine (((Finset.finite_toSet S).image leaf).union
      ((Set.Finite.pi' (fun _ : Fin p => hsub)).image node)).subset ?_
    intro T hT
    cases T with
    | leaf a =>
      left
      refine ⟨a, ?_, rfl⟩
      have h2 : ({a} : Finset α) = S := hT.2
      rw [← h2]
      simp
    | node f =>
      right
      have hg : (∀ i, (f i).Good) ∧ ∀ i j, i ≠ j → Disjoint (f i).lab (f j).lab := hT.1
      have hl : (node f).lab = S := hT.2
      refine ⟨f, fun i => ?_, rfl⟩
      refine Set.mem_iUnion₂.mpr ⟨(f i).lab, ?_, ⟨hg.1 i, rfl⟩⟩
      -- the label set of a child is a proper subset of `S`
      obtain ⟨j, hj⟩ := exists_ne hp i
      obtain ⟨x, hx⟩ := lab_nonempty (f j)
      have hxi : x ∉ (f i).lab := fun hxi => Finset.disjoint_left.mp (hg.2 j i hj) hx hxi
      have h1 : (f i).lab ⊂ S := by
        rw [← hl]
        refine Finset.ssubset_iff_subset_ne.mpr ⟨lab_child_subset f i, fun heq => hxi ?_⟩
        rw [heq]
        exact lab_child_subset f j hx
      exact h1

/-- There are finitely many trees with pairwise distinct labels and label set `S`. -/
theorem finite_good [hp : Fact p.Prime] (S : Finset α) :
    Finite {T : LTree p α // T.Good ∧ T.lab = S} :=
  (finite_good_set hp.out.two_le S.card S rfl).to_subtype

end finite

/-! ### Renaming labels -/

theorem map_map (g : α → β) (h : β → γ) (T : LTree p α) : (T.map g).map h = T.map (h ∘ g) := by
  induction T with
  | leaf a => rfl
  | node f ih =>
    simp only [map_node]
    congr 1
    funext i
    exact ih i

theorem map_id (T : LTree p α) : T.map id = T := by
  induction T with
  | leaf a => rfl
  | node f ih =>
    simp only [map_node]
    congr 1
    funext i
    exact ih i

theorem nodes_map (g : α → β) (T : LTree p α) : (T.map g).nodes = T.nodes := by
  induction T with
  | leaf a => rfl
  | node f ih => simp only [map_node, nodes_node, ih]

theorem Rot.map (g : α → β) {S T : LTree p α} (h : Rot S T) : Rot (S.map g) (T.map g) := by
  induction h with
  | leaf a => exact Rot.leaf (g a)
  | node f k r _ ih => exact Rot.node _ _ r ih

section mapdec

variable [DecidableEq α] [DecidableEq β]

theorem lab_map (g : α → β) (T : LTree p α) : (T.map g).lab = T.lab.image g := by
  induction T with
  | leaf a => simp
  | node f ih =>
    ext x
    simp only [map_node, lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and, ih,
      Finset.mem_image]
    constructor
    · rintro ⟨i, y, hy, rfl⟩
      exact ⟨y, ⟨i, hy⟩, rfl⟩
    · rintro ⟨y, ⟨i, hy⟩, rfl⟩
      exact ⟨i, y, hy, rfl⟩

theorem Good.map {g : α → β} (hg : Function.Injective g) {T : LTree p α} (h : T.Good) :
    (T.map g).Good := by
  induction T with
  | leaf a => exact good_leaf _
  | node f ih =>
    rw [good_node] at h
    rw [map_node, good_node]
    refine ⟨fun i => ih i (h.1 i), fun i j hij => ?_⟩
    rw [lab_map, lab_map]
    exact (Finset.disjoint_image hg).mpr (h.2 i j hij)

end mapdec

end LTree

end MMM

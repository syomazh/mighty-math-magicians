/-
Written by Claude Fable 5.2 (AI, a forked instance of the orchestrator), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **Step 4 of the main proof for `q = p`: the cherry collapse.**
  Let `p` be a prime and `S` a set of `(p - 1) * t + 1` labels. The number of `p`-ary plane trees
  whose leaves carry the labels of `S`, each once, is divisible by `p ^ t` and not by
  `p ^ (t + 1)` (`labelled_valuation`).

Proof, by induction on `t`. Choose `p` of the labels, a set `C`, and one of them, `c0`.

* Trees in which the labels of `C` form a cherry (a node whose `p` children are leaves): pruning
  the cherry to the single leaf `c0` is a bijection onto (orderings of `C`) × (trees on the label
  set `(S \ C) ∪ {c0}`), so there are `p ! * (number of smaller trees)` of them.
* The other trees: their rotation classes have `p ^ t` trees each, and a cyclic permutation `σ`
  of the labels of `C` permutes these classes without a fixed class (`cherry_of_fixed`: a class
  fixed by `σ` has the cherry). As `σ ^ p = 1`, the number of these classes is divisible by `p`,
  so the number of these trees is divisible by `p ^ (t + 1)`.

Since `p ! = p * (p - 1)!` and `p` does not divide `(p - 1)!`, the claim follows.
No factorial valuation (Legendre, Kummer) is used: the only fact about a factorial is that a
prime `p` does not divide `(p - 1)!`.

Difference from the paper: the paper counts the classes fixed by `σ` exactly (there are `p - 1`
cyclic orders compatible with `σ`), which also gives the residue; here all `p !` orders of the
cherry are put on one side, which gives the exact power of `p` but not the residue.
-/
import MMM.LRot
import Mathlib.GroupTheory.Perm.Fin
import Mathlib.Data.Nat.Prime.Factorial
import Mathlib.Data.Finite.Perm

namespace MMM

namespace LTree

variable {p : ℕ} {α : Type} [DecidableEq α]

/-! ### Cherries -/

/-- Some node of the tree has only leaves as children, and their labels are exactly `C`. -/
def CherryOn (C : Finset α) : LTree p α → Prop
  | leaf _ => False
  | node f => ((∀ i, ∃ x, f i = leaf x) ∧ (node f).lab = C) ∨ ∃ i, CherryOn C (f i)

theorem cherryOn_node (C : Finset α) (f : Fin p → LTree p α) :
    CherryOn C (node f) ↔
      ((∀ i, ∃ x, f i = leaf x) ∧ (node f).lab = C) ∨ ∃ i, CherryOn C (f i) := Iff.rfl

theorem not_cherryOn_leaf (C : Finset α) (a : α) : ¬ CherryOn C (leaf a : LTree p α) := id

theorem CherryOn.subset_lab {C : Finset α} {T : LTree p α} (h : CherryOn C T) : C ⊆ T.lab := by
  induction T with
  | leaf a => exact absurd h (not_cherryOn_leaf C a)
  | node f ih =>
    rcases (cherryOn_node C f).mp h with ⟨_, hl⟩ | ⟨i, hi⟩
    · rw [hl]
    · exact (ih i hi).trans (lab_child_subset f i)

/-- Having a cherry on `C` is a property of the rotation class. -/
theorem cherryOn_rot [NeZero p] {C : Finset α} {S T : LTree p α} (h : Rot S T) :
    CherryOn C S ↔ CherryOn C T := by
  induction h with
  | leaf a => exact Iff.rfl
  | node f g r h ih =>
    rw [cherryOn_node, cherryOn_node]
    have hlab : (node f).lab = (node g).lab := (Rot.node f g r h).lab_eq
    constructor
    · rintro (⟨hl, hC⟩ | ⟨i, hi⟩)
      · left
        refine ⟨fun i => ?_, hlab.symm.trans hC⟩
        obtain ⟨x, hx⟩ := hl (i + r)
        have h1 := h i
        rw [hx] at h1
        exact ⟨x, h1.symm.eq_leaf⟩
      · right
        refine ⟨i - r, (ih (i - r)).mp ?_⟩
        rw [sub_add_cancel]
        exact hi
    · rintro (⟨hl, hC⟩ | ⟨i, hi⟩)
      · left
        refine ⟨fun i => ?_, hlab.trans hC⟩
        obtain ⟨x, hx⟩ := hl (i - r)
        have h1 := h (i - r)
        rw [hx, sub_add_cancel] at h1
        exact ⟨x, h1.eq_leaf⟩
      · right
        exact ⟨i + r, (ih i).mpr hi⟩

/-- Renaming the labels by an injective map that keeps `C` in place does not create a cherry
on `C`. -/
theorem cherryOn_of_map {C : Finset α} {π : α → α} (hπ : Function.Injective π)
    (hC : C.image π = C) {T : LTree p α} (h : CherryOn C (T.map π)) : CherryOn C T := by
  induction T with
  | leaf a => exact absurd h (not_cherryOn_leaf C _)
  | node f ih =>
    rw [map_node, cherryOn_node] at h
    rw [cherryOn_node]
    rcases h with ⟨hl, hlab⟩ | ⟨i, hi⟩
    · left
      refine ⟨fun i => ?_, ?_⟩
      · obtain ⟨x, hx⟩ := hl i
        cases hfi : f i with
        | leaf y => exact ⟨y, rfl⟩
        | node g =>
          rw [hfi] at hx
          cases hx
      · have h2 : ((node f).map π).lab = C := hlab
        rw [lab_map] at h2
        exact Finset.image_injective hπ (h2.trans hC.symm)
    · right
      exact ⟨i, ih i hi⟩

/-! ### Grafting a cherry onto a leaf -/

/-- Replace the leaf labelled `c0` by a node whose children are the leaves `g 0, …, g (p-1)`. -/
def graft (c0 : α) (g : Fin p → α) : LTree p α → LTree p α
  | leaf x => if x = c0 then node (fun i => leaf (g i)) else leaf x
  | node f => node (fun i => graft c0 g (f i))

theorem graft_leaf_self (c0 : α) (g : Fin p → α) :
    graft c0 g (leaf c0 : LTree p α) = node (fun i => leaf (g i)) := by
  simp [graft]

theorem graft_leaf_of_ne {x c0 : α} (h : x ≠ c0) (g : Fin p → α) :
    graft c0 g (leaf x : LTree p α) = leaf x := by
  simp [graft, h]

theorem graft_node (c0 : α) (g : Fin p → α) (f : Fin p → LTree p α) :
    graft c0 g (node f) = node (fun i => graft c0 g (f i)) := rfl

theorem graft_of_notMem {c0 : α} (g : Fin p → α) {T : LTree p α} (h : c0 ∉ T.lab) :
    graft c0 g T = T := by
  induction T with
  | leaf x =>
    have hx : x ≠ c0 := fun e => h (by simp [e])
    exact graft_leaf_of_ne hx g
  | node f ih =>
    rw [graft_node]
    congr 1
    funext i
    exact ih i (fun hi => h (lab_child_subset f i hi))

theorem graft_ne_leaf (c0 : α) (g : Fin p → α) (T : LTree p α) : graft c0 g T ≠ leaf c0 := by
  cases T with
  | leaf x =>
    by_cases hx : x = c0
    · rw [hx, graft_leaf_self]
      intro h
      cases h
    · rw [graft_leaf_of_ne hx]
      intro h
      exact hx (LTree.leaf.inj h)
  | node f =>
    rw [graft_node]
    intro h
    cases h

theorem lab_cherry (g : Fin p → α) :
    (node (fun i => leaf (g i)) : LTree p α).lab = Finset.univ.image g := by
  rw [lab_node]
  simp only [lab_leaf]
  exact Finset.biUnion_singleton

theorem mem_lab_graft {c0 : α} {g : Fin p → α} {C : Finset α} (hg : Finset.univ.image g = C)
    (T : LTree p α) (x : α) :
    x ∈ (graft c0 g T).lab ↔ (x ∈ T.lab ∧ x ≠ c0) ∨ (c0 ∈ T.lab ∧ x ∈ C) := by
  induction T with
  | leaf y =>
    by_cases hy : y = c0
    · rw [hy, graft_leaf_self, lab_cherry, hg]
      simp
    · rw [graft_leaf_of_ne hy]
      simp only [lab_leaf, Finset.mem_singleton]
      constructor
      · intro h
        left
        exact ⟨h, by rw [h]; exact hy⟩
      · rintro (⟨h, _⟩ | ⟨h, _⟩)
        · exact h
        · exact absurd h.symm hy
  | node f ih =>
    simp only [graft_node, lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and, ih]
    constructor
    · rintro ⟨i, (⟨h1, h2⟩ | ⟨h1, h2⟩)⟩
      · exact Or.inl ⟨⟨i, h1⟩, h2⟩
      · exact Or.inr ⟨⟨i, h1⟩, h2⟩
    · rintro (⟨⟨i, h1⟩, h2⟩ | ⟨⟨i, h1⟩, h2⟩)
      · exact ⟨i, Or.inl ⟨h1, h2⟩⟩
      · exact ⟨i, Or.inr ⟨h1, h2⟩⟩

theorem good_graft {c0 : α} {g : Fin p → α} {C : Finset α} (hinj : Function.Injective g)
    (hg : Finset.univ.image g = C) {T : LTree p α} (hT : T.Good)
    (hTC : ∀ x ∈ T.lab, x ∈ C → x = c0) : (graft c0 g T).Good := by
  induction T with
  | leaf y =>
    by_cases hy : y = c0
    · rw [hy, graft_leaf_self, good_node]
      refine ⟨fun i => good_leaf _, fun i j hij => ?_⟩
      simp only [lab_leaf, Finset.disjoint_singleton]
      exact fun h => hij (hinj h)
    · rw [graft_leaf_of_ne hy]
      exact good_leaf _
  | node f ih =>
    rw [good_node] at hT
    rw [graft_node, good_node]
    refine ⟨fun i => ih i (hT.1 i) (fun x hx => hTC x (lab_child_subset f i hx)),
      fun i j hij => ?_⟩
    rw [Finset.disjoint_left]
    intro x hx1 hx2
    rw [mem_lab_graft hg] at hx1 hx2
    have hd := Finset.disjoint_left.mp (hT.2 i j hij)
    rcases hx1 with ⟨h1, h1'⟩ | ⟨h1, h1'⟩ <;> rcases hx2 with ⟨h2, h2'⟩ | ⟨h2, h2'⟩
    · exact hd h1 h2
    · exact h1' (hTC x (lab_child_subset f i h1) h2')
    · exact h2' (hTC x (lab_child_subset f j h2) h1')
    · exact hd h1 h2

theorem cherryOn_graft {c0 : α} {g : Fin p → α} {C : Finset α} (hg : Finset.univ.image g = C)
    {T : LTree p α} (hc : c0 ∈ T.lab) : CherryOn C (graft c0 g T) := by
  induction T with
  | leaf y =>
    have hy : y = c0 := by
      rw [lab_leaf, Finset.mem_singleton] at hc
      exact hc.symm
    rw [hy, graft_leaf_self, cherryOn_node]
    left
    exact ⟨fun i => ⟨g i, rfl⟩, (lab_cherry g).trans hg⟩
  | node f ih =>
    rw [graft_node, cherryOn_node]
    right
    simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and] at hc
    obtain ⟨i, hi⟩ := hc
    exact ⟨i, ih i hi⟩

/-- Grafting is injective, both in the tree and (when the leaf `c0` is present) in the cherry. -/
theorem graft_inj {c0 : α} {g g' : Fin p → α} (hc : ∃ i, g i = c0) (hc' : ∃ i, g' i = c0) :
    ∀ {T T' : LTree p α}, graft c0 g T = graft c0 g' T' → T = T' ∧ (c0 ∈ T.lab → g = g') := by
  intro T
  induction T with
  | leaf x =>
    intro T' h
    cases T' with
    | leaf y =>
      by_cases hx : x = c0 <;> by_cases hy : y = c0
      · rw [hx, hy] at h ⊢
        rw [graft_leaf_self, graft_leaf_self] at h
        refine ⟨rfl, fun _ => ?_⟩
        have h1 := LTree.node.inj h
        funext i
        exact LTree.leaf.inj (congrFun h1 i)
      · rw [hx, graft_leaf_self, graft_leaf_of_ne hy] at h
        cases h
      · rw [hy, graft_leaf_of_ne hx, graft_leaf_self] at h
        cases h
      · rw [graft_leaf_of_ne hx, graft_leaf_of_ne hy] at h
        refine ⟨h, fun hmem => ?_⟩
        rw [lab_leaf, Finset.mem_singleton] at hmem
        exact absurd hmem.symm hx
    | node f' =>
      exfalso
      by_cases hx : x = c0
      · rw [hx, graft_leaf_self, graft_node] at h
        have h1 := LTree.node.inj h
        obtain ⟨i0, hi0⟩ := hc
        have h2 := congrFun h1 i0
        rw [hi0] at h2
        exact graft_ne_leaf c0 g' (f' i0) h2.symm
      · rw [graft_leaf_of_ne hx, graft_node] at h
        cases h
  | node f ih =>
    intro T' h
    cases T' with
    | leaf y =>
      exfalso
      by_cases hy : y = c0
      · rw [hy, graft_leaf_self, graft_node] at h
        have h1 := LTree.node.inj h
        obtain ⟨i0, hi0⟩ := hc'
        have h2 := congrFun h1 i0
        rw [hi0] at h2
        exact graft_ne_leaf c0 g (f i0) h2
      · rw [graft_node, graft_leaf_of_ne hy] at h
        cases h
    | node f' =>
      rw [graft_node, graft_node] at h
      have h1 := LTree.node.inj h
      have h2 : ∀ i, f i = f' i ∧ (c0 ∈ (f i).lab → g = g') := fun i => ih i (congrFun h1 i)
      refine ⟨?_, fun hmem => ?_⟩
      · congr 1
        funext i
        exact (h2 i).1
      · simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and] at hmem
        obtain ⟨i, hi⟩ := hmem
        exact (h2 i).2 hi

/-- Every tree with a cherry on `C` is a graft: prune the cherry to the leaf `c0`. -/
theorem exists_graft {c0 : α} {C : Finset α} (hc0 : c0 ∈ C) {T : LTree p α} (hT : T.Good)
    (hch : CherryOn C T) :
    ∃ g : Fin p → α, Function.Injective g ∧ Finset.univ.image g = C ∧
      ∃ T' : LTree p α, T'.Good ∧ T'.lab = insert c0 (T.lab \ C) ∧ graft c0 g T' = T := by
  induction T with
  | leaf a => exact absurd hch (not_cherryOn_leaf C a)
  | node f ih =>
    have hT' := (good_node f).mp hT
    rcases (cherryOn_node C f).mp hch with ⟨hleaf, hlab⟩ | ⟨i0, hi0⟩
    · -- the root is the cherry
      choose g hg using hleaf
      have hf : f = fun i => leaf (g i) := funext hg
      refine ⟨g, ?_, ?_, leaf c0, good_leaf _, ?_, ?_⟩
      · intro i j hij
        by_contra hne
        have hd := hT'.2 i j hne
        rw [hg i, hg j, lab_leaf, lab_leaf, Finset.disjoint_singleton] at hd
        exact hd hij
      · rw [← hlab, hf, lab_cherry]
      · rw [hlab]
        simp
      · rw [graft_leaf_self, hf]
    · -- the cherry is inside the child `i0`
      obtain ⟨g, hinj, himg, T0, hT0, hlab0, hgr0⟩ := ih i0 (hT'.1 i0) hi0
      have hCsub : C ⊆ (f i0).lab := hi0.subset_lab
      have hc0mem : c0 ∈ (f i0).lab := hCsub hc0
      have hT0sub : T0.lab ⊆ (f i0).lab := by
        rw [hlab0]
        intro x hx
        rcases Finset.mem_insert.mp hx with h | h
        · rw [h]
          exact hc0mem
        · exact (Finset.mem_sdiff.mp h).1
      refine ⟨g, hinj, himg, node (Function.update f i0 T0), ?_, ?_, ?_⟩
      · rw [good_node]
        refine ⟨fun i => ?_, fun i j hij => ?_⟩
        · by_cases hi : i = i0
          · rw [hi, Function.update_self]
            exact hT0
          · rw [Function.update_of_ne hi]
            exact hT'.1 i
        · by_cases hi : i = i0
          · have hj : j ≠ i0 := fun e => hij (hi.trans e.symm)
            rw [hi, Function.update_self, Function.update_of_ne hj]
            exact Finset.disjoint_of_subset_left hT0sub (hT'.2 i0 j (fun e => hj e.symm))
          · by_cases hj : j = i0
            · rw [hj, Function.update_self, Function.update_of_ne hi]
              exact Finset.disjoint_of_subset_right hT0sub (hT'.2 i i0 hi)
            · rw [Function.update_of_ne hi, Function.update_of_ne hj]
              exact hT'.2 i j hij
      · ext x
        simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and, Finset.mem_insert,
          Finset.mem_sdiff]
        constructor
        · rintro ⟨i, hx⟩
          by_cases hi : i = i0
          · rw [hi, Function.update_self, hlab0] at hx
            rcases Finset.mem_insert.mp hx with h | h
            · exact Or.inl h
            · exact Or.inr ⟨⟨i0, (Finset.mem_sdiff.mp h).1⟩, (Finset.mem_sdiff.mp h).2⟩
          · rw [Function.update_of_ne hi] at hx
            exact Or.inr ⟨⟨i, hx⟩,
              fun hxC => Finset.disjoint_left.mp (hT'.2 i i0 hi) hx (hCsub hxC)⟩
        · rintro (h | ⟨⟨i, hx⟩, hxC⟩)
          · refine ⟨i0, ?_⟩
            rw [Function.update_self, hlab0, h]
            exact Finset.mem_insert_self _ _
          · by_cases hi : i = i0
            · refine ⟨i0, ?_⟩
              rw [Function.update_self, hlab0]
              rw [hi] at hx
              exact Finset.mem_insert_of_mem (Finset.mem_sdiff.mpr ⟨hx, hxC⟩)
            · exact ⟨i, by rw [Function.update_of_ne hi]; exact hx⟩
      · rw [graft_node]
        congr 1
        funext i
        by_cases hi : i = i0
        · rw [hi, Function.update_self]
          exact hgr0
        · rw [Function.update_of_ne hi]
          exact graft_of_notMem g
            (fun h => Finset.disjoint_left.mp (hT'.2 i i0 hi) h hc0mem)

/-- The label set of a graft. -/
theorem lab_graft_eq {c0 : α} {g : Fin p → α} {S C : Finset α} (hg : Finset.univ.image g = C)
    (hCS : C ⊆ S) (hc0 : c0 ∈ C) {T : LTree p α} (hl : T.lab = insert c0 (S \ C)) :
    (graft c0 g T).lab = S := by
  ext x
  rw [mem_lab_graft hg, hl]
  constructor
  · rintro (⟨h1, h2⟩ | ⟨_, h2⟩)
    · rcases Finset.mem_insert.mp h1 with h | h
      · exact absurd h h2
      · exact (Finset.mem_sdiff.mp h).1
    · exact hCS h2
  · intro hx
    by_cases hxC : x ∈ C
    · exact Or.inr ⟨Finset.mem_insert_self _ _, hxC⟩
    · refine Or.inl ⟨Finset.mem_insert_of_mem (Finset.mem_sdiff.mpr ⟨hx, hxC⟩), fun e => hxC ?_⟩
      rw [e]
      exact hc0

/-- The number of ways to put the labels of `C` on the `p` leaves of a cherry. -/
theorem card_orderings {C : Finset α} (hC : C.card = p) :
    Nat.card {g : Fin p → α // Function.Injective g ∧ Finset.univ.image g = C} =
      p.factorial := by
  have e0 : {x // x ∈ C} ≃ Fin p := Fintype.equivFinOfCardEq (by simpa using hC)
  have e : {g : Fin p → α // Function.Injective g ∧ Finset.univ.image g = C} ≃
      (Fin p ≃ {x // x ∈ C}) :=
    { toFun := fun g =>
        Equiv.ofBijective
          (fun i => ⟨g.1 i, by
            have h := Finset.mem_image_of_mem g.1 (Finset.mem_univ i)
            rw [g.2.2] at h
            exact h⟩)
          ⟨fun i j h => g.2.1 (congrArg Subtype.val h), fun x => by
            have hx : x.1 ∈ Finset.univ.image g.1 := by
              rw [g.2.2]
              exact x.2
            obtain ⟨i, -, hi⟩ := Finset.mem_image.mp hx
            exact ⟨i, Subtype.ext hi⟩⟩
      invFun := fun e =>
        ⟨fun i => (e i).1, fun i j h => e.injective (Subtype.ext h), by
          ext x
          simp only [Finset.mem_image, Finset.mem_univ, true_and]
          constructor
          · rintro ⟨i, rfl⟩
            exact (e i).2
          · intro hx
            exact ⟨e.symm ⟨x, hx⟩, by simp⟩⟩
      left_inv := fun g => rfl
      right_inv := fun e => by
        ext i
        rfl }
  rw [Nat.card_congr e, Nat.card_congr (Equiv.equivCongr (Equiv.refl (Fin p)) e0),
    Nat.card_perm]
  simp

/-- **The trees with the cherry.** There are `p !` times as many of them as there are trees
on the smaller label set `(S \ C) ∪ {c0}`. -/
theorem card_cherry {S C : Finset α} (hCS : C ⊆ S) (hC : C.card = p) {c0 : α} (hc0 : c0 ∈ C) :
    Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S} // CherryOn C x.1} =
      p.factorial * Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C)} := by
  rw [← card_orderings hC, ← Nat.card_prod]
  symm
  have hmem : ∀ T' : {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C)},
      ∀ x ∈ T'.1.lab, x ∈ C → x = c0 := by
    intro T' x hx hxC
    rw [T'.2.2] at hx
    rcases Finset.mem_insert.mp hx with h | h
    · exact h
    · exact absurd hxC (Finset.mem_sdiff.mp h).2
  have hc0' : ∀ T' : {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C)}, c0 ∈ T'.1.lab := by
    intro T'
    rw [T'.2.2]
    exact Finset.mem_insert_self _ _
  let Φ : {g : Fin p → α // Function.Injective g ∧ Finset.univ.image g = C} ×
      {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C)} →
      {x : {T : LTree p α // T.Good ∧ T.lab = S} // CherryOn C x.1} :=
    fun x => ⟨⟨graft c0 x.1.1 x.2.1, good_graft x.1.2.1 x.1.2.2 x.2.2.1 (hmem x.2),
      lab_graft_eq x.1.2.2 hCS hc0 x.2.2.2⟩, cherryOn_graft x.1.2.2 (hc0' x.2)⟩
  refine Nat.card_eq_of_bijective Φ ⟨?_, ?_⟩
  · rintro ⟨g, T'⟩ ⟨g', T''⟩ h
    have h1 : graft c0 g.1 T'.1 = graft c0 g'.1 T''.1 :=
      congrArg (fun y => y.1.1) h
    have hex : ∀ g : {g : Fin p → α // Function.Injective g ∧ Finset.univ.image g = C},
        ∃ i, g.1 i = c0 := by
      intro g
      have h0 : c0 ∈ Finset.univ.image g.1 := by
        rw [g.2.2]
        exact hc0
      obtain ⟨i, -, hi⟩ := Finset.mem_image.mp h0
      exact ⟨i, hi⟩
    obtain ⟨h2, h3⟩ := graft_inj (hex g) (hex g') h1
    exact Prod.ext (Subtype.ext (h3 (hc0' T'))) (Subtype.ext h2)
  · rintro ⟨⟨T, hT, hl⟩, hch⟩
    obtain ⟨g, hinj, himg, T', hT', hl', hgr⟩ := exists_graft hc0 hT hch
    refine ⟨(⟨g, hinj, himg⟩, ⟨T', hT', by rw [hl', hl]⟩), ?_⟩
    apply Subtype.ext
    apply Subtype.ext
    exact hgr

/-! ### A cyclic permutation of the labels in `C` -/

theorem perm_mem_of_fix {C : Finset α} {π : Equiv.Perm α} (hπ : ∀ x, x ∉ C → π x = x)
    {x : α} (hx : x ∈ C) : π x ∈ C := by
  by_contra h
  have h1 := hπ (π x) h
  have h2 := π.injective h1
  rw [h2] at h
  exact h hx

theorem image_eq_of_mapsTo {A : Finset α} {π : α → α} (hπ : Function.Injective π)
    (h : ∀ x ∈ A, π x ∈ A) : A.image π = A :=
  Finset.eq_of_subset_of_card_le (Finset.image_subset_iff.mpr h)
    (by rw [Finset.card_image_of_injective _ hπ])

/-- A permutation of the labels with `σ ^ p = 1` that fixes every label outside `C` and moves
the labels of `C` in one cycle (stated as: a `σ`-stable set that meets `C` contains `C`). -/
theorem exists_cycle (hp2 : 2 ≤ p) {C : Finset α} (hC : C.card = p) :
    ∃ σ : Equiv.Perm α, σ ^ p = 1 ∧ (∀ x, x ∉ C → σ x = x) ∧
      ∀ A : Finset α, (∀ x ∈ A, σ x ∈ A) → ∀ c ∈ A, c ∈ C → C ⊆ A := by
  obtain ⟨n, rfl⟩ : ∃ n, p = n + 2 := ⟨p - 2, by omega⟩
  let e : {x // x ∈ C} ≃ Fin (n + 2) := Fintype.equivFinOfCardEq (by simpa using hC)
  let ρ : Equiv.Perm (Fin (n + 2)) := finRotate (n + 2)
  have hρ : ρ ^ (n + 2) = 1 := by
    have h1 : orderOf ρ = n + 2 := by
      rw [Equiv.Perm.IsCycle.orderOf isCycle_finRotate, support_finRotate, Finset.card_univ,
        Fintype.card_fin]
    have h2 := pow_orderOf_eq_one ρ
    rwa [h1] at h2
  let τ : Equiv.Perm {x // x ∈ C} := (e.trans ρ).trans e.symm
  have hτ : ∀ (k : ℕ) (x : {x // x ∈ C}), (τ ^ k) x = e.symm ((ρ ^ k) (e x)) := by
    intro k
    induction k with
    | zero =>
      intro x
      simp
    | succ k ih =>
      intro x
      rw [pow_succ', Equiv.Perm.mul_apply, ih, pow_succ', Equiv.Perm.mul_apply]
      simp [τ]
  refine ⟨Equiv.Perm.ofSubtype τ, ?_, ?_, ?_⟩
  · rw [← map_pow]
    have h1 : τ ^ (n + 2) = 1 := by
      refine Equiv.ext fun x => ?_
      rw [hτ, hρ]
      simp
    rw [h1, map_one]
  · intro x hx
    exact Equiv.Perm.ofSubtype_apply_of_not_mem τ hx
  · intro A hA c hcA hcC c' hc'
    have hpow : ∀ k : ℕ, ((Equiv.Perm.ofSubtype τ) ^ k) c ∈ A := by
      intro k
      induction k with
      | zero => simpa using hcA
      | succ k ih =>
        rw [pow_succ', Equiv.Perm.mul_apply]
        exact hA _ ih
    obtain ⟨k, hk⟩ := Equiv.Perm.IsCycle.exists_pow_eq (isCycle_finRotate (n := n))
      (x := e ⟨c, hcC⟩) (y := e ⟨c', hc'⟩)
      (by rw [← Equiv.Perm.mem_support, support_finRotate]; exact Finset.mem_univ _)
      (by rw [← Equiv.Perm.mem_support, support_finRotate]; exact Finset.mem_univ _)
    have h1 : ((Equiv.Perm.ofSubtype τ) ^ k) c = c' := by
      rw [← map_pow, Equiv.Perm.ofSubtype_apply_of_mem _ hcC, hτ]
      have hk' : (ρ ^ k) (e ⟨c, hcC⟩) = e ⟨c', hc'⟩ := hk
      rw [hk']
      simp
    rw [← h1]
    exact hpow k

/-! ### The core lemma: a class fixed by `σ` has the cherry -/

/-- If renaming the labels by `σ` gives a tree in the same rotation class, then the labels of
`C` form a cherry. -/
theorem cherry_of_fixed (hp2 : 2 ≤ p) {C : Finset α} (hC : C.card = p) {σ : Equiv.Perm α}
    (hfix : ∀ x, x ∉ C → σ x = x)
    (horb : ∀ A : Finset α, (∀ x ∈ A, σ x ∈ A) → ∀ c ∈ A, c ∈ C → C ⊆ A)
    (T : LTree p α) (hT : T.Good) (hCT : C ⊆ T.lab) (h : Rot (T.map σ) T) : CherryOn C T := by
  have : NeZero p := ⟨by omega⟩
  induction T with
  | leaf a =>
    exfalso
    have h1 := Finset.card_le_card hCT
    rw [hC, lab_leaf, Finset.card_singleton] at h1
    omega
  | node f ih =>
    have hT' := (good_node f).mp hT
    rw [map_node] at h
    cases h with
    | node _ _ r hr =>
      have hr' : ∀ i, Rot ((f (i + r)).map σ) (f i) := hr
      have hlab : ∀ i, ((f (i + r)).lab).image σ = (f i).lab := fun i => by
        rw [← lab_map]
        exact (hr' i).lab_eq
      rw [cherryOn_node]
      by_cases hr0 : r = 0
      · -- no shift at the root: `C` lies inside one child
        right
        rw [hr0] at hr' hlab
        simp only [add_zero] at hr' hlab
        obtain ⟨c, hc⟩ : C.Nonempty := by
          rw [← Finset.card_pos, hC]
          omega
        have hc' := hCT hc
        simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and] at hc'
        obtain ⟨i0, hi0⟩ := hc'
        have hstab : ∀ x ∈ (f i0).lab, σ x ∈ (f i0).lab := fun x hx => by
          rw [← hlab i0]
          exact Finset.mem_image_of_mem _ hx
        exact ⟨i0, ih i0 (hT'.1 i0) (horb _ hstab c hi0 hc) (hr' i0)⟩
      · -- a shift at the root: every label lies in `C`, so the root is the cherry
        left
        have hsub : (node f).lab ⊆ C := by
          intro x hx
          by_contra hxC
          simp only [lab_node, Finset.mem_biUnion, Finset.mem_univ, true_and] at hx
          obtain ⟨j, hj⟩ := hx
          have h0 : σ x ∈ ((f j).lab).image σ := Finset.mem_image_of_mem _ hj
          rw [hfix x hxC] at h0
          have h1 : x ∈ (f (j - r)).lab := by
            have h2 := hlab (j - r)
            rw [sub_add_cancel] at h2
            rw [← h2]
            exact h0
          have hne : j - r ≠ j := fun e => hr0 (by simpa using e)
          exact Finset.disjoint_left.mp (hT'.2 (j - r) j hne) h1 hj
        have heq : (node f).lab = C := Finset.Subset.antisymm hsub hCT
        refine ⟨fun i => ?_, heq⟩
        apply eq_leaf_of_nodes_eq_zero
        have h1 := hT.card_lab hp2
        rw [heq, hC, nodes_node] at h1
        have h2 : ∑ i, (f i).nodes = 0 := by
          have hpos : 0 < p - 1 := by omega
          rcases Nat.eq_zero_or_pos (∑ i, (f i).nodes) with h0 | h0
          · exact h0
          · have h3 := Nat.mul_pos hpos h0
            rw [Nat.mul_add] at h1
            omega
        exact Finset.sum_eq_zero_iff.mp h2 i (Finset.mem_univ i)

/-! ### The trees without the cherry -/

/-- The trees with label set `S` in which `C` is not a cherry. -/
abbrev NoCherry (p : ℕ) (S C : Finset α) : Type :=
  {x : {T : LTree p α // T.Good ∧ T.lab = S} // ¬ CherryOn C x.1}

/-- Renaming the labels by a permutation that fixes everything outside `C`. -/
def mapNC {S C : Finset α} (hCS : C ⊆ S) (π : Equiv.Perm α) (hπ : ∀ x, x ∉ C → π x = x) :
    NoCherry p S C → NoCherry p S C :=
  fun z => ⟨⟨z.1.1.map π, z.1.2.1.map π.injective, by
      rw [lab_map, z.1.2.2]
      refine image_eq_of_mapsTo π.injective (fun x hx => ?_)
      by_cases hxC : x ∈ C
      · exact hCS (perm_mem_of_fix hπ hxC)
      · rw [hπ x hxC]
        exact hx⟩,
    fun h => z.2 (cherryOn_of_map π.injective
      (image_eq_of_mapsTo π.injective (fun x hx => perm_mem_of_fix hπ hx)) h)⟩

section prime

variable [hp : Fact p.Prime]

/-- **The trees without the cherry.** Their number is divisible by `p ^ (t + 1)`, where
`t` is the number of nodes. -/
theorem pow_succ_dvd_card_noCherry (t : ℕ) {S C : Finset α} (hS : S.card = (p - 1) * t + 1)
    (hCS : C ⊆ S) (hC : C.card = p) : p ^ (t + 1) ∣ Nat.card (NoCherry p S C) := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have : NeZero p := ⟨hp.out.ne_zero⟩
  obtain ⟨σ, hσp, hσfix, hσorb⟩ := exists_cycle hp2 hC
  have hfin : Finite {T : LTree p α // T.Good ∧ T.lab = S} := finite_good S
  let s : Setoid (NoCherry p S C) :=
    ⟨fun a b => Rot a.1.1 b.1.1,
      ⟨fun a => Rot.refl a.1.1, fun h => h.symm, fun h1 h2 => h1.trans h2⟩⟩
  -- every rotation class has `p ^ t` trees
  have hclass : ∀ z : NoCherry p S C, Nat.card {y : NoCherry p S C // s.r y z} = p ^ t := by
    intro z
    let e : {y : NoCherry p S C // s.r y z} ≃ {V : LTree p α // Rot V z.1.1} :=
      { toFun := fun y => ⟨y.1.1.1, y.2⟩
        invFun := fun V =>
          ⟨⟨⟨V.1, V.2.symm.good z.1.2.1, V.2.lab_eq.trans z.1.2.2⟩,
            fun h => z.2 ((cherryOn_rot V.2).mp h)⟩, V.2⟩
        left_inv := fun y => rfl
        right_inv := fun V => rfl }
    rw [Nat.card_congr e, card_class z.1.2.1]
    congr 1
    have h1 := z.1.2.1.card_lab hp2
    rw [z.1.2.2, hS] at h1
    have hpos : 0 < p - 1 := by omega
    exact Nat.eq_of_mul_eq_mul_left hpos (by omega)
  have hZ := card_eq_mul_card_quotient s (p ^ t) hclass
  -- the map induced by `σ` on the classes
  let φ : Quotient s → Quotient s :=
    Quotient.map (mapNC hCS σ hσfix) (fun a b h => Rot.map σ h)
  have hiter : ∀ (k : ℕ) (z : NoCherry p S C),
      ((mapNC hCS σ hσfix)^[k] z).1.1 = z.1.1.map (⇑(σ ^ k)) := by
    intro k
    induction k with
    | zero =>
      intro z
      exact (map_id z.1.1).symm
    | succ k ih =>
      intro z
      rw [Function.iterate_succ_apply']
      have h1 : (mapNC hCS σ hσfix ((mapNC hCS σ hσfix)^[k] z)).1.1 =
          (((mapNC hCS σ hσfix)^[k] z).1.1).map σ := rfl
      rw [h1, ih, map_map, pow_succ', Equiv.Perm.coe_mul]
  have hφk : ∀ (k : ℕ) (z : NoCherry p S C),
      φ^[k] (Quotient.mk s z) = Quotient.mk s ((mapNC hCS σ hσfix)^[k] z) := by
    intro k
    induction k with
    | zero =>
      intro z
      rfl
    | succ k ih =>
      intro z
      rw [Function.iterate_succ_apply', ih, Function.iterate_succ_apply']
      rfl
  have hφp : φ^[p ^ 1] = id := by
    funext q
    induction q using Quotient.inductionOn with
    | _ z =>
      rw [pow_one, hφk]
      apply congrArg
      apply Subtype.ext
      apply Subtype.ext
      rw [hiter, hσp]
      exact map_id _
  have hnofix : ∀ q : Quotient s, φ q ≠ q := by
    intro q
    induction q using Quotient.inductionOn with
    | _ z =>
      intro h
      have h1 : Rot (z.1.1.map σ) z.1.1 := Quotient.exact h
      have hCz : C ⊆ z.1.1.lab := by
        rw [z.1.2.2]
        exact hCS
      exact z.2 (cherry_of_fixed hp2 hC hσfix hσorb z.1.1 z.1.2.1 hCz h1)
  classical
  have : Fintype (Quotient s) := Fintype.ofFinite _
  have hmod := Equiv.Perm.card_fixedPoints_modEq (f := φ) (p := p) (n := 1) hφp
  have hempty : IsEmpty (Function.fixedPoints φ) := ⟨fun q => hnofix q.1 q.2⟩
  have hzero : Fintype.card (Function.fixedPoints φ) = 0 := Fintype.card_eq_zero
  rw [hzero] at hmod
  have hdvd : p ∣ Nat.card (Quotient s) := by
    rw [Nat.card_eq_fintype_card]
    exact Nat.modEq_zero_iff_dvd.mp hmod
  rw [hZ, pow_succ]
  exact Nat.mul_dvd_mul_left _ hdvd

/-- **Step 4 (`q = p`): the exact power of `p` in the number of labelled trees.**
For a set `S` of `(p - 1) * t + 1` labels, the number of `p`-ary plane trees whose leaves carry
the labels of `S`, each exactly once, is divisible by `p ^ t` and not by `p ^ (t + 1)`. -/
theorem labelled_valuation (t : ℕ) (S : Finset α) (hS : S.card = (p - 1) * t + 1) :
    p ^ t ∣ Nat.card {T : LTree p α // T.Good ∧ T.lab = S} ∧
    ¬ p ^ (t + 1) ∣ Nat.card {T : LTree p α // T.Good ∧ T.lab = S} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  induction t generalizing S with
  | zero =>
    have h1 : S.card = 1 := by simpa using hS
    obtain ⟨a, rfl⟩ := Finset.card_eq_one.mp h1
    have hcard : Nat.card {T : LTree p α // T.Good ∧ T.lab = {a}} = 1 := by
      rw [Nat.card_eq_one_iff_unique]
      refine ⟨⟨?_⟩, ⟨⟨leaf a, good_leaf a, rfl⟩⟩⟩
      rintro ⟨T, hT, hl⟩ ⟨T', hT', hl'⟩
      apply Subtype.ext
      obtain ⟨b, rfl⟩ := hT.eq_leaf_of_card_lab_eq_one hp2 (by rw [hl]; rfl)
      obtain ⟨b', rfl⟩ := hT'.eq_leaf_of_card_lab_eq_one hp2 (by rw [hl']; rfl)
      rw [lab_leaf, Finset.singleton_inj] at hl hl'
      subst hl
      subst hl'
      rfl
    rw [hcard]
    refine ⟨one_dvd _, ?_⟩
    rw [zero_add, pow_one, Nat.dvd_one]
    omega
  | succ t ih =>
    have hpS : p ≤ S.card := by
      rw [hS, Nat.mul_succ]
      omega
    obtain ⟨C, hCS, hC⟩ := Finset.exists_subset_card_eq hpS
    obtain ⟨c0, hc0⟩ : C.Nonempty := by
      rw [← Finset.card_pos, hC]
      omega
    have hS' : (insert c0 (S \ C)).card = (p - 1) * t + 1 := by
      rw [Finset.card_insert_of_notMem (by simp [hc0]), Finset.card_sdiff_of_subset hCS, hS, hC,
        Nat.mul_succ]
      omega
    obtain ⟨ih1, ih2⟩ := ih (insert c0 (S \ C)) hS'
    have hfin : Finite {T : LTree p α // T.Good ∧ T.lab = S} := finite_good S
    have hsplit : Nat.card {T : LTree p α // T.Good ∧ T.lab = S} =
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S} // CherryOn C x.1} +
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S} // ¬ CherryOn C x.1} := by
      classical
      rw [← Nat.card_sum]
      exact Nat.card_congr (Equiv.sumCompl _).symm
    have hY := card_cherry (p := p) hCS hC hc0
    have hZ : p ^ (t + 1 + 1) ∣
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S} // ¬ CherryOn C x.1} :=
      pow_succ_dvd_card_noCherry (t + 1) hS hCS hC
    have hfact : p.factorial = p * (p - 1).factorial :=
      (Nat.mul_factorial_pred hp.out.ne_zero).symm
    have hcop : ¬ p ∣ (p - 1).factorial := by
      rw [hp.out.dvd_factorial]
      omega
    rw [hsplit, hY, hfact]
    constructor
    · refine Nat.dvd_add ?_ (dvd_trans (pow_dvd_pow p (Nat.le_succ _)) hZ)
      rw [pow_succ', mul_assoc]
      exact Nat.mul_dvd_mul_left p (Dvd.dvd.mul_left ih1 _)
    · intro hdvd
      have h1 := Nat.dvd_sub hdvd hZ
      rw [Nat.add_sub_cancel, pow_succ', mul_assoc] at h1
      have h2 : p ^ (t + 1) ∣ (p - 1).factorial *
          Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C)} :=
        Nat.dvd_of_mul_dvd_mul_left hp.out.pos h1
      have h3 : Nat.Coprime (p ^ (t + 1)) (p - 1).factorial :=
        Nat.Coprime.pow_left _ (hp.out.coprime_iff_not_dvd.mpr hcop)
      exact ih2 (h3.dvd_of_dvd_mul_left h2)

end prime

end LTree

end MMM

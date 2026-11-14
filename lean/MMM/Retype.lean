/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Equal atoms** (the step of the paper where the atoms of equal size are told apart by labels).

Typed trees are counted by *content*: how many leaves of each type. If one leaf of type `j` is
given a new type `j'`, every tree with the old content comes from exactly `c` trees with the new
content, where `c` is the number of leaves of type `j` (`card_refine`). Repeating this until all
types are different (`exists_distinct`) shows:

    (number of trees with all types different) = K * (number of trees with the given content)

for some natural number `K`. This is all that is needed to pass the non-divisibility by
`p ^ (t + 1)` from the labelled trees of Step 4 to the minimal trees.

Also here: a typed tree with fewer than `p` leaves of each type is carry-free, and its weight has
these numbers as digits (`carryFree_of_cnt_lt`), so the carry-free trees of weight `m` are the
trees whose content is the digits of `m` (`typed_iff_cnt`).

Difference from the paper: the paper divides by `∏ m_j!` using a free action of permutations of
equal atoms; here one atom is relabelled at a time, which gives the same factor step by step
and needs no group action.
-/
import MMM.Atoms
import MMM.DigitsFree
import Mathlib.Data.Multiset.Count
import Mathlib.Data.Fintype.EquivFin

namespace MMM

namespace LTree

variable {p : ℕ}

/-! ### Content and digits -/

/-- A typed tree with fewer than `p` leaves of each type is carry-free, and the digits of its
weight are the numbers of leaves of each type. -/
theorem carryFree_of_cnt_lt (hp : 2 ≤ p) : ∀ U : LTree p ℕ, (∀ j, U.cnt j < p) →
    U.CarryFree ∧ ∀ j, dig p j U.wt = U.cnt j := by
  intro U
  induction U with
  | leaf i =>
    intro _
    exact ⟨trivial, fun j => by simp [dig_pow hp]⟩
  | node f ih =>
    intro h
    have hle : ∀ i j, (f i).cnt j ≤ (node f).cnt j := fun i j =>
      Finset.single_le_sum (f := fun i => (f i).cnt j) (fun _ _ => Nat.zero_le _)
        (Finset.mem_univ i)
    have hch := fun i => ih i (fun j => lt_of_le_of_lt (hle i j) (h j))
    have hdig : ∀ j, ∑ i, dig p j (f i).wt = (node f).cnt j := fun j => by
      rw [cnt_node]
      exact Finset.sum_congr rfl (fun i _ => (hch i).2 j)
    have hds : ds p (∑ i, (f i).wt) = ∑ i, ds p (f i).wt :=
      ds_sum_of_dig_lt hp _ _ (fun j => by rw [hdig]; exact h j)
    refine ⟨⟨fun i => (hch i).1, hds⟩, fun j => ?_⟩
    rw [wt_node, dig_sum hp _ _ hds j, hdig]

/-- **The carry-free typed trees of weight `m` are the trees whose content is the digits of
`m`.** -/
theorem typed_iff_cnt (hp : 2 ≤ p) (m : ℕ) (U : LTree p ℕ) :
    (U.CarryFree ∧ U.wt = m) ↔ ∀ j, U.cnt j = dig p j m := by
  constructor
  · rintro ⟨hc, rfl⟩ j
    exact cnt_eq_dig hp U hc j
  · intro h
    obtain ⟨hc, hd⟩ := carryFree_of_cnt_lt hp U (fun j => by rw [h j]; exact dig_lt hp j m)
    exact ⟨hc, eq_of_dig_eq hp _ _ (fun j => by rw [hd j, h j])⟩

/-! ### Giving one leaf a new type -/

/-- Rename the type `j'` to `j`. -/
def merge (j j' : ℕ) (x : ℕ) : ℕ := if x = j' then j else x

theorem map_merge_of_cnt_zero (j j' : ℕ) (V : LTree p ℕ) (h : V.cnt j' = 0) :
    V.map (merge j j') = V := by
  induction V with
  | leaf x =>
    have hx : x ≠ j' := by
      intro e
      simp [e] at h
    simp [merge, hx]
  | node f ih =>
    simp only [cnt_node] at h
    have h' : ∀ i, (f i).cnt j' = 0 := fun i => Finset.sum_eq_zero_iff.mp h i (Finset.mem_univ i)
    simp only [map_node]
    congr 1
    funext i
    exact ih i (h' i)

theorem cnt_map_merge {j j' : ℕ} (hjj : j ≠ j') (V : LTree p ℕ) (i : ℕ) :
    (V.map (merge j j')).cnt i =
      if i = j then V.cnt j + V.cnt j' else if i = j' then 0 else V.cnt i := by
  induction V with
  | leaf x =>
    simp only [map_leaf, cnt_leaf, merge]
    by_cases hx : x = j'
    · subst hx
      by_cases hi : i = j
      · subst hi
        simp [hjj.symm]
      · have h1 : ¬ j = i := fun e => hi e.symm
        by_cases hi' : i = x
        · subst hi'
          simp [hi, h1]
        · have h2 : ¬ x = i := fun e => hi' e.symm
          simp [hi, hi', h1, h2]
    · by_cases hi : i = j
      · subst hi
        simp [hx]
      · by_cases hi' : i = j'
        · subst hi'
          simp [hx, hi]
        · simp [hx, hi, hi']
  | node f ih =>
    simp only [map_node, cnt_node, ih]
    by_cases hi : i = j
    · subst hi
      simp [Finset.sum_add_distrib]
    · by_cases hi' : i = j'
      · subst hi'
        simp [hi]
      · simp [hi, hi']

/-- The trees with exactly one leaf of the new type `j'` that become `U` when `j'` is renamed
to `j`: the ways to give one leaf of type `j` in `U` the new type. -/
abbrev Retype (j j' : ℕ) (U : LTree p ℕ) : Type :=
  {V : LTree p ℕ // V.map (merge j j') = U ∧ V.cnt j' = 1}

/-- **There are as many ways as `U` has leaves of type `j`.** -/
theorem card_retype {j j' : ℕ} (hjj : j ≠ j') : ∀ U : LTree p ℕ, U.cnt j' = 0 →
    Finite (Retype j j' U) ∧ Nat.card (Retype j j' U) = U.cnt j := by
  intro U
  induction U with
  | leaf i =>
    intro hU
    have hi : i ≠ j' := by
      intro e
      simp [e] at hU
    have hleaf : ∀ V : Retype j j' (leaf i : LTree p ℕ), V.1 = leaf j' ∧ i = j := by
      rintro ⟨V, hmap, hcnt⟩
      cases V with
      | leaf x =>
        have hx : x = j' := by
          by_contra hne
          simp [hne] at hcnt
        subst hx
        simp only [map_leaf, merge, ite_true, leaf.injEq] at hmap
        exact ⟨rfl, hmap.symm⟩
      | node g => simp at hmap
    by_cases hij : i = j
    · subst hij
      have : Subsingleton (Retype i j' (leaf i : LTree p ℕ)) :=
        ⟨fun V W => Subtype.ext ((hleaf V).1.trans (hleaf W).1.symm)⟩
      have : Nonempty (Retype i j' (leaf i : LTree p ℕ)) :=
        ⟨⟨leaf j', by simp [merge], by simp⟩⟩
      refine ⟨inferInstance, ?_⟩
      simp
    · have : IsEmpty (Retype j j' (leaf i : LTree p ℕ)) := ⟨fun V => hij (hleaf V).2⟩
      refine ⟨inferInstance, ?_⟩
      simp [hij]
  | node f ih =>
    intro hU
    simp only [cnt_node] at hU
    have hU' : ∀ i, (f i).cnt j' = 0 := fun i =>
      Finset.sum_eq_zero_iff.mp hU i (Finset.mem_univ i)
    have hfin : ∀ i, Finite (Retype j j' (f i)) := fun i => (ih i (hU' i)).1
    -- choose the child that contains the leaf with the new type
    let φ : (Σ i : Fin p, Retype j j' (f i)) → Retype j j' (node f) := fun x =>
      ⟨node (Function.update f x.1 x.2.1), by
        simp only [map_node]
        congr 1
        funext i
        by_cases hi : i = x.1
        · rw [hi, Function.update_self]
          exact x.2.2.1
        · rw [Function.update_of_ne hi]
          exact map_merge_of_cnt_zero j j' (f i) (hU' i), by
        simp only [cnt_node]
        rw [Finset.sum_eq_single x.1]
        · rw [Function.update_self]
          exact x.2.2.2
        · intro i _ hi
          rw [Function.update_of_ne hi]
          exact hU' i
        · intro h
          exact absurd (Finset.mem_univ _) h⟩
    have hinj : Function.Injective φ := by
      rintro ⟨i1, V1, h1, c1⟩ ⟨i2, V2, h2, c2⟩ heq
      have hfun : Function.update f i1 V1 = Function.update f i2 V2 := by
        have := congrArg Subtype.val heq
        simpa [φ] using this
      have hi : i1 = i2 := by
        by_contra hne
        have e := congrFun hfun i1
        rw [Function.update_self, Function.update_of_ne hne] at e
        rw [e, hU' i1] at c1
        omega
      subst hi
      have e := congrFun hfun i1
      rw [Function.update_self, Function.update_self] at e
      subst e
      rfl
    have hsurj : Function.Surjective φ := by
      rintro ⟨V, hmap, hcnt⟩
      cases V with
      | leaf x => simp at hmap
      | node g =>
        simp only [map_node, node.injEq] at hmap
        have hmap' : ∀ i, (g i).map (merge j j') = f i := fun i => congrFun hmap i
        simp only [cnt_node] at hcnt
        obtain ⟨i0, -, hi0⟩ : ∃ i0 ∈ Finset.univ, (g i0).cnt j' ≠ 0 :=
          Finset.exists_ne_zero_of_sum_ne_zero (by rw [hcnt]; omega)
        have hsplit := Finset.add_sum_erase Finset.univ (fun i => (g i).cnt j')
          (Finset.mem_univ i0)
        beta_reduce at hsplit
        have h1 : (g i0).cnt j' = 1 := by omega
        have hrest : ∑ i ∈ Finset.univ.erase i0, (g i).cnt j' = 0 := by omega
        have h0 : ∀ i, i ≠ i0 → (g i).cnt j' = 0 := fun i hi =>
          Finset.sum_eq_zero_iff.mp hrest i (Finset.mem_erase.mpr ⟨hi, Finset.mem_univ i⟩)
        refine ⟨⟨i0, ⟨g i0, hmap' i0, h1⟩⟩, ?_⟩
        apply Subtype.ext
        show node (Function.update f i0 (g i0)) = node g
        congr 1
        funext i
        by_cases hi : i = i0
        · rw [hi, Function.update_self]
        · rw [Function.update_of_ne hi, ← hmap' i, map_merge_of_cnt_zero j j' (g i) (h0 i hi)]
    let e := Equiv.ofBijective φ ⟨hinj, hsurj⟩
    refine ⟨Finite.of_equiv _ e, ?_⟩
    rw [← Nat.card_congr e, Nat.card_sigma, cnt_node]
    exact Finset.sum_congr rfl (fun i _ => (ih i (hU' i)).2)

/-! ### Trees with a given content -/

/-- The typed trees with prescribed numbers of leaves of each type. -/
abbrev WithContent (p : ℕ) (M : Multiset ℕ) : Type :=
  {U : LTree p ℕ // ∀ i, U.cnt i = M.count i}

/-- **One step:** giving one of the leaves of type `j` a new type `j'` multiplies the number of
trees by the number of leaves of type `j`. -/
theorem card_refine (M0 : Multiset ℕ) (j j' : ℕ) (hj' : j' ∉ j ::ₘ M0) :
    Nat.card (WithContent p (j' ::ₘ M0)) =
      (j ::ₘ M0).count j * Nat.card (WithContent p (j ::ₘ M0)) := by
  have hjj : j ≠ j' := fun e => hj' (by simp [e])
  have hj'0 : M0.count j' = 0 := Multiset.count_eq_zero.mpr (fun h => hj' (by simp [h]))
  -- renaming `j'` to `j` maps the new content to the old one
  have hfwd : ∀ V : WithContent p (j' ::ₘ M0), ∀ i,
      (V.1.map (merge j j')).cnt i = (j ::ₘ M0).count i := by
    intro V i
    rw [cnt_map_merge hjj, Multiset.count_cons]
    have hVj := V.2 j
    have hVj' := V.2 j'
    have hVi := V.2 i
    rw [Multiset.count_cons] at hVj hVj' hVi
    by_cases hi : i = j
    · subst hi
      simp only [ite_true] at hVj hVj' ⊢
      simp only [hjj, ite_false] at hVj
      omega
    · by_cases hi' : i = j'
      · subst hi'
        simp only [hi, ite_false, ite_true]
        omega
      · simp only [hi, hi', ite_false] at hVi ⊢
        omega
  let g : WithContent p (j' ::ₘ M0) → WithContent p (j ::ₘ M0) :=
    fun V => ⟨V.1.map (merge j j'), hfwd V⟩
  -- the fibre of `g` over `U` is `Retype j j' U`
  have hfib : ∀ U : WithContent p (j ::ₘ M0),
      {V : WithContent p (j' ::ₘ M0) // g V = U} ≃ Retype j j' U.1 := fun U =>
    { toFun := fun V => ⟨V.1.1, congrArg Subtype.val V.2, by
        have := V.1.2 j'
        rw [Multiset.count_cons_self, hj'0] at this
        exact this⟩
      invFun := fun W => ⟨⟨W.1, by
        intro i
        have hW := congrArg (fun T : LTree p ℕ => T.cnt i) W.2.1
        beta_reduce at hW
        rw [cnt_map_merge hjj, U.2 i, Multiset.count_cons] at hW
        have hWj' := W.2.2
        rw [Multiset.count_cons]
        by_cases hi : i = j
        · subst hi
          simp only [ite_true] at hW
          simp only [hjj, ite_false]
          omega
        · by_cases hi' : i = j'
          · subst hi'
            simp only [ite_true]
            omega
          · simp only [hi, hi', ite_false] at hW ⊢
            omega⟩, Subtype.ext W.2.1⟩
      left_inv := fun V => rfl
      right_inv := fun W => rfl }
  have hk : ∀ U : WithContent p (j ::ₘ M0),
      Nat.card {V : WithContent p (j' ::ₘ M0) // g V = U} = (j ::ₘ M0).count j := fun U => by
    have hU0 : U.1.cnt j' = 0 := by
      rw [U.2 j', Multiset.count_cons, hj'0]
      simp [hjj.symm]
    rw [Nat.card_congr (hfib U), (card_retype hjj U.1 hU0).2, U.2 j]
  have hfinite : ∀ U : WithContent p (j ::ₘ M0),
      Finite {V : WithContent p (j' ::ₘ M0) // g V = U} := fun U => by
    have hU0 : U.1.cnt j' = 0 := by
      rw [U.2 j', Multiset.count_cons, hj'0]
      simp [hjj.symm]
    have := (card_retype hjj U.1 hU0).1
    exact Finite.of_equiv _ (hfib U).symm
  -- so the new trees are `count` copies of the old ones
  have e : WithContent p (j' ::ₘ M0) ≃ WithContent p (j ::ₘ M0) × Fin ((j ::ₘ M0).count j) :=
    (Equiv.sigmaFiberEquiv g).symm.trans
      ((Equiv.sigmaCongrRight fun U => Finite.equivFinOfCardEq (hk U)).trans
        (Equiv.sigmaEquivProd _ _))
  rw [Nat.card_congr e, Nat.card_prod, Nat.card_fin, mul_comm]

/-- **Repeating the step until all types are different.** For every content `M` there are a set
`D` of as many distinct types and a number `K` with
`#(trees with content D) = K * #(trees with content M)`. -/
theorem exists_distinct (p : ℕ) (M : Multiset ℕ) : ∃ (D : Finset ℕ) (K : ℕ),
    D.card = Multiset.card M ∧
      Nat.card (WithContent p D.val) = K * Nat.card (WithContent p M) := by
  suffices H : ∀ (e : ℕ) (M : Multiset ℕ), Multiset.card M - M.toFinset.card = e →
      ∃ (D : Finset ℕ) (K : ℕ), D.card = Multiset.card M ∧
        Nat.card (WithContent p D.val) = K * Nat.card (WithContent p M) from H _ M rfl
  intro e
  induction e using Nat.strong_induction_on with
  | _ e ih =>
    intro M hM
    by_cases hnd : M.Nodup
    · refine ⟨M.toFinset, 1, Multiset.toFinset_card_of_nodup hnd, ?_⟩
      rw [Multiset.toFinset_val, hnd.dedup, one_mul]
    · obtain ⟨j, hj⟩ : ∃ j, 2 ≤ M.count j := by
        by_contra hno
        exact hnd (Multiset.nodup_iff_count_le_one.mpr (fun a => by
          by_contra h
          exact hno ⟨a, by omega⟩))
      have hjM : j ∈ M := Multiset.count_pos.mp (by omega)
      obtain ⟨M0, rfl⟩ := Multiset.exists_cons_of_mem hjM
      have hjM0 : j ∈ M0 := by
        rw [Multiset.count_cons_self] at hj
        exact Multiset.count_pos.mp (by omega)
      obtain ⟨j', hj'⟩ := Infinite.exists_notMem_finset (j ::ₘ M0).toFinset
      rw [Multiset.mem_toFinset] at hj'
      have hj'M0 : j' ∉ M0.toFinset := fun h => hj' (by
        rw [Multiset.mem_toFinset] at h
        simp [h])
      have hlt : Multiset.card (j' ::ₘ M0) - (j' ::ₘ M0).toFinset.card < e := by
        rw [← hM]
        simp only [Multiset.card_cons, Multiset.toFinset_cons]
        rw [Finset.card_insert_of_notMem hj'M0,
          Finset.insert_eq_of_mem (Multiset.mem_toFinset.mpr hjM0)]
        have := Multiset.toFinset_card_le M0
        omega
      obtain ⟨D, K, hD, hK⟩ := ih _ hlt (j' ::ₘ M0) rfl
      refine ⟨D, K * (j ::ₘ M0).count j, by simpa using hD, ?_⟩
      rw [hK, card_refine M0 j j' hj', mul_assoc]

end LTree

end MMM

/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Equal atoms, with the depth condition** (prime powers `q = p ^ k`).

Same argument as `MMM/Retype.lean`, with one change: the new name `j'` given to an atom of type
`j` is taken in the same class modulo `k` (`j' ≡ j`), so the depth condition `k ∣ δ + type` is
not affected. The result (`exists_distinct_blocked`): for every content `M` there are a set `D`
of distinct types with the same classes modulo `k` and a number `K` with

    #(blocked trees with content D) = K * #(blocked trees with content M).
-/
import MMM.Retype
import MMM.LBlocked

namespace MMM

namespace LTree

variable {p : ℕ}

/-- Renaming types within their classes modulo `k` does not change the depth condition. -/
theorem blockedL_map_of_mod {k : ℕ} (g : ℕ → ℕ) (hg : ∀ x, g x % k = x % k) (V : LTree p ℕ) :
    ∀ δ, BlockedL k id δ (V.map g) ↔ BlockedL k id δ V := by
  induction V with
  | leaf x =>
    intro δ
    simp only [map_leaf, blockedL_leaf, id]
    rw [Nat.dvd_iff_mod_eq_zero, Nat.dvd_iff_mod_eq_zero, Nat.add_mod, hg x, ← Nat.add_mod]
  | node f ih =>
    intro δ
    simp only [map_node, blockedL_node]
    exact forall_congr' (fun i => ih i (δ + 1))

theorem merge_mod {k j j' : ℕ} (h : j' % k = j % k) (x : ℕ) : merge j j' x % k = x % k := by
  unfold merge
  split
  · next hx => rw [hx, h]
  · rfl

/-- Renaming `j'` to `j` turns the content `j' ::ₘ M0` into `j ::ₘ M0`. -/
theorem content_map_merge {M0 : Multiset ℕ} {j j' : ℕ} (hj' : j' ∉ j ::ₘ M0) (V : LTree p ℕ)
    (hV : ∀ i, V.cnt i = (j' ::ₘ M0).count i) (i : ℕ) :
    (V.map (merge j j')).cnt i = (j ::ₘ M0).count i := by
  have hjj : j ≠ j' := fun e => hj' (by simp [e])
  have hj'0 : M0.count j' = 0 := Multiset.count_eq_zero.mpr (fun h => hj' (by simp [h]))
  rw [cnt_map_merge hjj, Multiset.count_cons]
  have hVj := hV j
  have hVj' := hV j'
  have hVi := hV i
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

/-- A tree with one leaf of the new type `j'` that becomes `U` (content `j ::ₘ M0`) when `j'` is
renamed to `j` has content `j' ::ₘ M0`. -/
theorem content_of_retype {M0 : Multiset ℕ} {j j' : ℕ} (hj' : j' ∉ j ::ₘ M0) (U W : LTree p ℕ)
    (hU : ∀ i, U.cnt i = (j ::ₘ M0).count i) (hmap : W.map (merge j j') = U)
    (hc : W.cnt j' = 1) (i : ℕ) : W.cnt i = (j' ::ₘ M0).count i := by
  have hjj : j ≠ j' := fun e => hj' (by simp [e])
  have hj'0 : M0.count j' = 0 := Multiset.count_eq_zero.mpr (fun h => hj' (by simp [h]))
  have hW := congrArg (fun T : LTree p ℕ => T.cnt i) hmap
  beta_reduce at hW
  rw [cnt_map_merge hjj, hU i, Multiset.count_cons] at hW
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
      omega

/-- **One step, for trees with an extra property.** `Q'` is the property for the new content,
`Q` for the old one; they correspond under renaming `j'` to `j`. -/
theorem card_refine_pred (M0 : Multiset ℕ) (j j' : ℕ) (hj' : j' ∉ j ::ₘ M0)
    (Q Q' : LTree p ℕ → Prop) (hQ : ∀ V : LTree p ℕ, Q' V ↔ Q (V.map (merge j j'))) :
    Nat.card {V : LTree p ℕ // (∀ i, V.cnt i = (j' ::ₘ M0).count i) ∧ Q' V} =
      (j ::ₘ M0).count j *
        Nat.card {U : LTree p ℕ // (∀ i, U.cnt i = (j ::ₘ M0).count i) ∧ Q U} := by
  have hjj : j ≠ j' := fun e => hj' (by simp [e])
  have hj'0 : M0.count j' = 0 := Multiset.count_eq_zero.mpr (fun h => hj' (by simp [h]))
  let g : {V : LTree p ℕ // (∀ i, V.cnt i = (j' ::ₘ M0).count i) ∧ Q' V} →
      {U : LTree p ℕ // (∀ i, U.cnt i = (j ::ₘ M0).count i) ∧ Q U} :=
    fun V => ⟨V.1.map (merge j j'), content_map_merge hj' V.1 V.2.1, (hQ V.1).mp V.2.2⟩
  have hfib : ∀ U : {U : LTree p ℕ // (∀ i, U.cnt i = (j ::ₘ M0).count i) ∧ Q U},
      {V : {V : LTree p ℕ // (∀ i, V.cnt i = (j' ::ₘ M0).count i) ∧ Q' V} // g V = U} ≃
        Retype j j' U.1 := fun U =>
    { toFun := fun V => ⟨V.1.1, congrArg Subtype.val V.2, by
        have := V.1.2.1 j'
        rw [Multiset.count_cons_self, hj'0] at this
        exact this⟩
      invFun := fun W => ⟨⟨W.1, content_of_retype hj' U.1 W.1 U.2.1 W.2.1 W.2.2,
        (hQ W.1).mpr (by rw [W.2.1]; exact U.2.2)⟩, Subtype.ext W.2.1⟩
      left_inv := fun V => rfl
      right_inv := fun W => rfl }
  have hU0 : ∀ U : {U : LTree p ℕ // (∀ i, U.cnt i = (j ::ₘ M0).count i) ∧ Q U},
      U.1.cnt j' = 0 := fun U => by
    rw [U.2.1 j', Multiset.count_cons, hj'0]
    simp [hjj.symm]
  have hk : ∀ U : {U : LTree p ℕ // (∀ i, U.cnt i = (j ::ₘ M0).count i) ∧ Q U},
      Nat.card {V : {V : LTree p ℕ // (∀ i, V.cnt i = (j' ::ₘ M0).count i) ∧ Q' V} // g V = U} =
        (j ::ₘ M0).count j := fun U => by
    rw [Nat.card_congr (hfib U), (card_retype hjj U.1 (hU0 U)).2, U.2.1 j]
  have hfinite : ∀ U : {U : LTree p ℕ // (∀ i, U.cnt i = (j ::ₘ M0).count i) ∧ Q U},
      Finite {V : {V : LTree p ℕ // (∀ i, V.cnt i = (j' ::ₘ M0).count i) ∧ Q' V} // g V = U} :=
    fun U => by
      have := (card_retype hjj U.1 (hU0 U)).1
      exact Finite.of_equiv _ (hfib U).symm
  have e : {V : LTree p ℕ // (∀ i, V.cnt i = (j' ::ₘ M0).count i) ∧ Q' V} ≃
      {U : LTree p ℕ // (∀ i, U.cnt i = (j ::ₘ M0).count i) ∧ Q U} ×
        Fin ((j ::ₘ M0).count j) :=
    (Equiv.sigmaFiberEquiv g).symm.trans
      ((Equiv.sigmaCongrRight fun U => Finite.equivFinOfCardEq (hk U)).trans
        (Equiv.sigmaEquivProd _ _))
  rw [Nat.card_congr e, Nat.card_prod, Nat.card_fin, mul_comm]

/-- The typed trees with a given content that satisfy the depth condition. -/
abbrev WithContentB (p k : ℕ) (M : Multiset ℕ) : Type :=
  {U : LTree p ℕ // (∀ i, U.cnt i = M.count i) ∧ BlockedL k id 0 U}

theorem mem_le_sum (s : Multiset ℕ) : ∀ x ∈ s, x ≤ s.sum := by
  induction s using Multiset.induction_on with
  | empty => intro x hx; simp at hx
  | cons a s ih =>
    intro x hx
    rw [Multiset.sum_cons]
    rcases Multiset.mem_cons.mp hx with rfl | h
    · omega
    · have := ih x h
      omega

/-- **Repeating the step, with the depth condition.** The new types are chosen in the same
classes modulo `k`. -/
theorem exists_distinct_blocked (p k : ℕ) (hk : 0 < k) (M : Multiset ℕ) :
    ∃ (D : Finset ℕ) (K : ℕ), D.card = Multiset.card M ∧
      D.val.map (· % k) = M.map (· % k) ∧
        Nat.card (WithContentB p k D.val) = K * Nat.card (WithContentB p k M) := by
  suffices H : ∀ (e : ℕ) (M : Multiset ℕ), Multiset.card M - M.toFinset.card = e →
      ∃ (D : Finset ℕ) (K : ℕ), D.card = Multiset.card M ∧
        D.val.map (· % k) = M.map (· % k) ∧
          Nat.card (WithContentB p k D.val) = K * Nat.card (WithContentB p k M) from H _ M rfl
  intro e
  induction e using Nat.strong_induction_on with
  | _ e ih =>
    intro M hM
    by_cases hnd : M.Nodup
    · refine ⟨M.toFinset, 1, Multiset.toFinset_card_of_nodup hnd, ?_, ?_⟩
      · rw [Multiset.toFinset_val, hnd.dedup]
      · rw [Multiset.toFinset_val, hnd.dedup, one_mul]
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
      -- a new type in the class of `j`, larger than every type present
      let j' := j + k * ((j ::ₘ M0).sum + 1)
      have hbig : ∀ x ∈ j ::ₘ M0, x < j' := fun x hx => by
        have h1 := mem_le_sum _ x hx
        have h2 : (j ::ₘ M0).sum + 1 ≤ k * ((j ::ₘ M0).sum + 1) := Nat.le_mul_of_pos_left _ hk
        show x < j + k * ((j ::ₘ M0).sum + 1)
        omega
      have hj' : j' ∉ j ::ₘ M0 := fun h => lt_irrefl _ (hbig j' h)
      have hmod : j' % k = j % k := Nat.add_mul_mod_self_left j k _
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
      obtain ⟨D, K, hD, hres, hK⟩ := ih _ hlt (j' ::ₘ M0) rfl
      refine ⟨D, K * (j ::ₘ M0).count j, by simpa using hD, ?_, ?_⟩
      · rw [hres, Multiset.map_cons, Multiset.map_cons, hmod]
      · rw [hK]
        have := card_refine_pred (p := p) M0 j j' hj' (BlockedL k id 0) (BlockedL k id 0)
          (fun V => (blockedL_map_of_mod (merge j j') (merge_mod hmod) V 0).symm)
        rw [this, mul_assoc]

end LTree

end MMM

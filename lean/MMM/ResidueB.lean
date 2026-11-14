/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed. The induction in `labelled_congruence_blocked` follows the proof of
`labelled_valuation_blocked` in `MMM/CherryB.lean` (written by a forked instance) step by step.

  **The residue for every prime power `q = p ^ k`** (claims C7 and C12 of the ledger):

      (number of q-ary trees with m leaves) * ∏_j (m_j)!  ≡  (-p) ^ t   (mod p ^ (t + 1)),

where the `m_j` are the base-`p` digits of `m`, `m ≡ 1 (mod q - 1)` and
`(p - 1) * t + 1 = s_p(m)`.

Same three ingredients as `MMM/Residue.lean`, each with the depth condition:
`labelled_congruence_blocked` (Step 4 with the sign, by Wilson's theorem),
`exists_distinct_fact_blocked` (the factor between labelled and minimal trees is `∏ m_j!`),
and the reduction with Step 3 for blocked trees.
-/
import MMM.Residue
import MMM.ExactB

namespace MMM

namespace LTree

open CherryB

/-- **Step 4 with the sign and the depth condition.** -/
theorem labelled_congruence_blocked {p : ℕ} [hp : Fact p.Prime] {α : Type} [DecidableEq α]
    (k : ℕ) (hk : 0 < k) (κ : α → ℕ) (t : ℕ) (S : Finset α)
    (hS : S.card = (p - 1) * t + 1)
    (hI : (∑ x ∈ S, p ^ κ x) ≡ 1 [MOD p ^ k - 1]) :
    (Nat.card {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} : ℤ) ≡ (-(p : ℤ)) ^ t
      [ZMOD (p : ℤ) ^ (t + 1)] := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have : NeZero p := ⟨hp.out.ne_zero⟩
  induction t generalizing S κ with
  | zero =>
    have h1 : S.card = 1 := by simpa using hS
    obtain ⟨a, rfl⟩ := Finset.card_eq_one.mp h1
    rw [Finset.sum_singleton] at hI
    have hka : k ∣ κ a := dvd_of_pow_modEq_one hp2 hk hI
    have hcard : Nat.card {T : LTree p α // T.Good ∧ T.lab = {a} ∧ T.BlockedL k κ 0} = 1 := by
      rw [Nat.card_eq_one_iff_unique]
      refine ⟨⟨?_⟩, ⟨⟨leaf a, good_leaf a, rfl, ?_⟩⟩⟩
      · rintro ⟨T, hT, hl, _⟩ ⟨T', hT', hl', _⟩
        apply Subtype.ext
        obtain ⟨b, rfl⟩ := hT.eq_leaf_of_card_lab_eq_one hp2 (by rw [hl]; rfl)
        obtain ⟨b', rfl⟩ := hT'.eq_leaf_of_card_lab_eq_one hp2 (by rw [hl']; rfl)
        rw [lab_leaf, Finset.singleton_inj] at hl hl'
        subst hl
        subst hl'
        rfl
      · rw [blockedL_leaf, zero_add]
        exact hka
    rw [hcard]
    simp
  | succ t ih =>
    have hpS : p ≤ S.card := by
      rw [hS, Nat.mul_succ]
      omega
    obtain ⟨C, hCS, hC, hcl⟩ := exists_class hp2 hk κ S (by omega) hI
    obtain ⟨c0, hc0⟩ : C.Nonempty := by
      rw [← Finset.card_pos, hC]
      omega
    have hc0n : c0 ∉ S \ C := by simp [hc0]
    have hS' : (insert c0 (S \ C)).card = (p - 1) * t + 1 := by
      rw [Finset.card_insert_of_notMem hc0n, Finset.card_sdiff_of_subset hCS, hS, hC,
        Nat.mul_succ]
      omega
    have hsumC : (∑ x ∈ C, p ^ κ x) ≡ p ^ (κ c0 + 1) [MOD p ^ k - 1] := by
      have h1 : (∑ x ∈ C, p ^ κ x) ≡ ∑ _x ∈ C, p ^ κ c0 [MOD p ^ k - 1] :=
        Nat.ModEq.sum (fun x hx => pow_modEq_of_mod_eq hp2 (hcl x hx c0 hc0))
      have h2 : ∑ _x ∈ C, p ^ κ c0 = C.card * p ^ κ c0 :=
        Finset.sum_const_nat (fun _ _ => rfl)
      rw [h2, hC, ← pow_succ'] at h1
      exact h1
    have hI' : (∑ x ∈ insert c0 (S \ C), p ^ (Function.update κ c0 (κ c0 + 1)) x) ≡ 1
        [MOD p ^ k - 1] := by
      rw [Finset.sum_insert hc0n, Function.update_self]
      have hrest : ∑ x ∈ S \ C, p ^ (Function.update κ c0 (κ c0 + 1)) x =
          ∑ x ∈ S \ C, p ^ κ x :=
        Finset.sum_congr rfl (fun x hx => by
          have hne : x ≠ c0 := fun e => hc0n (e ▸ hx)
          rw [Function.update_of_ne hne])
      rw [hrest]
      have hsplit : ∑ x ∈ S \ C, p ^ κ x + ∑ x ∈ C, p ^ κ x = ∑ x ∈ S, p ^ κ x :=
        Finset.sum_sdiff hCS
      have h3 : p ^ (κ c0 + 1) + ∑ x ∈ S \ C, p ^ κ x ≡
          (∑ x ∈ C, p ^ κ x) + ∑ x ∈ S \ C, p ^ κ x [MOD p ^ k - 1] :=
        hsumC.symm.add_right _
      rw [add_comm (∑ x ∈ C, p ^ κ x), hsplit] at h3
      exact h3.trans hI
    have ihc := ih (κ := Function.update κ c0 (κ c0 + 1)) (S := insert c0 (S \ C)) hS' hI'
    have ihd := (labelled_valuation_blocked (p := p) k hk (Function.update κ c0 (κ c0 + 1)) t
      (insert c0 (S \ C)) hS' hI').1
    have hfin : Finite {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} :=
      finite_XB k κ S
    have hsplit : Nat.card {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} =
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
          CherryOn C x.1} +
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
          ¬ CherryOn C x.1} := by
      classical
      rw [← Nat.card_sum]
      exact Nat.card_congr (Equiv.sumCompl _).symm
    have hY : Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
          CherryOn C x.1} =
        p.factorial * Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C) ∧
          T.BlockedL k (Function.update κ c0 (κ c0 + 1)) 0} :=
      card_cherry_blocked hCS hC hc0 hcl
    have hZ : p ^ (t + 1 + 1) ∣
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
          ¬ CherryOn C x.1} :=
      pow_succ_dvd_card_noCherryB (t + 1) hS hCS hC hcl
    have hfact : p.factorial = p * (p - 1).factorial :=
      (Nat.mul_factorial_pred hp.out.ne_zero).symm
    have hw : (p : ℤ) ∣ ((p - 1).factorial : ℤ) + 1 := by
      rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
      push_cast
      rw [ZMod.wilsons_lemma]
      ring
    rw [hsplit, hY, hfact]
    obtain ⟨a, ha⟩ := hw
    obtain ⟨e, he⟩ := Int.modEq_iff_dvd.mp ihc
    obtain ⟨c, hc⟩ := ihd
    obtain ⟨z, hz⟩ := hZ
    have hc' : (Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C) ∧
        T.BlockedL k (Function.update κ c0 (κ c0 + 1)) 0} : ℤ) = (p : ℤ) ^ t * c := by
      exact_mod_cast hc
    have hz' : (Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
        ¬ CherryOn C x.1} : ℤ) = (p : ℤ) ^ (t + 1 + 1) * z := by exact_mod_cast hz
    rw [Int.modEq_iff_dvd]
    refine ⟨-e - a * c - z, ?_⟩
    push_cast
    linear_combination (-(p : ℤ)) * he +
      (-(p : ℤ) * (Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C) ∧
        T.BlockedL k (Function.update κ c0 (κ c0 + 1)) 0} : ℤ)) * ha -
      hz' - ((p : ℤ) ^ 2 * a) * hc'

/-- **Equal atoms with the exact factor and the depth condition.** -/
theorem exists_distinct_fact_blocked (p k : ℕ) (hk : 0 < k) (M : Multiset ℕ) :
    ∃ D : Finset ℕ, D.card = Multiset.card M ∧
      D.val.map (· % k) = M.map (· % k) ∧
        Nat.card (WithContentB p k D.val) = factProd M * Nat.card (WithContentB p k M) := by
  suffices H : ∀ (e : ℕ) (M : Multiset ℕ), Multiset.card M - M.toFinset.card = e →
      ∃ D : Finset ℕ, D.card = Multiset.card M ∧
        D.val.map (· % k) = M.map (· % k) ∧
          Nat.card (WithContentB p k D.val) = factProd M * Nat.card (WithContentB p k M) from
    H _ M rfl
  intro e
  induction e using Nat.strong_induction_on with
  | _ e ih =>
    intro M hM
    by_cases hnd : M.Nodup
    · refine ⟨M.toFinset, Multiset.toFinset_card_of_nodup hnd, ?_, ?_⟩
      · rw [Multiset.toFinset_val, hnd.dedup]
      · rw [Multiset.toFinset_val, hnd.dedup, factProd_of_nodup hnd, one_mul]
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
      obtain ⟨D, hD, hres, hK⟩ := ih _ hlt (j' ::ₘ M0) rfl
      refine ⟨D, by simpa using hD, ?_, ?_⟩
      · rw [hres, Multiset.map_cons, Multiset.map_cons, hmod]
      · rw [hK]
        have := card_refine_pred (p := p) M0 j j' hj' (BlockedL k id 0) (BlockedL k id 0)
          (fun V => (blockedL_map_of_mod (merge j j') (merge_mod hmod) V 0).symm)
        rw [this, factProd_cons hjM0 hj']
        ring

end LTree

namespace PTree

variable {p : ℕ} [hp : Fact p.Prime]

/-- **The residue for the blocked `p`-ary trees.** -/
theorem residue_blocked (k : ℕ) (hk : 0 < k) (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m)
    (hm : m ≡ 1 [MOD p ^ k - 1]) :
    (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} : ℤ) *
        ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have h1 : (Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} : ℤ) ≡
      (Nat.card {T : PTree p // (T.leaves = m ∧ BlockedAt k 0 T) ∧ T.d = t} : ℤ)
        [ZMOD (p : ℤ) ^ (t + 1)] := by
    have := Int.natCast_modEq_iff.mpr (card_blocked_modEq_minimal (p := p) k m t ht)
    push_cast at this
    exact this
  have e2 : Nat.card {T : PTree p // (T.leaves = m ∧ BlockedAt k 0 T) ∧ T.d = t} =
      Nat.card (LTree.WithContentB p k (LTree.digitMultiset p m)) := by
    rw [LTree.card_minimal_blocked hp2 k m t ht]
    exact Nat.card_congr (Equiv.subtypeEquivRight (fun U => by
      rw [LTree.typed_iff_cnt hp2]
      exact and_congr_left' (forall_congr' (fun i => by rw [LTree.count_digitMultiset hp2]))))
  obtain ⟨D, hD, hres, hK⟩ := LTree.exists_distinct_fact_blocked p k hk (LTree.digitMultiset p m)
  rw [LTree.card_digitMultiset hp2, ← ht] at hD
  have e3 : Nat.card {T : LTree p ℕ // T.Good ∧ T.lab = D ∧ T.BlockedL k id 0} =
      Nat.card (LTree.WithContentB p k D.val) :=
    Nat.card_congr (Equiv.subtypeEquivRight (fun U => by
      rw [← and_assoc, LTree.good_lab_iff_cnt hp2 D U]))
  have h4 := LTree.labelled_congruence_blocked (p := p) k hk id t D hD
    (LTree.sum_pow_modEq_one hp2 k D m hres hm)
  rw [e3, hK, LTree.factProd_digitMultiset hp2, ← e2] at h4
  refine (h1.mul_right _).trans ?_
  push_cast at h4 ⊢
  rw [mul_comm]
  exact h4

/-- **The residue for `q = p ^ k`** (claim C12): for `m ≡ 1 (mod q - 1)`,
`#(q-ary trees with m leaves) * ∏_j (m_j)! ≡ (-p) ^ t  (mod p ^ (t + 1))`. -/
theorem residue_primePower (k : ℕ) (hk : 0 < k) (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m)
    (hm : m ≡ 1 [MOD p ^ k - 1]) :
    (Nat.card {T : PTree (p ^ k) // T.leaves = m} : ℤ) *
        ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  rw [card_pow_ary_eq_card_blocked hp.out.two_le k hk m]
  exact residue_blocked k hk m t ht hm

end PTree

end MMM

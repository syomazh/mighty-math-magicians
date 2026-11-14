/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **The residue, for `q = p`** (claims C7 and C12 of the ledger):

      (number of p-ary trees with m leaves) * ∏_j (m_j)!  ≡  (-p) ^ t   (mod p ^ (t + 1)),

where the `m_j` are the base-`p` digits of `m` and `(p - 1) * t + 1 = s_p(m)`. This contains both
the exact valuation `t` and the residue `(-1) ^ t / ∏ m_j!` of the quotient modulo `p`.

Three ingredients beyond `MMM/Exact.lean`:

* `labelled_congruence`: the number of `p`-ary trees with `(p - 1) * t + 1` distinctly labelled
  leaves is `≡ (-p) ^ t (mod p ^ (t + 1))`. Same induction as `labelled_valuation`, with the
  factor `(p - 1)! ≡ -1 (mod p)` kept (Wilson's theorem, from Mathlib).
* `exists_distinct_fact`: the factor between labelled and minimal trees is exactly
  `∏ (multiplicity)!`.
* the reduction to minimal trees and Step 3, as before.

Difference from the paper: the paper gets the sign `-1` by counting the `p - 1` cyclic orders of
a cherry that are compatible with the relabelling; here it comes from Wilson's theorem applied
to all `p !` orders. Wilson's theorem is a statement about `(p - 1)!` modulo `p`, not a
factorial valuation.
-/
import MMM.ExactAll
import MMM.Cherry
import Mathlib.NumberTheory.Wilson
import Mathlib.Tactic.LinearCombination

namespace MMM

namespace LTree

section labelled

variable {p : ℕ} [hp : Fact p.Prime] {α : Type} [DecidableEq α]

/-- **Step 4 with the sign.** The number of `p`-ary trees whose leaves carry the `(p - 1) * t + 1`
labels of `S`, each once, is congruent to `(-p) ^ t` modulo `p ^ (t + 1)`. -/
theorem labelled_congruence (t : ℕ) (S : Finset α) (hS : S.card = (p - 1) * t + 1) :
    (Nat.card {T : LTree p α // T.Good ∧ T.lab = S} : ℤ) ≡ (-(p : ℤ)) ^ t
      [ZMOD (p : ℤ) ^ (t + 1)] := by
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
    simp
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
    have ihc := ih (insert c0 (S \ C)) hS'
    have ihd := (labelled_valuation (p := p) t (insert c0 (S \ C)) hS').1
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
    -- Wilson: (p - 1)! ≡ -1 (mod p)
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
    have hc' : (Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C)} : ℤ) =
        (p : ℤ) ^ t * c := by exact_mod_cast hc
    have hz' : (Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S} // ¬ CherryOn C x.1} : ℤ) =
        (p : ℤ) ^ (t + 1 + 1) * z := by exact_mod_cast hz
    rw [Int.modEq_iff_dvd]
    refine ⟨-e - a * c - z, ?_⟩
    push_cast
    linear_combination (-(p : ℤ)) * he +
      (-(p : ℤ) * (Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C)} : ℤ)) * ha -
      hz' - ((p : ℤ) ^ 2 * a) * hc'

end labelled

variable {p : ℕ}

/-- The product of the factorials of the multiplicities of a content. -/
def factProd (M : Multiset ℕ) : ℕ := ∏ x ∈ M.toFinset, (M.count x).factorial

theorem factProd_of_nodup {M : Multiset ℕ} (h : M.Nodup) : factProd M = 1 :=
  Finset.prod_eq_one (fun x hx => by
    rw [Multiset.count_eq_one_of_mem h (Multiset.mem_toFinset.mp hx)]
    rfl)

/-- Giving one of the atoms of type `j` a new type `j'` divides the product of factorials by the
number of atoms of type `j`. -/
theorem factProd_cons {M0 : Multiset ℕ} {j j' : ℕ} (hj : j ∈ M0) (hj' : j' ∉ j ::ₘ M0) :
    factProd (j ::ₘ M0) = (j ::ₘ M0).count j * factProd (j' ::ₘ M0) := by
  have hjj : j ≠ j' := fun e => hj' (by simp [e])
  have hj'M0 : j' ∉ M0.toFinset := fun h => hj' (by
    rw [Multiset.mem_toFinset] at h
    simp [h])
  have hjt : j ∈ M0.toFinset := Multiset.mem_toFinset.mpr hj
  -- the common part: the types other than `j`
  have hA : factProd (j ::ₘ M0) =
      (M0.count j + 1).factorial * ∏ x ∈ M0.toFinset.erase j, (M0.count x).factorial := by
    unfold factProd
    rw [Multiset.toFinset_cons, Finset.insert_eq_of_mem hjt, ← Finset.mul_prod_erase _ _ hjt,
      Multiset.count_cons_self]
    congr 1
    refine Finset.prod_congr rfl (fun x hx => ?_)
    rw [Multiset.count_cons_of_ne (Finset.ne_of_mem_erase hx)]
  have hB : factProd (j' ::ₘ M0) =
      (M0.count j).factorial * ∏ x ∈ M0.toFinset.erase j, (M0.count x).factorial := by
    unfold factProd
    rw [Multiset.toFinset_cons, Finset.prod_insert hj'M0, Multiset.count_cons_self,
      Multiset.count_eq_zero.mpr (fun h => hj'M0 (Multiset.mem_toFinset.mpr h))]
    have hrest : ∏ x ∈ M0.toFinset, ((j' ::ₘ M0).count x).factorial =
        ∏ x ∈ M0.toFinset, (M0.count x).factorial :=
      Finset.prod_congr rfl (fun x hx => by
        have hne : x ≠ j' := fun e => hj'M0 (by rw [← e]; exact hx)
        rw [Multiset.count_cons_of_ne hne])
    rw [hrest, ← Finset.mul_prod_erase _ (fun x => (M0.count x).factorial) hjt]
    simp
  rw [hA, hB, Multiset.count_cons_self, Nat.factorial_succ, mul_assoc]

/-- **Equal atoms, with the exact factor.** There is a set `D` of as many distinct types with
`#(trees with content D) = (∏ multiplicities!) * #(trees with content M)`. -/
theorem exists_distinct_fact (p : ℕ) (M : Multiset ℕ) : ∃ D : Finset ℕ,
    D.card = Multiset.card M ∧
      Nat.card (WithContent p D.val) = factProd M * Nat.card (WithContent p M) := by
  suffices H : ∀ (e : ℕ) (M : Multiset ℕ), Multiset.card M - M.toFinset.card = e →
      ∃ D : Finset ℕ, D.card = Multiset.card M ∧
        Nat.card (WithContent p D.val) = factProd M * Nat.card (WithContent p M) from H _ M rfl
  intro e
  induction e using Nat.strong_induction_on with
  | _ e ih =>
    intro M hM
    by_cases hnd : M.Nodup
    · refine ⟨M.toFinset, Multiset.toFinset_card_of_nodup hnd, ?_⟩
      rw [Multiset.toFinset_val, hnd.dedup, factProd_of_nodup hnd, one_mul]
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
      obtain ⟨D, hD, hK⟩ := ih _ hlt (j' ::ₘ M0) rfl
      refine ⟨D, by simpa using hD, ?_⟩
      rw [hK, card_refine M0 j j' hj', factProd_cons hjM0 hj']
      ring

/-- For the digits of `m`, the product of factorials is `∏_j (m_j)!`. -/
theorem factProd_digitMultiset (hp : 2 ≤ p) (m : ℕ) :
    factProd (digitMultiset p m) = ∏ j ∈ Finset.range m, (dig p j m).factorial := by
  unfold factProd
  have hsub : (digitMultiset p m).toFinset ⊆ Finset.range m := by
    intro x hx
    rw [Multiset.mem_toFinset, ← Multiset.count_pos, count_digitMultiset hp] at hx
    rw [Finset.mem_range]
    by_contra hge
    have h0 : dig p x m = 0 := dig_eq_zero_of_lt
      ((Nat.lt_pow_self (by omega)).trans_le (Nat.pow_le_pow_right (by omega) (by omega)))
    omega
  rw [← Finset.prod_subset hsub (fun x _ hx => by
    have h0 : dig p x m = 0 := by
      by_contra hne
      exact hx (Multiset.mem_toFinset.mpr (Multiset.count_pos.mp (by
        rw [count_digitMultiset hp]; omega)))
    rw [h0]
    rfl)]
  exact Finset.prod_congr rfl (fun x _ => by rw [count_digitMultiset hp])

end LTree

namespace PTree

variable {p : ℕ} [hp : Fact p.Prime]

/-- **The residue (`q = p`).** With `m_j` the base-`p` digits of `m` and
`(p - 1) * t + 1 = s_p(m)`:
`#(p-ary trees with m leaves) * ∏_j (m_j)! ≡ (-p) ^ t  (mod p ^ (t + 1))`. -/
theorem residue (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    (Nat.card {T : PTree p // T.leaves = m} : ℤ) *
        ((∏ j ∈ Finset.range m, (dig p j m).factorial : ℕ) : ℤ) ≡
      (-(p : ℤ)) ^ t [ZMOD (p : ℤ) ^ (t + 1)] := by
  have hp2 : 2 ≤ p := hp.out.two_le
  -- only the minimal trees count
  have h1 : (Nat.card {T : PTree p // T.leaves = m} : ℤ) ≡
      (Nat.card {T : PTree p // IsMinimal m t T} : ℤ) [ZMOD (p : ℤ) ^ (t + 1)] := by
    have := Int.natCast_modEq_iff.mpr (card_trees_modEq_minimal (p := p) m t ht)
    push_cast at this
    exact this
  -- minimal trees = trees with the digits of m as content
  have e2 : Nat.card {T : PTree p // IsMinimal m t T} =
      Nat.card (LTree.WithContent p (LTree.digitMultiset p m)) := by
    rw [← Nat.card_congr (LTree.minimalEquiv hp2 m t ht)]
    exact Nat.card_congr (Equiv.subtypeEquivRight (fun U => by
      rw [LTree.typed_iff_cnt hp2]
      exact forall_congr' (fun i => by rw [LTree.count_digitMultiset hp2])))
  -- labelled trees = ∏ m_j! copies of them
  obtain ⟨D, hD, hK⟩ := LTree.exists_distinct_fact p (LTree.digitMultiset p m)
  rw [LTree.card_digitMultiset hp2, ← ht] at hD
  have e3 : Nat.card {T : LTree p ℕ // T.Good ∧ T.lab = D} =
      Nat.card (LTree.WithContent p D.val) :=
    Nat.card_congr (Equiv.subtypeEquivRight (fun U => LTree.good_lab_iff_cnt hp2 D U))
  have h4 := LTree.labelled_congruence (p := p) t D hD
  rw [e3, hK, LTree.factProd_digitMultiset hp2, ← e2] at h4
  refine (h1.mul_right _).trans ?_
  push_cast at h4 ⊢
  rw [mul_comm]
  exact h4

end PTree

end MMM

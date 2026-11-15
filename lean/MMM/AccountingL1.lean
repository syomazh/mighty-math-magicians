/-
Written by Kimi K3.1 Pro (an Open Math OS worker, brief W056a),
2026-11-15. Not human-reviewed.

  **Lemma L1 of the accounting proof.** With all leaf labels of class `0`, a labelled tree is
`k`-blocked exactly when its shape is; hence the number of `k`-blocked labelled trees with `m`
distinct labels is `m!` times the number of `k`-blocked shapes with `m` leaves. Combined with
`LTree.labelled_congruence_blocked` (the cherry collapse), this gives

    m! * #(k-blocked p-ary trees with m leaves) ≡ (-p) ^ N   (mod p ^ (N + 1)),

where `(p - 1) * N + 1 = m` and `m ≡ 1 (mod p ^ k - 1)`.
-/
import MMM.ExactCount
import MMM.ResidueB

namespace MMM

namespace LTree

variable {p : ℕ} {α : Type}

/-- With all labels of class 0, a labelled tree is blocked exactly when its shape is. -/
theorem blockedL_zero_iff_shape (k δ : ℕ) (T : LTree p α) :
    T.BlockedL k (fun _ => 0) δ ↔ PTree.BlockedAt k δ T.shape := by
  induction T generalizing δ with
  | leaf a => simp [PTree.BlockedAt]
  | node f ih =>
    rw [blockedL_node, shape_node]
    exact forall_congr' (fun i => ih i (δ + 1))

/-- The number of `k`-blocked labelled trees whose leaves carry the labels of `S`, each once, is
`|S|!` times the number of `k`-blocked shapes with `|S|` leaves (same proof as
`card_good_lab_eq`, with the blocked condition carried along). -/
theorem card_good_lab_blocked_eq [DecidableEq α] (k : ℕ) (S : Finset α) :
    Nat.card {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k (fun _ => 0) 0} =
      Nat.card {U : PTree p // U.leaves = S.card ∧ PTree.BlockedAt k 0 U} * S.card.factorial := by
  rw [← card_nodup_lists S, ← Nat.card_prod]
  have hlen : ∀ T : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k (fun _ => 0) 0},
      T.1.shape.leaves = S.card := by
    intro T
    rw [← length_labels, ← List.toFinset_card_of_nodup ((nodup_labels T.1).mpr T.2.1),
      toFinset_labels, T.2.2.1]
  refine Nat.card_eq_of_bijective
    (fun T => (⟨T.1.shape, hlen T, (blockedL_zero_iff_shape k 0 T.1).mp T.2.2.2⟩,
      ⟨T.1.labels, (nodup_labels T.1).mpr T.2.1, (toFinset_labels T.1).trans T.2.2.1⟩)) ⟨?_, ?_⟩
  · intro T T' h
    apply Subtype.ext
    exact eq_of_shape_labels T.1 T'.1 (congrArg (fun x => x.1.1) h) (congrArg (fun x => x.2.1) h)
  · rintro ⟨⟨U, hU, hUb⟩, ⟨l, hnd, hl⟩⟩
    have hll : l.length = U.leaves := by
      rw [hU, ← hl, List.toFinset_card_of_nodup hnd]
    obtain ⟨T, hTs, hTl⟩ := exists_of_shape_labels U l hll
    refine ⟨⟨T, (nodup_labels T).mp (by rw [hTl]; exact hnd), by
      rw [← toFinset_labels, hTl, hl], ?_⟩, ?_⟩
    · exact (blockedL_zero_iff_shape k 0 T).mpr (by rw [hTs]; exact hUb)
    · apply Prod.ext
      · exact Subtype.ext hTs
      · exact Subtype.ext hTl

end LTree

/-- **Lemma L1 of the accounting proof.** -/
theorem factorial_mul_card_blocked_modEq (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (m N : ℕ)
    (hN : (p - 1) * N + 1 = m) (hm : m ≡ 1 [MOD p ^ k - 1]) :
    (m.factorial : ℤ) * (Nat.card {U : PTree p // U.leaves = m ∧ PTree.BlockedAt k 0 U} : ℤ) ≡
      (-(p : ℤ)) ^ N [ZMOD (p : ℤ) ^ (N + 1)] := by
  have hcard : (Finset.univ : Finset (Fin m)).card = m := by
    rw [Finset.card_univ, Fintype.card_fin]
  have hI : (∑ _x ∈ (Finset.univ : Finset (Fin m)), p ^ (0 : ℕ)) ≡ 1 [MOD p ^ k - 1] := by
    simp only [pow_zero, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul,
      mul_one]
    exact hm
  have h := LTree.labelled_congruence_blocked (p := p) (α := Fin m) k hk (fun _ => 0) N
    Finset.univ (by rw [hcard]; exact hN.symm) hI
  rw [LTree.card_good_lab_blocked_eq, hcard] at h
  push_cast at h
  rw [mul_comm]
  exact h


end MMM

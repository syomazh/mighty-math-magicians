/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **The divisibility half of the theorem, from tree symmetries.**
  For a prime `p`, the number of `p`-ary trees with `m` leaves is divisible by `p ^ t`, where
  `(p - 1) * t + 1` is the base-`p` digit sum of `m`.

Proof: the trees with `m` leaves form a finite set; it is a disjoint union of rotation classes;
each class has `p ^ d` elements (Step 1) with `d ≥ t` (Step 2).

Here the number of trees is *defined* by counting trees. That this number is the Fuss-Catalan
number `binom(p n, n) / ((p - 1) n + 1)` (for `m = (p - 1) n + 1`) is classical and is not
proved in this file.
-/
import MMM.ClassSize
import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Set.Finite.Lattice
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace MMM

namespace PTree

variable {p : ℕ}

theorem leaves_pos [NeZero p] (T : PTree p) : 0 < T.leaves := by
  induction T with
  | leaf => simp
  | node f ih =>
    rw [leaves_node]
    exact lt_of_lt_of_le (ih 0)
      (Finset.single_le_sum (f := fun i => (f i).leaves) (fun _ _ => Nat.zero_le _)
        (Finset.mem_univ 0))

/-- A child has fewer leaves than its parent (`p ≥ 2`). -/
theorem child_leaves_lt (hp : 2 ≤ p) (f : Fin p → PTree p) (i : Fin p) :
    (f i).leaves < ∑ j, (f j).leaves := by
  have : NeZero p := ⟨by omega⟩
  obtain ⟨j, hj⟩ : ∃ j : Fin p, j ≠ i := by
    by_cases h : i.val = 0
    · exact ⟨⟨1, by omega⟩, fun h' => by
        have := congrArg Fin.val h'
        simp at this
        omega⟩
    · exact ⟨⟨0, by omega⟩, fun h' => by
        have := congrArg Fin.val h'
        simp at this
        omega⟩
  have h1 := Finset.add_sum_erase Finset.univ (fun j => (f j).leaves) (Finset.mem_univ i)
  have h2 : (f j).leaves ≤ ∑ x ∈ Finset.univ.erase i, (f x).leaves :=
    Finset.single_le_sum (f := fun x => (f x).leaves) (fun _ _ => Nat.zero_le _)
      (Finset.mem_erase.mpr ⟨hj, Finset.mem_univ j⟩)
  have h3 := leaves_pos (f j)
  beta_reduce at h1 h2
  omega

/-- There are finitely many `p`-ary trees with `m` leaves (`p ≥ 2`). -/
theorem finite_leaves_eq (hp : 2 ≤ p) : ∀ m : ℕ, {T : PTree p | T.leaves = m}.Finite := by
  intro m
  induction m using Nat.strong_induction_on with
  | _ m ih =>
    have hS : (⋃ k ∈ {k : ℕ | k < m}, {T : PTree p | T.leaves = k}).Finite :=
      Set.Finite.biUnion (Set.finite_lt_nat m) (fun k hk => ih k hk)
    refine ((Set.finite_singleton leaf).union
      ((Set.Finite.pi' (fun _ : Fin p => hS)).image node)).subset ?_
    intro T hT
    cases T with
    | leaf => left; rfl
    | node f =>
      right
      refine ⟨f, fun i => ?_, rfl⟩
      refine Set.mem_iUnion₂.mpr ⟨(f i).leaves, ?_, rfl⟩
      have h := child_leaves_lt hp f i
      simp only [Set.mem_ofPred_eq, leaves_node] at hT ⊢
      omega

section prime

variable [hp : Fact p.Prime]

/-- **Divisibility from symmetry.** If `(p - 1) * t + 1 = s_p(m)`, then `p ^ t` divides the number
of `p`-ary trees with `m` leaves. -/
theorem pow_dvd_card_trees (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hfin : Finite {T : PTree p // T.leaves = m} := (finite_leaves_eq hp2 m).to_subtype
  let s : Setoid {T : PTree p // T.leaves = m} :=
    ⟨fun a b => Rot a.1 b.1, ⟨fun a => Rot.refl a.1, fun h => h.symm, fun h1 h2 => h1.trans h2⟩⟩
  have : Fintype (Quotient s) := Fintype.ofFinite _
  have key : Nat.card {T : PTree p // T.leaves = m} =
      ∑ c : Quotient s, Nat.card {x : {T : PTree p // T.leaves = m} // Quotient.mk s x = c} := by
    rw [← Nat.card_sigma]
    exact Nat.card_congr (Equiv.sigmaFiberEquiv (Quotient.mk s)).symm
  rw [key]
  refine Finset.dvd_sum (fun c _ => ?_)
  induction c using Quotient.inductionOn with
  | _ T =>
    have e : {x : {T : PTree p // T.leaves = m} // Quotient.mk s x = Quotient.mk s T} ≃
        {S : PTree p // Rot S T.1} :=
      { toFun := fun x => ⟨x.1.1, Quotient.exact x.2⟩
        invFun := fun S => ⟨⟨S.1, by rw [S.2.leaves_eq]; exact T.2⟩, Quotient.sound S.2⟩
        left_inv := fun x => rfl
        right_inv := fun S => rfl }
    rw [Nat.card_congr e, card_class]
    exact pow_dvd_pow p (t_le_d hp2 T.1 t (by rw [T.2]; exact ht))

/-- The trees with `m` leaves form a finite set, so the number above is the true count. -/
theorem finite_trees (m : ℕ) : Finite {T : PTree p // T.leaves = m} :=
  (finite_leaves_eq hp.out.two_le m).to_subtype

end prime

end PTree

end MMM

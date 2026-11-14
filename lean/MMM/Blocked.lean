/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Prime powers.** A `q`-ary tree with `q = p ^ k` is read in the paper as a `p`-ary tree all of
  whose leaves lie at a depth divisible by `k` ("`k`-blocked", Lemma "Blocked form").
  This file proves: the number of `k`-blocked `p`-ary trees with `m` leaves is divisible by
  `p ^ t`, where `(p - 1) * t + 1` is the base-`p` digit sum of `m`.

Rotations do not change depths, so the blocked trees are a union of rotation classes, and the
argument of `MMM/Divisibility.lean` applies to them unchanged.

Not proved in this file: the bijection between `q`-ary trees and `k`-blocked `p`-ary trees (Lemma
"Blocked form" of the paper), so the statement here is about blocked `p`-ary trees. The bijection
is in `MMM/BlockedForm.lean`.
-/
import MMM.Divisibility

namespace MMM

namespace PTree

variable {p : ℕ}

/-- All leaves of `T` lie at a depth `≡ 0 (mod k)`, when the root of `T` is at depth `δ`. -/
def BlockedAt (k : ℕ) : ℕ → PTree p → Prop
  | δ, leaf => k ∣ δ
  | δ, node f => ∀ i, BlockedAt k (δ + 1) (f i)

/-- Rotation equivalence preserves the depth condition. -/
theorem Rot.blockedAt [NeZero p] {k : ℕ} {S T : PTree p} (h : Rot S T) :
    ∀ δ, BlockedAt k δ S ↔ BlockedAt k δ T := by
  induction h with
  | leaf => intro δ; rfl
  | node f g r _ ih =>
    intro δ
    simp only [BlockedAt]
    constructor
    · intro hf i
      exact (ih i (δ + 1)).mp (hf (i + r))
    · intro hg i
      have h1 := (ih (i - r) (δ + 1)).mpr (hg (i - r))
      simpa using h1

section prime

variable [hp : Fact p.Prime]

/-- **Divisibility for prime powers, from symmetry.** The number of `k`-blocked `p`-ary trees
with `m` leaves is divisible by `p ^ t`, where `(p - 1) * t + 1 = s_p(m)`. -/
theorem pow_dvd_card_blocked_trees (k m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hsub : {T : PTree p | T.leaves = m ∧ BlockedAt k 0 T}.Finite := by
    refine (finite_leaves_eq hp2 m).subset ?_
    intro T hT
    simp only [Set.mem_ofPred_eq] at hT ⊢
    exact hT.1
  have hfin : Finite {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} := hsub.to_subtype
  let s : Setoid {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} :=
    ⟨fun a b => Rot a.1 b.1, ⟨fun a => Rot.refl a.1, fun h => h.symm, fun h1 h2 => h1.trans h2⟩⟩
  have : Fintype (Quotient s) := Fintype.ofFinite _
  have key : Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} =
      ∑ c : Quotient s,
        Nat.card {x : {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} // Quotient.mk s x = c} := by
    rw [← Nat.card_sigma]
    exact Nat.card_congr (Equiv.sigmaFiberEquiv (Quotient.mk s)).symm
  rw [key]
  refine Finset.dvd_sum (fun c _ => ?_)
  induction c using Quotient.inductionOn with
  | _ T =>
    have e : {x : {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} //
          Quotient.mk s x = Quotient.mk s T} ≃ {S : PTree p // Rot S T.1} :=
      { toFun := fun x => ⟨x.1.1, Quotient.exact x.2⟩
        invFun := fun S =>
          ⟨⟨S.1, by rw [S.2.leaves_eq]; exact T.2.1, (S.2.blockedAt 0).mpr T.2.2⟩,
            Quotient.sound S.2⟩
        left_inv := fun x => rfl
        right_inv := fun S => rfl }
    rw [Nat.card_congr e, card_class]
    exact pow_dvd_pow p (t_le_d hp2 T.1 t (by rw [T.2.1]; exact ht))

end prime

end PTree

end MMM

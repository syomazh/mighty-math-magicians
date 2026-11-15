/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W047), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **The congruence for rotation-closed families of `p`-ary trees (claim C11 of the ledger).**

Let `P` be a finite family of `p`-ary trees, `p` prime, that is closed under rotation and in which
every tree has at least `t` asymmetric nodes. Then, modulo `p ^ (t + 1)`,

      #P  ≡  p ^ t * #(rotation classes of P whose trees have exactly `t` asymmetric nodes).

Proof: the trees of `P` with more than `t` asymmetric nodes lie in classes of size `p ^ d`,
`d ≥ t + 1` (`card_modEq_minimal_of_closed` in `MMM/ReductionB.lean`), and the others lie in
classes of size exactly `p ^ t` (`card_eq_pow_mul_classes` in `MMM/Reduction.lean`).
No factorial and no valuation is used.
-/
import MMM.ReductionB

namespace MMM

namespace PTree

variable {p : ℕ}

/-- **Claim C11.** A finite rotation-closed family in which every tree has at least `t`
asymmetric nodes has, modulo `p ^ (t + 1)`, `p ^ t` times as many trees as it has rotation
classes with exactly `t` asymmetric nodes. -/
theorem card_closed_modEq_classes [Fact p.Prime] (P : PTree p → Prop)
    (hP : ∀ S T, Rot S T → P T → P S) [Finite {T : PTree p // P T}] (t : ℕ)
    (ht : ∀ T, P T → t ≤ T.d) :
    Nat.card {T : PTree p // P T} ≡
      p ^ t * Nat.card (Quotient (rotSetoidOn (fun T : PTree p => P T ∧ T.d = t)))
        [MOD p ^ (t + 1)] := by
  have hfin : Finite {T : PTree p // P T ∧ T.d = t} :=
    Finite.of_equiv _ (Equiv.subtypeSubtypeEquivSubtypeInter P (fun T => T.d = t))
  have hcl : ∀ S T : PTree p, Rot S T → (P T ∧ T.d = t) → (P S ∧ S.d = t) := by
    rintro S T h ⟨hT, hd⟩
    exact ⟨hP S T h hT, h.d_eq.trans hd⟩
  rw [← card_eq_pow_mul_classes (fun T : PTree p => P T ∧ T.d = t) hcl t (fun _ hT => hT.2)]
  exact card_modEq_minimal_of_closed P hP t ht

end PTree

end MMM

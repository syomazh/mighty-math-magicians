/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

Two counting facts about a finite set cut into classes by an equivalence relation.
They are used wherever the paper says "sum over the classes".
-/
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Fintype.BigOperators

namespace MMM

/-- A finite set is the disjoint union of its classes. -/
theorem card_eq_sum_classes {X : Type*} [Finite X] (s : Setoid X) [Fintype (Quotient s)] :
    Nat.card X = ∑ c : Quotient s, Nat.card {x : X // Quotient.mk s x = c} := by
  rw [← Nat.card_sigma]
  exact Nat.card_congr (Equiv.sigmaFiberEquiv (Quotient.mk s)).symm

/-- The class of `x`, as the set of elements related to `x`. -/
def classEquivRel {X : Type*} (s : Setoid X) (x : X) :
    {y : X // Quotient.mk s y = Quotient.mk s x} ≃ {y : X // s.r y x} :=
  Equiv.subtypeEquivRight fun _ => ⟨fun h => Quotient.exact h, fun h => Quotient.sound h⟩

/-- If every class has a size divisible by `N`, then `N` divides the size of the set. -/
theorem dvd_card_of_classes {X : Type*} [Finite X] (s : Setoid X) (N : ℕ)
    (h : ∀ x : X, N ∣ Nat.card {y : X // s.r y x}) : N ∣ Nat.card X := by
  have : Fintype (Quotient s) := Fintype.ofFinite _
  rw [card_eq_sum_classes s]
  refine Finset.dvd_sum fun c _ => ?_
  induction c using Quotient.inductionOn with
  | _ x => rw [Nat.card_congr (classEquivRel s x)]; exact h x

/-- If every class has exactly `N` elements, the set has `N` times as many elements as there
are classes. -/
theorem card_eq_mul_card_quotient {X : Type*} [Finite X] (s : Setoid X) (N : ℕ)
    (h : ∀ x : X, Nat.card {y : X // s.r y x} = N) : Nat.card X = N * Nat.card (Quotient s) := by
  have : Fintype (Quotient s) := Fintype.ofFinite _
  rw [card_eq_sum_classes s]
  have : ∀ c : Quotient s, Nat.card {x : X // Quotient.mk s x = c} = N := by
    intro c
    induction c using Quotient.inductionOn with
    | _ x => rw [Nat.card_congr (classEquivRel s x)]; exact h x
  rw [Finset.sum_const_nat (fun c _ => this c), Finset.card_univ, Nat.card_eq_fintype_card,
    mul_comm]

end MMM

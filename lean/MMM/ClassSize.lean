/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Step 1 of the main proof (class size):** for a prime `p`, the rotation class of a `p`-ary
  tree `T` has exactly `p ^ d(T)` trees.

Proof as in the paper (Lemma "Class size"): at a symmetric node the class is a product of the
classes of the children; at an asymmetric node the `p` rotations give `p` disjoint copies of that
product, because a non-trivial shift that preserved the children up to equivalence would make
all children equivalent (`p` is prime: a non-zero shift generates `Z/p`).
-/
import MMM.RotEquiv
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.GroupTheory.SpecificGroups.Cyclic.Subgroup

namespace MMM

namespace PTree

variable {p : ℕ}

/-- The children of a node (a dummy family for a leaf). -/
def kids : PTree p → Fin p → PTree p
  | leaf => fun _ => leaf
  | node g => g

section prime

variable [hp : Fact p.Prime]

instance instNeZeroOfPrime : NeZero p := ⟨hp.out.ne_zero⟩

/-- If a non-zero shift `s` preserves the children up to equivalence, the node is symmetric.
This is where `p` prime is used: the shifts with this property form a subgroup of `Z/p`. -/
theorem symmetric_of_shift {f : Fin p → PTree p} {s : Fin p} (hs : s ≠ 0)
    (h : ∀ i, Rot (f i) (f (i + s))) : Symmetric f := by
  let H : AddSubgroup (Fin p) :=
    { carrier := {x | ∀ i, Rot (f i) (f (i + x))}
      zero_mem' := fun i => by simpa using Rot.refl (f i)
      add_mem' := fun {a b} ha hb i => by
        have h1 := (ha i).trans (hb (i + a))
        simpa [add_assoc] using h1
      neg_mem' := fun {a} ha i => by
        have h1 := (ha (i + -a)).symm
        simpa using h1 }
  have : Fact (Nat.card (Fin p)).Prime := ⟨by simpa using hp.out⟩
  have hsH : s ∈ H := h
  rcases AddSubgroup.eq_bot_or_eq_top_of_prime_card H with hH | hH
  · rw [hH, AddSubgroup.mem_bot] at hsH
    exact absurd hsH hs
  · intro i j
    have hmem : j - i ∈ H := by rw [hH]; exact AddSubgroup.mem_top _
    have h1 := hmem i
    simpa using h1

/-- The class of `node f`, described by the children. -/
def classEquiv (f : Fin p → PTree p) :
    {S : PTree p // Rot S (node f)} ≃
      {g : Fin p → PTree p // ∃ r, ∀ i, Rot (g (i + r)) (f i)} where
  toFun S := ⟨kids S.1, by
    obtain ⟨S, hS⟩ := S
    cases hS with
    | node _ _ r h => exact ⟨r, h⟩⟩
  invFun g := ⟨node g.1, by
    obtain ⟨g, r, h⟩ := g
    exact Rot.node g f r h⟩
  left_inv := by
    rintro ⟨S, hS⟩
    cases hS
    rfl
  right_inv := by
    rintro ⟨g, hg⟩
    rfl

/-- **Class size (Step 1).** The rotation class of `T` has exactly `p ^ d(T)` elements. -/
theorem card_class (T : PTree p) : Nat.card {S : PTree p // Rot S T} = p ^ T.d := by
  induction T with
  | leaf =>
    have : Subsingleton {S : PTree p // Rot S leaf} :=
      ⟨by
        rintro ⟨S, hS⟩ ⟨S', hS'⟩
        cases hS
        cases hS'
        rfl⟩
    have : Nonempty {S : PTree p // Rot S leaf} := ⟨⟨leaf, Rot.leaf⟩⟩
    simp
  | node f ih =>
    rw [Nat.card_congr (classEquiv f)]
    -- the product of the classes of the children
    have hprod : Nat.card {g : Fin p → PTree p // ∀ i, Rot (g i) (f i)} = p ^ ∑ i, (f i).d := by
      rw [Nat.card_congr (Equiv.subtypePiEquivPi (p := fun i (S : PTree p) => Rot S (f i))),
        Nat.card_pi]
      simp only [ih]
      exact Finset.prod_pow_eq_pow_sum _ _ _
    by_cases hs : Symmetric f
    · -- symmetric node: a shift changes nothing
      rw [d_node_symm f hs, ← hprod]
      refine Nat.card_congr (Equiv.subtypeEquivRight (fun g => ?_))
      constructor
      · rintro ⟨r, h⟩ i
        have h1 := h (i - r)
        simp only [sub_add_cancel] at h1
        exact h1.trans (hs (i - r) i)
      · intro h
        exact ⟨0, fun i => by simpa using h i⟩
    · -- asymmetric node: p disjoint copies
      rw [d_node_asymm f hs, pow_succ, ← hprod]
      have hcard : Nat.card (Fin p × {g : Fin p → PTree p // ∀ i, Rot (g i) (f i)}) =
          p ^ (∑ i, (f i).d) * p := by
        rw [Nat.card_prod, hprod]
        simp [mul_comm]
      rw [← hprod] at hcard
      rw [← hcard]
      symm
      let φ : Fin p × {g : Fin p → PTree p // ∀ i, Rot (g i) (f i)} →
          {g : Fin p → PTree p // ∃ r, ∀ i, Rot (g (i + r)) (f i)} :=
        fun x => ⟨fun i => x.2.1 (i - x.1), ⟨x.1, fun i => by simpa using x.2.2 i⟩⟩
      refine Nat.card_eq_of_bijective φ ⟨?_, ?_⟩
      · -- injective
        rintro ⟨r1, g1, h1⟩ ⟨r2, g2, h2⟩ heq
        have hfun : ∀ i, g1 (i - r1) = g2 (i - r2) := fun i => congrFun (congrArg Subtype.val heq) i
        have hr : r1 = r2 := by
          by_contra hne
          apply hs
          refine symmetric_of_shift (s := r1 - r2) (sub_ne_zero.mpr hne) (fun i => ?_)
          have e := hfun (i + r1)
          simp only [add_sub_cancel_right] at e
          have e' : g1 i = g2 (i + (r1 - r2)) := by
            rw [e]; congr 1; abel
          have a := (h1 i).symm
          rw [e'] at a
          exact a.trans (h2 (i + (r1 - r2)))
        subst hr
        have hg : g1 = g2 := by
          funext i
          have e := hfun (i + r1)
          simpa using e
        subst hg
        rfl
      · -- surjective
        rintro ⟨g, r, h⟩
        refine ⟨(r, ⟨fun i => g (i + r), h⟩), ?_⟩
        apply Subtype.ext
        funext i
        simp [φ]

end prime

end PTree

end MMM

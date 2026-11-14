/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed.

  **Reduction of the exact valuation to the minimal trees** (`p` prime, `(p - 1) * t + 1 = s_p(m)`).

  1. A finite family of trees that is closed under rotation and in which every tree has at least
     `e` asymmetric nodes has a size divisible by `p ^ e`  (claim C11 of the ledger, divisibility).
  2. Modulo `p ^ (t + 1)`, the number of trees with `m` leaves equals the number of *minimal*
     trees, those with exactly `t` asymmetric nodes.
  3. The number of minimal trees is `p ^ t` times the number of minimal rotation classes.
  4. Hence: the valuation is exactly `t` as soon as `p ^ (t + 1)` does not divide the number of
     minimal trees, that is, as soon as the number of minimal classes is not divisible by `p`.

Steps 3 and 4 of the paper are what proves the hypothesis in 4; they are in other files.
-/
import MMM.Divisibility
import MMM.Counting
import Mathlib.Data.Nat.ModEq

namespace MMM

namespace PTree

variable {p : ℕ} [hp : Fact p.Prime]

/-- Rotation equivalence on a family of trees that is closed under it. -/
def rotSetoidOn (P : PTree p → Prop) : Setoid {T : PTree p // P T} :=
  ⟨fun a b => Rot a.1 b.1, ⟨fun a => Rot.refl a.1, fun h => h.symm, fun h1 h2 => h1.trans h2⟩⟩

/-- In a family closed under rotation, the class of a tree inside the family is its whole
rotation class. -/
def classOnEquiv (P : PTree p → Prop) (hP : ∀ S T, Rot S T → P T → P S) (x : {T : PTree p // P T}) :
    {y : {T : PTree p // P T} // (rotSetoidOn P).r y x} ≃ {S : PTree p // Rot S x.1} where
  toFun y := ⟨y.1.1, y.2⟩
  invFun S := ⟨⟨S.1, hP S.1 x.1 S.2 x.2⟩, S.2⟩
  left_inv _ := rfl
  right_inv _ := rfl

/-- **Divisibility for any closed family.** If a finite family of trees is closed under rotation
and each of its trees has at least `e` asymmetric nodes, its size is divisible by `p ^ e`. -/
theorem pow_dvd_card_of_closed (P : PTree p → Prop) (hP : ∀ S T, Rot S T → P T → P S)
    [Finite {T : PTree p // P T}] (e : ℕ) (he : ∀ T, P T → e ≤ T.d) :
    p ^ e ∣ Nat.card {T : PTree p // P T} := by
  refine dvd_card_of_classes (rotSetoidOn P) (p ^ e) (fun x => ?_)
  rw [Nat.card_congr (classOnEquiv P hP x), card_class]
  exact pow_dvd_pow p (he x.1 x.2)

/-- If every tree of a closed finite family has exactly `e` asymmetric nodes, the family has
`p ^ e` times as many trees as it has rotation classes. -/
theorem card_eq_pow_mul_classes (P : PTree p → Prop) (hP : ∀ S T, Rot S T → P T → P S)
    [Finite {T : PTree p // P T}] (e : ℕ) (he : ∀ T, P T → T.d = e) :
    Nat.card {T : PTree p // P T} = p ^ e * Nat.card (Quotient (rotSetoidOn P)) := by
  refine card_eq_mul_card_quotient (rotSetoidOn P) (p ^ e) (fun x => ?_)
  rw [Nat.card_congr (classOnEquiv P hP x), card_class, he x.1 x.2]

/-- The trees with `m` leaves and exactly `t` asymmetric nodes: the *minimal* trees when
`(p - 1) * t + 1 = s_p(m)`. -/
abbrev IsMinimal (m t : ℕ) (T : PTree p) : Prop := T.leaves = m ∧ T.d = t

/-- Any family of trees with `m` leaves is finite. -/
theorem finite_of_leaves (m : ℕ) (P : PTree p → Prop) :
    Finite {T : PTree p // T.leaves = m ∧ P T} := by
  have h : {T : PTree p | T.leaves = m ∧ P T}.Finite := by
    refine (finite_leaves_eq hp.out.two_le m).subset ?_
    intro T hT
    simp only [Set.mem_ofPred_eq] at hT ⊢
    exact hT.1
  exact h.to_subtype

instance finite_minimal (m t : ℕ) : Finite {T : PTree p // IsMinimal m t T} :=
  finite_of_leaves m (fun T => T.d = t)

/-- **Only the minimal trees matter modulo `p ^ (t + 1)`.** -/
theorem card_trees_modEq_minimal (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    Nat.card {T : PTree p // T.leaves = m} ≡
      Nat.card {T : PTree p // IsMinimal m t T} [MOD p ^ (t + 1)] := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have hfin : Finite {T : PTree p // T.leaves = m} := finite_trees m
  -- the trees with more than `t` asymmetric nodes
  have hfin2 : Finite {T : PTree p // T.leaves = m ∧ T.d ≠ t} :=
    finite_of_leaves m (fun T => T.d ≠ t)
  have hbig : p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m ∧ T.d ≠ t} := by
    refine pow_dvd_card_of_closed (fun T => T.leaves = m ∧ T.d ≠ t) ?_ (t + 1) ?_
    · rintro S T h ⟨hl, hd⟩
      exact ⟨h.leaves_eq.trans hl, by rw [h.d_eq]; exact hd⟩
    · rintro T ⟨hl, hd⟩
      have := t_le_d hp2 T t (by rw [hl]; exact ht)
      omega
  -- split the trees with `m` leaves according to `d = t` or not
  have hsplit : Nat.card {T : PTree p // T.leaves = m} =
      Nat.card {T : PTree p // IsMinimal m t T} +
        Nat.card {T : PTree p // T.leaves = m ∧ T.d ≠ t} := by
    rw [← Nat.card_sum]
    refine Nat.card_congr ?_
    exact (Equiv.sumCompl (fun x : {T : PTree p // T.leaves = m} => x.1.d = t)).symm.trans
      (Equiv.sumCongr
        (Equiv.subtypeSubtypeEquivSubtypeInter (fun T : PTree p => T.leaves = m) (fun T => T.d = t))
        (Equiv.subtypeSubtypeEquivSubtypeInter (fun T : PTree p => T.leaves = m)
          (fun T => ¬ T.d = t)))
  rw [hsplit]
  have h0 := Nat.modEq_zero_iff_dvd.mpr hbig
  simpa using (Nat.ModEq.refl (Nat.card {T : PTree p // IsMinimal m t T})).add h0

/-- The minimal trees come in classes of exactly `p ^ t` trees. -/
theorem card_minimal_eq (m t : ℕ) :
    Nat.card {T : PTree p // IsMinimal m t T} =
      p ^ t * Nat.card (Quotient (rotSetoidOn (IsMinimal (p := p) m t))) := by
  refine card_eq_pow_mul_classes (IsMinimal m t) ?_ t (fun _ hT => hT.2)
  rintro S T h ⟨hl, hd⟩
  exact ⟨h.leaves_eq.trans hl, h.d_eq.trans hd⟩

/-- **Trees modulo `p ^ (t + 1)`:** the number of trees with `m` leaves is congruent to `p ^ t`
times the number of minimal classes. -/
theorem card_trees_modEq_classes (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    Nat.card {T : PTree p // T.leaves = m} ≡
      p ^ t * Nat.card (Quotient (rotSetoidOn (IsMinimal (p := p) m t))) [MOD p ^ (t + 1)] := by
  rw [← card_minimal_eq]
  exact card_trees_modEq_minimal m t ht

/-- **The exact valuation, reduced to the minimal trees.** If `p ^ (t + 1)` does not divide the
number of minimal trees, then `p ^ t` is the exact power of `p` in the number of trees with
`m` leaves. -/
theorem exact_of_minimal (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m)
    (hmin : ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // IsMinimal m t T}) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m} :=
  ⟨pow_dvd_card_trees m t ht,
    fun h => hmin (((card_trees_modEq_minimal m t ht).dvd_iff (dvd_refl _)).mp h)⟩

/-- The same reduction in terms of classes: it is enough that the number of minimal classes
is not divisible by `p`. -/
theorem exact_of_classes (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m)
    (hcl : ¬ p ∣ Nat.card (Quotient (rotSetoidOn (IsMinimal (p := p) m t)))) :
    p ^ t ∣ Nat.card {T : PTree p // T.leaves = m} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : PTree p // T.leaves = m} := by
  refine exact_of_minimal m t ht (fun h => hcl ?_)
  rw [card_minimal_eq, pow_succ] at h
  exact (Nat.mul_dvd_mul_iff_left (pow_pos hp.out.pos t)).mp h

end PTree

end MMM

/-
Written by Claude Fable 5.2 (AI, orchestrator), 2026-11-14. Machine-checked by Lean when this file
compiles; not human-reviewed. (An earlier attempt at this file by an Open Math OS worker, W024,
did not compile and is kept only in that worker's log folder.)

  **The closed formula for the number of `q`-ary trees (Fuss–Catalan numbers).**

      ((q - 1) * n + 1) * #(q-ary trees with n internal nodes) = binom(q n, n).

This is classical. The proof here counts ordered forests instead of single trees: let `F(t, r)` be
the number of sequences of `r` trees with `t` internal nodes in total. Looking at the first tree,
which is either a leaf or a node with `q` subtrees,

      F(t + 1, r + 1) = F(t + 1, r) + F(t, q + r),

and the numbers `r * binom(q t + r, t) / (q t + r)` satisfy the same recursion (Pascal's rule and
`binom(M, t + 1) * (t + 1) = binom(M, t) * (M - t)`). So, by induction on `q t + r`,

      (q t + r) * F(t, r) = r * binom(q t + r, t)        (`forest_card`),

and `r = 1` gives the formula for trees.
-/
import MMM.Trees
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Basic.Finite.Sum
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

namespace MMM

namespace PTree

variable {q : ℕ}

theorem eq_leaf_of_nodes_eq_zero (T : PTree q) (h : T.nodes = 0) : T = leaf := by
  cases T with
  | leaf => rfl
  | node f =>
    simp only [nodes] at h
    omega

/-- Ordered forests of `r` trees with `t` internal nodes in total. -/
abbrev Forest (q r t : ℕ) : Type := {f : Fin r → PTree q // ∑ i, (f i).nodes = t}

/-- Put a first tree in front of a forest: a leaf, or a node whose `q` subtrees are the first `q`
trees of a longer forest. -/
def forestStep (q r t : ℕ) : Forest q r (t + 1) ⊕ Forest q (q + r) t → Forest q (r + 1) (t + 1)
  | Sum.inl f => ⟨Fin.cons leaf f.1, by
      have hf := f.2
      rw [Fin.sum_univ_succ]
      simp only [Fin.cons_zero, Fin.cons_succ, nodes]
      omega⟩
  | Sum.inr h => ⟨Fin.cons (node fun j => h.1 (Fin.castAdd r j)) (fun i => h.1 (Fin.natAdd q i)), by
      have hh := h.2
      rw [Fin.sum_univ_add] at hh
      rw [Fin.sum_univ_succ]
      simp only [Fin.cons_zero, Fin.cons_succ, nodes]
      omega⟩

theorem forestStep_injective (q r t : ℕ) : Function.Injective (forestStep q r t) := by
  rintro (f | h) (f' | h') heq
  · have h1 := congrArg Subtype.val heq
    simp only [forestStep] at h1
    exact congrArg Sum.inl (Subtype.ext (Fin.cons_injective2 h1).2)
  · have h1 := congrArg Subtype.val heq
    simp only [forestStep] at h1
    have h0 := (Fin.cons_injective2 h1).1
    cases h0
  · have h1 := congrArg Subtype.val heq
    simp only [forestStep] at h1
    have h0 := (Fin.cons_injective2 h1).1
    cases h0
  · have h1 := congrArg Subtype.val heq
    simp only [forestStep] at h1
    obtain ⟨h2, h3⟩ := Fin.cons_injective2 h1
    have h2' := PTree.node.inj h2
    refine congrArg Sum.inr (Subtype.ext (funext fun x => ?_))
    refine Fin.addCases (fun j => ?_) (fun i => ?_) x
    · exact congrFun h2' j
    · exact congrFun h3 i

theorem forestStep_surjective (q r t : ℕ) : Function.Surjective (forestStep q r t) := by
  rintro ⟨f, hf⟩
  rw [Fin.sum_univ_succ] at hf
  cases h0 : f 0 with
  | leaf =>
    rw [h0] at hf
    simp only [nodes] at hf
    refine ⟨Sum.inl ⟨fun i => f i.succ, by
      show ∑ i : Fin r, (f i.succ).nodes = t + 1
      omega⟩, ?_⟩
    apply Subtype.ext
    show Fin.cons leaf (fun i => f i.succ) = f
    rw [← h0]
    exact Fin.cons_self_tail f
  | node g =>
    rw [h0] at hf
    simp only [nodes] at hf
    refine ⟨Sum.inr ⟨Fin.append g (fun i => f i.succ), by
      rw [Fin.sum_univ_add]
      simp only [Fin.append_left, Fin.append_right]
      omega⟩, ?_⟩
    apply Subtype.ext
    show Fin.cons (node fun j => Fin.append g (fun i => f i.succ) (Fin.castAdd r j))
      (fun i => Fin.append g (fun i => f i.succ) (Fin.natAdd q i)) = f
    simp only [Fin.append_left, Fin.append_right]
    show Fin.cons (node g) (fun i => f i.succ) = f
    rw [← h0]
    exact Fin.cons_self_tail f

/-- **The number of forests.** `(q t + r) * F(t, r) = r * binom(q t + r, t)`; in particular the
forests with given `t` and `r` are finitely many. -/
theorem forest_card (hq : 1 ≤ q) : ∀ (M t r : ℕ), q * t + r = M →
    Finite (Forest q r t) ∧
      (q * t + r) * Nat.card (Forest q r t) = r * Nat.choose (q * t + r) t := by
  intro M
  induction M using Nat.strong_induction_on with
  | _ M ih =>
    intro t r hM
    rcases t with _ | t
    · -- no internal node: every tree is a leaf
      have huniq : ∀ f : Forest q r 0, f.1 = fun _ => leaf := by
        rintro ⟨f, hf⟩
        funext i
        exact eq_leaf_of_nodes_eq_zero _ (Finset.sum_eq_zero_iff.mp hf i (Finset.mem_univ i))
      have hsub : Subsingleton (Forest q r 0) :=
        ⟨fun a b => Subtype.ext ((huniq a).trans (huniq b).symm)⟩
      have hne : Nonempty (Forest q r 0) := ⟨⟨fun _ => leaf, by simp [nodes]⟩⟩
      refine ⟨inferInstance, ?_⟩
      rw [Nat.card_eq_one_iff_unique.mpr ⟨hsub, hne⟩]
      simp
    · rcases r with _ | r
      · -- no tree, but nodes to place: impossible
        have hemp : IsEmpty (Forest q 0 (t + 1)) := ⟨fun f => by
          have := f.2
          simp at this⟩
        refine ⟨inferInstance, ?_⟩
        simp
      · have hmul : q * (t + 1) = q * t + q := Nat.mul_succ q t
        obtain ⟨hfA, hA⟩ := ih (q * (t + 1) + r) (by omega) (t + 1) r rfl
        obtain ⟨hfB, hB⟩ := ih (q * t + (q + r)) (by omega) t (q + r) rfl
        have e2 : q * t + (q + r) = q * (t + 1) + r := by omega
        rw [e2] at hB
        have hfA' : Finite (Forest q r (t + 1)) := hfA
        have hfB' : Finite (Forest q (q + r) t) := hfB
        let e := Equiv.ofBijective (forestStep q r t)
          ⟨forestStep_injective q r t, forestStep_surjective q r t⟩
        have hfin : Finite (Forest q (r + 1) (t + 1)) := Finite.of_equiv _ e
        refine ⟨hfin, ?_⟩
        have hcard : Nat.card (Forest q (r + 1) (t + 1)) =
            Nat.card (Forest q r (t + 1)) + Nat.card (Forest q (q + r) t) := by
          rw [← Nat.card_congr e, Nat.card_sum]
        have hch := Nat.choose_succ_right_eq (q * (t + 1) + r) t
        have htm : t ≤ q * (t + 1) + r := by
          have : t ≤ q * t := Nat.le_mul_of_pos_left t hq
          omega
        have hpos : 0 < q * (t + 1) + r := by omega
        show (q * (t + 1) + r + 1) * Nat.card (Forest q (r + 1) (t + 1)) =
          (r + 1) * Nat.choose (q * (t + 1) + r + 1) (t + 1)
        rw [Nat.choose_succ_succ', hcard]
        -- from here on, arithmetic in ℤ with m = q (t + 1) + r
        generalize hmdef : q * (t + 1) + r = m at hA hB hch htm hpos ⊢
        have hM' : (m : ℤ) = q * (t + 1) + r := by
          rw [← hmdef]
          push_cast
          ring
        have hA' : (m : ℤ) * (Nat.card (Forest q r (t + 1)) : ℤ) = r * (Nat.choose m (t + 1) : ℤ) := by
          exact_mod_cast hA
        have hB' : (m : ℤ) * (Nat.card (Forest q (q + r) t) : ℤ) =
            ((q : ℤ) + r) * (Nat.choose m t : ℤ) := by
          exact_mod_cast hB
        have hch' : (Nat.choose m (t + 1) : ℤ) * ((t : ℤ) + 1) =
            (Nat.choose m t : ℤ) * ((m : ℤ) - t) := by
          have := congrArg (Nat.cast : ℕ → ℤ) hch
          push_cast [Nat.cast_sub htm] at this
          exact this
        have key : (m : ℤ) * (((m : ℤ) + 1) * ((Nat.card (Forest q r (t + 1)) : ℤ) +
            (Nat.card (Forest q (q + r) t) : ℤ)) -
              ((r : ℤ) + 1) * ((Nat.choose m t : ℤ) + (Nat.choose m (t + 1) : ℤ))) = 0 := by
          linear_combination ((m : ℤ) + 1) * hA' + ((m : ℤ) + 1) * hB' - (q : ℤ) * hch' -
            ((Nat.choose m t : ℤ) + (Nat.choose m (t + 1) : ℤ)) * hM'
        have hm0 : (m : ℤ) ≠ 0 := by exact_mod_cast hpos.ne'
        have key2 := (mul_eq_zero.mp key).resolve_left hm0
        have key3 : ((m : ℤ) + 1) * ((Nat.card (Forest q r (t + 1)) : ℤ) +
            (Nat.card (Forest q (q + r) t) : ℤ)) =
              ((r : ℤ) + 1) * ((Nat.choose m t : ℤ) + (Nat.choose m (t + 1) : ℤ)) := by
          linear_combination key2
        exact_mod_cast key3

/-- `(q n + 1) * #(q-ary trees with n internal nodes) = binom(q n + 1, n)`. -/
theorem card_nodes_mul_eq_choose (hq : 1 ≤ q) (n : ℕ) :
    (q * n + 1) * Nat.card {T : PTree q // T.nodes = n} = Nat.choose (q * n + 1) n := by
  have e : Forest q 1 n ≃ {T : PTree q // T.nodes = n} :=
    { toFun := fun f => ⟨f.1 0, by
        have := f.2
        simpa using this⟩
      invFun := fun T => ⟨fun _ => T.1, by simp [T.2]⟩
      left_inv := fun f => Subtype.ext (funext fun i => by
        have hi : i = 0 := Subsingleton.elim _ _
        rw [hi])
      right_inv := fun T => rfl }
  have h := (forest_card hq _ n 1 rfl).2
  rw [Nat.card_congr e, one_mul] at h
  exact h

/-- **The Fuss–Catalan formula.** `((q - 1) n + 1) * #(q-ary trees with n internal nodes) =
binom(q n, n)`. -/
theorem fuss_catalan_formula (hq : 1 ≤ q) (n : ℕ) :
    ((q - 1) * n + 1) * Nat.card {T : PTree q // T.nodes = n} = Nat.choose (q * n) n := by
  have h1 := card_nodes_mul_eq_choose hq n
  have h2 := Nat.choose_mul_succ_eq (q * n) n
  have hqn : q * n = (q - 1) * n + n := by
    have : (q - 1 + 1) * n = q * n := by rw [Nat.sub_add_cancel hq]
    rw [Nat.add_mul, Nat.one_mul] at this
    omega
  have h3 : q * n + 1 - n = (q - 1) * n + 1 := by omega
  rw [h3] at h2
  have h4 : (q * n + 1) * (((q - 1) * n + 1) * Nat.card {T : PTree q // T.nodes = n}) =
      (q * n + 1) * Nat.choose (q * n) n := by
    calc (q * n + 1) * (((q - 1) * n + 1) * Nat.card {T : PTree q // T.nodes = n})
        = ((q - 1) * n + 1) * ((q * n + 1) * Nat.card {T : PTree q // T.nodes = n}) := by ring
      _ = ((q - 1) * n + 1) * Nat.choose (q * n + 1) n := by rw [h1]
      _ = (q * n + 1) * Nat.choose (q * n) n := by rw [mul_comm, ← h2, mul_comm]
  exact Nat.eq_of_mul_eq_mul_left (Nat.succ_pos _) h4

/-- The Fuss–Catalan number `binom(q n, n) / ((q - 1) n + 1)` is the number of `q`-ary trees with
`n` internal nodes. -/
theorem choose_div_eq_card (hq : 1 ≤ q) (n : ℕ) :
    Nat.choose (q * n) n / ((q - 1) * n + 1) = Nat.card {T : PTree q // T.nodes = n} :=
  Nat.div_eq_of_eq_mul_right (Nat.succ_pos _) (fuss_catalan_formula hq n).symm

end PTree

end MMM

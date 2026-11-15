/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W048), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **The exact number of minimal rotation classes, for `q = p`** (claim C8 of the ledger;
  `paper/main.tex`, Corollary "exact count").

With `m_j` the base-`p` digits of `m` and `(p - 1) * t + 1 = s_p(m)`:

      N_min * t! * p ^ t * ∏_j (m_j)!  =  (p t)!,

where `N_min` is the number of rotation classes of `p`-ary trees with `m` leaves and exactly `t`
asymmetric nodes (the classes of the smallest size `p ^ t`).

The proof follows `PTree.residue` (`MMM/Residue.lean`) and keeps every equality of cardinalities
used there; the only new ingredient replaces the congruence `labelled_congruence` by an exact count:

* `LTree.card_good_lab_eq`: a tree whose leaves carry the labels of `S`, each once, is a shape
  (a `PTree p` with `|S|` leaves) together with the list of its labels from left to right, so there
  are `|S|! * #(shapes with |S| leaves)` of them;
* `card_labelled_mul_factorial_of_two_le`: with `|S| = (p - 1) t + 1` and the Fuss–Catalan formula
  `((p - 1) t + 1) * #(shapes with t nodes) = binom(p t, t)` (`MMM/FussFormula.lean`), the number
  of labelled trees times `t!` is `(p t)!`.

No valuation of a factorial or of a binomial coefficient is used.
-/
import MMM.Residue
import MMM.FussFormula
import MMM.ExactB
import Mathlib.Data.List.Permutation
import Mathlib.Data.List.OfFn
import Mathlib.Data.List.Nodup
import Mathlib.Data.Finset.Dedup
import Mathlib.Algebra.BigOperators.Fin

namespace MMM

/-! ### Two facts about lists cut into `n` consecutive pieces -/

/-- Two families of `n` lists with the same lengths and the same concatenation are equal. -/
theorem ofFn_flatten_inj {β : Type} : ∀ {n : ℕ} (g g' : Fin n → List β),
    (∀ i, (g i).length = (g' i).length) →
      (List.ofFn g).flatten = (List.ofFn g').flatten → g = g' := by
  intro n
  induction n with
  | zero =>
    intro g g' _ _
    funext i
    exact i.elim0
  | succ n ih =>
    intro g g' hlen h
    rw [List.ofFn_succ, List.ofFn_succ, List.flatten_cons, List.flatten_cons] at h
    obtain ⟨h0, h1⟩ := List.append_inj h (hlen 0)
    have h2 := ih (fun i => g i.succ) (fun i => g' i.succ) (fun i => hlen i.succ) h1
    funext i
    refine Fin.cases h0 (fun j => congrFun h2 j) i

/-- A list whose length is `c 0 + ... + c (n - 1)` is the concatenation of `n` lists of lengths
`c 0, ..., c (n - 1)`. -/
theorem exists_ofFn_flatten {β : Type} : ∀ {n : ℕ} (c : Fin n → ℕ) (l : List β),
    l.length = ∑ i, c i →
      ∃ g : Fin n → List β, (∀ i, (g i).length = c i) ∧ (List.ofFn g).flatten = l := by
  intro n
  induction n with
  | zero =>
    intro c l h
    have hl : l = [] := by
      rw [← List.length_eq_zero_iff, h]
      simp
    exact ⟨fun i => i.elim0, fun i => i.elim0, by rw [hl]; simp⟩
  | succ n ih =>
    intro c l h
    rw [Fin.sum_univ_succ] at h
    obtain ⟨g, hg, hfl⟩ := ih (fun i => c i.succ) (l.drop (c 0)) (by
      rw [List.length_drop, h]
      omega)
    refine ⟨Fin.cons (l.take (c 0)) g, fun i => ?_, ?_⟩
    · refine Fin.cases ?_ (fun j => ?_) i
      · rw [Fin.cons_zero, List.length_take]
        omega
      · rw [Fin.cons_succ]
        exact hg j
    · rw [List.ofFn_cons, List.flatten_cons, hfl]
      exact List.take_append_drop _ _

namespace LTree

variable {p : ℕ} {α : Type}

/-- The shape of a labelled tree: forget the labels. -/
def shape : LTree p α → PTree p
  | leaf _ => PTree.leaf
  | node f => PTree.node fun i => (f i).shape

/-- The labels of the leaves, from left to right. -/
def labels : LTree p α → List α
  | leaf a => [a]
  | node f => (List.ofFn fun i => (f i).labels).flatten

@[simp] theorem shape_leaf (a : α) : (leaf a : LTree p α).shape = PTree.leaf := rfl
@[simp] theorem shape_node (f : Fin p → LTree p α) :
    (node f).shape = PTree.node fun i => (f i).shape := rfl
@[simp] theorem labels_leaf (a : α) : (leaf a : LTree p α).labels = [a] := rfl
@[simp] theorem labels_node (f : Fin p → LTree p α) :
    (node f).labels = (List.ofFn fun i => (f i).labels).flatten := rfl

/-- There are as many labels as the shape has leaves. -/
theorem length_labels (T : LTree p α) : T.labels.length = T.shape.leaves := by
  induction T with
  | leaf a => rfl
  | node f ih =>
    rw [labels_node, shape_node, PTree.leaves_node, List.length_flatten, List.map_ofFn,
      List.sum_ofFn]
    exact Finset.sum_congr rfl (fun i _ => ih i)

section dec

variable [DecidableEq α]

/-- The list of labels has the same elements as the set of labels. -/
theorem mem_labels (T : LTree p α) (a : α) : a ∈ T.labels ↔ a ∈ T.lab := by
  induction T with
  | leaf b => simp
  | node f ih =>
    simp only [labels_node, lab_node, List.mem_flatten, List.mem_ofFn, Finset.mem_biUnion,
      Finset.mem_univ, true_and]
    constructor
    · rintro ⟨l, ⟨i, rfl⟩, hl⟩
      exact ⟨i, (ih i).mp hl⟩
    · rintro ⟨i, hi⟩
      exact ⟨_, ⟨i, rfl⟩, (ih i).mpr hi⟩

theorem toFinset_labels (T : LTree p α) : T.labels.toFinset = T.lab := by
  ext a
  rw [List.mem_toFinset, mem_labels]

/-- The labels are pairwise different exactly when the list of labels has no repetition. -/
theorem nodup_labels (T : LTree p α) : T.labels.Nodup ↔ T.Good := by
  induction T with
  | leaf a => simp
  | node f ih =>
    rw [good_node, labels_node, List.nodup_flatten, List.forall_mem_ofFn_iff, List.pairwise_ofFn]
    refine and_congr (forall_congr' ih) ?_
    constructor
    · intro h i j hij
      rw [Finset.disjoint_left]
      intro a ha hb
      rcases lt_or_gt_of_ne hij with hlt | hlt
      · exact h hlt ((mem_labels _ _).mpr ha) ((mem_labels _ _).mpr hb)
      · exact h hlt ((mem_labels _ _).mpr hb) ((mem_labels _ _).mpr ha)
    · intro h i j hij a ha hb
      exact Finset.disjoint_left.mp (h i j (ne_of_lt hij)) ((mem_labels _ _).mp ha)
        ((mem_labels _ _).mp hb)

end dec

/-- A labelled tree is determined by its shape and the list of its labels. -/
theorem eq_of_shape_labels : ∀ T T' : LTree p α, T.shape = T'.shape → T.labels = T'.labels →
    T = T' := by
  intro T
  induction T with
  | leaf a =>
    intro T' hs hl
    cases T' with
    | leaf b =>
      rw [labels_leaf, labels_leaf] at hl
      rw [List.cons.inj hl |>.1]
    | node g =>
      rw [shape_leaf, shape_node] at hs
      cases hs
  | node f ih =>
    intro T' hs hl
    cases T' with
    | leaf b =>
      rw [shape_leaf, shape_node] at hs
      cases hs
    | node g =>
      rw [shape_node, shape_node] at hs
      have hs' : (fun i => (f i).shape) = fun i => (g i).shape := PTree.node.inj hs
      rw [labels_node, labels_node] at hl
      have hl' : (fun i => (f i).labels) = fun i => (g i).labels :=
        ofFn_flatten_inj _ _ (fun i => by
          rw [length_labels, length_labels, congrFun hs' i]) hl
      congr 1
      funext i
      exact ih i (g i) (congrFun hs' i) (congrFun hl' i)

/-- Every shape can be labelled by every list of the right length. -/
theorem exists_of_shape_labels : ∀ (U : PTree p) (l : List α), l.length = U.leaves →
    ∃ T : LTree p α, T.shape = U ∧ T.labels = l := by
  intro U
  induction U with
  | leaf =>
    intro l h
    rw [PTree.leaves_leaf, List.length_eq_one_iff] at h
    obtain ⟨a, rfl⟩ := h
    exact ⟨leaf a, rfl, rfl⟩
  | node f ih =>
    intro l h
    rw [PTree.leaves_node] at h
    obtain ⟨g, hg, hfl⟩ := exists_ofFn_flatten (fun i => (f i).leaves) l h
    choose T hT using fun i => ih i (g i) (hg i)
    refine ⟨node T, ?_, ?_⟩
    · rw [shape_node]
      congr 1
      funext i
      exact (hT i).1
    · rw [labels_node, show (fun i => (T i).labels) = g from funext fun i => (hT i).2]
      exact hfl

/-- The number of lists without repetition whose set of elements is `S` is `|S|!`. -/
theorem card_nodup_lists [DecidableEq α] (S : Finset α) :
    Nat.card {l : List α // l.Nodup ∧ l.toFinset = S} = S.card.factorial := by
  have h : ∀ l : List α, l ∈ S.toList.permutations.toFinset ↔ (l.Nodup ∧ l.toFinset = S) := by
    intro l
    rw [List.mem_toFinset, List.mem_permutations]
    constructor
    · intro hperm
      refine ⟨hperm.nodup_iff.mpr S.nodup_toList, ?_⟩
      ext a
      rw [List.mem_toFinset, hperm.mem_iff, Finset.mem_toList]
    · rintro ⟨hnd, hS⟩
      refine (List.perm_ext_iff_of_nodup hnd S.nodup_toList).mpr (fun a => ?_)
      rw [Finset.mem_toList, ← hS, List.mem_toFinset]
  rw [Nat.subtype_card _ h,
    List.toFinset_card_of_nodup (List.nodup_permutations _ S.nodup_toList),
    List.length_permutations, Finset.length_toList]

/-- **Labelled trees = shapes × orders of the labels.** The number of `p`-ary trees whose leaves
carry the labels of `S`, each once, is `|S|!` times the number of `p`-ary trees with `|S|`
leaves. -/
theorem card_good_lab_eq [DecidableEq α] (S : Finset α) :
    Nat.card {T : LTree p α // T.Good ∧ T.lab = S} =
      Nat.card {U : PTree p // U.leaves = S.card} * S.card.factorial := by
  rw [← card_nodup_lists S, ← Nat.card_prod]
  have hlen : ∀ T : {T : LTree p α // T.Good ∧ T.lab = S}, T.1.shape.leaves = S.card := by
    intro T
    rw [← length_labels, ← List.toFinset_card_of_nodup ((nodup_labels T.1).mpr T.2.1),
      toFinset_labels, T.2.2]
  refine Nat.card_eq_of_bijective
    (fun T => (⟨T.1.shape, hlen T⟩,
      ⟨T.1.labels, (nodup_labels T.1).mpr T.2.1, (toFinset_labels T.1).trans T.2.2⟩)) ⟨?_, ?_⟩
  · intro T T' h
    apply Subtype.ext
    exact eq_of_shape_labels T.1 T'.1 (congrArg (fun x => x.1.1) h) (congrArg (fun x => x.2.1) h)
  · rintro ⟨⟨U, hU⟩, ⟨l, hnd, hl⟩⟩
    have hll : l.length = U.leaves := by
      rw [hU, ← hl, List.toFinset_card_of_nodup hnd]
    obtain ⟨T, hTs, hTl⟩ := exists_of_shape_labels U l hll
    refine ⟨⟨T, (nodup_labels T).mp (by rw [hTl]; exact hnd), by
      rw [← toFinset_labels, hTl, hl]⟩, ?_⟩
    apply Prod.ext
    · exact Subtype.ext hTs
    · exact Subtype.ext hTl

/-- **The exact number of labelled trees** (any arity `p ≥ 2`): the number of `p`-ary trees whose
`(p - 1) t + 1` leaves carry the labels of `S`, each once, times `t!`, is `(p t)!`. -/
theorem card_labelled_mul_factorial_of_two_le (hp : 2 ≤ p) [DecidableEq α] (t : ℕ) (S : Finset α)
    (hS : S.card = (p - 1) * t + 1) :
    Nat.card {T : LTree p α // T.Good ∧ T.lab = S} * t.factorial = (p * t).factorial := by
  rw [card_good_lab_eq, hS, ← PTree.card_nodes_eq_card_leaves hp t]
  have hF := PTree.fuss_catalan_formula (q := p) (by omega) t
  have hle : t ≤ p * t := Nat.le_mul_of_pos_left t (by omega)
  have hC := Nat.choose_mul_factorial_mul_factorial hle
  have hsub : p * t - t = (p - 1) * t := (Nat.sub_one_mul p t).symm
  rw [hsub, ← hF] at hC
  rw [Nat.factorial_succ, ← hC]
  ring

end LTree

/-- The number of `p`-ary trees whose `(p - 1) t + 1` leaves carry the labels of `S`, each once:
times `t!` it is `(p t)!`. -/
theorem card_labelled_mul_factorial {p : ℕ} [hp : Fact p.Prime] {α : Type} [DecidableEq α] (t : ℕ)
    (S : Finset α) (hS : S.card = (p - 1) * t + 1) :
    Nat.card {T : LTree p α // T.Good ∧ T.lab = S} * t.factorial = (p * t).factorial :=
  LTree.card_labelled_mul_factorial_of_two_le hp.out.two_le t S hS

/-- **Corollary "exact count", for the minimal trees.** With `m_j` the base-`p` digits of `m` and
`(p - 1) * t + 1 = s_p(m)`: `#(minimal trees) * t! * ∏_j (m_j)! = (p t)!`. -/
theorem card_minimal_mul_factorials (p : ℕ) [hp : Fact p.Prime] (m t : ℕ)
    (ht : (p - 1) * t + 1 = ds p m) :
    Nat.card {T : PTree p // PTree.IsMinimal m t T} *
        (t.factorial * ∏ j ∈ Finset.range m, (dig p j m).factorial) = (p * t).factorial := by
  have hp2 : 2 ≤ p := hp.out.two_le
  -- minimal trees = trees with the digits of m as content (as in `PTree.residue`)
  have e2 : Nat.card {T : PTree p // PTree.IsMinimal m t T} =
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
  -- the exact number of labelled trees, in place of `labelled_congruence`
  have h4 := card_labelled_mul_factorial (p := p) t D hD
  rw [e3, hK, LTree.factProd_digitMultiset hp2, ← e2] at h4
  rw [← h4]
  ring

/-- **Corollary "exact count".** With `m_j` the base-`p` digits of `m` and
`(p - 1) * t + 1 = s_p(m)`, the number `N_min` of rotation classes of `p`-ary trees with `m` leaves
and exactly `t` asymmetric nodes satisfies `N_min * t! * p ^ t * ∏_j (m_j)! = (p t)!`. -/
theorem card_minimal_classes_mul (p : ℕ) [hp : Fact p.Prime] (m t : ℕ)
    (ht : (p - 1) * t + 1 = ds p m) :
    Nat.card (Quotient (PTree.rotSetoidOn (PTree.IsMinimal (p := p) m t))) *
        (t.factorial * p ^ t * ∏ j ∈ Finset.range m, (dig p j m).factorial) = (p * t).factorial := by
  rw [← card_minimal_mul_factorials p m t ht, PTree.card_minimal_eq m t]
  ring

end MMM

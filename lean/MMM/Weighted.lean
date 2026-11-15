/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W051), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **Weights that rotations do not change (a weighted form of the closed-family theorem).**

* `dvd_sum_of_classes`: a finite set cut into classes, each of a size divisible by `N`, and an
  integer weight that is constant on every class: `N` divides the sum of the weights (the sum over
  a class is (size of the class) * (the weight)).
* `PTree.pow_dvd_sum_weight_of_closed`: for a prime `p`, a finite family of `p`-ary trees closed
  under rotation in which every tree has at least `e` asymmetric nodes, and a weight `w` that
  rotations do not change: `p ^ e` divides the sum of `w` over the family. A rotation class has
  `p ^ d` trees (`card_class`), `d ≥ e`.
* `PTree.depthWeight b T`: the product over the nodes `v` of `T` of `b (depth of v)`, written as
  `∏ i, b i ^ (number of nodes at depth i)`; `depthWeight_leaf` and `depthWeight_node` say that
  this is what the definition computes.
* `PTree.pow_dvd_sum_depthWeight`: for `q = p ^ k`, `k ≥ 1`, and any integers `b 0, b 1, ...`, the
  sum of `depthWeight b T` over the `q`-ary trees `T` with `n` nodes (finitely many:
  `finite_nodes_pow`) is divisible by `p ^ t`, where `(p - 1) * t + 1` is the base-`p` digit sum
  of `(q - 1) * n + 1`. For `b = 1` the sum is the number of trees (`finsum_depthWeight_one`).

The proof of the last statement goes through the blocked form (`expand`, `MMM/BlockedForm.lean`):
the `q`-ary trees with `n` nodes are the `p`-ary trees with `(q - 1) * n + 1` leaves, all at
depths divisible by `k` (`expandNodesEquiv`); the weight becomes `∏ i, b i ^ prof U (k * i)`
(`prof_expand`), which rotations do not change (`Rot.prof_eq`); and every such tree has at least
`t` asymmetric nodes (`t_le_d`). No theorem about the valuation of a factorial or of a binomial
coefficient is used.

All sums over families of trees are `finsum`s (`∑ᶠ`), as in the brief; in the proofs they are
turned into `Finset` sums over a `Fintype` obtained from `Fintype.ofFinite`.
-/
import MMM.Profile
import Mathlib.Algebra.BigOperators.Finprod

namespace MMM

/-- **Sum over the classes, with weights.** If every class of an equivalence relation on a finite
set has a size divisible by `N`, and the integer weight `w` is constant on every class, then `N`
divides the sum of `w`. (The weighted form of `dvd_card_of_classes`.) -/
theorem dvd_sum_of_classes {X : Type*} [Fintype X] (s : Setoid X) (N : ℕ) (w : X → ℤ)
    (hw : ∀ x y : X, s.r y x → w y = w x)
    (h : ∀ x : X, N ∣ Nat.card {y : X // s.r y x}) : (N : ℤ) ∣ ∑ x, w x := by
  classical
  have : Fintype (Quotient s) := Fintype.ofFinite _
  rw [← Fintype.sum_fiberwise (Quotient.mk s) w]
  refine Finset.dvd_sum fun c _ => ?_
  induction c using Quotient.inductionOn with
  | _ x =>
    -- the sum over the class of `x` is (size of the class) * `w x`
    have hconst : ∀ y : {y : X // Quotient.mk s y = Quotient.mk s x}, w y.1 = w x :=
      fun y => hw x y.1 (Quotient.exact y.2)
    rw [Finset.sum_congr rfl (fun y _ => hconst y), Finset.sum_const, Finset.card_univ,
      nsmul_eq_mul, ← Nat.card_eq_fintype_card, Nat.card_congr (classEquivRel s x)]
    exact Dvd.dvd.mul_right (Int.natCast_dvd_natCast.mpr (h x)) _

namespace PTree

variable {p : ℕ}

/-- The sum of a rotation-invariant weight over a rotation-closed family is divisible by `p ^ e`
when every member has `d ≥ e`. -/
theorem pow_dvd_sum_weight_of_closed [Fact p.Prime] (P : PTree p → Prop)
    (hP : ∀ S T, Rot S T → P T → P S) [Finite {T : PTree p // P T}] (e : ℕ)
    (he : ∀ T, P T → e ≤ T.d) (w : PTree p → ℤ) (hw : ∀ S T, Rot S T → w S = w T) :
    (p : ℤ) ^ e ∣ ∑ᶠ T : {T : PTree p // P T}, w T.1 := by
  have : Fintype {T : PTree p // P T} := Fintype.ofFinite _
  rw [finsum_eq_sum_of_fintype]
  have h := dvd_sum_of_classes (rotSetoidOn P) (p ^ e) (fun T => w T.1)
    (fun x y hyx => hw y.1 x.1 hyx) (fun x => by
      rw [Nat.card_congr (classOnEquiv P hP x), card_class]
      exact pow_dvd_pow p (he x.1 x.2))
  rw [Nat.cast_pow] at h
  exact h

/-! ### The weight by the depths of the nodes -/

/-- The weight of a tree by the depths of its nodes: `∏_i b_i ^ (number of nodes at depth i)`. -/
noncomputable def depthWeight (b : ℕ → ℤ) (T : PTree p) : ℤ :=
  ∏ i ∈ Finset.range (T.nodes + 1), b i ^ prof T i

/-- A tree has no node at a depth that is at least its number of nodes: the range
`i < T.nodes + 1` in `depthWeight` covers every depth at which `T` has a node. -/
theorem prof_eq_zero_of_nodes_le : ∀ (T : PTree p) (i : ℕ), T.nodes ≤ i → prof T i = 0 := by
  intro T
  induction T with
  | leaf =>
    intro i _
    exact prof_leaf i
  | node f ih =>
    intro i hi
    rw [nodes_node'] at hi
    obtain ⟨i', rfl⟩ : ∃ i', i = i' + 1 := ⟨i - 1, by omega⟩
    rw [prof_node_succ]
    refine Finset.sum_eq_zero (fun j _ => ih j i' ?_)
    have h := Finset.single_le_sum (f := fun j => (f j).nodes) (fun _ _ => Nat.zero_le _)
      (Finset.mem_univ j)
    beta_reduce at h
    omega

/-- The weight of a leaf is `1` (the empty product). -/
theorem depthWeight_leaf (b : ℕ → ℤ) : depthWeight b (leaf : PTree p) = 1 := by
  simp [depthWeight]

/-- The weight of a node: `b 0` for the root, times the weights of the subtrees, in which every
depth is one more. So `depthWeight b T` is the product of `b (depth of v)` over the nodes `v`. -/
theorem depthWeight_node (b : ℕ → ℤ) (f : Fin p → PTree p) :
    depthWeight b (node f) = b 0 * ∏ j, depthWeight (fun i => b (i + 1)) (f j) := by
  -- the product for a subtree may be taken over the larger range of the whole tree
  have hsub : ∀ j, ∏ i ∈ Finset.range ((f j).nodes + 1), b (i + 1) ^ prof (f j) i =
      ∏ i ∈ Finset.range (node f).nodes, b (i + 1) ^ prof (f j) i := by
    intro j
    refine Finset.prod_subset ?_ ?_
    · intro i hi
      rw [Finset.mem_range] at hi ⊢
      have h := Finset.single_le_sum (f := fun j => (f j).nodes) (fun _ _ => Nat.zero_le _)
        (Finset.mem_univ j)
      beta_reduce at h
      rw [nodes_node']
      omega
    · intro i _ hi
      rw [Finset.mem_range] at hi
      rw [prof_eq_zero_of_nodes_le (f j) i (by omega), pow_zero]
  show ∏ i ∈ Finset.range ((node f).nodes + 1), b i ^ prof (node f) i =
    b 0 * ∏ j, ∏ i ∈ Finset.range ((f j).nodes + 1), b (i + 1) ^ prof (f j) i
  rw [Finset.prod_range_succ', prof_node_zero, pow_one, mul_comm]
  congr 1
  rw [Finset.prod_congr rfl (fun j _ => hsub j), Finset.prod_comm]
  refine Finset.prod_congr rfl (fun i _ => ?_)
  rw [prof_node_succ, Finset.prod_pow_eq_pow_sum]

/-! ### Depth-weighted Fuss–Catalan numbers for `q = p ^ k` -/

/-- **Blocked form, by nodes.** For `q = p ^ k`, `k ≥ 1`: `expand` is a bijection from the
`q`-ary trees with `n` nodes onto the `p`-ary trees with `(q - 1) * n + 1` leaves all at depths
divisible by `k`. -/
noncomputable def expandNodesEquiv (hp : 2 ≤ p) {k : ℕ} (hk : 0 < k) (n : ℕ) :
    {T : PTree (p ^ k) // T.nodes = n} ≃
      {U : PTree p // U.leaves = (p ^ k - 1) * n + 1 ∧ BlockedAt k 0 U} :=
  Equiv.ofBijective
    (fun T => ⟨expand k T.1, by
        rw [leaves_expand, leaves_eq_nodes (Nat.one_le_pow _ _ (by omega)) T.1, T.2],
      blockedAt_expand k T.1 0 (dvd_zero k)⟩)
    ⟨fun T1 T2 h => Subtype.ext (expand_injective hk _ _ (congrArg Subtype.val h)), by
      rintro ⟨U, hl, hb⟩
      obtain ⟨T', hT'⟩ := exists_expand hk _ U rfl hb
      have hq2 : 2 ≤ p ^ k :=
        calc 2 ≤ p := hp
          _ = p ^ 1 := (pow_one p).symm
          _ ≤ p ^ k := Nat.pow_le_pow_right (by omega) hk
      have hn : T'.nodes = n := by
        have h1 : T'.leaves = (p ^ k - 1) * n + 1 := by
          rw [← leaves_expand k T', hT']
          exact hl
        rw [leaves_eq_nodes (by omega) T'] at h1
        have h2 : (p ^ k - 1) * T'.nodes = (p ^ k - 1) * n := by omega
        exact Nat.eq_of_mul_eq_mul_left (by omega) h2
      exact ⟨⟨T', hn⟩, Subtype.ext hT'⟩⟩

theorem expandNodesEquiv_apply_val (hp : 2 ≤ p) {k : ℕ} (hk : 0 < k) (n : ℕ)
    (T : {T : PTree (p ^ k) // T.nodes = n}) :
    (expandNodesEquiv hp hk n T).1 = expand k T.1 := rfl

/-- The `p ^ k`-ary trees with `n` nodes are finitely many (`p` prime, `k ≥ 1`): the sum in
`pow_dvd_sum_depthWeight` is a finite sum. -/
theorem finite_nodes_pow (p : ℕ) [hp : Fact p.Prime] (k : ℕ) (hk : 0 < k) (n : ℕ) :
    Finite {T : PTree (p ^ k) // T.nodes = n} :=
  have : Finite {U : PTree p // U.leaves = (p ^ k - 1) * n + 1 ∧ BlockedAt k 0 U} :=
    finite_of_leaves _ _
  Finite.of_equiv _ (expandNodesEquiv hp.out.two_le hk n).symm

/-- Depth-weighted Fuss–Catalan numbers, `q = p ^ k`: divisible by `p ^ t` for every integer
weights. -/
theorem pow_dvd_sum_depthWeight (p : ℕ) [Fact p.Prime] (k : ℕ) (hk : 0 < k) (n t : ℕ)
    (ht : (p - 1) * t + 1 = (Nat.digits p ((p ^ k - 1) * n + 1)).sum) (b : ℕ → ℤ) :
    (p : ℤ) ^ t ∣ ∑ᶠ T : {T : PTree (p ^ k) // T.nodes = n}, depthWeight b T.1 := by
  have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
  -- the corresponding family of `p`-ary trees: it is finite and closed under rotation, each of
  -- its trees has at least `t` asymmetric nodes, and rotations do not change the weight
  have hfin : Finite {U : PTree p // U.leaves = (p ^ k - 1) * n + 1 ∧ BlockedAt k 0 U} :=
    finite_of_leaves _ _
  have hdiv : (p : ℤ) ^ t ∣
      ∑ᶠ U : {U : PTree p // U.leaves = (p ^ k - 1) * n + 1 ∧ BlockedAt k 0 U},
        ∏ i ∈ Finset.range (n + 1), b i ^ prof U.1 (k * i) := by
    refine pow_dvd_sum_weight_of_closed
      (fun U : PTree p => U.leaves = (p ^ k - 1) * n + 1 ∧ BlockedAt k 0 U) ?_ t ?_
      (fun U => ∏ i ∈ Finset.range (n + 1), b i ^ prof U (k * i)) ?_
    · rintro S T h ⟨hl, hb⟩
      exact ⟨h.leaves_eq.trans hl, (h.blockedAt 0).mpr hb⟩
    · rintro T ⟨hl, -⟩
      exact t_le_d hp2 T t (by rw [hl]; exact ht)
    · intro S T h
      show ∏ i ∈ Finset.range (n + 1), b i ^ prof S (k * i) =
        ∏ i ∈ Finset.range (n + 1), b i ^ prof T (k * i)
      rw [h.prof_eq]
  -- the blocked form carries the sum over the `q`-ary trees to the sum over this family
  have hsum : ∑ᶠ T : {T : PTree (p ^ k) // T.nodes = n}, depthWeight b T.1 =
      ∑ᶠ U : {U : PTree p // U.leaves = (p ^ k - 1) * n + 1 ∧ BlockedAt k 0 U},
        ∏ i ∈ Finset.range (n + 1), b i ^ prof U.1 (k * i) := by
    rw [← finsum_comp_equiv (expandNodesEquiv hp2 hk n)]
    refine finsum_congr (fun T => ?_)
    show ∏ i ∈ Finset.range (T.1.nodes + 1), b i ^ prof T.1 i =
      ∏ i ∈ Finset.range (n + 1), b i ^ prof (expand k T.1) (k * i)
    rw [T.2]
    exact Finset.prod_congr rfl (fun i _ => by rw [prof_expand hk])
  rw [hsum]
  exact hdiv

/-- With all weights equal to `1`, the depth-weighted sum is the number of trees: the theorem
`pow_dvd_sum_depthWeight` contains the divisibility `p ^ t ∣ #{q-ary trees with n nodes}`. -/
theorem finsum_depthWeight_one (p : ℕ) [hp : Fact p.Prime] (k : ℕ) (hk : 0 < k) (n : ℕ) :
    ∑ᶠ T : {T : PTree (p ^ k) // T.nodes = n}, depthWeight (fun _ => 1) T.1 =
      (Nat.card {T : PTree (p ^ k) // T.nodes = n} : ℤ) := by
  have := finite_nodes_pow p k hk n
  have : Fintype {T : PTree (p ^ k) // T.nodes = n} := Fintype.ofFinite _
  rw [finsum_eq_sum_of_fintype, Nat.card_eq_fintype_card]
  simp [depthWeight]

end PTree

end MMM

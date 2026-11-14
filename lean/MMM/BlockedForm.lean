/-
Written by Claude Fable 5.2 (AI, a forked instance of the orchestrator), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **Lemma "Blocked form" of the paper** (`q = p ^ k`, `k ≥ 1`).
  The `q`-ary trees with `m` leaves correspond one to one to the `p`-ary trees with `m` leaves
  all of whose leaves are at a depth divisible by `k`:

      #{T : PTree (p ^ k) | leaves T = m} = #{T : PTree p | leaves T = m ∧ BlockedAt k 0 T}.

Construction: a `q`-ary node is replaced by a complete `p`-ary tree of height `k`, whose `p ^ k`
leaves take the `q` children (`build`, `expand`). `expand` keeps the number of leaves, lands in
the blocked trees, is injective, and every blocked tree is an `expand` (a blocked tree that is
not a leaf has no leaf at the depths `1, ..., k - 1`, so its top `k` levels are complete).

No factorial and no valuation occurs in this file.
-/
import MMM.Blocked
import Mathlib.Logic.Equiv.Fin.Basic
import Mathlib.Data.Fin.SuccPred
import Mathlib.Data.Fintype.BigOperators

namespace MMM

namespace PTree

variable {p : ℕ}

/-! ### Indexing the `p ^ (j + 1)` positions by a first step and a position below it -/

/-- A position at depth `j + 1` is a first step `i` and a position `x` at depth `j` below it. -/
def idx (p j : ℕ) : Fin p × Fin (p ^ j) ≃ Fin (p ^ (j + 1)) :=
  finProdFinEquiv.trans (finCongr (pow_succ' p j).symm)

/-- There is only one position at depth `0`. -/
theorem fin_pow_zero (x : Fin (p ^ 0)) : x = ⟨0, by simp⟩ := by
  apply Fin.ext
  have h : (x : ℕ) < 1 := lt_of_lt_of_eq x.2 (pow_zero p)
  show (x : ℕ) = 0
  omega

/-! ### `build`: a complete tree of height `j` with given trees at its leaves -/

/-- The complete `p`-ary tree of height `j` with the tree `g x` hung at its leaf number `x`. -/
def build : (j : ℕ) → (Fin (p ^ j) → PTree p) → PTree p
  | 0, g => g ⟨0, by simp⟩
  | j + 1, g => node fun i => build j fun x => g (idx p j (i, x))

theorem build_zero (g : Fin (p ^ 0) → PTree p) : build 0 g = g ⟨0, by simp⟩ := rfl

theorem build_succ (j : ℕ) (g : Fin (p ^ (j + 1)) → PTree p) :
    build (j + 1) g = node fun i => build j fun x => g (idx p j (i, x)) := rfl

theorem build_succ_ne_leaf (j : ℕ) (g : Fin (p ^ (j + 1)) → PTree p) : build (j + 1) g ≠ leaf := by
  rw [build_succ]
  intro h
  cases h

theorem nodes_node' (f : Fin p → PTree p) : (node f).nodes = 1 + ∑ i, (f i).nodes := rfl

/-- The leaves of `build j g` are the leaves of the trees `g x`. -/
theorem leaves_build : ∀ (j : ℕ) (g : Fin (p ^ j) → PTree p),
    (build j g).leaves = ∑ x, (g x).leaves := by
  intro j
  induction j with
  | zero =>
    intro g
    rw [build_zero]
    symm
    rw [Fintype.sum_eq_single (⟨0, by simp⟩ : Fin (p ^ 0))]
    intro x hx
    exact absurd (fin_pow_zero x) hx
  | succ j ih =>
    intro g
    rw [build_succ, leaves_node, ← Equiv.sum_comp (idx p j) (fun y => (g y).leaves),
      Fintype.sum_prod_type]
    exact Finset.sum_congr rfl (fun i _ => ih _)

/-- `build j g` is blocked at depth `δ` exactly when every `g x` is blocked at depth `δ + j`. -/
theorem blockedAt_build (k : ℕ) : ∀ (j δ : ℕ) (g : Fin (p ^ j) → PTree p),
    BlockedAt k δ (build j g) ↔ ∀ x, BlockedAt k (δ + j) (g x) := by
  intro j
  induction j with
  | zero =>
    intro δ g
    rw [build_zero]
    constructor
    · intro h x
      rw [fin_pow_zero x]
      exact h
    · intro h
      exact h _
  | succ j ih =>
    intro δ g
    rw [build_succ]
    show (∀ i, BlockedAt k (δ + 1) (build j fun x => g (idx p j (i, x)))) ↔ _
    have e : δ + 1 + j = δ + (j + 1) := by omega
    constructor
    · intro h y
      have h1 := (ih (δ + 1) _).mp (h ((idx p j).symm y).1) ((idx p j).symm y).2
      simp only [Prod.mk.eta, Equiv.apply_symm_apply] at h1
      rw [e] at h1
      exact h1
    · intro h i
      rw [ih]
      intro x
      rw [e]
      exact h _

/-- `build j` determines the trees at the leaves. -/
theorem build_injective : ∀ (j : ℕ) (g1 g2 : Fin (p ^ j) → PTree p),
    build j g1 = build j g2 → g1 = g2 := by
  intro j
  induction j with
  | zero =>
    intro g1 g2 h
    rw [build_zero, build_zero] at h
    funext x
    rw [fin_pow_zero x]
    exact h
  | succ j ih =>
    intro g1 g2 h
    rw [build_succ, build_succ] at h
    have h1 := congrFun (node.inj h)
    funext y
    have h2 := congrFun (ih _ _ (h1 ((idx p j).symm y).1)) ((idx p j).symm y).2
    simpa using h2

/-- A tree at a leaf of `build j g` has at most as many nodes as the whole tree. -/
theorem nodes_le_build : ∀ (j : ℕ) (g : Fin (p ^ j) → PTree p) (y : Fin (p ^ j)),
    (g y).nodes ≤ (build j g).nodes := by
  intro j
  induction j with
  | zero =>
    intro g y
    rw [build_zero, fin_pow_zero y]
  | succ j ih =>
    intro g y
    rw [build_succ, nodes_node']
    have h1 := ih (fun x => g (idx p j (((idx p j).symm y).1, x))) ((idx p j).symm y).2
    simp only [Prod.mk.eta, Equiv.apply_symm_apply] at h1
    have h2 := Finset.single_le_sum
      (f := fun i => (build j fun x => g (idx p j (i, x))).nodes) (fun _ _ => Nat.zero_le _)
      (Finset.mem_univ ((idx p j).symm y).1)
    beta_reduce at h2
    omega

/-- ... and strictly fewer when the height is positive. -/
theorem nodes_lt_build_succ (j : ℕ) (g : Fin (p ^ (j + 1)) → PTree p) (y : Fin (p ^ (j + 1))) :
    (g y).nodes < (build (j + 1) g).nodes := by
  rw [build_succ, nodes_node']
  have h1 := nodes_le_build j (fun x => g (idx p j (((idx p j).symm y).1, x)))
    ((idx p j).symm y).2
  simp only [Prod.mk.eta, Equiv.apply_symm_apply] at h1
  have h2 := Finset.single_le_sum
    (f := fun i => (build j fun x => g (idx p j (i, x))).nodes) (fun _ _ => Nat.zero_le _)
    (Finset.mem_univ ((idx p j).symm y).1)
  beta_reduce at h2
  omega

/-- The depth condition only depends on the depth modulo `k`. -/
theorem blockedAt_add (k : ℕ) : ∀ (T : PTree p) (δ : ℕ),
    BlockedAt k (δ + k) T ↔ BlockedAt k δ T := by
  intro T
  induction T with
  | leaf =>
    intro δ
    exact Nat.dvd_add_left (Nat.dvd_refl k)
  | node f ih =>
    intro δ
    show (∀ i, BlockedAt k (δ + k + 1) (f i)) ↔ (∀ i, BlockedAt k (δ + 1) (f i))
    have e : δ + k + 1 = δ + 1 + k := by omega
    rw [e]
    exact forall_congr' (fun i => ih i (δ + 1))

/-- A tree that is blocked at depth `δ`, when none of the depths `δ, ..., δ + r - 1` is
divisible by `k`, has no leaf in its top `r` levels: it is a `build r`. -/
theorem exists_build (k : ℕ) : ∀ (r δ : ℕ) (T : PTree p), BlockedAt k δ T →
    (∀ s, s < r → ¬ k ∣ δ + s) → ∃ g : Fin (p ^ r) → PTree p, T = build r g := by
  intro r
  induction r with
  | zero =>
    intro δ T _ _
    exact ⟨fun _ => T, rfl⟩
  | succ r ih =>
    intro δ T hT hno
    cases T with
    | leaf =>
      have hT' : k ∣ δ := hT
      exact absurd hT' (by simpa using hno 0 (Nat.succ_pos r))
    | node f =>
      have hT' : ∀ i, BlockedAt k (δ + 1) (f i) := hT
      have hch : ∀ i, ∃ g : Fin (p ^ r) → PTree p, f i = build r g := fun i =>
        ih (δ + 1) (f i) (hT' i) (fun s hs => by
          have h1 := hno (s + 1) (by omega)
          have e : δ + 1 + s = δ + (s + 1) := by omega
          rw [e]
          exact h1)
      choose gi hgi using hch
      refine ⟨fun y => gi ((idx p r).symm y).1 ((idx p r).symm y).2, ?_⟩
      rw [build_succ]
      congr 1
      funext i
      rw [hgi i]
      congr 1
      funext x
      simp

/-! ### `expand`: from `q`-ary trees to blocked `p`-ary trees -/

/-- Replace every `p ^ k`-ary node by a complete `p`-ary tree of height `k`. -/
def expand (k : ℕ) : PTree (p ^ k) → PTree p
  | leaf => leaf
  | node f => build k fun x => expand k (f x)

theorem expand_leaf (k : ℕ) : expand k (leaf : PTree (p ^ k)) = leaf := rfl

theorem expand_node (k : ℕ) (f : Fin (p ^ k) → PTree (p ^ k)) :
    expand k (node f) = build k fun x => expand k (f x) := rfl

/-- `expand` keeps the number of leaves. -/
theorem leaves_expand (k : ℕ) (T : PTree (p ^ k)) : (expand k T).leaves = T.leaves := by
  induction T with
  | leaf => rfl
  | node f ih =>
    rw [expand_node, leaves_build, leaves_node]
    exact Finset.sum_congr rfl (fun x _ => ih x)

/-- An expanded tree has all its leaves at depths divisible by `k`. -/
theorem blockedAt_expand (k : ℕ) (T : PTree (p ^ k)) :
    ∀ δ, k ∣ δ → BlockedAt k δ (expand k T) := by
  induction T with
  | leaf =>
    intro δ h
    exact h
  | node f ih =>
    intro δ h
    rw [expand_node, blockedAt_build]
    intro x
    exact ih x (δ + k) (dvd_add h (dvd_refl k))

/-- Different `q`-ary trees expand to different trees (`k ≥ 1`). -/
theorem expand_injective {k : ℕ} (hk : 0 < k) : ∀ T1 T2 : PTree (p ^ k),
    expand k T1 = expand k T2 → T1 = T2 := by
  obtain ⟨k', rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
  intro T1
  induction T1 with
  | leaf =>
    intro T2 h
    cases T2 with
    | leaf => rfl
    | node g =>
      rw [expand_leaf, expand_node] at h
      exact absurd h.symm (build_succ_ne_leaf _ _)
  | node f ih =>
    intro T2 h
    cases T2 with
    | leaf =>
      rw [expand_leaf, expand_node] at h
      exact absurd h (build_succ_ne_leaf _ _)
    | node g =>
      rw [expand_node, expand_node] at h
      have h1 := congrFun (build_injective _ _ _ h)
      congr 1
      funext x
      exact ih x (g x) (h1 x)

/-- Every blocked tree is the expansion of a `q`-ary tree (`k ≥ 1`). -/
theorem exists_expand {k : ℕ} (hk : 0 < k) : ∀ (n : ℕ) (T : PTree p), T.nodes = n →
    BlockedAt k 0 T → ∃ T' : PTree (p ^ k), expand k T' = T := by
  obtain ⟨k', rfl⟩ : ∃ k', k = k' + 1 := ⟨k - 1, by omega⟩
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro T hn hT
    cases T with
    | leaf => exact ⟨leaf, rfl⟩
    | node f =>
      -- the top `k` levels are complete
      have hT' : ∀ i, BlockedAt (k' + 1) 1 (f i) := hT
      have hch : ∀ i, ∃ g : Fin (p ^ k') → PTree p, f i = build k' g := fun i =>
        exists_build (k' + 1) k' 1 (f i) (hT' i) (fun s hs hdvd => by
          have h1 := Nat.le_of_dvd (by omega) hdvd
          omega)
      choose gi hgi using hch
      let g : Fin (p ^ (k' + 1)) → PTree p :=
        fun y => gi ((idx p k').symm y).1 ((idx p k').symm y).2
      have hfg : node f = build (k' + 1) g := by
        rw [build_succ]
        congr 1
        funext i
        rw [hgi i]
        congr 1
        funext x
        simp [g]
      -- the trees below are blocked again, and smaller
      have hgb : ∀ y, BlockedAt (k' + 1) 0 (g y) := by
        rw [hfg] at hT
        have h1 := (blockedAt_build (k' + 1) (k' + 1) 0 g).mp hT
        intro y
        exact (blockedAt_add (k' + 1) (g y) 0).mp (h1 y)
      have hlt : ∀ y, (g y).nodes < n := fun y => by
        rw [← hn, hfg]
        exact nodes_lt_build_succ k' g y
      choose T' hT'' using fun y => ih (g y).nodes (hlt y) (g y) rfl (hgb y)
      refine ⟨node T', ?_⟩
      rw [expand_node, hfg]
      congr 1
      funext y
      exact hT'' y

/-- **Blocked form.** For `q = p ^ k` with `k ≥ 1`, there are as many `q`-ary trees with `m`
leaves as `p`-ary trees with `m` leaves all at depths divisible by `k`. -/
theorem card_pow_ary_eq_card_blocked {p : ℕ} (hp : 2 ≤ p) (k : ℕ) (hk : 0 < k) (m : ℕ) :
    Nat.card {T : PTree (p ^ k) // T.leaves = m} =
      Nat.card {T : PTree p // T.leaves = m ∧ BlockedAt k 0 T} := by
  have _ := hp
  refine Nat.card_congr (Equiv.ofBijective
    (fun T => ⟨expand k T.1, by rw [leaves_expand]; exact T.2,
      blockedAt_expand k T.1 0 (dvd_zero k)⟩) ⟨?_, ?_⟩)
  · intro T1 T2 h
    exact Subtype.ext (expand_injective hk _ _ (congrArg Subtype.val h))
  · rintro ⟨T, hl, hb⟩
    obtain ⟨T', hT'⟩ := exists_expand hk _ T rfl hb
    exact ⟨⟨T', by rw [← leaves_expand k T', hT']; exact hl⟩, Subtype.ext hT'⟩

end PTree

end MMM

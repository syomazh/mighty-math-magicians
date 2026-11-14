/-
Written by Claude Fable 5.2 (AI, a forked instance of the orchestrator), 2026-11-14.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **Step 4 of the main proof for prime powers `q = p ^ k`: the cherry collapse with the depth
  condition.**
  Each label `x` has a class `κ x`; a leaf labelled `x` at depth `δ` is allowed when
  `k ∣ δ + κ x` (`BlockedL`, see `MMM/LBlocked.lean`). Let `S` be a set of `(p - 1) * t + 1`
  labels with `∑_{x ∈ S} p ^ κ x ≡ 1 (mod p ^ k - 1)`. Then the number of `p`-ary plane trees
  whose leaves carry the labels of `S`, each once, and satisfy the depth condition, is divisible
  by `p ^ t` and not by `p ^ (t + 1)` (`labelled_valuation_blocked`).

Proof, by induction on `t`, along the lines of `MMM/Cherry.lean`.

* `t = 0`: one label `a`, and the congruence forces `k ∣ κ a`, so the single leaf is allowed.
* `t ≥ 1`: the congruence forces some class modulo `k` to contain at least `p` labels
  (`exists_class`: otherwise the weight `∑ p ^ (κ x mod k)` would lie in `[2, p ^ k - 1]` and be
  congruent to 1). Take `p` labels `C` of one class and one of them, `c0`.
  - Trees in which `C` is a cherry: pruning the cherry to the leaf `c0`, whose class is raised
    by one, is a bijection onto (orderings of `C`) × (allowed trees on `(S \ C) ∪ {c0}`), so
    there are `p !` times as many (`card_cherry_blocked`). Raising the class by one is exactly
    what keeps the depth condition, and it keeps the congruence because `p * p ^ c = p ^ (c+1)`.
  - The other trees: the depth condition is invariant under rotation and under a permutation of
    the labels inside one class, so the argument of `Cherry.lean` applies to them unchanged:
    their number is divisible by `p ^ (t + 1)` (`pow_succ_dvd_card_noCherryB`).

No factorial valuation is used; the only fact about a factorial is that `p ∤ (p - 1)!`.

Difference from the paper: as in `Cherry.lean`, all `p !` orderings of the cherry are put on one
side, so Lean gets the exact power of `p` but not the residue. The paper records the classes of
the labels as a vector `a` indexed by `Z/k` and proves `T(a) ≡ -T(a - p e_c + e_{c+1})`; here
the classes are a function `κ` on the labels, the collapse changes `κ` at one label, and the
vector `a` enters only through the congruence `∑ p ^ κ x ≡ 1 (mod p ^ k - 1)`.
-/
import MMM.Cherry
import MMM.LBlocked
import Mathlib.Algebra.BigOperators.ModEq
import Mathlib.Data.Nat.ModEq

namespace MMM

/-! ### Powers of `p` modulo `p ^ k - 1` -/

namespace CherryB

variable {p : ℕ}

theorem pred_mul_add (hp2 : 2 ≤ p) (q : ℕ) : (p - 1) * q + q = p * q := by
  have h := Nat.add_one_mul (p - 1) q
  rw [Nat.sub_add_cancel (by omega : 1 ≤ p)] at h
  exact h.symm

/-- `(p - 1) (1 + p + ... + p ^ (k - 1)) + 1 = p ^ k`. -/
theorem geom_succ (hp2 : 2 ≤ p) (k : ℕ) :
    (∑ c ∈ Finset.range k, (p - 1) * p ^ c) + 1 = p ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, pow_succ']
    have h := pred_mul_add hp2 (p ^ k)
    omega

theorem pow_modEq_one (hp2 : 2 ≤ p) (k : ℕ) : p ^ k ≡ 1 [MOD p ^ k - 1] := by
  have h1 : 1 ≤ p ^ k := Nat.one_le_pow k p (by omega)
  exact ((Nat.modEq_iff_dvd' h1).mpr (dvd_refl _)).symm

/-- Modulo `p ^ k - 1`, a power of `p` depends only on the exponent modulo `k`. -/
theorem pow_modEq_pow_mod (hp2 : 2 ≤ p) (k j : ℕ) : p ^ j ≡ p ^ (j % k) [MOD p ^ k - 1] := by
  have h1 : p ^ j = (p ^ k) ^ (j / k) * p ^ (j % k) := by
    rw [← pow_mul, ← pow_add, Nat.div_add_mod]
  have h2 : (p ^ k) ^ (j / k) ≡ 1 [MOD p ^ k - 1] := by
    have h := (pow_modEq_one hp2 k).pow (j / k)
    rwa [one_pow] at h
  have h3 := h2.mul_right (p ^ (j % k))
  rw [one_mul, ← h1] at h3
  exact h3

theorem pow_modEq_of_mod_eq (hp2 : 2 ≤ p) {k a b : ℕ} (h : a % k = b % k) :
    p ^ a ≡ p ^ b [MOD p ^ k - 1] := by
  have h1 := pow_modEq_pow_mod hp2 k a
  rw [h] at h1
  exact h1.trans (pow_modEq_pow_mod hp2 k b).symm

/-- If `p ^ j ≡ 1 (mod p ^ k - 1)` then `k` divides `j`. -/
theorem dvd_of_pow_modEq_one (hp2 : 2 ≤ p) {k : ℕ} (hk : 0 < k) {j : ℕ}
    (h : p ^ j ≡ 1 [MOD p ^ k - 1]) : k ∣ j := by
  apply Nat.dvd_of_mod_eq_zero
  by_contra hr
  have hrk : j % k < k := Nat.mod_lt _ hk
  have h1 : p ^ (j % k) ≡ 1 [MOD p ^ k - 1] := (pow_modEq_pow_mod hp2 k j).symm.trans h
  have h2 : p ≤ p ^ (j % k) := Nat.le_self_pow hr p
  have h3 : p ^ (j % k) * p ≤ p ^ k := by
    rw [← pow_succ]
    exact Nat.pow_le_pow_right (by omega) (by omega)
  have h4 : p ^ (j % k) * 2 ≤ p ^ (j % k) * p := Nat.mul_le_mul_left _ hp2
  have h5 : p ^ (j % k) < p ^ k - 1 := by omega
  have h6 : 1 < p ^ k - 1 := by omega
  unfold Nat.ModEq at h1
  rw [Nat.mod_eq_of_lt h5, Nat.mod_eq_of_lt h6] at h1
  omega

theorem dvd_add_iff_of_mod_eq {k a b : ℕ} (h : a % k = b % k) (δ : ℕ) :
    k ∣ δ + a ↔ k ∣ δ + b :=
  (Nat.ModEq.add_left δ (show a ≡ b [MOD k] from h)).dvd_iff (dvd_refl k)

/-- **A class with at least `p` labels.** If the weights `p ^ κ x` of at least two labels add up
to 1 modulo `p ^ k - 1`, then `p` of the labels have the same class modulo `k`. -/
theorem exists_class {α : Type} [DecidableEq α] (hp2 : 2 ≤ p) {k : ℕ} (hk : 0 < k) (κ : α → ℕ)
    (S : Finset α) (hcard : 2 ≤ S.card) (hI : (∑ x ∈ S, p ^ κ x) ≡ 1 [MOD p ^ k - 1]) :
    ∃ C : Finset α, C ⊆ S ∧ C.card = p ∧ ∀ x ∈ C, ∀ y ∈ C, κ x % k = κ y % k := by
  by_contra hno
  have hsmall : ∀ c, (S.filter (fun x => κ x % k = c)).card ≤ p - 1 := by
    intro c
    by_contra hc
    have hpc : p ≤ (S.filter (fun x => κ x % k = c)).card := by omega
    obtain ⟨C, hCsub, hC⟩ := Finset.exists_subset_card_eq hpc
    refine hno ⟨C, hCsub.trans (Finset.filter_subset _ _), hC, fun x hx y hy => ?_⟩
    rw [(Finset.mem_filter.mp (hCsub hx)).2, (Finset.mem_filter.mp (hCsub hy)).2]
  -- the weight with the exponents reduced modulo `k`
  have hW1 : (∑ x ∈ S, p ^ (κ x % k)) ≡ 1 [MOD p ^ k - 1] :=
    (Nat.ModEq.sum (fun x _ => (pow_modEq_pow_mod hp2 k (κ x)).symm)).trans hI
  have hW2 : S.card ≤ ∑ x ∈ S, p ^ (κ x % k) := by
    rw [Finset.card_eq_sum_ones]
    exact Finset.sum_le_sum (fun x _ => Nat.one_le_pow _ _ (by omega))
  have hW3 : ∑ x ∈ S, p ^ (κ x % k) ≤ p ^ k - 1 := by
    have e : ∑ c ∈ Finset.range k, ∑ x ∈ S.filter (fun x => κ x % k = c), p ^ (κ x % k) =
        ∑ x ∈ S, p ^ (κ x % k) :=
      Finset.sum_fiberwise_of_maps_to (g := fun x => κ x % k)
        (fun x _ => Finset.mem_range.mpr (Nat.mod_lt _ hk)) _
    rw [← e]
    have hle : ∀ c ∈ Finset.range k,
        ∑ x ∈ S.filter (fun x => κ x % k = c), p ^ (κ x % k) ≤ (p - 1) * p ^ c := by
      intro c _
      have hin : ∑ x ∈ S.filter (fun x => κ x % k = c), p ^ (κ x % k) =
          (S.filter (fun x => κ x % k = c)).card * p ^ c :=
        Finset.sum_const_nat (fun x hx => by rw [(Finset.mem_filter.mp hx).2])
      rw [hin]
      exact Nat.mul_le_mul_right _ (hsmall c)
    have hsum := Finset.sum_le_sum hle
    have hg := geom_succ hp2 k
    omega
  have hN : 1 < p ^ k - 1 := by omega
  unfold Nat.ModEq at hW1
  rw [Nat.mod_eq_of_lt hN] at hW1
  rcases Nat.lt_or_eq_of_le hW3 with h | h
  · rw [Nat.mod_eq_of_lt h] at hW1
    omega
  · rw [h, Nat.mod_self] at hW1
    omega

end CherryB

namespace LTree

open CherryB

variable {p : ℕ} {α : Type}

/-! ### The depth condition under rotation, renaming and grafting -/

/-- Rotation equivalence preserves the depth condition. -/
theorem Rot.blockedL [NeZero p] {k : ℕ} {κ : α → ℕ} {S T : LTree p α} (h : Rot S T) :
    ∀ δ, BlockedL k κ δ S ↔ BlockedL k κ δ T := by
  induction h with
  | leaf a => intro δ; exact Iff.rfl
  | node f g r _ ih =>
    intro δ
    rw [blockedL_node, blockedL_node]
    constructor
    · intro hf i
      exact (ih i (δ + 1)).mp (hf (i + r))
    · intro hg i
      have h1 := (ih (i - r) (δ + 1)).mpr (hg (i - r))
      rwa [sub_add_cancel] at h1

/-- Renaming the labels inside their classes modulo `k` preserves the depth condition. -/
theorem blockedL_map {k : ℕ} {κ : α → ℕ} {π : α → α} (hπ : ∀ x, κ (π x) % k = κ x % k)
    (T : LTree p α) : ∀ δ, BlockedL k κ δ (T.map π) ↔ BlockedL k κ δ T := by
  induction T with
  | leaf a =>
    intro δ
    rw [map_leaf, blockedL_leaf, blockedL_leaf]
    exact dvd_add_iff_of_mod_eq (hπ a) δ
  | node f ih =>
    intro δ
    rw [map_node, blockedL_node, blockedL_node]
    exact forall_congr' (fun i => ih i (δ + 1))

variable [DecidableEq α]

/-- **Grafting and the depth condition.** If the labels `g i` of the cherry have the class of
`c0` modulo `k`, the grafted tree is allowed for `κ` exactly when the pruned tree is allowed
for the classes in which `c0` is raised by one. -/
theorem blockedL_graft [NeZero p] {k : ℕ} {κ : α → ℕ} {c0 : α} {g : Fin p → α}
    (hg : ∀ i, κ (g i) % k = κ c0 % k) (T : LTree p α) :
    ∀ δ, BlockedL k κ δ (graft c0 g T) ↔
      BlockedL k (Function.update κ c0 (κ c0 + 1)) δ T := by
  induction T with
  | leaf x =>
    intro δ
    by_cases hx : x = c0
    · rw [hx, graft_leaf_self, blockedL_node, blockedL_leaf, Function.update_self]
      have e : δ + (κ c0 + 1) = δ + 1 + κ c0 := by omega
      rw [e]
      constructor
      · intro h
        exact (dvd_add_iff_of_mod_eq (hg 0) (δ + 1)).mp (h 0)
      · intro h i
        exact (dvd_add_iff_of_mod_eq (hg i) (δ + 1)).mpr h
    · rw [graft_leaf_of_ne hx, blockedL_leaf, blockedL_leaf, Function.update_of_ne hx]
  | node f ih =>
    intro δ
    rw [graft_node, blockedL_node, blockedL_node]
    exact forall_congr' (fun i => ih i (δ + 1))

/-- A permutation that fixes everything outside a set `C` of one class keeps all classes. -/
theorem class_perm {k : ℕ} {κ : α → ℕ} {C : Finset α} {π : Equiv.Perm α}
    (hπ : ∀ x, x ∉ C → π x = x) (hcl : ∀ x ∈ C, ∀ y ∈ C, κ x % k = κ y % k) (x : α) :
    κ (π x) % k = κ x % k := by
  by_cases hx : x ∈ C
  · exact hcl _ (perm_mem_of_fix hπ hx) _ hx
  · rw [hπ x hx]

/-! ### Counting -/

/-- The labelled trees on `S` that satisfy the depth condition. -/
abbrev XB (p k : ℕ) (κ : α → ℕ) (S : Finset α) : Type :=
  {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0}

/-- **The allowed trees with the cherry.** There are `p !` times as many of them as there are
allowed trees on `(S \ C) ∪ {c0}` with the class of `c0` raised by one. -/
theorem card_cherry_blocked [NeZero p] {k : ℕ} {κ : α → ℕ} {S C : Finset α} (hCS : C ⊆ S)
    (hC : C.card = p) {c0 : α} (hc0 : c0 ∈ C) (hcl : ∀ x ∈ C, ∀ y ∈ C, κ x % k = κ y % k) :
    Nat.card {x : XB p k κ S // CherryOn C x.1} =
      p.factorial *
        Nat.card (XB p k (Function.update κ c0 (κ c0 + 1)) (insert c0 (S \ C))) := by
  rw [← card_orderings hC, ← Nat.card_prod]
  symm
  have hmem : ∀ T' : XB p k (Function.update κ c0 (κ c0 + 1)) (insert c0 (S \ C)),
      ∀ x ∈ T'.1.lab, x ∈ C → x = c0 := by
    intro T' x hx hxC
    rw [T'.2.2.1] at hx
    rcases Finset.mem_insert.mp hx with h | h
    · exact h
    · exact absurd hxC (Finset.mem_sdiff.mp h).2
  have hc0' : ∀ T' : XB p k (Function.update κ c0 (κ c0 + 1)) (insert c0 (S \ C)),
      c0 ∈ T'.1.lab := by
    intro T'
    rw [T'.2.2.1]
    exact Finset.mem_insert_self _ _
  have hgcl : ∀ g : {g : Fin p → α // Function.Injective g ∧ Finset.univ.image g = C},
      ∀ i, κ (g.1 i) % k = κ c0 % k := by
    intro g i
    have h0 : g.1 i ∈ Finset.univ.image g.1 := Finset.mem_image_of_mem _ (Finset.mem_univ i)
    rw [g.2.2] at h0
    exact hcl _ h0 _ hc0
  let Φ : {g : Fin p → α // Function.Injective g ∧ Finset.univ.image g = C} ×
      XB p k (Function.update κ c0 (κ c0 + 1)) (insert c0 (S \ C)) →
      {x : XB p k κ S // CherryOn C x.1} :=
    fun x => ⟨⟨graft c0 x.1.1 x.2.1, good_graft x.1.2.1 x.1.2.2 x.2.2.1 (hmem x.2),
      lab_graft_eq x.1.2.2 hCS hc0 x.2.2.2.1,
      (blockedL_graft (hgcl x.1) x.2.1 0).mpr x.2.2.2.2⟩, cherryOn_graft x.1.2.2 (hc0' x.2)⟩
  refine Nat.card_eq_of_bijective Φ ⟨?_, ?_⟩
  · rintro ⟨g, T'⟩ ⟨g', T''⟩ h
    have h1 : graft c0 g.1 T'.1 = graft c0 g'.1 T''.1 :=
      congrArg (fun y => y.1.1) h
    have hex : ∀ g : {g : Fin p → α // Function.Injective g ∧ Finset.univ.image g = C},
        ∃ i, g.1 i = c0 := by
      intro g
      have h0 : c0 ∈ Finset.univ.image g.1 := by
        rw [g.2.2]
        exact hc0
      obtain ⟨i, -, hi⟩ := Finset.mem_image.mp h0
      exact ⟨i, hi⟩
    obtain ⟨h2, h3⟩ := graft_inj (hex g) (hex g') h1
    exact Prod.ext (Subtype.ext (h3 (hc0' T'))) (Subtype.ext h2)
  · rintro ⟨⟨T, hT, hl, hb⟩, hch⟩
    obtain ⟨g, hinj, himg, T', hT', hl', hgr⟩ := exists_graft hc0 hT hch
    have hb' : BlockedL k (Function.update κ c0 (κ c0 + 1)) 0 T' := by
      refine (blockedL_graft (hgcl ⟨g, hinj, himg⟩) T' 0).mp ?_
      rw [hgr]
      exact hb
    refine ⟨(⟨g, hinj, himg⟩, ⟨T', hT', by rw [hl', hl], hb'⟩), ?_⟩
    apply Subtype.ext
    apply Subtype.ext
    exact hgr

/-- The allowed trees with label set `S` in which `C` is not a cherry. -/
abbrev NoCherryB (p k : ℕ) (κ : α → ℕ) (S C : Finset α) : Type :=
  {x : XB p k κ S // ¬ CherryOn C x.1}

/-- Renaming the labels by a permutation that fixes everything outside `C`, when all of `C` is
in one class. -/
def mapNCB {k : ℕ} {κ : α → ℕ} {S C : Finset α} (hCS : C ⊆ S) (π : Equiv.Perm α)
    (hπ : ∀ x, x ∉ C → π x = x) (hcl : ∀ x ∈ C, ∀ y ∈ C, κ x % k = κ y % k) :
    NoCherryB p k κ S C → NoCherryB p k κ S C :=
  fun z => ⟨⟨z.1.1.map π, z.1.2.1.map π.injective, by
      rw [lab_map, z.1.2.2.1]
      refine image_eq_of_mapsTo π.injective (fun x hx => ?_)
      by_cases hxC : x ∈ C
      · exact hCS (perm_mem_of_fix hπ hxC)
      · rw [hπ x hxC]
        exact hx,
      (blockedL_map (class_perm hπ hcl) z.1.1 0).mpr z.1.2.2.2⟩,
    fun h => z.2 (cherryOn_of_map π.injective
      (image_eq_of_mapsTo π.injective (fun x hx => perm_mem_of_fix hπ hx)) h)⟩

section prime

variable [hp : Fact p.Prime]

theorem finite_XB (k : ℕ) (κ : α → ℕ) (S : Finset α) : Finite (XB p k κ S) := by
  have : Finite {T : LTree p α // T.Good ∧ T.lab = S} := finite_good S
  exact Finite.of_injective
    (fun x : XB p k κ S => (⟨x.1, x.2.1, x.2.2.1⟩ : {T : LTree p α // T.Good ∧ T.lab = S}))
    (fun a b h => Subtype.ext
      (congrArg (fun y : {T : LTree p α // T.Good ∧ T.lab = S} => y.1) h))

/-- **The allowed trees without the cherry.** Their number is divisible by `p ^ (t + 1)`. -/
theorem pow_succ_dvd_card_noCherryB {k : ℕ} {κ : α → ℕ} (t : ℕ) {S C : Finset α}
    (hS : S.card = (p - 1) * t + 1) (hCS : C ⊆ S) (hC : C.card = p)
    (hcl : ∀ x ∈ C, ∀ y ∈ C, κ x % k = κ y % k) :
    p ^ (t + 1) ∣ Nat.card (NoCherryB p k κ S C) := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have : NeZero p := ⟨hp.out.ne_zero⟩
  obtain ⟨σ, hσp, hσfix, hσorb⟩ := exists_cycle hp2 hC
  have hfin : Finite (XB p k κ S) := finite_XB k κ S
  let s : Setoid (NoCherryB p k κ S C) :=
    ⟨fun a b => Rot a.1.1 b.1.1,
      ⟨fun a => Rot.refl a.1.1, fun h => h.symm, fun h1 h2 => h1.trans h2⟩⟩
  -- every rotation class has `p ^ t` trees
  have hclass : ∀ z : NoCherryB p k κ S C,
      Nat.card {y : NoCherryB p k κ S C // s.r y z} = p ^ t := by
    intro z
    let e : {y : NoCherryB p k κ S C // s.r y z} ≃ {V : LTree p α // Rot V z.1.1} :=
      { toFun := fun y => ⟨y.1.1.1, y.2⟩
        invFun := fun V =>
          ⟨⟨⟨V.1, V.2.symm.good z.1.2.1, V.2.lab_eq.trans z.1.2.2.1,
            (V.2.blockedL 0).mpr z.1.2.2.2⟩,
            fun h => z.2 ((cherryOn_rot V.2).mp h)⟩, V.2⟩
        left_inv := fun y => rfl
        right_inv := fun V => rfl }
    rw [Nat.card_congr e, card_class z.1.2.1]
    congr 1
    have h1 := z.1.2.1.card_lab hp2
    rw [z.1.2.2.1, hS] at h1
    have hpos : 0 < p - 1 := by omega
    exact Nat.eq_of_mul_eq_mul_left hpos (by omega)
  have hZ := card_eq_mul_card_quotient s (p ^ t) hclass
  -- the map induced by `σ` on the classes
  let φ : Quotient s → Quotient s :=
    Quotient.map (mapNCB hCS σ hσfix hcl) (fun a b h => Rot.map σ h)
  have hiter : ∀ (n : ℕ) (z : NoCherryB p k κ S C),
      ((mapNCB hCS σ hσfix hcl)^[n] z).1.1 = z.1.1.map (⇑(σ ^ n)) := by
    intro n
    induction n with
    | zero =>
      intro z
      exact (map_id z.1.1).symm
    | succ n ih =>
      intro z
      rw [Function.iterate_succ_apply']
      have h1 : (mapNCB hCS σ hσfix hcl ((mapNCB hCS σ hσfix hcl)^[n] z)).1.1 =
          (((mapNCB hCS σ hσfix hcl)^[n] z).1.1).map σ := rfl
      rw [h1, ih, map_map, pow_succ', Equiv.Perm.coe_mul]
  have hφk : ∀ (n : ℕ) (z : NoCherryB p k κ S C),
      φ^[n] (Quotient.mk s z) = Quotient.mk s ((mapNCB hCS σ hσfix hcl)^[n] z) := by
    intro n
    induction n with
    | zero =>
      intro z
      rfl
    | succ n ih =>
      intro z
      rw [Function.iterate_succ_apply', ih, Function.iterate_succ_apply']
      rfl
  have hφp : φ^[p ^ 1] = id := by
    funext q
    induction q using Quotient.inductionOn with
    | _ z =>
      rw [pow_one, hφk]
      apply congrArg
      apply Subtype.ext
      apply Subtype.ext
      rw [hiter, hσp]
      exact map_id _
  have hnofix : ∀ q : Quotient s, φ q ≠ q := by
    intro q
    induction q using Quotient.inductionOn with
    | _ z =>
      intro h
      have h1 : Rot (z.1.1.map σ) z.1.1 := Quotient.exact h
      have hCz : C ⊆ z.1.1.lab := by
        rw [z.1.2.2.1]
        exact hCS
      exact z.2 (cherry_of_fixed hp2 hC hσfix hσorb z.1.1 z.1.2.1 hCz h1)
  classical
  have : Fintype (Quotient s) := Fintype.ofFinite _
  have hmod := Equiv.Perm.card_fixedPoints_modEq (f := φ) (p := p) (n := 1) hφp
  have hempty : IsEmpty (Function.fixedPoints φ) := ⟨fun q => hnofix q.1 q.2⟩
  have hzero : Fintype.card (Function.fixedPoints φ) = 0 := Fintype.card_eq_zero
  rw [hzero] at hmod
  have hdvd : p ∣ Nat.card (Quotient s) := by
    rw [Nat.card_eq_fintype_card]
    exact Nat.modEq_zero_iff_dvd.mp hmod
  rw [hZ, pow_succ]
  exact Nat.mul_dvd_mul_left _ hdvd

end prime

/-- **Step 4 for `q = p ^ k`: the exact power of `p` in the number of allowed labelled trees.**
Let `S` be a set of `(p - 1) * t + 1` labels with classes `κ` such that
`∑_{x ∈ S} p ^ κ x ≡ 1 (mod p ^ k - 1)`. The number of `p`-ary plane trees whose leaves carry
the labels of `S`, each exactly once, with every leaf `x` at a depth `δ` such that
`k ∣ δ + κ x`, is divisible by `p ^ t` and not by `p ^ (t + 1)`. -/
theorem labelled_valuation_blocked {p : ℕ} [hp : Fact p.Prime] {α : Type} [DecidableEq α]
    (k : ℕ) (hk : 0 < k) (κ : α → ℕ) (t : ℕ) (S : Finset α)
    (hS : S.card = (p - 1) * t + 1)
    (hI : (∑ x ∈ S, p ^ κ x) ≡ 1 [MOD p ^ k - 1]) :
    p ^ t ∣ Nat.card {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} ∧
      ¬ p ^ (t + 1) ∣ Nat.card {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} := by
  have hp2 : 2 ≤ p := hp.out.two_le
  have : NeZero p := ⟨hp.out.ne_zero⟩
  induction t generalizing S κ with
  | zero =>
    have h1 : S.card = 1 := by simpa using hS
    obtain ⟨a, rfl⟩ := Finset.card_eq_one.mp h1
    rw [Finset.sum_singleton] at hI
    have hka : k ∣ κ a := dvd_of_pow_modEq_one hp2 hk hI
    have hcard : Nat.card {T : LTree p α // T.Good ∧ T.lab = {a} ∧ T.BlockedL k κ 0} = 1 := by
      rw [Nat.card_eq_one_iff_unique]
      refine ⟨⟨?_⟩, ⟨⟨leaf a, good_leaf a, rfl, ?_⟩⟩⟩
      · rintro ⟨T, hT, hl, _⟩ ⟨T', hT', hl', _⟩
        apply Subtype.ext
        obtain ⟨b, rfl⟩ := hT.eq_leaf_of_card_lab_eq_one hp2 (by rw [hl]; rfl)
        obtain ⟨b', rfl⟩ := hT'.eq_leaf_of_card_lab_eq_one hp2 (by rw [hl']; rfl)
        rw [lab_leaf, Finset.singleton_inj] at hl hl'
        subst hl
        subst hl'
        rfl
      · rw [blockedL_leaf, zero_add]
        exact hka
    rw [hcard]
    refine ⟨one_dvd _, ?_⟩
    rw [zero_add, pow_one, Nat.dvd_one]
    omega
  | succ t ih =>
    have hpS : p ≤ S.card := by
      rw [hS, Nat.mul_succ]
      omega
    obtain ⟨C, hCS, hC, hcl⟩ := exists_class hp2 hk κ S (by omega) hI
    obtain ⟨c0, hc0⟩ : C.Nonempty := by
      rw [← Finset.card_pos, hC]
      omega
    have hc0n : c0 ∉ S \ C := by simp [hc0]
    have hS' : (insert c0 (S \ C)).card = (p - 1) * t + 1 := by
      rw [Finset.card_insert_of_notMem hc0n, Finset.card_sdiff_of_subset hCS, hS, hC,
        Nat.mul_succ]
      omega
    -- the congruence survives the collapse: `p` labels of class `c` weigh as one of class `c + 1`
    have hsumC : (∑ x ∈ C, p ^ κ x) ≡ p ^ (κ c0 + 1) [MOD p ^ k - 1] := by
      have h1 : (∑ x ∈ C, p ^ κ x) ≡ ∑ _x ∈ C, p ^ κ c0 [MOD p ^ k - 1] :=
        Nat.ModEq.sum (fun x hx => pow_modEq_of_mod_eq hp2 (hcl x hx c0 hc0))
      have h2 : ∑ _x ∈ C, p ^ κ c0 = C.card * p ^ κ c0 :=
        Finset.sum_const_nat (fun _ _ => rfl)
      rw [h2, hC, ← pow_succ'] at h1
      exact h1
    have hI' : (∑ x ∈ insert c0 (S \ C), p ^ (Function.update κ c0 (κ c0 + 1)) x) ≡ 1
        [MOD p ^ k - 1] := by
      rw [Finset.sum_insert hc0n, Function.update_self]
      have hrest : ∑ x ∈ S \ C, p ^ (Function.update κ c0 (κ c0 + 1)) x =
          ∑ x ∈ S \ C, p ^ κ x :=
        Finset.sum_congr rfl (fun x hx => by
          have hne : x ≠ c0 := fun e => hc0n (e ▸ hx)
          rw [Function.update_of_ne hne])
      rw [hrest]
      have hsplit : ∑ x ∈ S \ C, p ^ κ x + ∑ x ∈ C, p ^ κ x = ∑ x ∈ S, p ^ κ x :=
        Finset.sum_sdiff hCS
      have h3 : p ^ (κ c0 + 1) + ∑ x ∈ S \ C, p ^ κ x ≡
          (∑ x ∈ C, p ^ κ x) + ∑ x ∈ S \ C, p ^ κ x [MOD p ^ k - 1] :=
        hsumC.symm.add_right _
      rw [add_comm (∑ x ∈ C, p ^ κ x), hsplit] at h3
      exact h3.trans hI
    obtain ⟨ih1, ih2⟩ :=
      ih (κ := Function.update κ c0 (κ c0 + 1)) (S := insert c0 (S \ C)) hS' hI'
    have hfin : Finite {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} :=
      finite_XB k κ S
    have hsplit : Nat.card {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} =
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
          CherryOn C x.1} +
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
          ¬ CherryOn C x.1} := by
      classical
      rw [← Nat.card_sum]
      exact Nat.card_congr (Equiv.sumCompl _).symm
    have hY : Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
          CherryOn C x.1} =
        p.factorial * Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C) ∧
          T.BlockedL k (Function.update κ c0 (κ c0 + 1)) 0} :=
      card_cherry_blocked hCS hC hc0 hcl
    have hZ : p ^ (t + 1 + 1) ∣
        Nat.card {x : {T : LTree p α // T.Good ∧ T.lab = S ∧ T.BlockedL k κ 0} //
          ¬ CherryOn C x.1} :=
      pow_succ_dvd_card_noCherryB (t + 1) hS hCS hC hcl
    have hfact : p.factorial = p * (p - 1).factorial :=
      (Nat.mul_factorial_pred hp.out.ne_zero).symm
    have hcop : ¬ p ∣ (p - 1).factorial := by
      rw [hp.out.dvd_factorial]
      omega
    rw [hsplit, hY, hfact]
    constructor
    · refine Nat.dvd_add ?_ (dvd_trans (pow_dvd_pow p (Nat.le_succ _)) hZ)
      rw [pow_succ', mul_assoc]
      exact Nat.mul_dvd_mul_left p (Dvd.dvd.mul_left ih1 _)
    · intro hdvd
      have h1 := Nat.dvd_sub hdvd hZ
      rw [Nat.add_sub_cancel, pow_succ', mul_assoc] at h1
      have h2 : p ^ (t + 1) ∣ (p - 1).factorial *
          Nat.card {T : LTree p α // T.Good ∧ T.lab = insert c0 (S \ C) ∧
            T.BlockedL k (Function.update κ c0 (κ c0 + 1)) 0} :=
        Nat.dvd_of_mul_dvd_mul_left hp.out.pos h1
      have h3 : Nat.Coprime (p ^ (t + 1)) (p - 1).factorial :=
        Nat.Coprime.pow_left _ (hp.out.coprime_iff_not_dvd.mpr hcop)
      exact ih2 (h3.dvd_of_dvd_mul_left h2)

end LTree

end MMM

/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; continuation of brief W041),
2026-11-14. Machine-checked by Lean when this file compiles; not human-reviewed.

  **Counting the minimal blocks (first step towards the note's Proposition `prop:count`).**

`minCount p h a` is the number of blocks of length `p^h` with `a` letters E that attain the lower
bound (`MinBlk`).

* `minCount_mono`: there is exactly one such block when `a = 0` or `a = p^h` (all letters equal).
* `minCount_succ`: for `0 < a < p^(h+1)` a minimal block of height `h + 1` is a `p`-tuple of
  minimal blocks of height `h` whose numbers of letters E, and of letters S, add up without
  carries (`minBlk_succ_iff`); the tuples are counted by their letter counts `c : Fin p → ℕ`.

The same for a word cut into top blocks (the equality case of Proposition `prop:bound`):

* `dW_eq_iff`: a word has `dW w = c` (the number of carries) exactly when every top block is
  minimal and the numbers of letters E, and of letters S, of the top blocks add up without
  carries.
* `card_minimal_words`: the number of minimal words with `n` letters E, as a sum over the letter
  counts of the top blocks of products of `minCount`.
* `choose_modEq_sum_minCount`: with `choose_modEq_minimal`, the binomial coefficient modulo
  `p ^ (c + 1)` is this sum (here `p` is prime).

The sum of `minCount_succ` in closed form (the note's Lemma `lem:mixed` and the count of
Proposition `prop:count`, for one block):

* `tuple_shape`: in a tuple `c` of the sum of `minCount_succ`, `a / p^h` entries are `p^h`, and
  the others are `0` except, when `p^h` does not divide `a`, exactly one, equal to `a % p^h`.
* `minCount_succ_mul_pow`: `minCount p (h + 1) (k p^h) = binom(p, k)` for `0 < k < p`.
* `minCount_succ_add`: `minCount p (h + 1) (k p^h + r) = p * binom(p - 1, k) * minCount p h r`
  for `k < p` and `0 < r < p^h`.
* `minCount_succ_eq`: both cases in one statement, for `0 < a < p^(h+1)`.

Not done here: the corresponding closed form for a word with several top blocks (the sum of
`card_minimal_words`), and the residue modulo `p` of Proposition `prop:count`.

No factorial and no valuation is used (binomial coefficients appear only as numbers of subsets);
`p` needs not be prime except in `choose_modEq_sum_minCount`.
-/
import MMM.Path.MinBlock
import MMM.Path.Minimal
import Mathlib.Data.Fin.Tuple.NatAntidiagonal

namespace MMM.Path

open MMM

variable {p : ℕ}

/-- The blocks of height `h` with `a` letters E that attain the bound. -/
abbrev MinSet (p : ℕ) [NeZero p] (h a : ℕ) : Type :=
  {u : Blk p h // cntE h u = a ∧ MinBlk h u}

/-- Number of blocks of height h with a letters E that attain the bound. -/
noncomputable def minCount (p : ℕ) [NeZero p] (h a : ℕ) : ℕ :=
  Nat.card {u : Blk p h // cntE h u = a ∧ MinBlk h u}

theorem minCount_eq [NeZero p] (h a : ℕ) : minCount p h a = Nat.card (MinSet p h a) := rfl

/-- The block of height `h` all of whose letters are `b`. -/
def constBlk (p : ℕ) (b : Bool) : (h : ℕ) → Blk p h
  | 0 => b
  | h + 1 => fun _ => constBlk p b h

theorem cntE_constBlk_false : ∀ h : ℕ, cntE h (constBlk p false h) = 0 := by
  intro h
  induction h with
  | zero => rfl
  | succ h ih =>
    show ∑ _j : Fin p, cntE h (constBlk p false h) = 0
    simp [ih]

theorem cntE_constBlk_true : ∀ h : ℕ, cntE h (constBlk p true h) = p ^ h := by
  intro h
  induction h with
  | zero => rfl
  | succ h ih =>
    show ∑ _j : Fin p, cntE h (constBlk p true h) = p ^ (h + 1)
    simp [ih, pow_succ']

/-- **Exactly one block with all letters equal attains the bound** (for each of the two
letters). -/
theorem minCount_mono [NeZero p] (hp : 2 ≤ p) (h a : ℕ) (ha : a = 0 ∨ a = p ^ h) :
    minCount p h a = 1 := by
  rw [minCount_eq, Nat.card_eq_one_iff_unique]
  constructor
  · constructor
    rintro ⟨u, hu, -⟩ ⟨v, hv, -⟩
    apply Subtype.ext
    rcases ha with ha | ha
    · exact eq_of_cntE_eq_zero h u v (hu.trans ha) (hv.trans ha)
    · exact eq_of_cntE_eq_pow h u v (hu.trans ha) (hv.trans ha)
  · rcases ha with ha | ha
    · exact ⟨⟨constBlk p false h, (cntE_constBlk_false h).trans ha.symm,
        minBlk_of_mono hp h _ (Or.inl (cntE_constBlk_false h))⟩⟩
    · exact ⟨⟨constBlk p true h, (cntE_constBlk_true h).trans ha.symm,
        minBlk_of_mono hp h _ (Or.inr (cntE_constBlk_true h))⟩⟩

/-- A finite set is the disjoint union of the fibres of a map. -/
theorem card_eq_sum_fibers {α β : Type*} [Finite α] [Fintype β] (f : α → β) :
    Nat.card α = ∑ b : β, Nat.card {x : α // f x = b} := by
  rw [← Nat.card_sigma]
  exact Nat.card_congr (Equiv.sigmaFiberEquiv f).symm

/-- `minCount_succ` for any finite set `F` of tuples with the right elements. -/
theorem minCount_succ_aux [NeZero p] (hp : 2 ≤ p) (h a : ℕ) (ha : 0 < a ∧ a < p ^ (h + 1))
    (F : Finset (Fin p → ℕ))
    (hF : ∀ c : Fin p → ℕ, c ∈ F ↔ ∑ j, c j = a ∧ (∀ j, c j ≤ p ^ h) ∧
      ∑ j, ds p (c j) = ds p a ∧ ∑ j, ds p (p ^ h - c j) = ds p (p ^ (h + 1) - a)) :
    minCount p (h + 1) a = ∑ c ∈ F, ∏ j, minCount p h (c j) := by
  -- a block with `a` letters E has both letters
  have hmix : ∀ u : Blk p (h + 1), cntE (h + 1) u = a →
      0 < cntE (h + 1) u ∧ cntE (h + 1) u < p ^ (h + 1) := fun u hu => by rw [hu]; exact ha
  -- the letter counts of the sub-blocks of a minimal block lie in `F`
  have hφ : ∀ u : MinSet p (h + 1) a, (fun j => cntE h (u.1 j)) ∈ F := by
    intro u
    obtain ⟨-, hA, hB⟩ := (minBlk_succ_iff hp h u.1 (hmix u.1 u.2.1)).mp u.2.2
    rw [u.2.1] at hA hB
    exact (hF _).mpr ⟨u.2.1, fun j => cntE_le h (u.1 j), hA, hB⟩
  obtain ⟨φ, hφdef⟩ : ∃ φ : MinSet p (h + 1) a → F, ∀ u j, (φ u).1 j = cntE h (u.1 j) :=
    ⟨fun u => ⟨fun j => cntE h (u.1 j), hφ u⟩, fun _ _ => rfl⟩
  -- the fibre over `c` is the product of the sets of minimal blocks with `c j` letters E
  have hfib : ∀ c : F, Nat.card {x : MinSet p (h + 1) a // φ x = c} =
      ∏ j, minCount p h (c.1 j) := by
    intro c
    obtain ⟨hc_sum, -, hcA, hcB⟩ := (hF c.1).mp c.2
    have hinv : ∀ v : (j : Fin p) → MinSet p h (c.1 j),
        cntE (h + 1) (fun j => (v j).1) = a ∧ MinBlk (h + 1) (fun j => (v j).1) := by
      intro v
      have hv : ∀ j, cntE h ((v j).1) = c.1 j := fun j => (v j).2.1
      have hsum : cntE (h + 1) (fun j => (v j).1) = a := by
        show ∑ j, cntE h ((v j).1) = a
        simp only [hv]
        exact hc_sum
      refine ⟨hsum, (minBlk_succ_iff hp h _ (hmix _ hsum)).mpr ⟨fun j => (v j).2.2, ?_, ?_⟩⟩
      · rw [hsum]
        simp only [hv]
        exact hcA
      · rw [hsum]
        simp only [hv]
        exact hcB
    let e : {x : MinSet p (h + 1) a // φ x = c} ≃ ((j : Fin p) → MinSet p h (c.1 j)) :=
      { toFun := fun x j => ⟨x.1.1 j,
          (hφdef x.1 j).symm.trans (congrFun (congrArg Subtype.val x.2) j),
          ((minBlk_succ_iff hp h x.1.1 (hmix x.1.1 x.1.2.1)).mp x.1.2.2).1 j⟩
        invFun := fun v => ⟨⟨fun j => (v j).1, hinv v⟩,
          Subtype.ext (funext fun j => (hφdef _ j).trans (v j).2.1)⟩
        left_inv := fun _ => rfl
        right_inv := fun _ => rfl }
    rw [Nat.card_congr e, Nat.card_pi]
    rfl
  calc minCount p (h + 1) a = Nat.card (MinSet p (h + 1) a) := rfl
    _ = ∑ c : F, Nat.card {x : MinSet p (h + 1) a // φ x = c} := card_eq_sum_fibers φ
    _ = ∑ c : F, ∏ j, minCount p h (c.1 j) := Finset.sum_congr rfl (fun c _ => hfib c)
    _ = ∑ c ∈ F, ∏ j, minCount p h (c j) :=
        Finset.sum_coe_sort F (fun c => ∏ j, minCount p h (c j))

/-- **Recursion for the number of minimal blocks with both letters.** A minimal block of height
`h + 1` with `0 < a < p^(h+1)` letters E is a `p`-tuple of minimal blocks of height `h` whose
numbers of letters E, and of letters S, add up without carries. -/
theorem minCount_succ [NeZero p] (hp : 2 ≤ p) (h a : ℕ) (ha : 0 < a ∧ a < p ^ (h + 1)) :
    minCount p (h + 1) a =
      ∑ c ∈ (Finset.Nat.antidiagonalTuple p a).filter (fun c =>
          (∀ j, c j ≤ p ^ h) ∧ ∑ j, ds p (c j) = ds p a ∧
          ∑ j, ds p (p ^ h - c j) = ds p (p ^ (h + 1) - a)),
        ∏ j, minCount p h (c j) :=
  minCount_succ_aux hp h a ha _ (fun c => by
    rw [Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple])

section words

/-- **Equality in `lower_boundW` (the equality case of Proposition `prop:bound`).** If `c` is the
number of carries for the letter counts of `w`, then `dW w = c` exactly when every top block
attains its bound and the numbers of letters E, and of letters S, of the top blocks add up
without carries. -/
theorem dW_eq_iff [NeZero p] (hp : 2 ≤ p) {L : List ℕ} (w : Word p L) (c : ℕ)
    (hc : (p - 1) * c + L.length = ds p (cntEW w) + ds p (len p L - cntEW w)) :
    dW w = c ↔
      (∀ i, MinBlk (L.get i) (w i)) ∧
      ∑ i, ds p (cntE (L.get i) (w i)) = ds p (cntEW w) ∧
      ∑ i, ds p (p ^ L.get i - cntE (L.get i) (w i)) = ds p (len p L - cntEW w) := by
  have hE : ds p (cntEW w) ≤ ∑ i, ds p (cntE (L.get i) (w i)) := ds_sum_le hp _ _
  have hS : ds p (len p L - cntEW w) ≤ ∑ i, ds p (p ^ L.get i - cntE (L.get i) (w i)) := by
    rw [len_sub_cntEW]
    exact ds_sum_le hp _ _
  have hsub : ∀ i ∈ (Finset.univ : Finset (Fin L.length)),
      ds p (cntE (L.get i) (w i)) + ds p (p ^ L.get i - cntE (L.get i) (w i)) ≤
        (p - 1) * d (L.get i) (w i) + 1 :=
    fun i _ => lower_bound hp _ (w i)
  have hsum_le : ∑ i, (ds p (cntE (L.get i) (w i)) + ds p (p ^ L.get i - cntE (L.get i) (w i))) ≤
      ∑ i : Fin L.length, ((p - 1) * d (L.get i) (w i) + 1) := Finset.sum_le_sum hsub
  have e3 : ∑ i : Fin L.length, ((p - 1) * d (L.get i) (w i) + 1) =
      (p - 1) * dW w + L.length := by
    simp [Finset.sum_add_distrib, ← Finset.mul_sum, dW]
  have e4 : ∑ i, (ds p (cntE (L.get i) (w i)) + ds p (p ^ L.get i - cntE (L.get i) (w i))) =
      (∑ i, ds p (cntE (L.get i) (w i))) + ∑ i, ds p (p ^ L.get i - cntE (L.get i) (w i)) :=
    Finset.sum_add_distrib
  have hall : (∀ i, MinBlk (L.get i) (w i)) ↔
      ∑ i, (ds p (cntE (L.get i) (w i)) + ds p (p ^ L.get i - cntE (L.get i) (w i))) =
        ∑ i : Fin L.length, ((p - 1) * d (L.get i) (w i) + 1) := by
    rw [Finset.sum_eq_sum_iff_of_le hsub]
    constructor
    · intro hm i _
      exact (hm i).symm
    · intro hm i
      exact (hm i (Finset.mem_univ i)).symm
  have hdc : dW w = c ↔ (p - 1) * dW w = (p - 1) * c := by
    constructor
    · intro h
      rw [h]
    · intro h
      exact Nat.eq_of_mul_eq_mul_left (by omega) h
  rw [hdc, hall]
  constructor
  · intro hm
    refine ⟨?_, ?_, ?_⟩ <;> omega
  · rintro ⟨hm, hA, hB⟩
    omega

/-- A word built from minimal blocks whose letter counts `a i` add up without carries is
minimal. -/
theorem minimal_word_of_blocks [NeZero p] (hp : 2 ≤ p) {L : List ℕ} (n c : ℕ)
    (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) (a : Fin L.length → ℕ)
    (ha : ∑ i, a i = n) (hA : ∑ i, ds p (a i) = ds p n)
    (hB : ∑ i, ds p (p ^ L.get i - a i) = ds p (len p L - n)) (w : Word p L)
    (hw : ∀ i, cntE (L.get i) (w i) = a i ∧ MinBlk (L.get i) (w i)) :
    cntEW w = n ∧ dW w = c := by
  have hv : ∀ i, cntE (L.get i) (w i) = a i := fun i => (hw i).1
  have hsum : cntEW w = n := by
    show ∑ i, cntE (L.get i) (w i) = n
    simp only [hv]
    exact ha
  refine ⟨hsum, (dW_eq_iff hp w c (by rw [hsum]; exact hc)).mpr ⟨fun i => (hw i).2, ?_, ?_⟩⟩
  · rw [hsum]
    simp only [hv]
    exact hA
  · rw [hsum]
    simp only [hv]
    exact hB

/-- `card_minimal_words` for any finite set `F` of tuples with the right elements. -/
theorem card_minimal_words_aux [NeZero p] (hp : 2 ≤ p) (L : List ℕ) (n c : ℕ)
    (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n))
    (F : Finset (Fin L.length → ℕ))
    (hF : ∀ a : Fin L.length → ℕ, a ∈ F ↔ ∑ i, a i = n ∧ (∀ i, a i ≤ p ^ L.get i) ∧
      ∑ i, ds p (a i) = ds p n ∧ ∑ i, ds p (p ^ L.get i - a i) = ds p (len p L - n)) :
    Nat.card {w : Word p L // cntEW w = n ∧ dW w = c} =
      ∑ a ∈ F, ∏ i, minCount p (L.get i) (a i) := by
  have hcw : ∀ w : Word p L, cntEW w = n →
      (p - 1) * c + L.length = ds p (cntEW w) + ds p (len p L - cntEW w) :=
    fun w hw => by rw [hw]; exact hc
  -- the letter counts of the top blocks of a minimal word lie in `F`
  have hφ : ∀ w : {w : Word p L // cntEW w = n ∧ dW w = c},
      (fun i => cntE (L.get i) (w.1 i)) ∈ F := by
    intro w
    obtain ⟨-, hA, hB⟩ := (dW_eq_iff hp w.1 c (hcw w.1 w.2.1)).mp w.2.2
    rw [w.2.1] at hA hB
    exact (hF _).mpr ⟨w.2.1, fun i => cntE_le _ (w.1 i), hA, hB⟩
  obtain ⟨φ, hφdef⟩ : ∃ φ : {w : Word p L // cntEW w = n ∧ dW w = c} → F,
      ∀ w i, (φ w).1 i = cntE (L.get i) (w.1 i) :=
    ⟨fun w => ⟨fun i => cntE (L.get i) (w.1 i), hφ w⟩, fun _ _ => rfl⟩
  -- the fibre over `a` is the product of the sets of minimal blocks with `a i` letters E
  have hfib : ∀ a : F, Nat.card {x : {w : Word p L // cntEW w = n ∧ dW w = c} // φ x = a} =
      ∏ i, minCount p (L.get i) (a.1 i) := by
    intro a
    obtain ⟨ha_sum, -, haA, haB⟩ := (hF a.1).mp a.2
    let e : {x : {w : Word p L // cntEW w = n ∧ dW w = c} // φ x = a} ≃
        ((i : Fin L.length) → MinSet p (L.get i) (a.1 i)) :=
      { toFun := fun x i => ⟨x.1.1 i,
          (hφdef x.1 i).symm.trans (congrFun (congrArg Subtype.val x.2) i),
          ((dW_eq_iff hp x.1.1 c (hcw x.1.1 x.1.2.1)).mp x.1.2.2).1 i⟩
        invFun := fun v => ⟨⟨fun i => (v i).1,
            minimal_word_of_blocks hp n c hc a.1 ha_sum haA haB _ (fun i => (v i).2)⟩,
          Subtype.ext (funext fun i => (hφdef _ i).trans (v i).2.1)⟩
        left_inv := fun _ => rfl
        right_inv := fun _ => rfl }
    rw [Nat.card_congr e, Nat.card_pi]
    rfl
  calc Nat.card {w : Word p L // cntEW w = n ∧ dW w = c}
      = ∑ a : F, Nat.card {x : {w : Word p L // cntEW w = n ∧ dW w = c} // φ x = a} :=
        card_eq_sum_fibers φ
    _ = ∑ a : F, ∏ i, minCount p (L.get i) (a.1 i) := Finset.sum_congr rfl (fun a _ => hfib a)
    _ = ∑ a ∈ F, ∏ i, minCount p (L.get i) (a i) :=
        Finset.sum_coe_sort F (fun a => ∏ i, minCount p (L.get i) (a i))

/-- **The number of minimal words.** If `c` is the number of carries when `n` and
`len p L - n` are added, the words with `n` letters E and `dW w = c` are the tuples of minimal
blocks whose numbers of letters E, and of letters S, add up without carries; they are counted
by the letter counts `a i` of the top blocks. -/
theorem card_minimal_words [NeZero p] (hp : 2 ≤ p) (L : List ℕ) (n c : ℕ)
    (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) :
    Nat.card {w : Word p L // cntEW w = n ∧ dW w = c} =
      ∑ a ∈ (Finset.Nat.antidiagonalTuple L.length n).filter (fun a =>
          (∀ i, a i ≤ p ^ L.get i) ∧ ∑ i, ds p (a i) = ds p n ∧
          ∑ i, ds p (p ^ L.get i - a i) = ds p (len p L - n)),
        ∏ i, minCount p (L.get i) (a i) :=
  card_minimal_words_aux hp L n c hc _ (fun a => by
    rw [Finset.mem_filter, Finset.Nat.mem_antidiagonalTuple])

/-- **Equation (modp) in terms of minimal blocks.** Modulo `p ^ (c + 1)`, the binomial
coefficient is the number of tuples of minimal blocks whose letter counts add up without
carries. -/
theorem choose_modEq_sum_minCount [hp : Fact p.Prime] (L : List ℕ) (n c : ℕ) (hn : n ≤ len p L)
    (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) :
    (len p L).choose n ≡
      ∑ a ∈ (Finset.Nat.antidiagonalTuple L.length n).filter (fun a =>
          (∀ i, a i ≤ p ^ L.get i) ∧ ∑ i, ds p (a i) = ds p n ∧
          ∑ i, ds p (p ^ L.get i - a i) = ds p (len p L - n)),
        ∏ i, minCount p (L.get i) (a i) [MOD p ^ (c + 1)] := by
  rw [← card_minimal_words hp.out.two_le L n c hc]
  exact choose_modEq_minimal L n c hn hc

end words

section shape

/-- The digit at place `h` of a number `≤ p^h`. -/
theorem dig_of_le_pow (hp : 2 ≤ p) (h x : ℕ) (hx : x ≤ p ^ h) :
    dig p h x = if x = p ^ h then 1 else 0 := by
  have hpos : 0 < p ^ h := pow_pos (by omega) h
  unfold dig
  split_ifs with hx'
  · rw [hx', Nat.div_self hpos, Nat.mod_eq_of_lt (by omega)]
  · rw [Nat.div_eq_of_lt (lt_of_le_of_ne hx hx'), Nat.zero_mod]

/-- In a carry-free sum below `p^(h+1)` of numbers `≤ p^h`, the number of summands equal to
`p^h` is the quotient of the sum by `p^h`. -/
theorem card_eq_pow_of_carry_free (hp : 2 ≤ p) {ι : Type*} [Fintype ι] (h : ℕ) (f : ι → ℕ)
    (hf : ∀ j, f j ≤ p ^ h) (hlt : ∑ j, f j < p ^ (h + 1))
    (hds : ds p (∑ j, f j) = ∑ j, ds p (f j)) :
    (Finset.univ.filter (fun j => f j = p ^ h)).card = (∑ j, f j) / p ^ h := by
  have hpos : 0 < p ^ h := pow_pos (by omega) h
  have h1 := dig_sum hp Finset.univ f hds h
  have h2 : dig p h (∑ j, f j) = (∑ j, f j) / p ^ h := by
    unfold dig
    refine Nat.mod_eq_of_lt ?_
    rw [Nat.div_lt_iff_lt_mul hpos]
    rw [pow_succ'] at hlt
    exact hlt
  rw [← h2, h1, Finset.card_filter]
  exact Finset.sum_congr rfl (fun j _ => (dig_of_le_pow hp h (f j) (hf j)).symm)

/-- A multiple of `p^h` plus a number below `p^h`: the digit sums add. -/
theorem ds_mul_pow_add (hp : 2 ≤ p) (k : ℕ) :
    ∀ (h r : ℕ), r < p ^ h → ds p (k * p ^ h + r) = ds p k + ds p r := by
  intro h
  induction h with
  | zero =>
    intro r hr
    have : r = 0 := by simpa using hr
    subst this
    simp
  | succ h ih =>
    intro r hr
    have hp0 : 0 < p := by omega
    have e : k * p ^ (h + 1) = p * (k * p ^ h) := by rw [pow_succ', Nat.mul_left_comm]
    have h1 : (k * p ^ (h + 1) + r) % p = r % p := by rw [e, Nat.mul_add_mod]
    have h2 : (k * p ^ (h + 1) + r) / p = k * p ^ h + r / p := by rw [e, Nat.mul_add_div hp0]
    have h3 : r / p < p ^ h := by
      rw [Nat.div_lt_iff_lt_mul hp0]
      rw [pow_succ] at hr
      exact hr
    rw [ds_rec hp (k * p ^ (h + 1) + r), ds_rec hp r, h1, h2, ih _ h3]
    omega

/-- **The shape of a carry-free tuple** (the note's Lemma `lem:mixed` for one block). Let
`c : Fin p → ℕ` be a tuple of numbers `≤ p^h` with sum `a`, `0 < a < p^(h+1)`, such that the
`c j` add up without carries and the `p^h - c j` add up without carries. Then `a / p^h` of the
`c j` are equal to `p^h`; if `p^h` divides `a` all the others are `0`; otherwise exactly one
other `c j` is not `0`, and it is `a % p^h`. -/
theorem tuple_shape (hp : 2 ≤ p) (h a : ℕ) (ha : 0 < a ∧ a < p ^ (h + 1)) (c : Fin p → ℕ)
    (hsum : ∑ j, c j = a) (hle : ∀ j, c j ≤ p ^ h) (hA : ∑ j, ds p (c j) = ds p a)
    (hB : ∑ j, ds p (p ^ h - c j) = ds p (p ^ (h + 1) - a)) :
    (Finset.univ.filter (fun j => c j = p ^ h)).card = a / p ^ h ∧
    (a % p ^ h = 0 → ∀ j, c j = 0 ∨ c j = p ^ h) ∧
    (0 < a % p ^ h → ∃ j0, c j0 = a % p ^ h ∧ ∀ j, j ≠ j0 → c j = 0 ∨ c j = p ^ h) := by
  have hq : 0 < p ^ h := pow_pos (by omega) h
  have hpow : p ^ (h + 1) = p ^ h * p := pow_succ _ _
  -- the number of `c j = p^h`
  have hE : (Finset.univ.filter (fun j => c j = p ^ h)).card = a / p ^ h := by
    have h1 := card_eq_pow_of_carry_free hp h c hle (by rw [hsum]; exact ha.2)
      (by rw [hsum]; exact hA.symm)
    rw [hsum] at h1
    exact h1
  -- the number of `c j = 0`
  have hsumS : ∑ j, (p ^ h - c j) = p ^ (h + 1) - a := by
    rw [Finset.sum_tsub_distrib _ (fun j _ => hle j), hsum]
    simp [pow_succ']
  have hZ : (Finset.univ.filter (fun j => c j = 0)).card = (p ^ (h + 1) - a) / p ^ h := by
    have h1 := card_eq_pow_of_carry_free hp h (fun j => p ^ h - c j) (fun j => Nat.sub_le _ _)
      (by rw [hsumS]; omega) (by rw [hsumS]; exact hB.symm)
    rw [hsumS] at h1
    rw [← h1]
    exact congrArg Finset.card (Finset.filter_congr (fun j _ => by omega))
  -- every `j` is of exactly one of three kinds
  have hterm : ∀ j, ((if c j = p ^ h then 1 else 0) + (if c j = 0 then 1 else 0) +
      (if c j ≠ 0 ∧ c j ≠ p ^ h then 1 else 0) : ℕ) = 1 := by
    intro j
    split_ifs <;> omega
  have hpart : (Finset.univ.filter (fun j => c j = p ^ h)).card +
      (Finset.univ.filter (fun j => c j = 0)).card +
      (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card = p := by
    rw [Finset.card_filter, Finset.card_filter, Finset.card_filter, ← Finset.sum_add_distrib,
      ← Finset.sum_add_distrib, Finset.sum_congr rfl (fun j _ => hterm j)]
    simp
  have hdivE := Nat.div_add_mod a (p ^ h)
  have hdivZ := Nat.div_add_mod (p ^ (h + 1) - a) (p ^ h)
  have hr : a % p ^ h < p ^ h := Nat.mod_lt _ hq
  have hr' : (p ^ (h + 1) - a) % p ^ h < p ^ h := Nat.mod_lt _ hq
  have e1 : p ^ h * p = p ^ h * (a / p ^ h) + p ^ h * ((p ^ (h + 1) - a) / p ^ h) +
      p ^ h * (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card := by
    rw [← Nat.mul_add, ← Nat.mul_add, ← hE, ← hZ, hpart]
  have hqe : a % p ^ h + (p ^ (h + 1) - a) % p ^ h =
      p ^ h * (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card := by
    omega
  refine ⟨hE, ?_, ?_⟩
  · -- `p^h` divides `a`: no other kind
    intro hr0 j
    have hM0 : (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card = 0 := by
      rcases Nat.eq_zero_or_pos (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card
        with h0 | h0
      · exact h0
      · have h1 : p ^ h * 1 ≤
            p ^ h * (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card :=
          Nat.mul_le_mul_left _ h0
        omega
    by_contra hcon
    have hmem : j ∈ Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h) :=
      Finset.mem_filter.mpr ⟨Finset.mem_univ j, by omega⟩
    rw [Finset.card_eq_zero.mp hM0] at hmem
    simp at hmem
  · -- otherwise exactly one `j0` of the third kind
    intro hrpos
    have hM1 : (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card = 1 := by
      rcases Nat.lt_or_ge (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card 2
        with h2 | h2
      · rcases Nat.eq_zero_or_pos (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card
          with h0 | h0
        · rw [h0, Nat.mul_zero] at hqe
          have h4 : a % p ^ h ≤ a % p ^ h + (p ^ (h + 1) - a) % p ^ h := Nat.le_add_right _ _
          rw [hqe] at h4
          exact absurd hrpos (Nat.not_lt.mpr h4)
        · omega
      · have h3 : p ^ h * 2 ≤
            p ^ h * (Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h)).card :=
          Nat.mul_le_mul_left _ h2
        omega
    obtain ⟨j0, hj0⟩ := Finset.card_eq_one.mp hM1
    have hj0M : c j0 ≠ 0 ∧ c j0 ≠ p ^ h := by
      have hmem : j0 ∈ Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h) := by
        rw [hj0]
        exact Finset.mem_singleton_self j0
      exact (Finset.mem_filter.mp hmem).2
    have hother : ∀ j, j ≠ j0 → c j = 0 ∨ c j = p ^ h := by
      intro j hj
      by_contra hcon
      have hmem : j ∈ Finset.univ.filter (fun j => c j ≠ 0 ∧ c j ≠ p ^ h) :=
        Finset.mem_filter.mpr ⟨Finset.mem_univ j, by omega⟩
      rw [hj0, Finset.mem_singleton] at hmem
      exact hj hmem
    refine ⟨j0, ?_, hother⟩
    have hdecomp : ∀ j, c j =
        (if c j = p ^ h then p ^ h else 0) + (if j = j0 then c j0 else 0) := by
      intro j
      by_cases hj : j = j0
      · rw [hj, ite_eq_right hj0M.2, ite_eq_left rfl, Nat.zero_add]
      · rcases hother j hj with h0 | h0 <;>
        · rw [ite_eq_right hj]
          split_ifs <;> omega
    have hs1 : ∑ j, (if c j = p ^ h then p ^ h else 0) =
        (Finset.univ.filter (fun j => c j = p ^ h)).card * p ^ h := by
      rw [← Finset.sum_filter, Finset.sum_const, smul_eq_mul]
    have hs2 : ∑ j, (if j = j0 then c j0 else 0) = c j0 := by simp
    have hs : a = (a / p ^ h) * p ^ h + c j0 := by
      calc a = ∑ j, c j := hsum.symm
        _ = ∑ j, ((if c j = p ^ h then p ^ h else 0) + (if j = j0 then c j0 else 0)) :=
            Finset.sum_congr rfl (fun j _ => hdecomp j)
        _ = (∑ j, (if c j = p ^ h then p ^ h else 0)) + ∑ j, (if j = j0 then c j0 else 0) :=
            Finset.sum_add_distrib
        _ = (a / p ^ h) * p ^ h + c j0 := by rw [hs1, hs2, hE]
    rw [Nat.mul_comm] at hs
    omega

end shape

section closed

/-- Sum over a tuple with one value on `T` and another elsewhere. -/
theorem sum_ite_mem_const (T : Finset (Fin p)) (x y : ℕ) :
    ∑ j : Fin p, (if j ∈ T then x else y) = T.card * x + (p - T.card) * y := by
  have hT : (Finset.univ.filter (fun j : Fin p => j ∈ T)) = T := by
    rw [Finset.filter_mem_eq_inter, Finset.univ_inter]
  have hc : (Finset.univ.filter (fun j : Fin p => j ∈ T)).card +
      (Finset.univ.filter (fun j : Fin p => ¬ j ∈ T)).card = p := by
    rw [Finset.card_filter_add_card_filter_not, Finset.card_univ, Fintype.card_fin]
  rw [hT] at hc
  have hc' : (Finset.univ.filter (fun j : Fin p => ¬ j ∈ T)).card = p - T.card := by omega
  rw [Finset.sum_ite, Finset.sum_const, Finset.sum_const, smul_eq_mul, smul_eq_mul, hT, hc']

/-- Sum over a tuple with a special value at `j0`, one value on `T` and another elsewhere. -/
theorem sum_ite_single_mem (T : Finset (Fin p)) (j0 : Fin p) (hj0 : j0 ∉ T) (w x y : ℕ) :
    ∑ j : Fin p, (if j = j0 then w else if j ∈ T then x else y) =
      w + T.card * x + (p - 1 - T.card) * y := by
  have hT : T.card + 1 ≤ p := by
    have h1 : (insert j0 T).card ≤ (Finset.univ : Finset (Fin p)).card :=
      Finset.card_le_card (Finset.subset_univ _)
    rw [Finset.card_insert_of_notMem hj0, Finset.card_univ, Fintype.card_fin] at h1
    exact h1
  have key : ∀ j : Fin p,
      (if j = j0 then w else if j ∈ T then x else y) + (if j = j0 then y else 0) =
        (if j ∈ T then x else y) + (if j = j0 then w else 0) := by
    intro j
    by_cases hj : j = j0
    · rw [hj, ite_eq_left rfl, ite_eq_left rfl, ite_eq_right hj0, ite_eq_left rfl, Nat.add_comm]
    · rw [ite_eq_right hj, ite_eq_right hj, ite_eq_right hj]
  have hsum := Finset.sum_congr (rfl : (Finset.univ : Finset (Fin p)) = Finset.univ)
    (fun j _ => key j)
  rw [Finset.sum_add_distrib, Finset.sum_add_distrib, sum_ite_mem_const] at hsum
  have h1 : ∑ j : Fin p, (if j = j0 then y else 0) = y := by simp
  have h2 : ∑ j : Fin p, (if j = j0 then w else 0) = w := by simp
  rw [h1, h2] at hsum
  have h3 : (p - T.card) * y = (p - 1 - T.card) * y + y := by
    have h4 : p - T.card = (p - 1 - T.card) + 1 := by omega
    rw [h4, Nat.add_mul, Nat.one_mul]
  omega

/-- The tuple with value `p^h` on `T` and `0` elsewhere. -/
def tupleOf (p h : ℕ) (T : Finset (Fin p)) : Fin p → ℕ :=
  fun j => if j ∈ T then p ^ h else 0

/-- The tuple with value `r` at `x.1`, value `p^h` on `x.2` and `0` elsewhere. -/
def tupleOf₁ (p h r : ℕ) (x : Σ _ : Fin p, Finset (Fin p)) : Fin p → ℕ :=
  fun j => if j = x.1 then r else if j ∈ x.2 then p ^ h else 0

/-- Pairs `(j0, T)` with `T` a set of `k` indices different from `j0`. -/
def pairSet (p k : ℕ) : Finset (Σ _ : Fin p, Finset (Fin p)) :=
  Finset.univ.sigma (fun j0 => Finset.powersetCard k (Finset.univ.erase j0))

theorem mem_pairSet {k : ℕ} {x : Σ _ : Fin p, Finset (Fin p)} :
    x ∈ pairSet p k ↔ x.1 ∉ x.2 ∧ x.2.card = k := by
  unfold pairSet
  rw [Finset.mem_sigma, Finset.mem_powersetCard]
  constructor
  · rintro ⟨-, hsub, hcard⟩
    exact ⟨fun hm => Finset.ne_of_mem_erase (hsub hm) rfl, hcard⟩
  · rintro ⟨hnm, hcard⟩
    exact ⟨Finset.mem_univ _,
      fun j hj => Finset.mem_erase.mpr ⟨fun hjx => hnm (hjx ▸ hj), Finset.mem_univ _⟩, hcard⟩

theorem card_pairSet (k : ℕ) : (pairSet p k).card = p * (p - 1).choose k := by
  unfold pairSet
  have h1 : ∀ j0 ∈ (Finset.univ : Finset (Fin p)),
      (Finset.powersetCard k (Finset.univ.erase j0)).card = (p - 1).choose k := by
    intro j0 _
    rw [Finset.card_powersetCard, Finset.card_erase_of_mem (Finset.mem_univ j0),
      Finset.card_univ, Fintype.card_fin]
  rw [Finset.card_sigma, Finset.sum_congr rfl h1, Finset.sum_const, Finset.card_univ,
    Fintype.card_fin, smul_eq_mul]

theorem tupleOf_injOn (h k : ℕ) (hp : 2 ≤ p) :
    Set.InjOn (tupleOf p h)
      (Finset.powersetCard k (Finset.univ : Finset (Fin p)) : Set (Finset (Fin p))) := by
  have hq : 0 < p ^ h := pow_pos (by omega) h
  intro T _ T' _ hTT
  ext j
  have hj := congrFun hTT j
  simp only [tupleOf] at hj
  constructor
  · intro hm
    by_contra hm'
    rw [ite_eq_left hm, ite_eq_right hm'] at hj
    omega
  · intro hm
    by_contra hm'
    rw [ite_eq_right hm', ite_eq_left hm] at hj
    omega

theorem tupleOf₁_injOn (h k r : ℕ) (hr : 0 < r ∧ r < p ^ h) :
    Set.InjOn (tupleOf₁ p h r) (pairSet p k : Set (Σ _ : Fin p, Finset (Fin p))) := by
  rintro ⟨j0, T⟩ hx ⟨j0', T'⟩ hy hxy
  rw [Finset.mem_coe, mem_pairSet] at hx hy
  dsimp only at hx hy
  have h1 : j0 = j0' := by
    by_contra hne
    have hj : (if j0 = j0 then r else if j0 ∈ T then p ^ h else 0) =
        (if j0 = j0' then r else if j0 ∈ T' then p ^ h else 0) := congrFun hxy j0
    rw [ite_eq_left rfl, ite_eq_right hne] at hj
    split_ifs at hj <;> omega
  subst h1
  have h2 : T = T' := by
    ext j
    by_cases hj : j = j0
    · rw [hj]
      exact ⟨fun hm => absurd hm hx.1, fun hm => absurd hm hy.1⟩
    · have hjj := congrFun hxy j
      simp only [tupleOf₁] at hjj
      rw [ite_eq_right hj, ite_eq_right hj] at hjj
      constructor
      · intro hm
        by_contra hm'
        rw [ite_eq_left hm, ite_eq_right hm'] at hjj
        omega
      · intro hm
        by_contra hm'
        rw [ite_eq_right hm', ite_eq_left hm] at hjj
        omega
  rw [h2]

/-- **Minimal blocks with `k p^h` letters E, `0 < k < p`:** choose which `k` of the `p`
sub-blocks consist of letters E; the others consist of letters S. -/
theorem minCount_succ_mul_pow [NeZero p] (hp : 2 ≤ p) (h k : ℕ) (hk : 0 < k ∧ k < p) :
    minCount p (h + 1) (k * p ^ h) = p.choose k := by
  have hq : 0 < p ^ h := pow_pos (by omega) h
  have ha : 0 < k * p ^ h ∧ k * p ^ h < p ^ (h + 1) := by
    refine ⟨Nat.mul_pos hk.1 hq, ?_⟩
    rw [pow_succ']
    exact Nat.mul_lt_mul_of_pos_right hk.2 hq
  have hF : ∀ c : Fin p → ℕ,
      c ∈ (Finset.powersetCard k (Finset.univ : Finset (Fin p))).image (tupleOf p h) ↔
        ∑ j, c j = k * p ^ h ∧ (∀ j, c j ≤ p ^ h) ∧
        ∑ j, ds p (c j) = ds p (k * p ^ h) ∧
        ∑ j, ds p (p ^ h - c j) = ds p (p ^ (h + 1) - k * p ^ h) := by
    intro c
    rw [Finset.mem_image]
    constructor
    · rintro ⟨T, hT, rfl⟩
      rw [Finset.mem_powersetCard] at hT
      have hds1 : ∀ j, ds p (tupleOf p h T j) = if j ∈ T then 1 else 0 := by
        intro j
        simp only [tupleOf]
        split_ifs
        · exact ds_pow hp h
        · exact ds_zero p
      have hds2 : ∀ j, ds p (p ^ h - tupleOf p h T j) = if j ∈ T then 0 else 1 := by
        intro j
        simp only [tupleOf]
        split_ifs
        · rw [Nat.sub_self]
          exact ds_zero p
        · rw [Nat.sub_zero]
          exact ds_pow hp h
      have hkds : ds p (k * p ^ h) = k := by
        have h1 := ds_mul_pow_add hp k h 0 hq
        rw [Nat.add_zero, ds_zero, Nat.add_zero, ds_of_lt hp hk.2] at h1
        exact h1
      have hpk : p ^ (h + 1) - k * p ^ h = (p - k) * p ^ h := by
        rw [pow_succ', Nat.sub_mul]
      have hpkds : ds p ((p - k) * p ^ h) = p - k := by
        have h1 := ds_mul_pow_add hp (p - k) h 0 hq
        rw [Nat.add_zero, ds_zero, Nat.add_zero, ds_of_lt hp (show p - k < p by omega)] at h1
        exact h1
      refine ⟨?_, ?_, ?_, ?_⟩
      · show ∑ j, (if j ∈ T then p ^ h else 0) = k * p ^ h
        rw [sum_ite_mem_const, hT.2, Nat.mul_zero, Nat.add_zero]
      · intro j
        simp only [tupleOf]
        split_ifs <;> omega
      · rw [Finset.sum_congr rfl (fun j _ => hds1 j), sum_ite_mem_const, hT.2, hkds]
        omega
      · rw [Finset.sum_congr rfl (fun j _ => hds2 j), sum_ite_mem_const, hT.2, hpk, hpkds]
        omega
    · rintro ⟨hsum, hle, hA, hB⟩
      obtain ⟨hE, h0, -⟩ := tuple_shape hp h (k * p ^ h) ha c hsum hle hA hB
      refine ⟨Finset.univ.filter (fun j => c j = p ^ h), ?_, ?_⟩
      · rw [Finset.mem_powersetCard]
        exact ⟨Finset.subset_univ _, by rw [hE, Nat.mul_div_cancel _ hq]⟩
      · funext j
        simp only [tupleOf, Finset.mem_filter, Finset.mem_univ, true_and]
        rcases h0 (Nat.mul_mod_left k (p ^ h)) j with hj | hj
        · rw [ite_eq_right (show ¬ c j = p ^ h by omega)]
          exact hj.symm
        · rw [ite_eq_left hj]
          exact hj.symm
  have hone : ∀ T ∈ Finset.powersetCard k (Finset.univ : Finset (Fin p)),
      ∏ j, minCount p h (tupleOf p h T j) = 1 := by
    intro T _
    refine Finset.prod_eq_one (fun j _ => minCount_mono hp h _ ?_)
    simp only [tupleOf]
    split_ifs
    · exact Or.inr rfl
    · exact Or.inl rfl
  rw [minCount_succ_aux hp h (k * p ^ h) ha _ hF, Finset.sum_image (tupleOf_injOn h k hp),
    Finset.sum_congr rfl hone, Finset.sum_const, smul_eq_mul, Nat.mul_one,
    Finset.card_powersetCard, Finset.card_univ, Fintype.card_fin]

/-- **Minimal blocks with `k p^h + r` letters E, `k < p` and `0 < r < p^h`:** choose the one
sub-block with both letters (it is minimal, with `r` letters E) and which `k` of the other
`p - 1` sub-blocks consist of letters E. -/
theorem minCount_succ_add [NeZero p] (hp : 2 ≤ p) (h k r : ℕ) (hk : k < p)
    (hr : 0 < r ∧ r < p ^ h) :
    minCount p (h + 1) (k * p ^ h + r) = p * (p - 1).choose k * minCount p h r := by
  have hq : 0 < p ^ h := pow_pos (by omega) h
  have hkq : k * p ^ h + p ^ h ≤ p * p ^ h := by
    have h1 : (k + 1) * p ^ h ≤ p * p ^ h := Nat.mul_le_mul_right _ hk
    rw [Nat.add_mul, Nat.one_mul] at h1
    exact h1
  have ha : 0 < k * p ^ h + r ∧ k * p ^ h + r < p ^ (h + 1) := by
    rw [pow_succ']
    omega
  have hdiv : (k * p ^ h + r) / p ^ h = k := by
    rw [Nat.mul_comm, Nat.mul_add_div hq, Nat.div_eq_of_lt hr.2, Nat.add_zero]
  have hmod : (k * p ^ h + r) % p ^ h = r := by
    rw [Nat.mul_comm, Nat.mul_add_mod, Nat.mod_eq_of_lt hr.2]
  have hF : ∀ c : Fin p → ℕ, c ∈ (pairSet p k).image (tupleOf₁ p h r) ↔
      ∑ j, c j = k * p ^ h + r ∧ (∀ j, c j ≤ p ^ h) ∧
      ∑ j, ds p (c j) = ds p (k * p ^ h + r) ∧
      ∑ j, ds p (p ^ h - c j) = ds p (p ^ (h + 1) - (k * p ^ h + r)) := by
    intro c
    rw [Finset.mem_image]
    constructor
    · rintro ⟨⟨j0, T⟩, hx, rfl⟩
      rw [mem_pairSet] at hx
      obtain ⟨hj0T, hT⟩ := hx
      dsimp only at hj0T hT
      have hds1 : ∀ j, ds p (tupleOf₁ p h r ⟨j0, T⟩ j) =
          if j = j0 then ds p r else if j ∈ T then 1 else 0 := by
        intro j
        simp only [tupleOf₁]
        split_ifs
        · rfl
        · exact ds_pow hp h
        · exact ds_zero p
      have hds2 : ∀ j, ds p (p ^ h - tupleOf₁ p h r ⟨j0, T⟩ j) =
          if j = j0 then ds p (p ^ h - r) else if j ∈ T then 0 else 1 := by
        intro j
        simp only [tupleOf₁]
        split_ifs
        · rfl
        · rw [Nat.sub_self]
          exact ds_zero p
        · rw [Nat.sub_zero]
          exact ds_pow hp h
      have hkds : ds p (k * p ^ h + r) = k + ds p r := by
        rw [ds_mul_pow_add hp k h r hr.2, ds_of_lt hp hk]
      have hpk : p ^ (h + 1) - (k * p ^ h + r) = (p - 1 - k) * p ^ h + (p ^ h - r) := by
        have e : (p - 1 - k) * p ^ h + p ^ h + k * p ^ h = p * p ^ h := by
          rw [← Nat.succ_mul, ← Nat.add_mul]
          congr 1
          omega
        rw [pow_succ']
        omega
      have hpkds : ds p ((p - 1 - k) * p ^ h + (p ^ h - r)) =
          (p - 1 - k) + ds p (p ^ h - r) := by
        rw [ds_mul_pow_add hp (p - 1 - k) h (p ^ h - r) (by omega),
          ds_of_lt hp (show p - 1 - k < p by omega)]
      refine ⟨?_, ?_, ?_, ?_⟩
      · show ∑ j, (if j = j0 then r else if j ∈ T then p ^ h else 0) = k * p ^ h + r
        rw [sum_ite_single_mem T j0 hj0T, hT]
        omega
      · intro j
        simp only [tupleOf₁]
        split_ifs <;> omega
      · rw [Finset.sum_congr rfl (fun j _ => hds1 j), sum_ite_single_mem T j0 hj0T, hT, hkds]
        omega
      · rw [Finset.sum_congr rfl (fun j _ => hds2 j), sum_ite_single_mem T j0 hj0T, hT, hpk,
          hpkds]
        omega
    · rintro ⟨hsum, hle, hA, hB⟩
      obtain ⟨hE, -, h1⟩ := tuple_shape hp h (k * p ^ h + r) ha c hsum hle hA hB
      rw [hdiv] at hE
      rw [hmod] at h1
      obtain ⟨j0, hc0, hother⟩ := h1 hr.1
      refine ⟨⟨j0, Finset.univ.filter (fun j => c j = p ^ h)⟩, ?_, ?_⟩
      · rw [mem_pairSet]
        refine ⟨fun hm => ?_, hE⟩
        have hm' : c j0 = p ^ h := (Finset.mem_filter.mp hm).2
        omega
      · funext j
        simp only [tupleOf₁, Finset.mem_filter, Finset.mem_univ, true_and]
        by_cases hj : j = j0
        · rw [ite_eq_left hj, hj]
          exact hc0.symm
        · rw [ite_eq_right hj]
          rcases hother j hj with hj' | hj'
          · rw [ite_eq_right (show ¬ c j = p ^ h by omega)]
            exact hj'.symm
          · rw [ite_eq_left hj']
            exact hj'.symm
  have hterm : ∀ x ∈ pairSet p k, ∏ j, minCount p h (tupleOf₁ p h r x j) = minCount p h r := by
    rintro ⟨j0, T⟩ -
    have hj1 : ∀ j ∈ (Finset.univ : Finset (Fin p)), j ≠ j0 →
        minCount p h (tupleOf₁ p h r ⟨j0, T⟩ j) = 1 := by
      intro j _ hj
      apply minCount_mono hp
      show (if j = j0 then r else if j ∈ T then p ^ h else 0) = 0 ∨
        (if j = j0 then r else if j ∈ T then p ^ h else 0) = p ^ h
      rw [ite_eq_right hj]
      split_ifs
      · exact Or.inr rfl
      · exact Or.inl rfl
    rw [Finset.prod_eq_single j0 hj1 (fun hj => absurd (Finset.mem_univ j0) hj)]
    show minCount p h (if j0 = j0 then r else if j0 ∈ T then p ^ h else 0) = minCount p h r
    rw [ite_eq_left rfl]
  rw [minCount_succ_aux hp h (k * p ^ h + r) ha _ hF,
    Finset.sum_image (tupleOf₁_injOn h k r hr), Finset.sum_congr rfl hterm, Finset.sum_const,
    smul_eq_mul, card_pairSet]

/-- **The recursion for the number of minimal blocks with both letters, in closed form.** Write
`a = k p^h + r` with `r < p^h` (so `k = a / p^h < p` and `r = a % p^h`). If `r = 0` there are
`binom(p, k)` minimal blocks; otherwise `p * binom(p - 1, k)` times the number of minimal blocks
of height `h` with `r` letters E. -/
theorem minCount_succ_eq [NeZero p] (hp : 2 ≤ p) (h a : ℕ) (ha : 0 < a ∧ a < p ^ (h + 1)) :
    minCount p (h + 1) a =
      if a % p ^ h = 0 then p.choose (a / p ^ h)
      else p * (p - 1).choose (a / p ^ h) * minCount p h (a % p ^ h) := by
  have hq : 0 < p ^ h := pow_pos (by omega) h
  have hk : a / p ^ h < p := by
    rw [Nat.div_lt_iff_lt_mul hq, ← pow_succ']
    exact ha.2
  have hdm := Nat.div_add_mod a (p ^ h)
  rw [Nat.mul_comm] at hdm
  split_ifs with h0
  · have hkpos : 0 < a / p ^ h := by
      rcases Nat.eq_zero_or_pos (a / p ^ h) with hz | hz
      · rw [hz, h0] at hdm
        omega
      · exact hz
    have ha' : a = a / p ^ h * p ^ h := by omega
    exact (congrArg (minCount p (h + 1)) ha').trans
      (minCount_succ_mul_pow hp h (a / p ^ h) ⟨hkpos, hk⟩)
  · exact (congrArg (minCount p (h + 1)) hdm.symm).trans
      (minCount_succ_add hp h (a / p ^ h) (a % p ^ h) hk
        ⟨Nat.pos_of_ne_zero h0, Nat.mod_lt _ hq⟩)

end closed

end MMM.Path

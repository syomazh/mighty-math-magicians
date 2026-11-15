/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-15. Not human-reviewed.

  **Definitions for the count of the minimal words (the note's Proposition `prop:count`).**

Definitions only, shared by `Slots.lean` (the count, for every list of top blocks) and
`KummerExact.lean` (its value for the base-p digits of a number). Tested numerically in
`experiments/E017_path_slot_count/`.

* `minWords p L n`: the number of minimal words with `n` letters E over the top blocks `L`, in
  the form of `card_minimal_words`: a sum over the letter counts of the top blocks.
* `muAt p L n j`: the number of mixed segments of length `p^j` in a minimal word. For the digit
  list of `N` this is the carry into digit `j` when `n` and `N - n` are added.
* `slotsAt p L n j`: the number of slots of length `p^j`: the top blocks of height `j` and the
  `p` sub-segments of each mixed segment of length `p^(j+1)`.
* `slotCount p L n B`: at each level `j < B`, choose the E-atoms and the S-atoms among the slots.
-/
import MMM.Path.MinCount

namespace MMM.Path

open MMM

/-- The number of minimal words with `n` letters E, as the sum of `card_minimal_words`. -/
noncomputable def minWords (p : ℕ) [NeZero p] (L : List ℕ) (n : ℕ) : ℕ :=
  ∑ a ∈ (Finset.Nat.antidiagonalTuple L.length n).filter (fun a =>
      (∀ i, a i ≤ p ^ L.get i) ∧ ∑ i, ds p (a i) = ds p n ∧
      ∑ i, ds p (p ^ L.get i - a i) = ds p (len p L - n)),
    ∏ i, minCount p (L.get i) (a i)

/-- The total length of the top blocks of height at least `j`, divided by `p^j`. -/
def topAt (p : ℕ) (L : List ℕ) (j : ℕ) : ℕ :=
  ((L.filter (fun h => j ≤ h)).map (fun h => p ^ (h - j))).sum

/-- The number of mixed segments of length `p^j` in a minimal word with `n` letters E. -/
def muAt (p : ℕ) (L : List ℕ) (n j : ℕ) : ℕ :=
  topAt p L j - n / p ^ j - (len p L - n) / p ^ j

/-- The number of slots of length `p^j`. -/
def slotsAt (p : ℕ) (L : List ℕ) (n j : ℕ) : ℕ :=
  L.count j + p * muAt p L n (j + 1)

/-- The count of the note's Proposition `prop:count`, level by level. -/
def slotCount (p : ℕ) (L : List ℕ) (n B : ℕ) : ℕ :=
  ∏ j ∈ Finset.range B,
    (slotsAt p L n j).choose (dig p j n) *
      (slotsAt p L n j - dig p j n).choose (dig p j (len p L - n))

/-- `card_minimal_words` in terms of `minWords`. -/
theorem card_minimal_words' {p : ℕ} [NeZero p] (hp : 2 ≤ p) (L : List ℕ) (n c : ℕ)
    (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) :
    Nat.card {w : Word p L // cntEW w = n ∧ dW w = c} = minWords p L n :=
  card_minimal_words hp L n c hc

/-- `choose_modEq_sum_minCount` in terms of `minWords`. -/
theorem choose_modEq_minWords {p : ℕ} [hp : Fact p.Prime] (L : List ℕ) (n c : ℕ)
    (hn : n ≤ len p L) (hc : (p - 1) * c + L.length = ds p n + ds p (len p L - n)) :
    (len p L).choose n ≡ minWords p L n [MOD p ^ (c + 1)] :=
  choose_modEq_sum_minCount L n c hn hc

end MMM.Path

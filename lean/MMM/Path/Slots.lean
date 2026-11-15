/-
Written by Claude Fable 5.2 (AI, a subagent of the orchestrator; brief W043), 2026-11-15.
Machine-checked by Lean when this file compiles; not human-reviewed.

  **The count of the minimal words (the note's Proposition `prop:count`), for every list of
  top blocks.**

`minWords p L n` (the number of minimal words with `n` letters E over the top blocks `L`, as the
sum of `card_minimal_words`) equals `slotCount p L n B` (at each level, choose the E-atoms and
the S-atoms among the slots), for every list `L` of heights, every `n ≤ len p L` and every `B`
with `len p L < p ^ B`.

Proof (Step 6 of the brief): both sides satisfy the same recursion that removes the first block
(`Slots1.lean`: `minWords_cons_succ`, `minWords_cons_zero`; `Slots2.lean`:
`slotCount_cons_succ`, `slotCount_cons_zero`): the block is all E, all S, or mixed, and a mixed
block of height `h + 1` is replaced by `p` blocks of height `h`. Strong induction on the measure
`∑ (p + 1) ^ h` over the heights `h` of `L`, which drops in all three cases.

No factorial and no valuation is used; `p` needs not be prime.
-/
import MMM.Path.Slots2

namespace MMM.Path

open MMM

variable {p : ℕ}

theorem slotCount_nil (B : ℕ) : slotCount p [] 0 B = 1 := by
  unfold slotCount
  refine Finset.prod_eq_one (fun j _ => ?_)
  simp [dig, len]

/-- **The count of the minimal words** (the note's Proposition `prop:count`), for every list of
top blocks. -/
theorem minWords_eq_slotCount [NeZero p] (hp : 2 ≤ p) (L : List ℕ) (n B : ℕ)
    (hn : n ≤ len p L) (hB : len p L < p ^ B) :
    minWords p L n = slotCount p L n B := by
  suffices key : ∀ (k : ℕ) (L : List ℕ), (L.map (fun h => (p + 1) ^ h)).sum = k →
      ∀ n, n ≤ len p L → len p L < p ^ B → minWords p L n = slotCount p L n B from
    key _ L rfl n hn hB
  intro k
  induction k using Nat.strong_induction_on with
  | _ k ih =>
    intro L hk n hn hB
    rcases L with _ | ⟨H, L⟩
    · rw [len_nil] at hn
      have h0 : n = 0 := by omega
      rw [h0, minWords_nil, ite_eq_left rfl, slotCount_nil]
    · rw [len_cons] at hn hB
      have hk' : (p + 1) ^ H + (L.map (fun h => (p + 1) ^ h)).sum = k := by simpa using hk
      have hposH : 0 < (p + 1) ^ H := pow_pos (by omega) H
      have ihL : ∀ n', n' ≤ len p L → minWords p L n' = slotCount p L n' B := fun n' hn' =>
        ih _ (by omega) L rfl n' hn' (by omega)
      rcases H with _ | h
      · -- the first block has height 0
        rw [pow_zero] at hn hB
        rw [minWords_cons_zero hp L n hn, slotCount_cons_zero hp L n B hn hB]
        congr 1
        · by_cases hd : 1 ≤ dig p 0 n
          · rw [ite_eq_left hd, ite_eq_left hd]
            exact ihL _ (by omega)
          · rw [ite_eq_right hd, ite_eq_right hd]
        · by_cases hd : 1 ≤ dig p 0 (1 + len p L - n)
          · rw [ite_eq_left hd, ite_eq_left hd]
            have hle := ((one_le_dig_iff hp 0 _).mp hd).1
            rw [pow_zero] at hle
            exact ihL n (by omega)
          · rw [ite_eq_right hd, ite_eq_right hd]
      · -- the first block has height h + 1
        have hmeas : ((List.replicate p h ++ L).map (fun h => (p + 1) ^ h)).sum =
            p * (p + 1) ^ h + (L.map (fun h => (p + 1) ^ h)).sum := by simp
        have hpos : 0 < (p + 1) ^ h := pow_pos (by omega) h
        have hsucc : (p + 1) ^ (h + 1) = p * (p + 1) ^ h + (p + 1) ^ h := by
          rw [pow_succ']
          ring
        have hM : minWords p (List.replicate p h ++ L) n =
            slotCount p (List.replicate p h ++ L) n B := by
          refine ih _ ?_ (List.replicate p h ++ L) rfl n ?_ ?_
          · rw [hmeas]
            omega
          · rw [len_append, len_replicate, ← pow_succ']
            exact hn
          · rw [len_append, len_replicate, ← pow_succ']
            exact hB
        rw [minWords_cons_succ hp h L n hn, slotCount_cons_succ hp h L n B hn hB, hM]
        congr 1
        congr 1
        · by_cases hd : 1 ≤ dig p (h + 1) n
          · rw [ite_eq_left hd, ite_eq_left hd]
            exact ihL _ (by omega)
          · rw [ite_eq_right hd, ite_eq_right hd]
        · by_cases hd : 1 ≤ dig p (h + 1) (p ^ (h + 1) + len p L - n)
          · rw [ite_eq_left hd, ite_eq_left hd]
            have hle := ((one_le_dig_iff hp (h + 1) _).mp hd).1
            exact ihL n (by omega)
          · rw [ite_eq_right hd, ite_eq_right hd]

end MMM.Path

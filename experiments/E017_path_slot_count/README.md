# E017: the slot count of the path proof, for every list of top blocks

Written by Claude Fable 5.2 (orchestrator), 2026-11-15; not human-reviewed.

## Goal and hypothesis

The path proof (claim C24, `guests/andrei-claude/`) counts the minimal words by "slots"
(Proposition `prop:count` of the note). Before asking for a Lean proof, test the statement in
the form in which Lean is to prove it: **for every list L of block heights** (not only the
base-p digits of a number) and every n,

    minWords(L, n) = slotCount(L, n).

- `minWords(L, n)`: the sum over the letter counts a_i of the top blocks (a_i ≤ p^(L_i), sum n,
  no carries among the a_i, no carries among the p^(L_i) − a_i) of ∏ minCount(L_i, a_i); the
  right side of `card_minimal_words` in `lean/MMM/Path/MinCount.lean`.
- `slotCount(L, n) = ∏_j C(s_j, n_j)·C(s_j − n_j, m_j)`, with m = len(L) − n,
  s_j = #{i : L_i = j} + p·μ_(j+1), μ_j = top_j − ⌊n/p^j⌋ − ⌊m/p^j⌋ (0 if negative),
  top_j = the sum over the blocks of height h ≥ j of p^(h − j).
  The definitions are those of `lean/MMM/Path/SlotsDef.lean`, truncated subtractions included.

Hypothesis: equality for all lists; both sides 0 when the letters cannot be placed without carries.

## Method

`run.py` (Python standard library). `minCount` is computed by the recursion proved in Lean
(`minCount_mono`, `minCount_succ_eq`) and, as an independent check, by enumerating all blocks
with their rotation classes. Run: `uv run python experiments/E017_path_slot_count/run.py`
(about one minute). Output: `output.txt`.

## Results (all pass)

0. `minCount` by the recursion equals the number of blocks that attain the bound, found by
   enumeration: p = 2 (height ≤ 4), p = 3 (height ≤ 2), p = 5 (height ≤ 1); 60 cases.
1. `minWords = slotCount` for all multisets of heights: p = 2 (heights ≤ 3, up to 5 blocks),
   p = 3 (heights ≤ 2, up to 5 blocks), p = 5 (heights ≤ 1, up to 4 blocks), all n; also with
   two extra levels in the product. 3117 cases, no mismatch.
2. For the digit list of N (p = 2, 3, 5, 7; N up to 70, 90, 130, 120; all n): `slotCount·∏ n_j! m_j!
   = ∏ (N_j + p·c_(j+1))!` (the note's formula), `binom(N, n) ≡ slotCount` and
   `binom(N, n)·∏ n_j! m_j! ≡ (−p)^c·∏ N_j!` modulo p^(c+1), and the number of carries is c.
   22769 cases.

## Analysis

The statement holds in the general form, so the Lean proof can be an induction that removes one
top block at a time and replaces a mixed block by its p sub-blocks; this leaves the class of
digit lists, which is why the general form is needed. Briefs: `briefs/W043_lean_path_slots.md`
(the count) and `briefs/W044_lean_path_kummer_exact.md` (its value for digit lists, the residue,
Kummer's theorem, Problem 137).

## Limits

Small cases only; a test, not a proof. The enumeration in (0) reads "d" as in
`lean/MMM/Path/Block.lean` (a symmetric block has p times the d of one sub-block).

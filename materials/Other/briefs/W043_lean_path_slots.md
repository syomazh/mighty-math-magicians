# W043 — Lean: the path proof, part 4 (the count of the minimal words, for every list of top blocks)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker".

## Where things stand

`lean/MMM/Path/` has, compiled and in the build: `Block`, `ClassSize`, `Bound`, `Count`, `Word`, `Kummer`, `Minimal`, `MinBlock`, `MinCount` (brief W041), and the new `SlotsDef.lean` (definitions only, by the orchestrator; read it first). The mathematics: `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex`, Lemma `lem:mixed` and Proposition `prop:count` (lines 326 to 377).

`SlotsDef.lean` defines `minWords p L n` (the sum of `card_minimal_words`), `topAt`, `muAt`, `slotsAt` and `slotCount p L n B`. The statement of this brief has been tested numerically for every list `L` of heights (not only digit lists): `experiments/E017_path_slot_count/run.py`, 3117 lists and values of n, no mismatch.

## File you own

`lean/MMM/Path/Slots.lean` (new; split into `Slots1.lean`, `Slots2.lean`, … if it grows). You may append to `lean/MMM/Path/PLAN.md`. Change nothing else; in particular not `SlotsDef.lean` (another agent builds on it at the same time, in `KummerExact.lean`).

## The statement

```lean
theorem minWords_eq_slotCount [NeZero p] (hp : 2 ≤ p) (L : List ℕ) (n B : ℕ)
    (hn : n ≤ len p L) (hB : len p L < p ^ B) :
    minWords p L n = slotCount p L n B
```

It holds for **every** list `L`; `p` need not be prime. When the letter counts cannot be realised without carries, both sides are 0 (the truncated subtractions in `muAt` and in `slotCount` take care of it: at the highest level where the integer value of μ would be negative, the factor of `slotCount` at that level is a binomial coefficient `choose s a` with `s < a`, or the next one is). `hB` makes every height of `L` and every non-zero digit of `n` and of `len p L - n` smaller than `B`.

## Proof plan (the note's "slots", as a recursion that removes one top block)

Work with plain sums over `Finset.range`, not with tuples, as early as possible.

**Step 1: a recursive form of `minWords`.**

```lean
theorem minWords_nil (n : ℕ) : minWords p [] n = if n = 0 then 1 else 0
theorem minWords_cons (hp : 2 ≤ p) (h : ℕ) (L : List ℕ) (n : ℕ) (hn : n ≤ p ^ h + len p L) :
    minWords p (h :: L) n =
      ∑ a ∈ Finset.range (n + 1),
        if a ≤ p ^ h ∧ n - a ≤ len p L ∧ ds p a + ds p (n - a) = ds p n ∧
            ds p (p ^ h - a) + ds p (len p L - (n - a)) = ds p (p ^ h + len p L - n)
        then minCount p h a * minWords p L (n - a) else 0
```

From the definition: a tuple on `Fin (L.length + 1)` is `Fin.cons a₀ a'` (grep `Finset.Nat.antidiagonalTuple` in `Mathlib/Data/Fin/Tuple/NatAntidiagonal.lean`: it is defined by this recursion; `Fin.sum_univ_succ`, `Fin.prod_univ_succ`, `List.get_cons_succ`, `List.get_cons_zero`). The condition "no carries among all the a_i" splits into "no carry in a₀ + (n − a₀)" and "no carries among the rest", because `ds p (x + y) ≤ ds p x + ds p y` (`ds_add_le`) and `ds p (∑) ≤ ∑ ds` (`ds_sum_le`): a chain of two inequalities is an equality exactly when both are. The same for the complements `p ^ L_i - a_i`, whose sum is `len p L - n` (`len_sub_cntEW` in `Word.lean` shows the pattern).

**Step 2: appending lists.** By induction on `L₁` from Step 1:

```lean
theorem minWords_append (hp : 2 ≤ p) (L₁ L₂ : List ℕ) (n : ℕ) (hn : n ≤ len p L₁ + len p L₂) :
    minWords p (L₁ ++ L₂) n =
      ∑ a ∈ Finset.range (n + 1),
        if a ≤ len p L₁ ∧ n - a ≤ len p L₂ ∧ ds p a + ds p (n - a) = ds p n ∧
            ds p (len p L₁ - a) + ds p (len p L₂ - (n - a)) = ds p (len p L₁ + len p L₂ - n)
        then minWords p L₁ a * minWords p L₂ (n - a) else 0
```

(needs: carry-freeness of a sum of three numbers can be bracketed either way). You need it only for `L₁ = List.replicate p h'`; if the general statement is awkward, prove that case.

**Step 3: a mixed block is p blocks one level down.** For `h ≥ 1`:

```lean
theorem minWords_replicate (hp : 2 ≤ p) (h a : ℕ) (ha : a ≤ p ^ (h + 1)) :
    minWords p (List.replicate p h) a = if 0 < a ∧ a < p ^ (h + 1) then minCount p (h + 1) a else 0
```

For `0 < a < p^(h+1)` this is `minCount_succ` (the two sums have the same summands; the index sets are the same filter of `antidiagonalTuple p a` up to `List.get` of a `replicate` and the casts `Fin (List.replicate p h).length ≃ Fin p`). For `a = 0` or `a = p^(h+1)` the left side is 0: the only tuple is all 0 or all `p^h`, and then `∑ ds (p^h - a_i) = p ≠ 1 = ds (p^(h+1) - 0)` (respectively `∑ ds a_i = p ≠ 1`), since `p ≥ 2`.

**Step 4: the recursion that removes the first block.** From Steps 1 to 3, with `m := p ^ h + len p L - n`:

```lean
theorem minWords_cons_succ (hp : 2 ≤ p) (h : ℕ) (L : List ℕ) (n : ℕ) (hn : n ≤ p ^ (h + 1) + len p L) :
    minWords p ((h + 1) :: L) n =
      (if 1 ≤ dig p (h + 1) n ∧ p ^ (h + 1) ≤ n then minWords p L (n - p ^ (h + 1)) else 0) +
      (if 1 ≤ dig p (h + 1) (p ^ (h + 1) + len p L - n) ∧ n ≤ len p L then minWords p L n else 0) +
      minWords p (List.replicate p h ++ L) n
theorem minWords_cons_zero (hp : 2 ≤ p) (L : List ℕ) (n : ℕ) (hn : n ≤ 1 + len p L) :
    minWords p (0 :: L) n =
      (if 1 ≤ dig p 0 n ∧ 1 ≤ n then minWords p L (n - 1) else 0) +
      (if 1 ≤ dig p 0 (1 + len p L - n) ∧ n ≤ len p L then minWords p L n else 0)
```

The three terms are the values `a = p^(h+1)` (the block is all E; "no carry in `p^(h+1) + (n - p^(h+1))`" says that digit `h + 1` of `n` is not 0), `a = 0` (all S; the same for the complements) and `0 < a < p^(h+1)` (mixed; `minCount p (h+1) a = minWords p (replicate p h) a` and Step 2). Adjust the exact shape of the two `if` conditions to what is true and convenient, and say so; the three-term structure is what matters.

**Step 5: `slotCount` satisfies the same recursion.** Removing a block of height `H` from the list:
- all E (`n` becomes `n - p^H`, digit `H` of `n` is ≥ 1): `topAt` at levels `j ≤ H` drops by `p^(H-j)` and so does `n / p^j`; at levels `j > H` nothing changes because there is no borrow. So every `muAt` is unchanged; `slotsAt` at level `H` drops by 1 (`List.count`), and digit `H` of `n` drops by 1. All other levels are unchanged.
- all S: the same with the complement.
- mixed (the block is replaced by `p` blocks of height `H - 1`): `topAt` at levels `j ≤ H - 1` is unchanged, at level `H` it drops by 1; so `muAt` at level `H` drops by 1 when it was positive, `slotsAt` at level `H` drops by 1 and `slotsAt` at level `H - 1` is unchanged (`+ p` from the count, `- p` from μ). When `muAt … H` was 0, the level-`H` factor of the new product is 0 (the slots no longer suffice), or the old product was already 0.

At level `H` the three terms add up by the Pascal rule for trinomial coefficients:
`choose s a * choose (s - a) b = [a ≥ 1] choose (s-1) (a-1) * choose (s - a) b + [b ≥ 1] choose (s-1) a * choose (s-1-a) (b-1) + choose (s-1) a * choose (s-1-a) b` for `s ≥ 1` (`Nat.choose_succ_succ` twice; prove it as a lemma about natural numbers first). For `H = 0` the third term vanishes because `muAt p L n 0 = 0` (`topAt p L 0 = len p L`), so `s = a + b` there. The cases in which a truncated subtraction misbehaves are those where the level-`H` factor, or a factor above it, is 0 on both sides; treat them separately. Check your formulation of each case against `experiments/E017_path_slot_count/run.py` (`slot_count` there is the same definition; `uv run python` is available) before proving it.

**Step 6: induction.** Strong induction on a measure that drops in all three terms, for example `(L.map (fun h => (p + 1) ^ h)).sum` (`p * (p+1)^h < (p+1)^(h+1)`), for all `n` at once; base `L = []`: `minWords_nil`, and `slotCount p [] n B = 1` for `n = 0` (`n ≤ len p [] = 0`). `slotCount` does not depend on the order of `L`, nor on `B` once `len p L < p ^ B`; you may need the latter as a lemma (extra levels have factor `choose 0 0 * choose 0 0`).

## Order of work, and what to do if it does not all fit

Steps 1 to 4 are about `minWords`, Step 5 about `slotCount`; they are independent. Keep every file compiling. If Step 5 or 6 cannot be finished, leave what is proved, state the missing recursion for `slotCount` as an explicit hypothesis of a theorem `minWords_eq_slotCount_of`, and say so. Do not state `minWords_eq_slotCount` unless everything is proved.

## Environment and rules

Exactly as in `briefs/W033_lean_path_kummer_dvd.md`, sections "Environment" and "Rules" (compile with `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/Path/Slots.lean -o .lake/build/lib/lean/MMM/Path/Slots.olean`; never `lake build`; grep Mathlib for names; no `sorry`, no axiom, no `native_decide`, no theorem with conclusion `True`; no theorem of Mathlib about valuations of factorials or binomial coefficients, no Lucas, no Kummer, no Legendre; every file must compile when you stop; header naming Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-15, not human-reviewed; no git changes). Another agent compiles on this laptop at the same time: one compile at a time.

## Report

For each step: done or not, the statement as it is in the file, the compile result, what blocked the first thing you could not finish, `#print axioms` for your last theorem, every change to a statement of this brief and why.

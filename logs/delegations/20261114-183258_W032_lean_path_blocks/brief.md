# W032 — Lean: the path proof, part 1 (one block: classes of size p^d, and the bound by digit sums)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## What this is

`guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex` proves Kummer's theorem by letting rotations act on words. Read its Sections 3 and 4 (Lemmas `lem:classes`, `lem:size`, `lem:digits`, `lem:bound`). This brief asks for those lemmas in Lean, for **one block of length p^h**.

The project already has the same two arguments for trees, and you should copy their structure: `lean/MMM/Trees.lean` (`PTree`, `d`, `leaves`, `lower_bound`), `lean/MMM/RotEquiv.lean` and `lean/MMM/ClassSize.lean` (`Rot` in normal form, `PTree.card_class`), `lean/MMM/Digits.lean` (`ds p n`, the base-p digit sum; `ds_base_mul`, `ds_add_le`, `ds_sum_le`, `ds_pos`, `ds_one`), `lean/MMM/DigitsCarry.lean` (`ds_pow`). Read them before you write anything. Do not change them.

## Files you own

`lean/MMM/Path/Block.lean`, `lean/MMM/Path/ClassSize.lean`, `lean/MMM/Path/Bound.lean`, `lean/MMM/Path/PLAN.md` (all new). Nothing else.

## Definitions (use exactly these; put them in `Block.lean`, namespace `MMM.Path`)

```lean
/-- A word on a block of length p^h: a complete p-ary tree of height h with a letter at each leaf.
`true` is the letter E, `false` the letter S. -/
def Blk (p : ℕ) : ℕ → Type
  | 0 => Bool
  | h + 1 => Fin p → Blk p h

/-- Number of letters E. -/
def cntE {p : ℕ} : (h : ℕ) → Blk p h → ℕ
  | 0, b => if b then 1 else 0
  | h + 1, u => ∑ j, cntE h (u j)

/-- Equivalence under rotations of the p sub-blocks of any block, in normal form
(rotate at the top, then recursively inside). -/
def Eqv {p : ℕ} [NeZero p] : (h : ℕ) → Blk p h → Blk p h → Prop
  | 0, a, b => a = b
  | h + 1, u, v => ∃ r : Fin p, ∀ j, Eqv h (u (j + r)) (v j)

/-- A block of length p^(h+1) is symmetric if its p sub-blocks are equivalent to one another. -/
def Sym {p : ℕ} [NeZero p] (h : ℕ) (u : Blk p (h + 1)) : Prop := ∀ i j, Eqv h (u i) (u j)

/-- Number of asymmetric blocks inside u (u itself included). -/
noncomputable def d {p : ℕ} [NeZero p] : (h : ℕ) → Blk p h → ℕ
  | 0, _ => 0
  | h + 1, u => (∑ j, d h (u j)) + (by classical exact if Sym h u then 0 else 1)
```

(If Lean rejects a definition as written, change it as little as possible, say exactly what you changed in `PLAN.md`, and keep the meaning.)

## Targets, in this order

1. (`Block.lean`) `Eqv h` is an equivalence relation (reflexive, symmetric, transitive), for `p` prime (or just `NeZero p`). Total letters: `cntS h u := p ^ h - cntE h u`, and `cntE h u ≤ p ^ h`. Equivalent blocks have the same `cntE` and the same `d`:
   `theorem cntE_eq_of_eqv : Eqv h u v → cntE h u = cntE h v` and `theorem d_eq_of_eqv : Eqv h u v → d h u = d h v`.
2. (`ClassSize.lean`) **Class size** (the note's Lemma `lem:size`), for `p` prime:
   `theorem card_class [Fact p.Prime] (h : ℕ) (u : Blk p h) : Nat.card {v : Blk p h // Eqv h u v} = p ^ d h u`.
   Follow `MMM/ClassSize.lean` step for step: at a symmetric block the class is the product of the classes of the sub-blocks; at an asymmetric block it is p disjoint copies of that product, the p rotations of the sequence of classes being pairwise distinct because p is prime.
3. (`Bound.lean`) **Lower bound** (the note's Lemma `lem:bound`), for `2 ≤ p` (use `ds` from `MMM.Digits`):
   `theorem lower_bound (hp : 2 ≤ p) (h : ℕ) (u : Blk p h) : ds p (cntE h u) + ds p (p ^ h - cntE h u) ≤ (p - 1) * d h u + 1`.
   Induction on h. Height 0: one letter, the left side is 1. Symmetric block: all sub-blocks have the same `cntE` (target 1), so `cntE u = p * cntE (u 0)` and `p^(h+1) - cntE u = p * (p^h - cntE (u 0))`; use `ds_base_mul`; `d u = p * d (u 0) ≥ d (u 0)`. Asymmetric block: `ds_sum_le` on both sums, the induction hypothesis for each sub-block, and `Σ ((p-1) d_j + 1) = (p-1) Σ d_j + p = (p-1)(Σ d_j + 1) + 1`. Compare with the proof of `PTree.lower_bound` in `MMM/Trees.lean`.
4. Only if time remains (`Bound.lean`): `theorem pow_dvd_card (hp : p.Prime) (h n c : ℕ) (hc : ds p n + ds p (p ^ h - n) = (p - 1) * c + 1) (hn : n ≤ p ^ h) : p ^ c ∣ Nat.card {u : Blk p h // cntE h u = n}` (every class inside this set has size p^d with d ≥ c; the set is a union of classes; see `MMM/Counting.lean`, `dvd_card_of_classes`, and `MMM/Divisibility.lean` for the same step on trees).

After each target that compiles, update `PLAN.md` (a table: statement, status, file).

## Environment

- Lean 4 (`leanprover/lean4:v4.36.0-rc2`) with Mathlib of November 2026. Lean is not on the PATH. From Git Bash:

      cd lean
      export PATH="$USERPROFILE/.elan/bin:$PATH"
      mkdir -p .lake/build/lib/lean/MMM/Path
      lake env lean MMM/Path/Block.lean -o .lake/build/lib/lean/MMM/Path/Block.olean

  The `-o` output is what lets a later file `import MMM.Path.Block`. The project's own files (`MMM.Digits`, `MMM.Trees`, ...) are already compiled and can be imported.
- **Never** run `lake build`, `lake update`, `lake exe cache get`, or anything that downloads. Never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean`.
- Run one compile at a time. Other workers compile on the same small machine: a compile usually takes 10 to 60 seconds, sometimes a few minutes. Do not start a second compile while one runs.
- Mathlib sources are in `lean/.lake/packages/mathlib/Mathlib`. This Mathlib is newer than most training data and many names have changed (for example `Set.mem_ofPred_eq` replaces `Set.mem_setOf_eq`, `ite_true`/`ite_false` replace `if_true`/`if_false`). **Grep Mathlib for a lemma before you use it; do not guess names.** Use slim imports, never `import Mathlib`.

## Rules

- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. A statement you cannot prove is left out of the Lean files and listed in `PLAN.md` with status "not done" and what blocked it. Do not state a weaker result under the name of a stronger one, no theorem whose conclusion is `True`, and no copy of an existing project theorem under a new name.
- A file that does not compile at the end is worse than a shorter file that does: before you stop, make sure every file you leave compiles, by moving the unfinished part into a comment block at the end if necessary.
- Every file starts with a comment naming the model that wrote it, the date 2026-11-14 and "not human-reviewed".
- No git commands that change anything. Do not launch other workers or agents.
- Save files often so that a restart can continue. Compile early and often.

## Report

For each target: done or not, the exact Lean statement as it is in the file, the compile result of each file, what blocked the first thing you could not finish, and `#print axioms` for `card_class` and `lower_bound` if they exist.

# W033 — Lean: the path proof, part 2 (Kummer's theorem, the divisibility half, for every N)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Where things stand

Worker W032 wrote, and the project now builds, `lean/MMM/Path/Block.lean` (`Blk p h`, `cntE`, `Eqv`, `Sym`, `d`, `cntS`, `Eqv.refl/symm/trans`, `eqvSetoid`, `cntE_le`, `cntE_eq_of_eqv`, `d_eq_of_eqv`), `ClassSize.lean` (`card_class : Nat.card {v : Blk p h // Eqv h u v} = p ^ d h u`) and `Bound.lean` (`lower_bound : ds p (cntE h u) + ds p (p ^ h - cntE h u) ≤ (p - 1) * d h u + 1`, and `pow_dvd_card : ds p n + ds p (p ^ h - n) = (p - 1) * c + 1 → n ≤ p ^ h → p ^ c ∣ Nat.card {u : Blk p h // cntE h u = n}`). Read these three files and `PLAN.md` first; do not change them. The mathematics is in `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex`, Sections 3 and 4 (Proposition `prop:bound` and equation (modp)).

The aim of this part: **p^c divides binom(N, n), where c is the number of carries when n and N − n are added in base p, proved from the group action.** This is the divisibility half of Kummer's theorem. **You must not use any theorem about the p-adic valuation of factorials or binomial coefficients from Mathlib** (nothing named after Kummer or Legendre, no `multiplicity_choose`, `multiplicity_factorial`, `padicValNat_choose`, `Nat.Prime.dvd_choose...` and the like). Counting lemmas (`Nat.card`, `Finset.card_powersetCard`, coefficients of `(1 + X)^N`) are fine.

## Files you own

`lean/MMM/Path/Count.lean`, `lean/MMM/Path/Word.lean`, `lean/MMM/Path/Kummer.lean` (all new), and you may append to `lean/MMM/Path/PLAN.md`. Nothing else.

## Targets, in this order (namespace `MMM.Path`; `ds` is the digit sum of `MMM.Digits`)

**1. (`Count.lean`) Words on one block are counted by a binomial coefficient.**

```lean
theorem card_cntE [NeZero p] (h n : ℕ) : Nat.card {u : Blk p h // cntE h u = n} = (p ^ h).choose n
theorem pow_dvd_choose_pow [Fact p.Prime] (h n c : ℕ)
    (hc : ds p n + ds p (p ^ h - n) = (p - 1) * c + 1) (hn : n ≤ p ^ h) : p ^ c ∣ (p ^ h).choose n
```

Plan for `card_cntE`: give `Blk p h` a `Fintype` instance by recursion on h, and prove by induction on h the polynomial identity `∑ u : Blk p h, (X : Polynomial ℕ) ^ cntE h u = (1 + X) ^ (p ^ h)` (step: a sum over `Fin p → Blk p h` of a product is the product of the sums, `Finset.prod_univ_sum` or `Fintype.prod_sum`; then `pow_mul`). Compare coefficients of X^n: the left side gives the number of u with `cntE h u = n`, the right side `(p ^ h).choose n` (grep Mathlib for the coefficient of `(1 + X) ^ N` or `(X + 1) ^ N`). A bijection with subsets of `Fin (p ^ h)` is an acceptable alternative.

**2. (`Word.lean`) Several blocks side by side.**

```lean
/-- A word cut into top blocks of heights L. -/
def Word (p : ℕ) (L : List ℕ) : Type := (i : Fin L.length) → Blk p (L.get i)
def len (p : ℕ) (L : List ℕ) : ℕ := (L.map (fun h => p ^ h)).sum          -- its length
def cntEW (w : Word p L) : ℕ := ∑ i, cntE _ (w i)
def EqvW [NeZero p] (w w' : Word p L) : Prop := ∀ i, Eqv _ (w i) (w' i)
noncomputable def dW [NeZero p] (w : Word p L) : ℕ := ∑ i, d _ (w i)

theorem card_classW [Fact p.Prime] (w : Word p L) : Nat.card {w' : Word p L // EqvW w w'} = p ^ dW w
theorem lower_boundW [NeZero p] (hp : 2 ≤ p) (w : Word p L) :
    ds p (cntEW w) + ds p (len p L - cntEW w) ≤ (p - 1) * dW w + L.length
theorem card_cntEW [NeZero p] (n : ℕ) : Nat.card {w : Word p L // cntEW w = n} = (len p L).choose n
```

Plans. `card_classW`: the class of w is the product over i of the classes of the blocks (`Equiv.subtypePiEquivPi` or the like, then the cardinality of a pi type, then `card_class` and `Finset.prod_pow_eq_pow_sum`). `lower_boundW`: `len p L - cntEW w = ∑ i, (p ^ L.get i - cntE _ (w i))` because `cntE ≤ p ^ h` (`cntE_le`); then `ds_sum_le` on both sums and `lower_bound` for each block. `card_cntEW`: the same generating-function argument as target 1, with `∏ i, (1 + X) ^ (p ^ L.get i) = (1 + X) ^ len p L`.

**3. (`Kummer.lean`) The divisibility half.**

```lean
theorem pow_dvd_choose_of_blocks [Fact p.Prime] (L : List ℕ) (n c : ℕ) (hn : n ≤ len p L)
    (hc : (p - 1) * c + L.length ≤ ds p n + ds p (len p L - n)) : p ^ c ∣ (len p L).choose n

/-- The base-p digits of N as a list of block heights. -/
theorem exists_blocks (hp : 2 ≤ p) (N : ℕ) : ∃ L : List ℕ, len p L = N ∧ L.length = ds p N

/-- Kummer's theorem, divisibility half, from the action of rotations on words. -/
theorem kummer_dvd [Fact p.Prime] (N n c : ℕ) (hn : n ≤ N)
    (hc : (p - 1) * c + ds p N ≤ ds p n + ds p (N - n)) : p ^ c ∣ N.choose n
```

Plans. `pow_dvd_choose_of_blocks`: the set `{w // cntEW w = n}` is a union of `EqvW`-classes (equivalent words have the same `cntEW`, by `cntE_eq_of_eqv`), each class has `p ^ dW w` elements, and `lower_boundW` with `hc` gives `c ≤ dW w` (divide by p − 1 ≥ 1); conclude as W032 did in `pow_dvd_card` (see `MMM/Counting.lean`, `dvd_card_of_classes`), then rewrite with `card_cntEW`. `exists_blocks`: strong induction on N with `ds_rec` (`ds p N = N % p + ds p (N / p)`): take the list for `N / p`, add 1 to every height, and append `N % p` zeros. `kummer_dvd`: combine.

After each target that compiles, update `PLAN.md`.

## Environment

- Lean 4 (`leanprover/lean4:v4.36.0-rc2`) with Mathlib of November 2026. Lean is not on the PATH. From Git Bash:

      cd lean
      export PATH="$USERPROFILE/.elan/bin:$PATH"
      lake env lean MMM/Path/Count.lean -o .lake/build/lib/lean/MMM/Path/Count.olean

  The `-o` output is what lets a later file `import MMM.Path.Count`. The project's own files are compiled and can be imported.
- **Never** run `lake build`, `lake update`, `lake exe cache get`, or anything that downloads. Never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean`.
- Run one compile at a time. Other workers compile on the same small machine. Do not start a second compile while one runs.
- Mathlib sources are in `lean/.lake/packages/mathlib/Mathlib`. This Mathlib is newer than most training data and many names have changed. **Grep Mathlib for a lemma before you use it; do not guess names.** Use slim imports, never `import Mathlib`.

## Rules

- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. A statement you cannot prove is left out of the Lean files and listed in `PLAN.md` with status "not done" and what blocked it. Do not state a weaker result under the name of a stronger one, no theorem whose conclusion is `True`, no copy of an existing theorem under a new name.
- The restriction above on Mathlib's valuation theorems is the point of the exercise. If you find you need one, stop and say so in `PLAN.md`.
- Before you stop, every file you leave must compile; move unfinished parts into a comment block at the end.
- Every file starts with a comment naming the model that wrote it, the date 2026-11-14 and "not human-reviewed".
- No git commands that change anything. Do not launch other workers or agents.
- Save files often. Compile early and often.

## Report

For each target: done or not, the exact Lean statement as it is in the file, the compile result of each file, what blocked the first thing you could not finish, and `#print axioms` for `kummer_dvd` if it exists.

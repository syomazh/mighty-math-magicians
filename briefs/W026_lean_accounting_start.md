# W026 — Lean: a start on the accounting proof

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Goal

`paper/accounting_proof.tex` (compiled as `paper/accounting_proof.pdf`) is a second proof of the team's theorem on the p-adic valuation of Fuss–Catalan numbers ("every node is worth −p"). It counts trees with labelled leaves and forests, and computes the power of p in m! by a symmetry argument (its Lemmas 3 and 4 together are Legendre's formula with a residue). No part of it is formalized. Your job is to **start** its formalization in Lean 4 with Mathlib: a plan for the whole note, and as many of its statements as you can prove. Nobody expects the whole note; what matters is that everything you deliver compiles and that the report is exact about what is and is not done.

## What already exists in Lean (read `lean/README.md` first)

The main proof is fully formalized in `lean/MMM/`. Useful for you:

- `lean/MMM/Trees.lean`: `PTree p`, `leaves`, `nodes`. `lean/MMM/LTree.lean`: `LTree p α` (trees with labelled leaves), `lab`, `Good` (labels pairwise distinct).
- `lean/MMM/Cherry.lean`, `lean/MMM/Residue.lean`: `LTree.labelled_valuation` and `LTree.labelled_congruence`: the number of p-ary trees with (p − 1)t + 1 distinctly labelled leaves is ≡ (−p)^t modulo p^(t+1). This is close to the note's lemma on labelled trees; check whether the note's Lemma 1 follows from it.
- `lean/MMM/Residue.lean`, `ResidueB.lean`: `PTree.residue`, `PTree.residue_primePower`: (number of trees)·∏ m_j! ≡ (−p)^t (mod p^(t+1)).
- `lean/MMM/Digits.lean`, `DigitsCarry.lean`, `DigitsFree.lean`: the digit sum `ds`, digits `dig`.
- Mathlib has Legendre's formula (search `Mathlib/NumberTheory/Padics/PadicVal` and `Mathlib/Data/Nat/Multiplicity.lean` or similar for `factorial`) and Wilson's theorem (`Mathlib/NumberTheory/Wilson.lean`).

## Files you own (create and edit only these)

- `lean/MMM/Acct/PLAN.md`
- `lean/MMM/Acct/*.lean` (module names `MMM.Acct.<Name>`)

Do not edit any other file.

## Part A — the plan (`lean/MMM/Acct/PLAN.md`)

Read the note in full. Write a table with one row for every lemma, corollary, proposition and theorem of the note, in order:

| label in the note | statement in one line | proposed Lean statement (as code) | which existing Lean theorems or Mathlib objects it needs | depends on | difficulty (easy / medium / hard) | status |

Say for each statement whether it already follows from what is in `lean/MMM/`, and how.

## Part B — Lean files

Formalize as far as you get, most valuable first:

1. The statement the note calls the Dwork form (claim C20 of `CLAIMS.md`): with N = (m − 1)/(p − 1), `#trees * m! ≡ (−p)^N (mod p^(N+1))`. One route: from `PTree.residue` together with the note's statement on m! (next item).
2. The note's Lemmas 3 and 4 and the corollary "Legendre's formula, with its residue": `m! = p^ν · ∏ m_j! · u` with `u ≡ (−1)^ν (mod p)`, ν = (m − s_p(m))/(p − 1). You may use Mathlib's Legendre formula for the valuation; the residue needs an argument (the note's, or a direct induction on m with Wilson's theorem).
3. The note's Lemma 1 on labelled trees, from `LTree.labelled_congruence`.
4. Whatever of the remaining statements you can reach.

Each file must compile on its own. Later files import earlier ones.

## Environment

- Lean 4 (`leanprover/lean4:v4.36.0-rc2`) with Mathlib of November 2026. Lean is not on the PATH. From Git Bash:

      cd lean
      export PATH="$USERPROFILE/.elan/bin:$PATH"
      mkdir -p .lake/build/lib/lean/MMM/Acct
      lake env lean MMM/Acct/Basic.lean -o .lake/build/lib/lean/MMM/Acct/Basic.olean

  The `-o` output is what lets a later file `import MMM.Acct.Basic`. The compiled files of everything in `lean/MMM/` that `lean/MMM.lean` imports already exist, so `import MMM.ResidueB` works.
- **Never** run `lake build`, `lake update`, `lake exe cache get`, or anything that downloads. Never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`.
- Run one compile at a time. Other agents compile on the same small machine: a compile usually takes 10 to 60 seconds, sometimes a few minutes. Be patient; do not start a second compile while one runs.
- Mathlib sources are in `lean/.lake/packages/mathlib/Mathlib`. This Mathlib is newer than most training data and many names have changed (the p-adic valuation of a natural number is `multiplicity p n : ℕ`; `padicValNat` names are deprecated aliases). **Grep Mathlib for a lemma before you use it; do not guess names.** Use slim imports, never `import Mathlib`.

## Rules

- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. A statement you cannot prove is left out of the Lean files and listed in `PLAN.md` with status "not done" and what blocked it. Do not state a weaker result under the name of a stronger one.
- If you find a step of the note that looks wrong or that you cannot make precise, that is important: describe it exactly in your report and in `PLAN.md`. Do not repair the note.
- Start each file with a comment that names your model, the date 2026-11-14 and "not human-reviewed".
- No git commands that change anything (`add`, `commit`, `push`, `checkout`, `stash`, ...). Do not launch other workers or agents.
- Work in short steps and save files often, so that a restart can continue from them. Time box: stop after about 80 minutes and report where you are.

## Report

The list of files and whether each compiles (paste the compile output of each), the exact Lean statements proved, the rows of the plan that are done and not done, any doubt about a step of the note, and `#print axioms` for your last theorem.

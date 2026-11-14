# W025 — Lean: a start on the Frobenius proof

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Goal

`paper/frobenius_proof.tex` (9 pages, compiled as `paper/frobenius_proof.pdf`) is a second, purely algebraic proof of the team's theorem on the p-adic valuation of Fuss–Catalan numbers. It works in the ring Λ = Z[y][[x]] with the Frobenius lift φ(f) = f(x^p, y^p) and the operator θ(f) = (f^p − φ(f))/p. No part of it is formalized. Your job is to **start** its formalization in Lean 4 with Mathlib: a plan for the whole note, and as many of its first statements as you can prove, in the order of the note. Nobody expects the whole proof; what matters is that everything you deliver compiles and that the report is exact about what is and is not done.

## Files you own (create and edit only these)

- `lean/MMM/Frob/PLAN.md`
- `lean/MMM/Frob/*.lean` (module names `MMM.Frob.<Name>`)

Do not edit any other file.

## Part A — the plan (`lean/MMM/Frob/PLAN.md`)

Read the note in full. Then write a table with one row for every definition, lemma, proposition and theorem of the note, in order:

| label in the note | statement in one line | proposed Lean statement (as code) | Mathlib objects it needs | depends on | difficulty (easy / medium / hard) | status |

Before proposing a Lean statement, look in Mathlib for what exists: `PowerSeries`, `Polynomial`, `MvPowerSeries`, `PowerSeries.map`, `PowerSeries.subst` or `evalNegHom`-style substitution, `Polynomial.expand`, `frobenius`, anything on δ-rings, λ-rings or Witt vectors (`Mathlib/RingTheory/WittVector`), divided powers and Hurwitz series. Say which objects you found and where. Decide how to represent Λ (for example `PowerSeries (Polynomial ℤ)`) and say why.

## Part B — Lean files

Formalize, in the order of the note, as far as you get. A reasonable first sequence:

1. The ring Λ and the map φ (f ↦ f(x^p, y^p)) as a ring homomorphism.
2. For a prime p: `f ^ p ≡ φ f` modulo p in Λ (for every f), so that θ is well defined; the definition of θ with `p * θ f = f ^ p - φ f`.
3. The basic identities of θ (its behaviour on sums and products), as stated in the note.
4. The system `F_δ = [δ = 0] x + φ(F_{δ+1}) + y θ(F_{δ+1})` (δ in Z/k): existence and uniqueness of the solution, and `F_0(x, p) = G`, if you get that far.

Each file must compile on its own. Later files import earlier ones.

## Environment

- Lean 4 (`leanprover/lean4:v4.36.0-rc2`) with Mathlib of November 2026. Lean is not on the PATH. From Git Bash:

      cd lean
      export PATH="$USERPROFILE/.elan/bin:$PATH"
      mkdir -p .lake/build/lib/lean/MMM/Frob
      lake env lean MMM/Frob/Basic.lean -o .lake/build/lib/lean/MMM/Frob/Basic.olean

  The `-o` output is what lets a later file `import MMM.Frob.Basic`.
- **Never** run `lake build`, `lake update`, `lake exe cache get`, or anything that downloads. Never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`.
- Run one compile at a time. Other agents compile on the same small machine: a compile usually takes 10 to 60 seconds, sometimes a few minutes. Be patient; do not start a second compile while one runs.
- Mathlib sources are in `lean/.lake/packages/mathlib/Mathlib`. This Mathlib is newer than most training data and many names have changed. **Grep Mathlib for a lemma before you use it; do not guess names.** Use slim imports, never `import Mathlib`.
- The existing files in `lean/MMM/` (the tree-symmetry proof) show the style used here; you do not need their content.

## Rules

- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. A statement you cannot prove is left out of the Lean files and listed in `PLAN.md` with status "not done" and what blocked it. Do not state a weaker result under the name of a stronger one.
- If you find a step of the note that looks wrong or that you cannot make precise, that is important: describe it exactly in your report and in `PLAN.md` (label, what the note says, what fails). Do not repair the note.
- Start each file with a comment that names your model, the date 2026-11-14 and "not human-reviewed".
- No git commands that change anything (`add`, `commit`, `push`, `checkout`, `stash`, ...). Do not launch other workers or agents.
- Work in short steps and save files often, so that a restart can continue from them. Time box: stop after about 80 minutes and report where you are.

## Report

The list of files and whether each compiles (paste the compile output of each), the exact Lean statements proved, the rows of the plan that are done and not done, any doubt about a step of the note, and `#print axioms` for your last theorem.

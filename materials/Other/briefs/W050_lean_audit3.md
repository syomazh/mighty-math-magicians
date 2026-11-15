# W050 — Independent audit of the Lean statements added since the first two audits

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". You are an **auditor**: your job is to try to break claims, not to confirm them.

## Why

The competition counts a claim as "Lean-verified" only if (a) the project builds on Lean v4.35.0 with Mathlib v4.35.0, (b) the declaration and everything it uses have no `sorry` and no axioms beyond `propext`, `Classical.choice`, `Quot.sound` (`native_decide` does not count), and (c) **its statement says what the report claims**. Calling something Lean-verified that fails this, or hiding a mismatch between a formal statement and its claim, is an integrity violation. Points (a) and (b) have been checked by full builds. Point (c) was audited on 2026-11-14 only for the main proof (`lean/AUDIT.md`). Everything added since has been read by one AI system only, the one that also coordinated the work. You are the second reader.

## What to audit

The report is `report/report.tex`; its Section "Lean" (search `\section{Lean}`) has a table "Declarations the report relies on, the claims they support, and the differences", and the status table (search `sec:status`) names Lean declarations for each claim. Audit every declaration in those two tables that is **not** covered by `lean/AUDIT.md`, that is:

1. the algebraic proof: `MMM.Frob.residue_frobenius`, `MMM.Frob.exact_valuation_blocked_frobenius`, `MMM.Frob.problem137_fussCatalan_frobenius`, `MMM.Frob.problem137_fussCatalan_exact_frobenius`, `MMM.Frob.residue_fussCatalan_frobenius`, and the intermediate declarations the table names (`exists_unique_cyclicSystem`, `evalY_solution_eq_treeGF`, `weight_solution`, `lead_solution`, `lead_mul_digitFact`, `carry`, `eval_of_carry`);
2. the lattice-path proof: `MMM.Path.kummer_exact`, `MMM.Path.choose_residue`, `MMM.Path.kummer_exact_digits`, `MMM.Path.choose_residue_digits`, `MMM.Path.multiplicity_choose_eq_carries`, `MMM.Path.problem137_fussCatalan_path` and its two companions, `MMM.Path.minWords_eq_slotCount`, `MMM.Path.slotCount_digits`, `MMM.Path.kummer_dvd`, and the definitions behind them (`Blk`, `Word`, `cntE`, `d`, `dW`, `minWords`, `slotCount`, `carryAt`, `digFact`);
3. around the main proof: `MMM.card_minimal_classes_mul` (the exact count), `MMM.PTree.excess` and its companions (the carry budget), `MMM.PTree.card_closed_modEq_classes` (closed families), `MMM.pow_dvd_prod_choose_profile`, `MMM.PTree.card_prof`, `MMM.PTree.prof` (level profiles);
4. the claims of independence: the commands in `lean/MMM/Frob/Deps.lean` (`#project_modules`, `#project_consts_in`, `#external_consts_matching`) and what the report and `lean/README.md` conclude from their output (in the build log: lines of `MMM/Frob/Axioms.lean`, `MMM/Path/Axioms.lean`, `MMM/AxiomsExtra.lean`). Does the command really follow every dependency inside the project? What does "refers to directly" leave out, and do the texts say so?

## What to do

- **Statements.** For each declaration: read the Lean statement and every project definition it mentions, down to Mathlib; restate in words what it says; compare with the claim in the report's tables and with the theorem of the written proof it is said to support (the appendices of the report). Look for: hypotheses that can never hold (vacuous statements), truncated natural-number subtraction or division that changes the meaning, conventions (`Nat.card` of an infinite type is 0, `multiplicity` conventions, `Nat.digits` for small bases, `0 ^ 0`, empty products), implicit arguments or instances that weaken the statement, quantifiers in the wrong order, a definition that does not mean what its name says, a "difference" that the report's table does not disclose.
- **Truth by test.** Test the statements numerically with your own program (`uv run python`): Kummer and the residue for all N < 150 and p in {2, 3, 5, 7}; the Fuss–Catalan statements for small p, k, n; the exact count against a direct enumeration of rotation classes for small trees; the profile divisibility for all small profiles; the carry-budget identity on all small trees. A mismatch between what the Lean statement says and the truth would be a finding of the highest severity (it would mean the statement is vacuous or I misread it).
- **Instances in Lean.** In a scratch file **outside the repository** (your scratchpad), derive concrete instances from the theorems (as `lean/AUDIT.md` describes: e.g. `2 ^ 3 ∣ Nat.choose 10 3 ∧ ¬ 2 ^ 4 ∣ Nat.choose 10 3` from `kummer_exact_digits`) and check that a deliberately false instance fails. Compile with `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean <your scratch file>` (never `lake build`).
- **Shortcuts.** Search the files added since 2026-11-14 14:30 (everything under `lean/MMM/Frob/`, `lean/MMM/Path/`, and `lean/MMM/ExactCount.lean`, `CarryBudget.lean`, `Closed.lean`, `Profile.lean`, `AxiomsExtra.lean`, `Dwork.lean`, `FussFormula.lean`, `Problem137.lean`, `ResidueForms.lean`, `NormalForm.lean`) for `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`, `implemented_by`, `opaque`, `extern`, `@[csimp]`, `set_option`, macros, `#eval`; say what each hit is.
- **Overclaims.** Read `lean/README.md` (the paragraphs added on 2026-11-15 and the table "Not checked by Lean"), the report's Section "Lean", and the abstract and status table of the report for sentences that say more than Lean proves.

## What you write

One new file, `lean/AUDIT3.md`, with a header naming Claude Fable 5.2 (a separate instance with no access to the orchestrator's session; brief W050), 2026-11-15, not human-reviewed. Structure as in `lean/AUDIT.md`: scope (give the commit hash from `git rev-parse HEAD`); verdict in three sentences; what you did; a table of findings with severity (WRONG: a statement does not say what is claimed or is false; GAP: a difference that is not disclosed, or a claim wider than the statement; COSMETIC), each with the place and a proposed correction; what the audit does not cover. If you find nothing in a category, say so in one line.

Change nothing else in the repository: no Lean file, no report, no ledger. No git command that changes anything. Do not run `lake build`.

## Report

Your verdict, the findings by severity, and what you did not cover.

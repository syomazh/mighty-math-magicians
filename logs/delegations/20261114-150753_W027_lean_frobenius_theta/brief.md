# W027 — Lean: the Frobenius proof, part 2 (the operator θ and the system)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-14. You are a worker (see `CLAUDE.md`, "If you are a worker").

## Where things stand

`paper/frobenius_proof.tex` is an algebraic proof in the ring Λ = Z[y][[x]]. A first worker (W025) wrote, in `lean/MMM/Frob/`:

- `Basic.lean`: `Lambda := PowerSeries (Polynomial ℤ)`, `frobeniusLiftRingHom p hp : Lambda →+* Lambda` (f ↦ f(x^p, y^p)), and its values on the two variables.
- `Theta.lean`: `modPoly`, `modSeries p : Lambda →+* PowerSeries (Polynomial (ZMod p))` (reduction modulo p), `coeff_modSeries`, `modPoly_expand`, `modSeries_expand`.
- `PLAN.md`: a table of all statements of the note with their status.

All of this compiles (the `.olean` files are in `lean/.lake/build/lib/lean/MMM/Frob/`). Nothing after the definition of φ is proved. Read these three files and the note's Lemma `lem:theta` (line 115 of the `.tex`), Lemma `lem:system` (line 141), the definition of the weight (line 177), Lemma `lem:lower` (line 191) and Corollary `cor:div` (line 203).

## Files you own

- Everything in `lean/MMM/Frob/` (you may add files and edit the existing ones, including `PLAN.md`; keep what compiles compiling).

Do not edit any file outside `lean/MMM/Frob/`.

## Targets, in this order (exact Lean statements; names may be yours)

Write `φ` for `frobeniusLiftRingHom p hp`.

1. **Frobenius modulo p.** For a prime p and every `f : Lambda`:

       modSeries p (φ f) = (modSeries p f) ^ p

   Hint from W025: `PowerSeries.map_frobenius_expand` and `Polynomial.map_frobenius_expand` in Mathlib give the local identities (characteristic p: the p-th power map is the Frobenius); combine them with `modPoly_expand` and `modSeries_expand`. Check the exact hypotheses of those Mathlib lemmas by reading them.

2. **Divisibility (the note's Lemma θ).** For a prime p and every `f : Lambda`:

       ∃ g : Lambda, f ^ p - φ f = (p : Lambda) * g

   From 1: `modSeries p (f ^ p - φ f) = 0`, so every integer coefficient of every polynomial coefficient is divisible by p (`ZMod.intCast_zmod_eq_zero_iff_dvd`, `Polynomial.C_dvd_iff_dvd_coeff`), and g can be built coefficient by coefficient (`PowerSeries.mk`).

3. **No p-torsion and the definition of θ.** `(p : Lambda) * g = (p : Lambda) * g' → g = g'`; then

       noncomputable def theta (p : ℕ) [Fact p.Prime] (f : Lambda) : Lambda
       theorem theta_spec : (p : Lambda) * theta p f = f ^ p - φ f

4. **The identities of θ** exactly as the note states them in and after Lemma θ (behaviour on products and sums, on x and on y, and whatever else the note uses later). State each as its own theorem.

5. **The system (the note's Lemma `lem:system`).** Existence and uniqueness of the family `F : ZMod k → Lambda` (or `Fin k → Lambda`) with `F δ = [δ = 0] x + φ (F (δ + 1)) + y * θ (F (δ + 1))`, and the note's statement relating `F 0` at `y = p` to the generating series of the trees. If the full lemma is out of reach, prove what you can (for example uniqueness, or the case k = 1) and say exactly what is missing.

6. If you get further: the weight and the note's Lemma `lem:lower` and Corollary `cor:div`.

After each target that compiles, update `PLAN.md` (status column) before going on.

## Environment

- Lean 4 (`leanprover/lean4:v4.36.0-rc2`) with Mathlib of November 2026. Lean is not on the PATH. From Git Bash:

      cd lean
      export PATH="$USERPROFILE/.elan/bin:$PATH"
      lake env lean MMM/Frob/ThetaDef.lean -o .lake/build/lib/lean/MMM/Frob/ThetaDef.olean

  The `-o` output is what lets a later file `import MMM.Frob.ThetaDef`.
- **Never** run `lake build`, `lake update`, `lake exe cache get`, or anything that downloads. Never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`.
- Run one compile at a time. Other agents compile on the same small machine: a compile usually takes 10 to 60 seconds, sometimes a few minutes. Be patient; do not start a second compile while one runs.
- Mathlib sources are in `lean/.lake/packages/mathlib/Mathlib`. This Mathlib is newer than most training data and many names have changed. **Grep Mathlib for a lemma before you use it; do not guess names.** Use slim imports, never `import Mathlib`.

## Rules

- No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`. A statement you cannot prove is left out of the Lean files and listed in `PLAN.md` with status "not done" and what blocked it. Do not state a weaker result under the name of a stronger one.
- If a step of the note looks wrong or cannot be made precise, describe it exactly in your report and in `PLAN.md`. Do not repair the note.
- Every file starts with a comment naming the model(s) that wrote it, the date 2026-11-14 and "not human-reviewed".
- No git commands that change anything. Do not launch other workers or agents.
- **Use the time.** The previous worker stopped after 20 minutes with targets 1 to 5 untouched. Work through the list for about 80 minutes; when one target is done, go on to the next. Save files often so that a restart can continue.

## Report

For each target: done or not, the exact Lean statement as it is in the file, the compile output of each file, what blocked the first target you could not finish, and `#print axioms` for your last theorem.

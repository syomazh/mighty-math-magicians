# W048 — Lean: the exact number of minimal classes for q = p (claim C8)

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker".

## What this is

`paper/main.tex`, Corollary "exact count" (label `cor:exact-count`, with its proof; read it and the two propositions it uses): for q = p prime, m leaves, s_p(m) = (p − 1)t + 1 and base-p digits m_j of m, the number of rotation classes of the smallest size p^t is

    N_min = (pt)! / (t! · p^t · ∏_j m_j!).

It is the one statement of the main text that Lean has not checked. Lean already has the residue of this number modulo p; this brief asks for the exact value.

## What exists (read these files first; change none)

- `lean/MMM/Trees.lean` (`PTree`), `Reduction.lean` (`IsMinimal m t T`: m leaves and d = t; `rotSetoidOn`; `card_minimal_eq : Nat.card {T // IsMinimal m t T} = p ^ t * Nat.card (Quotient (rotSetoidOn (IsMinimal m t)))`).
- `lean/MMM/LTree.lean` (`LTree p α`: trees with labelled leaves; `lab`, `Good`: the labels of the leaves are pairwise different; `nodes`), `Atoms.lean` (`minimalEquiv`: the minimal trees are the carry-free trees of atoms), `Retype.lean`, and **`Residue.lean`**: read the proof of `PTree.residue` (line 227 on) step by step. It goes: all trees ≡ minimal trees; minimal trees ≃ typed trees; `exists_distinct_fact` (renaming equal atoms one at a time multiplies the count by the multiplicities: `Nat.card (WithContent p D.val) = factProd M * Nat.card (WithContent p M)`); and `labelled_congruence`: `Nat.card {T : LTree p α // T.Good ∧ T.lab = S} ≡ (-p)^t`. Your theorem replaces the last congruence by an exact count and keeps the equalities before it.
- `lean/MMM/FussFormula.lean`: `fuss_catalan_formula (hq : 1 ≤ q) (n) : ((q - 1) * n + 1) * Nat.card {T : PTree q // T.nodes = n} = Nat.choose (q * n) n`; `lean/MMM/ExactB.lean`: `card_nodes_eq_card_leaves`.
- `lean/MMM/DigitsCarry.lean`: `dig p j m`; `Digits.lean`: `ds`.

The project is on **Lean v4.35.0 with Mathlib v4.35.0**; lemma names must be checked in `lean/.lake/packages/mathlib/Mathlib`.

## File you own

`lean/MMM/ExactCount.lean` (new). Nothing else.

## Statements

```lean
/-- The number of p-ary trees whose (p - 1) t + 1 leaves carry the labels of S, each once. -/
theorem card_labelled_mul_factorial [Fact p.Prime] {α : Type} [DecidableEq α] (t : ℕ) (S : Finset α)
    (hS : S.card = (p - 1) * t + 1) :
    Nat.card {T : LTree p α // T.Good ∧ T.lab = S} * t.factorial = (p * t).factorial

/-- Corollary "exact count", for the minimal trees. -/
theorem card_minimal_mul_factorials (p : ℕ) [Fact p.Prime] (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    Nat.card {T : PTree p // PTree.IsMinimal m t T} *
        (t.factorial * ∏ j ∈ Finset.range m, (dig p j m).factorial) = (p * t).factorial

/-- Corollary "exact count": N_min · t! · p^t · ∏ m_j! = (p t)!. -/
theorem card_minimal_classes_mul (p : ℕ) [Fact p.Prime] (m t : ℕ) (ht : (p - 1) * t + 1 = ds p m) :
    Nat.card (Quotient (PTree.rotSetoidOn (PTree.IsMinimal (p := p) m t))) *
        (t.factorial * p ^ t * ∏ j ∈ Finset.range m, (dig p j m).factorial) = (p * t).factorial
```

(Adjust implicit arguments and the form of the digit product to what `Residue.lean` uses, and say what you changed. `p` need not be prime for the first statement if the proof does not need it.)

## Proof plan

1. **`card_labelled_mul_factorial`.** A labelled tree with pairwise different labels is a shape (a `PTree p`) together with the list of its labels from left to right. So the trees with label set S, |S| = s, correspond to pairs (shape with s leaves, list without repetition with set S); there are `s!` such lists (`Finset` / `List.Nodup` counting: `Finset.card_perms…`, `List.Nodup`, `Fintype.card_perm`, or count bijections `Fin s ≃ S`: `Fintype.card_equiv`; grep). So the number is `s! * Nat.card {U : PTree p // U.leaves = s}`. A p-ary tree with s = (p − 1)t + 1 leaves has t nodes, and `((p - 1) * t + 1) * Nat.card {U // U.nodes = t} = Nat.choose (p * t) t`. Hence the number times t! is `(s - 1)! * (p t)! / ((p t - t)!)`, and `s - 1 = (p - 1) t = p t - t` (`Nat.choose_mul_factorial_mul_factorial`, `Nat.factorial_succ`). If the bijection with lists is awkward, an alternative is a recursion on the tree that splits the label set among the p subtrees; choose what you can finish.
2. **`card_minimal_mul_factorials`.** Follow the proof of `PTree.residue`: every equality of cardinalities used there before `labelled_congruence` is an equality, not a congruence; with step 1 in place of `labelled_congruence` you get `Nat.card {minimal} * (∏ m_j!) * t! = (p t)!` up to the form of the product of the digit factorials (`factProd` of the multiset of atoms; `Residue.lean` converts it to `∏ j ∈ range m, (dig p j m)!` somewhere: find that lemma).
3. **`card_minimal_classes_mul`** from 2 and `card_minimal_eq`.

## Order of work, and what to do if it does not all fit

1, 2, 3. Keep the file compiling. If something cannot be proved, leave it out, keep what depends on it conditional under a different name with the missing statement as an explicit hypothesis, and say so.

## Environment and rules

Lean is not on the PATH: `cd lean && export PATH="$USERPROFILE/.elan/bin:$PATH" && lake env lean MMM/ExactCount.lean -o .lake/build/lib/lean/MMM/ExactCount.olean`. **Never run `lake build`, `lake update` or anything that downloads; never edit `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`, `MMM.lean` or any existing file.** Grep Mathlib for every lemma name. No `sorry`, `admit`, `axiom`, `native_decide`, `unsafe`; no theorem with conclusion `True`; no theorem of Mathlib about valuations of factorials or binomial coefficients. The file starts with a comment naming Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-15, not human-reviewed. No git command that changes anything. Other agents compile on this laptop: one compile at a time.

## Report

For each statement: done or not, the exact statement as in the file, the compile result, `#print axioms` for the last theorem, every change to a statement of this brief and why, what you did not verify.

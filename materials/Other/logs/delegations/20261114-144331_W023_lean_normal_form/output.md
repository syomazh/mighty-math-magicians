Done. The file compiles cleanly and the theorem is machine-checked with only Lean's three standard axioms.

## Summary

**What I did:** Created `lean/MMM/NormalForm.lean` (the only file I touched) proving the paper's Lemma "Normal form": the normal-form rotation equivalence `Rot` equals the equivalence closure of single rotations.

**Final statements** (in `namespace MMM.PTree`):

```lean
inductive RotStep {p : ℕ} [NeZero p] : PTree p → PTree p → Prop
  | here (f : Fin p → PTree p) : RotStep (node f) (node fun i => f (i + 1))
  | under (f : Fin p → PTree p) (i : Fin p) (T : PTree p) (h : RotStep (f i) T) :
      RotStep (node f) (node (Function.update f i T))

theorem rot_iff_eqvGen {p : ℕ} [NeZero p] (S T : PTree p) :
    Rot S T ↔ Relation.EqvGen RotStep S T
```

**One deviation from the brief, as it permits:** the second constructor is named `under`, not `below`. I isolated this experimentally: an inductive over `PTree p` whose recursive constructor is literally named `below` fails the Lean kernel ("invalid occurrence of datatype … must be applied to the parameters"), while the identical declaration named `under` elaborates perfectly, with `{p : ℕ} [NeZero p]` exactly as specified. Meaning unchanged; the theorem statement is exactly the required equivalence. Supporting lemmas: `RotStep.rot`, `rot_of_eqvGen`, `eqvGen_update`, `eqvGen_node`, `eqvGen_shift`, `eqvGen_of_rot`.

**Compile output:** `lake env lean MMM/NormalForm.lean -o .lake/build/lib/lean/MMM/NormalForm.olean` → no errors, no warnings (run several times; final run clean).

**Axioms:** `#print axioms MMM.PTree.rot_iff_eqvGen` (run temporarily, then removed) →
`'MMM.PTree.rot_iff_eqvGen' depends on axioms: [propext, Classical.choice, Quot.sound]` — no `sorryAx`.

**What I could not do / did not verify:** No `sorry`, `admit`, `axiom`, `native_decide`, or `unsafe` anywhere, and nothing is left as an explicit hypothesis — the deliverable is proved outright. I did not run `lake build` (per the brief) and ran no git commands; the orchestrator should recompile and review. Proof structure follows the brief's suggestion: (⇐) each step is a `Rot.node` (shift 1 at the root / shift 0 with the IH at one child), closed under `EqvGen` via `Rot`'s refl/symm/trans; (⇒) induction on `Rot`, rotating the root `r` times by iterating `here` (induction on `r.val`), then replacing children one at a time over a `Finset (Fin p)` using the lift `eqvGen_update`.

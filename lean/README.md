# Lean formalization

Written by Claude Fable 5.2 (AI, orchestrator), started 2026-11-14. Not human-reviewed.

This folder is a Lean 4 project that depends on Mathlib. A statement listed below as **checked** is one that Lean has compiled without `sorry` and without extra axioms beyond Lean's standard ones; nothing else in this folder counts as verified. The list is kept honest by `lake build` (see "How to check").

## Status

See the table at the end of this file. It is updated only after a successful build.

## Layout

| File | Content |
|---|---|
| `MMM/Digits.lean` | base-p digit sums: the recursion, s(p·n) = s(n), positivity, subadditivity (no factorials) |
| `MMM/Trees.lean` | p-ary trees, rotation equivalence, the number d of asymmetric nodes, the lower bound (Step 2) |
| further files | listed in the status table when they compile |

## How to check

Lean is installed with `elan` in the user's home folder (`~/.elan`), not on the PATH. From this folder:

    export PATH="$USERPROFILE/.elan/bin:$PATH"     # Git Bash on Windows
    lake exe cache get                             # once: fetch Mathlib's prebuilt files
    lake build                                     # compiles everything; any error or `sorry` shows here

`lean-toolchain` pins the Lean version; `lake-manifest.json` pins Mathlib. The folder `.lake/` (several GB of downloaded and built files) is not in git.

## What "checked" does and does not mean

- Lean checks that each proof follows from the definitions **as written in the file**. Whether a definition says what the paper means (for example, that `Rot` is the paper's rotation equivalence) is a matter of reading the definitions, which are short.
- A statement that is not in the table is not machine-checked, however many tests it has passed.

/-
Written by Claude Fable 5.2 (orchestrator), 2026-11-14. Not human-reviewed.
A dependency audit: which declarations of this project does a theorem really use?

`#project_modules thm` follows the proof term of `thm` through every declaration of the project
(modules `MMM.*`; Mathlib cannot depend on the project) and prints the modules in which the
declarations it reaches live. `#project_consts_in thm Module` prints the declarations reached
in one module.

Purpose: to make "the Frobenius proof uses no symmetry of trees" a statement that Lean checks.
The lines at the end of `MMM/Frob/Axioms.lean` show that the Frobenius theorems reach, outside
`MMM/Frob/` and the digit files, only the definition of the trees (`MMM/Trees.lean`), the
definition `BlockedAt` (`MMM/Blocked.lean`) and three elementary facts about the number of
leaves (`MMM/Divisibility.lean`); no rotation, no class of trees, no cherry.
-/
import Lean

open Lean Elab Command

namespace MMM.Deps

/-- All declarations reached from `n` through types and values, descending only into
declarations of the modules `MMM.*`. -/
partial def collect (env : Environment) (n : Name) (seen : NameSet) : NameSet :=
  if seen.contains n then seen else
  let seen := seen.insert n
  match env.getModuleIdxFor? n with
  | none => seen
  | some idx =>
    let modName := env.header.moduleNames[idx.toNat]!
    if modName.getRoot != `MMM then seen else
    match env.find? n with
    | none => seen
    | some ci =>
      let fromVal : Array Name := match ci with
        | .thmInfo v => v.value.getUsedConstants
        | .defnInfo v => v.value.getUsedConstants
        | .opaqueInfo v => v.value.getUsedConstants
        | _ => #[]
      (ci.type.getUsedConstants ++ fromVal).foldl (fun s c => collect env c s) seen

/-- The module of the project in which a declaration lives, if any. -/
def projectModule? (env : Environment) (d : Name) : Option Name :=
  match env.getModuleIdxFor? d with
  | none => none
  | some idx =>
    let m := env.header.moduleNames[idx.toNat]!
    if m.getRoot == `MMM then some m else none

elab "#project_modules " id:ident : command => do
  let env ← getEnv
  let n ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
  let deps := collect env n {}
  let mut mods : NameSet := {}
  let mut cnt : Nat := 0
  for d in deps.toList do
    if let some m := projectModule? env d then
      mods := mods.insert m
      cnt := cnt + 1
  let sorted := (mods.toList.map toString).toArray.qsort (· < ·)
  logInfo m!"{n} reaches {cnt} declarations of the project, in the modules {sorted}"

elab "#project_consts_in " id:ident m1:ident : command => do
  let env ← getEnv
  let n ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
  let deps := collect env n {}
  let mut out : Array String := #[]
  for d in deps.toList do
    if projectModule? env d == some m1.getId then out := out.push (toString d)
  logInfo m!"{n} reaches in {m1.getId}: {out.qsort (· < ·)}"

end MMM.Deps

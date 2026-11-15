Both requested theorems were already complete, with their statements unchanged:

- `MMM.choose_add_prime_modEq`
- `MMM.choose_mul_add_modEq_one_action`

The proof uses the translation action on `r`-subsets and the fixed-point congruence, with no forbidden shortcuts.

I recompiled `lean/MMM/LegendreChoose.lean` alone successfully, with no errors or warnings. Axiom output:

```text
'MMM.choose_mul_add_modEq_one_action' depends on axioms:
[propext, Classical.choice, Quot.sound]
```

**No files were created or changed during this continuation.** I did not run a full project build or perform a human review.

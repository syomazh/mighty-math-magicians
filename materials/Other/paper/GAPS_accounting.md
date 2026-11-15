# Gaps and qualifications in W014, the accounting proof

Model: `moonshotai/kimi-k3.1-pro` (Open Math OS), 2026-11-13. This is an unreviewed AI draft, not a human-signed theorem.

## Mathematical gaps

No `\GAP` marker is used. All steps in L1, L2, L3, the theorem, and the sandpile proposition are supplied in `alt_proof_accounting.tex` for general `k`. That does **not** mean the proof is independently reviewed or human signed.

## Qualifications, not suppressed gaps

- The problem's request to avoid factorial valuations requires a qualification: this argument derives the valuation of `m!` from digit-forest symmetry. It does not quote Legendre's formula, but it is not a factorial-valuation-free substitute for the skeleton proof. See the explicit remark in the note.
- The original Idea 2 says that every stable positive ring state is encoded by base-`p` digits of `m mod (p^k-1)`. If `p^k-1 | m`, the ordinary remainder `0` is not the correct stable representative. The stable representative is `p^k-1` (all `p-1` digits); for `m=(p^k-1)n+1` it is `1`, as intended. The first general-state tests explicitly observed `[1,1]` for `p=2,k=2,m=3`. The note states the correct general case.
- The theorem's first congruence is written in `Z`; with `mod p^(t+1)` the right side may be regarded as an integer. It is still true in `Z_p` because the factor is nonzero (the shown ordering fixes its residue unambiguously).
- The L1/L2 small-object check is limited by both `m!` and the number of ordered labelled trees. It is not an exhaustive proof for all `m`. Extended exact-integer formula checks are formula checks, not independent enumerations of those larger labelled sets.
- No independent model or human has adversarially reviewed this proof. The numerical checks do not establish human understanding or sign-off.

## Verification record and tool failures

Output is in `experiments/E004_accounting_proof/`. The final output is `output.txt`; intermediate output files show debugging and are retained rather than silently discarded.

- The very first enumerator admitted empty child blocks, causing `RecursionError: maximum recursion depth exceeded` in explicit tree enumeration. It also returned the empty family rather than one empty forest in digit forests, causing failed counts. None is a mathematical failure of L1 or L3.
- A version of `ordered_orbit` canonicalized the ordered representatives, thereby collapsing each orbit to one object. It was corrected to build actual child-tuple products with rotations at every node. The raw failed check is retained in `trees.txt`.
- `nu(m)` was mistyped in the first implementation; the erroneous sandpile failures are retained in `sand.txt`. These were followed by base-`p` carry count checks using the stated formula.
- For the two-site binary ring the first expected final state used `m mod 3` without replacing the zero remainder of a positive multiple. The output `ring final state p=2,k=2,m=3: [1, 1], expected=[0, 0]` is retained in `sand.txt`; the second value is the omitted `[p-1,...,p-1]` case, stated in the proposition.
- Explicit forest/enumerator ranges are recorded in the output and README; no hidden ignored failure is intended. The full-forest checks are small, whereas longer ranges test the closed formula recursion.

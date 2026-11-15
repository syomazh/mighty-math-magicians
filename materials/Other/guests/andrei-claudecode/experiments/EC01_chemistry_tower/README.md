# EC01 — the chemistry tower: plane trees, stereoisomers, structural isomers

- **Date:** 2026-11-14, by Claude Fable 5.2 (AI) in a second Claude Code session working with a team member. **Not the orchestrator; not human-reviewed.** Guest folder `guests/andrei-claudecode/`; moved here unchanged from `experiments/EC01_chemistry_tower/` of a local clone (local commit 8cbcf1c, never pushed), except for the paths in this file.
- **Belongs to:** `guests/andrei-claudecode/notes/2026-11-14_chemistry_deep_dive.md`.
- **Folder name:** `EC01` instead of the next `E0xx` number, so that it cannot collide with the orchestrator's numbering.

## Goal

Check, against numbers printed in the chemical literature, that the team's rotation classes for p = 3 are the stereoisomers of the monosubstituted alkanes C_nH_(2n+1)X, and test every new statement of the chemistry note.

## Hypothesis

The three ways of comparing the three branches of a carbon (ordered; up to rotation; up to all permutations) give plane ternary trees, stereoisomers and structural isomers. A stereoisomer carries exactly 3^d plane trees, d = number of carbons whose three branches are not all alike.

## Method

`python3 guests/andrei-claudecode/experiments/EC01_chemistry_tower/run.py` from the repository root; `output.txt` is its output after a two-line header (standard library only; about one minute; run with the system Python 3.13.7 because `uv` is not installed on this machine). Rotation classes are generated as integer ids up to 14 carbons (110,500 classes at n = 14); plane trees are listed one by one up to 8 carbons (43,263 trees); symmetry groups are built as permutation groups of the hydrogens up to 8 carbons.

Literature numbers typed into the script: Robinson–Harary–Balaban 1976, Table 2 (read from the scan on the OEIS server); OEIS A000598, A000620, A000621, A000625, A005628 (JSON records); Eriksen–Merkle 2026, Tables 3.2.1 and 3.2.2 (text of arXiv:2609.02932); the three permutations of Gilson–Irikura's worked example "tert-butyl radical".

## Results (27 checks, all pass)

| Part | Statement | Result |
|---|---|---|
| A1–A6 | For n = 0..14: rotation classes = stereoisomers (A000625); classes up to all permutations = structural isomers (A000598); classes equal to their mirror image = achiral (RHB Table 2); the rest = chiral (A005628); classes with no stereogenic centre = Pólya's q (A000621); the difference = Blair–Henze's "stereoisomeric" column (A000620). | pass |
| A7 | "Achiral" and "no stereogenic centre" first differ at 9 carbons, by the two meso-type forms of 3,5-dimethylheptan-4-ol. | pass |
| B1–B2 | Σ over stereoisomers of 3^d = binom(3n, n)/(2n+1) for n ≤ 14; by listing plane trees, every stereoisomer carries exactly 3^d of them for n ≤ 8. | pass |
| B3 | The number of plane trees over a structural isomer (the orbit of the full symmetric group, as in Konvalinka) is the sum of 3^d over its stereoisomers. For n = 4: 1, 9, 18, 27 against 1, 9, 9, 9, 27. | pass |
| C1–C2 | Stereoisomers by number of stereogenic centres, and structural isomers by number of asymmetric carbons, equal Tables 3.2.2 and 3.2.1 of Eriksen–Merkle for n = 1..11. | pass |
| D1 | Pólya's 1936 equation (24), Q = 1 + x·Q·Q(x², y²) + x·y·[Q³ − 3·Q·Q(x², y²) + 2·Q(x³, y³)]/6, reproduces "structural isomers by asymmetric carbons" for n ≤ 14. | pass |
| D2–D4 | Pólya's remarks: α asymmetric carbons first occur at n = 2α + 2 in a single structure (α ≤ 6); the rule "2^α stereoisomers" first fails at C13H27OH, for a single structure (three sec-butyl groups on the carbinol carbon: 4 stereoisomers, not 8); where it fails the true number is smaller. | pass |
| D5–D6 | The team's deformed equation for p = 3, A = 1 + x·A(x³, y³) + x·y·[A³ − A(x³, y³)]/3, reproduces "stereoisomers by d" for n ≤ 14; y = 3 gives the Fuss–Catalan numbers, y = 1 Pólya's equation (25). | pass |
| E1–E4 | For n = 1..14: the least d is t = (s_3(2n+1) − 1)/2; the number of stereoisomers attaining it is (3t)!/(t!·3^t·∏ m_j!) and is ≡ (−1)^t/∏ m_j! mod 3; the largest symmetry number 3^(n−t) is the largest power of 3 dividing (2n+1)!. | pass |
| F1–F2 | For n ≤ 8 the rotations that keep a stereoisomer form a group of order 3^(n−d) acting on the hydrogens; it has at least s_3(2n+1) orbits, with equality (orbit sizes = the digits) for the most symmetric ones. **Equality does not characterise them:** 3-ethylpentan-3-ol (n = 7) also reaches it. | pass |
| F3–F4 | The three permutations of nine hydrogens printed by Gilson–Irikura for the tert-butyl radical generate groups of order 81 and 162; the group of order 81 is, permutation for permutation, the tree symmetry group of tert-butyl. | pass |
| G1 | The 16 structural / 20 stereoisomeric alcohols with up to 5 carbons, each with name, d, class size and symmetry number; the plane trees add up to 1, 3, 12, 55, 273. | pass |

## Analysis

- The identification "rotation classes for p = 3 = stereoisomers" now rests on three independent printed tables (1932/1976 counts, the 2026 table by stereogenic centres, and the chiral/achiral split), not only on the first terms of one OEIS entry.
- The team's deformed equation was re-derived here from scratch in the carbon-indexed form and agrees with enumeration; this is an independent check of claim C18(a) for p = 3, k = 1.
- Names in Part G were typed by hand from the SMILES strings and checked only by the counts (8 structural pentanols, 3 of them chiral). A chemist should read the table once.

## Next steps

None planned. If the orchestrator adopts this, renumber the folder and add the references of the note to `references/README.md`.

# guests/andrei-claudecode

Written by Claude Fable 5.2 (claude-fable-5-2) in Claude Code (a local session on a team member's laptop), started by Andrei, 2026-11-14. Not human-reviewed.
Nothing here is part of the team's record (see `AGENTS.md`).

This is not the session that wrote `guests/andrei-claude/` (the proof on lattice paths). It wrote nothing there and has its own tag for that reason.

## Read this first: what is worth your time here

Written 2026-11-14 at about 19:00 PT, after comparing this folder with the team's own work on connections at `origin/main` fdd8fd5 (`notes/2026-11-14_connections_ranked.md`, the briefs W029 and W030, the review of W030). **Most of this folder repeats what the team already has, or is colour.** Four items are not in the team's files and bear on the chemistry slide and on brief W029, which was still running when this was written.

1. **A word that a chemist will read as false.** `connections_ranked.md`, line 139, says "each asymmetric carbon has three distinguishable staggered positions". In chemistry an asymmetric carbon has four different groups. The team's notion is wider: chirality centres and prochirality centres together. The ethyl group is the smallest case where the two differ. This is lead L1 of W029 (homotopic against enantiotopic). See `PROPOSALS.md`, entry 1, and section 5 of the chemistry note.
2. **Printed sources, opened in scan.** Robinson, Harary and Balaban (1976), page 358, give the group at a carbon as the cyclic group of order 3, because the corner of the tetrahedron that points to the root stays fixed: a primary source for "rotated, not reflected". Blair–Henze (1932), Pólya (1936) and Eriksen–Merkle (2026) were read in part as well. The ranked note lists the first three as not opened and the sources note lists the last as an unopened lead. See `PROPOSALS.md`, entries 2 and 3, and sections 1 and 11 of the chemistry note.
3. **The classes of interchangeable hydrogens, already computed up to 8 carbons.** Lead L4 of W029 asks for this up to 5. There are at least s_3(2n+1) classes, and the most symmetric groups have exactly that many, with sizes given by the digits. **The converse fails, first at 7 carbons** (3-ethylpentan-3-ol), which a run up to 5 does not show. Also: tri-tert-butylcarbinol, with 27 hydrogens on one perfect group, is a real compound according to a bibliographic record and Wikipedia (Bartlett and Schneider 1945; paper not read). See EC01, checks F1 and F2, and section 6 of the chemistry note.
4. **Pólya's equation (24)**, a two-variable equation of the same shape as the deformed equation of the Frobenius note, for the full symmetric group and another statistic. A credit for the paper, not for the talk, and a person should read page 436 of the scan first. See `PROPOSALS.md`, entry 4, and EC01, check D1.

The rest, so that nobody spends time on it:

- **Already in the team's files:** the three counts and "reflections merge the two sec-butyls"; the 81 of tert-butyl (the team's source, Domalski and Hearing, is the better one); the most symmetric groups from the digits.
- **Colour, no step of the method:** the chemists' 2^α rule against the 3^d law; melting points.
- **Low value: the polymer note.** Its headline, the class size as the odds of an isomer, is what the team already has for p = 2 with a published source (the Yule model, `notes/2026-11-14_motivation_and_connections.md`, section 12). Here it is for a uniform model of a one-pot reaction and has no published source. By the scoring of the ranked note it would sit in the middle of the table. The gel point and the degree of branching share only the numbers.
- **A small extra:** EC03, a check of the path proof (C24) by a different method.

## Asked to do

In chat, on 2026-11-14:

1. "I have been tasked with investigating connections of our problem with other things such as the chemistry. Look deeply into some stuff."
2. "Dive deeper on the polymers and decide which one seems better for motivation."
3. "Look at updates, I think mmazin added something interesting", and then: move the two notes into a guest folder and bring the clone up to date.

## Done

- **Chemistry, from the sources.** `notes/2026-11-14_chemistry_deep_dive.md` with 27 checks in `experiments/EC01_chemistry_tower/`.
  - For p = 3 the three ways of comparing the branches of a carbon give the chemists' three counts: plane trees, stereoisomers (our classes), structural isomers (Konvalinka's orbits). All three agree with printed tables up to 14 carbons.
  - Blair–Henze 1932, Pólya 1936 and Robinson–Harary–Balaban 1976 were opened in scan and read in part. The team's `notes/2026-11-14_connections_ranked.md`, section 3.3, lists them as not opened.
  - Pólya's 1936 paper has a two-variable equation of the same kind as the deformed equation of the Frobenius note, for the full symmetric group and another statistic (section 4 of the note).
  - A dictionary for chemists: the team's d counts chirality centres and prochirality centres. The chemists' "asymmetric carbon" is a narrower notion (section 5).
  - The 81 of tert-butyl is the published symmetry number of the tert-butyl radical with rotating methyl groups, and the published permutations generate the symmetry group of our tree (section 6).
- **Polymers.** `notes/2026-11-14_polymers_deep_dive.md` with 17 checks in `experiments/EC02_polymers/`.
  - A ring-free molecule of n monomers AB_(f−1) is a rooted (f−1)-ary tree, and n labelled monomers form n! × FussCatalan(f−1, n) such molecules (found by listing bond patterns, with no trees in the program).
  - In the ideal one-pot reaction all bond patterns with the same number of bonds are equally likely (a lemma with a five-line proof), so an isomer occurs with probability p^d/FussCatalan. For AB3 and four units: 27 : 9 : 9 : 9 : 1 of 55.
  - The gel point of Flory's theory is the radius of convergence of the Fuss–Catalan series.
- **A second reading of the path proof (C24).** I read `guests/andrei-claude/notes/2026-11-14_path_proof/path_proof.tex` line by line and re-derived every lemma; I found no failing step. `experiments/EC03_path_proof_check/` tests its statements by a different method (328 + 26 cases, all pass).
- Proposed claims in `CLAIMS_PROPOSED.md`, six proposals in `PROPOSALS.md`, the work blocks in `JOURNAL.md`.

## Not done, not verified

- **No review.** No other model and no fresh agent has read the two notes. No person has signed anything here. **No chemist has read any of it.**
- **The chemistry is illustration, not the reason for the problem.** The polymer note uses the word "motivation"; after writing it I was asked whether it is real motivation and answered no (journal, third entry). The reason for the problem is mathematical. What the chemistry gives is a defence of the choice of group (chemists count exactly these classes), a picture for 55 = 1 + 9 + 9 + 9 + 27, and something to remember.
- **The "odds of an isomer" statement has no printed source.** It is proved here in five lines for an ideal model and simulated once. Whether polymer chemists state it was not found in a short search.
- **Sources read only in part or not at all** are marked one by one in the last two sections of each note. The main ones: Flory 1952 was not opened; the IUPAC glossary was read only through a summarising fetch tool; Pólya's equation (24) was read by an AI from a German scan and a human should look at page 436.
- **The reading of C24 is by the same model as its author and as the orchestrator.** It is a second independent reading, not a review by a different model. I propose no change of grade.
- Not read in this session: `paper/main.tex` and `paper/accounting_proof.tex` at the current commit, `lean/`. The statement that the path proof has the same skeleton as the main proof rests on the talk deck and on the earlier state of the paper.
- The names of the alcohols in the chemistry note were derived by hand from the structures. The counts are checked; the names are not.
- `uv` is not installed on this machine. The three scripts were run with the system Python 3.13.7 and use the standard library only.

## How these files got here

The two notes and their experiment folders were first written in `notes/` and `experiments/` on the local `main` of this clone (local commits 8cbcf1c and 6789468, 13:17 and 13:44 PT), when the clone was at 9198157 and had no `AGENTS.md`. They were never pushed: the push was refused, the account had read access only. On 2026-11-14 at about 18:15 PT they were moved here on the branch `guest/andrei-claudecode`, started from `origin/main` at 2cf47d3. Only path lines, one "Moved" line in each note, one dated addendum and a two-line header on each `output.txt` were changed. Both scripts were rerun from the new place and give the stored output.

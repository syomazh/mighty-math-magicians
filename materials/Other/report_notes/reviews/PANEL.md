# Panel review of `report/report.tex`

Written by Claude Fable 5.2 (AI; a fresh-context reviewer, brief `briefs/W053_report_review_panel.md`), 2026-11-15, about 02:30 to 03:10 PT. Not human-reviewed. Nothing other than this file was created or changed; no git command that changes anything was run.

**Version reviewed.** `report/report.tex` at commit `b0f095f` (02:40; 4010 lines; PDF of 70 pages). The file changed twice while I was reading (the row and item for C28, and the sentence on Postnikov and Sagan); I reread the changed parts. Line numbers below are those of `b0f095f`; every item also carries a phrase to search for, because the lines will move. At about 02:59, while this file was being finished, an uncommitted revision of `report/report.tex` appeared in the working tree (its header says that the referee's findings of brief W052 were applied). I did not review that revision. It already changes at least one sentence that this review lists (the abstract now names the lattice-path proof among the formalizations), so check each item against the current text before applying it.

**What I read.** The report from the abstract to the end of the reference list, in full; the mathematical text of Appendices A, B and C (all statements and proofs, not the TikZ code); the comment lines of the `.tex` outside the TikZ code. For comparison: `SUBMISSION_RULES.md`, the statement of Problem 137, `references/README.md`, `notes/2026-11-14_path_proof_literature.md`, `references/overlap_fulltext.md` (sections 3 and 4), `CLAIMS.md`, `AI_USAGE.md`, `FINDINGS.md`, `report/NOTES.md`, `logs/delegations/INDEX.md`, the last entries of `JOURNAL.md`, and lines 103 to 110 of the local text of Konvalinka's paper (`references/konvalinka_wcatalan.txt`, Remark 3).

**What I checked by program** (scripts in my scratchpad, not in the repository):

- every declaration named with `\lean{...}` in the report exists under that name in `lean/MMM/` (name search in 86 files; nothing missing), and every `.lean` file named exists;
- the 86 Lean files contain no `sorry`, no `native_decide` and no `axiom` declaration (text search); `lean-toolchain` is `v4.35.0` and `lakefile.toml` requires Mathlib `v4.35.0`;
- the PDF text and the `.tex` (comments included) contain none of the team's names, user names or the repository link outside the title block; the PDF metadata has no author;
- the residue of the report agrees with Konvalinka's Remark 3 as I read it (474 cases, p ≤ 13, n < 80), and the residue for prime powers is what the classical congruence gives for binom(qn+1, n) (649 cases, eleven pairs (p, k), n < 60);
- the arithmetic of the examples and tables of Sections 1.1, 2.2, 3.7, 4.4, 5 and of Examples A.8 by hand.

**What I did not do.** I did not build the Lean project (workers must not). I did not rerun any experiment. I did not read the slides, so "everything on the slides is in the report" is unchecked. I opened no paper except the eight lines named above. My reading of the proofs was at reading speed; it found no mathematical error, and it is not a substitute for the referee (brief W052), whose report I did not read.

---

## 0. In short

| Dimension | Score now | What costs the point(s) | Reachable today |
|---|---|---|---|
| Correctness | **4** | status sentences that contradict each other (Section 8.3, the abstract, one Lean row, Section 4.5, Appendix B against Section 1.4); "no human has read" the report; the human approvals are second-hand | 5 |
| Clarity | **3** | 70 pages; the theorem and its steps first appear on page 6, after a table of contents of two and a half pages; project bookkeeping (C-numbers, "ledger", "slides") in the running text; duplicated introduction in Section 3.1 | 4 |
| Motivation | **4** | Section 1.3 is exactly what the rubric asks for, but the contribution is stated on page 5 in hedged ledger language, and the case "why it matters" stops at "the problem asks for it" | 4 to 5 |
| Interest | **5** (a strict panelist: 4) | nothing in the substance; the insight is diluted by twelve connections of which most are labelled analogies | 5 |
| Attribution | **4** | the residue for prime powers is not said to be a classical corollary; "the action by cyclic rotations" is claimed although the classes are known objects; "the extra variable" is claimed against the report's own reading notes; "three models other than the author"; two bibliography notes understate what was read | 5 |
| Novelty | **4** | the differences from known work are stated carefully, but novelty rests on keyword searches by AI and no specialist; the one-sentence difference from Deutsch and Sagan and from Konvalinka is buried in a duplicated paragraph | 4 to 5 |

**Compliance.** No violation of the rule on names: the team's names, the user name and the repository link occur only in the title block (l. 126 to 128), in the `.tex` including comments and in the PDF. One self-contained file: yes. Open items that are not yet violations: the title block still has two placeholders; Section 9.3 says that no human has read the report; four figure captions of Appendix A do not give the pictured words; the from-scratch build that the report quotes (3272 jobs) predates six Lean files; the repository itself (the supplementary material) contains the names.

**The three changes that matter most.**

1. Put the result first: paste the one-page section of 5.3 between the abstract and the table of contents, and cut the table of contents to section level. The reader then has the statement, the four steps, what is new and what supports it by the end of page 2 (Clarity, Motivation, Interest).
2. Make the status exact: a person reads the report and Section 9.3 says so (change 2); the stale or contradictory sentences listed in change 3 are replaced, first of all Section 8.3 (Correctness, and the consistency half of Attribution).
3. Reword what is claimed: the residue as a statement is classical for every prime power, Konvalinka's Remark 3 speaks of the residue modulo q, the classes under rotation are known objects, the two-variable equation has more prior work than the report credits (Attribution, Novelty).

---

## 1. Scores, with reasons

The scale of the rules: 5 = above and beyond what a team can do in 40 hours; 4 = few flaws and some creative elements; 3 = only a few minor issues; 2 = a major issue or several minor ones; 1 = many major issues.

### Correctness: 4

Earns points. The main proof (Section 3) is complete and I found no wrong step in it: class size (Lemma 3.12), the lower bound (Proposition 3.14), the skeletons (Proposition 3.19), the free action (Proposition 3.21), the carry (Proposition 3.23) and the termination (Proposition 3.25) each do what the overview says. The scope of "no factorial" is stated exactly: "The proof uses no valuation of a factorial, of a binomial coefficient or of a multinomial coefficient, apart from the trivial fact that $a!$ is prime to $p$ when $a<p$" (l. 317). Every object is defined before use. The theorem has three independent proofs with formal counterparts, and the report separates what Lean checks from what the text says: "whether that statement says what the text claims is the subject of the table of differences" (l. 102). The status table (Section 2.3) says for each claim whether a human read it, including "**No.** No human has read the proof or the Lean files" (l. 529).

Costs points. The rubric asks that "the status of every claim [be] exact". It is not, in these places (details and replacement text in change 3):

- Section 8.3 lists as future work "The move of the Lean project to the required versions, and the exactness half of the lattice-path proof in Lean. Written proofs of the level-profile statement and of the congruence for closed families" (l. 1867). Sections 7.1, 4.1, 4.5 and 8.1 say that all three are done. A panelist cannot tell which is true without the build result.
- The abstract says "a formalization in Lean 4 of the main proof and of the algebraic proof" (l. 150); Section 4.1 says the lattice-path proof "is machine-checked in full".
- One row of the Lean table says the congruence of C11 "is formal only for the family of all trees with $m$ leaves" (l. 1647); a later row gives `PTree.card_closed_modEq_classes` for every closed family (l. 1691).
- Section 4.5 says "The remaining items are conjectures" (l. 1268); the last of them, C27, is checked by Lean.
- "This report was assembled by an AI system; at the time of writing no human has read it" (l. 1972), with a TODO comment above it. Honest, and it is the sentence a panelist will quote against "the team must be able to explain everything submitted".
- The human approval of the main proof is one reported sentence: "looked through the proof and said it is good ... What is known about the extent of that reading is this sentence" (l. 508). The abstract turns it into "read and approved" (l. 152).

None of these overstates a mathematical claim; most understate. They are several minor issues in the one area the rules single out, which is why this is 4 and a strict panelist could give 3.

### Clarity: 3

Earns points. Section 1.1 opens with the table of $v_2(C_n)$ against the binary digits of $n+1$, which any mathematician can read. Section 2.1 gives the proof in five steps and "In one sentence: shrink the symmetry group until it is a $p$-group; then orbit sizes are powers of $p$, the smallest orbits are built from the digits of $m$, and a carry in base $p$ is a cherry collapsing" (l. 341). Section 2.2 writes the examples as bracket words instead of pictures. Rigorous and heuristic statements are kept apart throughout, most visibly by the tags **[known]**, **[computed]**, **[analogy]** of Section 5. The proofs themselves are written at full rigour and are readable.

Costs points.

- Length and order. The PDF has 70 pages and about 41,000 words. After the abstract come two and a half pages of table of contents, then three pages on prior work; the theorem with its residue and the steps appear on page 6, the proof starts on page 12, and four pages of status table stand between them.
- Bookkeeping in the reader's way. "The numbers in this subsection are direct enumerations from the definitions, or are recorded as computed in the project's ledger (claims C22 and C23)" (l. 346); "**Claimed**, in the words of the project's ledger and with its caveat" (l. 250); "the diagram on the slides" (l. 1936); "On the slides: the same tree with 6 leaves drawn as an evolutionary tree, a knockout tournament, a prefix code and a bar of music" (l. 1351). The panel does not see the slides or care about the ledger; these phrases read as notes to self.
- Repetition. Section 3.1 "repeats, in the words of that write-up, the statement and the prior work of Sections 1 and 2" (l. 616), about two thirds of a page. The paragraph on the Lean versions is printed twice (Section 7.1 and, as a twelve-line item of a list, Section 8.2, l. 1854); the paragraph on the lattice-path formalization three times.
- Leftovers of the source notes in the appendices: "Whether this answers Problem 137 is for the team to judge" (l. 3185); "that is for the experts on the team to judge" (l. 3751). In a report by the team these sentences address nobody.

### Motivation: 4

Earns points. Section 1.3 does what the guidelines ask and does not say "it is open". It names what the arithmetic proof lacks: "it gives no reason, in terms of the trees, why the digits of $m$ should appear, and no object whose number is the unit part $C_n^{(q)}/p^t$ modulo $p$" (l. 231), and it gives two structural reasons why the known group-action argument stops: "First, the group that acts is not a $p$-group ... Second, the orbits of the smallest size are described but not counted modulo $p$" (l. 235 to 238). The repair then follows from the diagnosis, which is the best kind of motivation.

Costs points. The contribution is stated on page 5, after the prior work, and in hedged form. The report never says in plain words what a reader gains beyond the answer to the problem, although it has the material: the unit part gets a meaning (the number of smallest classes), the digits become visible objects (the complete subtrees), every statistic that rotations preserve inherits the divisibility (Section 4.5), and the extra variable of Appendix B interpolates between classes ($y=1$), trees ($y=p$) and complete trees ($y=0$). One paragraph that says this would move the score.

### Interest: 5 (a strict panelist: 4)

Earns points. The primary objective of the problem is met in full, for every prime power and with the residue, by an argument with one clear idea per step. Around it: a second proof of the lower bound in three lines (the carry budget, Section 4.4); an algebraic proof that shares no lemma with the first and explains it ("$y$ marks asymmetric nodes, so $y=p$ counts ordered trees, $y=1$ counts classes and $y=0$ keeps only the complete trees", l. 1170); a proof of Kummer's theorem with its residue by a group action; the remark that "the minimal trees are exactly the trees whose symmetry group is a Sylow $p$-subgroup of the symmetric group on their leaves" (l. 1259); and three statements in the direction "other statistics" proved on the last night, among them $p^t\mid\prod_i\binom{qn_i}{n_{i+1}}$. All of it is dated inside the event (Section 8.1). That is above what the rubric calls a 4.

Costs points, if any. Section 5 lists twelve connections; by the report's own tags most are analogies or lookups, and "None of this is used in any proof" (l. 1336). A panelist who reads them as padding will discount. The rules say that using AI earns nothing by itself; they do not say that it costs, and the report is plain that "The proofs were found and written by AI systems under the direction of the team" (l. 154).

### Attribution: 4

Earns points. This is the most carefully attributed report I can imagine being written in two days. Section 1.4 has a list "Not claimed" that is longer than the list "Claimed". Every bibliography entry says how far the source was read and by whom, down to "[Bibliographic record only; the text was not opened.]" (l. 2149). The history of two corrections is told: the lattice-path proof "was reclassified from 'new method' to 'a known method carried through in general'" (l. 1826). Section 9 names each tool, what it produced and how it was checked, and has a subsection "What no human has checked".

Costs points (Section 3 below has the detail).

- The status table says of the residue "Known for $q=p$" (l. 452). As a statement it is known for every prime power: Appendix A.7 of the report itself derives it in four lines from the classical congruence.
- The first claimed item is "the action by cyclic rotations (a $p$-group) for every prime $p$" (l. 254). The classes of this action are known objects, as Section 5 says.
- The fourth claimed item includes "the extra variable" (l. 262), while Appendix B says "We do not claim that this argument is new" (l. 3751), and the reference list records the two-variable equation in two further sources that Section 1.4 does not name.
- "Three rounds of review by AI systems (three models other than the author" (l. 505): one of the three is the model that drafted the text (Section 9.1 says so).
- "Of the papers in the reference list, none has been read by a human on the team for the purpose of this report" (l. 1968). Disclosed, and still a weakness under "the team must be able to explain everything submitted".

### Novelty: 4

Earns points. The rubric asks "how the proof, exposition or connection differs from known work", and the report answers for each proof: against Konvalinka (Section 1.3), against the case $p=2$ (Sections 1.2 and 3.1), against Smith and Wildon ("What was not found in those two sources is the general statement: the bound by the number of carries for every $N$, the structure and the exact count of the smallest orbits", l. 281), against Kauers, Krattenthaler and Müller (Appendix B.8). The table at the end of Appendix A compares the tree proof and the path proof row by row. Nothing is called new without "as far as".

Costs points. "A search of this kind cannot establish novelty, and no specialist has been asked" (l. 303): true, and it caps the score. The sharpest sentence on what had to be invented beyond replacing 2 by $p$ ("Proposition 3.23 replaces the explicit double factorial by a fixed-point count modulo $p$ that works for all $p$ and $k$", l. 653) sits in the duplicated introduction of Section 3.1 where few will read it. A three-column table (change 6) would show the difference at a glance.

---

## 2. Compliance with the hard requirements

| Requirement (`SUBMISSION_RULES.md`) | Verdict | Where, and what is open |
|---|---|---|
| One self-contained `.tex` and its PDF; no `\input`, no `.bib` | **met** | no `\input`, `\include`, `\includegraphics`, `\bibliography`; `thebibliography` at l. 2004; pictures are TikZ in the file |
| Names, affiliations, repository link, commit hash only in the title block | **met** | title block l. 125 to 129. Searched the `.tex` with comments and the PDF text for the team's first names and surnames, the user name, the team name, "github", "professor", "grad student": only l. 127 (the link, inside the block) and l. 1 (the name of the event in a comment). PDF metadata: author and title empty |
| Title block filled | **open** | l. 126 "TEAM MEMBERS: to be filled by the team"; l. 128 "COMMIT: to be filled at submission" |
| Every key figure described in words | **mostly met** | the three pictures of Section 3.7 have bracket descriptions (l. 1060, 1086, 1112); Figure A.3 lists both classes as words (l. 2678). **Not given in words:** the paths of Figure A.1 (caption l. 2350), the three words and two moves of Figure A.2 (l. 2547), the three minimal words and the words of the larger classes of Figure A.4 (l. 3073), the minimal word of Figure A.5 (l. 3156). The letters are in the TikZ code, one node per letter, which a reader of the source can hardly decode. One sentence per caption closes this |
| Work done during the event distinguishable from prior work | **met** | Section 8.1 with times; Sections 1.2 and 1.4 for prior work |
| Status of every main claim | **met, with contradictions** | Section 2.3 covers every claim. Contradicted elsewhere: Section 8.3 (l. 1867), abstract (l. 150), Lean row (l. 1647), Section 4.5 (l. 1266, 1268). Missing from the table: the converse statement on $T(\mathbf a)$ that the report says is on the slides (l. 410) |
| AI use: which tools, for what, how checked | **met** | Section 9. Inconsistencies in Section 4 below |
| Sources: every source and kind of help credited | **met, with gaps** | Section 3 below |
| Lean: each declaration relied on, the claim, every difference | **met** | Section 7.3; all names exist; differences 1 to 5 and the three of the algebraic proof are stated. Two things to settle: (a) the build quoted in the report ("a full build from scratch on 15 November 2026: 3272 jobs ... a fresh clone", l. 97) was of commit `c8e8e2a` (01:52, according to the journal) and is older than six files: `ExactCount.lean`, `CarryBudget.lean`, `AxiomsExtra.lean`, `Closed.lean`, `Profile.lean`, `Weighted.lean`; the later builds recorded in the journal (3275, 3277, 3278 jobs) took one minute each, so they were not from scratch. Build the final commit once from a fresh clone and print that number. (b) The Lean project is in the folder `lean/`, not in the root of the repository; check on the submission form that the automated build is pointed at that folder |
| No official Lean statement on the problem page | **stated** | l. 1785; read without signing in; a signed-in member should confirm (already in the morning brief) |
| Everything on the slides is in the report | **not checked by me** | the report itself names one statement of the slides that it does not prove (l. 410), and `talk/slides.tex` has uncommitted changes |

**Violations.** None of the rule on names. The items marked "open" become violations at the deadline if left as they are: an empty title block, and a status that the report contradicts in Section 8.3.

**Risks that are not rule violations.**

- The repository is the supplementary material that the panel reads, and it contains the names: `references/README.md` (entries 36 and 62 and the heading of entries 71 to 76), `CLAIMS.md`, `AI_USAGE.md`, `FINDINGS.md`, `JOURNAL.md`, `STATE.md`, `report/NOTES.md` (l. 28), the folder names under `guests/`, and the git history. The rules as summarised speak of the report body only. Whether the supplementary material must be anonymous is a question for the humans to ask the organisers; it cannot be repaired in the remaining hours without rewriting history, which the project forbids.
- "A faculty member of the team" occurs about twenty times and "another team member's machine", "a university library" once each. No name, no institution; I do not count it as affiliation. A panelist may still read the repeated phrase as an appeal to authority, since the panel cannot verify it. Once in the abstract and once in the status table would be enough.
- Line 1 of the file (a comment) names the event. Harmless; it can go.

---

## 3. Attribution and novelty, read by someone who knows the literature

Sources for this section are the project's own notes: `references/README.md` (entry numbers below), `notes/2026-11-14_path_proof_literature.md` and `references/overlap_fulltext.md`. I add no reference of my own.

### 3.1 The four items claimed in Section 1.4

**Item 1 (l. 254): "the action by cyclic rotations (a $p$-group) for every prime $p$, and for prime powers $q=p^k$ through the reading of a $q$-ary node as $k$ levels of $p$-ary nodes, with the depth condition this brings".**
Does not survive as worded. The action and its classes are known objects, and the report says so forty pages later: "Trees up to rotation at each node are called mobiles in the OEIS" (l. 1395, entry 25: "$k$-ary mobiles (circular rooted trees)"); for $p=3$ the classes are the "steric rooted ternary trees" of A000625, in whose entry "a comment says the children of a node are in cyclic order" (entry 38); "the group at a carbon is cyclic of order 3" is cited to Robinson, Harary and Balaban (l. 1367, entry 73). That a class has $p^d$ members is the orbit and stabiliser count for a $p$-group; for $p=2$ the report credits it (Etherington; Steel, entry 50). What the searches did not find is the *use* of this action for the power of $p$, and the block reading for $q=p^k$. Replacement text: change 5.

**Item 2 (l. 256): the smallest classes by the base-$p$ digits, with the depth condition.**
Survives. The parenthesis ("the *shape* of this description is not new: it is the analogue, for cyclic rotations and in base $p$, of Konvalinka's Lemmas 8 to 10 for the full symmetry group in base $q$, and for $p=2$ it is in [Deutsch–Sagan, Kersting–Fischer]") is exactly the right size. One addition would make it complete: Gao and Gu restate the description for $p=2$ (the report says so in Section 1.2, l. 213, but not here).

**Item 3 (l. 260): the count modulo $p$ by collapsing cherries, "and with it a proof of exactness and of the residue for every prime power from the symmetries of the trees".**
The proof survives; no opened source has it (`references/overlap_fulltext.md`: "not in this paper" for C4 and C5 in all four texts). Two things around it do not:

- *The residue as a statement.* The status table says "Known for $q=p$ [Konvalinka, Remark 3]" (l. 452), Section 1.3 says "the residue for prime powers, had no proof in terms of trees" (l. 240), and the abstract ends its account with "The result is the valuation and the residue ... for every prime power" (l. 147). A reader takes away that the residue formula for $q=p^k$, $k\ge2$, is new. It is not: $\binom{qn+1}{n}=(qn+1)\,C_n^{(q)}$, $qn+1\equiv1\pmod p$, and the classical congruence of Anton, Stickelberger and Hensel gives $(-1)^t/\prod_jm_j!$ at once, because the digits of $qn+1$ are those of $n$ shifted by $k$ places and a digit 1. The report proves exactly this in Appendix A.7 (l. 2856 to 2867) and says in Appendix A.9 that the theorem "is its special case $\binom{qn+1}n$" (l. 3171 to 3173), but nowhere in Sections 1 or 2. I checked the derivation on 649 cases. A panelist who knows Kummer's theorem will see this within a minute, and will then ask why the table says "Known for $q=p$".
- *Konvalinka's Remark 3.* The report says the remark gives the residue "modulo $p$" for $q=p$ "and says that the formula for general $q$ is much more complicated" (l. 195). In the local text of the paper (lines 103 to 110) the remark is about the residue of $C_n^{(q)}/p^{\xi}$ **modulo $q$**; for $q=p$ that is modulo $p$, and the closing clause is "we get a much more complicated formula for general q". For $q=p^k$ with $k\ge2$ the residue modulo $q$ is a finer statement than the residue modulo $p$ of this report. As the report stands, the two sentences together suggest that the report found a simple formula where Konvalinka saw a complicated one. They are about different residues. (My reading is of a text extraction in which the exponent is garbled; a person should confirm on page 3 of the paper.)
- *The comparison that is "not written out"* (l. 270, l. 452). It takes two lines. As I read the remark, its formula for $q=p$ is $(-1)^{\,t+\sum_j(m_j-1)}\prod_j(p-1-m_j)!$. By Wilson's theorem $a!\,(p-1-a)!\equiv(-1)^{a+1}\pmod p$ for $0\le a<p$, so $1/\prod_jm_j!\equiv(-1)^{\sum_j(m_j-1)}\prod_j(p-1-m_j)!$, and the two formulas are the same. Checked on 474 cases. Writing this out turns an admitted gap into an agreement with the only published residue.

**Item 4 (l. 262): "in the algebraic proof: the extra variable, the weight, the carry-free product and the carry operator".**
Half survives.

- It contradicts Appendix B.8: "We do not claim that this argument is new; that is for the experts on the team to judge" (l. 3751). One of the two has to change.
- "The extra variable" is the weakest word in the list. For $p=2$, $k=1$ the report credits Etherington's equation (33) (l. 289). The reference list holds two more sources that Section 1.4 does not name: Bóna and Flajolet, Lemma 1, "a functional equation for the bivariate generating function, $F(z,u)=z+\tfrac12F(z,u)^2+(u-\tfrac12)F(z^2,u^2)$" (entry 41), which is the same equation with the variable on the symmetric nodes; and Pólya's paper of 1936, of which entry 72 says: "Its equation (24), a two-variable equation of the same shape as the deformed equation of our Frobenius note (for the full symmetric group and another statistic), was read by an AI from a scan: a person should read p. 436 before it is cited". The report cites Bóna and Flajolet only for the number of labellings (l. 1343, l. 1425) and Pólya only for equation (25) at $y=1$ (l. 1370). A reader who knows Pólya's counting recognises $F=x+\varphi(F)+y\,\theta(F)$, that is $F=x+\tfrac yp F^p+(1-\tfrac yp)F(x^p,y^p)$, as the counting equation for the cyclic group of order $p$ with a variable for the nodes without symmetry. What the notes do not show anywhere else is what the report does with it: the reading as a deformation of the Frobenius lift with $y=p$, the weight $(p-1)d-s_p(m)$, the carry-free product, the carry operator on Hurwitz series, and the system of $k$ equations for $q=p^k$. Claim those.

### 3.2 Other sentences that can be read as claiming known work

| Where | Sentence | Problem | Repair |
|---|---|---|---|
| l. 147, abstract | "The result is the valuation and the residue ... for every prime power." | reads as a new result; both are classical as statements | "The result is a proof, from the symmetries of the trees, of the valuation and of the residue ..." |
| l. 452, status row C7 | "Known for $q=p$ ... (*cited*; the comparison with our form is not written out here)" | see 3.1, item 3 | change 4 |
| l. 1188 and Appendix C | "Legendre's formula with its residue" proved by symmetry | the residue of $m!/p^{\nu}$ is classical too: the literature note records that Granville's Section 2 names Anton, Stickelberger and Hensel "for the underlying factorial identity". The report does not say it is known | add "(classical; \cite{Granville})" at l. 1188 and at Corollary C.6 (l. 3949) |
| l. 1259 | "the minimal trees are exactly the trees whose symmetry group is a Sylow $p$-subgroup" | stated as a finding, status "checked by computation ... proof sketched in the note and is not reproduced". Fine as labelled; but the Sylow group as rotations of nested blocks from the digits is Smith's Section 1 for every $p$ (entry 62), and the report cites Smith for this only in Section 5 | add \cite{Smith} here |
| l. 1295 to 1311, C28 | depth-weighted sums divisible by $p^t$ | the depth-weighted statement is the level-profile corollary summed with coefficients $\prod_ib_i^{n_i}$; presenting it as a third item makes one result look like two | say "an immediate consequence of the corollary on level profiles" |
| l. 1851 | "The main proof answers the problem as posed." | defensible, and the strongest sentence in the report. It stands without the hedge that every other claim gets | "answers the problem as posed, as far as the team and its checks can tell" or leave it and be ready to defend it |

### 3.3 Known results used without a citation, or cited more weakly than the notes allow

- **Congruences from $p$-group actions as a method.** The "Not claimed" item on the lattice-path proof names Smith and Wildon. The reference list also has Sagan, "Congruences via Abelian groups" (1985), and Rota and Sagan, "Congruences derived from group action" (1980) (entry 64, both read by the literature agent): binomial congruences from groups generated by disjoint $p$-cycles, and "the divisibility half for $N=p^m$ only" from a cyclic group of order $p^m$. Sagan is a coauthor of two of the three references of the problem; a panel primed with the problem's references will look for these. Neither is in the report. Also entry 65 (Pimenov, Faizov, Zhukov, 2025: credits Smith, bounds for $N=p^k$, "says that the minimal orbit length of an irreducible colouring is open") supports the claim of what was not found and is not cited.
- **The cycle lemma** (l. 2257, "By the cycle lemma") and **Lagrange inversion** (Appendix B.1): named, no reference. Both are in remarks that the proofs do not use; a clause "(standard; not used)" is enough.
- **The Sylow $p$-subgroup of $S_q$ as an iterated wreath product**, in the remark of Section 3.2 (l. 693): no citation there; cited in Section 5 and in Appendix A.
- **Samet** is cited for a statement tagged [known] (l. 1400) although the bibliography says the text was never opened (l. 2149). Either open the first page or say "(a standard fact; the survey is cited from its catalogue record)".
- **The Yule formula** is given twice with different denominators, "$2^{d}/\prod_v(n_v-1)$" and "$2^{n-1-s}/\prod n(v)$, in its notation" (l. 1347 to 1349), and the report does not say whether they agree. A reader cannot tell which is the cited one.

### 3.4 Where the report says less than the repository supports

- The abstract leaves out that the lattice-path proof is formalized (l. 150), and with it that Kummer's theorem with the exact power and the residue is proved in Lean by a group action, in Mathlib's terms (`MMM.Path.kummer_exact_digits`, `MMM.Path.multiplicity_choose_eq_carries`).
- Section 8.3 lists three finished things as not done (l. 1867).
- The Lean row at l. 1647 says the congruence for closed families is formal for one family only; it is formal for all (`lean/MMM/Closed.lean`).
- The agreement with Konvalinka's Remark 3 is two lines and is "not written out".
- The bibliography says of Deutsch and Sagan "Pages 1--5 of the arXiv version ... read by AI" (l. 2037) and of Postnikov and Sagan "Abstract read by AI" (l. 2134), and the new sentence of Section 4.5 says "The paper [Postnikov–Sagan] on weighted Catalan numbers was not read in the project" (l. 1308). `references/overlap_fulltext.md` (worker W009, Kimi K3.1 Pro, 13 November) records a reading of the full arXiv text of both (22 and 9 pages), with theorem numbers and pages; its section 4(c) says the weight there depends "on left-edge counts". Six lines earlier the report itself speaks of "the four papers that an AI system read in full early in the project" (l. 1292), and Postnikov and Sagan is one of the four. So the sentence at l. 1308 is wrong as a statement of the record, `references/README.md` (entries 2 and 3) is behind `overlap_fulltext.md`, and Section 9.1 does not list this reading among what Kimi did. The reading is by one AI worker and unreviewed; say that, instead of "not read".
- The audits recorded in `CLAIMS.md` (14:55 and 01:08) say that the formal main proof for $q=p$ reaches no lemma of Mathlib on binomial coefficients, Legendre or Kummer, and that the formal lattice-path proof reaches only `Nat.Prime.dvd_factorial` and Wilson's theorem among Mathlib's statements on factorials and valuations. The problem says "without relying on factorial valuations"; Section 7.5 reports the dependency listing only for the algebraic proof and the profile theorem. Two sentences would add evidence on the very point of the problem.
- The level-profile divisibility $p^t\mid\prod_{i<L}\binom{q\,n_i}{n_{i+1}}$ is a concrete arithmetic statement, proved, formalized in Mathlib's terms, and an answer to the problem's "other statistics". It is a bullet on page 29 and is absent from the abstract. Keep the hedge on novelty and move the statement up.

### 3.5 The novelty statements, one by one

| Statement | Wording | Survives? |
|---|---|---|
| main proof | "as far as the project's search of the literature found, the half of the theorem that says 'exactly', and the residue for prime powers, had no proof in terms of trees except for $p=2$" (l. 239) | Yes, with "in terms of trees" doing the work. Add that as statements both halves are classical |
| lattice-path proof | "As far as one search and these two readings show, it is a new proof of a classical theorem by a known method; that is a statement about what was found, not a proof that nothing else exists." (l. 283) | Yes. This is the model for the others |
| algebraic proof | Section 1.4 claims four ingredients; Appendix B.8 claims nothing | No: contradiction. See 3.1, item 4 |
| level profiles | "we do not claim that it is new" (l. 1293) | Yes |
| weights (C28) | "No search of the literature was made for it." (l. 1311) | Yes |
| keyword search | "A search of this kind cannot establish novelty, and no specialist has been asked." (l. 303) | Yes, and it should stay |
| Appendix A.9, item 2 | "We have not searched the literature properly for this proof ... Before any claim of novelty this needs a real search" followed by a bracket that a search was made (l. 3174 to 3179) | Confusing: two states of knowledge in one paragraph. Replace the two old sentences by the bracket's content |

---

## 4. Is the AI disclosure consistent with the rest?

**Consistent.** Who had the idea (Section 9.1, first row, against the abstract and Section 8.1). Who drafted the main proof (Section 9.1, Kimi row, against the comment at l. 621). Who wrote the algebraic and accounting proofs (Section 9.1 against the comments at l. 3242 and l. 3793). The lattice-path proof: "the question was the team member's; the proof, the note, its figures and its check scripts are the AI's" (l. 1919), the same in the head of Appendix A. That all Lean files are AI-written and unread by humans (Sections 7.1, 8.2, 9.3). That referees of the algebraic proof, the accounting proof and the carry budget were "the same model as the author" (status table, three rows). Nothing in the report hides that the proofs were found by AI: the abstract, the first sentence of Section 9 and Section 8.1 all say it.

**Inconsistent or imprecise.**

1. **"three models other than the author"** (l. 505, status row "C1--C8 as a whole"). The first-round reviewers were Mistral Large 4.0, Muse Spark Open and Kimi K3.1 Pro (`logs/delegations/INDEX.md`, runs `W006_review_*`), and Kimi K3.1 Pro had drafted the text under review (run `W001_proof_draft`; Section 9.1 says both things in one row, l. 1900 to 1903). So one of the "three models other than the author" is the author of the text. Replacement in change 3.
2. **Human reading of the main proof, in four strengths.** "looked through the proof and said it is good (reported 14 November 2026)" (l. 508); "approved by a faculty member" (l. 447, l. 614); "read and approved" (abstract l. 152; Section 8.2 l. 1840); "read the main proof" (Section 9.4 l. 1976). Only the first is what the ledger records, and the ledger adds that the AI that kept the record did not speak with him. A judge can read the abstract as claiming a verification that is not on record. Use the first wording everywhere, or have him state in his own words what he read.
3. **Human reading of the lattice-path proof.** "Read and verified by a faculty member of the team, 14 November 2026" (l. 521) without "as reported"; the ledger has it from a note pasted by a team member. Add "(as reported by a team member)" or have it confirmed.
4. **"No human has read the proof"** of the algebraic proof (l. 529, l. 1178, Appendix B head). The ledger records that a team member began to read it and stopped without a verdict (`CLAIMS.md`, 12:13). The report's sentence errs on the safe side; exact would be "A team member began to read it and stopped; no human has checked it."
5. **Stale provenance comments in the `.tex`** that contradict the text beside them: l. 621 "Not yet human-verified" (the main proof; the text says approved); l. 2208 to 2209 "Not human-reviewed ... Not reviewed by another model. Not human-signed" (the lattice-path note; the text says read by two AI sessions and verified by a faculty member). They are marked as lines of the source files, but a panelist who reads the source sees "Not human-signed" next to "read and verified".
6. **Section numbers in the comments** are those of an earlier draft: "Section 5" at l. 1128 is Section 4, "Section 6" at l. 1325 is Section 5, "Section 7" at l. 1465 is Section 6, "Section 8" at l. 1531 is Section 7, "Sections 9 and 10" at l. 1796 are 8 and 9; l. 134 "Abstract and Sections 1 to 3" should be "1 and 2"; l. 22 "(4.1, A.1, ...)" should be "(3.1, A.1, ...)". The printed tools table (l. 1925 to 1927) has it right.
7. **After the addition of C28:** "the two proofs of Section 4.5" (l. 1898) are three; "both statements are checked by Lean" (l. 1266) are three; the row "Further sessions of Claude Fable 5.2" lists Lean files "for the exact count, the carry budget, the closed families and the level profiles" (l. 1914 to 1915) and not the file on weights (`lean/MMM/Weighted.lean`, brief W051).
8. **Not in Section 9.1 although in the record:** the full-text overlap check of four papers by Kimi K3.1 Pro (W009; see 3.4); the superseded drafts of the accounting and algebraic proofs by Kimi (named only in the comments at l. 3244 and l. 3795); the search for connections by Kimi (W029; the Mistral row has its counterpart W030). One clause each.
9. **"Claude Opus 5.5 ... according to a comment in the source of the slides"** (l. 1922). A disclosure that rests on a comment is an unverified disclosure. A team member should confirm or correct before submission.
10. **"Two separate AI sessions ... audited whether the statements of the main proof say what is claimed"** (l. 1551): a third audit was launched at 02:14 (brief W050). When it returns, this paragraph and "the files added after those audits ... are covered only by the Lean kernel and by the reading of the AI system that coordinated the work" need its result, whatever it is.

**Could a judge read any sentence as hiding that AI found the proofs?** No. **As claiming human verification that did not happen?** The abstract's "read and approved" for the main proof (item 2), and nothing else.

---

## 5. Economy

### 5.1 Where the reader is after two pages

On page 2 of the PDF the reader is in the middle of the table of contents. The idea is in the abstract (dense, but complete), the known theorem is stated on page 3, the team's theorem with its residue and the five steps are on page 6, and the first lemma is on page 14. A one-page path through the result does not exist: Section 2.1 has the statement and the steps on half a page, but what is new is on page 5 and what supports it is spread over the four pages of Section 2.3.

### 5.2 What to cut or move

In order of pages saved for the reader of the first ten pages. Nothing here deletes content that the rules require; "move" means to an appendix of the same file.

| Part | Pages now | Proposal |
|---|---|---|
| Table of contents | 2.5 | `\setcounter{tocdepth}{1}` before `\tableofcontents` (l. 157): fifteen lines instead of ninety |
| New: "The result on one page" | 0 | paste the section of 5.3 between the abstract and the table of contents |
| Abstract | 0.5 | cut the list of contents ("The report contains this proof in full; three further proofs ... and, for every claim, how it is supported") to one sentence; the one-page section carries it |
| 1.2 What was known | 1 | keep; drop its first sentence about the reading notes (l. 190 to 192) to a footnote or to Section 9 |
| 2.3 Status of every claim | 4 | move the full table to an appendix; keep in Section 2 a table of five rows (main proof, lattice-path, algebraic, accounting, extensions) with three columns (written proof, Lean, human) |
| 3.1 Statement and overview | 0.8 | keep the theorem; replace the two paragraphs on prior work (l. 651 and l. 653) by "Prior work: Sections 1.2 and 1.4." and move the one sentence that is not elsewhere (what replaces the double factorial) into Section 1.4 |
| 4.1 to 4.3 | 1.5 | keep; they are the right length |
| 4.4 Carry budget | 1 | keep; it is the shortest proof of Step 2 in the report and could be quoted in the one-page section |
| 5 Connections | 3.5 | move to an appendix. In the body keep four lines: the three connections that are prior work or bear on attribution (evolutionary trees, Sylow subgroups, alkyl groups and mobiles) with a pointer. If the chosen deck shows the others, the appendix covers the rule on slides |
| 6 Computations | 1.5 | move the table to an appendix; keep the first two sentences |
| 7.3 Table of declarations | 5 | move to an appendix; keep in the body the rows of the nine final statements and the five numbered differences (one page) |
| 8.2, item "Lean" | 0.3 | replace the macro `\LeanVersionStatus{}` at l. 1854 by "See Section 7.1." |
| 8.3 Next steps | 0.2 | rewrite (change 3) |
| Appendices A to C | 21 | keep. Remove the sentences addressed to "the team" (l. 3185, l. 3751) and the superseded sentences of A.9, item 2 |

With the first two rows alone the reader has the statement, the four steps, what is new and what supports it by the end of page 2, at the cost of fifteen minutes. With all rows the body before the references goes from about 46 pages to about 30.

### 5.3 The one-page path, ready to paste

Place: after `\end{abstract}` (l. 155) and before `\tableofcontents` (l. 157). It uses only labels, macros and citation keys that the file already has, and only statements that the report already makes (Sections 1.3, 1.4, 2.1, 2.2, 2.3, 7.1; Example 3.28; Appendix A.9, item 2). I compiled a scratch copy of the report (outside the repository) with this section on a page of its own, the table of change 6 and `\setcounter{tocdepth}{1}`: no error, no undefined reference, no new overfull box; the section fills exactly one page, and the PDF stays at 70 pages. Placed directly after the abstract it begins on page 1 and ends on page 2.

```latex
% ---- Proposed by a reviewing AI session (Claude Fable 5.2, brief W053), 2026-11-15, from Sections 1.3, 1.4,
% ---- 2.1, 2.2, 2.3 and 7.1 of this report. It adds no mathematical claim. Not human-reviewed.
\section*{The result on one page}\label{sec:onepage}
\addcontentsline{toc}{section}{The result on one page}

\noindent\textbf{Statement.} Let $p$ be a prime, $q=p^k$, and let $C_n^{(q)}$ be the number of plane $q$-ary
trees with $n$ internal nodes; such a tree has $m=(q-1)n+1$ leaves. Write $m=\sum_jm_jp^j$ in base $p$,
$s=\sum_jm_j$ and $t=(s-1)/(p-1)$. Then (Theorem~\ref{main:thm:main})
\[
 v_p\bigl(C_n^{(q)}\bigr)=t\qquad\text{and}\qquad\frac{C_n^{(q)}}{p^t}\equiv\frac{(-1)^t}{\prod_jm_j!}\pmod p .
\]
As statements about numbers both are classical (\cite[Proposition~2]{Konvalinka}, by factorials;
Appendix~\ref{app:path}). Problem~137 asks for a proof from the symmetries of the trees.

\noindent\textbf{What was missing.} The known argument with a group acting on trees \cite{Konvalinka} allows
all permutations of the $q$ branches of a node. That is not a $p$-group: the size of an orbit is a product of
multinomial coefficients, whose power of $p$ again needs factorials, and the smallest orbits are not counted
modulo $p$. It gives ``$p^t$ divides'', not ``exactly''.

\noindent\textbf{The idea.} Shrink the group until it is a $p$-group. Read a $q$-ary node as $k$
levels of $p$-ary nodes: $q$-ary trees with $n$ internal nodes become $p$-ary trees with $m$ leaves, all at
depths divisible by $k$ (Lemma~\ref{main:lem:blocked}). Allow only cyclic rotations of the $p$ children of a
node; a node is \emph{asymmetric} if its $p$ subtrees are not all equivalent, and $d(T)$ counts the
asymmetric nodes of $T$.
\begin{description}[leftmargin=1.2em,itemsep=0pt,topsep=2pt,parsep=0pt]
\item[Step 1] (Lemma~\ref{main:lem:class-size}). \emph{A class has $p^{d}$ members:} the trees obtained from
 $T$ by rotations are exactly $p^{d(T)}$ in number. Hence $C_n^{(q)}=\sum_{\text{classes}}p^{d}$.
\item[Step 2] (Proposition~\ref{main:prop:lower-bound}). \emph{$d\ge t$}, because $s_p(pa)=s_p(a)$ and
 $s_p(a+b)\le s_p(a)+s_p(b)$, with equality exactly when no carry occurs. Hence $p^t$ divides $C_n^{(q)}$, and
 $C_n^{(q)}/p^t$ is congruent modulo $p$ to the number $N_{\min}$ of classes with $d=t$.
\item[Step 3] (Propositions~\ref{main:prop:minimal-local}, \ref{main:prop:skeleton}). \emph{The smallest
 classes are built from the digits of $m$:} they are the skeletons, trees with $t$ asymmetric nodes whose
 leaves are replaced by complete $p$-ary trees (``atoms''), exactly $m_j$ of height $j$, an atom of height $j$
 hanging at a depth $\equiv-j\pmod k$.
\item[Step 4] (Propositions~\ref{main:prop:free}, \ref{main:prop:carry}, \ref{main:prop:carry-termination}).
 \emph{A carry is a cherry.} Give the atoms distinct labels; this multiplies the number of skeletons by
 $\prod_jm_j!$, which is prime to $p$. Let a cyclic permutation of $p$ labels of one depth class act: modulo
 $p$ only the fixed trees count, and in a fixed tree the $p$ labels are the children of one node (a
 \emph{cherry}), in one of $p-1$ cyclic orders. Collapsing the cherry to one leaf of the next class is a carry
 in base $p$ and multiplies the count by $p-1\equiv-1$. The $t$ carries end at a single leaf, so
 $N_{\min}\equiv(-1)^t/\prod_jm_j!\pmod p$, which is not zero.
\end{description}

\noindent\textbf{Example} (Example~\ref{main:ex:binary}). The $132$ binary trees with $7=111_2$ leaves form
$11$ classes, $132=3\cdot4+3\cdot8+4\cdot16+1\cdot32$; here $t=2$, and three classes have $2^2$ members.

\noindent\textbf{What is new, and what is not} (Section~\ref{sec:attribution}; from searches by AI systems,
no certificate of novelty). New, as far as we know: the use of cyclic rotations, a $p$-group, for
every prime and every prime power; the smallest classes in base $p$ with the depth condition; their count
modulo $p$ by collapsing cherries, and with it the exactness and the residue from the symmetries of the trees.
Not new: the formula; the divisibility by a group action and the shape of the smallest orbits
\cite{Konvalinka}; everything for $p=2$ \cite{Etherington,DeutschSagan,KerstingFischer}; the fixed-point
principle \cite{Gessel}.

\noindent\textbf{What supports it} (Section~\ref{sec:status}). A complete written proof
(Section~\ref{sec:mainproof}), looked through and approved by a faculty member of the team after three rounds
of review by AI systems. In Lean, \lean{MMM.problem137_fussCatalan} and \lean{MMM.residue_fussCatalan} state
the theorem with Mathlib's definitions only and build on \LeanVersions{} with no \texttt{sorry}; the five
differences from the text are in Section~\ref{sec:lean}. No failure in $1067$ values of $m$. Three further
proofs (Appendices~\ref{app:path} to~\ref{app:acc}), two of them also checked by Lean. The proofs were found
and written by AI systems under the direction of the team (Section~\ref{sec:ai}).
```

Two words in it anticipate changes proposed below and are not yet the report's wording: "the *use* of cyclic rotations" (change 5) and "looked through and approved" for the abstract's "read and approved" (change 2). Both are weaker than what the report says now.

---

## 6. The ten changes that would raise the scores most

In order. Each names the dimension, the place and the text.

### 1. The result first (Clarity, Motivation, Interest)

- Paste the section of 5.3 after l. 155.
- Before `\tableofcontents` (l. 157) add `\setcounter{tocdepth}{1}`.
- In the abstract (l. 147 to 151) replace from "The report contains this proof in full" to "whether a human has read it." by: "The report also contains three further proofs found during the event (on lattice paths, by algebra alone, by counting labelled trees), a formalization in Lean~4 of three of the four proofs, and the status of every claim."

### 2. A person reads the report, and the report says who read what (Correctness, Attribution)

This is the one change an AI cannot make. The minimum reading for a team member: the abstract, the new one-page section, Section 1.4, the table of Section 2.3, Section 9.

- l. 1971 to 1972: delete the TODO comment and replace the sentence by what is then true, for example: "This report was assembled by an AI system. On 15 November 2026 it was read by \_\_ members of the team: the abstract, Sections 1, 2 and 9 in full, and \_\_; the appendices were not reread."
- Abstract, l. 151 to 152, replace "The main proof and the lattice-path proof were read and approved by a faculty member of the team" by: "A faculty member of the team looked through the main proof and approved it, and read and verified the lattice-path proof (Section~\ref{sec:status} says what is on record about the extent)".
- l. 1840: "Two of the four proofs were read and approved by a human" becomes "Of the four proofs, a human looked through one and approved it (the main proof) and read and verified one (the lattice-path proof)".
- l. 1976: "read the main proof, the lattice-path proof and the accounting proof" becomes "looked through the main proof, and read the lattice-path proof and the accounting proof".
- l. 521: after "14 November 2026" add "(as reported by a team member)", unless he confirms it directly, in which case say so.
- Fill the title block (l. 126, l. 128).

### 3. Remove the sentences that contradict the status (Correctness, Attribution)

- **Section 8.3, l. 1866 to 1871.** Replace the paragraph by: "A human reading of the algebraic proof, of the three statements of Section~\ref{sec:extensions}, and of the definitions and final statements in Lean. A written proof of the product formula for minimal words over arbitrary lists of blocks, which exists only as a Lean proof. A proof or refutation of the weighted statement with the rotation group, and of the bijection with permutations made of $p$-cycles. The judgment of a specialist on novelty, on the relation to Smith's paper, and on the resemblance with Stickelberger's congruence. A check by a person of the sources that only AI systems have opened."
- **Abstract, l. 150:** "of the main proof and of the algebraic proof" becomes "of the main proof, of the algebraic proof and of the lattice-path proof".
- **Lean table, l. 1647 to 1648.** Replace the cell by: "The first two hold for every family closed under rotation whose members have $d\ge t$; the third is the case of all trees with $m$ leaves, which is the reduction used in the main proof. The congruence with the number of classes for every closed family is \lean{PTree.card_closed_modEq_classes} below."
- **Section 4.5, l. 1265 to 1268.** "and both statements are checked by Lean" becomes "and all three are checked by Lean"; "The remaining items are conjectures, with the computations listed in Section~\ref{sec:computations}." becomes "Of the remaining items, two are conjectures supported by the computations of Section~\ref{sec:computations}, and the last is checked by Lean and has no written proof."
- **Status row, l. 505:** "(three models other than the author, then two further readers with no access to the project's notes)" becomes "(first three models, of which one had drafted the text under review in a separate run; then two readers with no access to the project's notes, of the same model as the author of the idea)".
- **Status row, l. 529, and l. 1178:** the sentences "No human has read the proof or the Lean files" and "No human has read this proof" become "A team member began to read the proof and stopped; no human has checked it or the Lean files".
- **Appendix B.8, l. 3751:** replace "We do not claim that this argument is new; that is for the experts on the team to judge." by "What Section~\ref{sec:attribution} lists as ours in this argument is subject to the same caveat."
- **Appendix A.9, item 2, l. 3174 to 3179:** delete "We have not searched the literature properly for this proof." and "Before any claim of novelty this needs a real search.", and keep the content of the bracket as plain text. **Item 3, l. 3185:** replace "Whether this answers Problem~137 is for the team to judge." by "It is therefore offered as a second proof of the formula, not as a proof from the symmetries of the trees."
- **Section 9.1:** l. 1898 "the two proofs" becomes "the three proofs"; l. 1915 add "and the invariant weights" after "the level profiles"; in the Kimi row (l. 1902) after "a literature scan through public interfaces" add "and a reading of the full arXiv texts of four papers for overlap; superseded first drafts of the accounting and algebraic proofs".
- **Section 4.5, l. 1308 to 1309,** and the bibliography notes at l. 2037 and l. 2134: see 3.4. Replace "(The paper \cite{PostnikovSagan} on weighted Catalan numbers was not read in the project.)" by "(Of \cite{PostnikovSagan} the project has one reading of the arXiv version by an AI system, not reviewed; according to it the weight there depends on counts of left edges.)", and the two bibliography notes by "[Given in the problem statement. The arXiv version was read in full by one AI system; pages 1--5 by three more.]" and "[Given in the problem statement. The arXiv version, math/0601339, was read in full by one AI system; the abstract by two more.]". The orchestrator should first look at `references/overlap_fulltext.md`, sections 3 and 4, and bring `references/README.md` (entries 2 and 3) into line.
- **l. 97:** after the final from-scratch build of the submitted commit, replace "3272 jobs" by the number of that build.

### 4. Say what is classical about the residue (Attribution, Novelty, Correctness)

- **Section 1.2, l. 195 to 197.** Replace "Remark~3 gives, for $q=p$, the residue of $C_n^{(q)}/p^{t}$ modulo $p$ in terms of the base-$p$ digits, and says that the formula for general $q$ is much more complicated." by: "Remark~3 gives, for $q=p$, the residue of $C_n^{(q)}/p^{t}$ modulo $p$ as a signed product of the factorials $(p-1-m_j)!$ over the base-$p$ digits $m_j$ of $m$; it speaks of the residue modulo $q$ and says that for general $q$ the formula is much more complicated. This report treats the residue modulo $p$ only. For $q=p$ the formula of Remark~3 and ours agree: by Wilson's theorem $a!\,(p-1-a)!\equiv(-1)^{a+1}\pmod p$ for $0\le a<p$, hence $1/\prod_jm_j!\equiv(-1)^{\sum_j(m_j-1)}\prod_j(p-1-m_j)!$." (A person must first confirm the formula of Remark 3 on page 3 of the paper; I read it from a text extraction.)
- **Section 1.4, "Not claimed", l. 267 to 270.** Replace the clause "the residue for $q=p$ ... not written out in this report)" by: "the residue as a statement, for every prime power: since $\binom{qn+1}{n}=(qn+1)\,C_n^{(q)}$ and $qn+1\equiv1\pmod p$, it is the case $N=qn+1$ of the classical congruence of Anton, Stickelberger and Hensel \cite{Granville}, as Section~\ref{path:sec:proof} shows, and for $q=p$ it is \cite[Remark~3]{Konvalinka} (Section~\ref{sec:known}). What is claimed is its proof from the symmetries of the trees."
- **Status row C7, l. 452 to 453.** Replace "Known for $q=p$ \cite[Remark~3]{Konvalinka} (\emph{cited}; the comparison with our form is not written out here)." by "As a statement it is classical for every prime power (\emph{cited}: the congruence of Anton, Stickelberger and Hensel through \cite{Granville}, applied to $\binom{qn+1}{n}$, Section~\ref{path:sec:proof}); for $q=p$ also \cite[Remark~3]{Konvalinka}."
- **Abstract, l. 147:** "The result is the valuation and the residue" becomes "The result is a proof, from the symmetries of the trees, of the valuation and of the residue".

### 5. Claim the use, not the objects (Attribution, Novelty)

- **Section 1.4, first item, l. 254 to 255.** Replace by: "the \emph{use} of the action by cyclic rotations (a $p$-group) to find the power of $p$, for every prime $p$, and for prime powers $q=p^k$ through the reading of a $q$-ary node as $k$ levels of $p$-ary nodes, with the depth condition this brings. The classes themselves are known objects: trees up to cyclic rotation at each node are the mobiles of the OEIS \cite{OEISmobiles}, for $p=3$ the stereoisomers of the alkyl groups \cite{OEISA000625}, where the group at a carbon is cyclic of order $3$ \cite{RHB}; and that a class has $p^d$ members is the count by orbit and stabiliser for this group (for $p=2$: \cite{Etherington,Steel2014});"
- **Section 1.4, fourth item, l. 262 to 263.** Replace by: "in the algebraic proof (Appendix~\ref{app:frob}): the reading of the two-variable equation as a deformation of the Frobenius lift, with the system of $k$ equations for $q=p^k$; the weight; the carry-free product; the carry operator. The two-variable equation itself is not new for $p=2$: it is Etherington's equation~(33) \cite{Etherington}, and with the variable on the symmetric nodes it is Lemma~1 of \cite{BonaFlajolet}." If a person has read page 436 of Pólya's paper, add: "A two-variable equation of the same shape, for the full symmetric group and another statistic, is equation~(24) of \cite{Polya}." Entry 72 of the reference list forbids citing it before that.
- **Section 1.4, the item on the lattice-path proof, after l. 280.** Add: "More generally, congruences for binomial coefficients from the action of a $p$-group are an established method: Rota and Sagan \cite{RotaSagan} (a cyclic group of order $p^m$; the divisibility half for $N=p^m$) and Sagan \cite{Sagan85} (groups generated by disjoint $p$-cycles; Kummer's theorem is cited there, not proved)." Bibliography entries, with the data of entry 64 of the reference list and nothing else: "Gian-Carlo Rota and Bruce Sagan, ``Congruences derived from group action'', \emph{European Journal of Combinatorics} \textbf{1} (1980), 67--76. [Read by an AI from the author's copy.]" and "Bruce E. Sagan, ``Congruences via Abelian groups'', \emph{Journal of Number Theory} \textbf{20} (1985), 210--237. [Read by an AI from the author's copy.]"
- At l. 1188 and at Corollary C.6 (l. 3949) add "(classical; see \cite{Granville})" after "Legendre's formula with its residue"; at l. 1259 add \cite{Smith}.

### 6. One table that shows the difference (Novelty, Motivation)

Place: end of Section 1.3, after l. 242. Every entry is a statement the report already makes in Sections 1.2 and 1.3.

```latex
\begin{center}\small
\begin{tabular}{@{}>{\raggedright\arraybackslash}p{0.17\textwidth}>{\raggedright\arraybackslash}p{0.24\textwidth}>{\raggedright\arraybackslash}p{0.24\textwidth}>{\raggedright\arraybackslash}p{0.26\textwidth}@{}}
\toprule
 & \cite{Konvalinka}, every $q=p^k$ & \cite{DeutschSagan}, $p=q=2$ & this report, every $q=p^k$\\
\midrule
group at a node & all permutations of the $q$ branches & exchange of the two branches
 & cyclic rotations at $k$ levels of $p$-ary nodes: a $p$-group\\
size of an orbit & a product of multinomial coefficients & a power of $2$
 & $p^{d}$, $d$ the number of asymmetric nodes\\
smallest orbits & described, by the base-$q$ digits of $m$ & described and counted: $(2d-1)(2d-3)\cdots1$
 & described, by the base-$p$ digits of $m$ with a depth condition; counted modulo $p$\\
``exactly'' comes from & the arithmetic formula & the count being odd
 & the count being $\equiv(-1)^t/\prod_jm_j!\not\equiv0$: a carry is a cherry\\
\bottomrule
\end{tabular}
\end{center}
```

Under it, move the sentence now hidden at l. 653, as it stands: "Proposition~\ref{main:prop:carry} replaces the explicit double factorial by a fixed-point count modulo $p$ that works for all $p$ and $k$; for $k=1$ the exact count is Corollary~\ref{main:cor:exact-count}, which for $p=2$ gives $(2s-3)!!$ again."

### 7. Take the bookkeeping out of the reader's way (Clarity)

- l. 190 to 192: delete "The statements in this subsection about the contents of papers are those of the project's reading notes ... who opened what is said in Section 9." and put one sentence at the head of the bibliography, where the notes on each entry already are.
- l. 250 to 252: "\textbf{Claimed}, in the words of the project's ledger and with its caveat (``as far as we know''; this is the outcome ..." becomes "\textbf{Claimed}, as far as we know (this is the outcome of searches by AI systems and of the reading of a handful of papers, and is \emph{not} a certificate of novelty):".
- l. 346 to 347: "The numbers in this subsection are direct enumerations from the definitions, or are recorded as computed in the project's ledger (claims C22 and C23)." becomes "The numbers in this subsection are direct enumerations from the definitions (Section~\ref{sec:computations})."
- l. 1337: "The project ranked 43 candidate connections by how much of the method each contains; the first five are items 1 to 5." Delete; it says nothing about the mathematics.
- l. 1351 and l. 1936: replace "On the slides:" and "the diagram on the slides:" by the content alone. The panel does not have the slides.
- Keep the identifiers C1, C2, ... and E000, ... in the status table and the tables of Sections 6 and 7, and take them out of the prose of Sections 1, 2.1, 2.2, 4 and 5.

### 8. One introduction, not two (Clarity, Correctness)

- Section 3.1: keep Theorem 3.1 and the paragraph "No valuation of a factorial ..." (l. 655); replace the two paragraphs between them (l. 651 and l. 653) by "What was known, and what is and is not claimed, is in Sections~\ref{sec:known} and~\ref{sec:attribution}." This also removes "We have not made a complete search of the literature" (l. 653), which Section 1.4 says better. Note in the status paragraph at l. 610 that these two paragraphs of the source were cut.
- Section 8.2, l. 1854: replace "\LeanVersionStatus{} The formal proofs differ" by "The versions and the build are described in Section~\ref{sec:lean}. The formal proofs differ".
- Sections 4.1 and Appendix A head: print `\PathLeanStatus` once (in Section 7.1) and refer to it from the other two places.

### 9. Close the two loose statements (Correctness)

- **The converse on $T(\mathbf a)$, l. 410 to 413.** The report says the statement is on the slides and not proved. Either (a) the slide says "if" instead of "if and only if", and the sentence in the report goes; or (b) the report proves it. A proof in the report's own terms, written by this reviewer and read by nobody: *In a $p$-ary tree $\sum_{\text{leaves}}p^{-\ell}=1$, $\ell$ the depth of the leaf (replacing a leaf at depth $\ell$ by $p$ leaves at depth $\ell+1$ does not change the sum). Let $D$ be a multiple of $k$ that is at least every depth; then $\sum_{\text{leaves}}p^{D-\ell}=p^{D}$. Modulo $q-1$ we have $p^k\equiv1$, so $p^{D}\equiv1$, and $p^{D-\ell}\equiv p^{c}$ for a leaf of class $c\in\{0,\dots,k-1\}$, because $D-\ell\ge0$ and $D-\ell\equiv c\pmod k$. Hence $\sum_ca_cp^c\equiv1\pmod{q-1}$.* I checked the identity on 1000 random trees for five pairs $(p,k)$. Whichever is chosen, add a row to the status table.
- **The Yule formula, l. 1347 to 1349.** Give one formula and say whose notation it is, or say in a clause how $n_v-1$ and $n(v)$ correspond; if nobody has checked the correspondence, keep only the cited form.
- **Figures A.1, A.2, A.4, A.5:** add to each caption the pictured words, in the style of the addition to Figure A.3 (l. 2678).

### 10. Clean the source for a reader of the source (Attribution, compliance)

- l. 621 and l. 2208 to 2209: after each stale provenance line add "(superseded: see the status paragraph above)" or delete the words "Not yet human-verified", "Not human-reviewed", "Not reviewed by another model. Not human-signed."
- Correct the section numbers in the comments at l. 22, 134, 1128, 1325, 1465, 1531, 1796.
- l. 1 : "Report for the Caltech Mathathon 2026, Problem 137" becomes "Report on Problem 137".
- l. 1922: have a team member confirm which tool wrote the workflow slide, and drop "according to a comment in the source of the slides".
- l. 1400: do not cite a source that nobody opened for a statement tagged [known]; see 3.3.
- Before submission: build the Lean project from a fresh clone of the final commit; confirm that the automated build looks in `lean/`; decide with the organisers whether names in the repository matter; do not submit `report/build/` (its log files contain the local user name, as `report/NOTES.md` already warns).

---

## What I am not sure of

- The scores are one reader's. Interest could come out as 4 and Correctness as 3 with a panelist who weighs "no human has read it" heavily; Clarity will not come out above 3 without change 1.
- My reading of Konvalinka's Remark 3 is from a text extraction with a garbled exponent. The numerical agreement in 474 cases supports the reading; a person should still look at the page before the proposed sentence goes into the report.
- I did not see the result of the Lean build or of the third Lean audit (brief W050). The referee's report (brief W052) was committed at 02:53 while I was finishing; I did not read it, so the two reviews are independent. Its commit message says 26 findings, none in a theorem. If it or a later reading finds a gap in Section 3, Correctness is decided there and not by anything in this file.

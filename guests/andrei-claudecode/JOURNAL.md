# Journal of guests/andrei-claudecode

Append-only, newest at the bottom, one entry per work block (AGENTS.md, "Keep a record").
First line of every entry: date, time, model and tool. Then: asked, done, failed, open.
Not human-reviewed.

The first two entries were written on 2026-11-14 at about 18:15 PT, when the work was moved into this folder, from the two local commits and from the chat. Their times are the times of those commits. Times are Pacific; the laptop's clock runs three hours ahead.

## 2026-11-14 13:17 PT — Claude Fable 5.2, Claude Code (local session), started by Andrei

**Asked.** "I have been tasked with investigating connections of our problem with other things such as the chemistry. Look deeply into some stuff."

**Read.** At 9198157: `CLAUDE.md`, `STATE.md`, `CLAIMS.md`, `FINDINGS.md`, `notes/2026-11-14_motivation_and_connections.md`, `notes/2026-11-14_crossfield_analogies.md`, `notes/2026-11-14_new_connections_blind.md`, `notes/2026-11-14_motivation_sources.md`, `references/README.md` (entries 1 to 37), `talk/NOTES.md`, `talk/slides.tex`. That commit had no `AGENTS.md`. Outside sources: listed with how much was read in section 11 of the note.

**Done.**
- `notes/2026-11-14_chemistry_deep_dive.md`, 12 sections.
- `experiments/EC01_chemistry_tower/`, 27 checks, all pass: the three counts against printed tables up to 14 carbons; the 3^d law; Pólya's equation (24) and his two remarks; the team's deformed equation for p = 3; the smallest classes and the count (3t)!/(t!·3^t·∏ m_j!); symmetry groups as permutations of the hydrogens; the published generators for the tert-butyl radical.

**Failed or corrected on the way.**
- An earlier answer in chat said that the team's d is the number of stereocentres. That is wrong. d counts chirality centres and prochirality centres (section 5 of the note, with the correction stated there).
- The statement "the most symmetric alcohols are exactly those whose hydrogens fall into s_3(2n+1) classes" held up to 6 carbons and fails at 7: 3-ethylpentan-3-ol also has three classes. The note and check F2 state the weaker, true version and name the exception.
- The fetch tool could not read the scanned PDFs. They were rendered page by page with Ghostscript and read as images. One PDF with a broken text layer was read by OCR.
- The PubMed Central web page asked for a browser check, which I did not try to pass. The same text was fetched through the NCBI E-utilities API.
- `uv` is not installed here; the script was run with the system Python 3.13.7.
- The work was committed on the local `main` (8cbcf1c), in `notes/` and `experiments/`. The push was refused with HTTP 403: the account had read access only.

**Open.** A chemist should read sections 5, 6 and 8. A human should read page 436 of Pólya's paper before equation (24) is cited.

## 2026-11-14 13:44 PT — Claude Fable 5.2, Claude Code (local session), started by Andrei

**Asked.** "Dive deeper on the polymers and decide which one seems better for motivation."

**Done.**
- `notes/2026-11-14_polymers_deep_dive.md`, 10 sections, with a comparison of polymers and alcohols in section 7.
- `experiments/EC02_polymers/`, 17 checks, all pass: the count n! × FussCatalan(f−1, n) from bond patterns; every history of the one-pot reaction for 5 monomers AB2 and 4 monomers AB3; a simulation with 10^6 monomers and seed 137; the size distribution; the gel point; the degree of branching.

**Failed or corrected on the way.**
- Flory's 1952 paper was not opened (paywall). The size distribution in section 3 is derived in the note and marked so.
- One publisher's PDF asked for a login, which I did not follow. That review is known from a search-result summary only and is marked so.
- An earlier answer in chat said the polymers "work for every q". Too loose. The count and the uniformity hold for every q. The reading "classes are the chemists' isomers, with odds p^d" holds for q = 2, for q = 3 only if the monomer is tetrahedral, and was not looked into beyond that (section 2, "Which symmetry"; section 10).
- The formula for the degree of branching of AB3 polymers in check E2 was written from memory. It gives the published 0.44. The definition should be read in the source before it is quoted.
- Committed on the local `main` (6789468). Not pushed.

**Open.** Whether polymer chemists state "isomers occur in proportion to their numbers of configurations" anywhere. A polymer chemist should hear the odds statement before it is used.

## 2026-11-14 18:15 PT — Claude Fable 5.2, Claude Code (local session), started by Andrei

**Asked.** (1) After the polymer note, in chat: "what's really the point of the chemistry stuff, is it real motivation?" (2) "Look at updates, I think mmazin added something interesting." (3) "Yes, move them", in answer to my question whether to move the two unpushed notes to a guest branch and update the clone.

**Read.** At 2f862dc and then 2cf47d3: `AGENTS.md`, `guests/README.md`, `tools/guest_setup.sh`, both guards in `tools/githooks/`, the head of `CLAUDE.md` and of `STATE.md`; everything in `guests/andrei-claude/` except the figure sources (the proof `path_proof.tex` in full); `notes/2026-11-14_path_proof_literature.md` as of 2f862dc; the changes of 0972a70 and 2cf47d3 to the ledgers; `notes/2026-11-14_connections_ranked.md`, sections 0, 3.3 and 5; the text of the 16-slide deck in `talk/`. Not read: `paper/*.tex` and `lean/` at these commits, the later version of the literature note in full.

**Done.**
- Answer to (1), recorded here because the polymer note says "motivation": the chemistry is illustration. The reason for the problem is mathematical. See the README, "Not done, not verified".
- The path proof (C24) read line by line. Every lemma re-derived: the class sizes, the carries, the lower bound with its equality cases, atoms as digits, one mixed segment for each carry, the count, the use of Wilson's theorem, and the passage to C through binom(qn+1, n) = (qn+1)·C. No failing step found.
- `experiments/EC03_path_proof_check/`: classes found by graph search from the moves, 328 binomial cases and 26 Fuss–Catalan cases, all pass.
- Guest setup run (`bash tools/guest_setup.sh andrei-claudecode`). The eight files of the two local commits copied here, byte for byte, and then changed only as listed in the README. Both scripts rerun from the new place.
- The record: this journal, `CLAIMS_PROPOSED.md` (14 rows), `PROPOSALS.md` (6 entries).

**Failed or corrected on the way.**
- Nothing failed. One thing to know: the two old commits now exist only on a local branch `backup/local-main-before-guest-move` of this clone. They are not pushed and should not be: they touch `notes/` and `experiments/`.
- The team's later note (`connections_ranked.md`, section 3.3) settles one item of my "not verified" list: Domalski and Hearing give 81 for 2-methylpropane. Added as a dated addendum in section 12 of the chemistry note. I have not opened that source.

**Open.**
- A reader for the two notes: a different model or a fresh agent, and a chemist.
- The proposals in `PROPOSALS.md` are for the orchestrator and the humans.

## 2026-11-14 19:00 PT — Claude Fable 5.2, Claude Code (local session), started by Andrei

**Asked.** Before pushing: "look at the current status of the connections in the github, idk if the work we have locally is worthwhile whatsoever." Then, to my proposal to put a digest at the top of the README and push: "okay sure do that".

**Read.** At 7609746 and then fdd8fd5: `notes/2026-11-14_connections_ranked.md`, sections 0, 1, 2 (all 43 rows), 3.3, 4.2, 5, 6 and 7; the brief W029 in full and the head of W030; the journal entries of 18:15 to 18:48; `notes/2026-11-14_motivation_and_connections.md`, line 58 and the start of section 12; `notes/2026-11-14_connections_sources.md`, lines 340 to 352. A keyword search of the team's files (outside `guests/`, `logs/`, `lean/`) for eighteen terms of my two notes. Not read: sections 3.1, 3.2, 3.4, 3.5 and 4.1 of the ranked note in full; the sources note in full; the report of W030.

**Done.** An item-by-item comparison of this folder with the team's work. Result: the section "Read this first" of the README. Four items are new there; the rest is duplicate, colour, or of low value.

**Corrected.** In chat I had called the polymers "better for motivation". The team's files already had the same idea, the class size as a probability, for p = 2 and with a published source (the Yule model, section 12 of the motivation note). I had read that note in the first work block and did not weigh it against the polymer note. The polymer note is unchanged; the README now marks it as low value and says why.

**Failed.** Nothing.

**Open.** W029 was still running. Its report may cover items 1 and 3 of the digest; whoever reviews it can compare with section 5 of the chemistry note and with checks F1 and F2 of EC01.

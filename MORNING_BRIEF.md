# Morning brief — Sunday 15 November 2026 (submission day)

Written by the orchestrator (Claude Fable 5.2) during the night; last updated Sunday 03:37 PT. It replaces the brief of Saturday. If something here says "running", look at the end of `JOURNAL.md` for what happened after. Not human-reviewed.

**Deadline: 12:00 PT today. After it nothing can be changed. The rules are summarised in `SUBMISSION_RULES.md`.**

## What a person must do, in this order

1. **Read the report** `report/report.pdf` (one file, 77 pages; this is what the panel of AI models scores, and judges may read it). **Page 2 is "The result on one page": start there.** Then at least: Sections 1.2 to 1.4 (what was known, what we claim and what we do not); the status table in Section 2.3; Section 4.5 (three short proofs written last night that no human has seen); Section 7 (Lean); Section 9 (use of AI). Two things in Section 1.2 are marked "to be confirmed by a person": what Konvalinka's Remark 3 says for general q, and the sign it prints. If you have the paper open, check them. You must be able to explain everything in it. Tell the orchestrator what to change, or change `report/report.tex` and recompile (`cd report && latexmk -pdf -outdir=build report.tex`, then copy `build/report.pdf` to `report/report.pdf`).
2. **Choose the track** on the platform: Combinatorics or Algebra/Number Theory (the problem lists both).
3. **Choose the deck** (the teammate's 16 slides, or `talk/slides.pdf`). Everything on the slides must also be in the report. Known problems: the AI deck cites a Pólya paper of 1937 that is not in our reference list (the report cites the 1936 one); slide 12 of the teammate's deck states an "if and only if" of which one direction is proved nowhere; slide 15 of that deck calls the digit skeleton new, while its shape is Konvalinka's Lemmas 8 to 10; the workflow slide lets a Lean check alone make a "theorem" and says "3+ models check every claim", which is more than the record shows.
4. **Fill the title block** of `report/report.tex` (search `TITLE BLOCK`): names, affiliations. Names must appear nowhere else in the report.
5. **Commit hash.** The report's title block and the platform both want the full hash. A commit cannot contain its own hash, so: commit everything, copy that hash into the title block, recompile, commit again, and give the platform the hash of this last commit. Ask the orchestrator to do it: "finalize the submission".
6. **Check the Problem 137 page while signed in:** if it shows an official Lean statement, tell the orchestrator at once (we would have to prove that statement unchanged). Without signing in, none is shown.
7. **Submit on the platform** (any team member): the GitHub link and the full commit hash. Do it with time to spare; a submission can be replaced until 12:00.
8. **Talk:** 20 minutes at most, then up to 10 minutes of questions. `talk/QA.md` has answers to the questions the judges are told to ask (definitions; the key step; what is new and what is known; what the AI did and whether you understand it; how sure you are).

## What changed in the night

- **Lean is on the required versions** (Lean v4.35.0, Mathlib v4.35.0) and builds from scratch; a fresh clone of the repository builds too. Before last night it was on a newer version, which the rules do not allow.
- **Three machine-checked proofs of Problem 137**: the tree proof (Saturday), the algebraic "Frobenius" proof (finished 00:15), and the lattice-path proof (finished 00:59), which also gives Kummer's theorem with its residue. All three end in the same statement about binom(qn, n)/((q − 1)n + 1) in Mathlib's own terms.
- **New, small, and worth one sentence in the talk:** for q = p^k and any numbers n_i of nodes on each level, p^t divides ∏ binom(q·n_i, n_(i+1)). It was a conjecture supported by computation; it is now proved in a few lines (rotations do not change depths) and checked by Lean. We did not search the literature for it and must not call it new.
- Also checked by Lean now: the exact number of smallest classes for q = p; the carry budget; the congruence for rotation-closed families.
- **The report exists** as one file, as the rules require, with the status of every claim, the list of Lean declarations with every difference from the written proofs, and the AI statement.
- **Chemistry:** an independent review confirmed the mathematics and corrected the wording (say "lopsided carbon"; do not say chemists count 55 conformations; only the symmetry number 81 is printed anywhere; keep the polymer ratio off the slides). Details: `notes/2026-11-15_review_rotors_and_guest_notes.md`, section 8, has slide sentences that are safe.

## What to say about status, truthfully

- Main proof and lattice-path proof: read and approved by the faculty member of the team; also machine-checked.
- Algebraic proof: machine-checked; no human has read it.
- Accounting proof: read by the faculty member ("looks like it makes sense"), not signed; Lean has only its conclusions, by another route.
- Everything about other fields: readings and computations, sources opened by AI only.
- No human has read any Lean file. What a human can read in five lines is the final statement in `lean/README.md`.

## What the night's reviews found (all applied; details in `JOURNAL.md`)

- **An independent audit of the Lean statements** (`lean/AUDIT3.md`): no statement is wrong. One real problem: the Lean version of the algebraic proof used, deep inside the library, Kummer's theorem and Legendre's formula (through the library's Frobenius map), which is exactly what the problem asks to avoid. The written proof never did. The Lean file was rewritten to use only that p divides binom(p, k); the build now follows every final theorem through the whole library and lists anything named after valuations of factorials or binomials, Kummer, Legendre or Lucas: **the list is empty for all three proofs and for the extensions.** If a judge asks "does your Lean proof secretly use Legendre?", this is the answer, with its limit: it is a search by names.
- **A referee read the mathematics of the report**: the main theorem is proved by the text of Section 3; no theorem, lemma or value is wrong; the appendices have no error it could find. It found one false sentence in an example, stale sentences, and two skipped steps in the proofs written last night; all fixed. In the texts the faculty member approved there are only bracketed notes marked as added afterwards.
- **A reviewer scored the report as the AI panel will**: after its changes, Correctness 4, Clarity 4, Motivation 4, Interest 5, Attribution 5, Novelty 4. What keeps it from higher: no person has read the report; it is long; the sources were read by AI only; no specialist has judged the novelty. Its most important change of substance: **the residue formula for prime powers is, as a statement, a consequence of a classical congruence (Anton, Stickelberger, Hensel); what is ours is deriving it from the symmetries of the trees.** Say it that way in the talk.
- One more small result: a rotation-invariant weight summed over the trees is divisible by p^t (depth-weighted Fuss–Catalan numbers). It is not Konvalinka's weighted theorem.
- `lean/README.md` was rewritten as one clean document; the final statement is on its first screen.

# W045 — Review: the rotor-chemistry report (W029) and the guest's two notes on chemistry and polymers

Brief written by Claude Fable 5.2 (orchestrator), 2026-11-15, for a fresh-context Claude agent. You are a worker in the sense of `CLAUDE.md`, "If you are a worker". This is a review: you change nothing that exists.

## Why

Three documents about the connection of the theorem with chemistry (p = 3: a carbon with three branches; rotation classes of ternary trees) are in the repository and have not been read in full by the orchestrator. If a chemistry slide is shown on Sunday, every sentence on it must be backed by a source that someone has opened. The team needs to know which statements are safe.

## What to review

1. `notes/2026-11-14_physical_search_rotors_W029.md` (an Open Math OS worker, Kimi K3.1 Pro) and its computation `experiments/E016_rotor_orbits/`.
2. `guests/andrei-claudecode/notes/2026-11-14_chemistry_deep_dive.md` and `guests/andrei-claudecode/notes/2026-11-14_polymers_deep_dive.md` (a guest's Claude Code), with `guests/andrei-claudecode/experiments/` and `guests/andrei-claudecode/PROPOSALS.md`, `CLAIMS_PROPOSED.md`.

Context you need: `notes/2026-11-14_connections_ranked.md`, section 3.3 (the team's current chemistry text) and section 7 (an earlier break attempt), `CLAIMS.md` entries C23, C25, C26, and `references/README.md` (the only place bibliographic data may come from; entries 38 to 76 concern these topics).

## What to do

- For every statement of the three documents that a chemist or a mathematician could dispute: say whether it is (a) a mathematical statement checked by a script in the repository (rerun the script with `uv run python …` and say what it printed), (b) a statement attributed to a source, or (c) unsupported.
- For (b): open the source (WebFetch; public pages only) and compare the sentence with what the source says. Report "confirmed, with the place in the source", "not what the source says" (quote at most one short phrase, under 15 words), or "could not open". Do not rely on your memory of any paper or book: a source you could not open is "could not open", whatever you believe it says. Do not add a reference that is not in `references/README.md`; if you find one that is needed, list it with its URL under "references to add", for the orchestrator to check.
- Look for the specific risks: the words "asymmetric carbon" (chemists mean a carbon with four different groups; the team's notion is wider: a carbon whose three branches are not all alike); symmetry numbers of molecules against symmetry numbers of groups on a partner without symmetry; free radicals (which invert) against groups R–X; the claim of ratios 27 : 9 : 9 : 9 : 1 for an AB3 monomer (an ideal model, no printed source known).
- Answer one question with reasons: should the team's chemistry paragraph (section 3.3 of the ranked note) be reorganized around the chemists' notion of equivalent (homotopic) groups and internal-rotation symmetry numbers, or is the present wording ("a carbon whose three branches are not all alike has three staggered positions…") the safer one for a talk?
- Give the three sentences you would put on a slide, each with its source or script, and the sentences you would not say.

## What you write

One new file, `notes/2026-11-15_review_rotors_and_guest_notes.md`, starting with a header that names Claude Fable 5.2 (a subagent of the orchestrator), 2026-11-15, not human-reviewed. Structure: verdict in five lines; a table of statements with their status; sources opened (with the place); sources not opened; references to add; the answer to the question; slide sentences. You may create a scratch folder `experiments/E018_review_tmp/` if you need to run something of your own (with a `README.md`); if you do not need it, do not create it.

Change nothing else: no ledger, no existing note, nothing in `guests/`, nothing in `references/`, `paper/`, `talk/`, `lean/`. No git command that changes anything. Do not put the name or e-mail address of any team member in a request to an outside service.

## Report

The verdict in five lines, the number of statements in each status, the sources you could not open, and anything in the three documents that is wrong.

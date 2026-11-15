# Changes proposed by guests/andrei-claude to files outside this folder

One entry per change: the file and the place, what is wrong or missing, the exact replacement
text (or a patch file in this folder), and the evidence (AGENTS.md, "How to propose a change").
Not human-reviewed.

## 1. `references/README.md`: add Granville's survey

- **Place:** a new entry at the end of the list.
- **What is missing:** the note in this folder attributes the congruence binom(N, n)/p^c ≡ (−1)^c ∏ N_i!/(n_i! m_i!) to Anton (1869), Stickelberger (1890) and Hensel (1902), and the exponent to Kummer (1852), on the authority of this survey. The team's `notes/2026-11-14_connections_sources.md` already lists the web version; `references/README.md` has no entry.
- **Proposed text:** `NN. Andrew Granville, "Arithmetic Properties of Binomial Coefficients I: Binomial coefficients modulo prime powers", Canadian Mathematical Society Conference Proceedings 20 (1997), 253–275. Web version: https://www.cecm.sfu.ca/organics/papers/granville/paper/binomial/html/node2.html (introduction read by the guest andrei-claude on 2026-11-14). Used for: the attribution of Kummer's theorem and of the Anton–Stickelberger–Hensel congruence.`
- **Evidence and limits:** the journal data is from the reference list of the Wikipedia page "Lucas's theorem", not from the publication itself. Only the introduction (node2) and the start of section 2 (node3) of the web version were read, through a search tool. **To be checked against the source before it is used.**

## 2. `CLAIMS.md` / `paper/` / `talk/`: a second proof on lattice paths (for the team to decide)

- **Place:** `CLAIMS.md` (new rows), and possibly one remark in `paper/main.tex` or one line on the "context" slide.
- **What could be added:** the proof in `notes/2026-11-14_path_proof/path_proof.pdf`, as a second route to C6 and C7. The proposed rows are in `CLAIMS_PROPOSED.md`.
- **What speaks against using it as an answer to Problem 137:** the symmetry acts on paths (binom(qn+1, n) of them), not on q-ary trees, and the result is the special case binom(qn+1, n) of a classical congruence for binomial coefficients. It may be better as a remark ("the same carries appear as mixed segments of a path") than as a headline.
- **Evidence:** `experiments/path_segments/output.txt`; run `uv run python check_paths.py` there.
- **Needed first:** an independent review of the note.

## 3. `references/README.md` (and the paper, where the cherry collapse is introduced): Petersen's proof of Wilson's theorem

- **Place:** a new entry in `references/README.md`; one sentence where `paper/main.tex` introduces the cherry collapse (C5). `grep -i "petersen\|wilson" references/README.md` finds nothing at commit 487bdaf.
- **What is missing:** the smallest case of the cherry collapse is a known proof of Wilson's theorem. With k = 1 and a = (p), the trees are single cherries with p labelled leaves, (p − 1)! of them up to rotation; the relabelling σ fixes p − 1 of them; the collapse gives T((1)), one tree; so (p − 1)! ≡ −1 (mod p). In the literature: the cyclic group of order p acts on the (p − 1)! cyclic permutations of p points by conjugation and fixes p − 1 of them.
- **Sources found (web search, 2026-11-14; excerpts only, the original paper of 1872 was not located):**
  - I. M. Gessel, slides "Combinatorial Proofs of Congruences", Joint Mathematics Meeting, January 2010 (seen on a slide-hosting site, https://www.sambuz.com/doc/combinatorial-proofs-of-congruences-ppt-presentation-983881): "Petersen also gave a similar proof of Wilson's theorem"; (p − 1)! cyclic permutations of p points, C_p acts by conjugation, p − 1 fixed cycles.
  - B. E. Sagan, "Congruences via Abelian Groups" (1985), introduction (https://users.math.msu.edu/users/sagan/Papers/Old/cag-pub.pdf): proving congruences by group actions goes back to a paper of Petersen with the cyclic group of order p.
  - The online textbook at https://math.gordon.edu/ntic/ntic2021/section-congruence-counting-proofs.html gives the same proof with p-gons on p points of a circle, from Carmichael's textbook.
- **To do before use:** get the bibliographic data of Petersen's paper from a source that prints it, and check it. I did not write it down from memory.

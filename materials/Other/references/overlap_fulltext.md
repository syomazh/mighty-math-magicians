# Full-text overlap check of four papers

Detailed assessment by worker W009, `moonshotai/kimi-k3.1-pro`, 2026-11-13; **not human-reviewed**.

## Scope, retrieval, and cautions

The comparison uses claims C1–C11 exactly as stated in `CLAIMS.md`, and the project briefing's definitions of `m=(q-1)n+1`, base-`p` digits `m_j`, `s=s_p(m)`, and `t=(s-1)/(p-1)`. The **claims are the project's, not claims of these papers**. "Already there" below means that the retrieved text states the same claim, possibly in different notation; "partly there" means it states a special case or a substantial component; this includes a known binary special case of a general-prime-power claim. It is not a formal equivalence proof between differently worded results.

All four full texts were found through OpenAlex's DOI lookup using only `open_access.oa_url` and `locations`. **The arXiv copies below were downloaded and read, not the final publisher versions.** Semantic Scholar's four API lookups returned HTTP 429, so they did not supply the download URLs (although earlier saved records supplied arXiv IDs for two papers). The Krattenthaler–Müller OpenAlex record reports CC BY. Sequential requests were spaced more than one second apart, using a generic User-Agent and no personal information. The PDFs, pypdf layout-mode extracts, and retrieval records are local under `references/raw/fulltext/`; `downloads.json` records the four HTTP 200 retrievals and hashes. I read all pages, but this is extraction-assisted reading, not a line-by-line visual verification of every formula in every PDF. Layout extraction can flatten fractions and superscripts or garble diagrams. The relevant formulas (including the source `(2d)!!` and `(2s-1)!!` double factorials and Krattenthaler–Müller (7.9), (7.16), and Corollary 22) were also checked against the rendered PDF pages.

One important normalization: **their `F(n;Q)` is our `C_n^(Q)`, not our `C_n^(Q-1)`**, since
`F(n;Q)=(1/n)binom(Qn,n-1)=1/((Q-1)n+1)binom(Qn,n)`. Also, where they call something a “q-Catalan number,” `q` is a branching factor, whereas in Postnikov–Sagan's `q`-Catalan number `C_n(q)` it is a polynomial weight. The remainder of this section uses `Q` for the generic Fuss–Catalan branching parameter and reserves `Q=p^k` when it is a prime power.

## 1. Yibo Gao and Andrew Gu (2021)

### (a) Full text

arXiv 1908.03914, dated 13 August 2019, 27 pages: **https://arxiv.org/pdf/1908.03914** (OpenAlex `locations.pdf_url`). Local extract: `gao_gu_2021.txt`. Page numbers below are the displayed PDF preprint pages.

### (b) Overlapping results

- **Lemma 2.3 (p. 3):** a binary-tree orbit has size `2^t`, with `t>=s_2(n+1)-1`, and equality occurs for `(2s-1)!!` orbits. This is Deutsch–Sagan's orbit bound and exact orbit count quoted in their paper.
- **Theorem 2.5 (p. 4), “Structure of minimal orbits”:** for `s=s_2(n+1)-1` and the binary expansion of `n+1`,
  > “construct an arbitrary binary tree with s vertices, and then attach completely symmetric trees of depth k1, . . . , ks+1 to the s + 1 endpoints.”

  The paper says the more general `q`-ary description was done by Konvalinka and that reflections at the black skeleton vertices generate the remaining symmetries. This is closely related to the binary case of our digit-atom skeleton description (C3), but the tree model and terminology differ, and the prime-power depth restriction is not present. This is closely related to the binary case of my digit-atom skeleton description (C3), but the tree model and terminology differ, and the prime-power depth restriction is not present.
- **Theorem 2.1 (p. 3):** weaker difference conditions give exact equality of the `2`-adic valuations of weighted and ordinary Catalan numbers. The proof writes the weighted sum as `sum |O| rb(O;0)` over the minimal binary-tree orbits (p. 9), and reduces their average-weight parities recursively.
- **Theorem 3.1 (pp. 13–14):** for `Q=p^k`, under conditions on `b`, `C_n^(Q)(b)` and `C_n^(Q)` are congruent modulo `p^(xi+k)`; it gives our exact digit-sum formula for `xi=v_p(C_n^(Q))`. It derives the weighted result using minimal-orbit constructions, reductions, and base cases. It does not state it as a new unweighted exactness theorem.
- **Theorem 4.2 (p. 17):** eventual periodicity of weighted Catalan numbers modulo `m` is characterized by `m | b(0)...b(k)` for some `k`; it does not supply our unweighted residue modulo `p`.

### (c) Method and the specific Gao–Gu question

There **is a group acting on trees**: reflections exchanging left and right binary subtrees (Definition 2.2), and permutations of all `Q` subtrees at every `Q`-ary vertex (Section 3, p. 13). These correspond, respectively, to the full height-restricted binary-tree wreath product and the full branch-symmetry group, **not** our smaller iterated cyclic `p`-group with cyclic rather than arbitrary order.

The orbit machinery concerns average weight functions and existing lower/minimal orbit bounds. The text neither rederives the unweighted general-`Q=p^k` valuation solely from counting minimum orbits nor constructs a smaller rotation group to do so. The method is a **combination of tree-orbit arguments and finite-difference/2-adic function algebra**, not solely orbit enumeration or solely algebraic generating functions. Proposition 3.4 uses cyclic shifts of people among `Q` rooms to prove divisibility of a multinomial expression, not the orbit decomposition of the whole set of Fuss–Catalan trees. No general-`Q=p^k` residue of `C_n^(Q)/p^t` modulo `p` is stated.

### (d) Verdicts on C1–C11

| Claim | Verdict | Basis in this retrieved copy |
|---|---|---|
| C1 | partly there | Binary wreath-product orbits are powers of two and minimal-orbit reflections are described; no general cyclic-`p` class-size formula as C1. |
| C2 | partly there | Lemma 2.3 gives the binary bound. The prime-power `Q` valuation is in the statement of Theorem 3.1, but not this paper's independent orbit proof. |
| C3 | partly there | Theorem 2.5 gives binary skeletons with complete trees at digit heights; no leaf-depth `mod k` condition or general prime digit multiplicities. |
| C4 | not in this paper | No free action of `prod S_{m_j}` on depth-restricted labelled cyclic skeletons. |
| C5 | not in this paper | No carry–cherry fixed-point recurrence (indices `mod k`). |
| C6 | partly there | The formula is written in Theorem 3.1; this paper's proof is weighted and does not establish our C6 argument independently of the cited valuation machinery. |
| C7 | not in this paper | Theorem 3.1 concerns a difference modulo `p^(t+k)`, not the unit residue of the unweighted sum modulo `p`. |
| C8 | partly there | `(2u-1)!!`, where `u=s_2(n+1)-1`, equals our `(2t)!/(t!2^t)` in the binary case. |
| C9 | partly there | Theorem 3.1 already proves a weighted prime-power-`Q` congruence using full branch symmetries; it neither substitutes our smaller `p`-group into Konvalinka's proof nor discusses C9's proposed weakening. |
| C10 | not in this paper | No level-profile divisibility refinement. |
| C11 | not in this paper | Weighted orbit totalization is not the claimed divisibility and residue for an arbitrary rotation-closed tree family. |

## 2. Christian Krattenthaler and Thomas W. Müller (2025)

### (a) Full text

OpenAlex supplies both the publisher CC BY PDF **https://link.springer.com/content/pdf/10.1007/s00010-025-01195-0.pdf** and the arXiv copy **https://arxiv.org/pdf/1508.02580**; the latter, 36 pages, was downloaded and read. Local extract: `krattenthaler_mueller_2025.txt`. The extract has occasional null-control characters, removed in the local `.txt`; the relevant formulas were visually checked in the PDF. No comparison with the final Springer layout was made.

### (b) Overlapping results and what they state about Fuss–Catalan numbers modulo prime powers

Section 7 treats `F(n;Q)` modulo `p`-powers when `Q=p^h`, exactly the prime-power parameters relevant to us.

- **Theorem 19 (pp. 25–26):** modulo `p^(p^alpha)`, with `alpha` a positive integer, `f_{p;h}(z)` is a polynomial in `Phi_{p;h}(z)` of degree at most `p^((alpha+1)h)-1`.

  The coefficients are Laurent polynomials in `z^(1/(p^h-1))`. Here `Phi_{p;h}(z)=sum_{n>=0}z^(p^(nh)/(p^h-1))` (7.3). This is a general generating-function modulo-prime-power expression, not an orbit count. Its proof iteratively expands a solution of `z f^Q-f+1=0` in powers of `Phi`. After replacing `z` by `z^(Q-1)`, the analogue of the theorem is stated modulo `p^(p^alpha h)`. The first base-stage display (7.9) is only **modulo `p`**, although it uses the same full degree-bound sum as the later lifting steps. The actual nonzero mod-`p` base coefficients (7.10) for `alpha=1`, sufficient modulo `p`, make this distinction important; the PDF was checked because these `p^alpha` exponents are hard to recover from flattened layout text.
- **Residue-mod-`p` observation after Theorem 19 (p. 26):** `F(n;Q) ≡ 1 (mod p)` if `n=(Q^i-1)/(p-1)` for `i>=0`, and `0 (mod p)` otherwise. This characterizes powers of the minimum possible valuation, not all normalized unit residues.
- **Theorem 20 and Corollary 21 (p. 27):** for `Q=p`, an explicit polynomial expression in `Phi` modulo `p^2`. In normalized notation (7.16) it is `z^(-1/(p-1)) Phi^p` modulo `p^2`; the PDF should be consulted for the typeset fraction exponents because text extraction flattens them.
- **Corollary 22 (p. 27):** for `Q=p` modulo `p^2`, the cases are: `1` when `n=(p^i-1)/(p-1)`; `p!/(a_1!...a_r!)` when `(p-1)n+1=sum a_j p^(i_j)` with `r>=2`, `sum a_j=p`, and all `a_j` prime to `p`; and `0 mod p^2` otherwise. This is directly related to the modulo-`p^2` lift of the `Q=p` case of C7, but it is limited to `Q=p`.

### (c) Method and the specific residue question

The method is **algebraic/differential-generating-function recursions and coefficient extraction**, using Lagrange inversion and the auxiliary `H_{b_1,...,b_r}` series. A group or group action on trees is not used in Section 7 (nor used in the paper's demonstrated arguments); “blossom trees” in Section 8 are a different combinatorial enumeration, not the symmetry mechanism. No valuation exactness is derived from orbit sizes.

The displayed modular theorem does **not directly state a general-`h`, general-`t` residue of `F(n;p^h)/p^t (mod p)`**. In principle, its generating-function representation gives enough information for algebraic residue calculations for any prescribed `h`, but this report did not derive C7 as an immediate corollary. The base step reduces modulo `p` to `f(z)=1+z^(-1/(Q-1)) Phi_{p;h}(z)^Q`, written using `Phi(x)^Q=Phi(x) (mod p)` for `Q=p^h`. The text explicitly extracts only the valuation-zero characterization quoted above from this step; coefficient extraction for general `m` involves choices of powers of `Q` and the paper's changing exponent representatives, which I did not resolve in this task.

For `h=1`, Corollary 22 gives a direct check of C7 when `t<=1`: `t=0` is item (i), and in item (ii), with `t=1`, `F(n;p)/p = (p-1)!/prod a_i! (mod p)`; since partitioning base-`p` digits with digit sum `p` requires one carry, this equals `-1/prod m_j! (mod p)`. For larger `t`, the displayed case result is divisibility by `p^2`, not a unit residue; no displayed general-`h`, positive-`t` analogue of the explicit item (ii) formula was found. **These results thus overlap C7 substantially, but the retrieved text prints no general `(-1)^t/prod m_j! (mod p)` formula, and this task did not derive the arbitrary-`h,t` simplification from their representation.** No group- or orbit-based reproof of C6 was found.

### (d) Verdicts on C1–C11

| Claim | Verdict | Basis in this retrieved copy |
|---|---|---|
| C1 | not in this paper | No tree action or cyclic rotation classes. |
| C2 | not in this paper | No tree-object `A`, asymmetric-vertex count, or lower bound by orbit sizes. The valuation-zero characterization is mathematically related but is not C2. |
| C3 | not in this paper | No digit-atom rotation skeletons. |
| C4 | not in this paper | No free symmetric-product action on labelled skeletons. |
| C5 | not in this paper | Coefficient extraction and carry-reduction of `H` indices are algebraic bookkeeping, not cyclic carry-as-cherry fixed points or the `T(a)` recurrence. |
| C6 | partly there | Relevant valuation/residue information follows from generating functions, but nothing proves the main theorem with the tree-symmetry action or replaces factorial valuations by C1–C5. |
| C7 | partly there | Base expansion covers general `Q=p^h` and gives all valuation-`0` cases; Corollary 22 checks `Q=p`, `t<=1`. No displayed general-`h,t` unit residue, and the general simplification was not derived here. |
| C8 | not in this paper | The `t=0` characterization and `Q=p,t=1` formula are algebraic, not a count or structural description of minimum classes. |
| C9 | not in this paper | No weighted `b` theorem or `p`-group substitution. |
| C10 | not in this paper | No profile refinement. |
| C11 | not in this paper | No closed-tree-family residue theorem. |

## 3. Emeric Deutsch and Bruce E. Sagan (2006)

### (a) Full text

arXiv math/0407326, 22 pages: **https://arxiv.org/pdf/math/0407326** (OpenAlex `locations.pdf_url`). Local extract: `deutsch_sagan_2006.txt`. Page numbers below are the displayed preprint pages; theorem numbering agrees with the published numbering cited in the other papers. The arXiv file contains a display date of October 25, 2018, although the project citation is the 2006 publication.

### (b) Overlapping results

- **Theorem 2.1 (p. 3):** `omega(C_n)=delta(n+1)-1`, exactly `v_2(C_n)=s_2(n+1)-1`. It is proved combinatorially after Lemma 2.3 is established.
- **Lemma 2.2 (p. 3):** `G_h = Z_2 wr G_{h-1}`, `#G_h=2^(2^h-1)`, so every `G_h`-orbit has size a power of two.
- **Lemma 2.3 (p. 4):**
  > “with equality for exactly (2d)!! orbits.”

  Put `d=delta(n+1)-1=t`; their `(2d)!!` is exactly our `(2t-1)!!`: they define it as `(2d-1)(2d-3)...3.1`, with the empty product `0!!=1`. For example, `t=2` gives `3`, the three binary total partitions on 3 labels. **This confirms the memory-based known-facts entry in `CLAIMS.md`, with the `d=s-1` parameter, not separately printed as `(2s-3)!!`.**
- **Binary total partitions (pp. 5–6):** the number of these on `d+1` labels is `(2d)!!`. This provides the combinatorial interpretation of the count of minimal orbits.
- **Theorem 5.2 (p. 15):** an explicit ordinary Catalan residue modulo `3`, stated in terms of ternary digits of `n`/`n+1`; it is an ordinary-Catalan (`Q=2,p=3`) computation, not our prime-power-`Q` Fuss–Catalan residue.

### (c) Exactly how the combinatorial exactness proof works

They let `G_n`, the automorphism group of a complete binary tree `T_n`, act on binary trees with `n` vertices (allowing a left child, right child, both, or neither). In the paper's notation, `G_h=Z_2 wr G_{h-1}`: **local exchanges of the two children at every node**, a `2`-group. This is the same minimal cyclic-symmetry mechanism as our `p=2,k=1` action, subject to translating their optional-child trees to our full `p`-ary leaf trees.

Rather than invoke the orbit-stabilizer formula as a product over unstable vertices, they induct on the root subtrees. For orbit sizes they establish (their equation (3)) `|O(T)|=|O(T')|^2` if the subtrees are isomorphic and `2|O(T')||O(T'')|` otherwise. Their binary digit computation gives `d<=d'+d''+1`, with equality exactly for disjoint binary-bit supports. In the equal-subtree case, equality forces the unique complete tree; otherwise the minimum exponent splits recursively into carry-free pieces.

**How the minimum orbits are counted:** at a minimum, the bits of `n+1` are distributed between two unequal child subtrees, and the formula reduces to the recursive convolution (4). They first prove that convolution by Vandermonde after a hypergeometric conversion, then give a **bijective proof using binary total partitions**. The latter are unordered rooted trees with two children at each internal node and labelled leaves; choosing a subset of labels for the left root child and dividing by two for unordered children gives exactly the convolution. The minimum-orbit count is therefore `(2d)!!`, an odd number. From `C_n=(2d)!!2^d+k2^(d+1)` they get exactness. **Yes, the double factorial appears: it counts minimum-size orbits and binary total partitions, not just a factorial-exponent formula.**

Their combinatorial proof does not use our free `prod S_{m_j}` action or cycle-cherry fixed-point contraction; those are later ingredients in our generalization. They do not give a general-`Q=p^k` formula or a residue of the normalized quotient.

### (d) Verdicts on C1–C11

| Claim | Verdict | Basis in this retrieved copy |
|---|---|---|
| C1 | partly there | Complete for `p=2,k=1` after translating tree conventions: the wreath product gives power-of-two orbits and recursive precise exponents (`G_h`, equation (3)); all prime powers are absent. |
| C2 | partly there | Complete binary case: Lemma 2.3 gives the orbit lower bound with disjoint-bit equality; no general prime-power statement. |
| C3 | partly there | Carry-free recursive decomposition/complete-tree equality is there, but no labelled digit-atom proposition as ours. Binary total partitions are described separately. |
| C4 | not in this paper | They count recursively, without quotienting by free equal-atom permutations. |
| C5 | not in this paper | Disjoint-bit supports and total-partition recursion, not cyclic fixed points and cherry collapse. |
| C6 | partly there | Complete for `p=Q=2`: Theorem 2.1 is exactness from tree orbits without factorial valuations. General prime-power `Q` is absent. |
| C7 | partly there | Only ordinary Catalan residues modulo `3` and the odd `(2d)!!` minimum count in the binary case; nothing for all prime-power `Q`. |
| C8 | partly there | Complete binary case: for `Q=p=2`, `(2t)!/(t!2^t)=(2t-1)!!` is exactly Lemma 2.3's minimum-orbit count; no general-`p` count. |
| C9 | not in this paper | No weighted `b` or prime-power `Q` discussion in this proof. |
| C10 | not in this paper | Orbit induction is by root subtree size, not level profiles. |
| C11 | not in this paper | No general closed-tree-family statement. |

## 4. Alexander Postnikov and Bruce E. Sagan (2007)

### (a) Full text

arXiv math/0601339, dated 10 January 2006, 9 pages: **https://arxiv.org/pdf/math/0601339** (OpenAlex `locations.pdf_url`). Local extract: `postnikov_sagan_2007.txt`.

### (b) Overlapping results

- **Theorem 1.1 (p. 2):** ordinary `v_2(C_n)=s_2(n+1)-1`; the paper attributes its combinatorial proof to Deutsch–Sagan and extends that proof to weights.
- **Theorem 2.1 (pp. 4–5):**
  > “Then ξ(C_n^b) = ξ(C_n) = s(n + 1) − 1.”

  It assumes `b(0)` is odd and `2^(n+1) | (Delta^n b)(x)` for `n>=1`.
- **Lemma 2.3 (pp. 6–7):** for binary-tree orbits and `s=s_2(n+1)-1`,
  > “#O = 2^s for exactly (2s − 1)!! orbits.”

  The surrounding discussion identifies these orbits with binary total partitions. This matches the `d=s-1` version in Deutsch–Sagan; again, after setting `t=s`, the count is `(2t-1)!!`.
- **Lemma 2.4 (p. 7):** average orbit weight has an odd function contribution. The paper uses reflection interchange of left/right children; the weighted sum factors into orbit size times an odd-valued function after partitioning into orbits.
- **Corollary 2.5 (p. 8):** for polynomial `q≡1 (mod 4)`, the weighted-by-area `q`-Catalan numbers have the same `2`-adic valuation; this is **not** Fuss–Catalan branching. No residue of `C_n^b/2^t` modulo `2` is issued (it is immediate that the odd residue is 1 for the ordinary unweighted case, but no general prime-power statement is given).

### (c) Method, minimal classes, and weighted analogue

`G_n` is the complete-binary-tree symmetry generated by **reflections exchanging left and right subtrees**. This `2`-group gives power-of-two orbits; the minimum ones correspond to binary total partitions of a label set. Their analogue of our minimal classes is explicitly stated (Section 2, pp. 6–7):

> “orbits of the minimal size can be identified with binary total partitions on the set {1, 2, ..., s}”

This presentation reuses Deutsch–Sagan's class count; it does not carry out the digit skeleton construction or free action/carry fixed points. Its new work is to weight each orbit, using `w_b(T)` depending on left-edge counts, and prove `w_b(O)=#O r_b(O)` with odd average contribution (Lemmas 2.2 and 2.4). Exactness then comes from having an odd number `(2s-1)!!` of orbits of size `2^s`, not from a general-`p^k` orbit-count formula. There is no general `Q=p^k` normalized quotient modulo `p`.

### (d) Verdicts on C1–C11

| Claim | Verdict | Basis in this retrieved copy |
|---|---|---|
| C1 | partly there | Complete binary reflection-group result (`Q=p=2`), summarized from Deutsch–Sagan. |
| C2 | partly there | Complete binary orbit-bound result, stated as Lemma 2.3. |
| C3 | partly there | Minimal orbits as binary total partitions, but not our explicit digit-atom skeleton description in its full form. |
| C4 | not in this paper | No free action of equal-atom symmetric products. |
| C5 | not in this paper | No carry–cherry recurrence; Vandermonde/total-partition recursion is cited. |
| C6 | partly there | Complete ordinary binary special case (`p=Q=2`) of the Deutsch–Sagan proof. |
| C7 | partly there | Only the odd binary unit residue/minimum orbit counts; no general-prime-power `Q` formula. |
| C8 | partly there | Complete binary case (`Q=p=2`): `(2t-1)!!` in Lemma 2.3. |
| C9 | partly there | This is the binary predecessor of the weighted theorem whose prime-power version C9 concerns; no smaller-`p`-group transitivity substitution is made. |
| C10 | not in this paper | No level-profile refinement. |
| C11 | not in this paper | Weighted orbit totals are not the claimed general closed-family statement. |

## Bottom line

The oldest two papers already contain, for ordinary Catalan numbers, the heart of the symmetry-to-exactness argument: a full binary `2`-group generated by local child swaps, recursive exact orbit-size bounds, and a unit count `(2t-1)!!` of minimum orbits; Postnikov–Sagan extends this to weighted parity valuations. Gao–Gu explicitly writes the prime-power Fuss–Catalan valuation as `xi=t` and uses full-tree symmetries together with difference functions for weighted congruences, but does not supply a new independent general-`Q=p^k` minimum-orbit count. Krattenthaler–Müller is substantial algebraic overlap on general-`Q=p^h` congruences: its base step gives the exact valuation-zero cases, and its displayed closed formulas otherwise address `Q=p` modulo `p^2`; it neither states C7 for general `h,t` nor makes its derivation immediate. As far as these retrieved four texts alone go, **the full cyclic-`p` action on `Q=p^k` trees with all leaves at depth `0 mod k`, the depth-restricted labelled skeleton encoding, the free `prod S_{m_j}` action, and the cyclic carry–cherry proof are not present; nor are C10 or C11 or precisely C9's `p`-group transitivity observation.** This is not a novelty certification: only these four arXiv full texts were checked; published versions and cited/related works (especially Konvalinka beyond the given reading, Kauers–Krattenthaler–Müller, An's thesis, Eu–Liu–Yeh, and other literature in the scan) were not newly compared; and this is a textual comparison rather than an independent verification of C1–C11. The claim-grading and the project proofs remain unverified by a human.

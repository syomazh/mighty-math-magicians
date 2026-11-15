Written by a Claude subagent (Claude Fable 5.2, general-purpose, fresh context, given only a brief) on 2026-11-14; not human-reviewed.

# New connections to other fields (blind pass)

The subagent saw only the brief (the definitions, Facts 1-7 and the list of connections the team already has). It read no other file of the repository. Every "exact statement" below was checked with code written for this note; every source was opened on 2026-11-14 unless marked otherwise. Nothing here is graded above `computed`; nothing is human-signed.

**Notation.** p prime, m = number of leaves, N = number of internal nodes, s = digit sum of m in base p, t = (s-1)/(p-1), d(T) = number of asymmetric nodes, sigma(T) = number of symmetric nodes, "atom" = complete tree. "ones(m)" = number of ones of m in binary = s for p = 2.

**Result in one paragraph.** Eight connections survived, ranked best first. Four are rated "exact", three "exact core + analogy", and one "exact" but only a renaming. Two leads were strong enough to change how the result can be shown: (1) quadtrees, where the rotation classes for q = 4 are literally "rotate or mirror any block of the picture", because the symmetry group of a square is a Sylow 2-subgroup of S_4; (2) photon genealogies in laser harmonic generation, where the literature really uses both a minimal and a non-minimal tree for the fifth harmonic. One lead could not be confirmed and is flagged for a human (Etherington's "mutability", section "Open lead").

## Summary table

| # | Field | Object | Rating | Check |
|---|---|---|---|---|
| 1 | Computer graphics, GIS | quadtree subdivisions of a square (q = 4) | exact | passed |
| 2 | Nonlinear optics | cascaded harmonic generation, genealogy of a photon (p = 2) | exact core + analogy | passed |
| 3 | Quantum field theory | tree diagrams of phi^3 theory and their symmetry factors (p = 2) | exact | passed |
| 4 | Network science, planar maps | Apollonian networks / stacked triangulations, Sierpinski refinement (p = 3) | exact | passed |
| 5 | History of arithmetic, cryptography, numerical analysis | double-and-add: Egyptian multiplication, square-and-multiply, exact doublings (p = 2) | exact core + analogy | passed, with one caveat found |
| 6 | Security engineering | Merkle hash trees of RFC 6962 (p = 2) | exact (overlaps binomial heaps) | passed |
| 7 | Developmental biology | cell lineage trees (p = 2) | exact core + analogy | passed (no real lineage data used) |
| 8 | Combinatorics, kinetic art | mobiles and necklaces (all p) | exact (a renaming, with OEIS anchor) | passed |

## How the checks were run

All code is in `experiments/E013_new_connections_blind/`, standard library only, run from the repository root with `uv run python experiments/E013_new_connections_blind/<script>` (Python 3.13.14). Each script asserts its claims and prints a table; the output is saved next to it as `<script>_output.txt`. Total run time is under one minute.

| Script | What it checks |
|---|---|
| `trees.py` | helpers written from the brief's definitions: enumeration of ordered p-ary trees, canonical form of a rotation class, d and sigma |
| `classpoly.py` | Z_m(y) without enumerating trees, from a "nested necklace" recursion (derived in connection 8) |
| `c12_subdivisions.py` | connections 1 and 4 by brute force in a purely geometric model |
| `c1b_qary_classes.py` | connection 1 for N up to 60 (quadtrees), octrees and 9-ary trees |
| `c3_feynman.py` | connection 3 |
| `c4_harmonics.py` | connection 2 |
| `c5_double_and_add.py` | connection 5, including the addition-chain caveat and IEEE doubles |
| `c6_merkle_mergesort.py` | connection 6, and merge sort (rejected list) |
| `c7_lineages.py` | connection 7 |
| `c8_mobiles_necklaces.py` | connection 8, and Facts 2, 4, 7 for p = 2, 3, 5, 7 far beyond brute force |
| `c9_merge_games.py` | 2048 and merge-three games (rejected list) |

No check failed. One check found a limit of a statement (connection 5, reuse of intermediate results) and it is reported there.

---

## 1. Quadtrees: rotate or mirror any block (q = 4)

**Field and object.** A quadtree stores a picture or a map by cutting a square into four equal quadrants and cutting some of those again, and so on. It is a standard structure for image compression, spatial indexing and mesh generation.

**Dictionary.**

| Ours | Quadtree |
|---|---|
| q-ary tree, q = 4 = 2^2 (Fact 6) | a subdivision of the square by N successive quarterings |
| node | a block that has been quartered |
| leaf | a cell; m = 3N + 1 cells |
| the binary reading | a block = two diagonals, each diagonal = two opposite quadrants |
| rotation (swap at a binary node) | a rigid symmetry of a block, applied in place: rotate it by 90 degrees or mirror it |
| symmetric node | a block whose two diagonal pairs carry equivalent content (or a pair whose two quadrants do) |
| atom | a block quartered uniformly down to some depth (for odd height: one diagonal pair of such blocks) |
| p | 2 |

The point that makes this exact: the eight symmetries of a square permute its four quadrants, and they preserve the pairing {SW, NE}, {SE, NW} into diagonals. The group of all permutations of four things preserving a pairing is C2 wr C2, of order 8. So the symmetry group of the square, acting on the quadrants, **is** the group that Fact 6 puts at a 4-ary node (two levels of binary swaps), and it is a Sylow 2-subgroup of S_4. Rotating a whole block also turns everything inside it, but since every inner block may be turned back independently, the moves "apply a symmetry of the square to any block" generate exactly the rotation equivalence.

**Exact statement.** Let Q_N be the set of quadtree subdivisions of a square with N quarterings; |Q_N| = binom(4N, N)/(3N+1). Call two subdivisions equivalent if one is obtained from the other by repeatedly choosing a quartered block and rotating or mirroring it in place. Then:

1. every equivalence class has exactly 2^d members (Fact 1, read through Fact 6);
2. no class has fewer than 2^t members, t = ones(3N+1) - 1 (Fact 2);
3. the number of classes with exactly 2^t members is odd (Fact 4 with p = 2);
4. hence 2^t divides |Q_N| and 2^(t+1) does not (the theorem for q = 4).

Small cases a listener can verify by hand: N = 2 gives 4 subdivisions in one class (7 = 111 in binary, t = 2). N = 3 gives 22 = 2 + 4 + 16: the class of size 2 is "two opposite quadrants quartered", the class of size 4 is "two adjacent quadrants quartered", the class of size 16 is "a quadrant quartered and one of its quadrants quartered again"; 10 = 1010 in binary, t = 1, and 22 = 2 * 11. N = 5 gives 969, odd, and the single class of size 1 is the uniform 4 x 4 grid (16 cells, a power of 2).

**Check.** `c12_subdivisions.py`: pictures are sets of cell addresses; moves are the geometric rotation and mirror of a block; orbits are found by exhaustive search with no reference to trees, then compared with the brief's definition. N = 0..6 (up to 7084 subdivisions, 44 orbits): the group on the quadrants has order 8 and equals C2 wr C2 on the diagonals; orbits coincide with rotation classes; all orbit sizes equal 2^d; smallest orbit 2^t; number of smallest orbits odd (it was 1 each time); valuation equals t. All passed. `c1b_qary_classes.py`: the same four statements from a recursion, N = 0..60: passed. Valuation formula alone, N = 0..3000: no failure.

Independent external cross-check: the numbers of orbits found, 1, 1, 1, 3, 6, 17, 44, 129, 373, 1131, 3453, 10777, 33947, 108272, 348119, agree term by term with the first 15 terms of OEIS A398109 (see Source), which counts 4-ary trees up to the dihedral group at every node.

Two side results. (a) The other natural reading, "cut the square in half, then each half in half" (pairs = rows), gives a different partition of Q_N into classes with the same list of class sizes (checked N = 0..6); its move is "swap the two halves of any dyadic rectangle". (b) Octrees (q = 8): the valuation statement v_2(binom(8N,N)/(7N+1)) = ones(7N+1) - 1 holds (N = 0..3000, and the class statements for N = 0..25), but the local group has order 128 while the cube's symmetry group has order 48 with 2-part 16, so for octrees there is no picture by rigid motions. This is analogy only and is not counted as a connection.

**Source.**
- Hanan Samet, "The Quadtree and Related Hierarchical Data Structures", ACM Computing Surveys, volume 16, issue 2, pages 187-260, published 1984-06, DOI 10.1145/356924.356930. Opened: the Crossref record https://api.crossref.org/works/10.1145/356924.356930 (bibliographic data only; the article text was not opened).
- Pointer for the definition and the uses (image compression, spatial indexing, mesh generation): https://en.wikipedia.org/wiki/Quadtree. It says the structure was named by Raphael Finkel and J.L. Bentley in 1974.
- OEIS A002293, name "Number of dissections of a polygon: binomial(4*n, n)/(3*n + 1)."; a comment there says it counts quartic rooted ordered trees. Opened: https://oeis.org/search?q=id:A002293&fmt=json.
- OEIS A398109, name "Number of 4-ary dyslexic mobiles with n internal nodes.", author Andrew Howroyd, Jul 20 2026; its generating function uses the cycle index of the dihedral group of order 8. Opened: https://oeis.org/search?q=id:A398109&fmt=json. The parent table A398108 (opened the same way) explains that "dyslexic" means reversals are also allowed, so that the group at a node with k children is the dihedral group.
- Not confirmed: that anyone has stated the 2-adic valuation of A002293 in terms of block rotations. No such source was looked for beyond the OEIS entries above.

**Picture.** The 22 subdivisions of a square with three quarterings, drawn as small squares and grouped into three framed families of 2, 4 and 16. Inside each family, curved arrows show a block being turned by 90 degrees. Under the frame: "22 = 2 + 4 + 16, three powers of two; the smallest is 2^1; 3*3+1 = 10 = 1010 in binary has two ones". A second panel shows a photograph stored as a quadtree with one block highlighted and rotated.

**Honesty rating.** Exact. The object is literally ours (Fact 6 with q = 4) and the statement is the theorem. What is new is only the observation that the local group is the symmetry group of the square.

---

## 2. Laser harmonics: the genealogy of a photon (p = 2)

**Field and object.** A nonlinear crystal can fuse two photons into one photon carrying the sum of their energies. Laser engineers chain such stages to turn infrared light into green and ultraviolet light: the "m-th harmonic" photon is made of m pump photons.

**Dictionary.**

| Ours | Nonlinear optics |
|---|---|
| binary tree with m leaves | the genealogy of one photon of the m-th harmonic: which photons were fused, in which order |
| leaf | one pump photon (frequency w) |
| node | one fusion event in a second-order crystal |
| leaf count of a subtree | frequency of that intermediate photon in units of w |
| symmetric node | second-harmonic generation (SHG): two photons with identical histories fuse |
| asymmetric node | sum-frequency generation (SFG): the two inputs have different histories |
| atom of height j | the 2^j-th harmonic made by j doublings |
| rotation | exchanging the two inputs of a crystal (physically nothing changes) |
| carry | a fusion of two photons of equal frequency |
| p, m | 2, harmonic order |

Two counts are natural: d(T), the nodes whose inputs have different histories, and u(T), the nodes whose inputs have different frequencies (leaf counts). Always u(T) <= d(T).

**Exact statement.** In the genealogy of any photon of the m-th harmonic made by two-photon fusions, at least ones(m) - 1 of the m - 1 fusion events are sum-frequency events. This holds for both counts, min d = min u = ones(m) - 1, the schemes attaining the minimum are the same for both counts, and they are exactly the schemes of Fact 3: make the harmonics 2^j for the binary digits of m by repeated doubling, then add frequencies that never coincide.

For d this is Facts 2 and 3. For u it does not follow from Fact 2 (u can be smaller than d) and needs its own three-line proof, in the spirit of the carry count of Fact 5: write s(n) for the binary digit sum and prove u(T) >= s(m) - 1 by induction. If the root joins frequencies a != b, then u >= 1 + (s(a) - 1) + (s(b) - 1) >= s(a+b) - 1 because digit sums are subadditive. If it joins a = b, then u >= 2(s(a) - 1) >= s(a) - 1 = s(2a) - 1. Equality forces, in the first case, no carry in a + b and both sides optimal, and in the second case s(a) = 1 with both sides optimal, that is a complete tree.

What a practitioner can check against the literature (pump at 1064 nm): third harmonic, 355 nm = 2 + 1, one SFG stage, bound 1; fourth harmonic, 266 nm = 2 + 2 by doubling twice, no SFG stage, bound 0; fifth harmonic, 213 nm: both recipes occur in the sources below, 4 + 1 (one SFG event in the genealogy, the minimum) and 3 + 2 (two SFG events, not minimal). The theorem says that no recipe for the fifth harmonic can avoid SFG altogether and that 4 + 1 is the only genealogy with a single SFG event.

Caveat, found by the check in connection 5: an apparatus is not a tree, because one beam can be split and used twice. If one counts SFG crystals in an apparatus instead of SFG events in a genealogy, the bound ones(m) - 1 still holds for every m < 15 (exhaustive search) but fails at m = 15: 3 = 2 + 1, then 12 by two doublings of the 3, then 15 = 12 + 3 uses two SFG crystals, while ones(15) - 1 = 3. The genealogy of that photon still contains six SFG events.

**Check.** `c4_harmonics.py`, all binary tree shapes for m = 1..20 (293547 shapes for m = 20): min d = min u = ones(m) - 1; the two sets of minimisers are equal and equal to the set of shapes of Fact 3 (tested by a structural predicate). All passed. The script prints every scheme for harmonics 3 to 7 with its d and u.

**Source.**
- Y. K. Yap, M. Inagaki, S. Nakajima, Y. Mori, T. Sasaki, "High-power fourth- and fifth-harmonic generation of a Nd:YAG laser by means of a CsLiB_6O_10", Optics Letters, volume 21, issue 17, page 1348, published 1996-09-01, DOI 10.1364/ol.21.001348. Opened: the Crossref record https://api.crossref.org/works/10.1364/OL.21.001348 and the abstract at https://www.osti.gov/biblio/434707-high-power-fourth-fifth-harmonic-generation-nd-yag-laser-means-cslib-sub-sub, which says that 213 nm was produced by sum-frequency mixing of the 266 nm and 1064 nm beams (the 4 + 1 recipe). How the 266 nm beam was made is not stated in that abstract.
- "Higher and higher", Laser Focus World, May 1, 2003, author not listed on the page, https://www.laserfocusworld.com/lasers-sources/article/16554593/higher-and-higher. A trade-magazine article: third harmonic by doubling and then mixing the second harmonic with leftover fundamental; fourth harmonic by doubling the second harmonic; fifth harmonic by mixing the third with the second (the 3 + 2 recipe).
- Not opened: the RP Photonics Encyclopedia article on frequency tripling (the server returned HTTP 403).

**Picture.** Left: a row of crystals, an infrared beam entering, green after the first crystal, ultraviolet after the last. Right: two binary trees for the fifth harmonic side by side, leaves drawn as five red photons. Tree A: ((1+1)+(1+1))+1, doublings in green, the one sum-frequency node in orange, label "4 + 1, used at 213 nm (Optics Letters 1996)". Tree B: ((1+1)+1)+(1+1), two orange nodes, label "3 + 2, also used". Caption: "5 = 101 in binary: one orange node is unavoidable, and tree A is the only way to have just one."

**Honesty rating.** Exact core + analogy. The tree and the counting are exact; for p = 2 the two inputs of a crystal are physically unordered, as in our equivalence. The analogy part: real apparatus reuse beams (see the caveat), and engineers choose recipes by phase matching and available power, not by this count. The third-order analogue (three photons in, one out, which makes only odd harmonics, m = 2N + 1 as for ternary trees) is analogy only, because the three inputs are physically unordered (group S_3, not C_3).

---

## 3. Feynman diagrams: the largest symmetry factor is a Sylow order (p = 2)

**Field and object.** In quantum field theory an amplitude is a sum over diagrams, each divided by its symmetry factor (the number of ways the diagram can be mapped to itself). For a field with a cubic self-interaction, the diagrams without loops ("tree level", the classical approximation) are binary trees.

**Dictionary.**

| Ours | phi^3 theory in zero dimensions |
|---|---|
| rotation class of a binary tree with m leaves | a tree diagram for the one-point function with m sources J |
| root | the external leg |
| leaf | a source J |
| node | a cubic vertex, coupling g |
| ordered tree | one term in the iteration of the equation of motion phi = J + (g/2) phi^2 |
| symmetry group of the class (order 2^sigma, faithful on leaves) | the automorphism group of the diagram; its order is the symmetry factor S |
| minimal tree | a diagram with the largest possible symmetry factor |
| Catalan number | 2^(m-1) times the coefficient of g^(m-1) J^m in the classical field |

**Exact statement.** For the action phi^2/2 - g phi^3/3! - J phi the classical field is phi(J) = sum over tree diagrams T of g^(m-1) J^m / S(T), and:

1. S(T) = 2^sigma(T), and the automorphism group acts faithfully on the sources (Fact 1);
2. sum over diagrams with m sources of 1/S(T) = Catalan(m-1) / 2^(m-1) (Fact 1 again: each class has 2^d ordered trees and d + sigma = m - 1);
3. the largest symmetry factor among diagrams with m sources is the largest power of 2 dividing m!, that is the order of a Sylow 2-subgroup of S_m, and the diagrams attaining it are the minimal trees (Fact 3);
4. the number of diagrams with the largest symmetry factor is odd (Fact 4); for p = 2 it equals (2s - 3)!!, the number of ways to join s different atoms;
5. hence the coefficient Catalan(m-1)/2^(m-1) in lowest terms has denominator exactly the largest symmetry factor, which is the theorem v_2(Catalan(m-1)) = ones(m) - 1 in physical clothing: the 2-adic size of the classical amplitude is set by its most symmetric diagrams.

Useful for the question session: multiplying statement 2 by m! gives m! * sum 1/S = (2m-3)!!, the number of trees with labelled sources, which is odd. Together with Legendre's formula for v_2(m!) this is the short proof by factorial valuations that the problem excludes. Statement 3 is what replaces Legendre in the team's proof: the largest symmetry factor is a Sylow order.

**Check.** `c3_feynman.py`. (a) All leaf-labelled unordered binary trees for m = 1..8 (135135 trees for m = 8) were generated and grouped by shape; for every shape, m! divided by the number of labellings equals 2^sigma, which proves both S = 2^sigma and faithfulness for these m. (b)-(e) For m = 1..20 (293547 diagrams for m = 20): the series solution of phi = J + (g/2) phi^2, computed by iteration with exact fractions, equals the sum over diagrams of 1/2^sigma and equals Catalan/2^(m-1); the largest symmetry factor equals the 2-part of m! (found by dividing m!, not by Legendre); the number of diagrams attaining it is odd and equals (2s-3)!!; the denominator of the coefficient equals the largest symmetry factor. All passed. Example row: m = 7, 11 diagrams, coefficient 33/16, largest symmetry factor 16 = 2-part of 7!, attained by 3 diagrams.

**Source.** E.N. Argyres, A.F.W. van Hameren, R.H.P. Kleiss, C.G. Papadopoulos, "Zero-dimensional field theory", The European Physical Journal C, volume 19, issue 3, pages 567-582, published 2001-03, DOI 10.1007/s100520100630; arXiv:hep-ph/0101346, submitted 31 January 2001. Opened: https://arxiv.org/abs/hep-ph/0101346, the Crossref record https://api.crossref.org/works/10.1007/s100520100630, and pages 1-4 of https://arxiv.org/pdf/hep-ph/0101346. Section 2.1 derives the equation for the generating function of connected Green's functions from the diagrams; its equation (3), with the loop parameter set to zero and only the cubic vertex kept, is our phi = J + (g/2) phi^2 up to their sign and mass conventions. On symmetry factors the paper says: "The factor 1/(k-1)! is due to the k-1 identical blobs." Not confirmed in this source: the explicit sentence "the symmetry factor of a tree diagram is 2^(number of symmetric vertices)"; that is our Fact 1, checked by computer above.

**Picture.** The eleven tree diagrams with seven sources, each with its symmetry factor written underneath (16, 16, 16, 8, 8, 8, 4, 4, 4, 4, 2), the three with factor 16 circled (these multiplicities are from the check: 3, 3, 4 and 1 diagrams with 2, 3, 4 and 5 asymmetric vertices). Below: "3/16 + 3/8 + 4/4 + 1/2 = 33/16 = 132/64 = Catalan(6)/2^6", and "16 = the largest power of 2 dividing 7! = the order of a Sylow 2-subgroup of S_7".

**Honesty rating.** Exact for p = 2: the diagrams are literally the classes and the symmetry factor is literally 2^sigma. For p >= 3 it is not exact (a physical vertex is symmetric under all permutations of its legs, not only cyclic ones). The general Fuss-Catalan numbers still appear as the coefficients of the solution of phi = J + g phi^p, but without the symmetry-factor reading.

---

## 4. Apollonian networks and Sierpinski refinement: rotate the inside of a triangle (p = 3)

**Field and object.** Put a point inside a triangle and join it to the three corners; repeat inside any of the small triangles. The graphs obtained are called stacked triangulations, planar 3-trees or Apollonian networks, and are used in network science as models of scale-free, small-world networks. A second realisation with the same trees: replace a triangle by its three corner triangles of half the size (one step of the Sierpinski gasket) and repeat in some of them.

**Dictionary.**

| Ours | Triangle subdivisions |
|---|---|
| ternary tree with N nodes | a stacked triangulation with N inner vertices and a labelled outer triangle; or a partially refined Sierpinski gasket |
| node | a triangle that has been subdivided |
| leaf | a face (m = 2N + 1 faces) |
| rotation | cut out the inside of a subdivided triangle and put it back turned by 120 degrees |
| why rotations and not reflections | the rotation group of a triangle is C_3; mirrors are excluded, exactly as in the definition |
| symmetric node | a triangle whose three parts carry equivalent content |
| atom of height j | the Apollonian network of generation j, or the level-j Sierpinski gasket (3^j faces) |
| p | 3 |

**Exact statement.** The number of stacked triangulations with N inner vertices and a given outer triangle is binom(3N, N)/(2N+1). Under the moves "turn the inside of any subdivided triangle by 120 degrees" every class has 3^d members; no class has fewer than 3^t, t = (s_3(2N+1) - 1)/2; the number of classes of size 3^t is congruent to (-1)^t / prod a_j! modulo 3, so not divisible by 3; hence the number of such triangulations is divisible by exactly 3^t (Facts 1, 2, 4 and the theorem). The classes with 3^t members are those built from Apollonian networks (atoms), a_j of generation j for each ternary digit a_j of 2N + 1 (Fact 3).

Small cases: N = 2: 3 triangulations, one class. N = 3: 12 = 3 + 9. N = 4: 55 = 1 + 9 + 9 + 9 + 27, and the class of size 1 is the Apollonian network of generation 2 (9 = 3^2 faces).

For other primes the same picture exists: replace a regular p-gon by p smaller copies at its corners ("Sierpinski p-gon"); turning by 360/p degrees permutes the copies cyclically. This was not checked separately; it is the definition drawn.

**Check.** `c12_subdivisions.py`. (a) Geometric model as in connection 1 with the 120-degree rotation, N = 0..7 (up to 7752 pictures, 74 orbits): orbits equal rotation classes, sizes 3^d, smallest 3^t, number of smallest orbits congruent to the prediction of Fact 4 (for N = 6, m = 13 = 111 in base 3, there are 2 smallest orbits and the prediction is 2 mod 3), valuation t, and the congruence C * prod a_j! = (-3)^t mod 3^(t+1). All passed. The numbers of orbits 1, 1, 1, 2, 5, 11, 28, 74 are the first terms of OEIS A000625, which the team already uses. (b) Stacked triangulations as graphs: for N = 0..6 the graphs were built from the trees and compared up to isomorphism fixing the outer triangle, by brute force over all relabellings of the inner vertices; the number of non-isomorphic graphs is 1, 1, 3, 12, 55, 273, 1428 = binom(3N,N)/(2N+1). Passed. (c) Valuation formula alone, N = 0..3000: no failure.

**Source.**
- OEIS A001764, name "a(n) = binomial(3*n,n)/(2*n+1) (enumerates ternary trees and also noncrossing trees)."; a comment signed Allan Bickle, Feb 20 2024, says it counts Apollonian networks (planar 3-trees) with n+3 vertices and a given base triangle. Opened: https://oeis.org/search?q=id:A001764&fmt=json.
- Alexis Darrasse, Michèle Soria, "Degree distribution of random Apollonian network structures and Boltzmann sampling", DMTCS Proceedings vol. AH, 2007 Conference on Analysis of Algorithms (AofA 07), DOI 10.46298/dmtcs.3521; pages not shown on the page opened. Opened: https://dmtcs.episciences.org/3521. The abstract states a bijection between these network structures and ternary trees.
- Jose S. Andrade, Hans J. Herrmann, Roberto F. S. Andrade, Luciano R. da Silva, "Apollonian Networks: Simultaneously Scale-Free, Small World, Euclidean, Space Filling, and with Matching Graphs", Physical Review Letters, volume 94, issue 1, article 018702, 2005, DOI 10.1103/physrevlett.94.018702. Opened: Crossref search record only (bibliographic data; text not opened).
- Marie Albenque, Jean-François Marckert, "Some families of increasing planar maps", arXiv:0712.0593, submitted 4 Dec 2007; journal reference not shown on the page. Opened: https://arxiv.org/abs/0712.0593 (the abstract is about rooted stack-triangulations; it does not mention ternary trees).

**Picture.** A triangle subdivided three times (seven faces), shown in its 12 versions arranged as a family of 3 and a family of 9; a circular arrow inside one inner triangle shows its content turning by 120 degrees. Next to it the generation-2 Apollonian network with the caption "nine faces, 9 = 100 in base 3, alone in its class: the atom". For a general audience the Sierpinski version is prettier: a gasket in which some triangles are refined further and one refined triangle is being turned.

**Honesty rating.** Exact. The objects are literally ternary trees and the move is literally the cyclic rotation. Caution: the move changes the graph (it is not a graph isomorphism), so the classes are not isomorphism classes of networks; a network scientist would have to accept "turn the inside of a triangle" as a natural move.

---

## 5. Double-and-add: Egyptian multiplication, square-and-multiply, exact doublings (p = 2)

**Field and object.** To compute m times x the ancient Egyptians doubled x repeatedly and added the doubles selected by m; the same idea with squaring instead of doubling is how computers raise numbers to large powers in cryptography. Any way of computing m*x by additions alone (or x^m by multiplications alone) without reusing intermediate results is a binary tree with m leaves.

**Dictionary.**

| Ours | Arithmetic |
|---|---|
| binary tree with m leaves | a formula for m*x using only +, or for x^m using only multiplication |
| leaf | one copy of x |
| symmetric node | a doubling y + y (a squaring y*y): both operands are the same computation |
| asymmetric node | a genuine addition (multiplication) of two different intermediate results |
| atom of height j | 2^j * x (x^(2^j)), j doublings (squarings) |
| skeleton | the additions of the selected doubles |
| minimal tree | the binary method |
| carry | adding two equal multiples of x |

**Exact statement.**

1. Every tree-shaped computation of m*x contains at least ones(m) - 1 genuine additions (Fact 2). The computations with exactly ones(m) - 1 are precisely "double up to 2^j * x for each binary digit of m, then add these in any order" (Fact 3); there are (2s-3)!! of them up to exchanging operands, an odd number (Fact 4). The Egyptian method and the binary methods of the cryptography handbooks are among them.
2. In IEEE-754 binary floating point, summing m copies of x along a tree T, no symmetric node ever commits a rounding error, so the number of rounding errors is at most d(T). Reason: equivalent subtrees compute bit-identical values because floating-point addition is commutative, and y + y = 2y is exact in radix 2 unless it overflows.

Caveat (a limit of the statement, found by the check): statement 1 is about trees. If an intermediate result may be used several times (an addition chain), fewer genuine additions can suffice. With free doublings the tree optimum is beaten for the first time at m = 15 (two genuine additions: 3 = 2 + 1, 12 = 4 * 3, 15 = 12 + 3, against ones(15) - 1 = 3), and for m <= 64 exactly at m = 15, 27, 30, 31, 45, 47, 51, 54, 55, 59, 60, 61, 62, 63.

**Check.** `c5_double_and_add.py`. (1) The binary-method tree has d = ones(m) - 1 for m = 1..5000. (2) All tree shapes for m = 1..20: the minimum of d is ones(m) - 1; the minimisers are exactly the Fact-3 shapes; their number is (2s-3)!!. (3) Exhaustive search over computations with reuse, free doublings, at most three genuine additions, m <= 64: result as in the caveat. (4) Python floats (IEEE doubles), 205 values of x (random 53-bit mantissas, half of them odd, exponents from -40 to 40, plus 1, 3, 0.1, 0.001, 2^53 - 1), all tree shapes for m = 1..12, each addition compared with exact rational arithmetic: no symmetric node ever rounded; the number of roundings never exceeded d(T). All passed. Additional observation, `computed` only on this sample: for every m <= 12 the smallest worst-case number of roundings over all shapes was exactly ones(m) - 1.

**Source.**
- "Handbook of Applied Cryptography by A. Menezes, P. van Oorschot and S. Vanstone", copyright line "1997 by CRC Press, Inc.", chapter 14 "Efficient Implementation", section 14.6.1, Algorithm 14.76 (right-to-left binary exponentiation) and Note 14.78, page 614: the algorithm "performs t squarings and wt(e) - 1 multiplications", where t + 1 is the bit length and wt(e) the number of ones of the exponent. Opened: https://cacr.uwaterloo.ca/hac/about/chap14.pdf (pages 613-615 read). Note that the handbook counts t squarings because it reuses each square; in the tree every copy is counted, which gives m - ones(m) symmetric nodes.
- J J O'Connor and E F Robertson, "Mathematics in Egyptian Papyri", MacTutor History of Mathematics (University of St Andrews), last updated December 2000, https://mathshistory.st-andrews.ac.uk/HistTopics/Egyptian_papyri/. Worked example there: 41 * 59 by doubling 59 five times and adding the rows for 1, 8 and 32. Since 41 = 101001 in binary, that is ones(41) - 1 = 2 additions.
- Nicholas J. Higham, "The Accuracy of Floating Point Summation", SIAM Journal on Scientific Computing, volume 14, issue 4, pages 783-799, published 1993-07, DOI 10.1137/0914050. Opened: Crossref record only, https://api.crossref.org/works/10.1137/0914050; the article text was not opened, so its relevance (summation orders as trees) is not confirmed.

**Picture.** The MacTutor example as a two-column Egyptian table (1, 2, 4, 8, 16, 32 against 59, 118, 236, 472, 944, 1888) with the rows 1, 8, 32 ticked; beside it the same computation as a tree: three complete binary trees with 1, 8 and 32 leaves joined by two orange nodes. Caption: "41 = 101001: two additions, and no tree can do with fewer."

**Honesty rating.** Exact core + analogy. Statements 1 and 2 are theorems about trees and are literally what the algorithms do. The analogy part: practical cost models allow reuse (addition chains), where the bound fails from m = 15 on. This connection is the arithmetic twin of connection 2, and both are close relatives of the binary counter the team already has; the new content is that the optimal formulas are characterised and counted.

---

## 6. Merkle hash trees for a number of leaves that is not a power of two (p = 2)

**Field and object.** A Merkle tree lets one short hash commit to n records: records are hashed in pairs, the hashes again in pairs, up to a single root. Certificate Transparency, the public log system for web certificates, fixes by standard how the tree is shaped when n is not a power of two.

**Dictionary.**

| Ours | Merkle tree |
|---|---|
| binary tree with m = n leaves | the hash tree over n log entries |
| node | one hash of two child hashes |
| atom | a perfect (complete) subtree |
| skeleton | the nodes joining perfect subtrees of different sizes |
| minimal tree | the RFC 6962 tree |
| carry | when a new entry completes two perfect subtrees of the same size, they are joined into one |

**Exact statement.** The tree that RFC 6962 prescribes for n leaves is a minimal tree: its maximal perfect subtrees have sizes 2^j for exactly the binary digits j of n (Fact 3), and it has ones(n) - 1 asymmetric nodes, the smallest number possible for any binary hash tree on n leaves (Fact 2). It is one of (2s-3)!! shapes with this property (Fact 4), the one that joins the perfect subtrees largest first.

**Check.** `c6_merkle_mergesort.py`: the recursion of the RFC (split at the largest power of two smaller than n) for n = 1..3000: d = ones(n) - 1 and the maximal perfect subtrees are the binary digits of n; brute force over all shapes for n = 1..20 confirms that no tree has fewer asymmetric nodes. Passed. Side result: bottom-up merge sort produces the same shape (n = 1..3000), and top-down merge sort (halve with rounding) is minimal only for n = 2^k and n = 2^k - 1 in that range.

**Source.** RFC 6962, "Certificate Transparency", B. Laurie, A. Langley, E. Kasper, June 2013, Experimental; section 2.1 defines the split point k as "the largest power of two smaller than n" and says the input length need not be a power of two. The RFC page marks it as obsoleted by RFC 9162, "Certificate Transparency Version 2.0", B. Laurie, E. Messeri, R. Stradling, December 2021, Experimental, whose section 2.1.1 keeps the same definition. Opened: https://www.rfc-editor.org/rfc/rfc6962 and https://www.rfc-editor.org/rfc/rfc9162 (first 100000 characters).

**Picture.** The RFC tree for n = 7: a perfect tree on four leaves, a perfect tree on two, a single leaf, joined by two orange nodes; below it "7 = 111". Then an eighth entry arrives and the three pieces collapse, carry by carry, into one perfect tree.

**Honesty rating.** Exact: a standards document prescribes one of our minimal trees. It overlaps strongly with the binomial heap and the binary counter that the team already has (the growth of the log is the binary counter), so its value is a citable real-world document, not a new idea. Nothing in the security of the scheme depends on the number of asymmetric nodes; that part would be analogy.

---

## 7. Cell lineages: how many divisions must be asymmetric (p = 2)

**Field and object.** The cell lineage of an organism is the binary tree of all its cell divisions, from the fertilised egg to the final cells. Developmental biologists distinguish symmetric divisions (the two daughters behave alike) from asymmetric ones, and measure how repetitive a lineage is.

**Dictionary.**

| Ours | Development |
|---|---|
| binary tree with m leaves | lineage producing m terminal cells |
| node | a cell division |
| ordered tree | lineage with a named orientation of each division (for the nematode: anterior and posterior daughter) |
| rotation | forgetting which daughter is which |
| symmetric node | a division whose two daughters produce equivalent sub-lineages ("shape-symmetric") |
| atom of height j | a clone made by j synchronous rounds of division, 2^j cells |
| d(T) | number of shape-asymmetric divisions = number of binary choices needed to orient the lineage |

**Exact statement.** (i) A lineage in which every division is shape-symmetric exists if and only if the number of terminal cells is a power of two, and then it is unique (Fact 7, Z_m(0)). (ii) A lineage with m terminal cells has at least ones(m) - 1 shape-asymmetric divisions, with equality exactly when it consists of synchronous clones of sizes given by the binary digits of m, joined by divisions between clones of different sizes (Facts 2 and 3). (iii) A lineage shape with d asymmetric divisions has exactly 2^d oriented versions, and these add up to the Catalan number (Fact 1).

Reading for a biologist: colonial green algae of the Volvox family have cell numbers that are powers of two (source below), which is case (i). The adult hermaphrodite of the nematode C. elegans has 959 somatic nuclei; 959 = 1110111111 in binary has nine ones, so any lineage with 959 terminal cells needs at least 8 shape-asymmetric divisions. The bound is weak for real animals (real lineages have far more asymmetric divisions); its interest is that it is sharp and that it is zero only for powers of two.

**Check.** `c7_lineages.py`: (i) and (ii) for m = 1..200 from the recursion of `classpoly.py`, and by brute force over all shapes for m = 1..20; (iii) for m = 1..12 by enumerating ordered trees. Explicit optimal lineages were built for m = 4, 8, ..., 128, 959 and 1031 (bounds 0, ..., 0, 8, 3) and their d computed. All passed. Not done: no real lineage was downloaded, so the actual number of asymmetric divisions of any organism was not computed. The script also prints bounds for m = 558, 671 and 1090; those three cell counts were typed from memory and are not confirmed by any source opened here; do not use them.

**Source.**
- Matthew D. Herron, "Origins of multicellular complexity: Volvox and the volvocine algae", Molecular Ecology, volume 25, issue 6, pages 1213-1223, published 2016-03, DOI 10.1111/mec.13551, PMCID PMC5765864. Opened: https://pmc.ncbi.nlm.nih.gov/articles/PMC5765864 and the Crossref record. The caption of its Table 1 says that cell numbers are restricted to powers of two, with Volvox as a possible exception. Not confirmed in this source: the mechanism (several rapid rounds of division, "multiple fission"); it appeared only in search-result summaries of other papers.
- BioNumbers, record 100581, "Number of somatic cell nuclei in an adult hermaphrodite", value 959, reference given there as "W. B. Wood. The Nematode Caenorhabditis elegans. (CSH) 1988 p.1 3rd paragraph", with the comment "The adult hermaphrodite has only 959 somatic nuclei." and the adult male at 1031. Opened: https://bionumbers.hms.harvard.edu/bionumber.aspx?id=100581.
- Ricardo B. R. Azevedo, Rolf Lohaus, Volker Braun, Markus Gumbel, Muralikrishna Umamaheshwar, Paul-Michael Agapow, Wouter Houthoofd, Ute Platzer, Gaëtan Borgonie, Hans-Peter Meinzer, Armand M. Leroi, "The simplicity of metazoan cell lineages", Nature, volume 433, issue 7022, pages 152-156, published 2005-01-13, DOI 10.1038/nature03178. Opened: Crossref record only, https://api.crossref.org/works/10.1038/nature03178. That the paper measures lineage complexity by the repeated sub-lineages was seen only in a search-engine summary; not confirmed from the article itself.

**Picture.** Left: a 16-cell algal colony and its lineage, a perfect binary tree, every division marked green. Right: a lineage with 13 cells drawn as clones of 8, 4 and 1 joined by two orange divisions, with "13 = 1101". Caption: "all divisions symmetric: only 1, 2, 4, 8, 16, ... cells are possible."

**Honesty rating.** Exact core + analogy. The tree statement is a theorem and the tree is literally the lineage. The analogy: biologists call a division asymmetric when the daughters' fates differ, which is finer than our shape criterion; and the same mathematics is already in the team's list under shapes of evolutionary trees, so this is a new field for a known idea.

---

## 8. Mobiles and necklaces: the name of the classes, and Fermat's little theorem for trees (all p)

**Field and object.** In enumerative combinatorics a "mobile" is a rooted tree in which the branches at each node are arranged in a circle, like the hanging sculptures of that name whose arms turn freely. A necklace is a circular arrangement of p coloured beads counted up to rotation.

**Dictionary.**

| Ours | Mobiles and necklaces |
|---|---|
| rotation class of a p-ary tree | a p-ary mobile: a hanging mobile in which every hub has p arms and turns freely about its string |
| ordered tree | a snapshot of the mobile from above, with a chosen first arm at every hub |
| a node up to rotation | a necklace of p beads; the colours are the classes of the subtrees |
| symmetric node | a necklace with all beads equal (fixed by rotation) |
| asymmetric node | a necklace with p different rotations |
| Z_m(1) | number of p-ary mobiles with N hubs |
| Z_m(p) = C | number of snapshots |

**Exact statement.**

1. The rotation classes of p-ary trees are exactly the p-ary mobiles of the OEIS; their numbers are column p of OEIS A398107 (for p = 2, 3, 5: A001190, A000625, A036727).
2. One node: the number of necklaces with p beads in k colours is (k^p - k)/p + k; counting the snapshots, k^p = k + p * (number of non-constant necklaces), which is the classical necklace proof of Fermat's little theorem k^p = k (mod p).
3. The whole tree: the series M(x; y) = sum over m of Z_m(y) x^m satisfies the nested-necklace equation

   `M(x; y) = x + M(x^p; y^p) + y * ( M(x; y)^p - M(x^p; y^p) ) / p`

   (leaf; symmetric root; asymmetric root). At y = p it collapses to B = x + B^p, the equation of the Fuss-Catalan numbers; at y = 1 it is the cycle-index equation of the cyclic group.
4. Tree version of Fermat's little theorem: the number of p-ary trees with m leaves is congruent to 1 modulo p if m is a power of p, and to 0 otherwise (Fact 7: Z_m(p) = Z_m(0) mod p). The theorem of the team is the refinement of this congruence to the exact power of p.

**Check.** `c8_mobiles_necklaces.py`. (1), (3): the equation, implemented in `classpoly.py`, reproduces the brute-force distribution of d over classes for p = 2 (N <= 11), p = 3 (N <= 7), p = 5 (N <= 5), and the class sizes are p^d; the numbers of classes printed for p = 2, 3, 5 agree with the first rows of the table shown in A398107 (for example p = 5: 1, 1, 1, 3, 9, 30, 107, 392, 1489). (2): brute force for p in {2, 3, 5, 7}, k = 1..5. (4): p in {2, 3, 5, 7, 11, 13}, N = 0..2000. In addition, from the equation alone, far beyond brute force: Z_m(0) = [m is a power of p], Z_m(p) = Fuss-Catalan, lowest power of y equal to t, and its coefficient congruent to (-1)^t / prod a_j! modulo p, for p = 2 (all m <= 120), p = 3 (m <= 161), p = 5 (m <= 201), p = 7 (m <= 241). All passed.

**Source.**
- OEIS A398107, name "Array read by antidiagonals: T(n,k) is the number of k-ary mobiles (circular rooted trees) with n internal nodes, n >= 0, k >= 0.", author Andrew Howroyd, Jul 20 2026; cross-references there list column 2 as A001190, column 3 as A000625, column 5 as A036727, column 7 as A036728. Opened: https://oeis.org/search?q=id:A398107&fmt=json. The companion table A398108 (dihedral group, "dyslexic" mobiles) carries the comment "A mobile is a circular rooted tree."
- OEIS A032200, name "Number of rooted compound windmills (mobiles) of n nodes.", with the reference, as given there, "F. Bergeron, G. Labelle and P. Leroux, Combinatorial Species and Tree-Like Structures, Camb. 1998, p. 241 (3.3.84)." Opened: https://oeis.org/search?q=id:A032200&fmt=json. The book itself was not opened.
- S. W. Golomb, "Combinatorial Proof of Fermat's "Little" Theorem", The American Mathematical Monthly, volume 63, issue 10, page 718, 1956, DOI 10.2307/2309563. Opened: Crossref search record only; the article text was not opened.

**Picture.** A hanging mobile with three-armed hubs, seen from the side, and three views from above after turning one hub by 120 degrees and by 240 degrees: "three drawings, one mobile". A hub whose three arms carry identical sub-mobiles is shown in a different colour: "turning this one changes nothing". Caption: "a mobile with d ordinary hubs has 3^d drawings; the theorem finds the mobiles with the fewest."

**Honesty rating.** Exact, but it is a renaming rather than a new field: it gives the team the established name of its classes, an OEIS table to cite, a physical object that realises the cyclic group for every p (a hub can turn but cannot be mirrored), and a one-line motivation ("Fermat's little theorem for trees"). The team probably knows part of this through A000625.

---

## (a) The three for a 20-minute talk

1. **Double-and-add told with two pictures (connections 5 and 2).** It needs no preparation: everyone can follow 41 * 59 by doubling, and "41 has three ones, so two additions" is the theorem's lower bound in its most elementary form. The laser version makes it physical and has a real contrast to show: the literature contains both the minimal recipe for the fifth harmonic (4 + 1) and a non-minimal one (3 + 2). It serves the criterion "motivation". Keep the caveat about reuse (m = 15) ready for questions.
2. **Quadtrees (connection 1).** It is the only picture found for the q = p^k part of the problem, it is exact, and its key sentence is short and surprising: the symmetries of a square form a Sylow 2-subgroup of S_4. The slide with 22 = 2 + 4 + 16 shows class sizes, the smallest class and the valuation at once. It serves "interest" and "clarity".
3. **Feynman diagrams (connection 3).** For judges with a physics background it turns the theorem into a statement they know how to read: the largest symmetry factor at order m is the 2-part of m!, and it sets the 2-adic size of the amplitude. It also prepares the most likely hard question ("is this not a two-line consequence of Legendre's formula?") with a precise answer. It serves "correctness" under questioning.

The mobile of connection 8 costs one picture and no time; it is the best way to define the equivalence on the first slide.

## (b) Considered and rejected

- Moments of products of random matrices are Fuss-Catalan numbers: a true identity as far as remembered (source not checked), but the valuation of a moment has no physical meaning. Numerology.
- Dissections of a polygon (the original setting of Fuss, and the OEIS name of A002293): rotating the children of a node is not a rotation of the polygon. A re-skin without content.
- Linguistics, "Merge": syntactic objects are unordered binary trees, but the words are all different, so every node is asymmetric and the class size is always 2^(m-1). Nothing to check.
- Leaf orderings of a clustering dendrogram: the same triviality, 2^(n-1) orderings.
- Huffman codes for equally likely symbols: optimal trees are not unique and in general not minimal (m = 5 forces d = 2 against t = 1). No statement.
- Top-down merge sort: its tree is minimal only for n = 2^k and 2^k - 1 (checked to 3000). Bottom-up merge sort is minimal but is the binary counter again.
- The game 2048 and merge-three games: they literally perform carries (checked: the number of merges is (m - s_p(m))/(p-1) in any order, and the 2048 score depends only on the final tiles), but this is chip-firing on a line, which the team has. Usable as an audience hook only.
- Octrees: the counting theorem holds (checked), but the local group (order 128) is not the symmetry group of the cube (2-part 16). No rigid-motion picture.
- Splitting a triangle into four by midpoints: the triangle's symmetries fix the middle piece; not a p-group acting on the children.
- Protein complexes ("dimer of dimers", rings with rotational symmetry): rigid point groups are not iterated wreath products. Analogy only.
- Non-rigid molecular symmetry groups of alkyl groups (methyl rotors turning independently): true and literal, but it is the team's existing symmetry number 3^sigma in other words.
- Antenna feed networks and optical power splitters built from two-way splitters: the same statement as connection 2 ("at least ones(m) - 1 unequal splits") with less physics behind it.
- Population-count circuits, Wallace trees, ripple counters: the carry budget again.
- Glycogen (a doubly branching polymer): only the complete tree occurs; same as the dendrimer.
- Nuclear fusion chains in stars: particles are emitted along the way, so the histories are not our trees.
- Polymer synthesis by repeated doubling of chain length: literally atoms, but batches are reused, so the right model is an addition chain (see the caveat in connection 5). Source not checked.
- Exponentiation in a field of characteristic p where the p-th power is free (Frobenius): a tempting reading of symmetric p-ary nodes, but p-ary trees only reach exponents m = 1 mod (p-1), and practical algorithms reuse results. Analogy only.
- Third-order harmonic generation as ternary trees: only odd harmonics, as for ternary trees, but the three photons are unordered (S_3, not C_3). Analogy only.

## Open lead for a human (not confirmed)

The subagent remembers, without being able to confirm it, that I. M. H. Etherington defined for a commutative "shape" (a binary tree up to exchanging factors) a number called its **mutability**, such that the shape corresponds to 2^mutability non-commutative shapes. If that is right, it is d(T) for p = 2 and Fact 1 for p = 2 was known around 1940; it would be both prior art to credit and a link to Etherington's genetic algebras, where the complete tree is a "plenary power" (generations of random mating). The pages that could be opened show only that the paper defines commutative and non-commutative shapes; the word "mutability" does not appear in any visible extract, and neither do "plenary" or a power of 2. The paper is behind a paywall:

- I. M. H. Etherington, "XV.—On Non-Associative Combinations", Proceedings of the Royal Society of Edinburgh, volume 59, pages 153-162, DOI 10.1017/s0370164600012244; Crossref gives the print year as 1940 (the paper is often cited as 1939; not confirmed). Opened: https://www.cambridge.org/core/journals/proceedings-of-the-royal-society-of-edinburgh/article/xvon-nonassociative-combinations/2CF8FA12CF11199431AD632835299EB4 and https://api.crossref.org/works/10.1017/S0370164600012244.
- I. M. H. Etherington, "Enumeration of Indices of Given Altitude and Degree", Proceedings of the Edinburgh Mathematical Society, volume 12, issue 1, pages 1-5, 1960, DOI 10.1017/S0013091500024986. Its visible extract says the earlier paper defined the degree and the altitude of a power and that commutativity means ignoring left and right in the tree.

Someone with library access should read the first of these before the talk.

## What was not verified

- Article texts not opened (bibliographic records only): Samet 1984, Andrade et al. 2005, Higham 1993, Azevedo et al. 2005, Golomb 1956, the Bergeron-Labelle-Leroux book. Their relevance is stated from titles, OEIS comments or abstracts as noted in each entry.
- The floating-point check is a sample (205 values of x, m <= 12), not a proof; the statement itself has the two-line proof given in connection 5.
- No experimental data from any field were used: no real lineage, no measured laser efficiencies, no real log.
- For q = p^k the class statements (not only the valuation) were checked for (p, k) = (2, 2) to N = 60, (2, 3) to N = 25 and (3, 2) to N = 20, and by brute force only for quadtrees to N = 6.
- Whether any of the eight connections is already in the repository under another name could not be checked, because the subagent did not read the repository. The folder names `E011_crossfield_checks` and `E012_connections` were seen in a directory listing; their contents were not opened.

# Cross-field references: what was verified

By Claude Fable 5.2 (orchestrator), 2026-11-13 ~23:55 PT. Every citation below was returned by the OpenAlex or Semantic Scholar API on that date (script `experiments/E006_oeis/lookup.py`, raw output `experiments/E006_oeis/lookup_output.txt`). **Only titles and abstracts were read.** Statements about what a paper contains beyond its abstract are marked as unverified. Not human-reviewed.

## Verified to exist, with the link to our work

1. **Sophie Johanna Kersting, Mareike Fischer, "Measuring tree balance using symmetry nodes — A new balance index and its extremal properties", Mathematical Biosciences (2021), DOI 10.1016/j.mbs.2021.108690; arXiv 2105.00719.**
   Abstract (in summary): introduces the "symmetry nodes index" for measuring the balance of phylogenetic trees, analyses its extremal properties, shows it is computable in linear time, and relates it to the cherry index and Rogers' J index.
   *Link:* a symmetry node of a binary tree is a node whose two subtrees have the same shape. Our d(T) for p = 2 counts the nodes that are **not** symmetry nodes. So our lower bound "d(T) ≥ s_2(m) − 1" and our description of the trees attaining it are statements about the extremal values of this index.
   **Checked in the full text** (read as a web page at ar5iv.labs.arxiv.org/html/2105.00719 on 2026-11-13; nothing downloaded; paraphrased, not quoted):
   - Their index is SNI(T) = (n - 1) - (number of symmetry nodes), for a rooted binary tree with n leaves. This is exactly our d(T) for p = 2.
   - **Theorem 3.5:** the minimum of SNI over trees with n leaves is wt(n) - 1 (wt = number of ones in binary), attained exactly by the "rooted binary weight trees": take any rooted binary tree with wt(n) leaves (the "top tree") and replace its leaves by the fully balanced trees of the heights given by the binary digits of n (Definition 3.4). This is our skeleton with atoms.
   - **Theorem 3.9:** the number of minimal trees is (2 wt(n) - 3)!!, by regarding the top tree as a leaf-labelled (phylogenetic) tree.
   - The words Catalan, Deutsch and Sagan do not occur in the text: the authors did not connect this to the 2-adic valuation of Catalan numbers.
   *Consequence:* for p = 2 our Steps 2 and 3 and the count of minimal classes are in the literature twice, independently: Deutsch-Sagan (2006, number theory) and Kersting-Fischer (2021, phylogenetics). **This must be cited.** What we add is every prime p, prime powers q = p^k with the depth condition, and the carry-cherry count that replaces the formula (2s-3)!!. In their language our theorem for p = 2 reads: the power of 2 in the Catalan number C_(n-1) is the least possible value of the symmetry nodes index of a tree with n leaves.

2. **Persi W. Diaconis, Susan Holmes, "Matchings and phylogenetic trees", Proceedings of the National Academy of Sciences (1998), DOI 10.1073/pnas.95.25.14600.**
   Abstract: gives a correspondence between phylogenetic trees and perfect matchings in the complete graph.
   *Link:* for p = 2 our minimal classes are rooted binary trees on s labelled leaves, counted by (2s−3)!!, the number of perfect matchings on 2(s−1) points. Our Idea 5 (labelled cyclic p-ary trees ↔ permutations made of p-cycles) would be the p-ary analogue.

3. **Georg Pólya, "Kombinatorische Anzahlbestimmungen für Gruppen, Graphen und chemische Verbindungen", Acta Mathematica (1937), DOI 10.1007/bf02546665.**
   Abstract (German, in summary): continues Cayley's counting of trees, some of which count isomers of chemical compounds.
   *Link:* the source of counting trees up to a group acting on the children of each node. The OEIS entry A000625 (see `notes/oeis_recon.md`) identifies our classes for p = 3 with stereoisomeric alkyl radicals. *Unverified:* which formulas appear in the paper itself.

4. **Deepak Dhar, "Self-organized critical state of sandpile automaton models", Physical Review Letters (1990), DOI 10.1103/physrevlett.64.1613.**
   Abstract: studies Bak–Tang–Wiesenfeld-type sandpile automata, characterises the critical state.
   *Link:* background for the "abelian sandpile" language of Idea 2 (sand on a ring versus a line). *Unverified:* that this is the paper establishing the abelian property; that is our recollection, not something the abstract says.

5. **Léo Kaloujnine, "La structure des p-groupes de Sylow des groupes symétriques finis", Annales Scientifiques de l'École Normale Supérieure (1948), DOI 10.24033/asens.961.**
   Abstract (French, in summary): studies the Sylow p-subgroups of symmetric groups of degree p^m.
   *Link:* our rotation group on one q-ary node is such a group (an iterated wreath product of cyclic groups of order p).

## Related, found in passing

- Miklós Abért, Bálint Virág, "Dimension and randomness in groups acting on rooted trees", Journal of the American Mathematical Society (2004), DOI 10.1090/s0894-0347-04-00467-9. Abstract: structure of the "p-adic automorphism group" of the infinite rooted regular tree. This is the infinite version of our group.
- Eugenio Giannelli, Stacey Law, "Sylow branching trees for symmetric groups", Transactions of the American Mathematical Society (2025), DOI 10.1090/tran/9469. Abstract: associates labelled complete p-ary trees to characters of a Sylow p-subgroup of S_n. Different subject, same group and trees.
- Henk Bruin, Olga Lukina, "Rotated odometers and actions on rooted trees", Fundamenta Mathematicae (2023), DOI 10.4064/fm74-10-2022. Odometers ("adding machines") acting on rooted trees.

## Searched and not found

- A paper linking chip-firing or sandpiles to carries in base-p addition: the one query tried returned nothing relevant. Not a conclusion about the literature.
- Wedderburn–Etherington numbers as phylogenetic tree shapes: the query returned papers on tree shapes and balance but none that we would cite for the identification; the OEIS entry A001190 is the reference for now.

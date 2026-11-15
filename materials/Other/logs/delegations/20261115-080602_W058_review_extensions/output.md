**W058 review — four short proofs — worker report — no files edited**

### 1. Closed families (C11) — report lines 1543–1550

**Claim restated:** Let $p$ be prime, $m\ge1$ with $m\equiv1\pmod{p-1}$, $t=(s_{p}(m)-1)/(p-1)$, and $F$ be any (possibly empty) set of $p$-ary trees with $m$ leaves that is closed under rotation $\sim$ of §3 (i.e. $T\in F, T'\sim T\Rightarrow T'\in F$). Then $p^{t}\mid|F|$ and $|F|\equiv p^{t}\cdot N_{\min}(F)\pmod{p^{t+1}}$ where $N_{\min}(F)$ is number of rotation classes in $F$ with $d=t$.

Quantifiers are complete in context; $p$ prime is inherited from §3; $t$ integer follows from $m\equiv1\pmod{p-1}$ via $s_{p}(m)\equiv m\pmod{p-1}$ (used without comment but standard).

**Step check:**

* 1548: “$F$ is a union of rotation classes.” — **follows**. Partition into $\sim$-classes + closure = union.
* 1548–1549: class has $p^{d}$ members (Lemma \ref{main:lem:class-size}, line 1003) and $d\ge t$ (Prop \ref{main:prop:lower-bound}, line 1048). **Correctly quoted**: Lemma class-size holds for every $p$-ary tree unconditionally; Prop lower-bound holds for every $p$-ary tree ($d(T)\ge t(\ell(T))$, $t(\ell(T))=(s_{p}(\ell(T))-1)/(p-1)$). Applied with $\ell(T)=m$, hypotheses match ($m$ is leaf count).
* 1549–1550: “classes with $d>t$ contribute multiples of $p^{t+1}$ … each class with $d=t$ contributes $p^{t}$.” — **follows**: $d>t\Rightarrow d\ge t+1$ (integer), so $p^{d}\equiv0\pmod{p^{t+1}}$.

No missing internal step.

**Uses of earlier results:** same hypotheses, same conclusions. Lemma \ref{main:lem:depth-invariant} not needed here; not misquoted.

**Small cases:**

* $p=2,m=4$ ($s=1,t=0$): complete tree $K_{2}$ alone $d=0$, other 4-leaf trees form one class size $4$ ($d=2$). Take $F=$ all trees with 4 leaves: $|F|=5$, $N_{\min}=1$, $1\mid5$, $5\equiv1\pmod2$ correct. Take $F=$ class of size $4$ only: $4\equiv0\pmod2$, $N_{\min}=0$, statement $2^{0}\mid4$, $4\equiv0\pmod2$ correct.
* $p=3,m=9$ ($100_{3},s=1,t=0$): complete ternary tree alone $d=0$ class size $1$; $F=$ all trees with $9$ leaves has $55$ elements, classes $1,9,9,9,27$ (line 581–582). $55\equiv1\pmod3$, $N_{\min}=1$ correct. Empty $F$: $0$ divisible, $0\equiv0$ correct.

**Edge cases:** $n=0/m=1$ (single leaf): $s=1,t=0,p^{0}=1\mid|F|$, holds. $t=0$ ($m$ a power of $p$): $p^{t}=1$, congruence is $|F|\equiv N_{\min}\pmod p$; proof gives $d>0\Rightarrow p\mid p^{d}$ hence same. Empty family: $0$ divisible by any $p^{t}$ in integers, congruence $0\equiv0$ holds. $p=2,k=1$ not special here.

**Verdict: correct as written.** No counterexample, no missing hypothesis, all cited lemmas applied in their generality.

---

### 2. Level profiles (C10) — report lines 1566–1583

**Claim restated:** Let $q=p^{k}$ ($p$ prime, $k\ge1$), $n_{0}=1,n_{1},\dots,n_{L-1}\ge0$, $n_{L}=0$, $n=\sum_{i<L}n_{i}$, $t=(s_{p}((q-1)n+1)-1)/(p-1)$, $m=(q-1)n+1$. Then $p^{t}\mid\prod_{i<L}\binom{qn_{i}}{n_{i+1}}$.

**Step check:**

* 1571–1573: “The product is the number of $q$-ary trees that have exactly $n_{i}$ internal nodes at depth $i$ for every $i\le L$ … if some $n_{i}=0<n_{i+1}$ there is no such tree and the product is $0$.” — **follows with a minor extra argument** (finding 1 below). Construction level-by-level: $n_{i}$ nodes at depth $i$ have $qn_{i}$ child positions at depth $i+1$, choose $n_{i+1}$ to be internal — $\binom{qn_{i}}{n_{i+1}}$ possibilities, independent across levels. Product counts exactly those trees. Line 1573 parentheses needs convention $\binom{0}{b}=0$ for $b>0$ (standard combinatorial extension); otherwise “product is $0$” is not literally $\binom{0}{b}$ under e.g. factorial definition.
* 1574–1576: blocked translation: $q$-ary tree profile $\mapsto$ $k$-blocked $p$-ary trees with exactly $n_{i}$ internal nodes at depth $ik$ for $i\le L$ (Lemma \ref{main:lem:blocked}, line 928). **Follows** — bijection of Lemma 928. The $p$-ary tree has extra forced internal nodes at depths $ik+r$ ($1\le r<k$) inside each $K_{k}$ block ($p^{r}$ per block), so condition “exactly $n_{i}$ at depth $ik$” is correct characterisation of the image; saying “these are all the internal nodes … at depth $ik$” (line 1576) is true for that residue class, not for all depths (finding 2, expository only).
* 1578–1582: “Rotation-equivalent trees have the same multiset of depths of internal nodes. … satisfies (R1) and (R2), because depths … are $0$ … so it contains $\sim$.” — **follows**. Define $E(T,T')$ as equality of multisets of internal-node depths. $E$ is equivalence relation; (R1): rotating $p$ subtrees permutes their depth multisets, root contributes $0$, union unchanged; (R2): if $E(T_{i},T_{i}')$ each $i$, then $E((T_{i}),(T_{i}'))$ because assembled multiset is $\{0\}\cup\bigcup_{i}(\text{multiset}(T_{i})+1)$. Hence smallest relation $\sim$ satisfying (R1)(R2) is contained in $E$. So $T\sim T'\Rightarrow E$.
* 1582: “Together with Lemma \ref{main:lem:depth-invariant} this shows $F$ is closed” — **correctly quoted**. Lemma 967 preserves leaf-depth multiset hence $k$-blockedness and leaf count $m$; internal-depth preservation gives $n_{i}$ counts preserved. So $F$ closed under rotation.
* 1582–1583: proposition of item 1 applies with $m=(q-1)n+1$. Requires $m\equiv1\pmod{p-1}$ — holds because $q=p^{k}\equiv1\pmod{p-1}$. So $t$ as defined matches Prop C11, lower bound applies.

**Uses of earlier results:** Class-size lemma and lower-bound proposition applied in full generality; Lemma blocked and Lemma depth-invariant quoted with correct hypotheses (no extra $k$-blocked hypothesis needed for preservation).

**Small cases (checked by hand):**

* $q=2,p=2,k=1$: profile $n_{0}=1,n_{1}=2,n_{2}=0$, $n=3,m=4,t=0$, product $\binom21\cdot\binom40=1$ divides $1$ trivially. Profile $1,1,1,0$: $n=3,m=4,t=0$, product $2\cdot2\cdot1=4$, $1\mid4$; $F$ consists of $4$ trees (Catalan $5$ split $1+4$) as enumerated in analysis.
* $q=4,p=2,k=2$: $n_{0}=1,n_{1}=1,n_{2}=0$, $n=2,m=7=111_{2},s=3,t=2$, product $\binom41\cdot\binom40=4$, $2^{2}=4\mid4$ correct. Invalid profile $n_{0}=1,n_{1}=0,n_{2}=1$: product $\binom40\cdot\binom01=0$, $F=\emptyset$, $4\mid0$ correct. Hand-count matches level construction.
* $p=3,q=3,k=1$: $n_{0}=1,n_{1}=1,n_{2}=0$, $n=2,m=5=12_{3},s=3,t=1$, product $\binom31\cdot\binom30=3$, $3\mid3$ correct.

No counterexample found.

**Edge cases:** $L=1$ (only $n_{0}=1$): $n=1,m=q$, product $\binom{q}{0}=1$, $t=(s_{p}(q)-1)/(p-1)=0$ ($q=p^{k}$ is $100\dots_{p}$), $1\mid1$. $n_{i}=0$ for large $i$ forced to $0$ by $n_{L}=0$ and monotonicity of product? If profile not realizable (gap $0$ before positive), product zero and $F=\emptyset$, divisibility holds ($p^{t}\mid0$). $t=0$ always trivial divisor.

**Findings ordered by importance:**

1. Line 1573–1574: “if some $n_{i}=0<n_{i+1}$ there is no such tree and the product is $0$” — uses combinatorial extension $\binom{0}{b}=0$ for $b>0$. Under factorial definition $\binom{n}{k}=n!/(k!(n-k)!)$ this is undefined. Needs one sentence fixing convention or noting $\binom{qn_{i}}{n_{i+1}}=0$ as integer counting function in that case. **Gap, not a falsity.**
2. Line 1575–1577: wording “these are all the internal nodes of the $p$-ary tree at depth $ik$” could be read as “all internal nodes are at multiples of $k$” which is false; $K_{k}$ blocks contribute forced internal nodes at $ik+r$, $1\le r<k$ (e.g. $q=4,p=2,k=2$ block has 2 internal nodes at depth $ik+1$). Intended meaning is correct (for that residue class the count is exactly $n_{i}$). **Expository gap.**

**Verdict: correct, with gaps.** Statement true, proof valid modulo the two clarifications above; no step fails.

---

### 3. Weights that rotations do not change (C28) — report lines 1595–1613

**Claim restated:** Let $p$ prime, $m\equiv1\pmod{p-1}$, $t=(s_{p}(m)-1)/(p-1)$, $F$ set of $p$-ary trees with $m$ leaves closed under rotation, and $w$ integer-valued with $w(S)=w(T)$ when $S\sim T$. Then $p^{t}\mid\sum_{T\in F}w(T)$. In particular for $q=p^{k}$, arbitrary integers $b_{0},b_{1},\dots$, $p^{t}\mid\sum_{T}\prod_{v}b_{\operatorname{depth}(v)}$ where sum over $q$-ary trees with $n$ internal nodes ($m=(q-1)n+1$), product over internal nodes $v$ at depth $\operatorname{depth}(v)$ in the $q$-ary tree.

**Step check:**

* 1604–1606: $F=\bigsqcup$ classes, sum over class of size $p^{d}$ is $p^{d}w(\text{class})$, $d\ge t$ (Lemmas class-size + lower-bound). **Follows** for integer $w$; divisibility same as item 1.
* 1606–1608: $w(U)=\prod_{i}b_{i}^{\,n_{i}(U)}$, $n_{i}(U)$ = number of internal nodes of $U$ at depth $ik$. Claim rotations do not change $n_{i}(U)$ (proof of previous corollary). **Follows**: internal-depth multiset preservation (see item 2) implies counts per depth, in particular depths $\equiv0\pmod k$, are invariant. So $w$ constant on $\sim$-classes — correctly reduced to previous item.
* 1609–1611: $F_{\text{all}}=$ all $k$-blocked trees with $m$ leaves closed under rotation (Lemma depth-invariant) and in bijection with $q$-ary trees with $n$ nodes (Lemma blocked). **Correctly quoted**.
* 1612–1613: identification $w(U)=\prod_{v}b_{\operatorname{depth}(v)}$ for corresponding $q$-ary tree: $q$-ary internal node at depth $i$ corresponds bijectively to block-root internal node at depth $ik$ in $U$; extra intra-block internal nodes at depths $ik+r$ ($1\le r<k$) are not counted in $n_{i}(U)$ and do not appear in weight — **follows** but proof omits explicit mention of that distinction (finding below).

**Uses of earlier results:** Same lemmas as item 2, applied correctly; blocked lemma hypotheses satisfied ($q=p^{k}$).

**Small cases:**

* $p=2,q=2,n=2$: $m=3,s=2,t=1$, $q$-ary trees $2$ with product $b_{0}b_{1}$ each, sum $2b_{0}b_{1}$, $2\mid$ sum for any integers — e.g. $b_{0}=1,b_{1}=3$ sum $6$.
* $p=2,q=4,n=2$: $m=7,s=3,t=2$, trees $4$ each with depths $0$ and $1$: weight $b_{0}b_{1}$ each, sum $4b_{0}b_{1}$, $4\mid$ sum. With $b_{0}=2,b_{1}=5$ sum $40$, divisible by $4$.
* Random integer weight test: $p=2,m=3,t=1$, define $w=$ number of leaves in leftmost subtree mod something? Constant on class by construction, sum example earlier holds. No counterexample.

**Edge cases:** $b_{i}=0$ allowed (arbitrary integers) — weight may be zero for some trees (tree with node at depth $i$ where $b_{i}=0$), sum still integer divisible — holds because each class contribution $p^{d}w$ remains multiple of $p^{t}$ even if $w=0$. Empty $F$ gives sum $0$ divisible. $w$ zero function trivial. Single-leaf tree $m=1,t=0$ has empty product (defined as $1$) per convention internal nodes none — sum $1$, $p^{0}\mid1$. Need convention product over empty set $=1$, standard.

**Findings:**

1. Same findings 1–2 from item 2 propagate, since invariance of $n_{i}$ relies on same argument.
2. Line 1607–1608: definition $n_{i}(U)$ as “number of internal nodes of $U$ at depth $ik$” counts only block-roots, not all internal nodes of the $k$-blocked tree. Without one sentence noting that $k$-blocked trees have forced extra internal nodes at $ik+r$, $1\le r<k$ that are *not* counted, reader may think $n_{i}(U)$ is total internal count. **Expository gap, not logical error; identification with $q$-ary weight remains correct.**

**Verdict: correct, with gaps** (inherited gaps plus clarification of $n_{i}$ vs. total internal nodes). Statement true, no counterexample.

---

### 4. Converse direction of the “if and only if” (lines 615–622)

**Claim restated:** In context $p$ prime, $k\ge1$, $q=p^{k}$, vector $\mathbf a=(a_{0},\dots,a_{k-1})\in\mathbb Z_{\ge0}^{k}$, $T(\mathbf a)$ = number of $\sim$-classes of cyclic $p$-ary trees with distinctly labelled leaves, $a_{c}$ labels of class $c$ at depth $\equiv-c\pmod k$. If $T(\mathbf a)\neq0$ (i.e. a tree counted by $T(\mathbf a)$ exists) then $\mathbf a\neq0$ and $\sum_{c}a_{c}p^{c}\equiv1\pmod{q-1}$. Full “iff” in text is: $T(\mathbf a)\neq0\iff\mathbf a\neq0\wedge\sum a_{c}p^{c}\equiv1$ (sufficiency is Lemma \ref{acc:L0}/Prop \ref{main:prop:carry-termination} for digit vectors; not part of this proof).

Quantifiers in isolated sentence are implicit from preceding paragraph (1551–1556 context); standalone it lacks explicit “let $p$ prime, $q=p^{k}$” — **minor quantification gap** (finding 1).

**Step check with line numbers:**

* 616–617: “In a $p$-ary tree the depths $\ell$ of the leaves satisfy $\sum p^{-\ell}=1$: holds for single leaf, replacing leaf at depth $\ell$ by node with $p$ leaves at depth $\ell+1$ does not change sum.” — **follows**. Kraft equality for $p$-ary trees. Base $\bullet$ depth $0$ sum $1$. Replacement $-p^{-\ell}+p\cdot p^{-(\ell+1)}=0$.
* 618: “Let $D$ be multiple of $k$ at least depth of every leaf; then $\sum p^{D-\ell}=p^{D}$.” — **follows**: multiply previous equality by $p^{D}$, each term integer because $D\ge\ell$. Existence of $D$: max leaf depth finite, take $D=k\lceil\max\ell/k\rceil$.
* 619: “Since $p^{k}=q\equiv1\pmod{q-1}$, we have $p^{D}\equiv1$” — **follows** (if $q=2$, $q-1=1$, congruence is $0\equiv0$, still $p^{D}\equiv1\equiv0\pmod1$ vacuously true; statement remains valid as divisibility by $1$).
* 619–621: “$p^{D-\ell}\equiv p^{c}\pmod{q-1}$ for leaf of depth class $c$, because $D-\ell\ge0$ and $D-\ell\equiv c\pmod k$.” — **follows** given definition $c\equiv-\ell\pmod k$ (i.e. leaf depth $\ell\equiv-c\pmod k$ for class $c$). Then $D\equiv0\pmod k\Rightarrow D-\ell\equiv c\pmod k$. Write $D-\ell=c+kt$, so $p^{D-\ell}=p^{c}(p^{k})^{t}=p^{c}q^{t}\equiv p^{c}\pmod{q-1}$ via $q\equiv1$.
* 621: “Hence $\sum_{c}a_{c}p^{c}\equiv1\pmod{q-1}$, and $\mathbf a\neq0$ because tree has leaf.” — **follows**: sum over leaves grouped by class gives $\sum_{c}a_{c}p^{c}$ residue, equal to $p^{D}\equiv1$.

**Uses of earlier results:** Uses no unproved tree lemmas beyond Kraft equality (proved inline) and modular property $p^{k}\equiv1\pmod{q-1}$ (elementary). No misquote of §3.

**Small cases:**

* $p=2,k=2,q=4$: tree single leaf depth $0$ ($c=0$) gives $\mathbf a=(1,0)$, sum $1\equiv1\pmod3$ ok. Tree root with 2 leaves depth $1$ ($c=1$ each) gives $\mathbf a=(0,2)$, sum $4\equiv1\pmod3$ ok. Tree root with left leaf depth $1$ and right internal with 2 leaves depth $2$ gives depths $1,2,2\Rightarrow\mathbf a=(2,1)$, sum $2\cdot1+1\cdot2=4\equiv1\pmod3$ ok. Invalid $\mathbf a=(2,0)$ sum $2\not\equiv1\pmod3$, no tree with 2 leaves (Kraft sum $2\cdot1=2\neq1$, or $2\cdot2^{-?}$) — indeed no binary tree has 2 leaves? Actually binary tree leaf counts are any $n\ge1$, but depth-class restriction with $k=2$ forbids $(2,0)$: two leaves both depth $0$ impossible, both depth $2$ with class $0$ would be $2$ leaves depth $2$ each $2^{-2}=1/4$ sum $1/2\neq1$.
* $p=3,k=1,q=3$: single leaf $\mathbf a=(1)$ sum $1\equiv1\pmod2$; 3 leaves depth $1$ $\mathbf a=(3)$ sum $3\equiv1\pmod2$; $\mathbf a=(2)$ sum $0\pmod2$ no tree (leaf count $2$ even not $1\pmod2$). Matches condition.
* $p=2,k=1,q=2$: any $\mathbf a=(a_{0})$ with $a_{0}\ge1$ gives sum $a_{0}\equiv1\pmod1$ vacuously true; tree exists for every $a_{0}\ge1$ (binary leaf counts arbitrary) — condition does not filter, correct for modulus $1$.

No counterexample to necessity; converse direction verified on all hand-enumerated trees above.

**Edge cases:** Empty tree not allowed ($\mathbf a=0$ corresponds to no leaves, excluded; proof notes $\mathbf a\neq0$ because tree has leaf). $p=2$ ($q=2$) modulus $1$ case handled; proof does not break (still $p^{D}\equiv1\pmod1$ holds as $0\equiv0$). $D$ multiple of $k$ exists even when $k=1$ (any $D\ge\max\ell$). Tree with single leaf depth $0$ has $\max\ell=0$, $D=0$ works.

**Findings:**

1. Line 615–616 statement in isolation omits explicit quantifiers $p$ prime, $k\ge1$, $q=p^{k}$, $T(\mathbf a)$ definition. In this section ($548$–$627$) context is “small examples”, not “extensions”, and $T(\mathbf a)$ was defined at line 1154; standalone sentence needs reference. **Gap of presentation, not logic.**
2. No other gap: $D$ construction and $D-\ell\equiv c$ step could explicitly mention $\ell\equiv-c\pmod k$ definition of class, but proof does state “because $D-\ell\ge0$ and $D-\ell\equiv c\pmod k$” which implicitly uses it.

**Verdict: correct as written** (modulo the standalone-quantifier presentation note; mathematically no extra argument needed, no false step).

---

### What was not checked

* Did not re-verify the cited §3 lemmas (class size, lower bound, blocked bijection, depth invariance) beyond checking that the four proofs quote their hypotheses/conclusions literally; a full re-proof of §3 was not attempted.
* Did not build or run Lean (no `lake build`, no `lean` toolchain in this environment); the claim that the three extension corollaries are “checked by Lean” (line 1535–1536) was taken as provenance, not verified.
* Did not run computer checks beyond hand enumeration of $\le5$-leaf trees for $p=2,3$ and $q=4$; the exhaustive $1041$-vector computation mentioned at lines 624–626 (program not kept) and the $1067$ values in §Computations were not rerun.
* Did not compare with external literature (Konvalinka, Postnikov–Sagan, Etherington) — bibliographic accuracy not checked.
* For the level-profile product, the combinatorial identity “product equals number of trees with that profile” was checked on small $q=2,3,4$ examples only, not proved in full generality beyond the level-construction argument.


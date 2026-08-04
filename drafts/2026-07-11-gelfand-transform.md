---
layout: maths
title: The Gelfand Representation for C*-Algebras
category: Maths
---

The Gelfand Representation is an important topic in functional analysis. 
This text collects and orders important properties, with a focus on the basics of functional
calculus for C*-algebras. Much of this discussion also applies to Banach algebras. 

## The Character Space

Let $$A$$ be a C*-algebra, and consider the set of characters 

$$ \Omega(A) = \{ \chi : A \to \mathbb{C} \; | \;\chi\; \text{is a non-zero homomorphism} \}. $$

This is called the *character space*, or spectrum, of $$A$$ (sometimes written $$\text{Spec}\: A$$). Given an element $$a \in A$$, we define the Gelfand transform of $$a$$ as the evaluation map

$$\hat{a} : \Omega(A) \to \mathbb{C}, \;\;\; \chi \longmapsto \chi(a). $$

We endow the character space $$\Omega(A)$$ with the weakest topology that ensures each element $$\hat{a}$$ is continous. 
Take an open set $$U \subset \mathbb{C}$$, the preimage is then 

$$\hat{a}^{-1}(U) = \{ \chi \in \Omega(A) : \chi(a) \in U \}. $$

We take all such preimages (for all elements $$a \in A$$ and all open sets $$U$$ in $$\mathbb{C}$$) as a subbase for the topology. The topology we use is the smallest topology containing the subbase as open sets. This is exactly the weak* topology on $$\Omega(A)$$.

<div class="sidenote">
<h3> Aside: Weak vs Weak* Topology</h3>

Given an algebra \(A\), its character space \(\Omega(A)\) is a subset of the topological dual space \(A^*\) (all bounded linear maps from \(A\) to \(\mathbb{C}\)). 
The weak* topology on \(A^*\) is the smallest topology that keeps
\(\hat{a} : f \mapsto f(a)\) continous for every \(a \in A\). 
<br><br>

The weak topology is stronger. Each \(\hat{a}\) is an element of the double dual \(A^{**}\), that is, a bounded linear map from \(A^*\) to \(\mathbb{C}\). For the weak topology we require every single element of the double dual to be continous. A stronger requirements than for the weak* topology. 
This means a subbasis for the weak topology is given by sets of the form

$$ \Phi^{-1}(U) = \{ \chi \in \Omega(A) : \Phi(\chi) \in U \}. $$

Where \(\Phi\) is an element of \(A^{**}\) and \(U \subset \mathbb{C}\). 
</div>

## The Spectrum

Let $$A$$ be a **commutative** C*-algebra, 
then the character space is closely related to the spectrum of each element.

#### Unital Algebra

For $$a \in A$$, $$\chi \in \Omega(A)$$, let $$\lambda = \chi(a)$$.
Assume $$A$$ is unital, then

$$ \chi(a - \lambda 1) = \chi(a) - \lambda = 0$$

Now, if $$a - \lambda$$ is invertible, let $$b$$ be the inverse. 
Then 

$$1 = \chi((a - \lambda 1)b) = \chi(a - \lambda 1)\chi(b) = 0,$$

a contradiction, hence $$\lambda \in \sigma(a)$$.

For the other direction, let $$\lambda \in \sigma(a)$$ and consider the set $$I = (a - \lambda)A$$.
We have $$1 \not \in I$$, and for $$b \in A$$, $$bI = Ib = I$$ by commutivity of $$A$$. That is, $$I$$ is a two-sided proper ideal of $$A$$. 

Every proper ideal is contained in a proper maximal ideal $$M$$. Then the quotient $$A/M$$ is a simple commutative C*-algebra. That is, it is isomorphic to $$\mathbb{C}$$. 

Hence $$A\cong M \oplus \mathbb{C}$$. We can thus define a character $$\tau : A \to \mathbb{C}$$ by
$$\tau(m, \lambda) = \lambda$$ so that $$M = \text{ker}(\tau)$$. 
As $$a - \lambda \in M$$, $$\tau(a - \lambda) = 0$$, meaning $$\tau(a) = \lambda$$. 

Hence we have that for $$A$$ commutative and unital

$$ \sigma(a) = \{ \chi(a) \; : \; \chi \in \Omega(A)\}. $$

#### Non-Unital Algebra

When $$A$$ is non-unital, we define the spectrum of an element $$a \in A$$ by the spectrum in the
unitisation $$\tilde{A} = A \oplus \mathbb{C}$$ of $$A$$. Then the character space on $$\tilde{A}$$ is 

$$\Omega(\tilde{A}) = \{ \tilde{\chi} \; : \; \chi \in \Omega(A) \} \cup \{\tau\}. $$

Where $$\tilde{\chi}(a, \lambda) = \chi(a) + \lambda$$ and $$\tau(a, \lambda) = \lambda$$. Hence we have

$$ \sigma(a) = \{ \chi(a) \; : \; \chi \in \Omega(A)\} \cup \{0\} $$

### The Character Space is Locally Compact

Let $$A$$ be 
Given a character $$\chi \in \Omega(A)$$, it is an exercise to show that $$\lVert \chi \rVert \leq 1$$. Importantly, the character space $$\Omega(A)$$ is contained within the closed unit ball of $$A^*$$. By [Banach-Alaoglu](https://en.wikipedia.org/wiki/Banach%E2%80%93Alaoglu_theorem#Statement), 
the closed unit ball in the weak* topology is compact. 

## The Gelfand 

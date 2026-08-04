---
layout: maths
title: The Gelfand Representation for C*-Algebras
category: Maths
---

Let $$A$$ be a C*-algebra, and consider the set of characters 

$$ \Omega(A) = \{ \chi : A \to \mathbb{C} \; | \;\chi\; \text{is a non-zero homomorphism} \}. $$

This is called the *character space*, or spectrum, of $$A$$ (sometimes written $$\text{Spec}\: A$$). Given an element $$a \in A$$, we define the Gelfand transform of $$a$$ as the evaluation map

$$\hat{a} : \Omega(A) \to \mathbb{C}, \;\;\; \chi \longmapsto \chi(a). $$

We endow the character space $$\Omega(A)$$ with the weakest topology that ensures each element $$\hat{a}$$ is continous. 
Take an open set $$U \subset \mathbb{C}$$, the preimage is then 

$$\hat{a}^{-1}(U) = \{ \chi \in \Omega(A) : \chi(a) \in U \}. $$

We take all such preimages (for all elements $$a \in A$$ and all open sets $$U$$ in $$\mathbb{C}$$) as a subbase for the topology. The topology we use is the smallest topology containing the subbase as open sets. This is exactly the weak* topology on $$\Omega(A)$$.

<div class="sidenote">
<h3> Aside: Weak vs Weak*</h3>

Given an algebra \(A\), its character space \(\Omega(A)\) is a subset of the topological dual space \(A^*\) (all bounded linear maps from \(A\) to \(\mathbb{C}\)). 
The Weak* topology on \(A^*\) is the minimum that keeps  
\(\hat{a} : f \mapsto f(a)\) continous for every \(a \in A\). 
<br><br>

The weak topology is stronger. Each \(\hat{a}\) is an element of the double dual \(A^{**}\), that is, a bounded linear map from \(A^*\) to \(\mathbb{C}\). For the weak topology we require every single element of the double dual to be continous. A stronger requirements than for the weak* topology. 
This means a subbasis for the weak topology is given by sets of the form

$$ \Phi^{-1}(U) = \{ \chi \in \Omega(A) : \Phi(\chi) \in U \}. $$

Where \(\Phi\) is an element of \(A^{**}\) and \(U \subset \mathbb{C}\). 
</div>

## The Spectrum

The character space $$\Omega(A)$$ is closely related to the spectrum of each element in $$A$$. 

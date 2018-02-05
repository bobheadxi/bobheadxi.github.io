---
title: "Determining the Uniqueness of Sequences"
layout: post
date: 2018-02-07 22:00
image: http://biopython.org/assets/images/biopython_logo_s.png
headerImage: true
tag:
- python
- bioinformatics
star: false
category: blog
author: robert
description: using BLAST tools and FASTA
---

It's been raining a lot. When it stops raining and the sun comes out, it's pretty confusing, like that brief feeling you have when you wake up on your friend's couch after a long night.

<p align="center">
    <a href="http://bobheadxi.tumblr.com/post/169611079300/travelling-swallowing-dramamine-by-robert-lin">
        <img src="https://78.media.tumblr.com/9c8e304c71a554cd711ac88169b0084f/tumblr_p2fpa60BCg1rg86u5o1_1280.gif" width="50%" />
    </a>
</p>

<p align="center">
    <i>Don't really remember what it's like to be dry anymore.</i>
</p>

Thanks to the rain I have finally learned to enjoy running on treadmills. There's something really nice about reaching that place where the world melts away, and all you feel is your breathing, your steps, and the chorus of *Alexander Hamilton* from the [fantastic musical](https://www.youtube.com/watch?v=kHHlNON2cA8), at least until I feel too tired to keep going (which, after two years of laziness, doesn't take too long anymore).

# Prelude

First off, a note that all of the following is extremely simplified and is mostly based off what I've read over the past few weeks. But this definitely was a lot of fun to put together

Anyway, a quick introduction to the study of epigenetics:

> The plethora of cell types within an organism share a unifying genome. Despite this genetic unity, the various cell types, functions and phenotypes within an individual's cytome remain widely varied due to vast differences in their gene expression, both quantitatively and qualitatively. These variances are known to be dictated by so-called epigenetic mechanisms, such that individual cell types and developmental states, within an individual organism, have unique epigenomes. Thus, epigenetic mechanisms are crucially relevant in differentiation and development of all cell types, including those which do so in pathological contexts.<sup>[[1]](#r1)</sup>

In a nutshell, it is the study of the mechanisms that cause expression variances within an organism's cells. One such epigenetic mechanism is [DNA methylation](https://en.wikipedia.org/wiki/DNA_methylation), a process by which methyl groups are added to cytosine or adenine, with cytosine methylation being the most widespread (in mammalian DNA at least).<sup>[[2]](#r2)</sup>

<p align="center">
    <img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/DNA_methylation.png" width="80%" />
</p>

<p align="center">
    <i style="font-size:90%;">diagram by user Mariuswalter, distributed under a <a href="https://creativecommons.org/licenses/by-sa/4.0/deed.en">CC BY-SA 4.0</a> license</i>
</p>

One way in which DNA methylation effects expression is how it attracts and repels various DNA-binding proteins thanks to its position in the DNA helix at what are known as [CpG islands](https://en.wikipedia.org/wiki/CpG_site), which are often near transcription start sites.<sup>[[4]](#r4)</sup> It is understood that methylation at these sites is associated with gene silencing<sup>[[3]](#r3)</sup> by limiting transcription in the area.

<p align="center">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Cpg_islands.svg/1024px-Cpg_islands.svg.png" width="90%" />
</p>

<p align="center">
    <i style="font-size:90%;">diagram by Carl Fedrik, distributed under a <a href="https://creativecommons.org/licenses/by-sa/3.0/deed.en">CC BY-SA 3.0</a> license</i>
</p>

There are several methods available to analyze DNA methylation, one of which is known as [bisulfite conversion](https://en.wikipedia.org/wiki/Bisulfite_sequencing). Simply put, it converts unmethylated cytosines to uracils.<sup>[[1]](#r1)</sup>

My team often receives such bisulfite converted sequences, albeit with an additional step: samples are spiked with unmethylated [lambda phage](https://en.wikipedia.org/wiki/Lambda_phage), a procedure often done<sup>[[5]](#r5)</sup><sup>[[6]](#r6)</sup> to determine the efficiency of the conversion. Due to the lack of methylated cytosine residues in the lambda, if the conversion reaction is complete, all of the lambda sequence's cytosine should be converted to uracil when aligned to the lambda genome. This conversion rates is used to calculate the overall efficiency of the bisulfite conversion.

After conversion, the methylated cytosines remain and become unmethylated cytosines upon PCR amplification. Given a successful application of bisulfite modification, you can then assume that any remaining cytosines were originally methylated cytosines.<sup>[[1]](#r1)</sup> Another result of PCR amplification on bisulfite-converted DNA is that uracil is replaced with thymine.<sup>[[7]](#r7)</sup>

<p align="center">
    <img src="https://www.epigentek.com/catalog/images/headers/catdesc/dna-bisulfite-conversion.png" width="90%" />
</p>

<p align="center">
    <i style="font-size:90%;">diagram from <a href="https://www.epigentek.com/catalog/dna-bisulfite-conversion-c-75_21_47.html">Epigentek documentation</a></i>
</p>

# The Problem

The process of bisulfite conversion has an important consequence: to identify normal samples, we typically use the application of "spike-ins" - random, known sequences of around 180 base pairs that are grown in a lab, then added to samples during preparation for sequencing. During quality control, we check for the presence of these spike-ins in our pre-alignment pipelines. If the expected spike-in is only found in very small quantities, then that is usually a red flag that a sample swap might have occured.

These spike-ins do get affected by the bisulfite conversion, and in the event a perfect or near-perfect conversion, then the reduced complexity of the spike-in sequences (the result of replacing all cytosines with thymines) could potentially cause our pipeline to mistakenly identify spike-ins that aren't there. I was tasked with checking if our spike-ins sequences are sufficiently unique following bisulfite conversion, so that the team could decide if we can continue usine the spike-ins as identifiers in bisulfite converted libraries.

# Solution

```
Original:   AATGTCGATTCGA   ->  Reverse Complement: TCGAATCGACATT
                 |    |                              |    |  |
Converted:  AATGTTGATTTGA                Converted: TTGAATTGATATT
```

Note that the the original sequence's reverse complement, when bisulfite converted, is not the reverse complement of the original sequence's bisulfite conversion. This means that yet when using aligners like BLAST or BLAT, another sequence must be taken into account:

```
Converted:  AATGTTGATTTGA   ->  Reverse Complement: CAAATCAACATT
```

WORK IN PROGRESS

### References
<p style="font-size:90%;">
    <a name="r1">[1]</a> O’Sullivan, Eileen, and Michael Goggins. “<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3888804/">DNA Methylation Analysis in Human Cancer.</a>” Methods in molecular biology (Clifton, N.J.) 980 (2013): 131–156. PMC. Web. 4 Feb. 2018.
</p>

<p style="font-size:90%;">
    <a name="r2">[2]</a> Wu, Tao P. et al. “<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4977844/">DNA Methylation on N6-Adenine in Mammalian Embryonic Stem Cells.</a>” Nature 532.7599 (2016): 329–333. PMC. Web. 5 Feb. 2018.
</p>

<p style="font-size:90%;">
    <a name="r3">[3]</a> Li, En, and Yi Zhang. “<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3996472/">DNA Methylation in Mammals.</a>” Cold Spring Harbor Perspectives in Biology 6.5 (2014): a019133. PMC. Web. 5 Feb. 2018.
</p>

<p style="font-size:90%">
    <a name="r4">[4]</a> Watt, F, and P L Molloy. “<a href="https://www.ncbi.nlm.nih.gov/pubmed/3192075?dopt=Abstract">Cytosine methylation prevents binding to DNA of a HeLa cell transcription factor required for optimal expression of the adenovirus major late promoter.</a>” Genes & Development, vol. 2, no. 9, Jan. 1988
</p>

<p style="font-size:90%">
    <a name="r5">[5]</a> Ondov, Brian D. et al. “<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2905549/">An Alignment Algorithm for Bisulfite Sequencing Using the Applied Biosystems SOLiD System.</a>” Bioinformatics 26.15 (2010): 1901–1902. PMC. Web. 5 Feb. 2018.
</p>

<p style="font-size:90%">
    <a name="r6">[6]</a> Toh, Hidehiro et al. “<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5217569/">Software Updates in the Illumina HiSeq Platform Affect Whole-Genome Bisulfite Sequencing.</a>” BMC Genomics 18 (2017): 31. PMC. Web. 5 Feb. 2018.
</p>

<p style="font-size:90%">
    <a name="r7">[7]</a> Wang, R Y, C W Gehrke, and M Ehrlich. “<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC324387/">Comparison of Bisulfite Modification of 5-Methyldeoxycytidine and Deoxycytidine Residues.</a>” Nucleic Acids Research 8.20 (1980): 4777–4790. Print.
</p>

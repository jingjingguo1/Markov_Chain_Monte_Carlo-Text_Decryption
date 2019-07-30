# MCMC and Metropolis Hastings for Text-Decryption

This is code for a course project on Text Decryption solved using Markov Chain Monte Carlo (MCMC) and Metropolis Hastings sampler. See the compiled code here:
https://jingjingguo1.github.io/Markov_Chain_Monte_Carlo-Text_Decryption/view/MCMC-MH-Text-Decryption.html

### Problem Description:
Text file __message.txt__ gives a paragraph of English encoded by a permutation code,
where every symbol is mapped to a (usually) different one. The encryption key &delta; might thus be:\
a -> v\
b -> l\
c -> n\
d -> .\
...

Therefore a message like "_beware of dog._" might read as "_gavfgp wp. c_". For simplicity, assume there
are only 30 unique symbols, Symbol = ('a', 'b',. . . ,'z', ':', ';',' ' and ':'). Thus the encryption is a bijective
function &delta;: Symbol -> Symbol. We need to recover the original message (or equivalently find &delta;).

### Solution Overview:
* Model the English Language as a Markov Chain, where each character is followed by the next per the 30x30 transition matrix __T__. Where the T<sub>ij</sub> is the probability of letter i followed by letter j. T is estimated using a big book, e.g. War and Peace.
* Given X: encoded text message, then estimate Likelihood P(X|&delta;) = P<sub>Eng</sub>(&delta;<sup>-1</sup>|T), assume P(&delta;) is uniform, sample posterior P(&delta;|X).
* Use Metropolis Hastings algorithm to sample posterior distribution, since the Markov chain will wander towards more likely &delta; the text will be more and more like the English language.

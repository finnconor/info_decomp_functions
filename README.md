# info_decomp_functions


* Background

This small script evaluates the pointwise partial information decomposition for two sources as described in the following paper: 

Finn C, Lizier JT. 
Pointwise Partial Information Decomposition Using the Specificity and Ambiguity Lattices. 
Entropy. 2018; 20(4):297. 
https://doi.org/10.3390/e20040297 


* Useage

** redAsMinIComponent.m

To run it, you just define a joint probability table and pass it to the function.

    s1 	s2 	t 	p
    0 	0 	0 	1/4
    0 	1 	1 	1/4
    1 	0 	2 	1/4
    1 	1 	3 	1/4

So, for example, the above table is defined by

    p = [0 0 0 0.25; 0 1 1 0.25; 1 0 2 0.25; 1 1 3 0.25]

 and is passed as to matlab as

    >> redAsMinIComponent(p)

which should give you a table as a printed output

    s1 	s2 	t 	p 	  p(s1)  p(s2) 	p(t) 	p(s1|t) 	p(s2|t) 	p(S) 	p(S,t) 	i+(s1) 	i-(s1) 	i+(s2) 	i-(s2) 	r+ 	u+(s1) 	u+(s2) 	c+ 	r- 	u-(s1) 	u-(s2) 	c-
    0  	0 	0 	0.25 	0.5    0.5   	0.25 	1 	      1 	      0.25 	0.25   	1 	    0     	1     	0     	1 	0 	    0     	1 	0 	0     	0     	0
    0 	1 	1 	0.25 	0.5 	 0.5 	  0.25 	1 	      1 	      0.25 	0.25 	  1     	0 	    1 	    0 	    1 	0 	    0     	1 	0 	0 	    0     	0
    1 	0 	2 	0.25 	0.5    0.5 	  0.25 	1 	      1 	      0.25 	0.25 	  1 	    0 	    1 	    0 	    1 	0 	    0 	    1 	0 	0 	    0     	0
    1 	1 	3 	0.25 	0.5 	 0.5    0.25 	1 	      1 	      0.25 	0.25 	  1 	    0 	    1 	    0 	    1 	0 	    0 	    1 	0 	0 	    0     	0

A full explaination of the decomposition and this result is provided in the above paper. Further examples given in Sec. 5 of the paper.

** redAsMinIComponentTotal.m

This function is called in a similar manner, and will provide the same results as above, only it will also print a table of the recombine and averaged 
values, e.g. for the above decomposition, you would also get the following table.
    
    U1 	U2 	R 	C
    0 	0 	1 	1

The tables are related to each other as follows: the redundant information R, for example, is found by first recombining the positive and negegative 
components to evaluate the pointwise redundant informations, i.e. r = r+ - r- for each row, which yields a new column r. The redundant information R is 
then given by the average of this new column r weighted by the joint probabilities in comumn p(s,t). A full explaination of this recombination of 
positive and negative components, and the subsequent averaging is given in Sec. 4.1 of the paper linked above.

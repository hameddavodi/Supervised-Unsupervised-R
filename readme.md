So, here's the deal with my work on anomaly detection using ANN and PCA in R. 
First off, I dug into the data and did some exploratory analysis to get a feel for what I was dealing with. Checking out the patterns, looking for anything fishy.

Then, I jumped into the fun stuff and fired up ANN using this cool package called h2o in R. ANN is like a brain-inspired machine learning thing that's great at finding complex relationships in data. Perfect for sniffing out those anomalies. I trained the ANN models on my data to catch any weird deviations from what's normal. By the way, it is good to mention that i reduce the amount of data from 6 milion to a hundred thousand. 

I didn't stop there. I wanted to be fancy, so I brought in PCA to join the party. PCA does this dimensionality reduction thing, taking the original variables and squeezing them into these new uncorrelated ones called principal components. This helped me pinpoint the important features in the data and keep things nice and compact.

To make things even better, I used dedicated memory of h2o lib for running the ANN models. It made everything faster and more efficient, which was crucial in heavy computations.

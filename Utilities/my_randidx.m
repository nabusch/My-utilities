function idx = randidx( popsize, nsamples)
% function idx = randidx( popsize, nsamples);
% 
% This function creates a number of indices. Say you want to draw N random
% sample (with replacement) from vector vec. % 
% 
% vec = [1:1000];
% L = length(vec); N = 10; 
% 
% idx = randidx(L,N);

% Then use the vector 'idx' of indices to get a new vector that contains
% random draws (with replacement) from vec.
% sampvec = vec(idx);

idx = ceil( popsize * rand(1,nsamples));

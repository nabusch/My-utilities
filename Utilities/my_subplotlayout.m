function [nrows, ncols] = my_subplotlayout(n)
% function [nrows, ncols] = my_subplotlayout(n)
%
% This function dtermines for a given numer of plot the optimal arrangement
% of subplot rows and columns. Optimal means:
% - minimal number of rows and columns
% - if layout is not square, have more columns than rows

%%

if isprime(n) & n>3
    n = n+1;
end

nrows = [];
ncols = [];

for i=1:n
    if mod(n,i) == 0
        nrows = [nrows i];
        ncols = [ncols n/i];
    end
end

% Find the pair of divisors that, when added together, have the smallest
% sum. These divisors will create the least 'stretched' subplot layout.
% Using the first of these minimal divisors (minsums(1)) makes sure that we
% have more columns than rows. This makes more sense because the monitor is
% usually wider than high.
sums = nrows + ncols;
minsums = find(sums==min(sums));


nrows = nrows(minsums(1));
ncols = ncols(minsums(1));
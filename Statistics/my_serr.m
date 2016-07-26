function serr = my_serr(data, dim);
% function serr = my_serr(data, dim);
% Computes the standard error of the input data along dimension dim.
% In other words, dimension DIM represents subjects.
% data: input data
% dim:  which dimension corresponds to subjects?
% Written by Niko Busch (niko.busch@gmail.com)
%
% 2011-05-23

n = size(data, dim);

serr = std(data, [], dim) / sqrt(n);
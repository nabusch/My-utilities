function [std_err] = std_err(data, dim);
% function [std_err] = std_err(data, dim);
% Computes the standard error of the input data along dimension dim.
% In other words, dimension DIM represents subjects.
%
% Written by Niko Busch (niko.busch@gmail.com)
%
% 2011-05-23


n = size(data, dim);

std_err = nanstd(data, [], dim) / sqrt(n);
function x_out = my_removenans(x_in)
% function x_out = my_removenans(x_in)
%
% Removes Nans from a vector. Caution: really works only with vectors, not
% matrices.

not_a_nan = ~isnan(x_in);
x_out = x_in(not_a_nan);
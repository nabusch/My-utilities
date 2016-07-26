function out = push(in, new, index)
% function out = push(in, new, index)
%
% This function takes original vector "in" and inserts another vector
% "new", starting at element "index".
% Example:
% in  = [1 2 3 4 7 8 9];
% new = [5 6];
% index = 5;
% out = push(in, new, index)

out = [in(1:index-1) new in(index:end)];
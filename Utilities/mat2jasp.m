function mat2jasp(m, factornames, subjdim, filename, replacenans)
% function mat2jasp(m, factornames, subjdim, filename)
%
% A function to write any matrix to a CSV file that JASP can understand.
%
% m: a mtrix with arbitrary dimensions. One dimension represents subjects.
% factornames: {'cond', 'mask'} cell array with strings indicating factors.
% subjdim: which dimension represents subjects? The function will rotate
% the matrix so that this dimension comes first, as required by JASP
% (SPSS-style).
% filename: 'output.csv' string with output filename
% replacenans: replace missing values in the matrix with the average across
% all subjects.
%
% Note: the number of factornames must be ndmis(m)-1!!!


% rearrange matrix in the requested way, so that subject dimension comes
% first.
m2 = shiftdim(m, subjdim-1);

factorlevels = size(m2);
factorlevels(1) = [];
factorlevels = fullfact(factorlevels);

headstr = [];

factornames_length = length(flatten(factornames));

if factornames_length == ndims(m)-1
    
    for icond = 1:length(factorlevels)
        for ifactor = 1:length(factornames)
            headstr = [headstr factornames{ifactor} num2str(factorlevels(icond, ifactor))];
        end
        
        if icond < length(factorlevels)
            headstr = [headstr '; '];
        end
    end
    
elseif  factornames_length == sum(size(squeeze(mean(m,subjdim))))
    
    for icond = 1:length(factorlevels)
        for ifactor = 1:length(factornames)
            headstr = [headstr factornames{ifactor}(factorlevels(icond,ifactor))];
        end
        
        if icond < length(factorlevels)
            headstr = [headstr '; '];
        end
    end    
    
else
    disp('The number of factor names is shit!')
end

if iscell(headstr)
    headstr = cell2mat(headstr);
end

fid = fopen(filename, 'w');
fprintf(fid, '%s\n', headstr);
fclose(fid);



m3 = m2(:,:);

if replacenans
    for icolumn = 1:size(m3,2)
        
        tmpcolumn = m3(:,icolumn);
        
        tmpcolumn(isnan(tmpcolumn)) = nanmean(tmpcolumn);
        
        m3(:,icolumn) = tmpcolumn;
    end
end

dlmwrite(filename, m3, '-append', 'precision', '%.6f', 'delimiter', ';');

%%
function C = flatten(A)
% 
% C1 = flatten({{1 {2 3}} {4 5} 6})
% C2 = flatten({{'a' {'b','c'}} {'d' 'e'} 'f'})
% 
% Outputs:
% C1 = 
%     [1]    [2]    [3]    [4]    [5]    [6]
% C2 = 
%     'a'    'b'    'c'    'd'    'e'    'f'
%
% Copyright 2010  The MathWorks, Inc.
C = {};
for i=1:numel(A)  
    if(~iscell(A{i}))
        C = [C,A{i}];
    else
       Ctemp = flatten(A{i});
       C = [C,Ctemp{:}];
       
    end
end
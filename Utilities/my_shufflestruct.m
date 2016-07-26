function outstruct = my_shufflestruct(instruct)
% function outstruct = my_shufflestruct(instruct)
%
% Shuffles all numerical fields of a Struct.
% NOTE: string fields a left untouched.
%
% Written September 12, 2012 by Niko Busch
% niko.busch@gmail.com

if ~isstruct(instruct)
    error('Error: Input must be a struct variable!')
end

outstruct = struct;
allfield_names = fieldnames(instruct);

for ifield = 1:length(allfield_names)
    thisfield_data = getfield(instruct, allfield_names{ifield});
    
    if isnumeric(thisfield_data)
        n = size(thisfield_data);
        [null,index] = sort(rand(n));
        outstruct.(allfield_names{ifield}) = thisfield_data(index);
    else
        outstruct.(allfield_names{ifield}) = thisfield_data;
    end
end
    
    
function y = mmean(x, dims)
dims = sort(dims, 'descend');

for idim = 1:length(dims)
    x = mean(x, dims(idim));
end

y = squeeze(x);


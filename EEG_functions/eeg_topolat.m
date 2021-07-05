function [topolat_backshift, lchan_idx, rchan_idx] = eeg_topolat(l_data, r_data, chanlocs, chan_dim);


if nargin == 3
    chan_dim = 1;
end

%%

% some coordinates for chans on the midline have very small, but non-zero
% values. We round them down to zero.
for i = 1:length(chanlocs)
    chanlocs(i).Y = round(10 * chanlocs(i).Y) / 10;
end

% find left and right channels.
lchan_idx = find([chanlocs.Y] >  0);
rchan_idx = find([chanlocs.Y] <  0);


% we rotate the data matrix so that the channel dimension comes first.
original_dims = (1:ndims(l_data))';
shiftdims     = circshift(original_dims, [1-chan_dim,0]);

l_data_shift = permute(l_data, shiftdims);
r_data_shift = permute(r_data, shiftdims);


% We calculate contra - ipsi.
topolat = zeros(size(l_data_shift));
topolat(lchan_idx,:) = r_data_shift(lchan_idx,:) - l_data_shift(lchan_idx,:);
topolat(rchan_idx,:) = l_data_shift(rchan_idx,:) - r_data_shift(rchan_idx,:);

topolat_backshift = ipermute(topolat, shiftdims);


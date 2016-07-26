function h = my_plotserr(eegin, eegtimes, color);
% function h = my_plotserr(eegin, eegtimes, color);
%
% Function for plotting the standard error of the mean around an ERP. This
% functions requires that the input EEG data be 2D.
%
% eegin: input EEG data. Must be 2D: times X subjects/trials.
% eegtimes : series of time stamps, e.g. from EEG.times.
% color: color in which to plot the standard error.
%
% Example:
%
% channel = 32;
% dat = squeeze(EEG.data(channel,:,:));
% figure; h1 = my_plotserr(dat, EEG.times, [0.5 0.5 0.8]);
%
% Written by Niko Busch - niko.busch@gmail.com
% Aug 14 2011: wrote version 1






if ndims(eegin) ~= 2
    error('Error: input data must be two-dimensional!')
end

if size(eegin,1) ~= size(eegtimes)
    error('Error: length of input data must match length of times stamps!')
end


% Compute standard error
stderr = (std(eegin, [], 2) ./ sqrt(size(eegin, 2)))';

% Compute ERP
erp = mean(eegin,2)';

h = fill([eegtimes fliplr(eegtimes)], [erp-stderr fliplr(erp+stderr)], 'k', ...
    'facecolor', color, 'edgecolor', 'none'); hold on
uistack(h, 'bottom')
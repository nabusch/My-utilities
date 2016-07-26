function gfp = my_gfp(eegdata, chandim, avref)
% function gfp = my_gfp(eegdata, chandim, chaninds, avref)
% 
% Computes global field power as the standard deviation across electrodes.
% Inputs:
% eegdata: well, the EEG data, eg. EEG.data.
% chandim: optional, which dimension represents channels? 1 by default.
% avref: rereference the data to average reference (default: no). Not sure
% if this makes a difference on the result.

% Written by Niko Busch - Charite Berlin (niko.busch@gmail.com)
%
% 2012-07-29

if ~exist('eegdata','var'),
    error('No eeg input!');
end

if ~exist('chandim','var'),
    chandim = 1;
    disp('Assuming that first dimension represents channels');
end

nchans = size(eegdata);

if exist('avref','var') && avref==1
    avgref = mean(eegdata, chandim);
    avgref = repmat(avgref,nchans,1);
    eegdata = eegdata - avgref;
end    

gfp = squeeze(std(eegdata, [], chandim));

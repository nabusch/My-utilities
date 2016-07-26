function my_eegplot(EEG, ntrials, nchans, amps, title);
% function my_eegplot(EEG, ntrials, nchans, amps);
%
% Function for plotting EEGLAB raw data.
% Require input:
% EEG: EEGLAB data set
% ntrials: how many trials to show in one window
% nchans: how many channels to show in one window
% amps: amplitude range for display


set(0,'Units', 'pixels')
sz = get(0,'ScreenSize');

if nargin<2
    ntrials = 10;
end

if nargin<3
    nchans = EEG.nbchan;
end

if nargin<4
    amps = 100;
end

if nargin<5
    title = EEG.filename;
end


eegplot(EEG.data, ...
    'eloc_file', EEG.chanlocs, ...  
    'title', title,...
    'winlength', ntrials, ...
    'spacing', amps, ...
    'dispchans', nchans, ...
    'limits', [1000*EEG.xmin 1000*EEG.xmax], ...
    'srate', EEG.srate, ...
    'butlabel', 'Close', ... 
    'events', EEG.event, ...
    'position', [0 25 sz(3)/2 sz(4)-100]);
 
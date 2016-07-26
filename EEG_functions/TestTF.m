% This script applies a time frequency analysis to a small subset of data
% to test if your setting are appropriate. The function requires a
% configuration file that defines paths and filenames and the settings for
% the tf analysis.
%
% Note: the point of this script is NOT to spot any experimental effects in
% the data. It serves only to check if the time/frequency resolution is
% appropriate and if the time range of the output is long enough.

%% Set variable parameters and choose a subject index.
addpath('../');
ntrials = 10; % How many trials to analyze. Keep this number low, it is only a test.
chan    = 38; % Which channel to analyze.
desired_epochlimits = [-1.3 1.3]; % Desired epoch limits after TF analysis.

thisidx = 2;
cfg = getcfg(thisidx);    

%% Load data.
EEG = pop_loadset('filename', [cfg.subject_name '_import.set'] , ...
'filepath', cfg.dir_eeg, 'loadmode', 'all');   

%% Run TF analysis.
[wavelet, cycles, freqresol, timeresol] = ...
     dftfilt3( cfg.tf_freqsout, cfg.tf_cycles, EEG.srate);

 wavelet_length = (1/EEG.srate) .* length(wavelet{1});
 
[tf, TF.freqs, TF.times, ~] = ...
    timefreq(squeeze(EEG.data(chan,:,1:ntrials)), EEG.srate, ...
    'cycles',       cfg.tf_cycles, ...
    'tlimits',      [EEG.xmin EEG.xmax], ...
    'wletmethod',   'dftfilt3', ...
    'ntimesout',    cfg.tf_timesout,...
    'freqs',        cfg.tf_freqsout, ...
    'nfreqs',       cfg.tf_nfreqs, ...
    'freqscale',    cfg.tf_freqscale, ...
    'causal',       cfg.tf_causal);

TF.power = mean(abs(tf).^2,3);

necessary_limits = [desired_epochlimits(1)-0.5*wavelet_length desired_epochlimits(2)+0.5*wavelet_length];

disp('...........................................................................')
fprintf('Original epoch length: \t%2.3f .. %2.3f s\n', EEG.xmin, EEG.xmax);
fprintf('TF epoch length: \t%2.3f .. %2.3f s\n', TF.times(1), TF.times(end));
fprintf('To achieve desired epoch length of %2.3f .. %2.3f s with these TF settings, \nyou need an original epoch length of at least %2.3f - %2.3f s.\n', desired_epochlimits, necessary_limits)
disp('...........................................................................')

%% Plot results

figure;
subplot(2,1,1)
    contourf(TF.times, TF.freqs, TF.power, 32, 'linestyle', 'none')

subplot(2,1,2)    
hold all
    x = (1/EEG.srate) .* (1:length(wavelet{1}));
    plot(x, real(wavelet{1}))
    plot(x, imag(wavelet{1}))
    xlabel('time [s]')
    title(['Lowest freq wavelet at ' num2str(cfg.tf_freqsout(1)) ' Hz. Length: ' num2str(wavelet_length) ' s'])
    axis tight
    
%%
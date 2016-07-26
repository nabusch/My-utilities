function [topo, t_start, t_stop, f_start, f_stop] = my_tftopo(tf, times, freqs, timerange, freqrange, chanlocs, makeplot, plotoptions)
% [topo, t_start, t_stop, f_start, f_stop] = my_tftopo(tf, times, freqs, timerange, freqrange, chanlocs, makeplot, plotoptions)
%
% Computes a topography for a time-frequency window:
% Inputs:
% tf: the data as frequencies x times x channels
% times: vector of time stamps
% freqs: vector of frequencies
% time_range: e.g. [.400 0.900]
% freqrange: e.g. [8 12]
% chanlocs: eeglab chanlocs structure
% makeplot: make a plot or just compute topography
% plotoptions: cell array with topoplot commands. e.g. {'maplimits', 'maxmin', 'conv', 'on', 'emarker2', {[plot_chans],'.','w',14,1}}
%
% Written by Niko Busch - Charité Berlin (niko.busch@gmail.com)
%
% 2012-04-23

[~, t_start] = min(abs(times-timerange(1)));
[~, t_stop]  = min(abs(times-timerange(2)));
[~, f_start] = min(abs(freqs-freqrange(1)));
[~, f_stop]  = min(abs(freqs-freqrange(2)));

topo = squeeze(mean(mean(tf(f_start:f_stop, t_start:t_stop,:),2)));

if makeplot
    topoplot(topo, chanlocs(1:length(topo)), plotoptions{:});
end
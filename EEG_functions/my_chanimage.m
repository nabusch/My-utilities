function [ih] = my_chanimage(data, cfg)
% function [ih] = my_chanimage(data, cfg)
% This function produces a "chanimage": a color coded display of all time series from
% all channels. The function basically uses iamgesc, but has a few built-in
% tricks. Depending on the dimensions of the input data, the function will
% either display data from a single condition, the difference between two
% conditions, or results of a ttest between conditions.
% The function requires:
% data: channels x time: display of a single condition ERP
%       channels x time x trials: the function will average across trials and diplay the single condition ERP.
%       channels x time x 2: the function assumes that the third dimension
%       represents conditions (not two trials) and display the difference
%       between the two conditions.
%       channels x time x subjects x 2: the function will compute a ttest
%       and display the t-statistics.
%
% cfg.times          = ALLEEG(1).times; % REQUIRED: a vector of "time stamps".
% cfg.plottimes      = [-200 1000]; % OPTIONAL: restrict the time range to plot.
% cfg.chanlocs       = ALLEEG(1).chanlocs; % OPTIONAL: used for sorting channels.
% cfg.plotchans      = 1:64; % OPTIONAL: restrict range of channels to plot
% cfg.testdesign     = 'between'; % OPTIONAL: 'between' or 'within' (for single subjects) ttest
% cfg.pthreshold     = 0.01; % OPTIONAL: mask t-values below this threshold
% cfg.clim           = [-5 5]; % OPTIONAL: set the range for the color scale
% cfg.highlightchans = [1:10, 67]; % OPTIONAL: transparent mask for highlighting channels of interest
% cfg.maskwindows    = [150 500; 600 800]; % OPTIONAL: transparent mask for highlighting timeranges of interest
% cfg.srate          = ALLEEG(1).srate; % REQUIRED only when maskwindows is active.
% cfg.vertlines      = [100 600]; % OPTIONAL: plot vertical lines at specified times.
% cfg.cbar           = 1; % OPTIONAL: 1=plot color bar; 0=do not plot
% cfg.elabels        = []; % OPTIONAL: vector with indices of channels for which to plot ylabels

% fh=figure('color', 'white');

data = squeeze(data);
ntimes = size(data,2);

% Which channels shall be plotted?
if isfield(cfg, 'plotchans')
    nchans = cfg.plotchans;
else
    nchans = size(data,1);
    cfg.plotchans = 1:nchans;
end

% Time stamps
if isfield(cfg, 'times')
    timevec = cfg.times;
else
    timevec = 1:ntimes;
end

% Channel location info. Important for arranging data  on
% anterior-posterior axis.
if isfield(cfg, 'chanlocs')
    chanlabels = {cfg.chanlocs(cfg.plotchans).labels}; 
    
    [~, chan_sort_index] = sort([cfg.chanlocs(cfg.plotchans).X], 'descend');    
else
    chanlabels = 1:nchans;
    chan_sort_index = 1:nchans;
end
   
% What type of data is this?
% - A single ERP (channels x times)
% - Single trial EEG for one condition (channels x times x trials)
% - Two ERPs from two conditions (channels x times x 2)
% - Two grand averages (channels, times, subjects, conditions
if ndims(data)==2
    plotdata = data(chan_sort_index,:); % a single averaged ERP
elseif ndims(data)==3
    if size(data,3)>2
        plotdata = mean(data(chan_sort_index,:,:),3); % single trial EEG, will be averaged
    else
        plotdata = data(chan_sort_index,:,1) - data(chan_sort_index,:,2); % two ERPs, will compute difference
    end
elseif ndims(data)==4
    if isfield(cfg, 'testdesign') && strcmpi(cfg.testdesign, 'within')
        [H,P,CI,STATS] = ttest2(data(:,:,:,1), data(:,:,:,2), 0.05, 'both', [], 3);
    else
        [H,P,CI,STATS] = ttest(data(:,:,:,1), data(:,:,:,2), 0.05, 'both', 3);
    end
    
    if isfield(cfg, 'pthreshold') 
        df = size(data,3)-1;
        t_threshold = tinv(cfg.pthreshold, df);
        STATS.tstat(abs(STATS.tstat)<abs(t_threshold)) = 0;
        
        newjet = jet;
        newjet(32,:) = [0.9 0.9 0.9];
        newjet(33,:) = [0.9 0.9 0.9];
%         newjet(32,:) = [0 0 0];
%         newjet(33,:) = [0 0 0];
        colormap(newjet);
    end
    
    plotdata = STATS.tstat(chan_sort_index,:);
else
    fprintf('Don`t know what to do with that data.\n Data has %d dimensions.\n', ndims(data));
    return
end


%% Make the image
ih = imagesc(timevec,cfg.plotchans,plotdata);


%% Format the image
mask = 0.5 .* ones(size(plotdata));


if isfield(cfg, 'highlightchans')  
    mask(cfg.highlightchans,:) = 1;
    mask = mask(chan_sort_index,:); 
    set(ih, 'AlphaData', mask);
end


if isfield(cfg, 'maskwindows')    
    for iwindow = 1:size(cfg.maskwindows,1)
        mask_xlims = eeg_lat2point( cfg.maskwindows(iwindow,:)/1000, 1, cfg.srate, [timevec(1) timevec(end)]/1000);
        mask_xlims = round(mask_xlims);        
        mask(:,mask_xlims(1):mask_xlims(2)) = 1;
    end
    set(ih, 'AlphaData', mask);
end



xlabel('time', 'fontweight', 'bold')
ylabel('electrodes', 'fontweight', 'bold')

if isfield(cfg, 'plottimes')
    set(gca, 'xlim', cfg.plottimes)
end

line([0 0],get(gca,'Ylim'),'Color','k', 'linewidth', 1)

% Make electrode labels for y-axis
if isfield(cfg, 'elabels')
    mark_channels = find(ismember(chan_sort_index, cfg.elabels));
    mark_channels = sort(mark_channels);
    set(gca, 'YTick', mark_channels, 'YTickLabel', chanlabels(chan_sort_index(mark_channels)))
else
    set(gca, 'YTick', cfg.plotchans, 'YTickLabel', chanlabels(chan_sort_index))
end

set(gca, 'TickDir', 'out')

if ~isfield(cfg, 'clim')
    max_val = max(abs(plotdata(:)));
    cfg.clim = [[-max_val max_val]];
end
set(gca, 'CLim', cfg.clim)  


if isfield(cfg, 'vertlines')    
    for i=1:length(cfg.vertlines)
        line([cfg.vertlines(i) cfg.vertlines(i)],get(gca,'Ylim'),'Color','k', 'linewidth', 1)
    end
end

if isfield(cfg, 'cbar') 
    if cfg.cbar==1
        colorbar
    end
end



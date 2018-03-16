function RES = proc_longtable(LOG, factors, dvs, case_var, stats)

% Extract data from a longtable in which each line is a single trial and
% each column codes a variable.
%
% INPUTS:
% LOG:      longtable in Matlab's table format.
% factors:  independent variables; L must have a column with that name.
%           Can be cell array of multiple variable names.
% dvs:      dependent variables, for which to compute the mean across cases.
%           Can be a cell array with multiple variable names.
% case_var: typically, this would be subjects, but in some situations, it
%           could be something else. E.G. each subject sees a images,
%           and we want to know the performance for each image.
% stats:    compute 'mean' or 'median' of the dependent variable. Default
%           is mean. Note: if DV is zeros and ones, use 'mean' for
%           computing proportions, e.g. error rates.
%
% OUTPUT:
% RES: a struct with the results with the following field names:
% dv: (name of this field=name of the dvs) for each dv, a matrix in which each element is a subject's mean for a combination
% of factor levels. The last dimension represents subjects.
% factors = factor names.
% cases   = names of cases.
%
% TODO:
% - allow to rename variable labels.
% - allow option to output in csv format for later import to JASP or R.


% Check inputs
if nargin < 5
    stats = 'mean';
end

factors = makecell(factors);
dvs = makecell(dvs);
stats = makecell(stats);

if length(stats) < length(dvs)
    for idv = 1:length(dvs)
        stats{idv} = stats{1};
    end
end


% Put data for DV in a new variable. Runs faster than operating with the
% table.
for idv = 1:length(dvs)
    dv_data(idv,:) = LOG.(dvs{idv});
end    
    

% What are we interested in a "factor", e.g. scene category. A "condition"
% is a specific factor level or a combination of levels of different
% factors, e.g. "low memorability" AND "kitchen scene".
for ifactor = 1:length(factors)
    factor_data{ifactor} = LOG.(factors{ifactor});
    factor_level_names{ifactor} = unique(factor_data{ifactor});
    factor_level_names{ifactor}(isnan(factor_level_names{ifactor})) = []; % remove nans
    RES.factor_levels{ifactor} = factor_level_names{ifactor};
    factor_nlevels(ifactor) = length(factor_level_names{ifactor});
end


% Which lines in the logfile correspond to the cases we are interested in
% (subjects, images, etc.)?
case_data  = cellstr(LOG.(case_var));
RES.case_names = unique(case_data);
ncases     = length(RES.case_names);
RES.case_dim = length(factors)+1;


% Initialize outputs.
for idv = 1:length(dvs)
    res{idv} = nan([factor_nlevels, ncases]);
end


% Create a design matrix. Each row is a condition: a specific combination
% of factor levels of all dependent variables. Each column represents the
% specific factor level for each dv.
dsgn = fullfact(factor_nlevels);


RES.factors = factors;
RES.stats = stats;
RES.DVs = dvs;
%% Run across all conditions, i.e. rows in the design matrix.
for icondition = 1:size(dsgn,1)
    
    % Select which trials belong to each combination of conditions of all factors.
    condition_trials = get_trials(dsgn, icondition, factor_data, factor_level_names);
    
    % For each case, compute the mean/median/proportion value of the dependent
    % variable for this condition.
    for icase = 1:ncases
        
        idx = num2cell([dsgn(icondition,:), icase]);
        
        if iscellstr(case_data)
            this_case = strcmp(case_data, RES.case_names(icase));
        else
            this_case = case_data == case_names(icase);
        end
        
        case_trials = condition_trials & this_case;
        
        for idv = 1:length(dvs)
            
            switch(stats{idv})
                case 'mean'
                    res{idv}(idx{:}) = nanmean(dv_data(idv,case_trials));
                case 'median'
                    res{idv}(idx{:}) = nanmedian(dv_data(idv,case_trials));
            end
            
        end
        
    end
end


for idv = 1:length(dvs)
    RES.(dvs{idv}) = res{idv};
end

%% Subfunctions
%--------------------------------------------------------------------------
function condition_trials = get_trials(dsgn, icondition, factor_var, factor_level_names)

% Select which trials belong to each combination of conditions of all factors.
for ifactor = 1:size(dsgn,2)
    this_factor_level = factor_level_names{ifactor}(dsgn(icondition,ifactor));
    
    if iscellstr(factor_var{ifactor})
        select_trials(:,ifactor) = strcmp(factor_var{ifactor}, this_factor_level);
    else
        select_trials(:,ifactor) = factor_var{ifactor} == this_factor_level;
    end
end

% The trials for this condition are those which match all factor
% levels.
condition_trials = all(select_trials,2);
%--------------------------------------------------------------------------
function var = makecell(var)
if ~iscell(var)
    var = cellstr(var);
end


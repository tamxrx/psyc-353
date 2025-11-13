%% Lecture 5: Psychometric Functions

% Shade Discrimination Task

clear, clc, close all

% set task parameters
n_reps = 5; % repetitions of each contrast
baseline = .4; % baseline brightness
rf_contr = .1; % reference contrast (10%)

bg_tone = repmat(baseline, 1, 3); % background brightness in RGB
rf_tone = bg_tone + baseline * rf_contr; % compute reference tone (baseline + 10% of baseline) in RGB

% contrast definition: the difference between the brightness of the object and the background against which it is viewed, divided by the background brightness.
% i.e., contrast = (stimulus - background) / background
% or: stimulus = background + contrast * background

% define list of possible contrasts and add the reference to get total contrasts
contrasts = [-.045 -.03 -.015 0 .015 .03 .045] + rf_contr;

trials = repmat(contrasts, 1, n_reps); % repeat each contrast n_reps times

trials_rnd = randsample(trials, length(trials)); % randomize trials

% initialize respose array
resp = nan(1, length(trials));

% initialize correct array
correct = nan(1, length(trials));

% Initialize the figure for the task
figure(1), clf, hold on

set(gcf, 'Color', bg_tone, 'Position', [400, 120, 1000, 800]) % Position is [hrz, vrt, height, width] 
set(gca, 'Color', bg_tone, 'xlim', [-2 2], 'ylim', [-1 1])
axis off

% Create the two circles, but make them invisible (ie same tone as bg) before the trials start
left = plot(-1, 0, 'o', 'MarkerSize', 150, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', bg_tone); hold on
right = plot( 1, 0, 'o', 'MarkerSize', 150, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', bg_tone);

%% Run the experiment

% Start the task (with a FOR loop)
for trial = 1:length(trials)
        
    % remember: stimulus = background + contrast * background
    targ_shade = baseline + trials_rnd(trial) * baseline; % create target contrast
    targ_tone  = repmat(targ_shade, 1, 3);                % turn into RGB
    
    % reference always left
    set(left, 'MarkerFaceColor', rf_tone)         % left is reference
    set(right, 'MarkerFaceColor', targ_tone), shg % right is brighter
        
    resp(trial) = input("Which circle is lighter? (1/2) "); % gather response
    
    % While next trial starts, "turn off" the circles
    set(left, 'MarkerFaceColor', bg_tone)
    set(right, 'MarkerFaceColor', bg_tone)
    
    pause(1)
    clc
    
end

% save the results
save('my_results_original.mat', 'resp', 'trials_rnd', 'rf_contr', 'contrasts', 'n_reps')

%% Plot results
clear, clc, close all

% in case the data were lost, load your results (MUST BE IN SAME FOLDER AS
% YOUR CURRENT SCRIPT)
load("my_results_original.mat")

% initialize proportions array
p_targ = nan(1, length(contrasts));

% loop over the different contrasts used and calculate the proportion of 2s
for i=1:length(contrasts)
    % finds trials that have the specific contrast
    y = find((trials_rnd) == contrasts(i));
    % proportion of resuklts that were 2s
    p_targ(i)= sum(resp(y)==2)/length((y));
end
% get the possible contrast increases

contr_diff = contrasts-rf_contr; % diff between two circles

% close existing figure and open a new one
close
figure(1)

% plot results using a scatterplot

scatter(contr_diff, p_targ, 50, 'MarkerFaceColor', [0 .5 .2], 'MarkerEdgeColor', [0 .5 .5])
xlabel('Contrast Difference')
ylabel('Proportion of Target Brighter on the right side')

xlim([min(contr_diff) max(contr_diff)])
ylim([0 1])

set(gca, 'FontSize', 12)
hold on

%% Fit psychometric function using Palamedes

% Define the space of your stimulus levels
x_min = min(contr_diff);
x_max = max(contr_diff);
n = 500;
x = linspace(x_min, x_max, n);


% Add YOUR Palamedes path (MUST BE IN SAME FOLDER AS YOUR CURRENT SCRIPT)

palamedes_dir = '/Users/tamarabgreco/Documents/MATLAB/psyc-353/tutorials/Palamedes1_10_11/Palamedes';

addpath(palamedes_dir)

% initialize PF type as Logistic
PF = @PAL_Logistic;

% we want to search for the first 2 parameters (alpha and beta)
% but we keep the last 2 (gamma and lambda) fixed

% setup the parameter search
paramsFree = [1 1 0 0];

% alpha is the threshold
searchGrid.alpha = min(contr_diff, 0.001);

% beta is the slope
searchGrid.beta=logspace(0,3,101);


% gamma is the guessing rate

searchGrid.gamma = 0;

% lambda is the lapse rate
searchGrid.lambda = 0;

%number of 'target brighter right side (2)' responses (NumPos) out of total
%trials per contrast level (OutofNum)
NumPos = p_targ*n_reps;
OutofNum = repmat(n_reps, 1, length(contr_diff));

stimLevels = contr_diff;
% tell palamedes to find the parameters

paramsValues = PAL_PFML_Fit(stimLevels, NumPos, OutofNum, searchGrid, paramsFree, PF);

% run the PF
pal_fit = PF(paramsValues,x);
% plot
plot(x, pal_fit, 'LineWidth', 2, 'MarkerFaceColor', [0 .4 .2],'D);
xlabel('Length Difference')
ylabel('p(target brightness on right side')

xlim([min(contr_diff) max(contr_diff)])
ylim([0 1])

hold on 
set(gca, 'FontSize', 16)
title('Palamedes Fit')
savefig ('palamedes_original_img')

%display parameters for the PF


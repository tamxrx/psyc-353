name = "Tamara Brissette Greco";
student_id = 261182266;

% Muller-Lyer Illusion Task

% This experiment assesses how our perception of the relative size of two lines
% can be altered due to added fins at their ends.
% The first fin has outwards fins and is of fixed length
% The second fin (target) has inwards fins and is of variable length

% This script creates several repetitions of various target sizes
% and determines the proportion of times each target size is perceived as
% longer than the fixed line.


clear, clc, close all

%% Part 1: Initialization and parameters

% set minumim and maximum target size
min_size = .9; % minimum target size (relative to the reference)
max_size = 1.4; 

n_levels = 9; % num of variations/stimulus lvls
n_reps = 3;% num of reps of each lvl
n_trials = n_levels * n_reps;


levels = linspace(min_size,max_size, n_levels); % generate levels within min/max at given interval
trials= repmat(levels,1,n_reps); % rep each lvl n_reps times (ordered)
rnd_trials = randsample(trials, n_trials); % randomly select from trials, n_trial times

stim_duration = .5; % quick stimulus duration

% set background and stimulus colors
bg_color = [.8 .8 .8];
line_color = [0 0 0];

resps = nan(1, n_trials);

% Initialize the figure
figure(1), clf
% normalize: axis remain consistent
% outerposition: where the corners of the figure are (ex. fullscreen)
% Toolbar anf menu: view off
set(gcf,'Color', bg_color, 'Units', 'Normalized','OuterPosition', [0 0 1 1], 'Toolbar', 'none', 'Menu', 'none')

% draw fixed stimulus (middle line of stim)
% Same as bg color to begin with
rf_line = plot([-1 -1],[-5 5], 'Color', bg_color, 'LineWidth',4); hold on
rfUp = plot([-0.5 -1 -1.5],[7 5 7], 'Color', bg_color, 'LineWidth',4);
rfDn = plot([-0.5 -1 -1.5],[-7 -5 -7,], 'Color', bg_color, 'LineWidth',4);

% draw target stimulus
tg_line = plot([1 1],[-5 5], 'Color', bg_color, 'LineWidth',4); hold on
tgUp = plot([0.5 1 1.5],[3 5 3], 'Color', bg_color, 'LineWidth',4);
tgDn = plot([0.5 1 1.5],[-3 -5 -3,], 'Color', bg_color, 'LineWidth',4);

set(gca, 'xlim', [-3 3], 'ylim', [-15 15]) % consistent axis

% add beginning text
press_enter = text(0,0, 'Press RETURN to start', 'HorizontalAlignment','center','FontSize',30, 'Color', line_color);

% remove axis lines and ticks
axis off

pause

delete(press_enter), pause(2)


%% Part 2: Start Experiment

for t = 1:n_trials
    
    % extract length of target line for this trial
    % making the trial slightly longer/shorter
    tar = rnd_trials(t)*5; % cur trial value * 5 (bc of the units)
       
    % show fixation cross for 500ms
    fix = text(0,0, '+', 'HorizontalAlignment','center','FontSize',50);
    pause(.5)
    delete(fix)
    % make reference line visible (ie, change its current color)
    set(rf_line, 'Color', line_color)
    set(rfUp, 'Color', line_color)
    set(rfDn, 'Color', line_color)

    % show target line and adjust its size according to trial
    set(tg_line, 'Color', line_color, 'YData',[-tar tar])
    set(tgUp, 'Color', line_color, 'YData', [tar-2 tar tar-2])
    set(tgDn, 'Color', line_color, 'YData', [-tar+2 -tar -tar+2])

    % pause for stimulus duration
    pause(stim_duration)
    
    % "turn off" lines
    set(rf_line,'Color',bg_color)
    set(rfUp, 'Color', bg_color)
    set(rfDn, 'Color', bg_color)

    set(tg_line, 'Color', bg_color)
    set(tgUp, 'Color', bg_color)
    set(tgDn, 'Color', bg_color)

    % display instruction to press 1 or 2
    instr = text(0,0, 'Which line was longer? 1 or 2', 'HorizontalAlignment','center', 'FontSize', 30);
        
    % gather response
    waitforbuttonpress
    x = get(gcf, 'CurrentCharacter'); % stores input
    resps(t) = str2double(x); % double type conversion
    
    % remove instruction
    delete(instr)
    
    % pause 200ms
   pause(0.2)
end
% save data
save('hw6_BrissetteGreco.mat')

%% Part 3: Plot results (almost identical to Tutorial 5)

% % in case the data were lost, load your results
load('hw6_BrissetteGreco.mat')
% 
% % initialize proportions array
p_targ = nan(1, n_levels);
% 
% % loop over the different contrasts used and calculate the proportion of 2s
for i = 1:n_levels
     idx = find(rnd_trials == levels(i));
     p_targ(i) = sum(resps(idx)==2)/length(idx); % proportion target brighter responses
 end
% 
% % close existing figure and open a new one
close
figure(1), clf
% 
% % plot results using a scatterplot
scatter(levels, p_targ, 100, 'MarkerFaceColor', [0 .7 .7], 'MarkerEdgeColor', [0 .5 .5])
% 
% % Customize plot
xlabel('Target Length')
ylabel('p(target longer)')
% 
xlim([min(levels) max(levels)])
ylim([0 1])
% 
set(gca, 'FontSize', 16)
% 
grid minor
% 
hold on

%% Challenge: 
% Use PALAMEDES to fit a psychometric function to your results. Then report
% the parameters (alpha and beta) and prepare a figure of the function
% plotted over your data.

%% Fit psychometric function using Palamedes

% Define the space of your stimulus levels
x_min = min(levels);
x_max = max(levels);
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
searchGrid.alpha = min(levels, 0.001);

% beta is the slope
searchGrid.beta=logspace(0,3,101);


% gamma is the guessing rate

searchGrid.gamma = 0;

% lambda is the lapse rate
searchGrid.lambda = 0;

%number of 'target brighter right side (2)' responses (NumPos) out of total
%trials per contrast level (OutofNum)
NumPos = p_targ*n_reps;
OutofNum = repmat(n_reps, 1, length(levels));

stimLevels = levels;
% tell palamedes to find the parameters

paramsValues = PAL_PFML_Fit(stimLevels, NumPos, OutofNum, searchGrid, paramsFree, PF);

% run the PF
pal_fit = PF(paramsValues,x);
% plot
plot(x, pal_fit, 'LineWidth', 2, 'MarkerFaceColor', [0 .4 .2],'DisplayName', 'Original coloured task');
xlabel('Difference')
ylabel('p(target line on right side (2))')

xlim([min(levels) max(levels)])
ylim([0 1])

hold on 
set(gca, 'FontSize', 16)
title('Muller-Lyer Illusion Fit')
savefig ('hw6_BrissetteGreco')
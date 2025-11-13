

%% Visual detection task
% This experiment assess your ability to detect a visual target in white noise.
% It presents a succession of trials with or without a target,
% and calculates d' and criterion based on your hits and false alarms.


%% INITIALIZATION AND PARAMETERS

close all
clear
clc

% set target parameters
target_int = .7;
target_size = 50;
n_targets = 20;

% create a random list of present/absent (1/0) trials
trials = repelem([0 1],n_targets);

trials_rnd = randsample(trials, length(trials));

% initialize (empty) response vector
responses = zeros(size(trials));

% initialize figure
figure(1), clf
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1],'Toolbar', 'none', 'Menu', 'none')
set(gca, 'xlim', [0 500], 'ylim', [0 500])
axis square
axis off
hold on
%% EXPERIMENT STARTS
% start te for loop
for i =1:length(trials_rnd)

    % fixation cross
    fix = text(250,250, '+', 'HorizontalAlignment','center','FontSize',50);
    pause(.7)
    delete(fix)

    % generate white noise
    wn = rand(500);
    
    % generate random X & Y coordinate for the target(circle) position
    target_X = randi([100 400]);
    target_Y = randi([100 400]);

    target2_X = randi([100 400]);
    target2_Y = randi([100 400]);
    
    %display white noise
    imagesc(wn)
    colormap(gray);
    
    show_one = randi([0 1]);

    % target trial
    if trials_rnd(i) == 1
        text(target_X, target_Y,'O', 'FontSize', target_size,'Color',[target_int target_int target_int])
        text(target2_X, target2_Y,'O', 'FontSize', target_size,'Color',[target_int target_int target_int])
    elseif show_one == 1
        text(target_X, target_Y,'O', 'FontSize', target_size,'Color',[target_int target_int target_int])
    end
    pause(0.5)

    % clear axis/figure
    cla

    %prompt user for an answer
    prompt=text(250,250, 'Did you see two circles? 1 = Yes, 0 = No', 'HorizontalAlignment','center','FontSize',30);
    
    waitforbuttonpress
    answer = get(gcf,'CurrentCharacter');
    responses(i) = str2double(answer);

    
    % delete text prompt
    delete(prompt)

    pause(.2)
end


%% ANALYSIS


nH=0; % hit
nF=0; % false alarm

% iterate through trials and check if its correct
for j = 1:length(trials_rnd)

    % if this was a target trial
    if trials_rnd(j) == 1
    
        % if the user response was the target
        if responses(j) == 1
            nH = nH + 1;

        end
        % not target but responded it existed
    elseif trials_rnd(j) == 0
        if responses(j) == 1
            nF = nF+1;
        end
    end
end

%nH = sum(trials_rnd + responses == 2);
%nF = sum(trials_rnd - responses == -1);

% create pH (proportion hit) and pF (proportion false alarm) values
pH = nH/n_targets;

pF= nF/n_targets;


% calculate & display d', criterion & proportion correct using Palamedes
palamedes_dir = '/Users/tamarabgreco/Documents/MATLAB/psyc-353/tutorials/Palamedes1_10_11/Palamedes';
addpath(palamedes_dir)

[dp, C, lnB, Pc] = PAL_SDT_1AFC_PHFtoDP([pH pF]);

% or manually
dprime = norminv(pH) - norminv(pF);
c = -1/2*(norminv(pH) + norminv(pF));
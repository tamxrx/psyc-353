%% Visual detection task
% This experiment assesses your ability to detect a visual target in white noise.
% It presents a succession of trials with or without a target,
% and calculates d' and criterion based on your hits and false alarms.


%% INITIALIZATION AND PARAMETERS

close all
clear
clc

% set target parameters
target_int = .7; % target color = gray 
target_size = 50;
n_targets = 20;

% create a list of present/absent (1/0) trials
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
% start the for loop
for i = 1:length(trials_rnd)
    
    % crete a fixation cross
    fix = text(250, 250, '+', 'HorizontalAlignment', 'center', 'Fontsize', 50);
    pause(.7)
    delete(fix)
    
    % generate 2D white noise
    wn = rand(500); 
    
    % generate random X and Y coordinated for target position 
    target_x = randi([100 400]); % random x coordinate
    target_y = randi([100 400]); % random y coordinate

    % display the white noise (in gray colorscale)
    imagesc(wn) 
    colormap(gray)

    % if it is a targetpresent trial, add target to the image
    if trials_rnd(i) == 1
        text(target_x,target_y, 'O', 'FontSize', target_size, ...
            'Color', [target_int target_int target_int])
    end
    
    % pause 500ms
    pause(0.5)
    
    % clear the axis
    cla

    % prompt for an answer
    prompt = text(250, 250, 'Did you see a circle? (1 = Yes, 0 = No)', 'HorizontalAlignment', 'center', 'Fontsize', 30);
    
    % gather participant's key press and store it in response variable
    waitforbuttonpress % wait until user presses a key
    x = get(gcf,'CurrentCharacter'); % record pressed key
    responses(i) = str2double(x); % save pressed key as a number

    % delete the text prompt
    delete(prompt)
    
    % pause 200 ms
    pause(.2)

% end the for loop
end


%% ANALYSIS

nH = 0; % hit rate
nF = 0; % false alarm rate

% # of hits and false alarms (loop and if/else calculation)
for j = 1:length(trials_rnd)
    
    if trials_rnd(j) == 1
        if responses(j) == 1
        
            nH = nH + 1;
        end
        
    elseif trials_rnd(j) == 0
        if responses(j) == 1
            
            nF = nF + 1;
        end
    end
end

% Or a "clever" solution using element-wise operation:
nH = sum(trials_rnd + responses == 2);
nF = sum(trials_rnd - responses == -1);

% create pH (proportion hit) and pF (proportion false alarm) values
pH = nH/n_targets;
pF = nF/n_targets;

% calculate and display d', criterion, and proportion correct
% With Palamedes:
palamedes_dir = '/Users/tamarabgreco/Documents/MATLAB/psyc-353/tutorials/Palamedes1_10_11/Palamedes';
addpath(palamedes_dir)

[dp, C, lnB, Pc] = PAL_SDT_1AFC_PHFtoDP([pH pF]);

% Or mannualy: 
dprime = norminv(pH) - norminv(pF);
c = -1/2 * (norminv(pH) + norminv(pF));

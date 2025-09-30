name = "Tamara Brissette Greco";
student_id = 261182266;

clear, clc

%% Shade discrimination task

clear, clc, close all % clear terminal + close windows

%% task parameters

n_reps = 2; % each constrast lvl repeated twice
baseline = 0.4; % color ref for bg/baseline brightness
ref_contr = 0.1; % reference contrast (ex. 10% light of baseline)

% repetition matrix, # row, # of reps of baseline
bg_tone = repmat(baseline,1,3); 

% slightly lighter shade of baseline
ref_tone = bg_tone + baseline * ref_contr;

% list of each iteration where contrasts increase with + ref_contr
contrasts = [.0025 .005 .01 .02 .04 .08 .16] + ref_contr; 
% order of trials with rep max with 1 row and repeats #n_reps
trials = repmat(contrasts, 1, n_reps);
% trial order must be random
trials_random = randsample(trials, length(trials));

% response array to track
resp = nan(1, length(trials_random)); % nan array 1 row with len trials_rnd

% initiate correct array
corr = nan(1, length(trials));

% initialize figure for task
figure(1), clf, hold on
% get cur figure
set(gcf, 'Color', bg_tone, 'Position', [400, 120, 1000, 800]); % horizontal, vertical, height, width
% get cur axi, put color to same as background to "mask"
set(gca, 'Color', bg_tone, 'xlim', [-2 2], 'ylim', [-1 1]);
axis off % removes axis

% two invisible circles
% +,o,- are markers for plots w/o datapoints
left = plot(-1,0,'o', 'MarkerSize', 150, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', bg_tone);
right = plot(1,0,'o', 'MarkerSize', 150,'MarkerEdgeColor', 'none', 'MarkerFaceColor', bg_tone);

%% start the task

for trial = 1:length(trials)
    % determine location of target circle left/right
    s = randi([1 2]);

    % stimulus = bg + contrast * bg
    target_shade = baseline + trials_random(trial) * baseline; % target contrast
    target_tone = repmat(target_shade, 1, 3); % turn into RGB value

    % change brightness depending on s
    if s == 1 % left
        set(right, 'MarkerFaceColor', ref_tone) % set right markerfacecolor as ref tone
        set(left, 'MarkerFaceColor', target_tone), shg
    else
        set(left, 'MarkerFaceColor', ref_tone)
        set(right, 'MarkerFaceColor', target_tone), shg
    end
    % puts input into response array
    resp(trial) = input("Which circle is lighter? (1/2): "); 

    % if participant is correct (checks array)
    if resp(trial) == s
        disp(['Correct! ' num2str(s) ' was brighter.'])
        corr(trial) = 1;
    else
        disp(['Incorrect.. ' num2str(s) ' was brighter.'])
        corr(trial) = 0;
    end
    % turns off the circles for a second
    set(left, 'MarkerFaceColor', bg_tone)
    set(right, 'MarkerFaceColor', bg_tone)

    pause(1)
    clc
    
end

%% results

correct = 0;
for i = 1:length(corr)
    if corr(i) == 1
        correct = correct + 1;
    else
        continue
    end
end

disp(['Score: ' num2str(round(((correct/length(corr))*100),2)) '% correct'])


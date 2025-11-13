name = "Tamara Brissette Greco";
student_id = 261182266;

%% Assessment of speech reception thresholds (SRTs)
% This code uses an Up/Down method to assess speech perception in noise

% Dependencies:
% - mix_together.m (function to add white noise to sound)
% - sound files from the CRM database (crm folder)

% The stimuli are spoken sentences of the form 
% "Ready [Callsign] go to [Color] [Number] now".
% The specific Callsign, Color, and Number are
% specified by the file name (see CRM Info text file).

% This experiment asks participants to select which number and color they
% heard, and dynamically changes the noise based on correct/incorrect
% answers

% Recordings by the Laboratory for Auditory Brain Science and Neuroengeneering, University of Washington 
% https://github.com/LABSN/expyfun-data 
% For more information see Bolia, R.S.; Nelson, W.T.; Ericson, M.A.; Simpson, B.D. (2000). 
%    A speech corpus for multitalker communications research.  J. Acoust. Soc. Am. 107, 1065 (2000).

clear, clc
close all

palamedes_dir = '/Users/tamarabgreco/Documents/MATLAB/psyc-353/tutorials/Palamedes1_10_11/Palamedes';
addpath(palamedes_dir)
%% Set up the staircase procedure (using Palamedes)
% increase/decrease (stepsize) ratio by 1
UD = PAL_AMUD_setupUD('up',1,'down',2, 'stepsizeup',1,'stepsizedown',1, ...
    'stopCriterion','reversals','stopRule',6,'startValue',0);

%% Initialize the figure and figure settings
figure(1),clf

set(gcf, 'Color',[.5 .5 .5], 'Units','Normal','OuterPosition',[0 0 1 1], ...
    'Toolbar', 'none', 'Menu', 'none')
set(gca, 'xlim',[.5 8.5], 'ylim', [.5 4.5]), axis off


% Prepare response grid
colors = ["blue","red"];
numbers = 1:4;

%% Run experiment

while ~UD.stop

    %generate random file ID (random wav)
    callsign = randi(4);
    color = randi(2);
    number = randi(4);

    % creating random ID
    fileID = ['0',num2str(callsign-1),'0',num2str(color-1),'0',num2str(number-1),'.wav'];

    filename = ['crm/' fileID];

    % read file (sampling rate & frequency reading)
    [x, fs] = audioread(filename);

    % create whitenoise of same length
    wn = randn(length(x),1);
    wn = wn/max(abs(wn));

    % add noise at signal to ratio based on UD.xCurrent (current trial)
    SNR = UD.xCurrent;
    xn = mix_together(x,wn, SNR); % sounds and noise ratio mixed

    % start trial presentation
    fixation = text(4.5, 2.5, '+', 'HorizontalAlignment','center','FontSize',50);
    pause(0.7)

    % play mixture
    sound(xn, fs)
    pause(length(xn)/fs)

    % update screen to show response grid
    delete(fixation) % remove fixation cross

    for c = 1:length(colors)
        for n = numbers
            text(n+2, c+1, num2str(n), 'FontSize', 50, 'Color', colors(c), 'HorizontalAlignment','center', 'VerticalAlignment', 'middle')
        end
    end
    
    % participant response click
    resp = round(ginput(1)); % grid input: takes first click

    % make sure click is within bounds
    %while resp(1)< 1 || resp(1) > 4 || resp(2) < 1 || resp(2) >2
    while resp(1)< 3 || resp(1) > 6 || resp(2) < 2 || resp(2) >3
        resp = round(ginput(1)) ;
    end

    % clear axis (get rid of response grid)
    cla

    % if coords matcg the stimuli's color & number

    %disp(['x = ', num2str(resp(1)), ' y = ', num2str(resp(2)),'number: ', num2str(number), ' color: ', num2str(color)])
    if resp(1)-2  == number && resp(2)-1 == color
        c = 1;
       % disp("Here")
    else
        c = 0;
    end
    
    UD = PAL_AMUD_updateUD(UD,c);
end
close

% Display results
threshold = PAL_AMUD_analyzeUD(UD, 'reversals', 6);
disp(['Your speech reception threshold is ', num2str(round(threshold,2)),' dB.']);

save('SRT_data_small.mat')


%% Plot Staircase
load('SRT_data_small.mat')
figure(2), clf
plot(UD.x, '-r', 'LineWidth', 3)
xlabel('Trial #'), ylabel('SNR (dB)')
hold on
plot(get(gca, 'xlim'), [threshold threshold], '--k')

savefig('SRT_adaptive_results_1.fig')
%% Adaptive method to assess pitch discrimination thresholds using Palamedes
% up-down method

palamedes_dir = '/Users/tamarabgreco/Documents/MATLAB/psyc-353/tutorials/Palamedes1_10_11/Palamedes';
addpath(palamedes_dir)

clear, clc, close all

%% Part 1: Defining function for tone generation

% inline function to determine frequency of tone given a certain difference (in
% cents) - n - from another tone with frequency x
my_freq = @(x,n) x*2^(n/1200); % func def

% and the complementary:
diff_in_cents = @(f1,f2) 1200 * log2(f2/f1);

% inline function to create pure tone (A = amplitude; f = frequency; t =
% time vector)
my_tone = @(A,f,t) A*sin(2*pi*f*t);

%% Creating sounds demo

% Amplitude
A = .98;

% Frequency of tone1 in Hz
f1 = 300; 
f2 = my_freq(f1, 1000);

% Length of the tones in seconds
dur = 0.4;

% sampling rate
fs = 44100;

% time vector
t = 0:1/fs:dur;

% create tones 
tone1 = my_tone(A, f1, t);
tone2 = my_tone(A, f2, t);

% play sounds
sound(tone1, fs)

pause(1)

sound(tone2, fs)

% plot sine waves
figure(1), clf
set(gcf, 'Position', [400 400 1300 600])

subplot(211)
plot(t, tone1, 'g', 'linew', 2)

subplot(212)
plot(t, tone2, 'r', 'linew', 2)

%% Sound parameters for experiment

amp = 0.3; % amplitude

fs = 44100; % sampling rate

duration = 0.3; % duration of the tone

freq = 500; % frequency (pitch)

time = 0:1/fs:duration; % translate sampling rate and duration into actual time points

ref_tone = my_tone(amp, freq, time); %  = amp * sin(2*pi*freq*values);


%% Up/Down adaptive 2AFC pitch discrimination test
% adapt difficulty to the individual to see their respective threshold

% set up experiment using PAL_AMUD_setupUD
UD = PAL_AMUD_setupUD('up', 1, 'down',3,'stepsizeup',4,'stepsizedown', 4, ...
    'stopCriterion','reversals','stopRule',12,'startvalue',40,'xMax',100,'xMin',1);

% run the adaptive test

while ~UD.stop
    % Present trial here at stimulus intensity UD.xCurrent and collect
    % responses

    targ_freq = my_freq(freq, UD.xCurrent);
    targ_tone = my_tone(amp, targ_freq, time);

    clc
    disp('Please Listen')
    pause(0.7)

    order = randi(2); % pick num between 1-2

    if order == 1
        sound(targ_tone, fs)
        pause(0.8)
        sound(ref_tone,fs)
    elseif order == 2
        sound(ref_tone,fs)
        pause(0.8)
        sound(targ_tone,fs)
    end

    clc
    pause(0.5)

    % validity check

    valid = false;
    while ~valid
        str_answer = input('Which tone is higher? 1 or 2: ','s');
        if strcmp(str_answer, '1') || strcmp(str_answer,'2')
            valid = true;
            answer = str2double(str_answer);
        else
            clc
            fprintf('Invalid input. Please put in 1 or 2');
        end
    end

    if answer == order
        correct = 1;
    else
        correct=0;
    end
    % Update UD structure based on prior response
    UD = PAL_AMUD_updateUD(UD, correct);
end

save('pitch_results_1.mat')

%% Display results
load('hw7_BrissetteGreco2.mat')

threshold = PAL_AMUD_analyzeUD(UD, 'reversals', 8);
 
fprintf('Your threshold is %2.2f ct \n', threshold);
disp(['Your threshold at ' num2str(freq) ' Hz is ' num2str(threshold) ' ct.'])
 
figure(1), clf

plot(UD.x, 'LineWidth', 2)
 
grid minor
hold on
 
plot([0 length(UD.x)], [threshold threshold], 'LineWidth', 2)
 
xlabel('Trial #')
ylabel('Delta f')
 
savefig('tone_adaptive_UD')

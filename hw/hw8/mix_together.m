function [xn,resc] = mix_together(x,n,SNR)
% mix_together function: mixes noise with signal for a given SNR

% inline function for calculating RMS
RMS = @(z) sqrt(mean(z.^2));

% inline function for converting SNR to RMS
snr2rms = @(z) 10^(z/20)*RMS(n); 

% calculate target RMS of signal 
target_RMS = snr2rms(SNR);
% and modify signal to target RMS
x = x / RMS(x) * target_RMS;

% mix
xn = x + n;

resc = 0; % not rescaled
% rescale (if necessary)
m = max(abs(xn));
if m>1
    xn = .98 * xn/m;
    %warning(sprintf('xn was rescaled (max = %f)', m));
    resc = 1; % rescaled
end

% write signal-noise-mix ('sn_')
%wavwrite(xn,fs,'tmp.wav')
    
end
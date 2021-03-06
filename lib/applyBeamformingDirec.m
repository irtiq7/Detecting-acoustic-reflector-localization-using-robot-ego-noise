function [xOut] = applyBeamformingDirec(setup, signals, dMic, DOA, gamma)

nChannels = size(signals.observ,2);
x = signals.observ'; % input signal in matrix form [nChannels x Time], contains direct-path
% x = signals.observRefl'; % input signal in matrix form [nChannels x Time], no direct-path


%% Initialize parameters for spectral processing

% Divide the microphones output with overlap frames with a frame width of
% 882 ( 20ms with a sampling rate of 44.1KHz)
len=floor(20 * setup.signal.sampFreq / 1000);
if rem(len, 2) == 1
    len=len+1;
end

overlap = 0.50; % 50% window overlap of frame size
len1 = floor(len * overlap);
len2 = len - len1;

nFrames = floor(size(x, 2)/len2)-floor(len/len2);
xFinal = zeros(1, nFrames*len2+len1);

% Hamming window
% win = hamming(len)'; %define window
% win2D = repmat(win, nChannels, 1);

% Modified Discrete Cosine Transform
win = sin((pi/(2*len))*(linspace(0,(2*len)-1,(len))+1/2));
win2D = repmat(win, nChannels, 1);

% hanning window


nFft =len;
f = linspace(0,setup.signal.sampFreq,nFft);


%% Initialize covariance matrix
segment =10; % Use the first 10 segments to estimate noise spectrum
noiseConv = calNoiseConv(x, nChannels, nFft, win2D, segment, len, len2);


%% Diagnal Loading
% gamma = 0.1;
noiseConvDiag = diagLoading(noiseConv, gamma);
%% Generate Beamformer
bf = zeros(nChannels, nFft);
angTheta = 90;
bf = mvdrFF(setup,nChannels, dMic, DOA, f, noiseConvDiag, angTheta);


%% Applying beamforming to the observed Signal
k = 1;
for n = 1:nFrames
    xk = win2D.*x(:,k:k+len-1);
    spec = fft(xk, nFft, 2);
    
    specBF = sum(bf.*spec,1);
    xInv = ifft(specBF, nFft);
    xInv = real(xInv);
    
    % Overlap and add using windowing
    xFinal(k:k+len-1) = xFinal(k:k+len-1)+win.*xInv;
    
    k = k+len2;
end
   xOut =xFinal;
end
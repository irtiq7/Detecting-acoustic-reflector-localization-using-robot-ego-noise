% Calculate Noise Covariance for point-source-white-noise
% INPUT
% x                     - Input signal in time domain
% nChannel              - number of channels
% nFft                  - FFT length which is calculated based on the sampling frequency
% win2D                 - vector containing window size
% segment               - Use the first few segments to estimate noise spectrum
% frameWidth            - calculate the frame width based on the sampling frequency
% NoOverlapFrameWidth   - Frames width used move the observation window

function noiseConv = calNoiseConvPSWN(x,nChannels, nFft, win2D, segment, frameWidth, NoOverlapFrameWidth)
    noiseMean = zeros(nChannels, nFft);
    noiseConv = zeros(nChannels, nChannels, nFft);
    j = 1;
    for k = 1:segment % use first 10 segments to estimate noise spectrum
        noiseSpec = fft(win2D.* x(:,j:j+frameWidth-1), nFft, 2);
        noiseMean = noiseMean + noiseSpec;
        for freqIdx = 1:nFft
            noiseConv(:,:,freqIdx) = noiseConv(:,:,freqIdx)+(noiseSpec(:,freqIdx)*noiseSpec(:,freqIdx)');
        end
        j = j+NoOverlapFrameWidth;
    end
    noiseConv = noiseConv/segment;
end
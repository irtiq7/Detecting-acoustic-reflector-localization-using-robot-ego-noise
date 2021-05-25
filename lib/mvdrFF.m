% mvdrFF - Minimum Variance Distortionless Response Beamformer
% Free-field steering vector
% setup     - structure containing signals, speed of Sound, etc
% nChannels - number of channels of the input signal
% dMic      - distance between the microphones
% DOA       - Direction of Arrival of the reflections
% freqVec   - number of frequency bins
% noiseConv - Noise covariance matrix. Calculated by noiseConv function

function H_mvdr = mvdrFF(setup, nChannels, dMic, DOA, freqVec, noiseConv, angTheta)
    c = setup.room.soundSpeed;
    phi = DOA * pi/180;
    angTheta = angTheta * pi/180;
    R = setup.array.micRadius;
    d = exp( -1j * 2*pi * (freqVec)./c * R * sin(angTheta).* cos(phi - (2*pi.*[0:nChannels-1]'./nChannels)));
%     d = exp(-1j*[0:nChannels-1]'*2*pi*freqVec*cos(phi)*R/c)./nChannels; % steering vector
    H_mvdr = zeros(nChannels, length(freqVec));
    for f = 1:length(freqVec)
        noiseConvInv = pinv(noiseConv(:,:,f));
        df = d(:,f);
        H_mvdr(:,f) = (noiseConvInv*df)/(df'*noiseConvInv*df);
    end
end
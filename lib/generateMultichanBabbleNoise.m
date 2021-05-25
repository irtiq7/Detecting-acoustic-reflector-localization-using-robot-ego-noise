function [ multichannelBabble ] = generateMultichanBabbleNoise(...
    nSamples,nSensors,micPos,speedOfSound,noiseField,diffNoiseString)

nFft = 256;

[singleChannelData,samplingFreq] = audioread(diffNoiseString);
interval=1:nSamples*nSensors;
randStartNdx=randi(nSamples*nSensors,1);
singleChannelData=singleChannelData(randStartNdx:randStartNdx+length(interval)-1);

if (nSamples*nSensors)>length(singleChannelData)
    error([...
    '[nSamples]x[nSensors] exceeds the length of the noise signal. ',...
    'Maximum length with ',num2str(nSensors),' sensors is: ',...
    num2str(floor(length(singleChannelData)/nSensors))]);
end

singleChannelData = singleChannelData - mean(singleChannelData);
babble = zeros(nSamples,nSensors);
for iSensors=1:nSensors
    babble(:,iSensors) = singleChannelData((iSensors-1)*nSamples+1:...
        iSensors*nSamples);
end

%% Generate matrix with desired spatial coherence
ww = 2*pi*samplingFreq*(0:nFft/2)/nFft;
desiredCoherence = zeros(nSensors,nSensors,nFft/2+1);
for p = 1:nSensors
    for q = 1:nSensors
        if p == q
            desiredCoherence(p,q,:) = ones(1,1,nFft/2+1);
        else
            sensorDistance=norm(micPos(p,:)-micPos(q,:));
            switch lower(noiseField)
                case 'spherical'
%                     desiredCoherence(p,q,:) = sinc(ww*abs(p-q)*...
%                         sensorDistance/(speedOfSound*pi));
                    desiredCoherence(p,q,:) = sinc(ww*...
                    sensorDistance/(speedOfSound*pi));
                    
                case 'cylindrical'
%                     desiredCoherence(p,q,:) = bessel(0,ww*abs(p-q)*...
%                         sensorDistance/speedOfSound);
                    desiredCoherence(p,q,:) = besselj(0,ww*...
                        sensorDistance/speedOfSound);
                    
                otherwise
                    error('Unknown noise field.');
            end
        end
    end
end

%% Generate sensor signals with desired spatial coherence
multichannelBabble = mix_signals(babble,desiredCoherence,'cholesky');

end

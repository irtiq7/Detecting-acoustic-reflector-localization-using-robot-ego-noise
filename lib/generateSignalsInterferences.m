function signals=generateSignalsInterferences(rirs,signals,setup, noiseSel,SNR)
%     rng(0);
    signals.clean=[randn(setup.signal.lengthBurst,1);...
        zeros(setup.signal.lengthSignal-setup.signal.lengthBurst,1)];
    interference= audioread(setup.signal.diffNoiseStr);
    interval=1:setup.signal.lengthSignal;
    randStartNdx=randi(setup.signal.lengthSignal*setup.array.micNumber,1);
    signals.interference.source1 = interference(randStartNdx:randStartNdx+length(interval)-1);
    randStartNdx=randi(setup.signal.lengthSignal*setup.array.micNumber,1);
    signals.interference.source2 = interference(randStartNdx:randStartNdx+length(interval)-1);
    randStartNdx=randi(setup.signal.lengthSignal*setup.array.micNumber,1);
    signals.interference.source3 = interference(randStartNdx:randStartNdx+length(interval)-1);
    randStartNdx=randi(setup.signal.lengthSignal*setup.array.micNumber,1);
    signals.interference.source4 = interference(randStartNdx:randStartNdx+length(interval)-1);
%     rng('shuffle');

    signals.direct=fftfilt(rirs.direct',signals.clean);
    signals.received=fftfilt(rirs.all',signals.clean);
    signals.reflec=fftfilt(rirs.reflec',signals.clean);
    
    signals.rotorReceived1=fftfilt(rirs.all',signals.interference.source1);
    signals.rotorReceived2=fftfilt(rirs.all',signals.interference.source2);
    signals.rotorReceived3=fftfilt(rirs.all',signals.interference.source3);
    signals.rotorReceived4=fftfilt(rirs.all',signals.interference.source4);

%   Add sensor noise
    for kk=1:setup.array.micNumber
        signals.noise(:,kk)=sqrt(var(signals.received(:,kk))...
            /10^(setup.signal.snr/10))*randn(length(signals.received(:,kk)),1);
    end
    
    switch noiseSel
        case 1
            %% DIFFUSE Spherical
            signals.diffNoise=generateMultichanBabbleNoise(setup.signal.lengthSignal,...
                setup.array.micNumber,...
                setup.array.micPos,...
                setup.room.soundSpeed,...
                'spherical',...
                setup.signal.diffNoiseStr);

            for kk=1:setup.array.micNumber
                signals.diffNoise(:,kk)=sqrt(var(signals.received(:,kk))...
                    /10^(setup.signal.sdnr/10))*signals.diffNoise(:,kk)...
                    /sqrt(var(signals.diffNoise(:,kk)));
            end
                            %%    
                signals.observ=signals.received+signals.noise+signals.diffNoise;
                signals.observRefl=signals.reflec+signals.noise+signals.diffNoise;
                signals.bgNoise = signals.noise+signals.diffNoise;
        case 2
                %% DIFFUSE cylindrical
            signals.diffNoise=generateMultichanBabbleNoise(setup.signal.lengthSignal,...
                setup.array.micNumber,...
                setup.array.micPos,...
                setup.room.soundSpeed,...
                'cylindrical',...
                setup.signal.diffNoiseStr);

            for kk=1:setup.array.micNumber
                signals.diffNoise(:,kk)=sqrt(var(signals.received(:,kk))...
                    /10^(setup.signal.sdnr/10))*signals.diffNoise(:,kk)...
                    /sqrt(var(signals.diffNoise(:,kk)));
            end
            signals.observ=signals.received+signals.noise+signals.diffNoise;
            signals.observRefl=signals.reflec+signals.noise+signals.diffNoise;
%                 signals.observ=signals.received+signals.rotorReceived1+signals.rotorReceived2...
%                     +signals.rotorReceived3+signals.rotorReceived4+signals.noise+signals.diffNoise;
%                 signals.observRefl=signals.reflec+signals.rotorReceived1+signals.rotorReceived2...
%                     +signals.rotorReceived3+signals.rotorReceived4+signals.noise+signals.diffNoise;
%                 signals.bgNoise = signals.rotorReceived1+signals.rotorReceived2...
%                     +signals.rotorReceived3+signals.rotorReceived4+signals.noise+signals.diffNoise;
             signals.bgNoise = signals.noise+signals.diffNoise;
        case 3
            signals.whiteNoise = awgn(signals.received, SNR);
            for kk=1:setup.array.micNumber
                signals.whiteNoise(:,kk)=sqrt(var(signals.received(:,kk))...
                    /10^(setup.signal.sdnr/10))*signals.whiteNoise(:,kk)...
                    /sqrt(var(signals.whiteNoise(:,kk)));
            end
                signals.observ=signals.received+signals.noise;
                signals.observRefl=signals.reflec+signals.noise;
                signals.bgNoise = signals.noise;
    end
end

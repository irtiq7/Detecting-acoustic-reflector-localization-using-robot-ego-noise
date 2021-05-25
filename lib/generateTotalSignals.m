function signals=generateTotalSignals(rirs, rirsRotor,signals,setup, n)
%     rng(0);
    signals.clean=[randn(setup.signal.lengthBurst,1);...
        zeros(setup.signal.lengthSignal-setup.signal.lengthBurst,1)];
%     rng('shuffle');
    signals.Rotor = audioread('allMotors_70_mic1.wav');
    signals.Rotor=signals.Rotor(1:length(signals.clean));
    
%   Convolve room impulse response with clean signal
    signals.direct=fftfilt(rirs.direct',signals.clean);
    signals.received=fftfilt(rirs.all',signals.clean);
    signals.reflec=fftfilt(rirs.reflec',signals.clean);
% %   Add sensor noise
%     for kk=1:setup.array.micNumber
%         signals.noise(:,kk)=sqrt(var(signals.received(:,kk))...
%             /10^(setup.signal.snr/10))*randn(length(signals.received(:,kk)),1);
%     end
    
%   Convolve room impulse reponse with rotor noise
    signals.rotorDirect=fftfilt(rirsRotor.direct',signals.Rotor);
    signals.rotorReceived=fftfilt(rirsRotor.all',signals.Rotor);
    signals.rotorReflec=fftfilt(rirsRotor.reflec',signals.Rotor);
%   Add sensor noise
    for kk=1:setup.array.micNumber
        signals.noise(:,kk)=sqrt(var(signals.received(:,kk)+signals.rotorReceived(:,kk))...
            /10^(setup.signal.snr/10))*randn(length(signals.received(:,kk)+signals.rotorReceived(:,kk)),1);
    end
    
%   SWITCH BETWEEN SENSOR NOISE ONLY or SENSOR NOISE + BABBLE NOISE
    switch n
        case 1
        %% ONLY SENSOR NOISE
            signals.observ=signals.received+signals.rotorReceived+signals.noise;
            signals.observRefl=signals.reflec+signals.rotorReflec+signals.noise;
        case 2
        %% DIFFUSE NOISE
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
            signals.observ=signals.received+signals.rotorReceived+signals.noise+signals.diffNoise;
            signals.observRefl=signals.reflec+signals.rotorReflec+signals.noise+signals.diffNoise;
    end

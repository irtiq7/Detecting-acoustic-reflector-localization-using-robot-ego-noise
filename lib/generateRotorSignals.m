function signals=generateRotorSignals(rirs, rotorNoise,setup, noiseSel,SNR)
%     rng(0);
%     signals.clean=[randn(setup.signal.lengthBurst,1);...
%         zeros(setup.signal.lengthSignal-setup.signal.lengthBurst,1)];
%     rng('shuffle');

    signals.direct=fftfilt(rirs.direct',rotorNoise);
    signals.received=fftfilt(rirs.all',rotorNoise);
    signals.reflec=fftfilt(rirs.reflec',rotorNoise);
%   Add sensor noise
    for kk=1:setup.array.micNumber
        signals.noise(:,kk)=sqrt(var(signals.received(:,kk))...
            /10^(setup.signal.snr/10))*randn(length(signals.received(:,kk)),1);
    end
    
    switch noiseSel
        case 1
            %% DIFFUSE Spherical
            signals.diffNoise=generateMultichanBabbleNoise(length(rotorNoise),...
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
        case 2
                %% DIFFUSE cylindrical
            signals.diffNoise=generateMultichanBabbleNoise(length(rotorNoise),...
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
        case 3
%             signals.whiteNoise = awgn(signals.received, SNR,'measured');
%             for kk=1:setup.array.micNumber
%                 signals.whiteNoise(:,kk)=sqrt(var(signals.received(:,kk))...
%                     /10^(setup.signal.sdnr/10))*signals.whiteNoise(:,kk)...
%                     /sqrt(var(signals.whiteNoise(:,kk)));
%             end
%                 signals.observ=signals.received+signals.noise+signals.whiteNoise; %direct-path
%                 signals.observRefl=signals.reflec+signals.noise+signals.whiteNoise;
            for kk=1:setup.array.micNumber
                signals.observ(:,kk)=awgn(signals.received(:,kk),SNR,'measured');
                signals.whiteNoise(:,kk)=signals.observ(:,kk)-signals.received(:,kk);
                signals.observRefl(:,kk)=signals.reflec(:,kk)+signals.whiteNoise(:,kk);
            end
    end
end

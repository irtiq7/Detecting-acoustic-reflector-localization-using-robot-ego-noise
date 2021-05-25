function [estimates] = peakPeaking(signals,setup,estimates)

    toaInterval=round((2*[setup.EM.minimumDistance;setup.EM.maximumDistance]...
        -setup.array.micRadius)/setup.room.soundSpeed*setup.signal.sampFreq);

    windowNdx=toaInterval(1):(toaInterval(2)+setup.signal.lengthBurst);
    lengthWindow=length(windowNdx);    

%   Single channel Peak picking
    signalCleanFft = fft(signals.clean(windowNdx,1),setup.fftLength);
    signalDirectFft = fft(signals.direct, setup.fftLength);
    signalReceivedFft = fft(signals.reflec, setup.fftLength);
    signalNoiseFft = fft(signals.noise,setup.fftLength);
    signalObservFft = fft(signals.observ(windowNdx,1), setup.fftLength);
    signalObservReflFft = fft(signals.observRefl(windowNdx,1), setup.fftLength);
    
    signalObservReflFft = signalObservReflFft(:,1);
    signalObservFft = signalObservFft(:,1);
    
    pks = zeros(setup.EM.nRefl,1);
    locs = zeros(setup.EM.nRefl,1);
    
    if setup.EM.directPathFlag
        rirEstFft=signalObservFft./signalCleanFft;
        rirEst=ifft(rirEstFft);
        [tempPks,tempLocs] = findpeaks(rirEst,'SortStr','descend');
        for ii=1:1:setup.EM.nRefl
            pks(ii) =tempPks(ii);
            locs(ii) = tempLocs(ii);
        end   
    else
        rirEstFft=signalObservReflFft./signalCleanFft;
        rirEst=ifft(rirEstFft);
        [tempPks,tempLocs] = findpeaks(rirEst,'SortStr','descend');
        for ii=1:1:setup.EM.nRefl
            pks(ii) =tempPks(ii);
            locs(ii) = tempLocs(ii);
        end
    end
        estimates.peakPicking_oneCh.toa = locs;
        estimates.peakPicking_oneCh.gain = pks;
%         plot(rirEst)
end
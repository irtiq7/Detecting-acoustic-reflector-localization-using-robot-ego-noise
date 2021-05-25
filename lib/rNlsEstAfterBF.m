function [estimates, costFunctionDelay2]=rNlsEstAfterBF(signals, setup,xOut)

toaInterval=round((2*[setup.EM.minimumDistance;setup.EM.maximumDistance]...
    -setup.array.micRadius)/setup.room.soundSpeed*setup.signal.sampFreq);

windowNdx=toaInterval(1):(toaInterval(2)+setup.signal.lengthBurst);
lengthWindow=length(windowNdx);

grids.toa=toaInterval(1):toaInterval(2);

signals.signalCleanFft = fft(signals.clean,setup.fftLength);
signals.signalDirectFft = fft(signals.direct, setup.fftLength);
signals.signalReceivedFft = fft(signals.reflec, setup.fftLength);
signals.signalNoiseFft = fft(signals.noise,setup.fftLength);
signals.signalObservFft = fft(signals.observ, setup.fftLength);
signals.signalObservReflFft = fft(signals.observRefl, setup.fftLength);

% signals after BF
signals.signalObservReflFft = fft(xOut, setup.fftLength);

signals.signalObservReflFft = signals.signalObservReflFft;
signals.signalObservFft = signals.signalObservFft;
[l,n] = size(signals.signalObservReflFft);
response = zeros(setup.fftLength,setup.EM.nRefl,n);
delayEst = zeros(setup.EM.nRefl,n);
gainEst = zeros(setup.EM.nRefl,n);

for gg = 1:n
    
    response_sim = 0;
    
    delayEst_control_vec = zeros(setup.EM.nRefl,1);
    delayEst_control_vec1 = zeros(setup.EM.nRefl,1);
    
    gainEst_control_vec = zeros(setup.EM.nRefl,1);
    gainEst_control_vec1 = zeros(setup.EM.nRefl,1);

    control_vector = ones(setup.EM.nRefl,1);
                % control_vector(1)=0;
    control_vector1 = ones(setup.EM.nRefl,1);

    convergence_array = zeros(length(signals.signalObservReflFft),1);
    delayEst_control_vec(1) =1;
    gainEst_control_vec(1) =1;
    delayEst_control_vec1(1) =1;
    gainEst_control_vec1(1) =1;
    for rr=1:1:setup.EM.nRefl
        i=1;
    %     Step 1 : calculating first-order reflection Y2
    %     while 1
        response_sim = response(:,:,gg)*control_vector1;

        [gainEst(rr,gg),~,response(:,rr,gg),costFunctionDelay1,delayEst(rr,gg),costFunctionDelay2]=...
            delayEstimationFIR_filter(signals.signalObservReflFft, signals.signalCleanFft,response_sim,grids.toa);

    %         delayEst
    %         gainEst2
        control_vector1 = circshift(control_vector1,1);
        delayEst_control_vec1 = circshift(delayEst_control_vec1,1);
        gainEst_control_vec1 = circshift(gainEst_control_vec1,1);      

    %   RELAX algorithm ----> nothing relaxed about it
        if rr>1
            while 1
                for mm=rr:-1:1
                    control_vector = ones(setup.EM.nRefl,1);
                    control_vector(mm)=0;
                    response_sim = response(:,:,gg)*control_vector;
                    delayEst_value = delayEst'*delayEst_control_vec;

                    [gainEst(rr,gg),~,response(:,rr,gg),costFunctionDelay1,delayEst(rr,gg),costFunctionDelay2]=...
                             delayEstimationFIR_filter(signals.signalObservReflFft, signals.signalCleanFft,response_sim,grids.toa);
                end
                convergence_array(i) = norm(signals.signalObservReflFft - response_sim.*signals.signalCleanFft);
                i=i+1;
                if i>2
                    if ((convergence_array(i-1)-convergence_array(i-2)).^2<setup.nlsEst.epsilon)
                        break
                    end
                end
            end 
        end
    end
    estimates.rNlsEstBF.toa = delayEst;
    estimates.rNlsEstBF.gain = gainEst;
end
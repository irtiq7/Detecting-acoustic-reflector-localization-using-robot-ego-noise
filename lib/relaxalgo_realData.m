function [gainEst,delayEst,response,costFunctionDelay2]=relaxalgo(setup,signals)

[l,n] = size(signals.signalRealDataFft);
response = zeros(setup.signal.nfft,setup.nlsEst.R-1,n);
delayEst = zeros(setup.nlsEst.R-1,n);
gainEst = zeros(setup.nlsEst.R-1,n);

for gg = 1:n
    
    response_sim = 0;

    
    delayEst_control_vec = zeros(setup.nlsEst.R-1,1);
    delayEst_control_vec1 = zeros(setup.nlsEst.R-1,1);


    
    gainEst_control_vec = zeros(setup.nlsEst.R-1,1);
    gainEst_control_vec1 = zeros(setup.nlsEst.R-1,1);

    control_vector = ones(setup.nlsEst.R-1,1);
                % control_vector(1)=0;
    control_vector1 = ones(setup.nlsEst.R-1,1);

    convergence_array = zeros(length(signals.signalRealDataFft(:,gg)),1);
    delayEst_control_vec(1) =1;
    gainEst_control_vec(1) =1;
    delayEst_control_vec1(1) =1;
    gainEst_control_vec1(1) =1;
    for rr=1:1:setup.nlsEst.R-1
        i=1;
    %     Step 1 : calculating first-order reflection Y2
    %     while 1
        response_sim = response(:,:,gg)*control_vector1;

        [gainEst(rr,gg),delayEst(rr,gg),response(:,rr,gg),costFunctionDelay2]=...
            delayEstimationFIR_filter(signals.signalRealDataFft(:,gg), signals.signalCleanFft,response_sim,setup.nlsEst.candidateDelays);

    %         delayEst
    %         gainEst2
        control_vector1 = circshift(control_vector1,1);
        delayEst_control_vec1 = circshift(delayEst_control_vec1,1);
        gainEst_control_vec1 = circshift(gainEst_control_vec1,1);      

    %   RELAX algorithm ----> nothing relaxed about it
        if rr>1
            while 1
                for mm=rr:-1:1
                    control_vector = ones(setup.nlsEst.R-1,1);
                    control_vector(mm)=0;
                    response_sim = response(:,:,gg)*control_vector;
                    delayEst_value = delayEst'*delayEst_control_vec;

                    [gainEst(mm,gg),delayEst(mm,gg),response(:,mm,gg),costFunctionDelay2]=...
                             delayEstimationFIR_filter(signals.signalRealDataFft(:,gg), signals.signalCleanFft,response_sim,setup.nlsEst.candidateDelays);
                end
                convergence_array(i) = norm(signals.signalRealDataFft(:,gg) - response_sim.*signals.signalCleanFft);
                i=i+1;
                if i>2
                    if ((convergence_array(i-1)-convergence_array(i-2)).^2<setup.nlsEst.epsilon)
                        break
                    end
                end
            end 
        end
    end
end
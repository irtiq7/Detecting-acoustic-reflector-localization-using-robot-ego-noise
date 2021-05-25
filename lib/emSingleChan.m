function [estimates,costFunction,grids] = emSingleChan(signals,setup)
toaInterval=round((2*[setup.EM.minimumDistance;setup.EM.maximumDistance]...
    -setup.array.micRadius)/setup.room.soundSpeed*setup.signal.sampFreq);

windowNdx=toaInterval(1):(toaInterval(2)+setup.signal.lengthBurst);
lengthWindow=length(windowNdx);

estimates.emOneCh.gain=rand(setup.EM.nRefl,1);
estimates.emOneCh.toa=randi(toaInterval,setup.EM.nRefl,1);

grids.toa=toaInterval(1):toaInterval(2);

for ee=1:setup.EM.nIter
    % E-step
    signalShifted=zeros(lengthWindow,setup.EM.nRefl);
    for kk=1:setup.EM.nRefl
        tempShift=circshift(signals.clean,estimates.emOneCh.toa(kk));
        signalShifted(:,kk)=tempShift(windowNdx);
    end
    
    estimates.emOneCh.reflec=zeros(lengthWindow,setup.EM.nRefl);
    for kk=1:setup.EM.nRefl
        if setup.EM.directPathFlag
            estimates.emOneCh.reflec(:,kk)=estimates.emOneCh.gain(kk)*signalShifted(:,kk)...
                +setup.EM.beta*(signals.observ(windowNdx,1)...
                -signalShifted*estimates.emOneCh.gain);
        else
            estimates.emOneCh.reflec(:,kk)=estimates.emOneCh.gain(kk)*signalShifted(:,kk)...
                +setup.EM.beta*(signals.observRefl(windowNdx,1)...
                -signalShifted*estimates.emOneCh.gain);
        end
    end
    
    % M-step
    costFunction=zeros(length(grids.toa),setup.EM.nRefl);
    for kk=1:setup.EM.nRefl
        for tt=1:length(grids.toa)
            toaCand=grids.toa(tt);
            
            tempShift=circshift(signals.clean,toaCand);
            tempShift=tempShift(windowNdx);
            costFunction(tt,kk)=estimates.emOneCh.reflec(:,kk)'*tempShift;
        end
        
        [~,maxNdx]=max(costFunction(:,kk));
        estimates.emOneCh.toa(kk)=grids.toa(maxNdx);
        tempShift=circshift(signals.clean,estimates.emOneCh.toa(kk));
        tempShift=tempShift(windowNdx);
        estimates.emOneCh.gain(kk)=estimates.emOneCh.reflec(:,kk)'*tempShift...
            /(tempShift'*tempShift);
        
        if setup.EM.plotIterations
            figure(2);
            if setup.EM.nRefl<4
                subplot(1,3,kk);
            else
                subplot(2,3,kk);
            end
            plot(grids.toa,costFunction(:,kk));
            title(['EM iter: ',num2str(ee)]);
            sgtitle('Plot of EM cost functions');
            xlabel('TOA [samples]');
            ylabel('Cost function');
            drawnow;
        end
    end
end


        
end


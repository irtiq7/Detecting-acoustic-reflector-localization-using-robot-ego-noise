function [estimates,costFunction,grids] = emCircArray(signals,setup,estimates)
toaInterval=round((2*[setup.EM.minimumDistance;setup.EM.maximumDistance]...
    -setup.array.micRadius)/setup.room.soundSpeed*setup.signal.sampFreq);

windowNdx=toaInterval(1):(toaInterval(2)+setup.signal.lengthBurst);
lengthWindow=length(windowNdx);


estimates.emUca.gain=rand(setup.EM.nRefl,1);
estimates.emUca.toa=randi(toaInterval,setup.EM.nRefl,1);
estimates.emUca.angle=360*rand(setup.EM.nRefl,1);
estimates.emUca.tdoa=computeTdoas(estimates.emUca.angle,setup);

grids.toa=toaInterval(1):toaInterval(2);
grids.angle=linspace(0,360,180);

for ee=1:setup.EM.nIter

    % E-step
    signalShifted=zeros(lengthWindow,setup.EM.nRefl,setup.array.micNumber);
    for kk=1:setup.EM.nRefl
        for mm=1:setup.array.micNumber
            tempShift=circshift(signals.clean,estimates.emUca.toa(kk)...
                +estimates.emUca.tdoa(mm,kk)); %both tdoa and toa in integers. could be floats and then int after addition
                                                                        % SIGN TDOA!
            signalShifted(:,kk,mm)=tempShift(windowNdx(1):windowNdx(end));
        end
    end
    
    estimates.emUca.reflec=zeros(lengthWindow,setup.EM.nRefl,setup.array.micNumber);
    for kk=1:setup.EM.nRefl
        for mm=1:setup.array.micNumber
            if setup.EM.directPathFlag
                estimates.emUca.reflec(:,kk,mm)=estimates.emUca.gain(kk)*signalShifted(:,kk,mm)...
                    +setup.EM.beta*(signals.observ(windowNdx(1):windowNdx(end),mm)...
                    -signalShifted(:,:,mm)*estimates.emUca.gain);
            else
                estimates.emUca.reflec(:,kk,mm)=estimates.emUca.gain(kk)*signalShifted(:,kk,mm)...
                    +setup.EM.beta*(signals.observRefl(windowNdx(1):windowNdx(end),mm)...
                    -signalShifted(:,:,mm)*estimates.emUca.gain);
            end
        end
    end
    
    % M-step
    costFunction=zeros(length(grids.toa),length(grids.angle),setup.EM.nRefl);
    for kk=1:setup.EM.nRefl
        for aa=1:length(grids.angle)
            angleCand=grids.angle(aa);
            tdoaCand=computeTdoas(angleCand,setup);

            tempReflSum=zeros(lengthWindow,1);
            for mm=1:setup.array.micNumber
                tempReflShift=circshift(estimates.emUca.reflec(:,kk,mm),-tdoaCand(mm));%SIGN TDOA!
                tempReflShift=tempReflShift(1:lengthWindow); %%incex?
                tempReflSum=tempReflSum+tempReflShift;
            end
            
            for tt=1:length(grids.toa)
                toaCand=grids.toa(tt);

                tempSignalShift=circshift(signals.clean,toaCand);
                tempSignalShift=tempSignalShift(windowNdx); %%incex?

                costFunction(tt,aa,kk)=tempReflSum'*tempSignalShift;
            end
        end       
        [costFuncAngle,~]=max(costFunction(:,:,kk));
        [~,angleNdx]=max(costFuncAngle);
        estimates.emUca.angle(kk)=grids.angle(angleNdx);
        estimates.emUca.tdoa(:,kk)=computeTdoas(estimates.emUca.angle(kk),setup);
        
        [costFuncToa,~]=max(costFunction(:,:,kk),[],2);
        [~,toaNdx]=max(costFuncToa);
        estimates.emUca.toa(kk)=grids.toa(toaNdx);
        
        tempReflSum=zeros(lengthWindow,1);
        for mm=1:setup.array.micNumber
            tempReflShift=circshift(estimates.emUca.reflec(:,kk,mm),-estimates.emUca.tdoa(mm,kk));
            tempReflShift=tempReflShift(1:lengthWindow); %%incex?
            tempReflSum=tempReflSum+tempReflShift;
        end
        tempSignalShift=circshift(signals.clean,estimates.emUca.toa(kk));
        tempSignalShift=tempSignalShift(windowNdx); %%incex?
        
        estimates.emUca.gain(kk)=tempReflSum'*tempSignalShift/setup.array.micNumber...
            /(tempSignalShift'*tempSignalShift);
        
        if setup.EM.plotIterations
            h1=figure(1);
            h1.Position=[3.5000 422.5000 988 413];
            h1.Visible='on';
            if setup.EM.nRefl<4
                subplot(1,3,kk);
            else
                subplot(2,3,kk);
            end
            imagesc(grids.angle,grids.toa,squeeze(costFunction(:,:,kk)));
            title(['EM iter: ',num2str(ee)]);
            sgtitle('Figure 4: Plot of EM cost functions');
            xlabel('DOA [deg]');
            ylabel('TOA [samples]');
            drawnow limitrate;
        end
    end
end
end

function estimates=computeUcaCenterToWallDistance(setup,estimates)
    estimates.emUca.distance=estimates.emUca.toa/setup.signal.sampFreq*setup.room.soundSpeed/2 ...
        +(cosd(setup.array.micOffset-estimates.emUca.angle))*setup.array.micRadius;
    
    tempPos=[estimates.emUca.distance.*cosd(estimates.emUca.angle),...
        estimates.emUca.distance.*sind(estimates.emUca.angle)];
    estimates.emUca.wallPos=ones(setup.EM.nRefl,1)*setup.room.sourcePos(:,1:2)...
        +tempPos;
end


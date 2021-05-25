function tdoas=computeTdoas(angle,setup)
    micAngles=setup.array.micOffset+setup.array.micSpacing...
        *(0:(setup.array.micNumber-1))';

    tdoas=zeros(setup.array.micNumber,length(angle));
    for kk=1:setup.array.micNumber
        tdoas(kk,:)=setup.array.micRadius*(cosd(micAngles(1)-angle)...
            -cosd(micAngles(kk)-angle))*setup.signal.sampFreq/setup.room.soundSpeed;
    end
    tdoas=round(tdoas);
end


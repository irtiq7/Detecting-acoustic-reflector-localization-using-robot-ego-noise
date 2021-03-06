function rirsRotor = generateRirsRotor(setup)
% Direct component only
    rirsRotor.direct=rir_generator(setup.room.soundSpeed,setup.signal.sampFreq,...
        setup.room.receivPos,setup.room.rotorPos,setup.room.dimensions,...
        setup.room.T60,setup.rirGen.length,setup.rirGen.micType...
        ,0,3,[]);
% All reflections including the direct path component
    rirsRotor.all=rir_generator(setup.room.soundSpeed,setup.signal.sampFreq,...
        setup.room.receivPos,setup.room.rotorPos,setup.room.dimensions,...
        setup.room.T60,setup.rirGen.length,setup.rirGen.micType...
        ,setup.rirGen.order,2,[]);
%   All reflections excl. direct path component
    rirsRotor.reflec=rirsRotor.all-rirsRotor.direct;
end

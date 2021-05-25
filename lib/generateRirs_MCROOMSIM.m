function rirs = generateRirs_MCROOMSIM(setup)

%   All reflections including the direct path component
    setup.rirGen.directPath = true;
    mcRoomSim_setup= MCroom_init(setup);
    rirs.all = RunMCRoomSim(mcRoomSim_setup);
%   All reflections excl. direct path component
    setup.rirGen.directPath = false;
    setup= MCroom_init(setup);
    rirs.reflec = RunMCRoomSim(mcRoomSim_setup);
%   Direct component only
    rirs.direct = rirs.all - rirs.reflec;
end

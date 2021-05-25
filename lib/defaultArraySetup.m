function [setup] = defaultArraySetup(setup)
setup.array.micOffset=90;
setup.array.micNumber=4;
setup.array.micSpacing=360/setup.array.micNumber;
setup.array.micAngles=setup.array.micOffset...
    +setup.array.micSpacing*(0:(setup.array.micNumber-1))';
setup.array.micRadius=0.2;
setup.array.rotorRadius = 0.2;
setup.array.micPos=setup.array.micRadius...
    *[cosd(setup.array.micAngles),sind(setup.array.micAngles)];

setup.array.rotorOffset=0;
setup.array.rotorNumber = 4;
setup.array.rotorSpacing=360/setup.array.rotorNumber;
setup.array.rotorAngles = setup.array.rotorOffset...
    +setup.array.rotorSpacing*(0:(setup.array.rotorNumber-1))';
setup.array.rotorPos=setup.array.rotorRadius...
    *[cosd(setup.array.rotorAngles),sind(setup.array.rotorAngles)];
end


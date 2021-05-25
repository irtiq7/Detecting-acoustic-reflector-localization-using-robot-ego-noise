function [setup] = defaultEmSetup(setup)
setup.EM.plotIterations=0;
% setup.EM.minimumDistance=setup.array.micRadius+0.1;
setup.EM.minimumDistance=0.1;
setup.EM.maximumDistance=3;
setup.EM.nRefl=1;
setup.EM.nIter=30;
setup.EM.beta=1/setup.EM.nRefl;
setup.EM.directPathFlag=1;
end


function [setup] = defaultNLSSetup(setup)
setup.nlsEst.candidateDelays=linspace(6,4000,500);
setup.nlsEst.candidateGains=linspace(0.00,0.95,200);
setup.nlsEst.R = 2;
% setup.nlsEst.epsilon = 1e-5;% default value in conference paper 1
setup.nlsEst.epsilon = 1;% default value in conference paper 1
end
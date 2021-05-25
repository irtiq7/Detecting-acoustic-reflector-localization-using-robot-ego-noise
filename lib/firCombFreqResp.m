%% Feedforward Comb Filter

function [output] = firCombFreqResp(filterCoefficient, delay, freqGrid)
    [output] = 1+filterCoefficient*exp(-1i*delay*freqGrid);
end
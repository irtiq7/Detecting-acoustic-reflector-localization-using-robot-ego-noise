function [rirs] = generaterirsTotal(rirs,rirsRotor)
rirs.totalDirect = rirs.direct+rirsRotor.direct;
rirs.totalAll = rirs.all+rirsRotor.all;
rirs.totalReflec = rirs.reflec+rirsRotor.reflec;
end
function [setup] = defaultSignalSetup(setup)
setup.signal.lengthBurst=1500;
setup.signal.lengthSignal=20000;
setup.signal.snr=40;
setup.signal.sdnr=10;
setup.signal.sampFreq=44100/2;
% setup.signal.sampFreq=10000;
setup.signal.diffNoiseStr='allMotors_70_mic1.wav';
end


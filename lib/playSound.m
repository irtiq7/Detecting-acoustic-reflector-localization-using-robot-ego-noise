function playSound(setup, signals,n)
% PLAY SIGNALS
% 1 : Play Clean signals
% 2 : Play reflected signals
% 3 : Play noise signals
% 4 : Play observed incl. noise signals

switch n
    case 1
        soundsc(signals.clean,setup.signal.sampFreq);
%%
    case 2
        soundsc(signals.reflec(:,1),setup.signal.sampFreq);
%%
    case 3
        soundsc(signals.noise(:,1)+signals.diffNoise(:,1),setup.signal.sampFreq);
%%
    case 4
        soundsc(signals.observRefl(:,1),setup.signal.sampFreq);


end
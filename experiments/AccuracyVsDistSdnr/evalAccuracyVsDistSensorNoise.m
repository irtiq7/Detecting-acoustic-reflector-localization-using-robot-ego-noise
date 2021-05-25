% This script is used to evaluate the performance of the ego-noise
% estimator against varying distances and background noise

close all;
clc;
clear;

setup=defaultMiscSetup([]);
setup=defaultSignalSetup(setup);
setup=defaultArraySetup(setup);
setup=defaultRirGenSetup(setup);
setup=defaultRoomSetup(setup);
setup=defaultEmSetup(setup);
setup = defaultNLSSetup(setup);
addpath(genpath('..\Signal-Generator\'));
addpath(genpath('..\..\lib\'));

soundSpeed=343;
dimensions=[8,6,5];
setup.room.dimensions = dimensions;
reverbTime=0.4;
rirLength=2048;
gamma = 6e5;
rotorNumber = 4;
snrList = [-40 -30 -20 -10 0 10 20 30 40];
mcIter = 20;
distToWall = 0.1:0.2:2.5;
setup.signal.sdnr = 40;

srcMicDist=0.2;
trueInt=zeros( length(distToWall),length(snrList));
[inlong, sampFreq] = audioread('\\create.aau.dk\users\ussa\Private\code\allMotors_70.wav');

myCluster = parcluster('local');
myCluster.NumWorkers = 7;  % 'Modified' property now TRUE
saveProfile(myCluster);
poolobj =parpool(myCluster);

for vv = 1:length(snrList)
    setup.signal.snr = snrList(vv);
    aa = 1;
for nn = 1: length(distToWall)
    nn
parfor (ll= 1:mcIter,7)

    [tdoaEst(ll,nn,vv),trueInt(ll,nn,vv)]=middlethings(nn,inlong,sampFreq,distToWall,srcMicDist,soundSpeed,dimensions,reverbTime,rirLength,setup,gamma);
end
end
end
toaEstimates.trueInt=squeeze(trueInt(1,:,:));
%% evaluation


%% evaluate performance
for vv=1:length(snrList)
    for gg=1:length(distToWall)
        tmpEgEsta=tdoaEst;
        for mm=1:mcIter
                toaDiff.egoNoiseEst(mm,gg,vv)=((toaEstimates.trueInt(gg,vv)-tmpEgEsta(mm,gg,vv)));
                if toaDiff.egoNoiseEst(mm,gg,vv)<=7 && toaDiff.egoNoiseEst(mm,gg,vv)>=0
                    toaError.egoNoiseEst(mm,gg,vv)=0;
                else
                    toaError.egoNoiseEst(mm,gg,vv)=1;
                end
        end
    end
    toaError.egoNoisePerc(:,vv)=1-(sum(toaError.egoNoiseEst(:,:,vv)))/mcIter;
end
%%
close all;
h1=figure(1);
for kk = 1:size(toaError.egoNoisePerc,2)
    plot(distToWall,toaError.egoNoisePerc(:,kk)*100,'--s','LineWidth',2);
    grid on;
    ylim([0,100]);
%     legend(['SDNR= ', num2str(snrList(kk))])
    hold on
    box on
end
legend('SSNR = -40 dB', 'SSNR = -30 dB', 'SSNR = -20 dB', 'SSNR = -10 dB', 'SSNR = 0 dB', 'SSNR = 10 dB','SSNR = 20 dB','SSNR = 30 dB', 'SSNR = 40 dB')
hold off
xlabel('Distances [m]')
ylabel('Percentage Accuracy of TDOA estimates')
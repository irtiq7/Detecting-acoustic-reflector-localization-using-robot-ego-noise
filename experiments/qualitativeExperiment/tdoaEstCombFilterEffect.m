% In this script, we estimate the TDOA of the unknown ego-noise when the
% drone platform is moving within a 3D space. If the position of the
% microphone and source are assume fixed then TOA of the reflected signal
% can be obtained. dTDOA = TOA_r - TOA_s
%
%%
close all;
clear;

addpath(genpath('..\data\'));
addpath(genpath('..\lib\'));

setup=defaultMiscSetup([]);
setup=defaultSignalSetup(setup);
setup=defaultArraySetup(setup);
setup=defaultRirGenSetup(setup);
setup=defaultRoomSetup(setup);
setup=defaultEmSetup(setup);
setup.EM.preWhiten =1;
setup = defaultNLSSetup(setup);
setup.EM.plotIterations=0;
setup.fftLength = 2^11;
setup.signal.nfft = 2^11;
setup.simulation = 0;
setup.array.refPoint = 'center';

soundSpeed=343;
dimensions=[8,6,5];
reverbTime=0.4;
rirLength=2048;
gamma = 1500;
srcMicDist=0.3;

[in, sampFreq] = audioread('White_Noise.mp3');
in=in(240000:end,1); 
in=resample(in,1,4);
sampFreq=sampFreq/4;
setup.signal.sampFreq = sampFreq;
in=in(1:sampFreq*10,1)';
len = length(in);

hop=128*2;

srcPos=[0.1,3,2.5];
recPos=srcPos-[0,0,srcMicDist];

start_x=srcPos(1);
stop_x=4%:dimensions(1)-srcPos(1);
ll =1;
for ii=1:hop:len
    x_tmp = start_x + (ii*(stop_x-start_x)/len);
    srcPosTmp = [x_tmp,srcPos(2:3)];
    srcPath(ii:1:min(ii+hop-1,len),1)=srcPosTmp(1);
    srcPath(ii:1:min(ii+hop-1,len),2)=srcPosTmp(2);
    srcPath(ii:1:min(ii+hop-1,len),3)=srcPosTmp(3);
    
    recPath(ii:1:min(ii+hop-1,len),1,1)=srcPosTmp(1);
    recPath(ii:1:min(ii+hop-1,len),2,1)=srcPosTmp(2);
    recPath(ii:1:min(ii+hop-1,len),3,1)=srcPosTmp(3)-srcMicDist;
    
    setup.room.sourcePos = srcPosTmp;
    [imgPos,trueToa,trueDoa]=calculateTrueToas(setup);
    trueToaList(:,ll)=trueToa;
    ll = ll+1;
end

[out,beta_hat] = signal_generator_new(in,soundSpeed,sampFreq,recPath,srcPath,dimensions,reverbTime,rirLength,[],-1);
[direct] = signal_generator_new(in,soundSpeed,sampFreq,recPath,srcPath,dimensions,reverbTime,rirLength,[],0);
% change -1 to 0 in the last input for direct path RIR
[rirDirect] = rir_generator(soundSpeed,sampFreq,[dimensions(1:2)/2, recPos(3)],dimensions/2,dimensions,reverbTime,[],'o',-1);


%%
estDirect = fftfilt(rirDirect, in);
%%
% clear sigPow
% ndx=1:200;
% while ndx(end)<=len
%     sigPowOut(ndx(1),1)=var(out(ndx));
%     sigPowIn(ndx(1),1)=var(in(ndx));
%     ndx=ndx+1;
% end
% 
% for ii=2:length(sigPowOut)
%     deltaPowOut(ii-1)=sigPowOut(ii)-sigPowOut(ii-1);
% end

N=300;
ndx=1:N;
ii=1;
refl=out-direct;

while ndx(end)<=length(out)
    signal.observ = refl(ndx);
    signal.observDirect = direct(ndx);
    signal.bgNoise = out;
    [corr,lags]=xcorr(refl(ndx),direct(ndx));
    [pwrObservSignal(ii), thresholdValue(ii), acousticReflDetection(ii)] = echoDetector(signal, gamma);
    [maxCorr,maxNdx]=max(corr);
    maxCorrs(ii)=maxCorr;
    maxCorrsNorm(ii)=maxCorr/norm(direct(ndx));
    tdoaEst(ii)=lags(maxNdx);
 
    ii=ii+1;
    ndx=ndx+N/2;

end

%% Estimating TOA of the reflected signal given the source-microphone position is fixed
toa_s = srcMicDist/soundSpeed*sampFreq; % estimate the source distance
toaEst_r = tdoaEst + toa_s;
toaEst_r = toaEst_r/2; % since the signals twice the distance

%% RMSE of proposed estimator
% for nn = 1:size(trueToaList,2)
%     min(trueToaList(:,nn)-toaEst_r(1))

%%
% N=300;
% ndx=1:N;
% ii=1;
% refl2 = out-estDirect;
% while ndx(end)<=length(out)
%     [corr,lags]=xcorr(refl2(ndx),estDirect(ndx));
%     [maxCorr,maxNdx]=max(corr);
%     maxCorrs(ii)=maxCorr;
%     maxCorrsNorm(ii)=maxCorr/norm(estDirect(ndx));
%     tdoaEst(ii)=lags(maxNdx);
%     
%     ii=ii+1;
%     ndx=ndx+N/2;
% end


%%
% ndx=1:N;
% ii=1;
% prevObserv = zeros(length(N), 1);
% while ndx(end)<=length(out)
%     estX(ndx) = (mean(out(ndx)'.*prevObserv)/(N*mean(prevObserv.^2))).*prevObserv;
%     ii = ii + 1;
%     prevObserv = out(ndx);
%     ndx=ndx+N/2;
% end



%% Plot data
figure(1);
subplot(5,1,1);
plot(maxCorrs);
title('Gain without normalization')
grid on
subplot(5,1,2);
plot(maxCorrsNorm);
title('Gain with normalization')
grid on
subplot(5,1,3);
plot(tdoaEst);
title('TDOA')
grid on
subplot(5,1,4);
plot(toaEst_r);
title('TOA')
vline(30);
grid on
subplot(5,1,5);
plot(acousticReflDetection);
title('GLRT detector')
grid on;

%%
refl2 = out-estDirect;
figure;
subplot(311);
plot(out);
subplot(312);
plot(estDirect);
subplot(313);
plot(refl2)

%% TOA of unknown rotor signal but NLS can't be used because 
%  there is no knownledge of clean signal.
% signals.observRefl = out;
% [estimates, costFunction]=rNlsEst(signals,setup);
% toaEstimates.rNlsEst=estimates.rNlsEst.toa;
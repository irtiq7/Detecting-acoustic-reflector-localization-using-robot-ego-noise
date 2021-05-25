function [tdoaEstaaaa,trueIntaaa]=middlethings(nn,in,sampFreq,distToWall,srcMicDist,soundSpeed,dimensions,reverbTime,rirLength,setup,gamma)

% in=randn(1000000,1);
% sampFreq=44100;
% [in, sampFreq] = audioread('..\data\washingMachineEngine.wav');
randSample = randi([1e3,15e5]);
in=in(randSample:randSample+100000,1);
% in = in(200000:end,1);
in=resample(in,1,4);
sampFreq=sampFreq/4;
setup.signal.sampFreq= sampFreq;
in=in(1:floor(sampFreq),1)';

% in=randn(1,length(in));
setup.signal.lengthBurst = length(in);
setup.signal.lengthSignal = length(in);
signals.whiteNoise =[randn(setup.signal.lengthBurst,1);...
        zeros(setup.signal.lengthSignal-setup.signal.lengthBurst,1)];
len = length(in);

hop=50;

srcPos=[distToWall(nn),3,2.5];
setup.room.sourcePos = srcPos;

% for kk=1:rotorNumber
%       srcPos(kk,:)=[...
%       recPos(1:2)+setup.array.micPos(kk,:),...
%       recPos(3)];
% end
recPos=srcPos-[0,srcMicDist,0];
setup.room.receivPos = recPos;

start_x = srcPos(1);
% stop_x=dimensions(1)-srcPos(1);
stop_x = srcPos(1);

for ii=1:hop:len
    x_tmp = start_x + (ii*(stop_x-start_x)/len);
    srcPosTmp = [x_tmp,srcPos(:,2:3)];
    srcPath(ii:1:min(ii+hop-1,len),1)=srcPosTmp(1);
    srcPath(ii:1:min(ii+hop-1,len),2)=srcPosTmp(2);
    srcPath(ii:1:min(ii+hop-1,len),3)=srcPosTmp(3);
    
    recPath(ii:1:min(ii+hop-1,len),1,1)=srcPosTmp(1);
    recPath(ii:1:min(ii+hop-1,len),2,1)=srcPosTmp(2);
    recPath(ii:1:min(ii+hop-1,len),3,1)=srcPosTmp(3)-srcMicDist;
end

[out,beta_hat] = signal_generator_new(in,soundSpeed,sampFreq,recPath,srcPath,dimensions,reverbTime,rirLength,[],-1);
[direct] = signal_generator_new(in,soundSpeed,sampFreq,recPath,srcPath,dimensions,reverbTime,rirLength,[],0);
% save(['movingPlatformDataStatic_',num2str(nn),'.mat'])

% out=out(:);
% out = out-direct;


%   Add sensor noise
% for kk=1:1
%         signals.noise(:,kk)=sqrt(var(out)...
%             /10^(setup.signal.snr/10))*randn(length(out),1);
% end
signals.diffNoise=generateMultichanBabbleNoise(length(out),...
                1,...
                setup.array.micPos,...
                setup.room.soundSpeed,...
                'cylindrical',...
               setup.signal.diffNoiseStr);

            for kk=1:1
                signals.diffNoise(:,kk)=sqrt(var(out(kk,:))...
                    /10^(setup.signal.sdnr/10))*signals.diffNoise(:,kk)...
                    /sqrt(var(signals.diffNoise(:,kk)));
            end
            for kk=1:1
                signals.whiteNoise(:,kk)=sqrt(var(out(kk,:))...
                    /10^(setup.signal.snr/10))*signals.whiteNoise...
                    /sqrt(var(signals.whiteNoise));
            end
%             signals.observ=out'+signals.noise+signals.diffNoise;
            signals.observ=out'+signals.diffNoise + signals.whiteNoise;

%             signals.direct=direct'+signals.noise+signals.diffNoise;
            signals.direct=direct'+signals.diffNoise + signals.whiteNoise;
%             signals.observRefl=signals.reflec+signals.noise+signals.diffNoise;
%              signals.bgNoise = signals.noise+signals.diffNoise;
             signals.bgNoise = signals.diffNoise + signals.whiteNoise;

% N=300;
% ndx=1:N;
% ii=1;
refl=signals.observ-signals.direct;
signal.reflec = refl;
signal.observDirect = signals.direct;
signal.bgNoise = signals.bgNoise;
% 
% 
% while ndx(end)<=length(out)
%     signal.refl = refl(ndx);
%     signal.observDirect = signals.direct(ndx);
%     signal.bgNoise = signals.bgNoise;
%     [corr,lags]=xcorr(refl(ndx),signals.direct(ndx));
%     [pwrObservSignal(ii), thresholdValue(ii), acousticReflDetection(ii)] = echoDetector(signal, gamma);
%     [maxCorr,maxNdx]=max(corr);
%     maxCorrs(ii)=maxCorr;
%     maxCorrsNorm(ii)=maxCorr/norm(signals.direct(ndx));
%     tdoaEst(ii)=lags(maxNdx);
%  
%     ii=ii+1;
%     ndx=ndx+N/2;
% 
% end
%%
    [corr,lags]=xcorr(refl,signals.direct);
    [pwrObservSignal, thresholdValue, acousticReflDetection] = echoDetector(signal, gamma);
    [maxCorr,maxNdx]=max(corr);
    maxCorrs=maxCorr;
    maxCorrsNorm=maxCorr/norm(direct);
    tdoaEstaaaa=lags(maxNdx);
%     tdoaEst(ll,nn,vv)/sampFreq*343/2;

    
    %%
%     [~,toaEstimates.true]=calculateTrueToas(setup);
trueIntaaa=round(distToWall(nn)*sampFreq/setup.room.soundSpeed*2);
end


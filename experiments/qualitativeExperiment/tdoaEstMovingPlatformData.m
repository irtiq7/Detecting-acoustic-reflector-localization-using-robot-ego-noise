% In this script, we estimate the TDOA of the unknown ego-noise when the
% drone platform is moving within a 3D space. If the position of the
% microphone and source are assume fixed then TOA of the reflected signal
% can be obtained. dTDOA = TOA_r - TOA_s
%
%%
close all;
clear;

addpath(genpath('..\data\'));
addpath(genpath('..\..\lib\'));


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
gamma = 2500;
srcMicDist=0.3;
setup.signal.sdnr = 10;
distToWall = 0.1:0.2:2.5;
setup.signal.snr = 40;
load('movingPlatformData.mat')


N=300;
ndx=1:N;
ii=1;
refl=out-direct;
signal.observ = out;

setup.signal.lengthBurst = length(in);
setup.signal.lengthSignal = length(in);
signals.whiteNoise =[randn(setup.signal.lengthBurst,1);...
        zeros(setup.signal.lengthSignal-setup.signal.lengthBurst,1)];

%   Add sensor noise
for kk=1:1
        signals.noise(:,kk)=sqrt(var(out)...
            /10^(setup.signal.snr/10))*randn(length(out),1);
end
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

             
while ndx(end)<=length(out)
    signal.reflec = refl(ndx);
    signal.observDirect = direct(ndx);
    signal.bgNoise = signals.bgNoise;
    [corr,lags]=xcorr(refl(ndx),direct(ndx));
    [pwrObservSignal(ii), thresholdValue(ii), acousticReflDetection(ii)] = echoDetector(signal, gamma);
    [maxCorr,maxNdx]=max(corr);
    maxCorrs(ii)=maxCorr;
    maxCorrsNorm(ii)=maxCorr/norm(direct(ndx));
    tdoaEst(ii)=lags(maxNdx);
 
    ii=ii+1;
    ndx=ndx+N/2;

end


%% with echo-detector

N=300;
ndx=1:N;
ii=1;
refl=out-direct;
signal.observ = out;

while ndx(end)<=length(out)
    signal.refl = refl(ndx);
    signal.observDirect = direct(ndx);
    signal.bgNoise = signals.bgNoise;
    [pwrObservSignalEd(ii), thresholdValueEd(ii), acousticReflDetectionEd(ii)] = echoDetector(signal, gamma);
    if acousticReflDetectionEd
        [corrEd,lagsEd]=xcorr(refl(ndx),direct(ndx));
        [maxCorrEd,maxNdxEd]=max(corrEd);
        maxCorrsEd(ii)=maxCorrEd;
        maxCorrsNormEd(ii)=maxCorrEd/norm(direct(ndx));
        tdoaEstEd(ii)=lags(maxNdxEd);
    else
        tdoaEstEd(ii) = 0;
    end
 
    ii=ii+1;
    ndx=ndx+N/2;

end

%% Estimating True TDOE of the reflected signal given the source-microphone position is fixed

trueToaMin = [0.2]*sampFreq/343*2;
trueToaMax =  [4]*sampFreq/343*2;
trueToa = trueToaMin:trueToaMax;
trueToa = [trueToa flip(trueToa)];
trueDirect = 0.2*sampFreq/343*2;
trueTDOE = trueToa-trueDirect;


%% Plot data
close all;
h1 = get(gca,'fontname')  % shows you what you are using.
set(gca,'fontname','Times')  % Set it to times
h1 = figure(1);
subplot(3,1,1);
plot(0.01:1/92.8:length(maxCorrsNorm)/92.8, maxCorrsNorm');
ylabel('$\hat{\mathbf{\alpha}}$','Interpreter','Latex')
grid on
box on
subplot(3,1,2);
plot(0.01:1/92.8:length(maxCorrsNorm)/92.8,tdoaEst);
ylabel('$\Delta \hat \tau$','Interpreter','Latex')
hold on;
plot(linspace(0,8,490),trueTDOE, '--')
hold off;
grid on
box on
legend('Est. TDOE', 'True TDOE','Interpreter','Latex')
subplot(3,1,3);
plot(0.01:1/92.8:length(maxCorrsNorm)/92.8,acousticReflDetection);
ylim([-0.2 1.5])
ylabel('T(y)','Interpreter','Latex')
xlabel('Distance [m]', 'Interpreter','Latex')
yticks([0 1])
grid on;
box on
% subplot(4,1,3);
% plot(tdoaEstEd);
% title('Proposed method with Echo-Detector');
% grid on;
% box on;
%%
figure;
plot(pwrObservSignal);
hold on; 
plot(thresholdValue);
hold off;
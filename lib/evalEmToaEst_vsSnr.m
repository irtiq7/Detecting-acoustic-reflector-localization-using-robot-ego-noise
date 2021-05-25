clc;clear; close all;
addpath(genpath('lib'));

%% setup
setup=defaultMiscSetup([]);
setup=defaultSignalSetup(setup);
setup=defaultArraySetup(setup);
setup=defaultRirGenSetup(setup);
setup=defaultRoomSetup(setup);
setup=defaultEmSetup(setup);
setup.EM.plotIterations=0;
setup.fftLength = 2^13;
snrGrid=[-40 -20,-15,-10,-5,0,5,10];
mcIter=1;

%% generate rirs
rirs=generateRirs(setup);

for gg=1:length(snrGrid)
disp(['Running SNR evaluation for SNR=',num2str(snrGrid(gg)),'dB ('...
    ,num2str(gg),' of ',num2str(length(snrGrid)),' evals)']);
setup.signal.snr=snrGrid(gg);

for mm=1:mcIter
disp(['... simulation ',num2str(mm),' of ',num2str(mcIter)]);
%% generate signals
signals=generateSignals(rirs,[],setup);
%% estimation
% % uca em
% estimates=emCircArray(signals,setup);
% toaEstimates.emUca(:,mm,gg)=estimates.emUca.toa;
% 
% % one chan em
% estimates=emSingleChan(signals,setup,estimates);
% toaEstimates.emOneCh(:,mm,gg)=estimates.emOneCh.toa;

% PEAK PICKING Single Channel
estimates=peakPeaking(signals,setup);
toaEstimates.peakPicking(:,mm,gg)=estimates.peakPicking_oneCh.toa;
end
%%
[~,toaEstimates.true]=calculateTrueToas(setup);
toaEstimates.trueInt=round(toaEstimates.true);

end

%% save data
save([mfilename,'_',datestr(now,30)]);

%% evaluate performance
for gg=1:length(snrGrid)
    
%     % UCA EM
% %     tmpEmUca=squeeze(toaEstimates.emUca(:,gg,:))';
%     tmpEmUca=toaEstimates.emUca(:,:,gg)';
%     for mm=1:mcIter
%         for kk=1:setup.EM.nRefl
%             toaDiff.emUca(mm,kk,gg)=min(abs(toaEstimates.trueInt-tmpEmUca(mm,kk)));
%             if toaDiff.emUca(mm,kk,gg)<=1
%                 toaError.emUca(mm,kk,gg)=0;
%             else
%                 toaError.emUca(mm,kk,gg)=1;
%             end
%         end
%     end    
%     toaError.emUcaPerc(gg,1)=1-sum(sum(toaError.emUca(:,:,gg)))/setup.EM.nRefl/mcIter;
%     
%     % single-channel EM
%     tmpEmOneCh=toaEstimates.emOneCh(:,:,gg)';
%     for mm=1:mcIter
%         for kk=1:setup.EM.nRefl
%             toaDiff.emOneCh(mm,kk,gg)=min(abs(toaEstimates.trueInt-tmpEmOneCh(mm,kk)));
%             if toaDiff.emOneCh(mm,kk,gg)<=1
%                 toaError.emOneCh(mm,kk,gg)=0;
%             else
%                 toaError.emOneCh(mm,kk,gg)=1;
%             end
%         end
%     end
%     toaError.emOneChPerc(gg,1)=1-sum(sum(toaError.emOneCh(:,:,gg)))/setup.EM.nRefl/mcIter;
    
    % Peak Picking Single Channel
    tmpPeakPicking=toaEstimates.peakPicking(:,:,gg)';
    for mm=1:mcIter
        for kk=1:setup.EM.nRefl
            toaDiff.peakPicking(mm,kk,gg)=min(abs(toaEstimates.trueInt-tmpPeakPicking(mm,kk)));
            if toaDiff.peakPicking(mm,kk,gg)<=1
                toaError.peakPicking(mm,kk,gg)=0;
            else
                toaError.peakPicking(mm,kk,gg)=1;
            end
        end
    end
    toaError.peakPickingPerc(gg,1)=1-sum(sum(toaError.peakPicking(:,:,gg)))/setup.EM.nRefl/mcIter;
end

%% plots
close all;
h1=figure(1);
% plot(snrGrid,toaError.emUcaPerc,'bs-','LineWidth',1);
% hold on;
% plot(snrGrid,toaError.emOneChPerc,'r*-','LineWidth',1);
plot(snrGrid,toaError.peakPickingPerc,'k*-','LineWidth',1);
% hold off;
grid on;
ylim([0,1]);
xlim([-10,10]);

ylabel('Accuracy [%]');
xlabel('SNR [dB]');

legend('EM UCA','EM SC','Location','NorthWest');

h1.Position=[1095 996 465 342];
set(gca,'fontname','times');
set(gca,'fontsize',12);

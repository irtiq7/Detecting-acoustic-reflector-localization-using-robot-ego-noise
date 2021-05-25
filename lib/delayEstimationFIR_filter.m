function [gainEst,delayEst,filterEst,costFunction,delayEst2,costFunction2] = delayEstimationFIR_filter(signal_reflectionsFft,signal_cleanFft,oldResponse,delayCand)
%DELAYATTENUATIONESTIMATION Summary of this function goes here
%   Detailed explanation goes here

costFunction=zeros(length(delayCand),1);
costFunction2 = zeros(length(delayCand),1);
for dd=1:length(delayCand)
    tmpDelay=delayCand(dd);        

%     tmpResponse=findFirFilterResponse(tmpGain,tmpDelay,length(signals.cleanFft));

    w=(0:(length(signal_cleanFft)-1))/length(signal_cleanFft)*2*pi;
    for ww=1:length(w)
         if w(ww)<=pi
            z(ww,1)=exp(1i*w(ww)*-tmpDelay);
        else
            tmp=w(ww)-2*pi;
            z(ww,1)=exp(1i*tmp*-tmpDelay);
        end
    end
    Xz=signal_cleanFft.*z; %Z(Tw)*S
    Yb=signal_reflectionsFft-signal_cleanFft.*oldResponse; % Y - Sw*Z(Tw)
    gainEst=(Yb'*Xz+Xz'*Yb)/(2*Xz'*Xz);
    costFunction2(dd,1) = (real((signal_reflectionsFft'*Xz)));

    costFunction(dd,1)=sum(abs(Yb-...
        gainEst*Xz).^2);
    
%             signals.cleanFft.*(tmpResponse+oldResponse)).^2);
%     end
end

%     gainEst=gainCand;
[~,delayNdx]=min(costFunction);
delayEst=delayCand(delayNdx);
[~,delayNdx2]=max(costFunction2);
delayEst2=delayCand(delayNdx);

w=(0:(length(signal_cleanFft)-1))/length(signal_cleanFft)*2*pi;
for ww=1:length(w)
    if w(ww)<=pi
        z(ww,1)=exp(1i*w(ww)*-delayEst);
    else
        tmp=w(ww)-2*pi;
        z(ww,1)=exp(1i*tmp*-delayEst);
    end
end
Xz=signal_cleanFft.*z;
Yb=signal_reflectionsFft-signal_cleanFft.*oldResponse;
gainEst=(Yb'*Xz+Xz'*Yb)/(2*Xz'*Xz);
    

% if length(gainCand)==1&&length(delayCand)>1
% %     gainEst=gainCand;
%     [~,delayNdx]=min(costFunction);
%     delayEst=delayCand(delayNdx);
%     
%     w=(0:(length(signals.cleanFft)-1))/length(signals.cleanFft)*2*pi;
%     for ww=1:length(w)
%         if w(ww)<=pi
%             z(ww,1)=exp(1i*w(ww)*-delayEst);
%         else
%             tmp=w(ww)-2*pi;
%             z(ww,1)=exp(1i*tmp*-delayEst);
%         end
%     end
%     Xz=signals.cleanFft.*z;
%     Yb=signals.receivedFft-signals.cleanFft.*oldResponse;
%     gainEst=(Yb'*Xz+Xz'*Yb)/(2*Xz'*Xz)
%     
% elseif length(delayCand)==1&&length(gainCand)>1
%     delayEst=delayCand;
%     [~,gainNdx]=min(costFunction);
%     gainEst=gainCand(gainNdx)
%     
% %     w=linspace(0,2*pi,length(signals.cleanFft));
%     w=(0:(length(signals.cleanFft)-1))/length(signals.cleanFft)*2*pi;
%     for ww=1:length(w)
%         if w(ww)<=pi
%             z(ww,1)=exp(1i*w(ww)*-delayEst);
%         else
%             tmp=w(ww)-2*pi;
%             z(ww,1)=exp(1i*tmp*-delayEst);
%         end
%     end
% %     z=z.^-delayEst;
%     Xz=signals.cleanFft.*z;
%     Yb=signals.receivedFft-signals.cleanFft.*oldResponse;
%     gTest=(Yb'*Xz+Xz'*Yb)/(2*Xz'*Xz)
%     %keyboard
% elseif length(delayCand)==1&&length(gainCand)==1
%     gainEst=gainCand;
%     delayEst=delayCand;
% else
%     [~,gainNdx]=min(min(costFunction,1));
%     [~,delayNdx]=min(min(costFunction,2));
%     gainEst=gainCand(gainNdx);
%     delayEst=delayCand(delayNdx);
% end

filterEst=findFirFilterResponse(gainEst,delayEst,length(signal_cleanFft));
end


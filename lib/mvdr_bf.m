function mvdr_bf(setup, signals)
%%
N = setup.array.micNumber;
angMic = setup.array.micAngles;
c = 343;
R = setup.array.micRadius;
% R = 0.001;
% Steering vector on xy plane
angTheta = 90; %elevation is set to 90 deg
angPhi = 0:15:360-1;

% Find frequency bins of broadband source signal
xFft = fft(signals.observRefl,setup.signal.nfft);
xAbs = abs(xFft);
signal = signals.observRefl'*signals.observRefl;

%% Calculating steering vector a(\theta)
steeringVec = zeros(N, length(angPhi), length(xFft));

for ff = 1:length(xFft)
    for kk = 1:length(angPhi)
        for nn= 1:N
            steeringVec(nn,kk,ff) = exp( (1j) * 2*pi * (ff)/c...
                * R * sind(angTheta) * cosd(angPhi(kk) - (2*pi*(nn(1))/N)*180/pi))/sqrt(N);
        end
    end
    
end

%% Calculate weight of MVDR based on the equation
% for different ng angle and frequency for all microphone

for ff =1:length(xFft)
    for ss=1:length(angPhi)
            ll=inv(xFft(ff,:).'*xFft(ff,:))*steeringVec(:,ss,ff);
            jj = ll/(steeringVec(:,ss,ff)'*inv(xFft(ff,:).'*xFft(ff,:))*steeringVec(:,ss,ff));
%             outputPower(ss,ff+1) = jj'*(xFft(ff+1,:).'*xFft(ff+1,:))*jj;
            outBeam(:,ss,ff) = xFft(ff,:)'.*jj;
%             beamPower(:,ss,ff) = steeringVec(:,ss,ff)'*x*steeringVec(:,ss,ff);
    end
end
% beam = jj(:,:,:)'*steeringVec(:,10,1000);
% plot(angPhi, (abs(beam)))
% beam= (jj'*steeringVec(:,10,:));
% plot(angPhi, 20*log10(abs(beam)));
% If the interference is at position 90 degree
% angInterference = exp( (-1j) * 2*pi * xAbs(100)/c...
%                 * R * sind(angTheta) * cosd(angPhi(1) - (2*pi*(1:N)/N)'))/sqrt(N);

%%
% ss = 150;
% ll=inv(X)*steeringVec(:,ss,3);
% jj = ll/(steeringVec(:,ss,3)'*inv(X)*steeringVec(:,ss,3));
% beam = jj'*steeringVec(:,:,3);
% output = xFft(:,4)*steeringVec(1,1,1000);
% 
% plot(angPhi, 20*log10(abs(beam)));
% for f=1:length(xAbs)
%     for i=1:length(angPhi)
%         P(f,i)=steeringVec(:,i,f)'*X*steeringVec(:,i,f);
%     end
% end
% P=real(P);
% surf(angPhi, 1:length(xAbs)/2,beam)
end
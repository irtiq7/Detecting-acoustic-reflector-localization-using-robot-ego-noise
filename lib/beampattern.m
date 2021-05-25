function beampattern(setup, signals)
%% Signal Definitions.
M               = setup.array.micNumber;        % Number of Array Elements.
speedSound      = 343;                          % Speed of sound
d               = setup.array.micRadius;        % Interelement Distance in (m).
phi_s           = 0;                           % Steering Angle of Beamformer in (deg).
theta           = 90;                           % elevation angle in (deg)
% R = 0.001;
% Steering vector on xy plane
angPhi = 0:15:360-1;

% Find frequency bins of broadband source signal
xFft = fft(signals.observRefl,setup.signal.nfft);
xAbs = abs(xFft);
X = (xFft'*xFft)/length(xFft);
x = signals.observRefl'*signals.observRefl;

%% Calculate the Beampattern Using the definition.
%  for each frequency bin
for ff = 1:(length(xFft))
    u_s = (d*ff/speedSound)*sin(theta*pi/180)*cos(phi_s*pi/180- 2*pi*(1:M)/M);  % Normalized Spatial Frequency of the signal of interest.

    % Conventional Beamformer steered at $\phi_s$.
    c(:,ff) = exp(-1i*2*pi*u_s.')/sqrt(M);
end
%% Beampattern Calculation.
angle = angPhi;
L = length(angle);
C1 = zeros(length(xFft),L);

for ff = 1:(length(xFft))
    for k=1:L-1
        u = (d*ff/speedSound)*sin(theta*pi/180)*cos(angle(k)*pi/180- 2*pi*(1:M)/M);
        v = exp(-1i*2*pi*u.')/sqrt(M); % Azimuth Scanning Steering Vector.
        C1(ff,k) = c(:,ff)'*v;
%         beamPower(ff,k) = v'*xFft(ff,:)'*xFft(ff,:)*v;
        outputPower(ff,:) = xFft(ff,:)'.*v;
%         signalAfterBF(ff, k,:) = xFft(ff,:)'*C1(ff,k);
%         signalAfterBF(ff, k,:) = xFft(ff,:)*c(:,ff);
    end
end
%%
figure(1)
subplot(211)
plot((ifft((xFft))))
title('Observed Signal before beamforming')
subplot(212);
plot(flipud(real(ifft((outputPower)))))
title('Observed Signal after beamforming')
figure(2)
surf((1:8192)',(1:360)',abs(signalAfterBF(:,:,1))')
%% Plot the Results in Cartesian
% figure(1)
figure('NumberTitle', 'off','Name','Figure 11.9','Position',[0 0 600 850]);
subplot(2,1,1);
% This plots the instantaneous power for every element (M waveforms).
plot(angle,10*log10(abs(C1(1000,:)).^2));  
ylim([-70 5]);
xlim([0 360]);
grid on;
title('Beampattern Using Definition');
xlabel('Sample Number');
ylabel('Output Power (dB)');


%% Plot the Beampattern in Polar.
subplot(2,1,2);        
polardb(angle*pi/180,10*log10(abs(C1(1000,:)).^2),-60,'b');
title('Beampattern Using Definition');
grid on;

% tightfig;


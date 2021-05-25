

function [y,dt,fs] = GMSP(alpha,df,tm)
% df = frequency
%alpha = 
% Default values
if nargin <3
    alpha = 3;
    tm = 1;
    df = 100e3;
end

fs = 44100;
T = 1/fs;

dt = -500e-3-T:T:500e-3-T;
S0 = 2;
% S0 = df./tm;
a = 2*(alpha./tm).^2;
b = pi*S0;

y = exp(-(a-1i*b).*(dt.^2));

figure
plot(dt,real(y),'b',dt,imag(y),'r',dt,abs(y),'g')
ylabel('Magnitude')
xlabel('Time (s)')
legend('real','imaginary','absolute')
soundsc(real(y))
% figure(22);
% spectrogram(y);
end
% size(y)
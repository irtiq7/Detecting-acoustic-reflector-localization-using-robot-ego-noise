function  response=findFirFilterResponse(gain,delay,fftSize)
%FINDFILTERRESPONSE Summary of this function goes here
%   Detailed explanation goes here

response=zeros(fftSize,1);
% w=linspace(0,2*pi,fftSize);
w=(0:(fftSize-1))/fftSize*2*pi;
for ww=1:length(w)
    if w(ww)<=pi
        z=exp(1i*w(ww)*-delay);
    else
        tmp=w(ww)-2*pi;
        z=exp(1i*tmp*-delay);
    end
%     keyboard
    response(ww,1)=gain*z;
end

end


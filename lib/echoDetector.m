function [pwrObservSignal, thresholdValue, acousticReflDetection] = echoDetector(signals, gamma)
pwrObservSignal = norm(signals.reflec);
thresholdValue = 2*var(signals.bgNoise)*gamma;
if pwrObservSignal > thresholdValue
   acousticReflDetection = 1;
else
   acousticReflDetection = 0;
end

end
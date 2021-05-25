function tauset = estimatePitch(data, frequencyRange)
% Lecture 4, p. 21, eqn (8)
% frequencyRange should be bounded between [0 0.5]
if length(frequencyRange) ~= 2
    error('''frequencyRange'' should contain [fmin fmax].')
end
f = sort(frequencyRange);
if f(1) < 0
    warning('fmin should be a nonnegative value. Automatically this is set to be 0.')
    f(1) = 0;
end
if f(2) > 0.5
    warning('fmax should be smaller than 0.5. Automatically this is set to be 0.5.')
    f(2) = 0.5;
end

fmin = f(1);
fmax = f(2);
taumax = round(1/fmin);

subsetdata = data(taumax:end);
cfactor1 = sqrt(sum(subsetdata.^2));

tauset = zeros(taumax,1);
for tidx = 1:taumax
    shiftdata = data((taumax:end)-tidx+1);
    cfactor2 = sqrt(sum(shiftdata.^2));
    
    tauset(tidx) = (subsetdata'*shiftdata)/(cfactor1*cfactor2);
end


end
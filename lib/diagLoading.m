function diagLoadingOutput = diagLoading(noiseCovariance, gamma)
[nmic,~,nfrebins] = size(noiseCovariance);
diagLoadingOutput = zeros(size(noiseCovariance));
for ii= 1:nfrebins
    diagLoadingOutput(:,:,ii) = (1-gamma)*noiseCovariance(:,:,ii) + (gamma)*trace(noiseCovariance(:,:,ii))*(eye(nmic))/(nmic);
end

end
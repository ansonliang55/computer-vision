function newSamples = propagateSamples(sampDist, dynamicsParams)

  % YOU NEED TO WRITE THIS
  sampDist.samples(1,:);
  sigma = diag(dynamicsParams.dynCovar)';
  numSamps = size(sampDist.samples,1);
  newSamples.samples = normrnd(sampDist.samples,repmat(sigma,numSamps,1));

  %newSamples.samples = 0;
  newSamples.weights = sampDist.weights;

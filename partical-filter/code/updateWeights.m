function newSamples = updateWeights(sampDist, im, likelihoodParams)

  
  numSamps = size(sampDist.samples,1);
  
  % For each sample, first obtain data log likelihood
  loglike = pigLogLike(sampDist.samples', im, ...
                               likelihoodParams);
  
  % YOU NEED TO FINISH THIS

  % Bayes Rule 1/c ~ SUM(p(z_t|a_t))
  likelihood = exp(loglike);
  c = 1/sum(likelihood);
  newSamples.weights = c*likelihood;
  
  
  % calculate effective number of particles
  N = 1/sum(newSamples.weights.^2);
  fprintf('Effective number of particles: %f\n', N);

  %newSamples.weights = 0;
  newSamples.samples = sampDist.samples;
  
   return;

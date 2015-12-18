function newSamples = updateWeights(sampDist, im, likelihoodParams)

  
  numSamps = size(sampDist.samples,1);
  
  % For each sample, first obtain data log likelihood
  
  [idx C] = kmeans(sampDist.samples,2);
  s1 = sampDist.samples(idx==1,:);
  s2 = sampDist.samples(idx==2,:);
  loglike1 = pigLogLike(s1', im, ...
                               likelihoodParams);
  loglike2 = pigLogLike(s2', im, ...
                               likelihoodParams);
  
  % YOU NEED TO FINISH THIS

  % Bayes Rule 1/c ~ SUM(p(z_t|a_t))
  likelihood1 = exp(loglike1);
  likelihood2 = exp(loglike2);
 
  
  c1 = 1/sum(likelihood1);
  c2 = 1/sum(likelihood2);
  
  newSamples.weights = [c1*likelihood1;c2*likelihood2];
  newSamples.weights = newSamples.weights/sum(newSamples.weights);
  
  
  % calculate effective number of particles
  N = 1/sum(newSamples.weights.^2);
  fprintf('Effective number of particles: %f\n', N);
  % BOGUS
  %newSamples.weights = 0;
  newSamples.samples = [s1;s2];
  
   return;

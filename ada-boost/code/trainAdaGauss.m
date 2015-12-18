%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File: trainAdaGauss.m
%  Matlab script file
%  Date: Oct, 08
%

% Dependencies, Toolboxes:
%      iseToolbox/
%      utvisToolbox/file/
% Data files: trainSet.mat testSet.mat
% Writes data file: adaFit.mat

% Author: YOU and ADJ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Check Path and Constants  %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
% close all;
% run('/Users/ansonliang55/Dropbox/UOT/CSC2503/matlab/startup.m')
% debugFish = 0;          % Set to 1 or 2 to debug fishFeature
% debugTrainStump = 0;    % Set to 1 or 2 to debug trainStump
% maxFeatures = 100;       % Maximum number of features in strong classifier
% maxErr = 0.4;           % Ignore any feature with err > maxErr
% greedyErr = 0.3;        % Use any feature found with err < greedyErr
% % This breaks out of the search over all features, and the selected
% % feature may not be the optimal next feature.
% 
% sigmaSet = [4 2 1];     % The gaussian derivative sigmas (coarse to fine)
%                         % to try.
%                         
% %% Check path
% if ~exist('rescaleImageVectors','file')
%   addpath('./util');
% end
% 
% %  Check for toolboxes.
% %  If these aren't on your path, then you will need
% %  to add these toolboxes to your path.  See ~jepson/pub/matlab/startup.m
% which showIm          % should be iseToolbox\pyrTools\showIm.m
% 
% %%%%%%%%  Initialize random number generator %%%%%%%%%%%%%%%%%%%%%%%
% % Random number generator seed:
% seed = round(sum(1000*clock));
% rand('state', seed);
% seed0 = seed;
% 
% %%%%%%%%%%% Load eye and non-eye images %%%%%%%%%%%%%%%%%%%%%%%%%%
% load('trainSet');
% nTarg = size(eyeIm,2);
% nNon = size(nonIm, 2);
% testImSz = sizeIm;
% 
% %% %%%%%%%%%
% % Do brightness normalization
% % %%%%%%%%%%
% testTarg = rescaleImageVectors(eyeIm);
% testNon = rescaleImageVectors(nonIm);
% 
% 
% % Form training data
% X = [testTarg testNon];
% y = [ones(1,nTarg) zeros(1,nNon)];
% 
% % Initial weights, scaled so that sum of the target weights is 0.5,
% % as is the sum of the non target weights.
% wghts = [ones(1,nTarg)/(2*nTarg), ones(1,nNon)/(2*nNon)];
% 
% nFeatures = 0;
% while nFeatures < maxFeatures
% 
%   bestFeat = fishFeature(testImSz, sigmaSet, X, y, wghts, greedyErr, ...
%                          debugFish);
%                
%   f = buildGaussFeat(bestFeat);
% 
%   figure(1); clf; 
%   showIm(f);
%   pause(0.1);
%   [err, thres, parity, H] = ...
%       trainStump(f(:), bestFeat.abs, X, y, wghts, debugTrainStump);
%   
% %  fprintf('sigma: %i, deriv: %i, theta: %d, abs: %i, x0: %i, y0: %i\n, parity: %i, Err: %f, Thres: %f, True/False Pos. Rates: %f, %f\n', ...
%  %           bestFeat.sigma,bestFeat.deriv, bestFeat.theta, ...
% %            bestFeat.abs,bestFeat.center(1),bestFeat.center(2), ...
% %            bestFeat.parity, err, bestFeat.thres, ...
% %            sum(H(y>0) >0)/sum(y>0), sum(H(y==0) >0)/sum(y==0));
% %  pause
%   if err > maxErr
%     break;
%   end
%   
%   bestFeat.alpha = log((1-err)/err);
%   
%   % Add bestFeat to feature list
%   if nFeatures == 0
%     featList(1) = bestFeat;
%     nFeatures = 1;
%   else
%     nFeatures = nFeatures+1;
%     featList(nFeatures) = bestFeat;
%   end
%   
%   
%   
%   
%   wghts = doAdaBoostStep(wghts, bestFeat.alpha, H, y);
%   
%   % Check responses
%   resp = evalBoosted(featList, nFeatures, X);
%   
%  
%   
%   % Histogram of boosted detector responses
%   if (any(y >0) & any(y == 0))
%     [hTarg, hxTarg] = histo(resp(y>0), 101);
%     hTarg = hTarg/(sum(hTarg) * (hxTarg(2) - hxTarg(1)));
%     [hNon, hxNon] = histo(resp(y==0), 101);
%     hNon = hNon/(sum(hNon) * (hxNon(2) - hxNon(1)));
% 
%     figure(2); clf;
%     plot(hxTarg, hTarg, 'g');
%     hold on;
%     plot(hxNon, hNon, 'r');
%     title(sprintf('Hist of Boosted Responses, Targ/Non (g/r), nFeat = %d', ...
%                   nFeatures));
%     xlabel('Response');
%     ylabel('Probability');
%    
%   
%     fprintf('True/False Pos. Rates: %f, %f\n', ...
%             sum(resp(y>0) >0)/sum(y>0), sum(resp(y==0) >0)/sum(y==0));
%     %pause;
%   end
%   
% end
% 
% 
% save('adaFit.mat', 'nFeatures', 'featList');
% 
% pause;

% The rest of the code is yours....

clear
load('adaFit');

load('testSet');
%load('trainSet');
testImSz = sizeIm;

%% %%%%%%%%%
% Do brightness normalization
% %%%%%%%%%%
testTarg = rescaleImageVectors(testEyeIm);
testNon = rescaleImageVectors(testNonIm);
%testTarg = rescaleImageVectors(eyeIm);
%testNon = rescaleImageVectors(nonIm);
nTarg = size(testTarg,2);
nNon = size(testNon, 2);

X = [testTarg testNon];
y = [ones(1, nTarg) zeros(1, nNon)];
K= size(X,2);

response = zeros(1, K);

colorSet = hsv(nFeatures*0.6); % change 0.6 to account for number of features to print

set(gca, 'ColorOrder', colorSet);
hold all;
figure(1); clf;
title('DET Plot');
xlabel('Flase Alarm Rate (%)');
ylabel('Miss Rate (%)');
grid on;
hold all;
for m = 1:nFeatures/2 %I only need to print half of the features to see the trend
      
    f=buildGaussFeat(featList(m));
    r = f(:)' * X;
    if featList(m).abs
        r = abs(r);
    end

    if featList(m).parity == 1
        h = r <= featList(m).thres;
    else 
        h = r > featList(m).thres;
    end

    response = response + featList(m).alpha*(2*h - 1);
    if mod(m, 5) == 0 
        n =1;
        for t = min(response):0.2:max(response)
            response_t = zeros(1,K);
            response_t(find(response>t)) = 1;
            fn(n) = sum(response_t(y>0)==0)/sum(y>0); % false negative
            fp(n) = sum(response_t(y==0) >0)/sum(y==0); % false positive
            n = n+1;
        end
    
        
        plot(100*fp, 100*fn,'LineWidth',2,'color',colorSet(m,:));
        axis ( [0.1 100 0.1 100] );
        set(gca, 'XScale', 'log', 'YScale', 'log')

        legendS{m/5} = ['nFeature = ' num2str(m)];
        pause(0.01); 
        legend(legendS);
    end
end


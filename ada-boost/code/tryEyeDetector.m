%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File: tryEyeDetector.m
%  Matlab script file
%  Date: Oct, 08
%

% Dependencies, Toolboxes:
%      iseToolbox/
% Author: YOU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Check Path and Constants  %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%run('/Users/ansonliang55/Dropbox/UOT/CSC2503/matlab/startup.m')
if ~exist('buildGaussFeat','file')
  addpath('./util');
end

%  Check path.  If these aren't on your path, then you will need
%  to add these toolboxes to your path.  Use the startup m-file provided
%  at the beginning of the course.
which pgmRead          % should be in iseToolbox\pyrTools\MEX\

im = pgmRead('tryEye.pgm');

figure(1); clf;
showIm(im);
hold on

load('adaFit');
while true
    fprintf(1,'Mouse in a box now...\n');
    rec=round(ginput(2));
    if rec(1,1)>rec(2,1) || rec(1,2)>rec(2,2)
      fprintf(1,'Box input error! Please select top left first then bottom right corner...\n');
      break;
    end
    imCrop = im(rec(1,2):rec(2,2), rec(1,1):rec(2,1));
    imCrop = rescaleImageVectors(imCrop);
    
    xMax = size(imCrop,2) - 20;
    yMax = size(imCrop,1) - 25;

    X = zeros(500, xMax*yMax);
    location = zeros(2, xMax*yMax);
    K=1;
    for j = 1:yMax
        for i = 1:xMax
           patch = imCrop(j:j+24,i:i+19);
           X(:,K) = patch(:);
           location(1,K) = i + 10;
           location(2,K) = j + 12;
           K=K+1;
        end
    end

    K= size(X,2);
   
    response = zeros(1, K);

    for m = 1:nFeatures

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

        response = response + featList(m).alpha*(2*h-1);
    end
    
    xRange = xMax-1;
    yRange = yMax-1;
    t = 10.5;
    targets = find(response>t);
    targetFound = size(targets,2);
    for i=1:targetFound
       target = targets(i);
       xCirCenter =  location(1,target) + rec(1,1);
       yCirCenter =  location(2,target) + rec(1,2);
       
       rectangle('position',[rec(1,1),rec(1,2),size(imCrop,2),size(imCrop,1)],'EdgeColor', 'y')
       hold on
       scatter(xCirCenter,yCirCenter, pi*5^2, 'g');
    end
    hold off
end

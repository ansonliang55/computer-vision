function [L] = fitChromeSphere(chromeDir, nDir, chatty)
  % [L] = fitChromeSphere(chromeDir, nDir, chatty)
  % Input:
  %  chromeDir (string) -- directory containing chrome images.
  %  nDir -- number of different light source images.
  %  chatty -- true to show results images. 
  % Return:
  %  L is a 3 x nDir image of light source directions.

  % Since we are looking down the z-axis, the direction
  % of the light source from the surface should have
  % a negative z-component, i.e., the light sources
  % are behind the camera.
  if ~exist('chatty', 'var')
    chatty = false;
  end
    
  mask = ppmRead([chromeDir, 'chrome.mask.ppm']);
  mask = mask(:,:,1) / 255.0;
  
  for n=1:nDir
    fname = [chromeDir,'chrome.',num2str(n-1),'.ppm'];
    im = ppmRead(fname);
  	imData(:,:,n) = im(:,:,1);           % red channel
    
  end
  
  % YOU NEED TO COMPLETE THIS FUNCTION
  
  % Determine the center of the chrome sphere
  % Method: 1. find all the points with max brightness
  %         2. take the average of the location in col and row to find x
  %            and y
  %         3. take the right most bright pixel minus left most bright 
  %            pixel divided by 2 to get radius
  maxpix = max(max(mask));
  [pRow pCol] = find(maxpix == mask);
  yCenter = mean(pRow);
  xCenter = mean(pCol);
  center = [xCenter, yCenter];
  radius = double((max(pCol) - min(pCol))/2);

  
  % Using Phongs model with direct specular
  R = [0 0 -1.0];
  L=[];
  for i=1:nDir
  	% 1. find the brightest spot in the image (strongest reflection point)
  	maxpix = max( max( imData(:,:,i) ) );
    [pRow, pCol] = find(maxpix == imData(:,:,i));
    pointX = mean(pCol);
    pointY = mean(pRow);
    reflectP = [pointX, pointY];
    % determine the normal at pointX and pointY
    normal = reflectP - center;
    normal(3) = -sqrt(radius^2 - norm(normal)^2);
    normalize_N = normal/norm(normal);
    % use specular reflection equation to find L
    A =2*dot(normalize_N,R)*normalize_N - R;
    L(:,i)=A/norm(A);
  end
  
  
  % END IMPLEMENTATION 

  return ;


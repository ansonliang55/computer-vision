function [circles] = getProposals(normals, p, numGuesses)
  % [circles] = getProposals(normals, p, numGuesses)
  % Attempt to produce up to numGuesses circle proposals from
  % the edgel data p and normals.  For typical data sets
  % we will be able to produce numGuesses proposals.  However,
  % on some datasets, say with only a few edgels, we may not be
  % able to generate any proposals.  In this case size(circles,1)
  % can be zero.
  % Input:
  %  normals - N x 2 edgel normals
  %  p         N x 2 edgel positions
  %  numGuesses - attempt to propose this number of circles.
  % Return:
  %   circles a P x 3 array, each row contains [x0(1) x0(2) r]
  %           with 0 <= P <= numGuesses.
  
  
  % YOU NEED TO FILL IN CODE HERE.
  
  binSize=2; % set this to only even number
  [numEdgels dimen] = size(p);
  xmin = min(p(:,1));
  xmax = max(p(:,1));
  ymin = min(p(:,2));
  ymax = max(p(:,2));
  rmax= ceil(sqrt((xmax-xmin)^2+ (ymax-ymin)^2));
  
  %define the hough transform space
  hSpace = zeros(xmax, ymax, rmax);
 
  %calculate vote on every pixels using all the egels
  for n=1:numEdgels
     point = p(n,:);
     normal = normals(n,:);
     m = normal(2)/normal(1);
     
     %determine the angle in polar coordinate given the normal
     if normal(1) < 0
         angle = atan(m);
     else
         if normal(1) > 0 
             if normal(2) >= 0
                 angle = atan(m) + pi;
             else
                 angle = atan(m) - pi;
             end
         else
             if normal(2) >= 0
                 angle = pi/2;
             else
                 angle = -pi/2;
             end
         end
     end
     %vote on every pixels for every r increment
     for r=2:rmax
         x0 = round(point(1) - r*cos(angle));
         y0 = round(point(2) - r*sin(angle));
         if(x0 < xmax && y0 < ymax && x0 > 0 && y0 >0 )
            hSpace(x0, y0, r) = hSpace(x0, y0, r) + 1;
         end
     end
  end
  
  % transform the 3D (x, y, r) hough space to 2D to find the circle center (x, y)
  sumHSpace = zeros(xmax,ymax);
  for x=1:xmax
      for y=1:ymax
          sumHSpace(x,y) = sum(hSpace(x,y,:));
      end
  end
  
  % set bin size to sum up votes in binSize x binSize (reduce noise)
  sumHSpace2 = zeros(xmax,ymax);
  for x=binSize:binSize:(xmax-binSize/2)
      for y=binSize:binSize:(ymax-binSize/2)
          sumHSpace2(x-binSize/2,y-binSize/2) = sum(sum(sumHSpace((x-binSize/2):(x+binSize/2), (y-binSize/2):(y+binSize/2))));
      end
  end
  numDetected = 9999;
  threshold = 30;
  % find peaks to determine the potential circle center
  while(numDetected > numGuesses || numDetected == 0)
      
      y0detect = []; x0detect = [];
      maxPixel = imregionalmax(sumHSpace2);
      [Potential_x0 Potential_y0] = find(maxPixel == 1);
      houghSpaceTemp = sumHSpace2 - threshold;
      
      for cnt = 1:length(Potential_y0)
          if houghSpaceTemp(Potential_x0(cnt),Potential_y0(cnt)) >= 0
              y0detect = [y0detect;Potential_y0(cnt)];
              x0detect = [x0detect;Potential_x0(cnt)];
          end
      end
      [numDetected ind] = size(y0detect);
      
      if numDetected == 0
          threshold = threshold - 2;
      else 
          threshold = threshold + 5;
      end
  end
  
  % store the circle center and use the center to find the radius peak (max
  % voted radius) as the circle radius
  for i=1:numDetected
     
      circles(i,1) = x0detect(i);
      circles(i,2) = y0detect(i);
      [count,radius] = max(hSpace(x0detect(i),y0detect(i),:));
      circles(i,3) = radius;
  end

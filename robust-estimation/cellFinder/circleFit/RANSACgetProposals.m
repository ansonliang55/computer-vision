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
  
  %%RANSAC
  % YOU NEED TO FILL IN CODE HERE.
  [numEgels dimen] = size(p);
  b =zeros(2,1);
  A =ones(2,2);
  xc = zeros(2,1);
  xRange = range(p(:,1));
  yRange = range(p(:,2));
  minRange = min(xRange, yRange);
  threshold = numGuesses*10; 
  
  i = 1;
  numLoop = 1;
  while (numLoop < threshold && i <= numGuesses)
 % while (numEgels> 1&& i <= numGuesses)    
      randp1 = randi(numEgels);
      normal1 = normals(randp1,:);
      point1 = p(randp1,:);
      
      randIt = 0;
      while randIt < 10  
          randp2 = randi(numEgels);

          if(randp1~=randp2 && (norm(p(randp1,:)-p(randp2,:)) < 10)) 
            normal2 = normals(randp2,:);
            point2 = p(randp2,:);  
            break; 
          end
          randIt = randIt+1;
          if(randIt == 10) 
            tempP = p;
            tempNormal = normals;
            tempP([randp1],:)=[];%delete
            tempNormal([randp1],:)=[];%delete

            % Find the nearest point to point1
            bxf = bsxfun(@minus,tempP(:,1:2),point1); 
            [dist, randp2] = min(hypot(bxf(:,1),bxf(:,2)));
            normal2 = normals(randp2,:);
            point2 = p(randp2,:);  
          end        
      end
      
      point1(3) = 1; % to homogeneous coordinate
      point2(3) = 1; % to homogeneous coordinate
      % find l1 and l2 for the line spec
      l1(1) = -normal1(2);
      l1(2) = normal1(1);
      l1(3) = -(l1(1) *point1(1) + l1(2)*point1(2));
      l2(1) = -normal2(2);
      l2(2) = normal2(1);
      l2(3) = -(l2(1) *point2(1) + l2(2)*point2(2));
      
      % find intersection point between the two line
      xc = cross(l2, l1);
      xc = [xc(1)/xc(3), xc(2)/xc(3)];
          radius1 = sqrt((point1(1) - xc(1))^2 + (point1(2) - xc(2))^2);
          radius2 = sqrt((point2(1) - xc(1))^2 + (point2(2) - xc(2))^2);
          radius = min(radius1,radius2);
          rRatio = radius1/radius2;

          normalc1 = point1(1:2)-xc;
          normalc1 = normalc1/norm(normalc1);

          normalc2 = point2(1:2)-xc;
          normalc2 = normalc2/norm(normalc2);

          dirToward1 = dot(normalc1, normal1);
          dirToward2 = dot(normalc2, normal2);

          if (dirToward1 < 0 && dirToward2 < 0 && rRatio < 1.2 && rRatio > 0.8)
            circles(i,1:2) = xc;
            circles(i,3) = radius;%maybe average?
            i = i+1;
          end
      numLoop = numLoop +1;
  end
  

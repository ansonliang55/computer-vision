function [goodCircle] = isGoodCircle(x0, r, w, ...
                                     circleEstimates, nFound)
  % [goodCircle] = isGoodCircle(x0, r, w, normals, ...
  %                                  circleEstimates, nFound)
  % Decide if the circle with parameters x0 and r, with fitted
  % weights w, is to be added to the current set of circles.
  % Input:
  %  x0 2-vector for circle center
  %  r  radius of circle
  %  w  robust weights of edgels supporting this circle,
  %     weights have been scaled to have max possible value 1.
  %  circleEstimates C x 3 array of circle parameters, the first
  %     nFound rows of which specifies the [x0(1), x0(2) r] parameters
  %     for a previously fitted circle for this data set.
  %  nFound the number of previously fitted circles stored in circleEstimates
  % Output:
  %  goodCircle boolean, true if you wish to add this circle to the
  %             list of previously fitted circles.
  
  x0 = x0(:);  % Decide, row or column
  % YOU FINISH THIS
  
  goodCircle = true;
  if nFound == 0
      circumf = 2*pi*r;
      sumW = sum(w)
  
      % for circle at the edge we want to determine that arc that is
      % removed by the edge of the image so we can scale the threshold
      % later
      sizeWindow = [640 512];
      croppedArc1 = 0;
      croppedArc2 = 0;
      if(abs(sizeWindow(1) - x0(1)) < r);
         croppedArc1 = acos((sizeWindow(1)-x0(1))/r);
      elseif abs(x0(1)) < r
         croppedArc1 = acos(x0(1)/r); 
      end
      if(abs(sizeWindow(2) - x0(2)) < r)
         croppedArc2 = acos((sizeWindow(2)-x0(2))/r);
      elseif abs(x0(2)) < r
         croppedArc2 = acos(x0(2)/r); 
      end

      if(croppedArc1 ~= 0 && croppedArc2 ~= 0) 
          croppedArc = croppedArc1 + croppedArc2;
      else
          croppedArc = 2* croppedArc1 + 2 * croppedArc2;
      end
      
      %if weight fall below the threshold value this circle is evaluated to
      %be bad
      threshold = 0.25*(2*pi-croppedArc)/(2*pi)*circumf;
      if (sumW < threshold)
        goodCircle = false;
        a = 'weight'
        return;
      end
  end
  sumAngle = 0;
  for i=1:nFound
      x1 = circleEstimates(1:2,i);
      r1 = circleEstimates(3,i);
      dist = norm(x0-x1);
      smallR = min(r, r1);
      bigR = max(r,r1);
      totalR = smallR + bigR;
      
      %for circles that are too close we simply just say its bad
      if dist <= bigR
          a = 'dist'
          goodCircle = false;
          return;
      else
          % for intersected circle we calculate the total intersected angle
          % with all the found circle, if it pass pi we will say this
          % circle is bad
          if dist < totalR
            d1 =(dist^2 - r^2 + r1^2 )/(2*dist);
            angle = 2 * asin(abs(d1/r));
            sumAngle = sumAngle + angle;
            if sumAngle > pi
                goodCircle = false;
                a = 'angle'
                return;
            end
          end
      end
  end
    
  
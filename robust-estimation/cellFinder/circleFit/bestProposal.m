function [circle] = bestProposal(circles, sigmaGM, normals, p)
% [circle] = bestProposal(circles, sigmaGM, normals, p)
% Chose the best circle from the proposed circles.
% Input
%  circles K x 3 matrix each row containing [x0(1), x0(2), r] for 
%          the center and radius of a proposed circle.
%  sigmaGM - the robust scale parameter 
%  normals - P x 2 edgel normal data
%  p       - P x 2 edgel position data.
% Output
%  circle  1 x 3  best circle params [x0(1), x0(2), r] from the proposals
  
  % YOU COMPLETE THIS

  % find the least sumGM circle as the bestProposal
  [numEgels dimen] = size(p);
  [numGuessCircle dimenCircle] = size(circles);
  minSumGM = 9999;
  for n=1:numGuessCircle
      sumGM = 0;
      for i=1:numEgels
        error = (norm(p(i,:)-circles(n,1:2)))^2 - circles(n,3)^2;
        GM = error^2/(sigmaGM^2 + error^2);
        sumGM = sumGM + GM;
      end
      
      if minSumGM > sumGM
          minSumGM = sumGM;
          circle = circles(n,1:3);
      end
      
  end
  
 
  
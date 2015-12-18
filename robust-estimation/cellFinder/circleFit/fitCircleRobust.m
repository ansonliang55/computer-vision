function [x0, r, w, maxW] = fitCircleRobust(pts, initx0, initr, normals, sigmaGM)
%
% function [x0, r, w, maxW] = fitCircleRobust(pts, initx0, initr,
%                                  normals, sigmaGM)
%
%  minimize sum_i  rho( a'x_i + b + x_i'x_i, sigma)
%  w.r.t. a and b, where a = -2x_0 and b = x_0'x_0 - r^2
% Input:
%  pts: an Nx2 matrix containing 2D x_i, i=1...N
%  initx0: 2-vector initial guess for centre
%  initr: initial guess for radius 
%  normals: an Nx2 matrix of corresponding 2D edge normal directions nrml_i  
% Output
%  x0 - 2x1 fitted circle's center position
%  r  - fitted circle's radius
%  w  - N x 1 robust weights for edgels.
%  maxW  - maximum possible robust weight (i.e. for zero error)
%          This may be used by the calling code to scale the weights 
%          to be between 0 and 1.
  
% FINISH THIS CODE
x0 = initx0(:)';  % Make it a row vector.
[numPoints dimen] = size(pts);
a = -2*x0;
b = x0 * x0' - initr^2;
preConvSum = 0;
for n=1:30
    W = zeros(numPoints, numPoints);
    A = ones(numPoints, 3);
    B = zeros(numPoints, 1);

    for i=1:numPoints
        error = dot(a, pts(i,:)) + b + dot(pts(i,:),pts(i,:));
        w(i) = (sigmaGM/(sigmaGM^2 + error^2))^2; % P*1
        % This is a P*P matrix which used for later calculation, the effective
        % weight lies on the diagonal
        A(i, 1:2) = pts(i,:);
        B(i) = dot(pts(i,:),pts(i,:));
    end

    % cover w array to diagonal matrix
    W(logical(eye(size(W)))) = w;
    
    p = (transpose(A) * W * A)^-1 * (-transpose(A)*W*B);
    a = p(1:2);
    b = p(3);
    
    % break the loop if we detect convergence smaller than 0.5 
    convSum = sum(p);
    if( n > 4 ) 
        if abs(convSum - preConvSum) < 1/2 
            break;
        end
        preConvSum = convSum;   
    end
end
maxW = max(w);
x0 = a./(-2); 
r = sqrt(dot(x0,x0)-b);


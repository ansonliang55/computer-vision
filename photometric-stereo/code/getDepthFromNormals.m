function [depth] = getDepthFromNormals(n, mask)
  % [depth] = getDepthFromNormals(n, mask)
  %
  % Input:
  %    n is an [N, M, 3] matrix of surface normals (or zeros
  %      for no available normal).
  %    mask logical [N,M] matrix which is true for pixels
  %      at which the object is present.
  % Output
  %    depth an [N,M] matrix providing depths which are
  %          orthogonal to the normals n (in the least
  %          squares sense).
  %
  [N M] = size(mask);
  depth = zeros(N,M);
  index = zeros(N,M);
  
  %find the rows and col position in the mask
  [maskPixelRow maskPixelCol] = find(mask);
  numMaskPixels=size(maskPixelRow,1);
  
  %label each pixel in the mask region with a index so we can retrieve this
  %index later by inputing position in the index array (equal size as
  %the original image).
  for i=1:numMaskPixels
      index(maskPixelRow(i),maskPixelCol(i))=i;
  end
  
  A = sparse(2*numMaskPixels, numMaskPixels);
  v = zeros(2*numMaskPixels, 1);
 
  % Generate the sparse matrix
  for i=1:numMaskPixels
      Y = maskPixelRow(i);
      X = maskPixelCol(i);
      Nx = n(Y,X,1);
      Ny = n(Y,X,2);
      Nz = n(Y,X,3);
      
      % setting the first constrain in the x direction, if the pixel reach
      % the right most pixel of the mask region, we use the one on the left
      % instead
      if(index(Y,X+1) >0) 
          A(2*i - 1, index(Y,X)) = 1;
          A(2*i - 1, index(Y,X+1)) = -1;
          v(2*i - 1, 1) = Nx/Nz;
      elseif (index(Y, X-1) > 0)
          A(2*i - 1, index(Y,X)) = 1;
          A(2*i - 1, index(Y,X-1)) = -1;
          v(2*i - 1, 1) = -Nx/Nz;
      end
      
      % setting the second constrain in the y direction, if the pixel reach
      % the bottom most pixel of the mask region, we use the one above
      % instead
      if(index(Y+1,X) >0) 
          A(2*i, index(Y,X)) = 1;
          A(2*i, index(Y+1,X)) = -1;
          v(2*i, 1) = Ny/Nz;
      elseif (index(Y-1, X) > 0)
          A(2*i, index(Y,X)) = 1;
          A(2*i, index(Y-1,X)) = -1;
          v(2*i, 1) = -Ny/Nz;
      end
  end
  
  % use least square method to solve for the depth
  z = A\v;
  for i=1:numMaskPixels
      depth(maskPixelRow(i), maskPixelCol(i))=z(i);
  end
  
  
  % YOU NEED TO COMPLETE THIS.

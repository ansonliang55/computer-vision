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
  imsize = size(mask);
  [N M D]=size(n);
  depth = zeros(N,M);
  
  [maskPixelsRow maskPixelsCol] = find(mask);
  maskPixels = [maskPixelsRow maskPixelsCol];
  
  
  % YOU NEED TO COMPLETE THIS.

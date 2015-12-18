function [n, albedo] = fitReflectance(im, L)
  % [n, albedo] = fitReflectance(im, L)
  % 
  % Input:
  %   im - nPix x nDirChrome array of brightnesses,
  %   L  - 3 x nDirChrome array of light source directions.
  % Output:
  %   n - nPix x 3 array of surface normals, with n(k,1:3) = (nx, ny, nz)
  %       at the k-th pixel.
  %   albedo - nPix x 1 array of estimated albdedos
    

  % YOU NEED TO COMPLETE THIS

  
  [npixel npic] = size(im);
  n=[];
  albedo=zeros(npixel,1);
  L = L';
  
  % calculate normal for every single pixels in the cropped image data
  for i=1:npixel
    I = im(i,:)';
    
    % Use least square method to solve for G
    G = L\I;
    
    % perform check to avoid NaN result if I is too dark, we set those
    % the normal and albedo to 0
    if( norm(I) < 1.0E-06) 
      albedo(i,1)=0;
      n(i,:)=[0 0 0];
    else
      % the solved G magnitude is albedo and the unit vector is normal
      albedo(i,1)=norm(G');
      n(i,:)=G'/albedo(i);
    end
  end
  
  return;



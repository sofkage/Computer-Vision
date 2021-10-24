function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%
%
assert(ndims(I)==2,'input image should be grayscale');

F = [-1,0,1]; %x derivative filter 
F_trans = transpose(F); %y derivative filter 

dx = imfilter(I, F, 'replicate');  
dy = imfilter(I, F_trans, 'replicate');

mag = sqrt(dx.^2 + dy.^2);
ori = atan2(dy, dx).*-180/pi;
mag(isnan(ori)) = 0;
ori(isnan(ori)) = 0;

figure;
imagesc(mag)
colormap jet
colorbar
title('Magnitude');

figure;
imagesc(ori)
colormap jet
colorbar
title('Orientation');

assert(all(size(mag)==size(I)),'gradient magnitudes should be same size as input image');
assert(all(size(ori)==size(I)),'gradient orientations should be same size as input image');

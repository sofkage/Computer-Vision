function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambiguous which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

[filter_row, filter_col] = size(filter); % get the dimensions of the filter
[im_row, im_col,channel] = size(image);  % get the dimensions of the image

if rem(filter_row,2) == 0 || rem(filter_col,2) == 0 % throw error if the filter size is even
    error("Error! Filter size is even");
end

image_padded = padarray(image,[floor(filter_row/2),floor(filter_col/2)],0,'both'); % image padding

% conv

conv_index_row = 1;
conv_index_column = 1;
for row = 1:im_row
    for col = 1:im_col
        image_temp = image_padded(row: row + filter_row -1 , col : col + filter_col - 1,:);
        for channel = 1:channel
            conv_image(conv_index_row,conv_index_column,channel) = sum(sum(filter .* image_temp(:,:,channel)));
        end        
        conv_index_column = conv_index_column +1;
    end
    conv_index_column = 1;
    conv_index_row = conv_index_row +1;
end
output = conv_image;



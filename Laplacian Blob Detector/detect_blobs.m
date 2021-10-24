function detect_blobs(img,sigma,k,levels,threshold,method)

    sigma_init = sigma;
    [h,w] = size(img);

    %-------------filter size of the Laplacian of Gaussian---
    filter_size = 2*ceil(3*sigma)+1;
    %filter = fspecial('log', filter_size, sigma);

    %-------- make place --------------
    scale_space = zeros(h,w,levels);

    %---------- Method 1 : Increasing filter size ---------------
    if method == 1
        tic
        for i=1:levels

             filter = fspecial('log', filter_size, sigma); %1st level 
             filter = filter.* (sigma^2); % Scale Normalized Laplacian

         %    figure; % check window size
         %    surf(abs(filter),'EdgeColor','none');

             im_filtered = imfilter(img, filter,'replicate');  
             im_filtered = im_filtered.^2;
             sigma = k * sigma;     %increasing s for next level 
             filter_size = 2*(ceil(3*sigma)) + 1; %new filter size 
             scale_space(:,:,i) = im_filtered; %storing 

        end
        toc
    end

    %---------- Method 2 : keeping filter size constant ---------
    %---------------and downsampling the image ---------------

    if method == 2
        tic
        filter_constant = fspecial('log', filter_size, sigma).*(sigma^2);
     %   figure; % check window size
     %   surf(abs(filter_constant),'EdgeColor','none');
        for i=1:levels

             img_down = imresize(img,(1/(k^(i-1))),'bicubic'); %Decreasing image size 
             im_filtered = imfilter(img_down, filter_constant,'replicate'); %Applying the Laplacian of Gaussian filter 
             im_filtered = imresize(im_filtered, [h w],'bicubic'); %resize to original size 
             im_filtered = im_filtered.^2; %square of log
             scale_space(:,:,i) = im_filtered; %storing

        end
        toc
    end 

    %-------------- Non Maxima Supression on 2D layers ----------
    % Perform Non-Maximum Suppression for each Scale-Space Slice
    %fun = @(x) max(x(:));

    suppression_size = 5; 
    max_scale = zeros(h, w, levels); % NMS output for each level

    for i=1:levels  
        max_scale(:,:,i) = (ordfilt2(scale_space(:,:,i), suppression_size^2, ones(suppression_size)));
        %max_scale(:,:,i) = (nlfilter(scale_space(:,:,i), [3 3], fun));
        %max_scale(:,:,i) = (colfilt(scale_space(:,:,i), [3 3], fun));
    end

    %------------- Non Maxima Supression between all 2D layers -------------
    %Non-Maximum Suppression between Scales 
    %comparing the current one with the previous and next one, choose the maximum of the three

    for i=1:levels
        max_scale(:,:,i) = max(max_scale(:,:,max(i-1,1):min(i+1,levels)),[],3); %operates along the dimension 3.
    end
    

    %----------- drawing circles on the image
    maxima = zeros(h,w,levels);
    radius =[]; 
    x =[]; %x axis blob
    y =[]; %y axis blob

    for i=1:levels 

        % Zero Out All Positions that are not the Local Maxima 
        maxima(:,:,i) = max_scale(:,:,i).*(max_scale(:,:,i)==scale_space(:,:,i));

        % setting a threshold
        [row,col] = find(maxima(:,:,i)>= threshold);

        x = cat(1,x,row); %concat x and r along dim 1
        y = cat(1,y,col); %concat y and c along dim 1
        blob_num = length(row);

        rad_array = sqrt(2) * sigma_init * k^(i-1); 
        rad_array = repmat(rad_array,blob_num,1);
        radius = cat(1,radius,rad_array);  
        
    end
    
    %------------------ Show cyrcles --------------------
    figure
    show_all_circles(img,y,x,radius,'r',1.5);

end


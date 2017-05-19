%% Clear the environment
clc;
clear;

%% Read the images
im1 = imread('/Users/kchak/Google Drive/NYU/Spring 2017/Computer Vision/Assignment/4/toy-car-images-bw/toy_formatted2.png');
im2 = imread('/Users/kchak/Google Drive/NYU/Spring 2017/Computer Vision/Assignment/4/toy-car-images-bw/toy_formatted3.png');

% Uncomment for reading our own images. 
% im1=imread('/Users/kchak/Google Drive/NYU/Spring 2017/Computer Vision/Assignment/4/beanbags/frame08.png');
% im2=imread('/Users/kchak/Google Drive/NYU/Spring 2017/Computer Vision/Assignment/4/beanbags/frame09.png');

%% Smoothen images
i1_double = double(im1);
i2_double = double(im2);

i1_smoothed = double(gaussian_filter(im1, 1.0));
i2_smoothed = double(gaussian_filter(im2, 1.0));

%% Estimate the parameters

[fx, fy, ft] = computeDerivatives(i1_smoothed, i2_smoothed);
% [fx, fy, ft] = computeDerivatives(double(im1), double(im2));
figure;
imshow(fx);
title('Spatial Derivative in X');
figure;
imshow(fy);
title('Spatial Derivative in Y');
figure;
imshow(ft);
title('Temporal Derivative');

%% Algorithm

image_size = size(i1_smoothed);
rows = image_size(:,1);
cols = image_size(:,2);

spatial_gradient = zeros(rows, cols, 2);
spatial_gradient(:,:,1) = fx;
spatial_gradient(:,:,2) = fy;

velocity_vector = zeros(rows,cols,2);

for i=1:rows-1
    for j= 1:cols-1
        
        A = [
                fx(i,j),fy(i,j);
                fx(i,j+1),fy(i,j+1);
                fx(i+1,j),fy(i+1,j);
                fx(i+1,j+1),fy(i+1,j+1)
            ];
        
        b = [
                ft(i,j);
                ft(i,j+1);
                ft(i+1,j);
                ft(i+1,j+1)
            ];
        
        C = pinv(A'*A);
        
        velocity_vector(i,j,:) = -C*A'*b;
        
    end;
end;

velocity_vector(isnan(velocity_vector))=0;

%% Plot the vectors
figure;
imshow(im1);
hold on;
quiver(velocity_vector(1:1:rows,1:1:cols,1),velocity_vector(1:1:rows,1:1:cols,2),5);
title('Individual u and v vectors for each pixel');
plotFlow(velocity_vector(:,:,1), velocity_vector(:,:,2), im1, 5, 5); 
title('Combined u and v vectors for each pixel');
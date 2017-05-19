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

i1_smoothed = double(gaussian_filter(im1, 2.0));
i2_smoothed = double(gaussian_filter(im2, 2.0));

%% Estimate the parameters

[fx, fy, ft] = computeDerivatives(i1_smoothed, i2_smoothed);

figure;
imshow(fx)
title('Spatial Derivative in X');

figure;
imshow(fy);
title('Spatial Derivative in Y');

figure;
imshow(ft);
title('Temporal Derivative');

%% Calculate the Normal Vectors

image_size = size(i1_smoothed);
rows = image_size(:,1);
cols = image_size(:,2);

spatial_gradient = zeros(rows, cols, 2);
spatial_gradient(:,:,1) = fx;
spatial_gradient(:,:,2) = fy;

normal_vector = zeros(rows, cols, 2);
for i = 1:rows
    for j=1:cols
        temp = [spatial_gradient(i,j,1); spatial_gradient(i,j,2)];
        normal_vector(i,j,:) = - ft(i,j) * ( spatial_gradient(i,j,:) / (norm(temp))^2 );
    end
end

normal_vector(isnan(normal_vector))=0;

%% Plot the vectors
figure;
imshow(im1);
hold on;
quiver(normal_vector(1:1:rows,1:1:cols,1),normal_vector(1:1:rows,1:1:cols,2),5);
title('Individual u and v vectors for each pixel');
plotFlow(normal_vector(:,:,1), normal_vector(:,:,2), im1, 5, 5); 
title('Combined u and v vectors for each pixel');
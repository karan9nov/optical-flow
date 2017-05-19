%% Clear the environment
clc;
clear;

%% Read the images
im1=imread('/Users/kchak/Google Drive/NYU/Spring 2017/Computer Vision/Assignment/4/toy-car-images-bw/toy_formatted2.png');
im2=imread('/Users/kchak/Google Drive/NYU/Spring 2017/Computer Vision/Assignment/4/toy-car-images-bw/toy_formatted3.png');

% Uncomment for reading our own images. 
% im1=imread('/Users/kchak/Google Drive/NYU/Spring 2017/Computer Vision/Assignment/4/beanbags/frame08.png');
% im2=imread('/Users/kchak/Google Drive/NYU/Spring 2017/Computer Vision/Assignment/4/beanbags/frame09.png');

%% Smoothen images

im1=double(im1);
im2=double(im2);

im1_smoothed=double(gaussian_filter(im1,1));
im2_smoothed=double(gaussian_filter(im2,1));

%% Set initial parameters.

% Set initial value for the flow vectors
u = 0;
v = 0;

% Estimate spatiotemporal derivatives
[fx,fy,ft] = computeDerivatives(im1_smoothed,im2_smoothed);

%% HS Algorithm

% Averaging kernel
kernel=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12];
alpha=2;
% Iterations
for i=1:200
    % Compute local averages of the flow vectors
    uAvg=conv2(u,kernel,'same');
    vAvg=conv2(v,kernel,'same');
    % Compute flow vectors constrained by its local average and the optical flow constraints
    u= uAvg - ( fx .* ( ( fx .* uAvg ) + ( fy .* vAvg ) + ft ) ) ./ ( alpha^2 + fx.^2 + fy.^2); 
    v= vAvg - ( fy .* ( ( fx .* uAvg ) + ( fy .* vAvg ) + ft ) ) ./ ( alpha^2 + fx.^2 + fy.^2);
end

u(isnan(u))=0;
v(isnan(v))=0;

%% Plot the Flow

plotFlow(u, v, im1, 5, 5);
title('Flow vectors for each pixel');
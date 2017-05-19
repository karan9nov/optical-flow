function [fx, fy, ft] = computeDerivatives(i1_smoothed,i2_smoothed)

% FIRST WAY TO CALCULATE DERIVATIVES
image_size = size(i1_smoothed);
rows = image_size(:,1);
cols = image_size(:,2);

ft = i2_smoothed - i1_smoothed;

fx = zeros(rows,cols);

for i = 2:rows
    for j = 1:cols
        fx(i,j) = double(i1_smoothed(i,j) - i1_smoothed(i-1,j));
    end
end 

fy = zeros(rows,cols);
for i = 1:rows
    for j = 2:cols
        fy(i,j) = double(i1_smoothed(i,j) - i1_smoothed(i,j-1));
    end
end

% SECOND WAY TO CALCULATE DERIVATIVES
fx = conv2(i1_smoothed,[1 -1]);
fx = fx(:,1:end-1);
fy = conv2(i1_smoothed,[1; -1]);
fy = fy(1:end-1,:);
ft= i2_smoothed-i1_smoothed;
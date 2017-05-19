function plotFlow(u, v, imgOriginal, rSize, scale)

figure();

%Image Scaling
if sum(sum(imgOriginal))~=0
    imshow(imgOriginal,[0 255]);
    hold on;
end

% Enhance the quiver plot visually by showing one vector per region
for i=1:size(u,1)
    for j=1:size(u,2)
        if floor(i/rSize)~=i/rSize || floor(j/rSize)~=j/rSize
            u(i,j)=0;
            v(i,j)=0;
        end
    end
end

quiver(u, v, scale, 'color', 'b', 'linewidth', 2);
set(gca,'YDir','reverse');
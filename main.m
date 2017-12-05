%% ACTIVE CONTOUR SEGMENTATION
% w.opoczynski 2017r 
% main script

%folder 
cd 'C:\Users\Wojtek\source\repos\PI';
clear; clc; close all;

image = imread('airplane.jpg');

% create mask 
 % jak sie da za duza maske to leci w kosmos na gpu
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true;
%% for large images rescale
% image = imresize(image,.5);
% mask = imresize(mask,.5);  

%%
subplot(2,2,1); imshow(image); title('Input');
subplot(2,2,2); imshow(mask); title('Maska');
subplot(2,2,3); title('Segmentacja');

%% params 
iterations = 600;
radius = 50;
smooth = 0.2;
display = true;
threheads = 4;
parameters = struct('image',image,'initMask',mask,'maxIterations',...
    iterations,'radius', radius,'smooth', smooth,'display', display,...
   'threheads', threheads);


result = localizedSeg(parameters);
resultCPU = localizedSegParallel(parameters);  
resultGPU = localizedSegParallelGPU(parameters);
imageOutGpu = gather(resultGPU);
clear resultGPU;

%% wyniki
figure(1);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja');
subplot(2,2,4);
imshow(result);
title('Wynik CPU');

figure(2);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja');
subplot(2,2,4);
imshow(resultCPU);
title('Wynik CPU multithread.');

figure(3);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja');
subplot(2,2,4); imshow(imageOutGpu);
title('Wynik GPU');



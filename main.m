cd 'C:\Users\Wojtek\source\repos\PI';
clear; clc; close all;

image = imread('plane.jpeg');

mask = false(size(image,1),size(image,2));
mask(1100:2000, 800:3000) = true;

%skalowanie do speedupa testow
image = imresize(image,.1);
mask = imresize(mask,.1);  

subplot(2,2,1); imshow(image); title('Input Image');
subplot(2,2,2); imshow(mask); title('Initialization');
subplot(2,2,3); title('Segmentation');

iterations = 600;
radius = 50;
smooth = 0.2;
display = true;
threheads = 4;
parameters = struct('image',image,'initMask',mask,'maxIterations',...
    iterations,'radius', radius,'smooth', smooth,'display', display,...
   'threheads', threheads);

% result = localizedSeg(parameters);
% result = localizedSegParallel(parameters);  
result = localizedSegParallelGPU(parameters);

subplot(2,2,4); imshow(result); title('Final Segmentation');





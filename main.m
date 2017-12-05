%% ACTIVE CONTOUR SEGMENTATION
% w.opoczynski 2017r 
% main script

%folder 
cd 'C:\Users\Wojtek\source\repos\PI';
clear; clc; close all;

image = imread('airplane.jpg');

% create mask 
mask = false(size(image,1),size(image,2));
mask(70:250, 80:250) = true;
%% for large images rescale
% image = imresize(image,.5);
% mask = imresize(mask,.5);  

%%
subplot(2,2,1); imshow(image); title('Input');
subplot(2,2,2); imshow(mask); title('Maska');
subplot(2,2,3); title('Segmentacja');

%% params 
iterations = 1000;
radius = 50;
smooth = 0.2;
display = true;
threheads = 4;
parameters = struct('image',image,'initMask',mask,'maxIterations',...
    iterations,'radius', radius,'smooth', smooth,'display', display,...
   'threheads', threheads);
%% wyniki
result = localizedSeg(parameters);
subplot(2,2,4); imshow(result); title('Wynik');

resultCPU = localizedSegParallel(parameters);  
subplot(2,2,4); imshow(resultCPU); title('Wynik');

resultGPU = localizedSegParallelGPU(parameters);
subplot(2,2,4); imshow(resultGPU); title('Wynik');





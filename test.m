%% result comparsion on plots live

cd 'C:\Users\Wojtek\source\repos\PI';
image = imread('airplane.jpg');
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; %small one
% mask(20:250,30:250) = true; %big one

iterations = 400;
radius = 100;
smooth = 0.2;
display = true;
threads = 4;
dispIteration = 10;
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,...
                    'radius', radius,'smooth', smooth,'display', display,...
                    'dispIteration',dispIteration,'threads', threads);

%% %%%%%% normal size %%%%%%%%%%%%%%%%
% single thread
figure(1);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
('segmentacja live');
tic;
result = localizedSeg(parameters);
timeCPU = toc;
subplot(2,2,4);
imshow(result);
title('Segmentacja CPU');

% multi threads
figure(2);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultCPU = localizedSegParallel(parameters);  
timeMultiCpu = toc;
subplot(2,2,4);
imshow(resultCPU);
title('Wynik CPU multithread.');

% GPU
figure(3);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultGPU = localizedSegParallelGPU(parameters);
timeGPU = toc;
imageOutGpu = gather(resultGPU);
clear resultGPU;
subplot(2,2,4); imshow(imageOutGpu);
title('Wynik GPU');

%% %%%%%% 0.1 size %%%%%%%%%%%%%%%%

image = imread('airplane.jpg');
% image = imread('plane.jpeg'); %//2nd pic much bigger
% create mask 
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; %small one
% mask(20:250,30:250) = true; %big one

% rescale
image = imresize(image,.1);
mask = imresize(mask,.1);  

% params 
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,...
                    'radius', radius,'smooth', smooth,'display', display,...
                    'dispIteration',dispIteration,'threads', threads);
% single thread
figure(1);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
('segmentacja live');
tic;
result01 = localizedSeg(parameters);
timeCPU01 = toc;
subplot(2,2,4);
imshow(result01);
title('Segmentacja CPU');

% multi threads
figure(2);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultCPU01 = localizedSegParallel(parameters);  
timeMultiCpu01 = toc;
subplot(2,2,4);
imshow(resultCPU01);
title('Wynik CPU multithread.');

% GPU
figure(4);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultGPU01 = localizedSegParallelGPU(parameters);
timeGPU01 = toc;
imageOutGpu01 = gather(resultGPU01);
clear resultGPU;
subplot(2,2,4); imshow(imageOutGpu01);
title('Wynik GPU');

%% %%%%%% 0.2 size %%%%%%%%%%%%%%%%

image = imread('airplane.jpg');
% image = imread('plane.jpeg'); %//2nd pic much bigger
% create mask 
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; %small one
% mask(20:250,30:250) = true; %big one

% rescale
image = imresize(image,.2);
mask = imresize(mask,.2);  

% params 
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,...
                    'radius', radius,'smooth', smooth,'display', display,...
                    'dispIteration',dispIteration,'threads', threads);


% single thread
figure(1);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
('segmentacja live');
tic;
result02 = localizedSeg(parameters);
timeCPU02 = toc;
subplot(2,2,4);
imshow(result02);
title('Segmentacja CPU');

% multi threads
figure(2);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultCPU02 = localizedSegParallel(parameters);  
timeMultiCpu02 = toc;
subplot(2,2,4);
imshow(resultCPU02);
title('Wynik CPU multithread.');

% GPU
figure(4);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultGPU02 = localizedSegParallelGPU(parameters);
timeGPU02 = toc;
imageOutGpu02 = gather(resultGPU02);
clear resultGPU;
subplot(2,2,4); imshow(imageOutGpu02);
title('Wynik GPU');

%% %%%%%% 0.5 size %%%%%%%%%%%%%%%%

image = imread('airplane.jpg');
% image = imread('plane.jpeg'); %//2nd pic much bigger
% create mask 
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; %small one
% mask(20:250,30:250) = true; %big one

% rescale
image = imresize(image,.5);
mask = imresize(mask,.5);  

% params 
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,...
                    'radius', radius,'smooth', smooth,'display', display,...
                    'dispIteration',dispIteration,'threads', threads);

% single thread
figure(1);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
('segmentacja live');
tic;
result05 = localizedSeg(parameters);
timeCPU05 = toc;
subplot(2,2,4);
imshow(result05);
title('Segmentacja CPU');

% multi threads
figure(2);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultCPU05 = localizedSegParallel(parameters);  
timeMultiCpu05 = toc;
subplot(2,2,4);
imshow(resultCPU05);
title('Wynik CPU multithread.');

% GPU
figure(4);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultGPU05 = localizedSegParallelGPU(parameters);
timeGPU05 = toc;
imageOutGpu05 = gather(resultGPU05);
clear resultGPU;
subplot(2,2,4); imshow(imageOutGpu05);
title('Wynik GPU');
%% %%%%%% 1.5 size %%%%%%%%%%%%%%%%

image = imread('airplane.jpg');
% image = imread('plane.jpeg'); %//2nd pic much bigger
% create mask 
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; %small one
% mask(20:250,30:250) = true; %big one

% rescale
 image = imresize(image,1.5);
 mask = imresize(mask,1.5);  

% params 
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,...
                    'radius', radius,'smooth', smooth,'display', display,...
                    'dispIteration',dispIteration,'threads', threads);

% single thread
figure(1);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
('segmentacja live');
tic;
result15 = localizedSeg(parameters);
timeCPU15 = toc;
subplot(2,2,4);
imshow(result15);
title('Segmentacja CPU');

% multi threads
figure(2);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultCPU15 = localizedSegParallel(parameters);  
timeMultiCpu15 = toc;
subplot(2,2,4);
imshow(resultCPU15);
title('Wynik CPU multithread.');

% GPU
figure(4);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultGPU15 = localizedSegParallelGPU(parameters);
timeGPU15 = toc;
imageOutGpu15 = gather(resultGPU15);
clear resultGPU;
subplot(2,2,4); imshow(imageOutGpu15);
title('Wynik GPU');

%% %%%%%% 2.0 size %%%%%%%%%%%%%%%%
image = imread('airplane.jpg');
% image = imread('plane.jpeg'); %//2nd pic much bigger
% create mask 
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; %small one
% mask(20:250,30:250) = true; %big one

% rescale
image = imresize(image,2);
mask = imresize(mask,2);  

% params 
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,...
                    'radius', radius,'smooth', smooth,'display', display,...
                    'dispIteration',dispIteration,'threads', threads);
% single thread
figure(1);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
('segmentacja live');
tic;
result20 = localizedSeg(parameters);
timeCPU20 = toc;
subplot(2,2,4);
imshow(result20);
title('Segmentacja CPU');

% multi threads
figure(2);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultCPU20 = localizedSegParallel(parameters);  
timeMultiCpu20 = toc;
subplot(2,2,4);
imshow(resultCPU20);
title('Wynik CPU multithread.');

% GPU
figure(4);
subplot(2,2,1);
imshow(image);
title('Input');
subplot(2,2,2);
imshow(mask);
title('Maska');
subplot(2,2,3);
title('Segmentacja live');
tic;
resultGPU20 = localizedSegParallelGPU(parameters);
timeGPU20 = toc;
imageOutGpu20 = gather(resultGPU20);
clear resultGPU;
subplot(2,2,4); imshow(imageOutGpu20);
title('Wynik GPU');
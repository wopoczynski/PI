image = imread('airplane.jpg');
% image = imread('plane.jpeg'); %//2nd pic much bigger
% create mask 
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; %small one
% mask(20:250,30:250) = true; %big one

%% rescale
% image = imresize(image,.5);
% mask = imresize(mask,.5);  

%% params 
iterations = 400;
radius = 100;
smooth = 0.2;
display = true;
threads = 4;
dispIteration = 10;
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,...
                    'radius', radius,'smooth', smooth,'display', display,...
                    'dispIteration',dispIteration,'threads', threads);
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
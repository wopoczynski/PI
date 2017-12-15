% multithread

image = imread('airplane.jpg');
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true;

iterations = 600; % podniesione z 400
display = false; %disp off
threads = 12; %% ilosc watkow ustawilem na 12

%% 0.1
image01 = imresize(image,.1);
mask01 = imresize(mask,.1);  
parameters = struct('image',image01,'initMask',mask01,'display', display,'maxIterations',iterations);
tic;
result01 = localizedSegParallel(parameters);
timeCPU01 = toc;
disp('done x .1');

%% 0.25
image025 = imresize(image,.25);
mask025 = imresize(mask,.25);  
parameters = struct('image',image025,'initMask',mask025,'display', display,'maxIterations',iterations);
tic;
result025 = localizedSegParallel(parameters);
timeCPU025 = toc;
disp('done x.2');

%% 0.5
image05 = imresize(image,.5);
mask05 = imresize(mask,.5);  
parameters = struct('image',image05,'initMask',mask05,'display', display,'maxIterations',iterations);
tic;
result05 = localizedSegParallel(parameters);
timeCPU05 = toc;

disp('done x.5');

%% 0.75
image075 = imresize(image,.75);
mask075 = imresize(mask,.75);  
parameters = struct('image',image075,'initMask',mask075,'display', display,'maxIterations',iterations);
tic;
result075 = localizedSegParallel(parameters);
timeCPU075 = toc;
disp('done x.75');

%% 1
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,'display',display);

tic;
result1 = localizedSegParallel(parameters);
timeCPU1 = toc;

disp('done x1');

%% 1.5

image15 = imresize(image,1.5);
mask15 = imresize(mask,1.5);  
parameters = struct('image',image15,'initMask',mask15,'display', display,'maxIterations',iterations);
tic;
result15 = localizedSegParallel(parameters);
timeCPU15 = toc;
disp('done x1,5');

%% 2

image2 = imresize(image,2);
mask2 = imresize(mask,2);  
parameters = struct('image',image2,'initMask',mask2,'display', display,'maxIterations',iterations);
tic;
result2 = localizedSegParallel(parameters);
timeCPU2 = toc;

disp('done x2');

%% 4

image4 = imresize(image,4);
mask4 = imresize(mask,4);  
parameters = struct('image',image4,'initMask',mask4,'display', display,'maxIterations',iterations);
tic;
result4 = localizedSegParallel(parameters);
timeCPU4 = toc;

disp('done4');

%% 8

image8 = imresize(image,8);
mask8 = imresize(mask,8);  
parameters = struct('image',image8,'initMask',mask8,'display', display,'maxIterations',iterations);
tic;
result8 = localizedSegParallel(parameters);
timeCPU8 = toc;

save('multiThreadResults');

disp('done x 8');
toc


%% imshow
% imshow(result01);
% imshow(result025);
% imshow(result05);
% imshow(result075);
% imshow(result1);
% imshow(result15);
% imshow(result2);
% imshow(result4);
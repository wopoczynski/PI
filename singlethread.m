% single thread
cd 'C:\Users\Wojtek\source\repos\PI';

image = imread('airplane.jpg');
mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true;
iterations = 400;
display = false;


%% 0.1
image01 = imresize(image,.1);
mask01 = imresize(mask,.1);  
parameters = struct('image',image01,'initMask',mask01,'display', display,'maxIterations',iterations);
tic;
result01 = localizedSeg(parameters);
timeCPU01 = toc/60;

%% 0.25
image025 = imresize(image,.25);
mask025 = imresize(mask,.25);  
parameters = struct('image',image025,'initMask',mask025,'display', display,'maxIterations',iterations);
tic;
result025 = localizedSeg(parameters);
timeCPU025 = toc/60;

%% 0.5
image05 = imresize(image,.5);
mask05 = imresize(mask,.5);  
parameters = struct('image',image05,'initMask',mask05,'display', display,'maxIterations',iterations);
tic;
result05 = localizedSeg(parameters);
timeCPU05 = toc/60;


%% 0.75
image075 = imresize(image,.75);
mask075 = imresize(mask,.75);  
parameters = struct('image',image075,'initMask',mask075,'display', display,'maxIterations',iterations);
tic;
result075 = localizedSeg(parameters);
timeCPU075 = toc/60;

%% 1
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations,'display',display);

tic;
result1 = localizedSeg(parameters);
timeCPU1 = toc/60;

%% 1.5

image15 = imresize(image,1.5);
mask15 = imresize(mask,1.5);  
parameters = struct('image',image15,'initMask',mask15,'display', display,'maxIterations',iterations);
tic;
result15 = localizedSeg(parameters);
timeCPU15 = toc/60;

%% 2

image2 = imresize(image,2);
mask2 = imresize(mask,2);  
parameters = struct('image',image2,'initMask',mask2,'display', display,'maxIterations',iterations);
tic;
result2 = localizedSeg(parameters);
timeCPU2 = toc/60;


%% 4

image4 = imresize(image,4);
mask4 = imresize(mask,4);  
parameters = struct('image',image4,'initMask',mask4,'display', display,'maxIterations',iterations);
tic;
result4 = localizedSeg(parameters);
timeCPU4 = toc/60;


x = [.1 .25 .5 .75 1 1.5 2 4];
y = [timeCPU01 timeCPU025 timeCPU05 timeCPU075 timeCPU1 timeCPU15 timeCPU2 timeCPU4];
figure(1);
plot(x,y);
xlabel('size');
ylabel('time [s]');
title('processing time 1 thread');

save('timingCore');

disp('done');
toc


imshow(result01);
imshow(result025);
imshow(result05);
imshow(result075);
imshow(result1);
imshow(result15);
imshow(result2);
imshow(result4);
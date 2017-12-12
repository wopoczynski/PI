image = imread('airplane.jpg');

mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; %small one

iterations = 1;
parameters = struct('image',image,'initMask',mask,'maxIterations',iterations);
                
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

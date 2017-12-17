%%%% GPU COMPUTING
image = imread('airplane.jpg');

mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; 
iterations = 600; %iteracje
display = false; % T/F czy ma wyœwietlaæ przebieg
size = [.1 .25 .5 .75 1 1.5 2 4 8];

for i = 1:numel(size)
    
    imageTmp = imresize(image,size(i));
    maskTmp = imresize(mask,size(i));  
    parameters = struct('image',imageTmp,'initMask',maskTmp,'display', display,'maxIterations',iterations);
    tic;
    resultTmp = localizedSegParallelGPU(parameters);
    resultGPU{i} = gather(resultTmp);
    timesGPU(i) = toc;
    disp(['done ' num2str(size(i))]);
end

save('resultGPUSizes');
disp('alldone');

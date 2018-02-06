%%%% CPU threads check
image = imread('airplane.jpg');

mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; 
resizeVal = 8;
iterations = 600; 
display = false;
threads = [1, 2, 4, 8, 12];
for i = 1:numel(threads)
    
    imageTmp = imresize(image,resizeVal);
    maskTmp = imresize(mask,resizeVal);  
    parameters = struct('image',imageTmp,'initMask',maskTmp,'display', display,'maxIterations',iterations, 'threads', threads(i));
    tic;
    result{i} = localizedSegParallel(parameters);
    timesMultiThreads(i) = toc;
    disp(['done ' num2str(threads(i))]); 
end

save('resultsMultiCpuTest');
disp('alldone');

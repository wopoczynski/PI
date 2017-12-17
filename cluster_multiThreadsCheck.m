%%%% CPU threads check
image = imread('airplane.jpg');

mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; 
resizeVal = 8; %8x 
iterations = 600; %iteracje
display = false; % T/F czy ma wyœwietlaæ przebieg
threads = [1, 2, 4, 8, 12, 16, 32, 48, 64, 72, 96]; % ilosc watkow taka?
for i = 1:numel(threads)
    
    imageTmp = imresize(image,resizeVal);
    maskTmp = imresize(mask,resizeVal);  
    parameters = struct('image',imageTmp,'initMask',maskTmp,'display', display,'maxIterations',iterations, 'threads', threads(i));
    tic;
    result{i} = localizedSegParallel(parameters);
    timesMultiThreads(i) = toc;
    disp(['done ' num2str(threads(i))]); 
%     if i==3 break; end;
end

save('resultsMultiCpuTest');
disp('alldone');
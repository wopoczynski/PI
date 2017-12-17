%%%% single

image = imread('airplane.jpg');

mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true;

iterations = 600; % podniesione z 400
display = false; %disp off
resizeVal = [.1 .25 .5 .75 1 1.5 2 4 8];


for i = 1:numel(resizeVal)
    
    imageTmp = imresize(image,resizeVal(i));
    maskTmp = imresize(mask,resizeVal(i));  
    parameters = struct('image',imageTmp,'initMask',maskTmp,'display', display,...
                        'maxIterations',iterations);
    tic;
    resultCpu{i} = localizedSeg(parameters);
    timesCpu(i) = toc;
    disp(['done ' num2str(resizeVal(i))]);
   if (i==3) break; end; 
end

save('resultCPUSingleSizes');
disp('alldone');

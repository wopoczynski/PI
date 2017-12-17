%% gpu vs cpu 

image = imread('airplane.jpg');

mask = false(size(image,1),size(image,2));
mask(140:220, 140:220) = true; 

resizeVal = 8; %8x 

imageTmp = imresize(image,resizeVal);
maskTmp = imresize(mask,resizeVal); 


iterations = 600; %iteracje
display = false; % T/F czy ma wyœwietlaæ przebieg

threads = 32 %% nie wiem jaka ilosc watkow wpisac na porownanie rozne gpu vs rozne cpu ;/

%% GPU 

parameters = struct('image',imageTmp,'initMask',maskTmp,'display', display,'maxIterations',iterations);
tic;
resultTmp = localizedSegParallelGPU(parameters);
resultGPU = gather(resultTmp);
timeGPU = toc;

%% cpu

parameters = struct('image',imageTmp,'initMask',maskTmp,'display', display,'maxIterations',iterations, 'threads', threads);
tic;
result = localizedSegParallel(parameters);
timeCPU = toc;


save('gpuVScpu');
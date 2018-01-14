clear all;clc;close all;
%% wyniki
cd 'wyniki uzyte';
resultsGpu = load('resultGPUSizes.mat');
resultsCpu = load('resultCPUSingleSizes.mat');
resultsCpuThreadsChange = load('resultsMultiCpuTest.mat');
resultsCpuThreads = load('resultCpuMultiSizes.mat');
cd '..';

%% wykresy

figure (1);
plot(resultsGpu.size, resultsGpu.timesGPU ,'g')
hold on;
plot (resultsGpu.size, resultsGpu.timesGPU , 'g.', 'MarkerSize', 20);
xlabel('Krotno�� zdj�cia o rozmiarze 400x320 [x100%]');
ylabel('Czas [sek]');
title('Wyniki przetwarzania obrazu zr�wnoleglone na GPU');

figure (2);
plot(resultsCpu.resizeVal,( resultsCpu.timesCpu/3600) ,'b')
hold on;
plot (resultsCpu.resizeVal,( resultsCpu.timesCpu /3600), 'b.', 'MarkerSize', 20);
xlabel('Krotno�� zdj�cia o rozmiarze 400x320');
ylabel('Czas [godziny]');
title('Wyniki przetwarzania jednego w�tku');


figure (22);
plot(resultsCpu.resizeVal(1:7),( resultsCpu.timesCpu(1:7)/60) ,'b')
hold on;
plot (resultsCpu.resizeVal(1:7),( resultsCpu.timesCpu(1:7) /60), 'b.', 'MarkerSize', 20);
xlabel('Krotno�� zdj�cia o rozmiarze 400x320');
ylabel('Czas [minuty]');
title('Wyniki przetwarzania jednego w�tku');

figure (3);
plot(resultsCpuThreads.resizeVal, (resultsCpuThreads.timesCpuMulti /3600),'b')
hold on;
plot (resultsCpuThreads.resizeVal, (resultsCpuThreads.timesCpuMulti /3600), 'b.', 'MarkerSize', 20);
xlabel('Krotno�� zdj�cia o rozmiarze 400x320');
ylabel('Czas [godziny]');
title('Wyniki przetwarzania na 12 w�tkach');


figure (33);
plot(resultsCpuThreads.resizeVal(1:7), (resultsCpuThreads.timesCpuMulti(1:7) /60),'b')
hold on;
plot (resultsCpuThreads.resizeVal(1:7), (resultsCpuThreads.timesCpuMulti(1:7) /60), 'b.', 'MarkerSize', 20);
xlabel('Krotno�� zdj�cia o rozmiarze 400x320');
ylabel('Czas [minuty]');
title('Wyniki przetwarzania na 12 w�tkach');

figure (4);
plot(resultsCpu.resizeVal,( resultsCpu.timesCpu ./3600),'r',...
    resultsCpuThreads.resizeVal, (resultsCpuThreads.timesCpuMulti./3600) ,'b',...
    resultsGpu.size, (resultsGpu.timesGPU ./3600),'g')
hold on;
plot (resultsCpu.resizeVal, (resultsCpu.timesCpu./3600) ,'r.', 'MarkerSize', 20);
hold on;
plot ( resultsCpuThreads.resizeVal, (resultsCpuThreads.timesCpuMulti./3600) ,'b.', 'MarkerSize', 20);
hold on;
plot (  resultsGpu.size, (resultsGpu.timesGPU./3600) ,'g.', 'MarkerSize', 20);
xlabel('Krotno�� zdj�cia o rozmiarze 400x320');
ylabel('Czas [godziny]');
title('Por�wnanie czasu przetwarzania zdj�cia');
legend('1 w�tek','12 w�tk�w','gpu');

figure(5);
plot(resultsCpuThreadsChange.threads(1:7),(resultsCpuThreadsChange.timesMultiThreads(1:7)./3600), 'b');
hold on;
plot(resultsCpuThreadsChange.threads(1:7),(resultsCpuThreadsChange.timesMultiThreads(1:7)./3600), 'b.', 'MarkerSize', 20);
xlabel('Ilo�� w�tk�w');
ylabel('Czas [godziny]');
title('Czasy przetwarzania obrazu wzgl�dem liczby w�tk�w 1-32');

figure(6);
plot(resultsCpuThreadsChange.threads(3:7),(resultsCpuThreadsChange.timesMultiThreads(3:7)/3600), 'b');
hold on;
plot(resultsCpuThreadsChange.threads(3:7),(resultsCpuThreadsChange.timesMultiThreads(3:7)./3600), 'b.', 'MarkerSize', 20);
xlabel('Ilo�� w�tk�w');
ylabel('Czas [godziny]');
title('Czasy przetwarzania obrazu 400x320px wzgl�dem liczby w�tk�w 4-32');
%% speedup
threadsTmp = resultsCpuThreadsChange.threads;
threadsTmp(10:11)=[];
resTmp = resultsCpuThreadsChange.timesMultiThreads;
resTmp(10:11)=[];
speedup = resTmp./resultsGpu.timesGPU;

figure(7);
plot(threadsTmp,speedup, 'b');
hold on;
plot(threadsTmp,speedup, 'b.', 'MarkerSize', 20);
xlabel('Ilo�� w�tk�w/gpu');
ylabel('Speed-up [krotno��]');
title('Speedup wzgl�dem wzrostu w�tk�w obliczeniowych'); % przy 64 w�tkach speedup wyniosl ~~x25


speedup1 = resultsCpu.timesCpu./resultsGpu.timesGPU;
figure(8);
plot(resultsCpu.resizeVal,speedup1, 'b');
hold on;
plot(resultsCpu.resizeVal,speedup1, 'b.', 'MarkerSize', 20);
xlabel('Czas obliczen cpu/Czas obliczen gpu');
ylabel('Speedup [krotnosc]');
title('Speedup wzgl�dem wzrostu rozmiaru zdj�cia'); % przy 64 w�tkach speedup wyniosl ~~x25

%% 1 watek
figure(9);
subplot(3,3,1);
imshow(resultsCpu.resultCpu{1,1});
title('10% rozmiaru obrazu');

subplot(3,3,2);
imshow(resultsCpu.resultCpu{1,2});
title('25% rozmiaru obrazu');

subplot(3,3,3);
imshow(resultsCpu.resultCpu{1,3});
title('50% rozmiaru obrazu');

subplot(3,3,4);
imshow(resultsCpu.resultCpu{1,4});
title('75% rozmiaru obrazu');

subplot(3,3,5);
imshow(resultsCpu.resultCpu{1,5});
title('oryginalny obraz');

subplot(3,3,6);
imshow(resultsCpu.resultCpu{1,6});
title('150% rozmiaru obrazu');

subplot(3,3,7);
imshow(resultsCpu.resultCpu{1,7});
title('200% rozmiaru obrazu');

subplot(3,3,8);
imshow(resultsCpu.resultCpu{1,8});
title('400% rozmiaru obrazu');

subplot(3,3,9);
imshow(resultsCpu.resultCpu{1,9});
title('800% rozmiaru obrazu');

suptitle('Wyniki przetwarzania obrazu 400x320px bez zr�wnoleglenia');

%% wiele watkow 

figure(10);
subplot(3,3,1);
imshow(resultsCpuThreads.resultCpuMulti{1,1});
title('10% rozmiaru obrazu org.');

subplot(3,3,2);
imshow(resultsCpuThreads.resultCpuMulti{1,2});
title('25% rozmiaru obrazu org.');

subplot(3,3,3);
imshow(resultsCpuThreads.resultCpuMulti{1,3});
title('50% rozmiaru obrazu org.');

subplot(3,3,4);
imshow(resultsCpuThreads.resultCpuMulti{1,4});
title('75% rozmiaru obrazu org.');

subplot(3,3,5);
imshow(resultsCpuThreads.resultCpuMulti{1,5});
title('oryginalny obraz');

subplot(3,3,6);
imshow(resultsCpuThreads.resultCpuMulti{1,6});
title('150% rozmiaru obrazu org.');

subplot(3,3,7);
imshow(resultsCpuThreads.resultCpuMulti{1,7});
title('200% rozmiaru obrazu org.');

subplot(3,3,8);
imshow(resultsCpuThreads.resultCpuMulti{1,8});
title('400% rozmiaru obrazu org.');

subplot(3,3,9);
imshow(resultsCpuThreads.resultCpuMulti{1,9});
title('800% rozmiaru obrazu org.');

suptitle('Wyniki przetwarzania obrazu 400x320px zr�wnoleglone na 12 w�tk�w');

%% zmienne w�tki 
figure(11);
subplot(3,3,1);
imshow(resultsCpuThreadsChange.result{1,1});
title('1 w�tek');

subplot(3,3,2);
imshow(resultsCpuThreadsChange.result{1,2});
title('2 w�tki');

subplot(3,3,3);
imshow(resultsCpuThreadsChange.result{1,3});
title('4 w�tki');

subplot(3,3,4);
imshow(resultsCpuThreadsChange.result{1,4});
title('8 w�tk�w');

subplot(3,3,5);
imshow(resultsCpuThreadsChange.result{1,5});
title('12 w�tk�w');

subplot(3,3,6);
imshow(resultsCpuThreadsChange.result{1,6});
title('16 w�tk�w');

subplot(3,3,7);
imshow(resultsCpuThreadsChange.result{1,7});
title('32 w�tki');

subplot(3,3,8);
imshow(resultsCpuThreadsChange.result{1,8});
title('48 w�tk�w');

subplot(3,3,9);
imshow(resultsCpuThreadsChange.result{1,9});
title('64 w�tki');

suptitle('Wyniki przetwarzania obrazu 400x320px na zmiennej ilo�ci w�tk�w');

%% gpu


figure(12);
subplot(3,3,1);
imshow(resultsGpu.resultGPU{1,1});
title('10% rozmiaru');

subplot(3,3,2);
imshow(resultsGpu.resultGPU{1,2});
title('25% rozmiaru');

subplot(3,3,3);
imshow(resultsGpu.resultGPU{1,3});
title('50% rozmiaru');

subplot(3,3,4);
imshow(resultsGpu.resultGPU{1,4});
title('75% rozmiaru');

subplot(3,3,5);
imshow(resultsGpu.resultGPU{1,5});
title('oryginalny obraz');

subplot(3,3,6);
imshow(resultsGpu.resultGPU{1,6});
title('150% rozmiaru');

subplot(3,3,7);
imshow(resultsGpu.resultGPU{1,7});
title('200% rozmiaru');

subplot(3,3,8);
imshow(resultsGpu.resultGPU{1,8});
title('400% rozmiaru');

subplot(3,3,9);
imshow(resultsGpu.resultGPU{1,9});
title('800% rozmiaru');

suptitle('Wyniki przetwarzania obrazu 400x320px zr�wnoleglone na GPU');


% 
% 
% %% zapis
% cd 'wyniki_png';
% screenSize = get(0, 'ScreenSize');
% figures = 1:1:12;
% for f = 1:numel(figures)
%       fig = figures(f);
%       % Resize the figure
% % %       set(fig, 'Units', figUnits);
% %       set(figure, 'Position', [0 0 screenSize(3) screenSize(4)]);
%       filename = sprintf('Figure%02d.png', f);
%       print( fig, filename, '-dpng');
%       disp(f);
% end
% cd '..';
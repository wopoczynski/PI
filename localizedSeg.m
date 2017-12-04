%% SNAKE SEGMENTATION W/O EDGES
% Implementacja algorytmu segmentacji aktywnego konturu aka. snake
% 
% w.opoczynski 2017
% segmentedImage = localizedSeg(image,initMask,maxIterations,radius,smooth)
%
% @param object parameters {
%  array image
%  array initMask
% OPTIONAL parameters
%  int maxIterations default 200
%  int radius default (x+y)/(2*8)
%  float smooth default 0.1
%  boolean display def. true
%  }
% @result array segmentedImage 
%
% 
% initMask binarny obraz zawierajacy figure, z ktorej pobierany jest kontur
% radius promieñ do wykrywania zmian lokalnych im wiêkszy tym bardziej globalny 
% smooth odpowiada za wyg³adzenie krawêdzi
% display flaga czy ma pokazywac wyniki


%%
function segmentedImage = localizedSeg(parameters)
	
		image = parameters.image; 
		initMask = parameters.initMask;
		maxIterations = parameters.maxIterations;
        radius = parameters.radius;
        smooth = parameters.smooth;
        display = parameters.display;		

	% default values
	image = im2graydouble(image);  
	[dimY dimX] = size(image);
	if(~exist('radius','var')) 
		radius = round((dimY+dimX)/(2*8)); 
		if(display>0) 
			disp(['radius = ' num2str(radius) ' px']); 
		end
	end
	
	if(~exist('maxIterations','var')) 
		maxIterations = 200; 
	end
	if(~exist('smooth','var'))
		smooth = .1; 
	end
	if(~exist('display','var'))
		display = true;
    end

    % tworzy signed distance map (SDF)
	phi = mask2phi(initMask);

	% ilosc iteracji 
    licznik = 0;
	while (licznik <= maxIterations)

		% pobiera punkty z krzywej
		idx = find(phi <= 1.2 & phi >= -1.2)';	
		[y x] = ind2sub(size(phi),idx);
		
		% okno przesuwne dla lokalnych pochodnych i sprawdzenie wymiarow
		xNeg = x-radius;
        xPos = x+radius;
		yNeg = y-radius;
        yPos = y+radius;
		xNeg(xNeg<1)=1;
        yNeg(yNeg<1)=1;
		xPos(xPos>dimX)=dimX;
        yPos(yPos>dimY)=dimY;

		% re-inicjalizacja u,v,aIn,aOut
		u=zeros(size(idx)); v=zeros(size(idx)); 
		aIn=zeros(size(idx)); aOut=zeros(size(idx)); 
		
		% obliczanie lokalnych pochodnych
		for i = 1:numel(idx) %tu zrównoleglic?
			imageTemp = image(yNeg(i):yPos(i),xNeg(i):xPos(i)); %sub i
			P = phi(yNeg(i):yPos(i),xNeg(i):xPos(i)); %sub phi

			localMin = find(P<=0);
			aIn(i) = length(localMin)+eps;
			u(i) = sum(imageTemp(localMin))/aIn(i);
			
			localMax = find(P>0);
			aOut(i) = length(localMax)+eps;
			v(i) = sum(imageTemp(localMax))/aOut(i);
		end	 
 
		% F obrazu
		F = -(u-v).*(2.*image(idx)-u-v);
		% F z krzywej
		curvature = getCurvature(phi,idx,x,y);	
		% gradient spada minimalizujac energie
		dphidt = F./max(abs(F)) + smooth*curvature;	
		% utrzymuje równanie Courant–Friedrichs–Lewy 
		dt = .45/(max(dphidt)+eps);
		% zmiana krzywej na obrazie
		phi(idx) = phi(idx) + dt.*dphidt;
		% utrzymuje SDF wyg³adzone
		phi = sussman(phi, .5);
		% co 20 iteracji print postepu
		if((display>0)&&(mod(licznik,20) == 0)) 
			showCurveAndPhi(image,phi,licznik);	
        end
        licznik = licznik+1;
	end
	
	% result print
	if(display)
		showCurveAndPhi(image,phi,licznik);
	end
	
	segmentedImage = phi<=0;


%% dodatkowe funkcje

% wyswietlanie wynikow
function showCurveAndPhi(I, phi, i)
	imshow(I,'displayrange',[0 255]);
    hold on;
	contour(phi, [0 0], 'g','LineWidth',4);
	contour(phi, [0 0], 'k','LineWidth',2);
	hold off; title([num2str(i) ' Iterations']);
    drawnow;
	
% zamiana z mask na SDF ( Signed distance Function)
function phi = mask2phi(init_a)
	phi=bwdist(init_a)-bwdist(1-init_a)+im2double(init_a)-.5;
	
% obliczanie ksztaltu krawedzi
function curvature = getCurvature(phi,idx,x,y)
		[dimY, dimX] = size(phi);				

		% 4 s¹siedztwo
		ym1 = y-1;
        xm1 = x-1;
        yp1 = y+1;
        xp1 = x+1;

		% granice	
		ym1(ym1<1) = 1;
        xm1(xm1<1) = 1;							
		yp1(yp1>dimY)=dimY;
        xp1(xp1>dimX) = dimX;		

		% indexy 8 sasiedztwa
		idUp = sub2ind(size(phi),yp1,x);		
		iddn = sub2ind(size(phi),ym1,x);
		idlt = sub2ind(size(phi),y,xm1);
		idrt = sub2ind(size(phi),y,xp1);
		idul = sub2ind(size(phi),yp1,xm1);
		idur = sub2ind(size(phi),yp1,xp1);
		iddl = sub2ind(size(phi),ym1,xm1);
		iddr = sub2ind(size(phi),ym1,xp1);
		
		% pochodne dla srodka SDF w x,y
		phi_x	= -phi(idlt)+phi(idrt);
		phi_y	= -phi(iddn)+phi(idUp);
		phi_xx = phi(idlt)-2*phi(idx)+phi(idrt);
		phi_yy = phi(iddn)-2*phi(idx)+phi(idUp);
		phi_xy = -0.25*phi(iddl)-0.25*phi(idur)...
						 +0.25*phi(iddr)+0.25*phi(idul);
		phi_x2 = phi_x.^2;
		phi_y2 = phi_y.^2;
		
		% kalkulacja krzywej
		curvature = ((phi_x2.*phi_yy + phi_y2.*phi_xx - 2*phi_x.*phi_y.*phi_xy)./...
							(phi_x2 + phi_y2 +eps).^(3/2)).*(phi_x2 + phi_y2).^(1/2);				
	
% zamiana image na grayscale double
function imageTemp = im2graydouble(imageTemp)		
	[dimY, dimX, c] = size(imageTemp);
     if (c == 3)
        if(isfloat(imageTemp))
            if(c==3) 
                imageTemp = rgb2gray(uint8(imageTemp)); 
            end
        else
            if(c==3) 
                imageTemp = rgb2gray(imageTemp); 
            end
            imageTemp = double(imageTemp);
        end
     else 
         disp('obraz musi byc 2D');
     end
% level set re-initialization by the sussman method
% https://www.mathworks.com/matlabcentral/fileexchange/26101-active-contours--a-new-distribution-metric-for-image-segmentation?focused=5140125&tab=function
%
function D = sussman(D, dt)
	% forward/backward differences
	a = D - shiftR(D); % backward
	b = shiftL(D) - D; % forward
	c = D - shiftD(D); % backward
	d = shiftU(D) - D; % forward
	
	a_p = a;	a_n = a; % a+ and a-
	b_p = b;	b_n = b;
	c_p = c;	c_n = c;
	d_p = d;	d_n = d;
	
	a_p(a < 0) = 0;
	a_n(a > 0) = 0;
	b_p(b < 0) = 0;
	b_n(b > 0) = 0;
	c_p(c < 0) = 0;
	c_n(c > 0) = 0;
	d_p(d < 0) = 0;
	d_n(d > 0) = 0;
	
	dD = zeros(size(D));
	dNegativeIndex = find(D < 0);
	D_pos_ind = find(D > 0);
	dD(D_pos_ind) = sqrt(max(a_p(D_pos_ind).^2, b_n(D_pos_ind).^2) ...
											 + max(c_p(D_pos_ind).^2, d_n(D_pos_ind).^2)) - 1;
	dD(dNegativeIndex) = sqrt(max(a_n(dNegativeIndex).^2, b_p(dNegativeIndex).^2) ...
											 + max(c_n(dNegativeIndex).^2, d_p(dNegativeIndex).^2)) - 1;
	
	D = D - dt .* sussmanSign(D) .* dD;

% obliczanie pochodnych inwersje
function shift = shiftD(M)
	shift = shiftR(M')';

function shift = shiftL(M)
	shift = [ M(:,2:size(M,2)) M(:,size(M,2)) ];

function shift = shiftR(M)
	shift = [ M(:,1) M(:,1:size(M,2)-1) ];

function shift = shiftU(M)
	shift = shiftL(M')';
	
function S = sussmanSign(D)
	S = D ./ sqrt(D.^2 + 1);		

	

%% SNAKE SEGMENTATION W/O EDGES
% W.Opoczynski 2017-12
% Implementacja algorytmu segmentacji aktywnego konturu "snake"
% na GPU przy uzyciu parallel computing toolbox
% 
% segmentedImage = localizedSegParallelGPU(parameters)
%
% @param object parameters {
%  array image
%  array initMask
% OPTIONAL parameters
%  int maxIterations default 300
%  int radius default (x+y)/(2*8)
%  float smooth default 0.1
%  boolean display default true
%  boolean dispIterations default true
%  int threads default 1 
%  }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function segmentedImage = localizedSegParallelGPU(parameters)
	

    if(~isfield(parameters,'display'))
		display = true;
    else
        display = parameters.display;
    end
    
	if(~isfield(parameters,'dispIteration')) 
		dispIteration = 20; 
    else
        dispIteration = parameters.dispIteration;
    end
    
    if (~isfield(parameters,'image'))
        error('No image passed to function!');
    else
        image = gpuArray(parameters.image);
        image = im2graydouble(image);  
        [dimY, dimX] = size(image);
    end
    
    if (~isfield(parameters,'initMask'))
        error('No mask passed to function!');
    else
        initMask = parameters.initMask;
        mask = gpuArray(mask2phi(initMask));
    end
    
 	if(~isfield(parameters,'radius'))
		radius = round((dimY+dimX)/(2*8)); 
		if(display>0) 
			disp(['radius = ' num2str(radius) ' px']); 
		end
    else
        radius = parameters.radius;    
    end   

    if(~isfield(parameters,'maxIterations')) 
		maxIterations = 200; 
    else
        maxIterations = parameters.maxIterations;
    end
    
	if(~isfield(parameters,'smooth'))
		smooth = .1; 
    else
        smooth = parameters.smooth;
    end
    

    
	% kryterium stop
    licznik = 0;
	while (licznik <= maxIterations)

		% pobiera punkty z krzywej
		idx = find(mask <= 1.2 & mask >= -1.2)';	
		[y, x] = ind2sub(size(mask),idx);
		
		% okno przesuwne dla lokalnych pochodnych i sprawdzenie wymiarow
		xNeg = x-radius;
        xPos = x+radius;
		yNeg = y-radius;
        yPos = y+radius;
		xNeg(xNeg<1) = 1;
        yNeg(yNeg<1) = 1;
		xPos(xPos>dimX) = dimX;
        yPos(yPos>dimY) = dimY;

		% re-inicjalizacja u,v,aIn,aOut
		u = zeros(size(idx));
        v = zeros(size(idx)); 
		aIn = zeros(size(idx));
        aOut = zeros(size(idx)); 
		
			% przeliczanie pochodnych gpu jest równoległe nie potrzebna jest zadna petla
			imageTemp = image(yNeg:yPos,xNeg:xPos); %sub i
			P = mask(yNeg:yPos,xNeg:xPos); %sub mask

			localMin = find(P<=0);
			aIn = length(localMin)+eps;
			u = sum(imageTemp(localMin))/aIn;
			
			localMax = find(P>0);
			aOut = length(localMax)+eps;
			v = sum(imageTemp(localMax))/aOut;
 
		% F obrazu
		F = -(u-v).*(2.*image(idx)-u-v);
		% F z krzywej
		curvature = getCurvature(mask,idx,x,y);	
		% gradient spada minimalizujac energie
		dphidt = F./max(abs(F)) + smooth*curvature;	
		% utrzymuje równanie Courant–Friedrichs–Lewy 
		dt = .45/(max(dphidt)+eps);
		% zmiana krzywej na obrazie
		mask(idx) = mask(idx) + dt.*dphidt;
		% utrzymuje SDF wyg³adzone
		mask = sussman(mask, .5);
		%% 
		if((display>0)&&(mod(licznik,dispIteration) == 0)) 
			showCurveAndPhi(image,mask,licznik);
        end
        licznik = licznik+1;
	end
	
	% result print
	if(display)
		showCurveAndPhi(image,mask,licznik);
	end
	
	segmentedImage = mask <= 0;


%% dodatkowe funkcje %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=========================================================================
%=========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp results
function showCurveAndPhi(I, mask, i)
	imshow(I,'displayrange',[0 255]);
    hold on;
	contour(mask, [0 0], 'y','LineWidth',4);
	contour(mask, [0 0], 'r','LineWidth',2);
	hold off; title([num2str(i) ' Iteracji']);
    drawnow;
    
% SDF ( Signed distance Function) tworzy signed distance map (SDF)
function mask = mask2phi(init_a)
	mask = bwdist(init_a) - bwdist(1-init_a) + im2double(init_a) - .5;
	
% calc curve 
function curvature = getCurvature(mask,idx,x,y)
		[dimY, dimX] = size(mask);				

		% 4 neighbourhood
		ym1 = y-1;
        xm1 = x-1;
        yp1 = y+1;
        xp1 = x+1;

		% borders	
		ym1(ym1<1) = 1;
        xm1(xm1<1) = 1;							
		yp1(yp1>dimY)=dimY;
        xp1(xp1>dimX) = dimX;		

		% indexy 8 neighbourhood
		idUp = sub2ind(size(mask),yp1,x);		
		iddn = sub2ind(size(mask),ym1,x);
		idlt = sub2ind(size(mask),y,xm1);
		idrt = sub2ind(size(mask),y,xp1);
		idul = sub2ind(size(mask),yp1,xm1);
		idur = sub2ind(size(mask),yp1,xp1);
		iddl = sub2ind(size(mask),ym1,xm1);
		iddr = sub2ind(size(mask),ym1,xp1);
		
		% deriv. for center of SDF at x,y
		phi_x	= -mask(idlt)+mask(idrt);
		phi_y	= -mask(iddn)+mask(idUp);
		phi_xx = mask(idlt)-2*mask(idx)+mask(idrt);
		phi_yy = mask(iddn)-2*mask(idx)+mask(idUp);
		phi_xy = -0.25*mask(iddl)-0.25*mask(idur)...
				 +0.25*mask(iddr)+0.25*mask(idul);
		phi_x2 = phi_x.^2;
		phi_y2 = phi_y.^2;
		
		% curve calc
		curvature = ((phi_x2.*phi_yy + phi_y2.*phi_xx - 2*phi_x.*phi_y.*phi_xy)./...
							(phi_x2 + phi_y2 +eps).^(3/2)).*(phi_x2 + phi_y2).^(1/2);				
	
% color to grayscale
function imageTemp = im2graydouble(imageTemp)		
	[~, ~, c] = size(imageTemp);
     if (c == 3)
        if(isfloat(imageTemp))
            if(c == 3) 
                imageTemp = rgb2gray(uint8(imageTemp)); 
            end
        else
            if(c == 3) 
                imageTemp = rgb2gray(imageTemp); 
            end
            imageTemp = double(imageTemp);
        end
     else 
         disp('obraz musi byc 2D');
     end
% level set re-initialization by the sussman method
% https://www.mathworks.com/matlabcentral/fileexchange/26101-active-contours--a-new-distribution-metric-for-image-segmentation?focused=5140125&tab=function
% @author Romeil Sandhu
function D = sussman(D, dt)
	% forward/backward differences
	a = D - shiftR(D); % backward
	b = shiftL(D) - D; % forward
	c = D - shiftD(D); % backward
	d = shiftU(D) - D; % forward
	
	a_p = a;
    a_n = a; % a+ and a-
	b_p = b;
    b_n = b;
    c_p = c;
    c_n = c;
	d_p = d;
    d_n = d;
	
	a_p(a < 0) = 0;
	a_n(a > 0) = 0;
	b_p(b < 0) = 0;
	b_n(b > 0) = 0;
	c_p(c < 0) = 0;
	c_n(c > 0) = 0;
	d_p(d < 0) = 0;
	d_n(d > 0) = 0;
	
	dD = zeros(size(D),'gpuArray');
	dNegativeIndex = find(D < 0);
	D_pos_ind = find(D > 0);
	dD(D_pos_ind) = sqrt(max(a_p(D_pos_ind).^2, b_n(D_pos_ind).^2) ...
											 + max(c_p(D_pos_ind).^2, d_n(D_pos_ind).^2)) - 1;
	dD(dNegativeIndex) = sqrt(max(a_n(dNegativeIndex).^2, b_p(dNegativeIndex).^2) ...
											 + max(c_n(dNegativeIndex).^2, d_p(dNegativeIndex).^2)) - 1;
	
	D = D - dt .* sussmanSign(D) .* dD;

% transpose matrix and inverse for deriv. calc.
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

	

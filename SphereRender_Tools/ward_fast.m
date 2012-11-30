% ward model
% dan lichtman, 23/july/2004
% dpl27@cornell.edu

clear all;

%environment constants
radius = 500;
viewPoint = [0 0 4*radius];
lightCoords = 8*radius*normalize1([1 1 1]);
lightIntensity = 1;

%sphere characteristics
diffuseConst = .33;
specularConst = .025;
specularBlurConst = .1;
lightScaleConst = .5; %for no light scaling, set to zero.


% ******************
% temp fix for mapping error
temp=lightCoords(1);
lightCoords(1)=-lightCoords(2);
lightCoords(2)=temp;
% ******************



%print details
display(' ');
display(['starting ward render at: ' datestr(now)]);

%globals
global XMIN;
global XMAX;
global YMIN;
global YMAX;
global ROWS;
global COLS;
global POINTS

%do some calculations for globals
XMIN = -radius;
XMAX = radius;
YMIN = -radius;
YMAX = radius;
ROWS = XMAX-XMIN+1;
COLS = YMAX-YMIN+1;
POINTS = ROWS*COLS;

%set operational constants
lightDist = sqrt(sum(lightCoords.^2));
lightDirection = normalize1(lightCoords);
limits = [-radius radius -radius radius];
bitmapImage = zeros(ROWS, COLS);
calc = zeros(19,POINTS);

%create a column for each point
[temp1 temp2] = ndgrid(XMIN:XMAX,YMIN:YMAX);
calc([1 2],:) = [reshape(temp1,1,POINTS);reshape(temp2,1,POINTS)];

%find z components
calc(3,:) = sqrt(max(0,radius^2*ones(1,POINTS)-(calc(1,:)).^2-(calc(2,:)).^2));

%find surface normals, reflectance vectors and half vector
calc(4:6,:)=normalize(calc(1:3,:));
calc(7:9,:)=normalize(repmat(viewPoint',1,POINTS)-calc(1:3,:));
calc(10:12,:)=normalize((repmat(lightDirection',1,POINTS)+calc(7:9,:))./2);

%find cos theta(inc), cos theta(ref), and tan(delta)
calc(13,:)=max(0,[[calc(4:6,:)]'*lightDirection']');            %cos(thetaInc)
calc(14,:)=max(0,sum(calc(7:9,:).*calc(4:6,:)));                %cos(thetaR)
calc(15,:)=max(0,sum(calc(10:12,:).*calc(4:6,:)));              %cos(delta)
i=find(calc(15,:)>0);                                           %find non-zero deltas
iLength=length(i);
calc(16,i)=(ones(1,iLength)-[calc(15,i)].^2)./[calc(15,i)].^2;  %find tan^2 of non-zero deltas

%find light reflected from the sphere at each pixel
i=find(calc(13,:)&calc(14,:)&calc(16,:));                      %only calc where cos and tans are non-zero
iLength=length(i);
calc(17,i)=diffuseConst.*calc(13,i);                           %diffuse light
calc(18,i) = ...                                               %specular light
    (ones(1,iLength).*(pi*specularConst))./sqrt(calc(13,i).*calc(14,i)) .* ...
    exp(-calc(16,i)./(specularBlurConst^2))./(4*specularBlurConst^2);
                                                           
%rescale light

if lightScaleConst>0
    %david's method
    % maxLightDiffuse=max(max(calc(17,i)));
    % maxLightSpecularNew=maxLightDiffuse/lightScaleConst;
    % i2=find(calc(18,:)>maxLightSpecularNew);
    % calc(18,i2)=maxLightSpecularNew;

    %my method
    maxLightDiffuse=max(max(calc(17,i)));
    maxLightSpecular=max(max(calc(18,i)));
    maxLightSpecularNew=maxLightDiffuse/lightScaleConst;
    calc(18,:)=maxLightSpecularNew.*calc(18,:)./maxLightSpecular;
end
    
%reshape into bitmapImage matrix and draw
calc(19,:)=calc(17,:)+calc(18,:);
bitmapImage=reshape(calc(19,:),ROWS,COLS);

%convert to U64
bitmapImage./max(max(bitmapImage));
bitmapImage=uint16(round(bitmapImage*65535));
bitmapImage=repmat(bitmapImage, [1 1 3]);

drawRGB(bitmapImage);

% drawBW(bitmapImage, 'ward');

%print again
display(['finishing ward render at: ' datestr(now)]);
display(' ');



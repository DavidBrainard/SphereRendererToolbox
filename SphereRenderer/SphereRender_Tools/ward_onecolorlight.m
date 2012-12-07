% ward model render, multiple light sources
% dan lichtman, 27/july/2004
% dpl27@cornell.edu

%note: the method here, using three lights at the same spot
%one each for R, G and B is unnecessary. Could just
%


% *************************
% parameters

%environmental
radius = 200;
viewPoint = [0 0 4*radius];
lightCoords = 8*radius*[1 1 1;1 1 1;1 1 1]; % one row for each light source
lightColors = [0 1 1];

%sphere characteristics
diffuseConst = .3;
specularConst = .01;
specularBlurConst = .15;
lightScaleConst = .5; %for no light scaling, set to zero.


% ******************
% temp fix for mapping error
lightCoordsOld=lightCoords;
temp=lightCoords(:,1);
lightCoords(:,1)=-lightCoords(:,2);
lightCoords(:,2)=temp;
% ******************



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
numLightSources = size(lightCoords,1);
lightDirection = normalizeRow(lightCoords);
limits = [-radius radius -radius radius];
bitmapImage = zeros(ROWS, COLS);
bitmapImageTemp = zeros(ROWS,COLS,numLightSources);
calc = zeros(19,POINTS,numLightSources);
lightIntensity=ones(1,numLightSources);

%print details
display(' ');
display(['Starting ward render at:    ' datestr(now)]);
display(['   light source location:   ' triplet(lightCoordsOld)]);
if numLightSources>1
    for x=2:numLightSources
        display(['                            ' triplet(lightCoordsOld(x,:))]);
    end
end
display(['   view point location:     ' triplet(viewPoint)]);
display(['   sphere radius:           ' num2str(radius)]);
display(['   diffuse constant:        ' num2str(diffuseConst)]);
display(['   specular constant:       ' num2str(specularConst)]);
display(['   light scale constant:    ' num2str(lightScaleConst)]);
display(['   stored image resolution: ' num2str(ROWS) 'x' num2str(COLS)]);
display(['   *processing...']);
tic;


%create a column for each point
[temp1 temp2] = ndgrid(XMIN:XMAX,YMIN:YMAX);
calc([1 2],:,:) = repmat([reshape(temp1,1,POINTS);reshape(temp2,1,POINTS)],[1 1 numLightSources]);

%find z components
calc(3,:,:) = sqrt(max(0,radius^2*ones(1,POINTS,numLightSources)-(calc(1,:,:)).^2-(calc(2,:,:)).^2));

%find surface normals, reflectance vectors and half vector
calc(4:6,:,:)=normalizeCol(calc(1:3,:,:));
calc(7:9,:,:)=normalizeCol(repmat(viewPoint', [1 POINTS numLightSources])-calc(1:3,:,:));
lightDirectionTemp=repmat(reshape(lightDirection',[3,1,numLightSources]),[1 POINTS 1]);
calc(10:12,:,:)=normalizeCol((lightDirectionTemp+calc(7:9,:,:))./2);

%find cos theta(inc), cos theta(ref), cos(delta)
calc(13,:,:)=max(0,dot3D(lightDirection,calc(4:6,:,:)));              %cos(thetaInc)
calc(14,:,:)=max(0,sum(calc(7:9,:,:).*calc(4:6,:,:)));                %cos(thetaR)
calc(15,:,:)=max(0,sum(calc(10:12,:,:).*calc(4:6,:,:)));              %cos(delta)

%find which pixels reflect light  %START HERE!!!
i=[find(calc(13,:,:)&calc(14,:,:)&calc(15,:,:))]';
slices = round(ceil(i/POINTS));
cols = round(POINTS*(i/POINTS-fix(i/POINTS)));
numCols = length(cols);
numSlices = max(slices);

%find tan^2 delta for reflecting points
% calc(16,cols,slices)=(ones(1,cols,numSlices)-[calc(15,cols,slices)].^2)./[calc(15,cols,slices)].^2;  %find tan^2 of non-zero deltas
calc(16,i)=(ones(size(calc(15,i)))-[calc(15,i)].^2)./[calc(15,i)].^2;  %find tan^2 of non-zero deltas


%find light reflected from the sphere at each pixel
calc(17,i)=diffuseConst.*calc(13,i);                           %diffuse light
calc(18,i) = ...                                               %specular light
    (ones(size(calc(13,i))).*(pi*specularConst))./sqrt(calc(13,i).*calc(14,i)) .* ...
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
    calc(18,i)=maxLightSpecularNew.*calc(18,i)./maxLightSpecular;
end
    
%reshape into three channel bitmap image
calc(19,:,:)=calc(17,:,:)+calc(18,:,:);
bitmapImageTemp=reshape(calc(19,:,:),[ROWS COLS numLightSources]);

%scale color values to color of light source
lightColors = reshape(lightColors,[1 1 3]);
lightColors = repmat(lightColors,[ROWS COLS 1]);
bitmapImageTemp=lightColors.*bitmapImageTemp;

bitmapImage=bitmapImageTemp;

%convert to U64
bitmapImage./max(max(max(bitmapImage))); %scale to max value
bitmapImage=uint16(round(bitmapImage*65535));
% bitmapImage=repmat(bitmapImage, [1 1 3]);

drawRGB(bitmapImage);

% drawBW(bitmapImage, 'ward');

%print again
display(['Finished ward render at: ' datestr(now)]);
toc;
display(' ');



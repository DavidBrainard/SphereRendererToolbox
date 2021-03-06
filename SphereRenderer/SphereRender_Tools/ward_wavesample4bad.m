% ward model render, hyperspectral light sources, spectral and diffuse
% reflectance
% dan lichtman, 29/july/2004
% dpl27@cornell.edu

clear all;


% *************************
% parameters

%environment
startWavelength=400; %(not radius!!)
sampleInterval=10;
numSamples=31;
sampleVec=[startWavelength sampleInterval numSamples];

%load macbeth colors
load sur_macbeth
colors=SplineSrf(S_macbeth,sur_macbeth,sampleVec);

%load light source
load spd_D65;
daylightIntensity=SplineSpd(S_D65,spd_D65,sampleVec);

%spacial
radius=200;
viewPoint=[0 0 4*radius];
lightCoords=8*radius*[1 1 1;-1 -1 1]; % one row for each light source
lightIntensity=[daylightIntensity .25*daylightIntensity];
% lightIntensity=repmat(daylightIntensity,1,1);
ambientLightIntensity=0*daylightIntensity;
lightScaleConst=.5; %for no light scaling, set to zero.
ambientConst=0;

%sphere characteristics
diffuseConst = [colors(:,17)]';
% diffuseConst = .3*ones(1,numSamples);
specularConst = .01*ones(1,numSamples);
specularBlurConst = .03;


%do some calculations for globals
XMIN = -radius;
XMAX = radius;
YMIN = -radius;
YMAX = radius;
ROWS = XMAX-XMIN+1;
COLS = YMAX-YMIN+1;
POINTS = ROWS*COLS;


%set operational variables
numLightSources = size(lightCoords,1);
lightDirection = normalizeRow(lightCoords);
limits = [-radius radius -radius radius];


%print details
display(' ');
display(['Starting ward render at:    ' datestr(now)]);
display(['   light source location:   ' triplet(lightCoords)]);
if numLightSources>1
    for x=2:numLightSources
        display(['                            ' triplet(lightCoords(x,:))]);
    end
end
display(['   view point location:     ' triplet(viewPoint)]);
display(['   sphere radius:           ' num2str(radius)]);
display(['   light scale constant:    ' num2str(lightScaleConst)]);
display(['   stored image resolution: ' num2str(ROWS) 'x' num2str(COLS)]);
display(['   *processing...']);
tic;

% *************************
% geometry
display('      geometry...');

%create a column for each point
geometry = zeros(12,POINTS,numLightSources);
[temp1 temp2] = ndgrid(XMIN:XMAX,YMIN:YMAX);
geometry([1 2],:,:) = repmat([reshape(temp1,1,POINTS);reshape(temp2,1,POINTS)],[1 1 numLightSources]);

% only do calculations for points within the circle
i=[find(geometry(1,:,:).^2+geometry(2,:,:).^2<=radius^2)]';
sigPoints=length(i)/numLightSources;
geometrySmall=zeros(12,sigPoints,numLightSources);
temp1=geometry(1:2,i);
temp2=geometrySmall(1:2,[1:length(i)]);
geometrySmall(1:2,[1:length(i)])=geometry(1:2,i);


%find z components
geometrySmall(3,:,:) = sqrt(max(0,radius^2*ones(1,sigPoints,numLightSources)-(geometrySmall(1,:,:)).^2-(geometrySmall(2,:,:)).^2));


%find surface normals, reflectance vectors and half vector
geometrySmall(4:6,:,:)=normalizeCol(geometrySmall(1:3,:,:));                              %surface normal
geometrySmall(7:9,:,:)=normalizeCol(repmat(viewPoint', [1 sigPoints numLightSources])-geometrySmall(1:3,:,:));
                                                                                %reflectance vector
lightDirectionTemp=repmat(reshape(lightDirection',[3,1,numLightSources]),[1 sigPoints 1]); 
geometrySmall(10:12,:,:)=normalizeCol((lightDirectionTemp+geometrySmall(7:9,:,:))./2);    %half vector

%find cos theta(inc), cos theta(ref), cos(delta)
angles=zeros(4,sigPoints,numLightSources);
angles(1,:,:)=max(0,dot3D(lightDirection,geometrySmall(4:6,:,:)));                   %cos(thetaInc)
angles(2,:,:)=max(0,sum(geometrySmall(7:9,:,:).*geometrySmall(4:6,:,:)));                 %cos(thetaR)
angles(3,:,:)=max(0,sum(geometrySmall(10:12,:,:).*geometrySmall(4:6,:,:)));               %cos(delta)
j=[find(angles(1,:,:)&angles(2,:,:)&angles(3,:,:))]';                           %find which pixels actually reflect light
angles(4,j)=(ones(size(angles(3,j)))-[angles(3,j)].^2)./[angles(3,j)].^2;       %find tan^2 of non-zero deltas
temp1=geometry(:,1);
temp2=geometrySmall;

geometry(:,i)=geometrySmall(:,1:length(i));
clear geometry %save some memory
clear lightDirectionTemp;


% *************************
% diffuse and ambient light
display('      diffuse/ambient light reflectance...');
diffuseConstTemp=repmat(diffuseConst',[1 numLightSources]);
reflectedDiffuseLightTemp=diffuseConstTemp.*lightIntensity;
reflectedDiffuseLightTemp=repmat(reshape(reflectedDiffuseLightTemp,[numSamples 1 numLightSources]),[1 POINTS 1]);
cosThetaI=repmat(angles(1,:,:),[numSamples 1 1]);
reflectedDiffuseLight=zeros([numSamples POINTS numLightSources]);
reflectedDiffuseLight(:,j)=cosThetaI(:,j).*reflectedDiffuseLightTemp(:,j);
clear diffuseConstTemp;

% ambient light
j=find(angles(2,:,:));
reflectedAmbientLight=zeros(size(reflectedDiffuseLight));
reflectedAmbientLight(:,j)=repmat(ambientLightIntensity,[1 length(j)]);
clear reflectedDiffuseLightTemp;


% *************************
% specular light
display('      specular light reflectance...');
cosThetaR=repmat(angles(2,:,:),[numSamples 1 1]);
tanDelta=repmat(angles(4,:,:),[numSamples 1 1]);
specularConstTemp=repmat(specularConst',[1 numLightSources]);
reflectedSpecularLightTemp=specularConstTemp.*lightIntensity;
reflectedSpecularLightTemp=repmat(reshape(reflectedSpecularLightTemp,[numSamples 1 numLightSources]),[1 POINTS 1]);

reflectedSpecularLight=zeros([numSamples POINTS numLightSources]);
reflectedSpecularLight(:,j)=reflectedSpecularLightTemp(:,j).*(1./sqrt(cosThetaI(:,j).*cosThetaR(:,j))).* ...
    exp(-tanDelta(:,j)/specularBlurConst^2)/(4*specularBlurConst^2);
clear reflectedSpecularLightTemp;
clear cosThetaI;
clear cosThetaR;
clear tanDelta;


% *************************
% process into RGB image
display('      transforming and scaling color values...');

%transform color of each pixel from spectral to XYZ color coordinates
load T_xyz1931;
T_xyz1931t=SplineCmf(S_xyz1931, T_xyz1931, sampleVec);
imageXYZDiffuse=T_xyz1931t*sum(reflectedDiffuseLight,3);
imageXYZSpecular=T_xyz1931t*sum(reflectedSpecularLight,3);
imageXYZAmbient=T_xyz1931t*sum(reflectedAmbientLight,3);
clear reflectedDiffuseLight;
clear reflectedSpecularLight;

%scale max luminance of specular light wrt max lum of diffuse
if lightScaleConst>0
    maxLightDiffuse=max(imageXYZDiffuse(2,:));
    maxLightSpecular=max(imageXYZSpecular(2,:));
    if maxLightSpecular>maxLightDiffuse
        maxLightSpecularNew=maxLightDiffuse/lightScaleConst;
        imageXYZSpecular=maxLightSpecularNew.*imageXYZSpecular./maxLightSpecular;
    end
end

imageXYZ=imageXYZSpecular+imageXYZDiffuse;
imageXYZ=imageXYZ+imageXYZAmbient;

[imageSRGBPrimary M]=XYZToSRGBPrimary(imageXYZ);
imageRGB=SRGBGammaCorrect(imageSRGBPrimary);
clear imageXYZ;
clear imageSRGBPrimary;
clear M;

%reshape and display image
display('      displaying image...');
imageRGBfinal=zeros(ROWS,COLS,3);
% for x=1:POINTS
%     for c=1:3
%         [i j k]=ind2sub([ROWS COLS 3],x);
%         imageRGBfinal(i,j,k)= imageRGB(c,x);
%     end
% end
imageRGBfinal(:,:,1)=rot90(reshape(imageRGB(1,:),[ROWS COLS]));
imageRGBfinal(:,:,2)=rot90(reshape(imageRGB(2,:),[ROWS COLS]));
imageRGBfinal(:,:,3)=rot90(reshape(imageRGB(3,:),[ROWS COLS]));
imageRGBfinal=uint8(imageRGBfinal);

figure;
imshow(imageRGBfinal);

%print end
display(['Finished ward render at: ' datestr(now)]);
toc;
display(' ');


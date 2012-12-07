% ward model render, hyperspectral light sources, spectral and diffuse
% reflectance
% dan lichtman, 28/july/2004
% dpl27@cornell.edu

clear all;


% *************************
% parameters

%environment
startWavelength=400;
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
radius=50;
viewPoint=[0 0 4*radius];
lightCoords=8*radius*[1 -1 1;]; % one row for each light source
lightIntensity=repmat(daylightIntensity,1,1);
ambientLightIntensity=0*ones(numSamples,1);
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

% fix for mapping error
lightCoordsOld=lightCoords;
% temp=lightCoords(:,1);
% lightCoords(:,1)=-lightCoords(:,2);
% lightCoords(:,2)=temp;

%set operational variables
numLightSources = size(lightCoords,1);
lightDirection = normalizeRow(lightCoords);
limits = [-radius radius -radius radius];
geometry = zeros(12,POINTS,numLightSources);
angles = zeros(4,POINTS,numLightSources);

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
% display(['   diffuse constant:        ' num2str(diffuseConst)]);
% display(['   specular constant:       ' num2str(specularConst)]);
display(['   light scale constant:    ' num2str(lightScaleConst)]);
display(['   stored image resolution: ' num2str(ROWS) 'x' num2str(COLS)]);
display(['   *processing...']);
tic;

% *************************
% geometry
display('      geometry...');


%create a column for each point
[temp1 temp2] = ndgrid(XMIN:XMAX,YMIN:YMAX);
geometry([1 2],:,:) = repmat([reshape(temp1,1,POINTS);reshape(temp2,1,POINTS)],[1 1 numLightSources]);

%find z components
geometry(3,:,:) = sqrt(max(0,radius^2*ones(1,POINTS,numLightSources)-(geometry(1,:,:)).^2-(geometry(2,:,:)).^2));
j=find(geometry(3,:,:)>1e-9);

%find surface normals, reflectance vectors and half vector
geometry(4:6,:,:)=normalizeCol(geometry(1:3,:,:));                              %surface normal
geometry(7:9,:,:)=normalizeCol(repmat(viewPoint', [1 POINTS numLightSources])-geometry(1:3,:,:));
                                                                                %reflectance vector
lightDirectionTemp=repmat(reshape(lightDirection',[3,1,numLightSources]),[1 POINTS 1]); 
geometry(10:12,:,:)=normalizeCol((lightDirectionTemp+geometry(7:9,:,:))./2);    %half vector

%find cos theta(inc), cos theta(ref), cos(delta)
angles(1,:,:)=max(0,dot3D(lightDirection,geometry(4:6,:,:)));                   %cos(thetaInc)
angles(2,:,:)=max(0,sum(geometry(7:9,:,:).*geometry(4:6,:,:)));                 %cos(thetaR)
angles(3,:,:)=max(0,sum(geometry(10:12,:,:).*geometry(4:6,:,:)));               %cos(delta)
i=[find(angles(1,:,:)&angles(2,:,:)&angles(3,:,:))]';                           %find which pixels actually reflect light
angles(4,i)=(ones(size(angles(3,i)))-[angles(3,i)].^2)./[angles(3,i)].^2;       %find tan^2 of non-zero deltas
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
reflectedDiffuseLight(:,i)=cosThetaI(:,i).*reflectedDiffuseLightTemp(:,i);
clear diffuseConstTemp;

% ambient light
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
reflectedSpecularLight(:,i)=reflectedSpecularLightTemp(:,i).*(1./sqrt(cosThetaI(:,i).*cosThetaR(:,i))).* ...
    exp(-tanDelta(:,i)/specularBlurConst^2)/(4*specularBlurConst^2);
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
imageRGBfinal=imageRGBfinal./max(max(max(imageRGBfinal)));


figure;
imshow(imageRGBfinal);

%print end
display(['Finished ward render at: ' datestr(now)]);
toc;
display(' ');

clear all;

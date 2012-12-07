% DoMatlabSphereRender
%
% This renders a sphere using our from scratch Matlab code, for comparison with orthogonal renderings
% with Radiance and PBRT.
%
% Sets sphere rendering parameters that would have otherwise been taken 
% from the SphereRenderer gui, then executes rendering according to 
% SphereRenderer rendering algorithm.
%
% This produces files sphereRenderer_imageData.mat, sphereRenderer_imageRGBtoneMapped.mat,
% and sphereRendererimageRGBtoneMapped.jpg.
%
% 1/26/08  dhb  Added some comments.

% Clear
clear;

%set general parameters
S=[400 10 31];
%___sphere is centered at the origin
radius=300;
%___view point is along the z-axis
viewPoint=1000;

%set light parameters
%____for more than one light, add more rows...
lightCoords=[1e6 1e6 1e6];
%____...and more than one column in lightIntensity
%____(col vector)
load spd_D65;
lightIntensity(:,1)=SplineSpd(S_D65,spd_D65,S);
%lightIntensity(:,1)=1000*ones(S(3),1);
%____sets ambient light to .1% of first point light's intensity
%____(col vector)
ambientLightIntensity=0*lightIntensity(:,1);

%set object reflectance
load sur_macbethPeter;
macbethColors=SplineSrf(S_macbethPeter,sur_macbethPeter,S);
%___diffuse reflectance set here to macbeth color number 13 (blue)
%___(row vector)
diffuseSurfaceReflectance=macbethColors(:,12)';
%___specularReflectance
%___(row vector)
specularSurfaceReflectance=.07*ones(1,S(3));
%___specular blur
%___(const)
specularBlur=.05;

%tonemap, just for viewing the monitor image, is set automatically below

%put into params struct formatted for SphereRenderer
%___general
params.radius=radius;
params.viewPoint=[0 0 viewPoint];
params.numSamples=S(3);
params.sampleVec=S;
%___lights
params.lightCoords=lightCoords;
params.numLights=size(lightCoords,1);
params.lightIntensity=lightIntensity;
params.ambientLightIntensity=ambientLightIntensity;
%___diffuse reflectance
params.diffuseConst=diffuseSurfaceReflectance;
%___specular reflectance
params.specularConst=specularSurfaceReflectance;
%___specular blur
params.specularBlurConst=specularBlur*ones(S(3),1);
%___tonemap
params.toneMapName='cutOff';
params.toneMapLock=0;
params.cutOff.meanMultiplier=3;

% pass on to render
%___don't care about toneMapProfile
toneMapProfile=render(params);

% Take sphere renderer off path
% Add sphere renderer to path
if (~any(findstr(path,'SphereRenderer_Matlab')))
    rmpath(genpath([pwd '/../../SphereRenderer_Matlab']));
end

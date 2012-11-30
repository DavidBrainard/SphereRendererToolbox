function reflectedDiffuseLight=ward_DiffuseLight(params,angles)
% reflectedDiffuseLight=calculateWardDiffuseLight(params,angles)
%
% 12 august 2004 dpl wrote it.
% 9 september 2007 dpl changed to add normalization constant

diffuseConst=params.diffuseConst;
numLightSources=params.numLightSources;
lightIntensity=params.lightIntensity;
numSamples=params.numSamples;
numLightSources=params.numLightSources;
numPoints=params.numPoints;

% find points from which light is reflected
i=[find(angles(1,:,:)&angles(2,:,:)&angles(3,:,:))]';

% calculate how much diffuse light is reflected
diffuseConstTemp=repmat(diffuseConst',[1 numLightSources]);
reflectedDiffuseLightTemp=diffuseConstTemp.*lightIntensity;
reflectedDiffuseLightTemp=repmat(reshape(reflectedDiffuseLightTemp, ... 
    [numSamples 1 numLightSources]),[1 numPoints 1]);
cosThetaI=repmat(angles(1,:,:),[numSamples 1 1]);
reflectedDiffuseLight=zeros([numSamples numPoints numLightSources]);
reflectedDiffuseLight(:,i)=cosThetaI(:,i).*reflectedDiffuseLightTemp(:,i);

%normalize (to make this a Lambertian BRDF)
reflectedDiffuseLight(:,i)=reflectedDiffuseLight(:,i)/pi;

function reflectedAmbientLight=ward_AmbientLight(params,angles)
% reflectedAmbientLight=ward_AmbientLight(params,angles)
%
% 12 august 2004 dpl wrote it.

numSamples=params.numSamples;
numPoints=params.numPoints;
numLightSources=params.numLightSources;
ambientLightIntensity=params.ambientLightIntensity;

% ambient light
j=find(angles(2,:,:));
reflectedAmbientLight=zeros([numSamples numPoints numLightSources]);
reflectedAmbientLight(:,j)=repmat(ambientLightIntensity,[1 length(j)]);
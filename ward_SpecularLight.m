function reflectedSpecularLight=ward_SpecularLight(params,angles)
% reflectedSpecularLight=ward_SpecularLight(params,angles)
%
% 12 august 2004 dpl wrote it.
% 8/7/07 dpl changed to return matrix of zeros if specularBlurConst is 0

numSamples=params.numSamples;
specularConst=params.specularConst;
numLightSources=params.numLightSources;
specularBlurConst=params.specularBlurConst;
lightIntensity=params.lightIntensity;
numPoints=params.numPoints;


if(specularBlurConst)
    % fine where light is reflected
    i=[find(angles(1,:,:)&angles(2,:,:)&angles(3,:,:))]';

    % shape vectors for calculation
    cosThetaI=repmat(angles(1,:,:),[numSamples 1 1]);
    cosThetaR=repmat(angles(2,:,:),[numSamples 1 1]);
    tanDelta=repmat(angles(4,:,:),[numSamples 1 1]);
    specularConstTemp=repmat(specularConst',[1 numLightSources]);
    specularBlurConstTemp=repmat(specularBlurConst,[1 length(i)]);
    reflectedSpecularLightTemp=specularConstTemp.*lightIntensity;
    reflectedSpecularLightTemp=repmat(reshape(reflectedSpecularLightTemp, ... 
        [numSamples 1 numLightSources]),[1 numPoints 1]);

    % do calculation
    reflectedSpecularLight=zeros([numSamples numPoints numLightSources]);
    reflectedSpecularLight(:,i)=reflectedSpecularLightTemp(:,i).*(1./sqrt(cosThetaI(:,i).*cosThetaR(:,i))).* ...
        exp(-tanDelta(:,i)./specularBlurConstTemp.^2)./(4*pi*specularBlurConstTemp.^2);
    %%%is this necessary?
    reflectedSpecularLight(:,i)=reflectedSpecularLight(:,i).*cosThetaI(:,i);
    %%%
else
    %return matrix of zeros
    reflectedSpecularLight=zeros([numSamples numPoints numLightSources]);
end
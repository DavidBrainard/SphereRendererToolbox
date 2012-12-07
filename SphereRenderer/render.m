function toneMapProfile=render(params)
% toneMapProfile=render(params)
%
% render the image of the sphere by calculating surface geometry,
% applying the ward model to this geometry and tone mapping the resulting
% XYZ color data into a displayable image, then displays the image.
%
% params can come from getGUIParams, or can be filled manually. it
% must include the fields set by getGUIParams, which are:
% sampleVec [start inc numIncs], radius (pixels), viewPoint [x y z],
% numLightSources, lightCoords ([x y z], one row per light),
% lightIntensity ([x; y; z], one col per light), daylightIntensity (1 col, usually
% loaded from D65 and splined to fit sampleVec), ambientLightIntensity
% (1 col), diffuseConst (1 col), specularConst (1 col), specularBlur
% (1 col), toneMapName (string, must match the name of a function in toneMaps folder
% which must be part of the matlab path), toneMapLock (boolean),
% toneMapProfile (if using a previously generated profile, created by a
% toneMap function)
%
% 11 august 2004 dpl wrote it.



% ward model render, hyperspectral light sources, spectral and diffuse
% reflectance
% dan lichtman, 29/july/2004
% dpl27@cornell.edu
% 3 august 2004 dpl added support for hyperspectral specular blur
% 11 august 2004 dpl adapted parameters structure
% 8/7/07 dpl save hyperspectral image



% add a few fields to params
params.xmin=-params.radius;
params.xmax=params.radius;
params.ymin=-params.radius;
params.ymax=params.radius;
params.rows=params.xmax-params.xmin+1;
params.cols=params.ymax-params.ymin+1;
params.numPoints=(params.xmax-params.xmin+1)*(params.ymax-params.ymin+1);
params.numLightSources=size(params.lightCoords,1);
params.numSamples=params.sampleVec(3);

% display params
printParams(params);

% calculate geometry
display('      geometry...');
angles=calculateSurfaceGeometry(params);

% apply ward model
[reflectedLight reflectedDiffuseLight reflectedAmbientLight reflectedSpecularLight]=ward(params,angles);

%save hyperspectral image in cwd
imageData=list2image(params,reflectedLight);
save sphereRenderer_imageData imageData

% tone map
display('      applying tone map...');
[imageXYZList toneMapProfile]=toneMap(params,reflectedLight, reflectedDiffuseLight, ...
    reflectedSpecularLight, reflectedAmbientLight);
    
% display image
imageRGB=imshowXYZ(params,imageXYZList);
save sphereRenderer_imageRGBtoneMapped imageRGB
imwrite(imageRGB,'sphereRendererimageRGBtoneMapped.jpg');


%print end
display(['Finished ward render at: ' datestr(now)]);
display(['Will display in figure window ' num2str(gcf) '.']);
% displayStatus(hObject,handles,'done.');
toc;
display(' ');




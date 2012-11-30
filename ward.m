function [reflectedLight reflectedDiffuseLight reflectedAmbientLight reflectedSpecularLight]=ward(params, angles)
% [reflectedLight reflectedDiffuseLight reflectedAmbientLight reclectedSpecularLight]=ward(params)
%
% calculate the reflected light at each point according to
% the ward model. angles must observe the same format as
% the output array of calculateSurfaceGeometry. output of ward is in list
% format specified by calculateSurfaceGeometry. see image2list and
% list2image for conversion between list and square data formats.
%
% 12 august dpl wrote it.

% calculate diffuse light
display('      diffuse light reflectance...');
reflectedDiffuseLight=ward_DiffuseLight(params,angles);

% calculate ambient light
display('      ambient light reflectance...');
reflectedAmbientLight=ward_AmbientLight(params,angles);

% calculate specular light
display('      specular light reflectance...');
reflectedSpecularLight=ward_SpecularLight(params,angles);

% add them together
reflectedLight=reflectedDiffuseLight+reflectedAmbientLight+reflectedSpecularLight;

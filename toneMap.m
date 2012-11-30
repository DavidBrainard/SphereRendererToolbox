function [imageXYZList toneMapProfile]=toneMap(params,varargin)
%   [imageXYZList toneMapProfile]=toneMap(params,varargin)
%
% maps list of hyperspectral intensity values (see 
% calculateSurfaceGeometry for explanation of list format) 
% to a list of XYZ color values (see imshowXYZ for conversion
% to a square of RGB color values). the first argument must be
% params, which must contain the fields toneMapName and toneMapLock,
% specifying the tone map to be applied and whether the tone map
% should use a profile saved from a previous mapping. if a saved
% profile is to be used, a field 
% toneMapProfile.[toneMapName].[propertyName] must be present for
% each relevant property. a toneMapProfile is generated 
% by each toneMap function each time it runs.
%
% if the tone map to be applied only requires one input argument in
% addition to params, this function only requires that array
% as the second and final input argument. if the toneMap requires
% more than one input argument, list them after params when calling
% this function in the order specified by the tone map.
%
% this function returns a list of XYZ values, and the profile
% created by the tone map (if there are two output arguments specified)
%
% 12 august 2004 dpl wrote it.

% convert hyperspectral input arrays into XYZ coords
for x=1:length(varargin)
    vararginXYZ{x}=hyperspectral2XYZ(params,varargin{x});
end


% get number of input args the current toneMap takes
toneMapParams=eval(params.toneMapName);
numArgs=toneMapParams{1};

% build command string so that we can apply the appropriate tonemap
% with the appropriate arguments as specified in the parameters
% passed to the function
commandString=[params.toneMapName '(params'];
if numArgs==3
    for x=2:length(varargin)
        commandString=[commandString ', vararginXYZ{' num2str(x) '}'];
    end
elseif numArgs==1
    commandString=[commandString ', vararginXYZ{' num2str(1) '}'];
else
    display('error--current toneMap not supported');
    return;
end
commandString=[commandString ');'];

% execute the tone mapping
[imageXYZList toneMapProfile]=eval(commandString);
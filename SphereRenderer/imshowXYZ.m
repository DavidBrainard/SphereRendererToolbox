function imageRGB=imshowXYZ(params,imageXYZ)
%   imageRGB=imshowXYZ(params,imageXYZ)
%
% display an image in a new window. imageXYZ may be either a list or a
% square (see image2list and list2image). params must include .rows and
% .cols. returns a square array of RGB color values, each slice
% corresponding the the R,G and B values for that point.
%
% if params includes either of toneMapName, toneMapLock, these will be
% displayed in the title
%
% august 2004 dpl wrote it.
% 19 august 2004 dpl added titles

if size(imageXYZ,1)~=3
    imageXYZList=image2list(params,imageXYZ);
else
    imageXYZList=imageXYZ;
end


[imageSRGBPrimary M]=XYZToSRGBPrimary(imageXYZList);
imageRGBList=SRGBGammaCorrect(imageSRGBPrimary);

imageRGB=uint8(list2image(params,imageRGBList));

figure;
imshow(imageRGB);

titleString='ward';
if isfield(params,'toneMapName')
    titleString=[titleString ', ' params.toneMapName];
end
if isfield(params,'toneMapLock')
    if params.toneMapLock
        titleString=[titleString ', using saved tone map settings'];
    end
end
title(titleString);
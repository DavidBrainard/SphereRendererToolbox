function [imageXYZListSplitScale toneMapProfileOut]=splitScale(params,imageXYZDiffuseList,imageXYZSpecularList,imageXYZAmbientList)
% imageXYZList=splitScale(params,reflectedLight)
%
% if function is called with no arguments, it returns a cell in which the first
% element specifies how many input vectors the function takes (for now, 1
% means that the function uses the sum of diffuse, ambient and specular
% light). the following elements of the cell specify the names of the parameters the
% function uses, which it expects to find in
% params.[function_name].[parameter_name] this is used by ward_gui in order
% to allow the user to specify the value of each parameter.
%
% if there are two output arguments, the second output is the profile of
% the settings used to execute the current tone mapping. this struct
% consists of toneMapProfile.splitScale.maxLightSpecularNew
%
% if params.toneMapLock is true, this function expects to find a saved
% profile from its last execution in
% params.toneMapProfile.splitScale with the same fields as
% those mentioned above.
%
% if the number of light lists passed is more than one, pass them in the
% following order: diffuse, specular, ambient
%
% 12 august 2004 dpl wrote it.



if nargin==0
    imageXYZListSplitScale{1}=3;
    imageXYZListSplitScale{2}='lightConst';
    return;
end

useSaved=params.toneMapLock;

if useSaved
    maxLightSpecularNew=params.toneMapProfile.splitScale.maxLightSpecularNew;
else
    maxLightDiffuse=max(imageXYZDiffuseList(2,:));
    maxLightAmbient=max(imageXYZAmbientList(2,:));
    maxLightSpecularNew=maxLightDiffuse*(1/params.splitScale.lightConst-1);
    toneMapProfile.splitScale.maxLightSpecularNew=maxLightSpecularNew;
end
maxLightSpecular=max(imageXYZSpecularList(2,:));
imageXYZSpecularNew=maxLightSpecularNew.*imageXYZSpecularList./maxLightSpecular;
imageXYZListSplitScale=imageXYZDiffuseList+imageXYZAmbientList+imageXYZSpecularNew;

% end function
if (nargout==2)
    if useSaved
        toneMapProfileOut=params.toneMapProfile;
    else
        if isfield(params,'toneMapProfile')
            toneMapProfileOut=params.toneMapProfile;
        end
        toneMapProfileOut.splitScale=toneMapProfile.splitScale;
    end
end

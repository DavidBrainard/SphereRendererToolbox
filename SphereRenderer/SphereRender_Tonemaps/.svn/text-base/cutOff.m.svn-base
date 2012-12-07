function [imageXYZListCutOff toneMapProfileOut]=cutOff(params,imageXYZList)
% imageXYZList=cutOff(params,reflectedLight)
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
% consists of toneMapProfile.cutOff.cutOff.
%
% if params.toneMapLock is true, this function expects to find a saved
% profile from its last execution in
% params.toneMapProfile.cutOff with the same fields as
% those mentioned above.
%
% if the number of light lists passed is more than one, pass them in the
% following order: diffuse, specular, ambient
%
% 12 august 2004 dpl wrote it.

if nargin==0
    imageXYZListCutOff{1}=1;
    imageXYZListCutOff{2}='meanMultiplier';
    return;
end

useSaved=params.toneMapLock;

if useSaved
    cutOff=params.toneMapProfile.cutOff.cutOff;
else
    cutOff=params.cutOff.meanMultiplier*mean(imageXYZList(2,:));
    toneMapProfile.cutOff.cutOff=cutOff;
end


i=find(imageXYZList(2,:)>cutOff);
imageXYZListCutOff=imageXYZList;
imageXYZListCutOff(:,i)=repmat((cutOff./imageXYZList(2,i)),3,1).*imageXYZList(:,i);


% end function
imageXYZListCutOff(:,i)=repmat((cutOff./imageXYZList(2,i)),3,1).*imageXYZList(:,i);
if (nargout==2)
    if useSaved
        toneMapProfileOut=params.toneMapProfile;
    else
        if isfield(params,'toneMapProfile')
            toneMapProfileOut=params.toneMapProfile;
        end
        toneMapProfileOut.cutOff=toneMapProfile.cutOff;
    end
end
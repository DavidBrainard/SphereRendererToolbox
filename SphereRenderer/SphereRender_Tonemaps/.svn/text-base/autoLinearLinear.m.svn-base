function [imageXYZListLinearLinear toneMapProfileOut]=autoLinearLinear(params,imageXYZList)
% [imageXYZListLinearLinear toneMapProfile]=autoLinearLinear(params,imageXYZList)
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
% consists of toneMapProfile.autoLinearLinear.[cutOff,
% maxLightSpecularNew].
%
% if params.toneMapLock is true, this function expects to find a saved
% profile from its last execution in
% params.toneMapProfile.autoLinearLinear with the same fields as
% those mentioned above.
%
% if the number of light lists passed is more than one, pass them in the
% following order: diffuse, specular, ambient
%
% 12 August 2004 dpl wrote it.
%
% 12 august 2004 dpl wrote it.

if nargin==0
    imageXYZListLinearLinear{1}=1;
    imageXYZListLinearLinear{2}='lightConst';
    return;
end

% see if we're using saved params
useSaved=params.toneMapLock;

% find where imageXYZList isn't zero
i=find(imageXYZList(2,:));
imageXYZListNoZero=imageXYZList(2,i);

% get max value of image, and generate histogram bins

yMax=max(imageXYZListNoZero);
if useSaved
    cutOff=params.toneMapProfile.autoLinearLinear.cutOff;
else
    numBins=1000;
    binMax=log10(yMax);
    bins=logspace(0,binMax,numBins);
    histogram=hist(imageXYZListNoZero,bins);

    % chop off bottom of histogram and find max
    populated=find(histogram);
    [minPopulated minPopulatedIndex]=min(populated);
    chop=round(.05*numBins+minPopulated);
    histogram(1:chop)=0;
    [histMax index]=max(histogram);

    % set cut off point to be at center of next bin
    cutOff=1.1*bins(index);
    toneMapProfile.autoLinearLinear.cutOff=cutOff;
end


% find image minus bright spots
imageXYZListNoBright=zeros(size(imageXYZList));
j=find(imageXYZList(2,:)<cutOff);
imageXYZListNoBright(:,j)=imageXYZList(:,j);

% find image of bright spots
imageXYZListBright=zeros(size(imageXYZList));
k=find(imageXYZList(2,:)>=cutOff);
imageXYZListBright(:,k)=imageXYZList(:,k);

% now scale bright image given parameters
maxLightSpecular=max(imageXYZListBright(2,:));
if useSaved
    maxLightSpecularNew=params.toneMapProfile.autoLinearLinear.maxLightSpecularNew;
else
    maxLightDiffuse=max(imageXYZListNoBright(2,:));
    
    maxLightSpecularNew=maxLightDiffuse*(1/params.autoLinearLinear.lightConst-1);
    toneMapProfile.autoLinearLinear.maxLightSpecularNew=maxLightSpecularNew;
end
imageXYZListBrightNew=zeros(size(imageXYZListBright));
imageXYZListBrightNew=maxLightSpecularNew.*imageXYZListBright./maxLightSpecular;

        

imageXYZListBrightSquare=list2image(params,imageXYZListBright);
imageXYZListNoBrightSquare=list2image(params,imageXYZListNoBright);

% find ave color around the bright spot
[i j]=find(imageXYZListBrightSquare(:,:,2)==yMax);
numBrightPixelsPerSpot=length(k)/params.numLightSources;
measuringRadius=ceil(1.5*sqrt(numBrightPixelsPerSpot/pi));
imageXYZListNoBrightSmallSquare=imageXYZListNoBrightSquare((i-measuringRadius):(i+measuringRadius),(j-measuringRadius):(j+measuringRadius),:);
n=find(imageXYZListNoBrightSmallSquare(:,:,2));
for x=[1 2 3]
    temp=imageXYZListNoBrightSmallSquare(:,:,x);
    averageColor(x)=mean(mean(temp(n)));
end

% fill in center with this color
temp=repmat(averageColor',[1 length(k)]);
imageXYZListNoBright=imageXYZListNoBright;
imageXYZListNoBright(:,k)=temp;

% find places with large change, and replace those places with this color
imageXYZListNoBrightSquare=list2image(params,imageXYZListNoBright);
imageXYZListNoBrightSmallSquare=imageXYZListNoBrightSquare((i-measuringRadius):(i+measuringRadius),(j-measuringRadius):(j+measuringRadius),:);
noBrightChange=zeros(params.rows,params.cols);
change=gradient(imageXYZListNoBrightSmallSquare(:,:,2));
averageChange=mean(mean(abs(change)));
p=find(abs(change)>averageChange);
for x=1:3
    temp=imageXYZListNoBrightSmallSquare(:,:,x);
    temp(p)=averageColor(x);
    imageXYZListNoBrightSmallSquare(:,:,x)=temp;
end

% blur this area
blurFilter=1-fspecial('gaussian',8,3);
blurFilter=blurFilter/sum(sum(blurFilter));
imageXYZListNoBrightSmallSquare=imfilter(imageXYZListNoBrightSmallSquare,blurFilter,'replicate');

imageXYZListNoBrightSquare((i-measuringRadius):(i+measuringRadius),(j-measuringRadius):(j+measuringRadius),:)=imageXYZListNoBrightSmallSquare;
imageXYZListNoBright=image2list(params,imageXYZListNoBrightSquare);


% end function
imageXYZListLinearLinear=imageXYZListNoBright+imageXYZListBrightNew;
if (nargout==2)
    if useSaved
        toneMapProfileOut=params.toneMapProfile;
    else
        if isfield(params,'toneMapProfile')
            toneMapProfileOut=params.toneMapProfile;
        end
        toneMapProfileOut.autoLinearLinear=toneMapProfile.autoLinearLinear;
    end
end


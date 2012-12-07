function imageSquare=list2image(params,imageList)
% imageSquare=list2image(params,imageList)
%
% turns a list of color values into a square array in which each point in
% the array corresponds to the color value of a pixel. each slice of the
% resulting array corresponds to each row of the list given as input.
%
% this function assums that points in the list, moving left to right, 
% correspond to points in the original image moving left to 
% right across each row, bottom to top.
%
% params must include .rows and .cols
%
% august 2004 dpl wrote it.

[rowsList colsList]=size(imageList);

for x=1:rowsList
    imageSquareTemp(:,:,x)=rot90(reshape(imageList(x,:),[params.rows params.cols]));
end

imageSquare=imageSquareTemp;
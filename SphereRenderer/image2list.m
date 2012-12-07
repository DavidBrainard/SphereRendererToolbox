function imageList=image2list(params,imageSquare)
%   imageList=image2list(params,imageSquare)
%
% turn square array of color data into a list of color data. each slice of
% the array in the third dimention is transformed into a row of the list,
% the first slice mapped to the first row, etc...
%
% points in the list, moving left to right, correspond to points in the
% original image moving left to right across each row, bottom to top.
%
% params must include .rows and .cols
%
% august 2004 dpl wrote it.

points=(params.rows)*(params.cols);
slicesSquare=size(imageSquare,3);

for x=1:slicesSquare
    imageList(x,:)=reshape(rot90(imageSquare(:,:,x),-1),[1 points 1]);
end

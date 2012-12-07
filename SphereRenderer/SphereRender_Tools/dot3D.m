function A = dot3D(X,Y)
% A = dot3D(X,Y)
%
% X is n-by-3, each row is a triplet in 3-splace
% Y is 3-by-n-by-m. each column in each slice is a triplet
% dot3D dots the triplet in each row of X with every
% triplet in the corresponding slice of Y

numRows = size(X,1);
numPoints = size(Y,2);

X = reshape(X',[3 1 numRows]);
X = repmat(X, [1 numPoints 1]);

A = sum(X.*Y);



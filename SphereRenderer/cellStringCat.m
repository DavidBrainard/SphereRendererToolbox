function newCell=cellStringCat(cell,string)
% cellStringCat(cell,string)
%
% append string to the bottom cell
%
% 2 August 2004 dpl wrote it.

i=length(cell);
cell{i+1}=string;

newCell=cell;
function [r c] = c2m(x,y)
% [r c] = c2m(x,y)
%
% converts coords x and y to the appropriate
% row and colomn of an image matrix given globals
% XMIN, XMAX, YMIN and YMAX

global XMIN;
global YMAX;

c=x-XMIN+1;
r=YMAX+1-y;
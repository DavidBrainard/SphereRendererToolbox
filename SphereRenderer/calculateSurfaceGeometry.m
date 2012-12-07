function [anglesOut geometryOut]=calculateSurfaceGeometry(params)
%   [anglesOut geometryOut]=calculateSurfaceGeometry(params)
% calculate surface normals reflectance vectors, 
% half vectors, cos(thetaIncident), cos(thetaReflected),tan^2(delta)
% for each point (pixel)
%
% params must include: radius, viewPoint (1x3),
% lightCoords (numSources x 3)
%
% in the returned arrays, each point in the image is represented
% by a single column, with each slice in the third dimention 
% representing the information for that point with respect
% to a specific light source. the columns, from left to right,
% represent points moving from left to right of each row
% of the image starting at the bottom row. see image2list 
% and list2image for conversion between list and square data
% formats.
%
% for geometry: rows 1-3:   coords of the point (x,y,z)
%                    4-6:   coords of surface norm
%                    7-9:   coords of reflectance vector
%                    10-12: coords of incident vector
%                    13-15: coords of half vector specified by ward
% for angles:   rows 1:     cos(thetaIncident)
%                    2:     cos(thetaReflected)
%                    3:     cos(delta) - delta is half angle between
%                                        incident & reflected
%                    4:     tan^2(delta)
%6
% 11 august 2004 dpl wrote it.

% get params
radius=params.radius;
viewPoint=params.viewPoint;
lightCoords=params.lightCoords;
xmin=params.xmin;
xmax=params.xmax;
ymin=params.ymin;
ymax=params.ymax;
numPoints=params.numPoints;
numLightSources=params.numLightSources;

% find direction vector of light
% (this works if we treat the light
% as a point source infinitely distant)
lightDirection = normalizeRow(lightCoords);

% preallocate contiginous blocks for arrays (helps speed)
geometry = zeros(15,numPoints,numLightSources);
angles = zeros(4,numPoints,numLightSources);

% create a column for each point
%__x and y components
[temp1 temp2] = ndgrid(xmin:xmax,ymin:ymax);
geometry([1 2],:,:) = repmat([reshape(temp1,1,numPoints);reshape(temp2,1,numPoints)],[1 1 numLightSources]);
%__z components
geometry(3,:,:) = sqrt(max(0,radius^2*ones(1,numPoints,numLightSources)-(geometry(1,:,:)).^2-(geometry(2,:,:)).^2));

%find surface normals, reflectance vectors and half vector
%__surface norm
geometry(4:6,:,:)=normalizeCol(geometry(1:3,:,:));
%__reflectance vector
%____for orthographic projection, each x,y point on the sphere points towards
%    the projection plane,which is in front of the sphere (z is greater
%    than the local z coordinate). so, normalized, (x,y,z)=(0,0,1).
geometry(7:8,:,:)=zeros(2,numPoints,numLightSources);
geometry(9,:,:)=ones(1,numPoints,numLightSources);
%__incident vector (light point - surface point)
lightCoords=repmat(reshape(lightCoords',[3,1,numLightSources]),[1 numPoints 1]);
geometry(10:12,:,:)=normalizeCol(lightCoords-geometry(1:3,:,:));
%__half vector
geometry(13:15,:,:)=normalizeCol(geometry(13:15,:,:)+geometry(7:9,:,:));

%find cos theta(inc), cos theta(ref), cos(delta)
%__cos(thetaIncident)
angles(1,:,:)=max(0,sum(geometry(10:12,:,:).*geometry(4:6,:,:)));
%__cos(thetaReflected)
angles(2,:,:)=max(0,sum(geometry(7:9,:,:).*geometry(4:6,:,:)));
%__cos(delta)
halfVector=normalizeCol(geometry(7:9,:,:)+geometry(10:12,:,:));
angles(3,:,:)=max(0,sum(halfVector.*geometry(4:6,:,:)));
%__tan^2(delta)
i=[find(angles(1,:,:)&angles(2,:,:)&angles(3,:,:))]';
angles(4,i)=(ones(size(angles(3,i)))-[angles(3,i)].^2)./[angles(3,i)].^2;

% return calculated values
anglesOut=angles;
if nargout==2
    geometryOut=geometry;
end

function printParams(params)
% printParams(params)
% format data and print on command line
%
% 12 august 2004 dpl wrote it.

%print details
display(' ');
display(['Starting ward render at:    ' datestr(now)]);
display(['   light source location:   ' triplet(params.lightCoords)]);
if params.numLightSources>1
    for x=2:params.numLightSources
        display(['                            ' triplet(params.lightCoords(x,:))]);
    end
end
display(['   view point location:     ' triplet(params.viewPoint)]);
display(['   sphere radius:           ' num2str(params.radius)]);
display(['   tone map:                ' params.toneMapName]);
if params.toneMapLock
    display(['   tone map lock:           on' ]);
else
    display(['   tone map lock:           off' ]);
end
display(['   stored image resolution: ' num2str(params.rows) 'x' num2str(params.cols)]);
display(['   *processing...']);
tic;
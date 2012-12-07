% test script

%constants
radius = 150;
lightCoords = [0 1 5]';
lightIntensity = 1;
reflectionCoeff = 1;
ambientLightIntensity = .05;
ambientReflectionCoeff = 1;

%globals
global XMIN;
global XMAX;
global YMIN;
global YMAX;
global ROWS;
global COLS;

%do some calculations for globals
XMIN = -radius;
XMAX = radius;
YMIN = -radius;
YMAX = radius;
ROWS = XMAX-XMIN+1;
COLS = YMAX-YMIN+1;

%set operational constants
lightDirection = lightCoords/sqrt(sum(lightCoords.^2));
limits = [-radius radius -radius radius];
image = zeros(ROWS, COLS);

for x=-radius:1:radius
    for y=-radius:1:radius
            if (x^2+y^2<=radius^2)
                z=abs(sqrt(radius^2-x^2-y^2));
                N=[x y z]/sqrt(x^2+y^2+z^2);
                cosTheta=max(0,N*lightDirection);
                I=lightIntensity*reflectionCoeff*cosTheta ...
                    +ambientLightIntensity+ambientReflectionCoeff;
                [r c]=c2m(x,y);
                image(r,c)=I;
            else
                [r c]=c2m(x,y);
                image(r,c)=0;
            end
    end
end

drawBW(image);



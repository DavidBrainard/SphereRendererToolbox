% ward model
% dan lichtman, 23/july/2004
% dpl27@cornell.edu

clear all;

%constants
radius = 300;
viewPoint = [0 0 4*radius];
lightCoords = 8*radius*normalize1([-1 -1 1]);
lightIntensity = 1;
reflectionCoeff = 1;
ambientLightIntensity = .002;
ambientReflectionCoeff = .2;
diffuseConst = .29;
specularConst = .083;
specularBlurConst = .082;
c1 = .25;
c2 = .25;
c3 = .5;

%print details
display(' ');
display(['starting ward render at: ' datestr(now)]);

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
YMAX = radius;
ROWS = XMAX-XMIN+1;
COLS = YMAX-YMIN+1;

%set operational constants
lightDist = sqrt(sum(lightCoords.^2));
lightDirection = normalize1(lightCoords);
limits = [-radius radius -radius radius];
image = zeros(ROWS, COLS);


for x=-radius:1:radius
    for y=-radius:1:radius
            if (x^2+y^2<=radius^2)
                z=abs(sqrt(radius^2-x^2-y^2));
                surfaceNorm=normalize1([x y z]);
                reflectionDirection = normalize1(viewPoint-[x y z]);
                halfVector = normalize1((lightDirection+reflectionDirection)/2);
                       
                cosThetaIncident = max(0,lightDirection*surfaceNorm');
                cosThetaReflected = max(0,reflectionDirection*surfaceNorm');
                if cosThetaIncident*cosThetaReflected > 0
                    specularCos=1/sqrt(cosThetaIncident*cosThetaReflected);
                    
                    cosDelta = halfVector*surfaceNorm';
                    delta = acos(cosDelta);
                    tanDelta = tan(delta);
                    %tanDelta = sqrt(1-cosDelta^2)/cosDelta;
                    specularExp = exp(-tanDelta^2/specularBlurConst^2)/ ... 
                            (4*pi*specularBlurConst^2);
                else
                    specularCos=0;
                    specularExp=0;
                end
                
                diffuseLightIntensity=lightIntensity*cosThetaIncident*diffuseConst/pi;
                
                specularLightIntensity=lightIntensity*specularConst*specularCos*specularExp;
                
                I=(diffuseLightIntensity+specularLightIntensity)*pi;
                
                [r c]=c2m(x,y);
                image(r,c)=I;
            else
                [r c]=c2m(x,y);
                image(r,c)=0;
            end
    end
end

drawBW(image, 'ward');

%print again
display(['finishing ward render at: ' datestr(now)]);
display(' ');



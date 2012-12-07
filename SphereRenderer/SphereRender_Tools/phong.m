% test script

%constants
radius = 300;
viewPoint = [0 0 4*radius];
lightCoords = 4*radius*normalize([1 1 1])';
lightIntensity = 1;
reflectionCoeff = 1;
ambientLightIntensity = .002;
ambientReflectionCoeff = .2;
kPhong = .5;
nPhong = 250;
c1 = .25;
c2 = .25;
c3 = .5;

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
lightDist = sqrt(sum(lightCoords.^2));
lightDirection = normalize(lightCoords);
limits = [-radius radius -radius radius];
image = zeros(ROWS, COLS);


for x=-radius:1:radius
    for y=-radius:1:radius
            if (x^2+y^2<=radius^2)
                z=abs(sqrt(radius^2-x^2-y^2));
                N=normalize([x y z]);
                cosTheta=max(0,N*lightDirection);
                V=normalize(viewPoint-[x y z]);
                phongCosTheta=max(0,(2*N*(N*lightDirection)-lightDirection')*V');
                pointDist=sqrt((x-lightCoords(1))^2+(y-lightCoords(2))^2 ...
                    +(z-lightCoords(3))^2);
                f=max(1/(c1+c2*pointDist+c3*pointDist^2),1);
                I=f*(lightIntensity*reflectionCoeff*cosTheta +kPhong*phongCosTheta^nPhong)...
                    +ambientLightIntensity+ambientReflectionCoeff;
                [r c]=c2m(x,y);
                image(r,c)=I;
            else
                [r c]=c2m(x,y);
                image(r,c)=0;
            end
    end
end

drawBW(image, 'phong');



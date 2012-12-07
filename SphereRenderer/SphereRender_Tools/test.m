% test script

%constants
radius = 50;
lightCoords = [0 1 1]';
lightIntensity = 1;
reflectionCoeff = 1;
ambientLightIntensity = .2;
ambientReflectionCoeff = 1;

%set operational constants
lightDirection = lightCoords/sqrt(sum(lightCoords.^2));
limits = [-radius radius -radius radius];
dan = axespic(limits);

for x=-radius:1:radius
    for y=-radius:1:radius
            if (x^2+y^2<=radius^2)
                z=abs(sqrt(radius^2-x^2-y^2));
                N=[x y z]/sqrt(x^2+y^2+z^2);
                cosTheta=max(0,N*lightDirection);
                I=lightIntensity*reflectionCoeff*cosTheta ...
                    +ambientLightIntensity+ambientReflectionCoeff;
                dan(x,y)=I;
            else
                dan(x,y)=0;
            end
    end
end

dan;

draw(dan);
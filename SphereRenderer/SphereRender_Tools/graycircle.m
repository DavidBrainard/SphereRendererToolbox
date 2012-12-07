%generate a sphere

%define constants
XMAX = 1000;
YMAX = 1000;
RADIUS = 10;

%initialize I
I=ones(XMAX,YMAX).*RADIUS;


for x=1:XMAX
    for y=1:YMAX
        r = sqrt((x-XMAX/2)^2+(y-YMAX/2)^2);
        if r <=RADIUS
            I(x,y)=r;
        end
    end
end

imagesc(I,[0 RADIUS]);
colormap(gray);
axis square;
            



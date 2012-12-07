function [dacs] = xyz2rgb(XYZ)

% function [dacs] = xyz2rgb(XYZ, gogvals, A)
% converts XYZ to RGB DACS for a monitor
% XYZ is a 3 by 1 matrix containing the XYZ values
% gogvals is a 3 by 2 matrix containing the gamma and gain
% for each of the three channels
% A is a 3 by 3 matrix to transform RGB to XYZ

RGB=inv(A)*XYZ;

dacs(1) = compigog(gogvals(1,:), RGB(1));
dacs(2) = compigog(gogvals(2,:), RGB(2));
dacs(3) = compigog(gogvals(3,:), RGB(3));

dacs = dacs*255;

if (dacs(1)>255)
    dacs(1) = 255;
end
if (dacs(2)>255)
    dacs(2) = 255;
end
if (dacs(3)>255)
    dacs(3) = 255;
end

if (dacs(1)<0)
    dacs(1) = 0;
end
if (dacs(2)<0)
    dacs(2) = 0;
end
if (dacs(3)<0)
    dacs(3) = 0;
end

dacs = dacs(:);



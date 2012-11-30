function lightXYZ=hyperspectral2XYZ(params,lightHyperspectral)
% lightXYZ=hyperspectral2XYZ(lightHyperspectral)
%
% 12 august 2004 dpl wrote it.

%transform color of each pixel from spectral to XYZ color coordinates
load T_xyz1931;
T_xyz1931t=SplineCmf(S_xyz1931, T_xyz1931, params.sampleVec);
lightXYZ=T_xyz1931t*sum(lightHyperspectral,3);

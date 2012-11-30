function doBatchRender(hObject,handles)
% doBatchRender(hObject,handles)
%
% 7/30/07 dpl wrote it.

%set location of directory to save the scene in.
%%for now hard code it
sceneDirectory='/Users/dan/work/working/auto_sphere_renderer/';
% if exist(sceneDirectory,'dir')
%     answer=questdlg('Scene directory already exists. Click ''Yes'' to over write, or ''No'' to cancel.');
%     if(~strcmp(answer,'Yes'))
%         return;
%     end
%     unix(['rm -rf ' sceneDirectory]);
% end
if exist(sceneDirectory)
    rmdir(sceneDirectory,'s');
end
mkdir(sceneDirectory);

% get settings from gui
guiParams=getGUIParams(hObject,handles);
S=guiParams.sampleVec;
radius=guiParams.radius;
viewPoint=guiParams.viewPoint;
numLightSources=guiParams.numLightSources;
lightCoords=guiParams.lightCoords;
lightIntensity=guiParams.lightIntensity;
daylightIntensity=guiParams.daylightIntensity;
ambientLightIntensity=guiParams.ambientLightIntensity;
diffuseConst=guiParams.diffuseConst;
specularConst=guiParams.specularConst;
specularBlurConst=guiParams.specularBlurConst;

%save object reflectance spectra in the scene directory
S_sphereRenderer_objectSpectra=S;
sur_sphereRenderer_objectSpectra=diffuseConst';
save([sceneDirectory 'sur_sphereRenderer_objectSpectra'],'S_sphereRenderer_objectSpectra','sur_sphereRenderer_objectSpectra');

%save light reflectance spectra in the scene directory
S_sphereRenderer_LightSpectra=S;
spd_sphereRenderer_LightSpectra=lightIntensity;
save([sceneDirectory 'spd_sphereRenderer_LightSpectra'],'S_sphereRenderer_LightSpectra','spd_sphereRenderer_LightSpectra');

%RADIANCE
%create scene objects directory and make sphere
mkdir([sceneDirectory 'scene_objects']);
str=['theSphere sphere theSphereOBJ\n' ...
    '0\n' ...
    '0\n' ...
    '4 0 0 0 ' num2str(radius) '\n'];
f=fopen([sceneDirectory 'scene_objects/theSphere.rad'],'wt');
fprintf(f,str);
fclose(f);

%create lights
for i=1:numLightSources
    str=['pointlight' num2str(i) ' sphere pointlight' num2str(i) 'OBJ\n' ...
        '0\n' ...
        '0\n' ...
        '4 ' num2str(lightCoords(i,1)) ' ' num2str(lightCoords(i,2)) ' ' num2str(lightCoords(i,3)) ' .001\n'];
    f=fopen([sceneDirectory 'scene_objects/pointlight' num2str(i) '.rad'],'wt');
    fprintf(f,str);
    fclose(f);
end

%creat view file
mkdir([sceneDirectory 'view_files']);
angleOfView=2*atand(radius/viewPoint(3));
str=['rview -vtv -vp 0 0 ' num2str(viewPoint(3)) ' -vd 0 0 -1 -vu 0 1  ' num2str(viewPoint(3)) ...
    ' -vh ' num2str(angleOfView) ' -vv ' num2str(angleOfView) '\n'];
fopen([sceneDirectory 'view_files/view.vf'],'wt');
fprintf(f,str);
fclose(f);

%copy .cal files that radiance needs
fileDirectory=Data_FindDirectoryOnPath('SphereRender_RadianceFiles');
copyfile([fileDirectory '/rayinit.cal'],sceneDirectory);
copyfile([fileDirectory '/tmesh.cal'], sceneDirectory);

%PBRT
%%do pbrt part


%CONDITIONS FILE
f=fopen('conditions.txt','wt');
%add field names line
str=['sceneName\trenderer\timageRes\twavelengthsStart\twavelengthsStep\twavelengthsNumSteps\tviewFile\n'];
fprintf(f,str);
%add radiance line
resolution=radius*2+1;
str=['con_rad\tradiance\t' num2str(resolution) '\t' num2str(S(1)) '\t' num2str(S(2)) '\t' num2str(S(3)) '\tview.vf\n'];
fprintf(f,str);
%add pbrt line
%%add it here

%OBJECT PROPERTIES.TXT
f=fopen('objectProperties.txt');
%add field names line
str=['objectName\tobjectType\tglossiness\troughness\tspectrumNumber\tspectrumType\n'];
fprintf(f,str);
%add the sphere
%%fix glossiness&roughness
str=['theSphere\tward\t0\t0\t1\tsur_sphereRenderer_objectSpectra\n'];
fprintf(f,str);

%LIGHT PROPERTIES.TXT
f=fopen('lightProperties.txt');
%add field names line
str=['lightName\tspectrumNumber\tspectrumType\tlightType\n'];
fprintf(f,str);
%add light line for each light
for i=1:numLightSources
    str=['pointlight' num2str(i) '\t' num2str(i) '\tsur_sphereRenderer_LightSpectra\tpoint\n'];
    fprintf(f,str);
end






function guiSettings=getGUIParams(hObject,handles)
% function guiSettings=getGUIParams(hObject,handles)
%
% return the current user settings in struct guiSettings. to see
% fields of guiSettings, enter this command withough a semicolon
%
% 11 august 2004    dpl wrote it.

% make sure there is at least one light
if handles.currentLight<=1
    display('you must have at least one point light');
    return;
end

% *************************
% get values from GUI

% don't load new sample vector from GUI. just use from each light source.
% also note, this function will not work if light sources were entered
% at different sampling spectrums.

numSamples=handles.sampleVec(3);

% load data
load spd_D65;
handles.daylightIntensity=SplineSpd(S_D65,spd_D65,handles.sampleVec);
daylightIntensity=handles.daylightIntensity;
load sur_macbeth;
colors=SplineSrf(S_macbeth,sur_macbeth,handles.sampleVec);

% params
guiSettings.sampleVec=handles.sampleVec;
guiSettings.radius=str2num(get(handles.edit_radius,'String'));
guiSettings.viewPoint=[0 0 str2num(get(handles.edit_viewPoint,'String'))];
guiSettings.numLightSources=handles.currentLight-1;

% point light
guiSettings.lightCoords=[];
guiSettings.lightIntensityGUI=[];
for i=1:guiSettings.numLightSources
    guiSettings.lightCoords(i,:)=handles.lights(i).position;
    guiSettings.lightIntensity(:,i)=handles.lights(i).scaleFactor*handles.lights(i).spd';
end
guiSettings.daylightIntensity=handles.daylightIntensity;

% ambient light
if get(handles.radiobutton_ambientDaylight,'Value')
    choice=get(handles.popupmenu_ambientLightFiles,'Value');
    guiSettings.ambientLightIntensity=handles.lightFileData(choice).spd;
elseif get(handles.radiobutton_ambientFlat,'Value')
    guiSettings.ambientLightIntensity=ones(handles.sampleVec(3),1);
else
    guiSettings.ambientLightIntensity=str2num(get(handles.edit_ambientUserLightIntensity,'String'));
    if length(ambientLightIntensity)~=handles.sampleVec(3)
        displayStatus(hObject,handles,'User defined light intensity must contain correct number of elements.');
        return;
    end
end
guiSettings.ambientLightIntensity=str2num(get(handles.edit_ambientScaleFactor,'String'))*guiSettings.ambientLightIntensity;

% diffuse reflectance
guiSettings.diffuseConst=getDiffuseReflectance(hObject,handles);
% guiSettings.lightScaleConst=str2num(get(handles.edit_lightScaleConst,'String'));

% specular reflectance
guiSettings.specularConst=getSpecularReflectance(hObject,handles);

% specular blur
if get(handles.radiobutton_blurFlat,'Value')
    guiSettings.specularBlurConst=str2num(get(handles.edit_blurFlat,'String'));
    guiSettings.specularBlurConst=guiSettings.specularBlurConst*ones(numSamples,1);
else
    guiSettings.blurSpecifyConst=str2num(get(handles.edit_blurSpecify,'String'));
    if length(blurSpecify)~=numSamples
        display('specular blur must have right number of samples');
        return;
    end
    guiSettings.specularBlurConst=guiSettings.blurSpecify';
end

% tone map settings
choice=get(handles.popupmenu_toneMapFiles,'Value');
guiSettings.toneMapName=handles.toneMapFileData(choice).name;
guiSettings.toneMapLock=get(handles.checkbox_toneMapLock,'Value');
if isfield(handles,'toneMapProfile')
    guiSettings.toneMapProfile=handles.toneMapProfile;
end

guiSettings.toneMapName;
handles;
commandString=['guiSettings.' guiSettings.toneMapName '=handles.' guiSettings.toneMapName ';'];
eval(commandString);





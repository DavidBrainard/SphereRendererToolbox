function addLight(hObject,handles)
% addLight(hObject,handles)
%
% add light to current configuration specified in GUI
%
% 2 August 2004     dpl     wrote it.
% 11 August 2004    dpl     added support for file popup menu

handles.sampleVec=str2num(get(handles.edit_sampleVec,'String'));
guidata(hObject,handles);

load spd_D65;
daylightIntensity=SplineSpd(S_D65,spd_D65,handles.sampleVec);


i=handles.currentLight;

if get(handles.radiobutton_standardDaylight,'Value')
%     handles.lights(i).spd=daylightIntensity;  %old
%     spdString='Daylight';
%     handles.lights(i).spdString=spdString;
    selection=get(handles.popupmenu_pointLightFiles,'Value');
    handles.lights(i).spd=handles.lightFileData(selection).spd;
    handles.lights(i).spdString=handles.lightFileData(selection).name;
    spdString=handles.lights(i).spdString;
    
elseif get(handles.radiobutton_flatLight,'Value')
    handles.lights(i).spd=ones(handles.sampleVec(3),1);
    spdString='Flat';
    handles.lights(i).spdString=spdString;
else
    lightIntensity=str2num(get(handles.edit_userLightIntensity,'String'));
    if length(lightIntensity)~=handles.sampleVec(3);
        display(['spd must have ' sampleVec(3) 'elements']);
        return;
    end
    handles.lights(i).spd=lightIntensity;
    spdString='User defined';
    handles.lights(i).spdString=spdString;
end
position=get(handles.edit_lightPosition,'String');
handles.lights(i).position=str2num(position);
handles.lights(i).scaleFactor=str2num(get(handles.edit_scaleFactor,'String'));

lightList=get(handles.listbox_lightList,'String');
lightList{i}=['Light ' num2str(i) ': ' position ', ' spdString ', scale factor: ' num2str(handles.lights(i).scaleFactor)];

set(handles.listbox_lightList,'String',lightList');
handles.currentLight=handles.currentLight+1;

guidata(hObject,handles);
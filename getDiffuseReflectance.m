function diffuseReflectance=getDiffuseReflectance(hObject,handles)


numSamples=handles.sampleVec(3);

scaleFactor=str2num(get(handles.edit_diffuseScaleFactor,'String'));
if get(handles.radiobutton_diffuseColorFiles,'Value')
    choice=get(handles.popupmenu_diffuseColorFiles,'Value');
    diffuseReflectance=scaleFactor*[handles.colorFileData(choice).srf]';
elseif get(handles.radiobutton_diffuseMacbeth,'Value')
    macbethColor=get(handles.popupmenu_diffuseMacbeth,'Value');
    diffuseReflectance=scaleFactor*[handles.macbethColors(:,macbethColor)]';
elseif get(handles.radiobutton_diffuseFlat,'Value')
    diffuseReflectance=scaleFactor*ones(1, numSamples);
else
    diffuseSpecify=str2num(get(handles.edit_diffuseSpecify,'String'));
    if length(diffuseSpecify)~=numSamples;
        displayStatus(hObject,handles,'diffuse const must be right length');
        return;
    end
    diffuseReflectance=scaleFactor*diffuseSpecify;
end


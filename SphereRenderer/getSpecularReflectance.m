function specularReflectance=getSpecularReflectance(hObject,handles)

numSamples=handles.sampleVec(3);

scaleFactor=str2num(get(handles.edit_specularScaleFactor,'String'));
if get(handles.radiobutton_specularColorFiles,'Value')
    choice=get(handles.popupmenu_specularColorFiles,'Value');
    specularReflectance=scaleFactor*[handles.colorFileData(choice).srf]';
elseif get(handles.radiobutton_specularMacbeth,'Value')
    macbethColor=get(handles.popupmenu_specularMacbeth,'Value');
    specularReflectance=scaleFactor*[handles.macbethColors(:,macbethColor)]';
elseif get(handles.radiobutton_specularFlat,'Value')
    specularReflectance=scaleFactor*ones(1, numSamples);
else
    specularSpecify=str2num(get(handles.edit_specularSpecify,'String'));
    if length(specularSpecify)~=numSamples;
        displayStatus(hObject,handles,'specular const must be right length');
        return;
    end
    specularReflectance=scaleFactor*specularSpecify;
end


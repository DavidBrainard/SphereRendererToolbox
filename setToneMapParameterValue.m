function handles=setToneMapParameterValue(hObject,handles)
% handles=setToneMapParameterValue(hObject,handles)
%
% 13 august 2004 dpl wrote it.

parameterNames=get(handles.listbox_toneMapParameterList,'String');
if iscell(parameterNames)
    choice=get(handles.listbox_toneMapParameterList,'Value');
    currentParameterName=parameterNames{choice};
else
    currentParameterName=parameterNames;
end
currentToneMapName=handles.currentToneMapName;
value=get(hObject,'String');

commandString=['handles.' currentToneMapName '.' currentParameterName '=' value ';'];
eval(commandString);
guidata(hObject,handles);
function handles=updateToneMapParameterValue(hObject,handles)
% handles=updateToneMapParameterValue(hObject,handles);
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

% see if any parameters for this toneMap have been set yet
if ~isfield(handles,currentToneMapName)
    set(handles.edit_toneMapParameterValue,'String','not set');
    return;
end

% see if this parameter has been set
if ~isfield(eval(['handles.' currentToneMapName]),currentParameterName)
    set(handles.edit_toneMapParameterValue,'String','not set');
    return;
end

% it has already been set, display the value
parameterValue=eval(['handles.' currentToneMapName '.' currentParameterName]);
set(handles.edit_toneMapParameterValue,'String',parameterValue);
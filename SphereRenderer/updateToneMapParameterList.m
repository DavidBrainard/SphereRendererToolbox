function handles=updateToneMapParameterList(hObject,handles)
% handles=updateToneMapParameterList(hObject,handles)
%
% 13 august 2004 dpl wrote it.

% get selection
choice=get(handles.popupmenu_toneMapFiles,'Value');
toneMapName=handles.toneMapFileData(choice).name;

% get parameters for selected tone map
parameters=eval([toneMapName '()']);

% make cell of strings to put in list of params
listString=parameters{2:end};

% put this string into the listbox
set(handles.listbox_toneMapParameterList,'String',listString);

% set this as the current tonemap
handles.currentToneMapNumber=choice;
handles.currentToneMapName=toneMapName;

guidata(hObject,handles);
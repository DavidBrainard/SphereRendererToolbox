function handles=loadToneMap(hObject,handles)
% handles=loadToneMap(hObject,handles)
%
% 13 august 2004 dpl        Wrote it.
% 3/15/05        dhb, bx    Look for tonemap code in local directory.

% load lights from files
toneMapDirectory=Data_FindDirectoryOnPath('SphereRender_Tonemaps');
toneMapFileNames=dir([toneMapDirectory '/*.m']);
numFiles=length(toneMapFileNames);
default=1;

% process each item in the list
for x=1:numFiles
    name=toneMapFileNames(x).name;
    listString{x,1}=name(1:end-2);
    handles.toneMapFileData(x).name=name(1:end-2);
    guidata(hObject,handles);
end

% populate listboxes and set default selection to D65
set(handles.popupmenu_toneMapFiles,'String',listString);
set(handles.popupmenu_toneMapFiles,'Value',default);
guidata(hObject,handles);
listString={};

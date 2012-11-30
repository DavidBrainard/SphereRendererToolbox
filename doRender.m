function handles=doRender(hObject,handles)
% handles=doRender(hObject,handles)
%
% gets params from gui (stored in handles), passes parameters
% to render
%
% 2 August 2004 dpl wrote it.
% 11 august 2004    added support for popupmenus    dpl
% 11 august 2004    modularized code                dpl

% get settings from gui
guiParams=getGUIParams(hObject,handles);

% pass on to render
toneMapProfile=render(guiParams);

% save profile
handles.toneMapProfile=toneMapProfile;
guidata(hObject,handles);
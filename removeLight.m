function removeLight(hObject,handles)
% removeLight(hObject,handles)
%
% remove the selected light from the current configuration
%
% 2 August 2004 dpl wrote it.

max=handles.currentLight-1;
choice=get(handles.listbox_lightList,'Value');


% check if there are any lights to remove
if max==0
    display('there must be a light to remove');
    return;
end


% move elements up one space
for i=choice:(max-1)
    handles.lights(i)=handles.lights(i+1);
end

% remove last element, which is a duplicate now of the second to last
handles.lights=handles.lights(1:(max-1));
handles.currentLight=max;

%build new list to display in list box
lightList='';
for i=1:(max-1)
    lightNum=num2str(i);
    position=triplet(handles.lights(i).position);
    spdString=handles.lights(i).spdString;
    scaleFactor=num2str(handles.lights(i).scaleFactor);
    lightList{i}=['Light ' lightNum ': ' position ', ' spdString ', scale factor: ' scaleFactor];
end

% save settings
set(handles.listbox_lightList,'Value',1);
set(handles.listbox_lightList,'String',lightList);
guidata(hObject,handles);


%%%%%%%%%%%%%%%%%%%
% fix bug with light number in listbox string. does not affect function
% fixed.
%%%%%%%%%%%%%%%%%%%%

function handlesNew=loadLightsAndColors(hObject,handles)
% loadLightsAndColors(hObject,handles)
%
% 11 August 2004    dpl     wrote it.


sampleVec=handles.sampleVec;
default=1;

% load lights from files
lightDirectory=Data_FindDirectoryOnPath('SphereRender_Lights');
lightFileNames=dir([lightDirectory '/*.mat']);
numFiles=length(lightFileNames);


% process each item in the list
for x=1:numFiles
    name=lightFileNames(x).name;
    load([lightDirectory '/' name]);
    sampleVecIn=eval(['S_' name(5:end-4)]);
    spdIn=eval(name(1:end-4));
    spd=SplineSpd(sampleVecIn, spdIn, sampleVec);
    listString{x,1}=name(5:end-4);
    if strcmp(name,'spd_D65.mat')
        default=x;
    end
    handles.lightFileData(x).name=name(5:end-4);
    handles.lightFileData(x).spd=spd;
    guidata(hObject,handles);
end

% populate listboxes and set default selection to D65
set(handles.popupmenu_pointLightFiles,'String',listString);
set(handles.popupmenu_pointLightFiles,'Value',default);
set(handles.popupmenu_ambientLightFiles,'String',listString);
set(handles.popupmenu_ambientLightFiles,'Value',default);
guidata(hObject,handles);
listString={};

% load color files
colorsDirectory=Data_FindDirectoryOnPath('SphereRender_Colors');
colorFileNames=dir([colorsDirectory '/*.mat']);
numFiles=length(colorFileNames);

% process each item
j=1;
for i=1:numFiles
    name=colorFileNames(i).name;
    if strcmp(name,'sur_macbeth.mat')
        continue;
    end
    load([colorsDirectory '/' name]);
    sampleVecIn=eval(['S_' name(5:end-4)]);
    srfIn=eval(name(1:end-4));
    srf=SplineSrf(sampleVecIn, srfIn, sampleVec);
    for k=1:size(srf,2)
        tempNameString=[name(5:end-4) ' ' num2str(k)];
        listString{j,1}=tempNameString;
        handles.colorFileData(j).name=tempNameString;
        handles.colorFileData(j).srf=srf(:,k);
        j=j+1;
    end
    guidata(hObject,handles);
end

% populate listboxes and set default selection to D65
set(handles.popupmenu_diffuseColorFiles,'String',listString);
set(handles.popupmenu_diffuseColorFiles,'Value',default);
set(handles.popupmenu_specularColorFiles,'String',listString);
set(handles.popupmenu_specularColorFiles,'Value',default);
guidata(hObject,handles);





handlesNew=handles;
function varargout = ward_gui(varargin)
% WARD_GUI M-file for ward_gui.fig
%      WARD_GUI, by itself, creates a new WARD_GUI or raises the existing
%      singleton*.
%
%      H = WARD_GUI returns the handle to a new WARD_GUI or the handle to
%      the existing singleton*.
%
%      WARD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WARD_GUI.M with the given input arguments.
%
%      WARD_GUI('Property','Value',...) creates a new WARD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ward_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ward_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help ward_gui

% Last Modified by GUIDE v2.5 01-Aug-2007 16:26:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ward_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ward_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ward_gui is made visible.
function ward_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ward_gui (see VARARGIN)

% Choose default command line output for ward_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% set light params
sampleVec=[400 10 31];
handles.lights(1).position=[];
handles.lights(1).spd=[];
handles.sampleVec=[400 10 31];
handles.currentLight=1;
handles.lightFileData(1).name='';
handles.lightFileData(1).spd=[];
handles.colorFileData(1).name='';
handles.colorFileData(1).srf=[];

% populate light and color popup menu
handles=loadLightsAndColors(hObject,handles);

% populate tone map popup menu
handles=loadToneMap(hObject,handles);

% get macbeth colors
load sur_macbeth;
handles.macbethColors=SplineSrf(S_macbeth,sur_macbeth,handles.sampleVec);

set(handles.edit_sampleVec,'String',num2str(handles.sampleVec));

% set default pointlight settings

% set default ambient light settings
set(handles.edit_ambientScaleFactor,'String','.01');

% set default reflectance settings
set(handles.radiobutton_diffuseMacbeth,'Value',1);
set(handles.popupmenu_diffuseMacbeth,'Value',13);
set(handles.edit_diffuseScaleFactor,'String',1);
set(handles.radiobutton_specularFlat,'Value',1);
set(handles.edit_specularScaleFactor,'String',.01);
set(handles.edit_blurFlat,'String',.03);
% set(handles.edit_lightScaleConst,'String',.5);
set(handles.edit_ambientScaleFactor,'String',.0025);
set(handles.radiobutton_blurFlat,'Value',1);

guidata(hObject,handles);

% add a light
addLight(hObject,handles);



% UIWAIT makes ward_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ward_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_render.
function pushbutton_render_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_render (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=doRender(hObject,handles);


function edit_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_radius as text
%        str2double(get(hObject,'String')) returns contents of edit_radius as a double




% --- Executes during object creation, after setting all properties.
function edit_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_viewPoint_Callback(hObject, eventdata, handles)
% hObject    handle to edit_viewPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_viewPoint as text
%        str2double(get(hObject,'String')) returns contents of edit_viewPoint as a double


% --- Executes during object creation, after setting all properties.
function edit_viewPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_viewPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_lightCoords_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lightCoords (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lightCoords as text
%        str2double(get(hObject,'String')) returns contents of edit_lightCoords as a double


% --- Executes during object creation, after setting all properties.
function edit_lightCoords_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lightCoords (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_userLightIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_userLightIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_userLightIntensity as text
%        str2double(get(hObject,'String')) returns contents of edit_userLightIntensity as a double


% --- Executes during object creation, after setting all properties.
function edit_userLightIntensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_userLightIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox_lightList.
function listbox_lightList_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_lightList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_lightList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_lightList


% --- Executes during object creation, after setting all properties.
function listbox_lightList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_lightList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_lightPosition_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lightPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lightPosition as text
%        str2double(get(hObject,'String')) returns contents of edit_lightPosition as a double


% --- Executes during object creation, after setting all properties.
function edit_lightPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lightPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton_addLight.
function pushbutton_addLight_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_addLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.lights.position=str2num(get(handles.edit_lightPosition,'String'));
% handles.lights.spd=

addLight(hObject,handles);

% --- Executes on selection change in listbox_lightList.
function lightbox_lightList_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_lightList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_lightList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_lightList


% --- Executes during object creation, after setting all properties.
function lightbox_lightList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_lightList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton_removeLight.
function pushbutton_removeLight_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_removeLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

removeLight(hObject,handles);

% --- Executes on button press in pushbutton_test.
function pushbutton_test_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list=get(handles.listbox_lightList,'String');
list{3}='hello world!';
set(handles.listbox_lightList,'String',list);


% --- Executes on button press in radiobutton_ambientDaylight.
function radiobutton_ambientDaylight_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_ambientDaylight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_ambientDaylight


% --- Executes on button press in radiobutton_ambientFlat.
function radiobutton_ambientFlat_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_ambientFlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_ambientFlat


% --- Executes on button press in radiobutton_ambientSpecifyLight.
function radiobutton_ambientSpecifyLight_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_ambientSpecifyLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_ambientSpecifyLight



function edit_ambientUserLightIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ambientUserLightIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ambientUserLightIntensity as text
%        str2double(get(hObject,'String')) returns contents of edit_ambientUserLightIntensity as a double


% --- Executes during object creation, after setting all properties.
function edit_ambientUserLightIntensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ambientUserLightIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ambientScaleFactor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ambientScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ambientScaleFactor as text
%        str2double(get(hObject,'String')) returns contents of edit_ambientScaleFactor as a double


% --- Executes during object creation, after setting all properties.
function edit_ambientScaleFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ambientScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_scaleFactor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scaleFactor as text
%        str2double(get(hObject,'String')) returns contents of edit_scaleFactor as a double


% --- Executes during object creation, after setting all properties.
function edit_scaleFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_status_Callback(hObject, eventdata, handles)
% hObject    handle to edit_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_status as text
%        str2double(get(hObject,'String')) returns contents of edit_status as a double


% --- Executes during object creation, after setting all properties.
function edit_status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox_status.
function listbox_status_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_status contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_status


% --- Executes during object creation, after setting all properties.
function listbox_status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_diffuseMacbeth.
function popupmenu_diffuseMacbeth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_diffuseMacbeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_diffuseMacbeth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_diffuseMacbeth


% --- Executes during object creation, after setting all properties.
function popupmenu_diffuseMacbeth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_diffuseMacbeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_diffuseSpecify_Callback(hObject, eventdata, handles)
% hObject    handle to edit_diffuseSpecify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_diffuseSpecify as text
%        str2double(get(hObject,'String')) returns contents of edit_diffuseSpecify as a double


% --- Executes during object creation, after setting all properties.
function edit_diffuseSpecify_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_diffuseSpecify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_specularMacbeth.
function popupmenu_specularMacbeth_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_specularMacbeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_specularMacbeth contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_specularMacbeth


% --- Executes during object creation, after setting all properties.
function popupmenu_specularMacbeth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_specularMacbeth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_specularSpecify_Callback(hObject, eventdata, handles)
% hObject    handle to edit_specularSpecify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_specularSpecify as text
%        str2double(get(hObject,'String')) returns contents of edit_specularSpecify as a double


% --- Executes during object creation, after setting all properties.
function edit_specularSpecify_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_specularSpecify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_blurFlat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_blurFlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_blurFlat as text
%        str2double(get(hObject,'String')) returns contents of edit_blurFlat as a double


% --- Executes during object creation, after setting all properties.
function edit_blurFlat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_blurFlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_diffuseScaleFactor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_diffuseScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_diffuseScaleFactor as text
%        str2double(get(hObject,'String')) returns contents of edit_diffuseScaleFactor as a double


% --- Executes during object creation, after setting all properties.
function edit_diffuseScaleFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_diffuseScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_specularScaleFactor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_specularScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_specularScaleFactor as text
%        str2double(get(hObject,'String')) returns contents of edit_specularScaleFactor as a double


% --- Executes during object creation, after setting all properties.
function edit_specularScaleFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_specularScaleFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_lightScaleConst_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lightScaleConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lightScaleConst as text
%        str2double(get(hObject,'String')) returns contents of edit_lightScaleConst as a double


% --- Executes during object creation, after setting all properties.
function edit_lightScaleConst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lightScaleConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_sampleVec_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sampleVec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sampleVec as text
%        str2double(get(hObject,'String')) returns contents of edit_sampleVec as a double


% --- Executes during object creation, after setting all properties.
function edit_sampleVec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sampleVec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_blurSpecify_Callback(hObject, eventdata, handles)
% hObject    handle to edit_blurSpecify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_blurSpecify as text
%        str2double(get(hObject,'String')) returns contents of edit_blurSpecify as a double


% --- Executes during object creation, after setting all properties.
function edit_blurSpecify_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_blurSpecify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton_plotLight.
function pushbutton_plotLight_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotPointLight(hObject,handles);


% --- Executes on button press in pushbutton_plotAmbientLight.
function pushbutton_plotAmbientLight_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotAmbientLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotAmbientLight(hObject,handles);


% --- Executes on selection change in popupmenu_pointLightFiles.
function popupmenu_pointLightFiles_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_pointLightFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_pointLightFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_pointLightFiles


% --- Executes during object creation, after setting all properties.
function popupmenu_pointLightFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_pointLightFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_ambientLightFiles.
function popupmenu_ambientLightFiles_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ambientLightFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_ambientLightFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ambientLightFiles


% --- Executes during object creation, after setting all properties.
function popupmenu_ambientLightFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ambientLightFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_diffuseColorFiles.
function popupmenu_diffuseColorFiles_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_diffuseColorFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_diffuseColorFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_diffuseColorFiles


% --- Executes during object creation, after setting all properties.
function popupmenu_diffuseColorFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_diffuseColorFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu_specularColorFiles.
function popupmenu_specularColorFiles_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_specularColorFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_specularColorFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_specularColorFiles


% --- Executes during object creation, after setting all properties.
function popupmenu_specularColorFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_specularColorFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton_plotDiffuseReflectance.
function pushbutton_plotDiffuseReflectance_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotDiffuseReflectance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sampleVec=handles.sampleVec;
samples=sampleVec(1):sampleVec(2):(sampleVec(1)+sampleVec(2)*(sampleVec(3)-1));
diffuseReflectance=getDiffuseReflectance(hObject,handles);
figure;
plot(samples,diffuseReflectance);
title('diffuse reflectance');
xlabel('wavelength (nm)');
ylabel('portion reflected');

% --- Executes on button press in pushbutton_plotSpecularReflectance.
function pushbutton_plotSpecularReflectance_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotSpecularReflectance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sampleVec=handles.sampleVec;
samples=sampleVec(1):sampleVec(2):(sampleVec(1)+sampleVec(2)*(sampleVec(3)-1));
specularReflectance=getSpecularReflectance(hObject,handles);
figure;
plot(samples,specularReflectance);
title('diffuse reflectance');
xlabel('wavelength (nm)');
ylabel('portion reflected');


% --- Executes on selection change in popupmenu_toneMapFiles.
function popupmenu_toneMapFiles_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_toneMapFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_toneMapFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_toneMapFiles

handles=updateToneMapParameterList(hObject,handles);
handles=updateToneMapParameterValue(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_toneMapFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_toneMapFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox_toneMapParameterList.
function listbox_toneMapParameterList_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_toneMapParameterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_toneMapParameterList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_toneMapParameterList

updateToneMapParameterValue(hObject,handles);


% --- Executes during object creation, after setting all properties.
function listbox_toneMapParameterList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_toneMapParameterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_toneMapParameterValue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_toneMapParameterValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_toneMapParameterValue as text
%        str2double(get(hObject,'String')) returns contents of edit_toneMapParameterValue as a double

handles=setToneMapParameterValue(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_toneMapParameterValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_toneMapParameterValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in checkbox_toneMapLock.
function checkbox_toneMapLock_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_toneMapLock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_toneMapLock


% --- Executes on button press in pushbutton_BatchRender.
function pushbutton_BatchRender_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_BatchRender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

doBatchRender(hObject,handles);


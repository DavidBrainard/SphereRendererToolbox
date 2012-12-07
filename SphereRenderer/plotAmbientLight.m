function plotAmbientLight(hObject,handles)
%work on this!!

load spd_D65;
sampleVec=handles.sampleVec;
daylightIntensity=SplineSpd(S_D65,spd_D65,handles.sampleVec);


if get(handles.radiobutton_ambientDaylight,'Value')
    spd=daylightIntensity;
    spectrumString='standard daylight';
elseif get(handles.radiobutton_ambientFlat,'Value')
    spectrumString='flat';
    spd=ones(handles.sampleVec(3),1);
else
    spd=str2num(get(handles.edit_ambientUserLightIntensity,'String'));
    spectrumString='user specified';
    if length(ambientLightIntensityGUI)~=handles.sampleVec(3)
        displayStatus(hObject,handles,'User defined light intensity must contain correct number of elements.');
        return;
    end
end
spd=str2num(get(handles.edit_ambientScaleFactor,'String'))*spd;

titleString=['ambient light, spectrum: ' spectrumString];

figure;
x=sampleVec(1):sampleVec(2):(sampleVec(1)+sampleVec(2)*(sampleVec(3)-1));
plot(x,spd);
title(titleString);
xlabel('wavelength (nm)');

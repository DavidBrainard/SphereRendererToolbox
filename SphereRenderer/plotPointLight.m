function plotPointLight(hObject,handles)

i=get(handles.listbox_lightList, 'Value');
sampleVec=handles.sampleVec;

spd=handles.lights(i).spd;
spectrumString=handles.lights(i).spdString;
titleString=['point light numer ' num2str(i) ', spectrum: ' spectrumString];

figure;
x=sampleVec(1):sampleVec(2):(sampleVec(1)+sampleVec(2)*(sampleVec(3)-1));
plot(x,spd);
title(titleString);
xlabel('wavelength (nm)');

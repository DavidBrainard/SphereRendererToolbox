function drawBWsc(image, titleString)

if nargin==1
    titleString = '';
end

scaleFactor = max(max(image));
% if scaleFactor<1
%     scaleFactor=1;
% end

figure;
imagesc(image, [0 scaleFactor]);
colormap(gray);
axis square;
axis off;
title([titleString ', ' datestr(now)]);
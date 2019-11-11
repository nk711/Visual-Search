function F=extractAverageRGB(img)
%r,g,b contains the average red, green and blue values of the image.
r = mean(reshape(img(:,:,1),1,[]));
g = mean(reshape(img(:,:,2),1,[]));
b = mean(reshape(img(:,:,3),1,[]));
F = [r,g,b];
return;

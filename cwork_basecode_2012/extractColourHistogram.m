function F = extractColourHistogram(img,q)
% floor rounds each value in a pixel to the nearest integer less than
% or equal to the calculated quantizative value
r = floor(double(img(:,:,1))*q/256);
g = floor(double(img(:,:,2))*q/256);
b = floor(double(img(:,:,3))*q/256);
bin = r*(q^2) + g*(q^1) + b;
vals = reshape(bin, 1, size(bin,1)*size(bin,2));
h = hist(vals, q^3);
F = h ./sum(h);
return;

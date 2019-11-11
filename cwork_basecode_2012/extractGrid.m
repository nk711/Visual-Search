function F = extractColourHistogram(img,r)
% floor rounds each value in a pixel to the nearest integer less than
% or equal to the calculated quantizative value
y = size(img,1);
x = size(img,2);

red = img(:,:,1);
green = img(:,:,2);
b = img(:,:,3);
%box = round(y/r) * round(x/r);


for j = 1:r
    for i = 1:r
        subimage = img(round((j)*y/r+1): round(j*y/r),round((i-1)*x/r+1):round(i*x/r));
    end
end

return;

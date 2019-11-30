% This function calculates the distance between two images
function dst=cvpr_compare(F1, F2)
dst = sqrt(sum((F1-F2).^2));
return;

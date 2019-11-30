% This function calculates the distance between two images
function dst=cvpr_compare_manhattan(F1, F2)
dst = sum(abs(F1-F2));
return;

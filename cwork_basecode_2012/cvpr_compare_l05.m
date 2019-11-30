% This function calculates the distance between two images
function dst=cvpr_compare_l05(F1, F2)
    dst = (sum(sqrt(abs(F1-F2)))).^2;
return;

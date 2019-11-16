% This function calculates the distance between two images
function dst=cvpr_compare_pca(F1, F2, V)
dst = sqrt(sum((F1-F2).^2));
%dst=norm(F1-F2);

return;

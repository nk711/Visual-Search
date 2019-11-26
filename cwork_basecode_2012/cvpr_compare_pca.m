% This function calculates the distance between two images
function dst=cvpr_compare_pca(test_obj, target_obj)
    dst = Eigen_Mahalanobis(test_obj, target_obj);
return;

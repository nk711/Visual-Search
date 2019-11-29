% This function calculates the distance between two images
function dst=cvpr_compare_pca(test_obj, target_obj)
    % target_obj is the list of images that represents the query class
    % test_obj is our candidate image
   
    target_e = Eigen_Build(target_obj);
    
    mdst = Eigen_Mahalanobis(test_obj, target_e);
    dst = mdst./max(max(result));
return;

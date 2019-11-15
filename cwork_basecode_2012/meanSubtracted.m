function images = meanSubtracted(dataset)
    % Extract the individual red, green, and blue color channels.
    
    list_of_images = cell2mat(dataset(:,1));
    
    %mean_r =mean(reshape(image(:,:,1),1,[]));
    %mean_g = mean(reshape(image(:,:,2),1,[]));
    %mean_b = mean(reshape(image(:,:,3),1,[]));
    %images = cat(3, r - mean_r, g - mean_g, b - mean_b);
    images = list_of_images
end


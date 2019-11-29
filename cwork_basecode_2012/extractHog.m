function F = extractHog(img, divisions ,bins)
% Calculates the size of each division
bin_size  = (2*pi)/(bins-1);
% No need could just use Extract HOG Features
% Sobel filters
Kx = [1 2 1 ; 0 0 0; -1 -2 -1]./4;
Ky = Kx';
%convert img to greyscale 
greyImage = img(:,:,1)*0.3+img(:,:,2)*0.59+img(:,:,3)*0.11;
%differentiate in respect to x
dx = conv2(greyImage, Kx, 'same');
%differentiate in respect to y 
dy = conv2(greyImage, Ky, 'same');
%calculating the magnitude
mag = sqrt(dx.^2+dy.^2);
%this converts atan(dy./dx) to the range of 0 and 2pi
dir = mod(atan2(dy,dx), 2*pi);
% alternative func: dir = atan2(dy,dx) + 2*pi*(dy<0);

% Calculates the length of each small grid sub section
% 255/ x
grid_size = length(img)/divisions;

list = [];
% Go through each cell of size (gridlength by gridlength) inside the image 
for grid_row=1:grid_size:length(img)
    for grid_column = 1:grid_size:length(img)
        sub_gradient = dir(grid_row:(grid_row+grid_size-1), grid_column:(grid_column+grid_size-1));
        sub_magnitude = mag(grid_row:(grid_row+grid_size-1), grid_column:(grid_column+grid_size-1));
        
        histogram = zeros(1,bins);
        
        for x=1:length(sub_gradient)
            for y=1:length(sub_gradient)
                % 0.15 is the threshold
                if sub_magnitude(x,y)>0.15
                    bin = ceil(sub_gradient(x,y)/bin_size);
                    if bin == 0
                        bin = 1;
                    end
              
                    histogram(bin) = histogram(bin)+1;
                end
            end
        end
        
        %normalising histogram
        if sum(histogram)~=0 
            h = histogram./sum(histogram);
        else
            h = histogram;
        end
       
        
        for x=1:bins 
            list = [list h(x)];
        end
        
        
        %Get the subimage 
        sub = img(grid_row:(grid_row+grid_size-1), grid_column:(grid_column+grid_size-1), :);
        %Calculate the average of the RGB 
        r = mean(reshape(sub(:,:,1),1,[]));
        g = mean(reshape(sub(:,:,2),1,[]));
        b = mean(reshape(sub(:,:,3),1,[]));
        list = [list r g b];
    end
end

F = list;
return;

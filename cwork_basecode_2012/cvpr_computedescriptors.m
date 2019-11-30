%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%% Skeleton code provided as part of the coursework assessment
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.  Currently that function returns just a random vector so should
%% be changed as part of the coursework exercise.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER1='averageRGB';
OUT_SUBFOLDER2='globalColorHistogram';
OUT_SUBFOLDER3='alexNet';
OUT_SUBFOLDER4='grid';

% set to true if you would like to use alex net to extract features
alex_net = false;

dataset = [];
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full));
    
    %Remember to set alex_net to false when trying to compute other
    %descriptors 
    
    %AVERAGE RGB [NOT REQUIRED FOR CW]
    %fout=[OUT_FOLDER,'/',OUT_SUBFOLDER1,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    %F=extractAverageRGB(img);
    %save(fout,'F');
     
    %GLOBAL COLOR HISTOGRAM
    %fout=[OUT_FOLDER,'/',OUT_SUBFOLDER2,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    %F=extractColourHistogram(img, 8);
    %save(fout,'F');
    
    %AlexNet Feature extraction MAKE SURE TO SET 'alex_net' variable to
    %true 
    %label = split(fname,"_");
    %dataset = [dataset ; [imresize(img,[227,227]), label(1)]];  
    
    %GRID
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER4,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    img= double(imresize(imread(imgfname_full),[256,256]))./255;
    F=extractHog(img, 4,8);
    save(fout,'F');
    
    
    
    toc
end



% when true, feature extract using AlexNet
if alex_net == true
    
    fprintf('Preparing AlexNet for feature extraction...');
   % mean_rgb = mean(mean(cell2mat(dataset(:,1))));

  %  for filenum=1:length(allfiles)
  %      image = cell2mat(dataset(filenum, 1));
  %      image_r = image(:,:,1);
  %      image_g = image(:,:,2);
  %      image_b = image(:,:,3);
  %      meanSubtracted = cat(3, image_r - mean_rgb(:,:,1), image_g - mean_rgb(:,:,2), image_b - mean_rgb(:,:,3));
  %      dataset(filenum,1) = {meanSubtracted};
  %  end

    imd_dataset = zeros(227,227,3,591);
    for item=1:length(dataset)
        imd_dataset(:,:,:,item) = cell2mat(dataset(item,1));
    end
    
    net = alexnet;
    inputSize = net.Layers(1).InputSize;

    aid_dataset = augmentedImageDatastore(inputSize(1:2), imd_dataset);

    layer = 'fc7';
    features_extracted = activations(net,aid_dataset,layer,'OutputAs','rows');
    
    %feature extracted contains a vector of size 591x4096
    fprintf('\nfeatures extracted');

    %Now we save the features one at a time
    for filenum=1:length(allfiles)
        fname=allfiles(filenum).name;
        imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
        fout=[OUT_FOLDER,'/',OUT_SUBFOLDER3,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
        F = features_extracted(filenum, :);
        save(fout,'F');
    end

    fprintf('\nDone\n');
end
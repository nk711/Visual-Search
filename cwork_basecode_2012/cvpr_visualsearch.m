%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER1='averageRGB';
DESCRIPTOR_SUBFOLDER2='globalColorHistogram';
DESCRIPTOR_SUBFOLDER3='alexNet';
DESCRIPTOR_SUBFOLDER4='grid';
%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
LABELS = {};

% true if you would like to apply PCA on the dataset 
PCA = false;

ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    %featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER1,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    %featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER2,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    %featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER3,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER4,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat

    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    % We can add labels which position corresponds to each element
    % descriptor
    label = split(fname,"_");
    LABELS = [LABELS label(1)];
    ctr=ctr+1;
end

outoutdisplay = [];
% Number of images in our collection
NIMG=size(allfiles,1);   



% This set of code will pick a random image for each class and will find
% the most similar images accordingly. The precision and recall will also
% be calculated
precision = [];
recall = [];
average_precision = [];
relevant_doc = [];
y_query_set = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
x_query_set = [301,352,382,412,442,472,502,532,563,1,33,63,97,127,157,181,211,241,271,331];
for row = 1:20
    
    no_of_relevant_docs = 0; % number of relevant document in a class
    % Finds all the images to do where class_id = row;
    for i=1:NIMG
        if str2double(LABELS(i)) == row
           no_of_relevant_docs = no_of_relevant_docs + 1;
        end
    end
    queryimg = x_query_set(row);    % Selecting our query image index from the current class
    query_label = y_query_set(row); % Getting the label for the query image index

  
    
    if PCA == true  
        %% 3) Compute the distance using PCA
        dst=[]; % hold a list of images ranked in order of similarity 
        %computing PCA over dataset;
        
        % Build an eigen model
        eigenmodel = Eigen_Build(permute(ALLFEAT, [2,1]));
        e = Eigen_Deflate(eigenmodel, 'keepn', 3);
        ALLFEATPCA = Eigen_Project(permute(ALLFEAT, [2,1]), e);
        distances = Eigen_Mahalanobis(ALLFEATPCA(:,queryimg),e);
        distances.sort
    else 
        %% 3) Compute the distance of the query image to the rest of the images
        dst=[]; % hold a list of images ranked in order of similarity 
        for i=1:NIMG % Goes through each image
            candidate=ALLFEAT(i,:); % picks the current image
            query=ALLFEAT(queryimg,:); % gets the query image
            thedst=cvpr_compare(query,candidate); % computes a defined similarity measure

            dst=[dst ; [thedst i]]; % appends list 
        end
        dst=sortrows(dst,1); 
    end
    
    %% 4) Visualise the results

    SHOW=591; % Show top 15 results
    dst=dst(1:SHOW,:);
   
    outdisplay=[];
    %for i=1:size(dst,1)
    %   img=imread(ALLFILES{dst(i,2)});
    %   img=img(1:2:end,1:2:end,:); % make image a quarter size
    %   img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
    %   outdisplay=[outdisplay img];
   % end
    % figure;
    % imshow(outdisplay);
    % axis off;
    
    %% 4) Calculating Statistics
    results = dst(:,end);
    counter = 0;
   
    pn = 0;
    p = [];
    r = []; 
    ap = 0;
    % Goes through our results and calculate the statistics 
    for i=1:SHOW
       relevant = 0;
       if str2double(LABELS(results(i)))==query_label
            counter=counter + 1;
            relevant = 1;
       end
       pn = counter/i; % calculates precision at n
       p = [p pn]; % concatinates the results of precision in a list
       r = [r (counter/no_of_relevant_docs)]; % concatinates the results of recall in a list
       ap = ap + (pn * relevant); % partial calculation of the average precision 
    end
    % Stores the precision results into a matrix
    % where each row represents each class and each Nth column represents the
    % percentage of 'N' returned images that are relevant
    precision = [precision ; p];
    % Stores the recall results into a matrix
    % where each row represents each class and each Nth column represents the 
    % percentage of 'N' relevant images have been returned
    recall = [recall ;r];
    % calculates the average precision and stores it in a matrix
    average_precision = [average_precision ; (ap/no_of_relevant_docs)];
end

mean_average_precision = mean(average_precision);

plot( mean(recall, 1), mean(precision,1));
xlabel('Recall'); ylabel('Precision')
xlim([0 1])
ylim([0 1])



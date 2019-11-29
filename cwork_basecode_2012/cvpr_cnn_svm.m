%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'MSRC_ObjCategImageDatabase_v2';
dataset =[];
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img= double(imresize(imread(imgfname_full),[227,227]));
    
    %%imshow(cell2mat(dataset(1,1)))
    label = split(fname,"_");
    dataset = [dataset ; [img, label(1)]];
end

testset = [];

% keeping a record of the dataset 
all_dataset = dataset;
% manually deleting the test set from the dataset
dataset(2,:)=[];dataset(4-1,:)=[];dataset(34-2,:)=[];dataset(36-3,:)=[];dataset(74-4,:)=[];dataset(93-5,:)=[];dataset(100-6,:)=[];dataset(122-7,:)=[];dataset(135-8,:)=[];dataset(145-9,:)=[];dataset(169-10,:)=[];dataset(174-11,:)=[];dataset(183-12,:)=[];dataset(199-13,:)=[];dataset(214-14,:)=[];dataset(234-15,:)=[];dataset(245-16,:)=[];dataset(255-17,:)=[];dataset(284-18,:)=[];dataset(289-19,:)=[];dataset(301-20,:)=[];dataset(313-21,:)=[];dataset(332-22,:)=[];dataset(343-23,:)=[];dataset(369-24,:)=[];dataset(374-25,:)=[];dataset(392-26,:)=[];dataset(401-27,:)=[];dataset(423-28,:)=[];dataset(425-29,:)=[];dataset(456-30,:)=[];dataset(467-31,:)=[];dataset(489-32,:)=[];dataset(499-33,:)=[];dataset(510-34,:)=[];dataset(523-35,:)=[];dataset(545-36,:)=[];dataset(556-37,:)=[];dataset(578-38,:)=[];dataset(587-39,:)=[];

% contains the training set
training_set = dataset;

% calculate the mean for all rgb channels from all the data in our training
% set

%mean_rgb = mean(mean(cell2mat(training_set(:,1))));

% go through each image in our dataset and subtract the mean values
%for filenum=1:length(allfiles)
%    image = cell2mat(all_dataset(filenum, 1));
%    image_r = image(:,:,1);
%    image_g = image(:,:,2);
%    image_b = image(:,:,3);
%    meanSubtracted = cat(3, image_r - mean_rgb(:,:,1), image_g - mean_rgb(:,:,2), image_b - mean_rgb(:,:,3));
%    all_dataset(filenum,1) = {meanSubtracted};
%end


%updated database containing the whole dataset where each image has been
%subtracted by the mean rgb channels of the training set.
dataset = all_dataset;
% Picking 2 images from each class to make the test set 
testset = [testset ;dataset(2,:);dataset(4,:);dataset(34,:);dataset(36,:);dataset(74,:);dataset(93,:);dataset(100,:);dataset(122,:);dataset(135,:);dataset(145,:);dataset(169,:);dataset(174,:);dataset(183,:);dataset(199,:);dataset(214,:);dataset(234,:);dataset(245,:);dataset(255,:);dataset(284,:);dataset(289,:);dataset(301,:);dataset(313,:);dataset(332,:);dataset(343,:);dataset(369,:);dataset(374,:);dataset(392,:);dataset(401,:);dataset(423,:);dataset(425,:);dataset(456,:);dataset(467,:);dataset(489,:);dataset(499,:);dataset(510,:);dataset(523,:);dataset(545,:);dataset(556,:);dataset(578,:);dataset(587,:)];
% manually deleting the test set from the dataset
dataset(2,:)=[];dataset(4-1,:)=[];dataset(34-2,:)=[];dataset(36-3,:)=[];dataset(74-4,:)=[];dataset(93-5,:)=[];dataset(100-6,:)=[];dataset(122-7,:)=[];dataset(135-8,:)=[];dataset(145-9,:)=[];dataset(169-10,:)=[];dataset(174-11,:)=[];dataset(183-12,:)=[];dataset(199-13,:)=[];dataset(214-14,:)=[];dataset(234-15,:)=[];dataset(245-16,:)=[];dataset(255-17,:)=[];dataset(284-18,:)=[];dataset(289-19,:)=[];dataset(301-20,:)=[];dataset(313-21,:)=[];dataset(332-22,:)=[];dataset(343-23,:)=[];dataset(369-24,:)=[];dataset(374-25,:)=[];dataset(392-26,:)=[];dataset(401-27,:)=[];dataset(423-28,:)=[];dataset(425-29,:)=[];dataset(456-30,:)=[];dataset(467-31,:)=[];dataset(489-32,:)=[];dataset(499-33,:)=[];dataset(510-34,:)=[];dataset(523-35,:)=[];dataset(545-36,:)=[];dataset(556-37,:)=[];dataset(578-38,:)=[];dataset(587-39,:)=[];

% Shuffled the dataset 
shuffled_dataset = dataset(randperm(size(dataset, 1)), :);
dataset_size = size(dataset,1);

imd_x_test = zeros(227,227,3,40);
for item=1:length(testset)
    imd_x_test(:,:,:,item) = cell2mat(testset(item,1));
end

imd_x_train = zeros(227,227,3,551);
for item=1:length(shuffled_dataset)
    imd_x_train(:,:,:,item) = cell2mat(shuffled_dataset(item,1));
end

net = alexnet;
inputSize = net.Layers(1).InputSize;

aid_train = augmentedImageDatastore(inputSize(1:2), imd_x_train);
aid_test= augmentedImageDatastore(inputSize(1:2), imd_x_test);

layer = 'fc7';
x_train = activations(net,aid_train,layer,'OutputAs','rows');
x_test = activations(net,aid_test,layer,'OutputAs','rows');

y_train = string(shuffled_dataset(:,2));
y_test = string(testset(:,2)); 

multiclass_svm_model = fitcecoc(x_train, y_train);

y_predicted = string(predict(multiclass_svm_model, x_test));


accuracy = mean(y_predicted == y_test);

confusionchart(y_test, y_predicted);


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
    img=imread(imgfname_full);
    %%imshow(cell2mat(dataset(1,1)))
    label = split(fname,"_");
    
    dataset = [dataset ; [imresize(img,[227,227]), label(1)]];
end

testset = [];

%Picking 2 images from each class to make the test set 
testset = [testset ;dataset(2,:);dataset(4,:);dataset(34,:);dataset(36,:);dataset(74,:);dataset(93,:);dataset(100,:);dataset(122,:);dataset(135,:);dataset(145,:);dataset(169,:);dataset(174,:);dataset(183,:);dataset(199,:);dataset(214,:);dataset(234,:);dataset(245,:);dataset(255,:);dataset(284,:);dataset(289,:);dataset(301,:);dataset(313,:);dataset(332,:);dataset(343,:);dataset(369,:);dataset(374,:);dataset(392,:);dataset(401,:);dataset(423,:);dataset(425,:);dataset(456,:);dataset(467,:);dataset(489,:);dataset(499,:);dataset(510,:);dataset(523,:);dataset(545,:);dataset(556,:);dataset(578,:);dataset(587,:)];
%deleting the test set from the dataset
dataset(2,:)=[];dataset(4-1,:)=[];dataset(34-2,:)=[];dataset(36-3,:)=[];dataset(74-4,:)=[];dataset(93-5,:)=[];dataset(100-6,:)=[];dataset(122-7,:)=[];dataset(135-8,:)=[];dataset(145-9,:)=[];dataset(169-10,:)=[];dataset(174-11,:)=[];dataset(183-12,:)=[];dataset(199-13,:)=[];dataset(214-14,:)=[];dataset(234-15,:)=[];dataset(245-16,:)=[];dataset(255-17,:)=[];dataset(284-18,:)=[];dataset(289-19,:)=[];dataset(301-20,:)=[];dataset(313-21,:)=[];dataset(332-22,:)=[];dataset(343-23,:)=[];dataset(369-24,:)=[];dataset(374-25,:)=[];dataset(392-26,:)=[];dataset(401-27,:)=[];dataset(423-28,:)=[];dataset(425-29,:)=[];dataset(456-30,:)=[];dataset(467-31,:)=[];dataset(489-32,:)=[];dataset(499-33,:)=[];dataset(510-34,:)=[];dataset(523-35,:)=[];dataset(545-36,:)=[];dataset(556-37,:)=[];dataset(578-38,:)=[];dataset(587-39,:)=[];


shuffled_dataset = dataset(randperm(size(dataset, 1)), :);
dataset_size = size(dataset,1);

%splitting training set and validation set using an 80%/20% split
%x_train = shuffled_dataset((1:440),1); 
%y_train = shuffled_dataset((1:440),2);

%x_val = shuffled_dataset((441:dataset_size),1); 
%y_val = shuffled_dataset(441:dataset_size,2);

%x_test = testset(:,1); 
%y_test = testset(:,2); 

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

augimdsTrain = augmentedImageDatastore(inputSize(1:2), imd_x_train);
augimdsTest= augmentedImageDatastore(inputSize(1:2), imd_x_test);

layer = 'fc7';
featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');

y_train = string(shuffled_dataset(:,2));
y_test = string(testset(:,2)); 

multiclass_svm_model = fitcecoc(featuresTrain, y_train);

y_predicted = string(predict(multiclass_svm_model, featuresTest));


accuracy = mean(y_predicted == y_test);

confusionchart(y_test, y_predicted);
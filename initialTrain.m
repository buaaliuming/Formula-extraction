function [totalClassifer] = initialTrain(classifier)
imdsTrain = imageDatastore('C:\Users\win8.1\Desktop\trainData\train_formula',...    
    'IncludeSubfolders',true,...    
    'LabelSource','foldernames');
%imdsTest = imageDatastore('C:\Users\win8.1\Desktop\trainData\test_formula');    

scaleImage = readimage(imdsTrain,1);
features = getFeatures(scaleImage,classifier);
numImages = length(imdsTrain.Files);
featuresTrain = zeros(numImages,size(features,2),'single');  
for i = 1:numImages    
    imageTrain = readimage(imdsTrain,i);      
    featuresTrain(i,:) = getFeatures(imageTrain,classifier);  
end

trainLabels = imdsTrain.Labels;
totalClassifer = fitcecoc(featuresTrain,trainLabels,'Coding','onevsone');
end
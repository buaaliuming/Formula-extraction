classifier = formulaTrain();
imdsTrain = imageDatastore('C:\Users\win8.1\Desktop\trainData\train_formula',...    
    'IncludeSubfolders',true,...    
    'LabelSource','foldernames');    
imdsTest = imageDatastore('C:\Users\win8.1\Desktop\trainData\test_formula');    

scaleImage = readimage(imdsTrain,1);
% features = extractHOGFeatures(imageTrain);
features = getFeatures(scaleImage,classifier);
numImages = length(imdsTrain.Files);
featuresTrain = zeros(numImages,size(features,2),'single');  
for i = 1:numImages    
    imageTrain = readimage(imdsTrain,i);      
    %featuresTrain(i,:) = extractHOGFeatures(imageTrain);
    featuresTrain(i,:) = getFeatures(imageTrain,classifier);  
end

trainLabels = imdsTrain.Labels;

totalClassifer = fitcecoc(featuresTrain,trainLabels);  
numTest = length(imdsTest.Files);
for i = 1:numTest
    scaleTestImage = readimage(imdsTest,i);    
    featureTest = getFeatures(scaleTestImage,classifier);    
    [predictIndex,score] = predict(totalClassifer,featureTest);
    figure;imshow(scaleTestImage);
    title(['predictImage: ',char(predictIndex)]);    
end 
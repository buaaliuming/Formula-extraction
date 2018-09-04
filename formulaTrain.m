function [classifier] = formulaTrain()
    imdsTrain = imageDatastore('C:\Users\win8.1\Desktop\trainData\train_image',...    
        'IncludeSubfolders',true,...    
        'LabelSource','foldernames');

    image1 = readimage(imdsTrain,1);
    if size(image1,1)>40
        image1 = imresize(image1,39/size(image1,1));
    end
    if size(image1,2)>40
        image1 = imresize(image1,39/size(image1,2));
    end
    padImage = padarray(image1,[floor((40-size(image1,1))/2) floor((40-size(image1,2))/2)],255,'post');
    padImage = padarray(padImage,[ceil((40-size(image1,1))/2) ceil((40-size(image1,2))/2)],255,'pre');
    numImages = length(imdsTrain.Files);
    features = extractHOGFeatures(rgb2gray(padImage),'CellSize',[8,8]); 

    featuresTrain = zeros(numImages,size(features,2),'single');
    for i = 1:numImages    
        imageTrain = readimage(imdsTrain,i);
        if size(imageTrain,1)>40
            imageTrain = imresize(imageTrain,39/size(imageTrain,1));
        end
        if size(imageTrain,2)>40
            imageTrain = imresize(imageTrain,39/size(imageTrain,2));
        end
        padImageTrain = padarray(imageTrain,[floor((40-size(imageTrain,1))/2) floor((40-size(imageTrain,2))/2)],255,'post');
        padImageTrain = padarray(padImageTrain,[ceil((40-size(imageTrain,1))/2) ceil((40-size(imageTrain,2))/2)],255,'pre');
        featuresTrain(i,:) = extractHOGFeatures(rgb2gray(padImageTrain),'CellSize',[8,8]);
    end

    trainLabels = imdsTrain.Labels;
    classifier = fitcecoc(featuresTrain,trainLabels,'Coding','onevsone');
end
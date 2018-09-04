    imdsTrain = imageDatastore('C:\Users\win8.1\Desktop\trainData\train_image',...    
        'IncludeSubfolders',true,...    
        'LabelSource','foldernames');
    imdsTest = imageDatastore('C:\Users\win8.1\Desktop\trainData\test_image',...    
        'IncludeSubfolders',true,...    
        'LabelSource','foldernames');
    image1 = readimage(imdsTrain,90);
    padImage = padarray(image1,[floor((40-size(image1,1))/2) floor((40-size(image1,2))/2)],255,'post');
    padImage = padarray(padImage,[ceil((40-size(image1,1))/2) ceil((40-size(image1,2))/2)],255,'pre');
    numImages = length(imdsTrain.Files);
    features = extractHOGFeatures(rgb2gray(padImage),'CellSize',[8,8]); 

    featuresTrain = zeros(numImages,size(features,2),'single');
    for i = 1:numImages    
        imageTrain = readimage(imdsTrain,i);
        if size(imageTrain,1)>40
            imageTrain = imresize(imageTrain,40/size(imageTrain,1));
        end
        if size(imageTrain,2)>40
            imageTrain = imresize(imageTrain,40/size(imageTrain,2));
        end
        padImageTrain = padarray(imageTrain,[floor((40-size(imageTrain,1))/2) floor((40-size(imageTrain,2))/2)],255,'post');
        padImageTrain = padarray(padImageTrain,[ceil((40-size(imageTrain,1))/2) ceil((40-size(imageTrain,2))/2)],255,'pre');
        featuresTrain(i,:) = extractHOGFeatures(rgb2gray(padImageTrain),'CellSize',[8,8]);
    end

    trainLabels = imdsTrain.Labels;
    classifier = fitcecoc(featuresTrain,trainLabels,'Coding','onevsall'); 
    
    numTest = length(imdsTest.Files);
    for i = 1:numTest
        testImage = readimage(imdsTest,i);
        if size(testImage,1)>40
            testImage = imresize(testImage,40/size(testImage,1));
        end
        if size(testImage,2)>40
            testImage = imresize(testImage,40/size(testImage,2));
        end
        padImageTest = padarray(testImage,[floor((40-size(testImage,1))/2) floor((40-size(testImage,2))/2)],255,'post');
        padImageTest = padarray(padImageTest,[ceil((40-size(testImage,1))/2) ceil((40-size(testImage,2))/2)],255,'pre');
        featureTest = extractHOGFeatures(rgb2gray(padImageTest),'CellSize',[8,8]);
        [predictIndex,score] = predict(classifier,featureTest);  
        figure;imshow(padImageTest);
        title(['predictImage: ',char(predictIndex)]);    
    end 
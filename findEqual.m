function [ judgeLabel ] = findEqual(classifier,testImage)
    scaleTestImage = testImage;
    featureTest = extractHOGFeatures(scaleTestImage);    
    predictIndex = predict(classifier,featureTest); 
    judgeLabel = predictIndex; 
end


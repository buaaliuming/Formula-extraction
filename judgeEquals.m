function [recogText] = judgeEquals(classifier1,classifier2,recogText,bbox,RGB,originImg,imageSize1,imageSize2)
        CUT = imcrop(originImg,bbox);
        RGBCUT = imcrop(RGB,bbox);
        dCUT = imdilate(CUT,strel('rectangle',[2 3]));
        cutFonts = regionprops(CUT,'BoundingBox');
        for j=1:length(cutFonts)
            tempCut = imcrop(RGBCUT,cutFonts(j).BoundingBox);
            %RGBCUT = insertShape(RGBCUT,'rectangle',cutFonts(j).BoundingBox,'LineWidth',2,'Color','red');
            rate = cutFonts(j).BoundingBox(3)/cutFonts(j).BoundingBox(4);
            if abs(rate-imageSize1(2)/imageSize1(1))<abs(rate-imageSize2(2)/imageSize2(1))
                tempCut = imresize(tempCut,imageSize1);
                classified = findEqual(classifier1,tempCut,imageSize1);
            else
                tempCut = imresize(tempCut,imageSize2);
                classified = findEqual(classifier2,tempCut,imageSize2);
            end
            recogText = [recogText,classified];
        end
        %figure;imshow(RGBCUT);
end


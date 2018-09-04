% classifier = formulaTrain();
% totalClassifier = initialTrain(classifier);
% save classifier_save classifier;
% save totalClassifier_save totalClassifier;
% load classifier_save;
% load totalClassifier_save;
% img = imread('test_data/110.jpg');
allnames=struct2cell(dir('test_data/*.jpg'));
[k,len]=size(allnames); 
for num=1:len
name = allnames{1,num};
img = imread(['test_data/',name]);
img = imresize(img,500/size(img,1));
RGB = img;
img = rgb2gray(img);
img = splitBbox(img,45);
img2 = img;
status = regionprops(img2,'BoundingBox','Area');
% figure;imshow(img2);hold on;

% deleteIdx = [];
% for i=1:length(status)
%     for j=1:length(status)
%         if status(i).BoundingBox(1)>=status(j).BoundingBox(1)&&status(i).BoundingBox(2)>status(j).BoundingBox(2)...
%             &&status(i).BoundingBox(1)+status(i).BoundingBox(3)<=status(j).BoundingBox(1)+status(j).BoundingBox(3)...
%             &&status(i).BoundingBox(2)+status(i).BoundingBox(4)<status(j).BoundingBox(2)+status(j).BoundingBox(4)
%             deleteIdx = [deleteIdx i];
%         end
%     end
% end
% 
% for i=1:size(deleteIdx,1)
%     img2(status(deleteIdx(i)).BoundingBox(2):(status(deleteIdx(i)).BoundingBox(2)+status(deleteIdx(i)).BoundingBox(4)) ...
%         ,status(deleteIdx(i)).BoundingBox(1):(status(deleteIdx(i)).BoundingBox(1)+status(deleteIdx(i)).BoundingBox(3))) = 0;
% end
% status(deleteIdx) = [];
% 
% % overlapRatio = zeros(length(status),length(fonts));
% % for i=1:length(status)
% %     for j=1:length(fonts)
% %         overlapRatio(i,j) = bboxOverlapRatio(status(i).BoundingBox,fonts(j).BoundingBox,'Min');
% %     end
% % end
% 
% RGB2 = RGB;
% idx = find([status.Area]>200);
% for i=1:length(idx)
%     testImage = imcrop(RGB,status(idx(i)).BoundingBox);
% %     figure;imshow(testImage);
%     featureTest = getFeatures(testImage,classifier,i);
%     predictIndex = predict(totalClassifier,featureTest);
%     str = ['id:' num2str(idx(i)) ' feature:' num2str(featureTest) ' ' char(predictIndex)];
%     disp(str);
% %     RGB2 = insertObjectAnnotation(RGB2, 'rectangle', status(idx(i)).BoundingBox, idx(i));
%     if char(predictIndex) == "formula"
% %         str = ['id:' num2str(idx(i)) ' feature:' num2str(featureTest)];
% %         disp(str);
% %         rectangle('position',status(idx(i)).BoundingBox,'edgecolor','r');
%         RGB2 = insertObjectAnnotation(RGB2, 'rectangle', status(idx(i)).BoundingBox, idx(i));
% %         RGB2 = insertShape(RGB2,'rectangle',status(idx(i)).BoundingBox,'LineWidth',2,'Color','red');
%     end
% end
% figure;imshow(RGB2);
imwrite(img2,['C:\Users\win8.1\Desktop\´óÈýÏÂ assignments\Lab\sliderSegement2\test_data\binaryImage\',num2str(num) '.jpg']);
end
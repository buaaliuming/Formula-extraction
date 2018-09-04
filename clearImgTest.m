C1 = 20;
C2 = 5;
img = imread('test_data\744.jpg');
img = imresize(img,400/size(img,1));
RGB = img;
img = rgb2gray(img);
lev = graythresh(img);
img = ~imbinarize(img,0.9);
% originImg = ~imbinarize(rgb2gray(RGB),lev);
originImg = img;
img = clearImg(img);
img = imdilate(img,strel('Line',3,0));
img = rlsaConn(img,0,1);
% imshow(originImg);hold on;

status = regionprops(img,'BoundingBox');
cenStatus = regionprops(img,'centroid');
deleteIdx = [];
for i=1:length(status)
    for j=1:length(status)
        if status(i).BoundingBox(1)>status(j).BoundingBox(1)&&status(i).BoundingBox(2)>status(j).BoundingBox(2)...
            &&status(i).BoundingBox(1)+status(i).BoundingBox(3)<status(j).BoundingBox(1)+status(j).BoundingBox(3)...
            &&status(i).BoundingBox(2)+status(i).BoundingBox(4)<status(j).BoundingBox(2)+status(j).BoundingBox(4)
            deleteIdx = [deleteIdx i];
        end
    end
end
status(deleteIdx) = [];
cenStatus(deleteIdx) = [];
% for i=1:size(status,1)
%     rectangle('position',status(i).BoundingBox,'edgecolor','y');
% end
idx = zeros(1,size(status,1));
for i=1:size(status,1)
    if(idx(i)==0)
    yPos = cenStatus(i).Centroid(2);
    height = status(i).BoundingBox(4);
    temp = i;
    idx(i) = 1;
    for j=1:size(status,1)
%         if i==15
%             str=['height=' num2str(height) ',j=' num2str(j) ',h=' num2str(status(j).BoundingBox(4)) ',pos=' num2str(cenStatus(j).Centroid(1))];
%             disp(str);
%         end
        if(idx(j)==0)
            if abs(status(j).BoundingBox(4)-height)>50 || abs(cenStatus(j).Centroid(2)-yPos)>15
                continue;
            else
                temp = [temp j];
                idx(j) = 1;
            end
        end
    end
    arrayX1 = zeros(size(temp,1),1);
    arrayY1 = arrayX1;
    arrayX2 = arrayX1;
    arrayY2 = arrayX1;
    for k=1:size(status(temp),1)
        arrayX1(k) = status(temp(k)).BoundingBox(1);
        arrayY1(k) = status(temp(k)).BoundingBox(2);
        arrayX2(k) = status(temp(k)).BoundingBox(1)+status(temp(k)).BoundingBox(3);
        arrayY2(k) = status(temp(k)).BoundingBox(2)+status(temp(k)).BoundingBox(4);
    end
    bbox = [min(arrayX1),min(arrayY1),max(arrayX2)-min(arrayX1),max(arrayY2)-min(arrayY1)];
%     RGB = insertObjectAnnotation(RGB, 'rectangle', bbox, i);
%     rectangle('position',bbox,'edgecolor','y');
    cutImg = originImg(min(arrayY1):max(arrayY2),min(arrayX1):max(arrayX2));
    for k=1:size(cutImg,1)
        cutImg(k,:) = rlsa(cutImg(k,:),20);
    end
    originImg(min(arrayY1):max(arrayY2),min(arrayX1):max(arrayX2)) = cutImg;
    end
end
imshow(originImg);hold on;
% newStatus = regionprops(originImg,'BoundingBox');
% for i=1:size(newStatus,1)
%     rectangle('position',newStatus(i).BoundingBox,'edgecolor','y');
% end
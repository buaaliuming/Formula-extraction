function [originImg] = splitBbox(img,distance)
lev = graythresh(img);
originImg = ~imbinarize(img,0.9);
img = ~imbinarize(img,0.9);
img = clearImg(img);
img(1:10,:)=0;
img(size(img,1)-10:size(img,1),:)=0;
img(:,1:10)=0;
img(:,size(img,2)-10:size(img,2))=0;
originImg = clearImg(originImg);

% img = imdilate(img,strel('Line',3,0));
% img = rlsaConn(img,0,2);
% figure;imshow(img);hold on;

status = regionprops(img,'BoundingBox');
cenStatus = regionprops(img,'centroid');
deleteIdx = [];
% for i=1:length(status)
%     for j=1:length(status)
%         if status(i).BoundingBox(1)>status(j).BoundingBox(1)&&status(i).BoundingBox(2)>status(j).BoundingBox(2)...
%             &&status(i).BoundingBox(1)+status(i).BoundingBox(3)<status(j).BoundingBox(1)+status(j).BoundingBox(3)...
%             &&status(i).BoundingBox(2)+status(i).BoundingBox(4)<status(j).BoundingBox(2)+status(j).BoundingBox(4)
%             deleteIdx = [deleteIdx i];
%         end
%     end
% end
for i=1:length(cenStatus)
    for j=1:length(cenStatus)
        if i~=j&&cenStatus(i).Centroid(1)>status(j).BoundingBox(1)&&cenStatus(i).Centroid(2)>status(j).BoundingBox(2)...
            &&cenStatus(i).Centroid(1)<status(j).BoundingBox(1)+status(j).BoundingBox(3)...
            &&cenStatus(i).Centroid(2)<status(j).BoundingBox(2)+status(j).BoundingBox(4)...
            &&status(i).BoundingBox(3)<status(j).BoundingBox(3)&&status(i).BoundingBox(4)<status(j).BoundingBox(4)
            deleteIdx = [deleteIdx i];
        end
    end
end
% for i=1:size(status,1)
%     rectangle('position',status(i).BoundingBox,'edgecolor','y');
% end
status(deleteIdx) = [];
cenStatus(deleteIdx) = [];
idx = zeros(1,size(status,1));
for i=1:size(status,1)
    if(idx(i)==0)
    yPos = cenStatus(i).Centroid(2);
    height = status(i).BoundingBox(4);
    temp = i;
    idx(i) = 1;
    for j=1:size(status,1)
        if(idx(j)==0)
            if abs(status(j).BoundingBox(4)-height)>40 || abs(cenStatus(j).Centroid(2)-yPos)>15
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
    temp2 = [];
    for j=1:size(status,1)
        if min(arrayX1)<status(j).BoundingBox(1)&&status(j).BoundingBox(1)+status(j).BoundingBox(3)<max(arrayX2) &&...
                min(arrayY1)>status(j).BoundingBox(2)&&status(j).BoundingBox(2)+status(j).BoundingBox(4)>max(arrayY2)
            temp2 = [temp2 j];
        end
    end

%     diff = setdiff(temp2,temp);
    diff = temp2;
    deleteDiff = [];
    for j=1:length(diff)
        if abs(status(diff(j)).BoundingBox(4)-height)<=40
            deleteDiff = [deleteDiff j];
        end
    end
    diff(deleteDiff) = [];
    bboxset = {};
    if ~isempty(diff)
        for j=1:length(diff)
            tempBbox = [];
            if j==1
                tempBbox = [bbox(1), bbox(2), status(diff(j)).BoundingBox(1)-bbox(1)-3, bbox(4)];
            else
                tempBbox = status(diff(j)).BoundingBox;
            end
            bboxset = [bboxset tempBbox];
            if j==length(diff)
                tempBbox = [status(diff(j)).BoundingBox(1)+status(diff(j)).BoundingBox(3)+3, bbox(2), bbox(1)+bbox(3)-status(diff(j)).BoundingBox(1)-status(diff(j)).BoundingBox(3), bbox(4)];
                bboxset = [bboxset tempBbox];
            end
        end
    else
        bboxset = [bboxset bbox];
    end
%     for j=1:length(bboxset)
%         rectangle('position',bboxset{j},'edgecolor','y');
%     end
%     RGB = insertObjectAnnotation(RGB, 'rectangle', bbox, i);
    for j=1:length(bboxset)
%         rectangle('position',bboxset{j},'edgecolor','r');
        cutImg = originImg(bboxset{j}(2):bboxset{j}(2)+bboxset{j}(4),bboxset{j}(1):bboxset{j}(1)+bboxset{j}(3));
        for k=1:size(cutImg,1)
            cutImg(k,:) = rlsa(cutImg(k,:),distance);
        end
        originImg(bboxset{j}(2):bboxset{j}(2)+bboxset{j}(4),bboxset{j}(1):bboxset{j}(1)+bboxset{j}(3)) = cutImg;
    end
    end
end
originImg(1:10,:)=0;
originImg(size(originImg,1)-10:size(originImg,1),:)=0;
originImg(:,1:10)=0;
originImg(:,size(originImg,2)-10:size(originImg,2))=0;
end
function [outImg] = clearImg(inImg)
    CC = bwconncomp(inImg);
%     stats = regionprops(CC,'BoundingBox');
%     width = zeros(size(stats,1),1);
%     for i=1:size(stats)
%         width(i) = stats(i).BoundingBox(3);
%     end
%     removeMask = width>500;
    stats = regionprops(CC,'MajorAxisLength','MinorAxisLength');
    removeMask = [stats.MajorAxisLength]>500&[stats.MinorAxisLength]<10;
    inImg(cat(1,CC.PixelIdxList{removeMask})) = false;
    cutImg = inImg(1:150,1:400);
    %img2 = bwareafilt(img,[0 300]);
    CC = bwconncomp(cutImg);
    stats = regionprops(CC,'MajorAxisLength','MinorAxisLength');
    removeMask = [stats.MajorAxisLength]>300&[stats.MinorAxisLength]>25;
    cutImg(cat(1,CC.PixelIdxList{removeMask})) = false;
    inImg(1:150,1:400) = cutImg;
    inImg = bwareaopen(inImg,5);
    outImg = inImg;
end


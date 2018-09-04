function [uImg] = rlsaConn(img,C1,C2)
img(1:10,:)=0;
img(size(img,1)-10:size(img,1),:)=0;
img(:,1:10)=0;
img(:,size(img,2)-10:size(img,2))=0;
bigger = zeros(size(img,1)+50,size(img,2)+50);
bigger(26:size(bigger,1)-25,26:size(bigger,2)-25) = img;
u = double(bigger);
u1 = u;
u2 = u;
for i=1:size(u,1)
    u1(i,:) = rlsa(u(i,:),C1);
end
for i=1:size(u,2)
    u2(:,i) = rlsa(u(:,i)',C2)';
end
uImg = u1|u2;
uImg = uImg(26:size(uImg,1)-25,26:size(uImg,2)-25);
end
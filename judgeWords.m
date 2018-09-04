function [ratio] = judgeWords(bbox,RGB,originImg)
    ocrResult = ocr(originImg,bbox,'TextLayout','Line');
    [ocrText,position]=ocrfilter(ocrResult);
    res = [];
    for i=1:length(ocrText)
        res = [res ocrText{i}];
    end
    word = res((res>='a'& res<='z')|(res>='A'& res<='Z'));
    if(~isempty(res))
        ratio = length(word)/length(res);
    else
        ratio = 0;
    end
end
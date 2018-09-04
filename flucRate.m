function [res] = flucRate(array)
    if length(array)==1
        res = 0;
        return
    end
    diff = [];
    for i=2:length(array)
        diff = [diff abs(array(i)-array(i-1))];
    end
    res = mean(diff);
end


function [y] = rlsa(x,C)
[m n] = size(x);
xx = [ones(m,1) x ones(m,1)]; 
xx = reshape(xx',1,[]); 
d = diff(xx); 
start = find(d==-1); 
stop = find(d==1); 
lgt = stop-start; 
b = lgt <= C; 
d(start(b)) = 0; 
d(stop(b)) = 0; 
yy = cumsum([1 d]); 
yy = reshape(yy, [], m)'; 
y = yy(:,2:end-1);
end


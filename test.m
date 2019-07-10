clear all
clc

x = [4 1 2; 
    2 4 0; 
    2 3 -8; 
    3 6 0; 
    4 4 0; 
    9 10 1; 
    6 8 -2; 
    9 5 1; 
    8 7 10; 
    10 8 -5];

m = mean(x);
s = std(x);

x = x - repmat(m,size(x,1),1);
x = x ./ repmat(s,size(x,1),1);

C = cov(x);

[V, D] = eig(C)

sum(sum(abs(V(: ,1:2))))/sum(sum(abs(V)))



Zmat = [];
W = [];

% Z1 = x(1,:)*V(:,1)
% Z2 = x(1,:)*V(:,2)
% Z3 = x(1,:)*V(:,3)

for k = 1:size(D,2)
   [~, col] = find(D == max(max(D)));
   Z = x*V(:,col);
   W(:, k) = V(:, col);
   Zmat(:,end+1) = Z;
   D(:,col) = 0;
end
 Zmat
% W
% Zmat * transpose(W)


%% CS 383
% Alan Davis
% Assignment 1 - Part 1

%% Clear All
clear, clc, close all

%% Defining Datasets
class1 = [-2 1; -5 -4; -3 1; 0 3; -8 11];
class2 = [-2 5; 1 0; 5 -1; -1 -3; 6 1];

f1 = [class1(:,1); class2(:,1)];
f2 = [class1(:,2); class2(:,2)];

vals1 = unique(f1);
vals2 = unique(f2);

probf1 = prob(class1, class2, 1, vals1);
probf2 = prob(class1, class2, 2, vals2);

entropy1 = entr(probf1);
entropy2 = entr(probf2);

ig1 = 1 - entropy1;
ig2 = 1 - entropy2;

%% Functions
function entropy = entr(mat)
    ansmat = [];
    for o = 1:size(mat,1)
        v1 = mat(o,1); v2 = mat(o,2);
        denom = size(mat,1)*size(mat,2);
        combined = v1+v2;
        frac1 = combined/denom;
        if v1 == 0
            frac2 = 0;
        else
            frac2 = (-v1/combined)*log2(v1/combined);
        end
        if v2 == 0
            frac3 = 0;
        else
            frac3 = (-v2/combined)*log2(v2/combined);
        end
        ans = frac1*(frac2+frac3);
        ansmat(end+1,:) = ans;
    end
    entropy = sum(ansmat);
end

function probmat = prob(class1, class2, colnum, vals)
    newcol1 = [];
    newcol2 = [];
    for i=1:size(class1,2)
        if i == 1
            col = class1(:,colnum);
        elseif i==2
            col = class2(:,colnum);
        end
       for j=1:size(vals,1)
           if i == 1
            newcol1(end+1,:) = nnz(col == vals(j,:));
           elseif i > 1
              newcol2(end+1,:) = nnz(col == vals(j,:));
           end
       end
    end
    probmat = [newcol1 newcol2];
end
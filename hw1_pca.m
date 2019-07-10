%% CS 383
% Alan Davis
% Assignment 1 - Theory

%% Clear All
clc
clear all
close all

%% Creating matrix
finmat = [];
files = dir('yalefaces/*');

for k = 1:length(files)
    if contains(files(k).name, 'subject')
        baseFileName = files(k).name;
        fullFileName = fullfile('yalefaces', files(k).name);
        imdata = imread(fullFileName);
        subsampled = imresize(imdata,[40,40]);
        finmat(end+1,:) = subsampled(:);
    end
end

% figure; image(finmat);

%% Standardizing data
m = mean(finmat);
s = std(finmat);

finmat = finmat - repmat(m,size(finmat,1),1);
finmat = finmat ./ repmat(s,size(finmat,1),1);

%% 2D using PCA
% finmat(:,1) = finmat(:,1)-mean(finmat(:,1));
% finmat(:,2) = finmat(:,2)-mean(finmat(:,2));

C = cov(finmat);
[V, D] = eig(C);
sumTop = 0;
sumBottom = sum(sum(abs(V)));

for z = 1:size(V,2)
    sumTop = sum(sum(abs(V(: ,1:z))));
    if sumTop/sumBottom >= 0.90
        break
    end
end

[~, colnum] = find(D == max(max(D)));
[row, col] = size(finmat);
Zmat = [];
W = [];

for k = 1:2
   [~, col] = find(D == max(max(D)));
   Z = finmat*V(:,col);
   W(:, k) = V(:, col);
   Zmat(:,end+1) = Z;
   D(:,col) = 0;
end

figure
axes('LineWidth',0.6,...
    'FontName','Helvetica',...
    'FontSize',8);
line(Zmat(:,1),Zmat(:,2),...
    'LineStyle','None',...
    'Marker','o');
grid on
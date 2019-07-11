%% CS 383
% Alan Davis
% Assignment 1 - Part 2 & 3

%% Clear All
clc
clear, close all

%% Creating matrix
finmat = [];
files = dir('yalefaces/*');

for z = 1:length(files)
    if contains(files(z).name, 'subject')
        baseFileName = files(z).name;
        fullFileName = fullfile('yalefaces', files(z).name);
        imdata = imread(fullFileName);
        subsampled = imresize(imdata,[40,40]);
        finmat(end+1,:) = subsampled(:);
    end
end

%% Standardizing data
m = mean(finmat);
s = std(finmat);

finmat = finmat - repmat(m,size(finmat,1),1);
finmat = finmat ./ repmat(s,size(finmat,1),1);

%% 2D using PCA
C = cov(finmat);
[V, D] = eig(C);
D2 = D;
maxvals = fliplr(max(D));
arrTop = [];
sumBottom = sum(sum(abs(D)));

for y = 1:size(D,2)
    val = maxvals(1,y);
    arrTop(:, end+1) = val;
    sumTop = sum(arrTop);
    if sumTop/sumBottom >= 0.95
        k = y;
        break
    end
end

[row, col] = size(finmat);
Zmat = [];

for z = 1:2
   [~, col] = find(D == max(max(D)));
   Z = finmat*V(:,col);
   Zmat(:,end+1) = Z;
   D(:,col) = 0;
end

%% Plot
figure
axes('LineWidth',0.6,...
    'FontName','Helvetica',...
    'FontSize',8);
line(Zmat(:,1),Zmat(:,2),...
    'LineStyle','None',...
    'Marker','o');
grid on

%% Original Image
originalImage = imread('yalefaces/subject02.centerlight');
smallerImage = imresize(originalImage,[40,40]);
figure; image(smallerImage);

%% Eigface
[~, eigcol] = max(diag(D2));
eigarr = V(:,eigcol);
resized = reshape(eigarr,40,40);
figure; image(resized, 'CDataMapping', 'scaled');

%% 
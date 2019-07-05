%% CS 383
% Alan Davis
% Assignment 1 - Theory

%% Clear All
clc
clear all
close all

%% Creating matrix
imdata = imread('yalefaces/subject02.centerlight');
subsampled = imresize(imdata,[40,40]);
finmat = subsampled(:);

files = dir('yalefaces/*');
for k = 1:length(files)
    if contains(files(k).name, 'subject')
        baseFileName = files(k).name;
        fullFileName = fullfile('yalefaces', files(k).name);
        imdata = imread(fullFileName);
        subsampled = imresize(imdata,[40,40]);
        finmat = [finmat subsampled(:)];
    end
end

%% Standardizing data
m = mean(finmat);
s = std(finmat);

finmat = finmat - repmat(m,size(finmat,1),1);
finmat = finmat ./ repmat(s,size(finmat,1),1);

%% 2D using PCA
% cmat = cov(double(finmat));
% [V,D] = eig(cmat);
% 
% newdata = V * double(finmat)';
% newdata = newdata';
% newdata = fliplr(newdata);
% 
% variance = D / sum(D(:));
% figure
% axes('LineWidth',0.6,...
%     'FontName','Helvetica',...
%     'FontSize',8,...
%     'XAxisLocation','Origin',...
%     'YAxisLocation','Origin')
% line(newdata(:,1),newdata(:,2),...
%     'LineStyle','None',...
%     'Marker','o');
% axis equal
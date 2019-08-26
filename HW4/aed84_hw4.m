%% CS 383
% Alan Davis
% Assignment 1 - Part 1

%% Clear All
clear, clc, close all

%% Naive Bayes Classifier
% Read data and separate label from data
data = load('spambase.data');

% Prep and randomize elements in matrix
rng(0);
[rows cols] = size(data);
data = data(randperm(size(data,1)), :);

% Get the index for 2/3 of the data
xTrainSet = data(1:ceil(rows*(2/3)),:);
yTrainSet = xTrainSet(:, size(xTrainSet, 2));
xTrainSet(:, size(xTrainSet, 2)) = [];

% Standardize Training Set
trainMean = mean(xTrainSet);
trainStd = std(xTrainSet);
xTrainSet = (xTrainSet - trainMean)./trainStd;
trainSet = [xTrainSet yTrainSet];

% Remainder 1/3 of data
xTestSet = data(ceil(rows*(2/3))+1:end,:);
yTestSet = xTestSet(:, size(xTestSet, 2));
xTestSet(:, size(xTestSet, 2)) = [];

% Standardize Testing Set with Training
xTestSet = (xTestSet - trainMean)./trainStd;
testSet = [xTestSet yTestSet];

%Set Aside Spam and Non-Spam Data in Training Phase
xTrainSpam = trainSet(trainSet(:,end) == 1, 1:end-1);
xTrainNotSpam = trainSet(trainSet(:,end) == 0, 1:end-1);

% Prior Estimation
priorXSpam = size(xTrainSpam,1)/size(xTrainSet,1);
priorXNotSpam = size(xTrainNotSpam,1)/size(xTrainSet,1);

% Mean
meanXTrainSpam = mean(xTrainSpam);
meanXTrainNotSpam = mean(xTrainNotSpam);

% Std
stdXTrainSpam = std(xTrainSpam);
stdXTrainNotSpam = std(xTrainNotSpam);

% Norm PDF or Gaussian Distribution
normXSpam = normpdf(xTestSet,meanXTrainSpam,stdXTrainSpam);
normXNotSpam = normpdf(xTestSet,meanXTrainNotSpam,stdXTrainNotSpam);

% Maximum Likelihood Estimation
mleXSpam = prod(normXSpam, 2);
mleXNotSpam = prod(normXNotSpam, 2);

% Multiply Maximum Likelihood Estimation

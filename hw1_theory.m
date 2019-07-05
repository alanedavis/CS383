%% CS 383
% Alan Davis
% Assignment 1

%% Clear All
clear, clc, close all

%% f1
% [1; 1; 0]
% probability of 0 = -1/3*log2(1/3)
% probability of 1 = -2/3*log2(2/3)

% [1; 0]
% Entropy is 1 (-1/2*log2(1/2)

% [0]
% No randomness (0*log2(0))

% TAKE THE WEIGHTED AVERAGE

%% Defining Datasets
% Feature 1 (Column 1)
% Feature 2 (Column 2)
% Must be done for both sets of data
class1 = [-2 1; -5 -4; -3 1; 0 3; -8 11];
class2 = [-2 5; 1 0; 5 -1; -1 -3; 6 1];

% Complements
complement = [1 0 0 0 0; 1 1 1 1 0; 1 1 1 0 0; 1 1 1 0 0];

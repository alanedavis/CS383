%% CS 383
% Alan Davis
% Assignment 1 - Part 1

%% Clear All
clear, clc, close all

%% Part 1 - Theory
% Initial matrix
matrix = [-2 1; -5 -4; -3 1; 0 3; -8 11; -2 5; 1 0; 5 -1; -1 -3; 6 1];
Y = matrix(:,2);

% Add an addition feature with value 1 to the data
biasMat = [ones(size(matrix,1),1) matrix(:,1)];

% Weights of the feature
theta = (biasMat'*biasMat)^-1*(transpose(biasMat)*Y);

% Add an addition feature with value 1 to the data
biasMat = [ones(size(matrix,1),1) matrix(:,1)];

% Predicted values as X(theta)
predicted = biasMat*theta;

% Calculating partial derivatives
syms x y g(x,y)
g(x,y) = (x+y-2)^2;
dg_dx = diff(g,x);
dg_dy = diff(g,y);

% 3D plot of x vs y vs g(x,y)
eq1 = @(x,y) dg_dx;
eq2 = @(x,y) dg_dy;
eq3 = @(x,y) g(x,y);
fsurf(eq1)
hold on
fsurf(eq2)
fsurf(eq3)

% values of x and y that minimize g(x,y)


%% Data
data = xlsread('x06Simple.csv');
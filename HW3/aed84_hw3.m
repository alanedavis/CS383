%% CS 383
% Alan Davis
% Assignment 1 - Part 1

%% Clear All
clear, clc, close all

%% Part 1 - Theory
% Initial matrix
matrix = [-2 1; -5 -4; -3 1; 0 3; -8 11; -2 5; 1 0; 5 -1; -1 -3; 6 1];
Y = matrix(:,2);

% Standardize Data
matrixM = mean(matrix);
matrixS = std(matrix);

matrix = matrix - repmat(matrixM,size(matrix,1),1);
matrix = matrix ./ repmat(matrixS,size(matrix,1),1);

% Add an addition feature with value 1 to the data
biasMat = [ones(size(matrix,1),1) matrix(:,1)];

% Weights of the feature
theta = (biasMat'*biasMat)^-1*(transpose(biasMat)*Y);

% Add an addition feature with value 1 to the data
biasMat = [ones(size(matrix,1),1) matrix(:,1)];

% Predicted values as X(theta)
predicted = biasMat*theta;

% Calculating partial derivatives
% g(x,y) = (x+y-2)^2
% dg/dx = 2*x + 2*y -4
% dg=dy = 2*x + 2*y -4
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
% g(x,y) = (x+y-2)^2
% x = 1, y = 2
% g(x,y) = (1+1-2)^2

%% Gradient Descent
change = 1;
iter = 1;
learn_rate = 0.1;
theta = [0; 0];
arrg = [g(0,0)];

while change > 2^(-32)
    new_theta = theta(:,iter) - learn_rate*[dg_dx(theta(1,iter),theta(2,iter)); dg_dy(theta(1,iter),theta(2,iter))];
    arrg = [arrg g(vpa(new_theta(1)),vpa(new_theta(2)))];
    theta = [theta new_theta];
    iter = iter + 1;
    change = abs(arrg(iter-1)-arrg(iter));
end

figure();
subplot(2,2,[1,2]);
plot(arrg,'m');
grid on
title('Iterations vs. g(x,y)')
hold on

subplot(2,2,3);
plot(theta(1,:),'r');
grid on
title('Iterations vs. x')

subplot(2,2,4);
plot(theta(2,:),'b');
grid on
title('Iterations vs. y')

%% Closed Form Linear Regression
% Read in data and remove unecessary data
data = readmatrix('x06Simple.csv');
data(:,1) = [];

% Standardize Data
dataM = mean(data);
dataS = std(data);

data = data - repmat(dataM,size(data,1),1);
data = data ./ repmat(dataS,size(data,1),1);

% Prep and randomize elements in matrix
rng(0);
[rows cols] = size(data);
data = data(randperm(size(data,1)), :);

% Get the index for 2/3 of the data
trainRows = ceil(rows*(2/3));

% Set training and test set
trainSet = data(1:trainRows,:);
testSet = data(trainRows+1:end,:);

% Train Set Data and Train Set Target
trainSetTarget = trainSet(:,3);
trainSetData = trainSet(:,1:2);

% Create bias mat
trainBiasMat = [ones(size(trainSetTarget,1),1) trainSetData];

% Weights of the feature
trainTheta = (trainBiasMat'*trainBiasMat)^-1*(trainBiasMat'*trainSetTarget);

% Test Set Matrices
testSetData = testSet(:,1:2);
testSetExpected = testSet(:,3);

% Predicted values as X(theta)
testPredicted = zeros(size(testSet,1),1);

% Applying my solution
for i = 1:size(testSetData,1)
    testPredicted(i) = trainTheta(1,1)+trainTheta(2,1)*testSetData(i,1)+trainTheta(3,1)*testSetData(i,2);
end

% RootMeanSquared value
RMSE = sqrt(1/size(testSetData,1)*sum(abs(testSetExpected-testPredicted))^2);

%% S-Folds Cross-Validation
data = readmatrix('x06Simple.csv'); data(:,1) = [];
sfolds = [];
arrRMSE = [];

% Standardize Data
dataM = mean(data);
dataS = std(data);

data = data - repmat(dataM,size(data,1),1);
data = data ./ repmat(dataS,size(data,1),1);

% Running sfold functions
sfold_out1 = sfold(data,3)
sfold_out2 = sfold(data,5)
sfold_out3 = sfold(data,20)
sfold_out4 = sfold(data,size(data,1))

%% Functions
function arrRMSE = sfold(data,s)
    arrRMSE = [];

    for j = 1:20
        data = data(randperm(size(data,1)), :);
        for k = 1:s
            sfolds = data;
            testSet = sfolds(k,:);
            sfolds(k,:) = [];
            
            % Train Set Data and Train Set Target
            trainSetTarget = sfolds(:,3);
            trainSetData = sfolds(:,1:2);

            % Create bias mat
            trainBiasMat = [ones(size(trainSetTarget,1),1) trainSetData];

            % Weights of the feature
            trainTheta = (trainBiasMat'*trainBiasMat)^-1*(trainBiasMat'*trainSetTarget);

            % Test Set Matrices
            testSetData = testSet(:,1:2);
            testSetExpected = testSet(:,3);

            % Predicted values as X(theta)
            testPredicted = zeros(size(testSet,1),1);

            % Applying my solution
            for i = 1:size(testSetData,1)
                testPredicted(i) = trainTheta(1,1)+trainTheta(2,1)*testSetData(i,1)+trainTheta(3,1)*testSetData(i,2);
            end

            % RootMeanSquared value
        end
        RMSE = sqrt(1/size(testSetData,1)*sum(abs(testSetExpected-testPredicted))^2); 
        arrRMSE = [arrRMSE RMSE];
    end
end
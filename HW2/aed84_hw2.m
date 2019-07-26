%% CS 383
% Alan Davis
% Assignment 1 - Part 1

%% Clear All
clear, clc, close all

%% Data
data = xlsread('diabetes.csv');
X = data(data(:,1) == 1,:);
Y = data(data(:,1) == -1,:);

%% Standardizing data

%% Random k Value
rng(0);
k = randi(7);
       
%% Run Function
myKMeans(X_std,k);

%% Functions
function myKMeans(X,k)
    % Simply standardizes the data in preparation of performing PCA on the
    % data. Also, removing the first column which is null.
    Xm = mean(X);
    Xs = std(X);

    X_std = X - repmat(Xm,size(X,1),1);
    X_std = X ./ repmat(Xs,size(X,1),1);

    Ym = mean(Y);
    Ys = std(Y);

    Y_std = Y - repmat(Ym,size(Y,1),1);
    Y_std = Y ./ repmat(Ys,size(Y,1),1);

    X_std(:,1) = [];
    Y_std(:,1) = [];
    
    % Rows and Cols
    [rows, cols] = size(X_std);

    % Colors
    colors = ['b','r','g','y','c','m'];

    % Dimensionality Reduction & Cluster Formation
    if size(X_std,2) > 3
        coeff = pca(X_std);
        reduce = coeff(:,1:3);
        X_std = X_std * reduce;
    end

    % Hard Coding that k will only be 1-7
    if k > 7
        k = 7;
    end

    % Initialize reference vectors
    kvecs = [];
    for o = 1:k
        row = X_std(randi([1,rows]),:);
        kvecs = [kvecs; row;];
    end
    
    % Means
    index = randperm(rows,k); %Vector of k random numbers
    means = [];
    for i = 1:length(index) %Vectorize starting means
        means = [means;X_std(index(i),:)];
    end
    
    % Making Clusters
    iter = 1;
    change = 1;
    while abs(change) > 2^(-23)
        iter = iter + 1;
        D = [];
        
        for i = i:k
            calc = [];
            for j = 1:rows
                calc = [calc; norm(means(i,:)-X_std(j,:))];
            end
            D = [D,calc];

        C(1:rows,1:3,1:k) = 0; %Create MultiDimensional Matrix
        for i = 1:rows 
            [v,index] = min(D(i,:)); %find index of min distance
            C(i,:,index) = X_std(i,:); %stick that observation in that cluster 
        end
        
        cpurity = 0;
        purity = 0;
        
        for i = 1:k
            temp = C(:,:,i);
            temp = [temp X(:,1)];
            holder = [];
            for j = 1:rows
                if temp(j,1) == 0 && temp(j,2) == 0 && temp(j,3) == 0
                    continue
                else
                    holder = [holder; temp(j,:)];
                end
            end
            
            one = sum(X(:,1) == 1);
            negone = sum(X(:,1) == -1);
            purity = purity + max(one,negone);
        end
        purity = purity / rows;

        end
  
       end
    end
end
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

%% Random k Value
rng(0);
k = randi(7);
       
%% Run Function
myKMeans(X_std,k,Y);

%% Functions
function myKMeans(X,k,Y)
    % Imlibrary
    imlibrary = [];

    % Rows and Cols
    [rows, cols] = size(X);

    % Colors
    colors = [ 0.8500,0.3250,0.0980; 0.4940,0.1840,0.5560;
           0.3010, 0.7450, 0.9330; 0.6350, 0.0780, 0.1840;
           0.9290,0.6940,0.1250; 0,0.4470,0.7410;
           0.4660, 0.6740, 0.1880; ];

    % Dimensionality Reduction & Cluster Formation
    if size(X,2) > 3
        coeff = pca(X);
        reduce = coeff(:,1:3);
        X = X * reduce;
    end

    % Hard Coding that k will only be 1-7
    if k > 7
        k = 7;
    end

    % Finding min and max of X
    means = mean(X);

    % Initialize reference vectors
    kindex = randperm(rows,k);
    means = [];
    for i = 1:length(kindex)
        means = [means;X(kindex(i),:)];
    end

    % Distance Calculations D = [D(X1,mean1),D(X1,mean2),...D(X1,meank)]
    % Vector distance from X(j,:) to mean 
    DM = 1;
    iter = 0;
    while abs(DM) > (2^-23)
    iter = iter+1;
    D = [];
    for i = 1:k
        calc = [];
        for j = 1:rows
            calc = [calc;norm(means(i,:)-X(j,:))];
        end
        D = [D,calc];
    end

    %Cluster
    %find index of min distance
    %stick that observation in that cluster
    C(1:rows,1:3,1:k) = 0;
    for i = 1:rows
        [v,index] = min(D(i,:));
        C(i,:,index) = X(i,:);
    end

    %Calculate Purity
    clusterPurity = 0;
    Purity = 0;
    for i = 1:k %For every Cluster
        temp = C(:,:,i); % Copy cluster into temp
        temp = [temp,X];
        temp2 = [];
        for j = 1:rows
            if temp(j,1) == 0 && temp(j,2) == 0 && temp(j,3) == 0 %Remove 0 vectors
                continue
            else
                temp2 = [temp2;temp(j,:)]; % Recombined X and Y
            end
        end
        pos = sum(temp2(:,4)==1); %Count classes
        neg = sum(temp2(:,4)==(-1));
        Purity = Purity + max(pos,neg); %Purity Calculations
    end
    Purity = Purity/rows; %Composite Purity

    %Plot Clusters
    %Title 'Iteration n - Purity = ...'
    %Clear Last Figure
    %For every Cluster
    %Select Color
    %Plot Cluster i
    %Plot Mean in Same Colo
    tit = ['Iteration ',num2str(iter),' -',' Purity = ',num2str(Purity)];
    clf
    figure1 = figure(1);
    for i = 1:k
        color = colors(i,1:3);
        scatter3(C(:,1,i),C(:,2,i),C(:,3,i),36,color,'x')
        if i == 1
            hold on
        end
        scatter3(means(i,1),means(i,2),means(i,3),75,'MarkerEdgeColor','k','MarkerFaceColor',color);
        title(tit);
    end

    %Save Plots 
    %Create Plots Folder and Add to Work Directory
    %Name the plots and add them to the library
    if ~exist('plots', 'dir')
       mkdir('plots')
       addpath('plots')
    end
    imname = ['plots/figure',num2str(iter),'.jpg'];
    imlibrary = [imlibrary;string(imname)];
    saveas(figure1,imname) 

    % pause(1) Pause for viewer in debugging
    % Calculate new means
    % Move cluster to temp working space
    % Strip 0 vectors
    % Compute mean
    oldmeans = means;       
    means = [];
    for i = 1:k
        temp = C(:,:,i);
        temp = temp(any(temp,2),:);
        means = [means;mean(temp)];
    end

    % Calculate Manhattan distance D(oldmean,mean)
    DM = 0;
    for i = 1:k
        Di = (means(i,1)-oldmeans(i,1))+(means(i,2)-oldmeans(i,2))+(means(i,3)-oldmeans(i,3));
        DM = DM + Di;
    end

    end

    % Construct Video
    % create the video object
    % video.FileFormat = 'mp4';
    % open the file for writing
    % where N is the number of images
    % read the next image
    % write the image to file
    % close the file
    vname = ['K_',num2str(k),'_F_all'];
    video = VideoWriter(vname);
    video.FrameRate = 1;
    open(video);
    [numImg,c] = size(imlibrary);
    for ii=1:numImg
      I = imread(char(imlibrary(ii))); 
      writeVideo(video,I); 
    end
    close(video);

    if exist('plots', 'dir')
       rmdir('plots','s')
    end
end
clear;close all;clc;format short g;format compact;

%% Load data
load('Xy_percep_ideal.mat');Xy = Xy_percep_ideal;
X = Xy(:,1:2);
y = Xy(:,3);
% figure(1);
% gscatter(X(:,1),X(:,2),y);
% hold on;

%% Pre-process data
[X,mean_X,std_X] = normalise_features(X); % now we want to normalise our data
X = [X,ones(size(X,1),1)]; % after normalising we add the bias
y(y==0) = -1;

%% Perceptron algorithm
w_init = rand(3,1); % initialise learning weights (w)
rho = 0.1; % learning-rate for iteration
max_iter = 1000;
[w,costs_in_iterations] = perceptron_learn(X,y,w_init,rho,max_iter); % Run perceptron algorithm on training set to compute learning weights (w)
fprintf('The final cost is %g\n',costs_in_iterations(end));
%% Plot the result
X_plot = circshift(X,1,2);
w_plot = circshift(w,1);
figure(1);
plot_boundary(X_plot,w_plot);
gscatter(X(:,1),X(:,2),y);
hold off;
%% Plot cost vector 
figure(2);
plot(costs_in_iterations,'o-','MarkerFaceColor','b');
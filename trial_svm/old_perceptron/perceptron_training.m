clear; close all; format short g;
% cd('Training_mtFeatures');

trainingData_filenames =  dir('*.mat');

overall_X = [];
overall_whistle_truth = [];
for fileno = 1:length(trainingData_filenames)
    load(trainingData_filenames(fileno).name);
    [X,~,~] = normalise_features(X); % now we want to normalise our data
    overall_X = [overall_X;X];
    overall_whistle_truth = [overall_whistle_truth;whistle_truth];
%     figure(fileno);
%     gscatter(X(:,1),X(:,2),whistle_truth);
end

% gscatter(overall_X(:,1),overall_X(:,2),overall_whistle_truth);
overall_X = [overall_X,ones(size(overall_X,1),1)]; % after normalising we add the bias

%% Run Perceptron Algorithm
w_init = rand(3,1); % initialise learning weights (w)
rho = 0.1; % learning-rate for iteration
max_iter = 1000;
term_tolerance = 1e3;
visualise = 'false';
[w_vector_iters,cost_vector_iters,iters] = perceptron_learn(overall_X,overall_whistle_truth,w_init,rho,max_iter,term_tolerance,visualise); % Run perceptron algorithm on training set to compute learning weights (w)
[least_cost,least_cost_iter_no] = min(cost_vector_iters);
best_w = w_vector_iters(:,least_cost_iter_no);
save('best_w_perceptron.mat','best_w');
fprintf('The best cost is at iteration: %d, and its value is: %g\n',least_cost_iter_no,least_cost);
%
%% Plot the final boundary result
X_plot = circshift(overall_X,1,2);
w_plot = circshift(best_w,1);
close all;
figure(1);
gscatter(overall_X(:,1),overall_X(:,2),overall_whistle_truth,'br','xs');
plot_boundary(X_plot,w_plot);
hold off;
%% Plot cost vector
figure(2);
plot(cost_vector_iters,'o-','MarkerFaceColor','b');

%% Test the cassifier accuracy
% [Xtest,~,~] = normalise_features([mtFeatureZcr,mtFeatureEnergy]); % now we want to normalise our data
% Xtest = [Xtest,ones(size(Xtest,1),1)]; % after normalising we add the bias
% load('best_w_perceptron');
% classifier_output = zeros(block_size,1);
% classifier_output((Xtest*best_w)>0) = 1;
% plot(classifier_output);
% ylim([-2 2]);

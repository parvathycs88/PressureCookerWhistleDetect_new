clear; close all; format short g;
trainingData_filenames =  dir('Training_mtFeatures/*.mat');

overall_X = [];
overall_whistle_truth = [];
% for fileno = 1:length(trainingData_filenames)
%     load(trainingData_filenames(fileno).name);
%     [X,~,~] = normalise_features(X); % now we want to normalise our data
%     overall_X = [overall_X;X];
%     overall_whistle_truth = [overall_whistle_truth;whistle_truth];
%     %     figure(fileno);
%     %     gscatter(X(:,1),X(:,2),whistle_truth);
% end

%% First, concatenate all training sets. Only then afterwards, normalise them
for fileno = 1:length(trainingData_filenames)
    load(trainingData_filenames(fileno).name);
    overall_X = [overall_X;X];
    overall_whistle_truth = [overall_whistle_truth;whistle_truth];
%     figure(fileno);
%     gscatter(X(:,1),X(:,2),whistle_truth);
end

[overall_X,mean_overallX,std_overallX] = normalise_features(overall_X); % now we want to normalise our data
overall_X = [overall_X,ones(size(overall_X,1),1)]; % after normalising we add the bias
% gscatter(overall_X(:,1),overall_X(:,2),overall_whistle_truth)
%%
overall_whistle_truth(overall_whistle_truth==-1) = 0;
% gscatter(overall_X(:,1),overall_X(:,2),overall_whistle_truth);

%% SVM traininng
SVMModel = fitcsvm(overall_X,overall_whistle_truth,'KernelFunction','rbf',...
    'Standardize',false,'ClassNames',{'0','1'});
SVMModel_simulink = fitcsvm(overall_X,overall_whistle_truth,'KernelFunction','rbf',...
    'Standardize',false,'ClassNames',[0,1]);

save('SVMModel.mat','SVMModel','mean_overallX','std_overallX');
saveCompactModel(SVMModel_simulink,'SVMModel_simulink');
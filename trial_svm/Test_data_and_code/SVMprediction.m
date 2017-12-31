clear;close all;clc;
%% Load the trained SVM model as well as the mean and std of training set
load('SVMModel');
% load('Testing_audio_files/31122016ChitturRice'); % Load test set under consideration
load('28122017_porridge_Koduvayur_2metres'); % Load test set under consideration

%% Normalise it using the training set's mean and std vector
% [X,~,~] = normalise_features(X);
X = (X - mean_overallX)./std_overallX;
X = [X,ones(size(X,1),1)];
[labels,score] = predict(SVMModel,X);
predicted_label_vector = str2double(labels);
block_size = 0.5;
no_of_audio_blocks = size(X,1);
time_vector = linspace(0,no_of_audio_blocks*block_size,no_of_audio_blocks);
h1 = subplot(211);
plot(time_vector/60,predicted_label_vector,'o-','linewidth',2);
ylim([-1 2]);

%% Whistle Counting Logic
whistle_count = 0;
maybe_whistle = 0;
consecutive_maybe_whistle_events = 0;
maybe_downward_glitch = 0;
whistle_count_vector = [];
for idx = 1:length(predicted_label_vector)
    predicted_label = predicted_label_vector(idx);
    [whistle_count,maybe_downward_glitch,maybe_whistle,consecutive_maybe_whistle_events] = count_whistles_from_label(whistle_count,predicted_label,maybe_whistle,maybe_downward_glitch,consecutive_maybe_whistle_events);
    
    whistle_count_vector = [whistle_count_vector; whistle_count];
%     if predicted_label_vector(idx) ~= 0 && maybe_whistle == 0
%         maybe_downward_glitch = 0;
%         maybe_whistle = 1;
%         consecutive_maybe_whistle_events = consecutive_maybe_whistle_events + 1;
%     elseif predicted_label_vector(idx) ~= 0 && maybe_whistle == 1 && consecutive_maybe_whistle_events < 3
%         maybe_downward_glitch = 0;
%         consecutive_maybe_whistle_events = consecutive_maybe_whistle_events + 1;
%     elseif predicted_label_vector(idx) ~= 0 && consecutive_maybe_whistle_events == 3 && maybe_whistle == 1
%         maybe_downward_glitch = 0;
%         whistle_count = whistle_count + 1;
%         consecutive_maybe_whistle_events = nan;
%     elseif predicted_label_vector(idx) == 0 && maybe_whistle == 1 && maybe_downward_glitch < 2
%         maybe_downward_glitch = maybe_downward_glitch + 1;
%     elseif predicted_label_vector(idx) == 0 && maybe_whistle == 1 && maybe_downward_glitch == 2
%         maybe_downward_glitch = 0;
%         maybe_whistle = 0;
%         consecutive_maybe_whistle_events = 0;
%     end
        
end

h2 = subplot(212);
plot(time_vector/60,whistle_count_vector,'r','linewidth',2);
linkaxes([h1,h2],'x');
fprintf('The whistle count is : %d\n',whistle_count);
clear;close all;clc;format short g;

%% Filter Design
audio_filename = '28122017_porridge_Koduvayur_2metres.wav';
au_info = audioinfo(audio_filename);
fs = au_info.SampleRate;
bp_filter = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',2500,'HalfPowerFrequency2',4000, ...
    'SampleRate',fs);

%% Feature Statitics
block_size = 0.5; % sec
winsize = 0.05;
hopsize = 0.5*winsize;
[mtFeatureEnergy,mtFeatureZcr] = readWavFile(audio_filename, block_size, winsize, hopsize,bp_filter);

%% Normalise Features and add bias before saving to disk
X = [mtFeatureZcr,mtFeatureEnergy];
% [X,~,~] = normalise_features(X); % now we want to normalise our data
% X = [X,ones(size(X,1),1)]; % after normalising we add the bias

%% Save training features to hard drive
save_filename = [audio_filename(1:end-4) '.mat'];
save(save_filename,'X');
% cd('..');
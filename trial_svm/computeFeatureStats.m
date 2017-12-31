clear;close all;clc;format short g;

%% Filter Design
audio_filename = '30122016ChitturLentilsVegetables.wav';
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

%% Manual tagging of whistle blocks (please change this for every audio training data)
whistle_truth = -1*ones(length(mtFeatureEnergy),1);

% starting_sec = [6.5,56,101,144.5,187,229,271.5,312.5,353,400]+block_size;  % 10-01-2017LentilsExtract
% ending_sec = [18,67,112,156,198.5,240.5,282.5,324,364,410];  % 10-01-2017LentilsExtract

% starting_sec = [3,55,113,160,195,236.5,256,276,302,334.5,363,386]+block_size;  % 02012017ChitturLentils
% ending_sec = [10.5,64,121,166.5,203.5,239.5,259,280,307,339.5,366,389.5];  % 02012017ChitturLentils

% starting_sec = [1,34,64,93.5,124.5,153,183,207,234,258.5,283,311.5,338.5,365.5,411.5] + block_size; % 11012017Koduvayoorgreenmoongdal
% ending_sec = [8,41,71,101.5,132,161.5,190,214,240.5,265,291,318.5,345.5,372.5,418.5]; % 11012017Koduvayoorgreenmoongdal

% starting_sec = [4,51,95.5,140.5,179,216.5,255.5,289.5,334,370,409.5] + block_size; % 13012017Koduvayoorvegetablesandlentils
% ending_sec = [13,60.5,105.5,149,188.5,226,263.5,300.5,343.5,380,419]; % 13012017Koduvayoorvegetablesandlentils

% starting_sec = [6,61,112.5,155.5] + block_size;  % 31122016ChitturWheatRice
% ending_sec = [13.5,69.5,122,163]; % 31122016ChitturWheatRice

% starting_sec = [305,377.5,430.5,481,533.5,583.5,631,674,711,749.5,789.5,830.5,874.5] + block_size; % 31122016Chitturvegetable
% ending_sec = [316.5,388.5,442.5,493,547.5,597,642.5,685,722.5,760,800.5,842.5,885]; % 31122016Chitturvegetable

starting_sec = [4,67.5,117,152.5,191,211,232.5] + block_size; % 30122016ChitturLentilsVegetables
ending_sec = [6,71,119,155.5,193,213,234]; % 30122016ChitturLentilsVegetables

% starting_sec = [2,93.5,158.5,205.5,247,281.5,319.5,357,392.5,420,451.5,483.5,517,568.5] + block_size; % 31122016ChitturRice (temporarily avoid for training set)
% ending_sec = [12.5,101,164,210.5,252,286.5,324,361.5,396.5,424.5,456,488,522,572.5]; % 31122016ChitturRice


starting_indices= starting_sec/block_size;
ending_indices = ending_sec/block_size;
whistle_mtwindows = [];
for idx = 1:length(starting_indices)
    whistle_mtwindows = [whistle_mtwindows starting_indices(idx):ending_indices(idx)];
end

% whistle_mtwindows = whistle_seconds/block_size;
whistle_truth(whistle_mtwindows) = 1;
plot(whistle_truth,'o-');
ylim([-2 2]);
%% Normalise Features and add bias before saving to disk
X = [mtFeatureZcr,mtFeatureEnergy];
% [X,~,~] = normalise_features(X); % now we want to normalise our data
% X = [X,ones(size(X,1),1)]; % after normalising we add the bias

%% Save training features to hard drive
save_filename = [audio_filename(1:end-4) '.mat'];
cd('Training_mtFeatures');
save(save_filename,'X','whistle_truth');
cd('..');
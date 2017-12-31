clear;clc;close all;format short g;

%%
audio_filename = '29122017_Koduvayur_rice_2metres.wav';
au_info = audioinfo(audio_filename);
fs = au_info.SampleRate;
FileObj = dsp.AudioFileReader(audio_filename);
block_size = 0.5; % seconds
FileObj.SamplesPerFrame = round(block_size*fs);
% out = audioDeviceWriter('SampleRate',fs);
winsize = 0.05; % seconds
hopsize = 0.5*winsize; % seconds

%% Bandpass filter

bp_filter = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',2500,'HalfPowerFrequency2',4000, ...
    'SampleRate',fs);
load('SVMModel');

whistle_count = 0;
maybe_whistle = 0;
consecutive_maybe_whistle_events = 0;
maybe_downward_glitch = 0;


%% Run the audio stream processing
iter = 0;
whistle_count_vector = [];
time_vector = [];
commandwindow;
while((iter*block_size) < au_info.Duration)
    
    tempX = step(FileObj);  % read data from stream object (file or mic)
    % 0buffered_tempX = step(buff,tempX);
    filtered_tempX = filter(bp_filter,tempX);
    stFeature_energy = st_Reduced_FeatureExtraction(filtered_tempX, fs, winsize, hopsize,'energy');
    numOfStWins_energy = size(stFeature_energy,2);
    mtWinhopsize_energy = numOfStWins_energy;
    [mtFeature_energy, ~] = mtFeatureExtraction(stFeature_energy,numOfStWins_energy,mtWinhopsize_energy,{'max'});
    
    stFeature_zcr = st_Reduced_FeatureExtraction(filtered_tempX, fs, winsize, hopsize,'zcr');
    numOfStWins_zcr = size(stFeature_zcr,2);
    mtWinhopsize_zcr = numOfStWins_zcr;
    [mtFeature_zcr, ~] = mtFeatureExtraction(stFeature_zcr,numOfStWins_zcr,mtWinhopsize_zcr,{'stdbymean'});
    
    X = [mtFeature_zcr,mtFeature_energy];
    X = (X - mean_overallX)./std_overallX;
    X = [X,ones(size(X,1),1)];
    [labels,score] = predict(SVMModel,X);
    predicted_label = str2double(labels);
    iter = iter + 1;
    [whistle_count,maybe_downward_glitch,maybe_whistle,consecutive_maybe_whistle_events] = count_whistles_from_label(whistle_count,predicted_label,maybe_whistle,maybe_downward_glitch,consecutive_maybe_whistle_events);   
    whistle_count_vector = [whistle_count_vector;whistle_count];
    time_vector = [time_vector;iter*block_size];
    fprintf('The elapsed time is : %3.2f, latest whistle count : %d\n',iter*block_size,whistle_count);
end

%% Display final result
clc;
fprintf('The whistle count is : %d\n',whistle_count);

time_vector_duration = duration(0,0,time_vector);
plot(time_vector_duration,whistle_count_vector,'linewidth',2.5);
xlabel('Time [min]');
xtickformat('mm:ss');
ylabel('Whistle Count [sec]');
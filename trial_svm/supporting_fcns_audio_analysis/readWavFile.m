function [mtFeature_energy,mtFeature_zcr] = readWavFile(fileName, BLOCK, winsize, hopsize,bp_filter)

% function readWavFile(fileName, BLOCK,winsize)
%
% This function demonstrates how to read the contents of a WAV file
% BLOCKS of data are read and each BLOCK can be processed separatelly
%
% ARGUMENTS:
% - fileName: the name of the WAV file
% - BLOCK: the length of the processing block (in seconds).
% - winsize: the length of the window size (in seconds).
% - hopsize: the length of the hop size (in seconds).

% [a, fs] = wavread(fileName, 'size');
au_info = audioinfo(fileName);
fs = au_info.SampleRate;
numOfSamples = au_info.TotalSamples;
% fprintf('total length of recording is %3.4f',numOfSamples/fs);
% pause(5);
% nChannels = au_info.NumChannels;
BLOCK_SIZE = round(BLOCK * fs);
curSample = 1;

% mtWin = floor(BLOCK_SIZE/winsize)*winsize/fs;
% mtStep = floor(mtWin/hopsize)*hopsize/fs;
% while the end of file has not been reached
block_no = 1;
while (curSample <= numOfSamples-fs)
    N1 = curSample;
    N2 = curSample + BLOCK_SIZE - 1;
    if (N2>numOfSamples)
        N2 = numOfSamples;
    end
    
    % read current block from the WAV file:
    tempX = double(int16(audioread(fileName, [N1, N2])));
    filtered_tempX = filter(bp_filter,tempX);
%     h1 = subplot(211);
%     plot(tempX);
%     h2 = subplot(212);
%     plot(filtered_tempX);
%     linkaxes([h1,h2],'x');
    % DO SOME PROCESS ON THE CURRENT FILTERED BLOCK
    stFeature_energy = st_Reduced_FeatureExtraction(filtered_tempX, fs, winsize, hopsize,'energy');
    numOfStWins_energy = size(stFeature_energy,2);
    %     mtWinhopsize = ceil(0.5*numOfStWins_energy);
    mtWinhopsize_energy = numOfStWins_energy;
    [mtFeature_energy(block_no,:), ~] = mtFeatureExtraction(stFeature_energy,numOfStWins_energy,mtWinhopsize_energy,{'max'});
    
    stFeature_zcr = st_Reduced_FeatureExtraction(filtered_tempX, fs, winsize, hopsize,'zcr');
    numOfStWins_zcr = size(stFeature_zcr,2);
    
    %     mtWinhopsize = ceil(0.5*numOfStWins_zcr);
    mtWinhopsize_zcr = numOfStWins_zcr;
    [mtFeature_zcr(block_no,:), ~] = mtFeatureExtraction(stFeature_zcr,numOfStWins_zcr,mtWinhopsize_zcr,{'stdbymean'});
    
    % update counter:
    curSample = curSample + BLOCK_SIZE;
    block_no = block_no + 1;
    %     fprintf('time = %3.4f\n',curSample/fs);
end
end

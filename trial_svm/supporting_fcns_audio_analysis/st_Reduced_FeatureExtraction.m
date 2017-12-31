function Features = st_Reduced_FeatureExtraction(signal, fs, win, step,featurename)

% function Features = stFeatureExtraction(signal, fs, win, step)
%
% This function computes basic audio feature sequences for an audio signal, on a short-term basis.
%
% ARGUMENTS:
%  - signal:    the audio signal
%  - fs:        the sampling frequency
%  - win:       short-term window size (in seconds)
%  - step:      short-term step (in seconds)
%
% RETURNS:
%  - Features: a [MxN] matrix, where M is the number of features and N is
%  the total number of short-term windows. Each line of the matrix
%  corresponds to a seperate feature sequence
%
% (c) 2014 T. Giannakopoulos, A. Pikrakis

% if STEREO ...
if (size(signal,2)>1)
    signal = (sum(signal,2)/2); % convert to MONO
end

% convert window length and step from seconds to samples:
windowLength = round(win * fs);
step = round(step * fs);

curPos = 1;
L = length(signal);

% compute the total number of frames:
if step==0
    numOfFrames = floor(L/windowLength);
else
     numOfFrames = floor((L-windowLength)/step) + 1;
end
% number of features to be computed:
numOfFeatures = 1;
Features = zeros(numOfFeatures, numOfFrames);
Ham = window(@hamming, windowLength);

for i=1:numOfFrames % for each frame
    % get current frame:
    frame  = signal(curPos:curPos+windowLength-1);
    frame  = frame .* Ham;
    if (sum(abs(frame))>eps)
        % compute time-domain features:
        switch featurename
            case 'zcr'
                Features(1,i) = feature_zcr(frame);
            case 'energy'
                Features(1,i) = feature_energy(frame);
        end
    else
        Features(:,i) = zeros(numOfFeatures, 1);
    end
    curPos = curPos + step;
end
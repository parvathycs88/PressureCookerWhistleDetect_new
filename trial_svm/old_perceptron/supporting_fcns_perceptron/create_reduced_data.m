clear;close all;clc;format short g;format compact;
Xy = load('ex2data1.txt');
y_orig = Xy(:,3);
Xytrue = Xy(y_orig==1,:);

Xytrue(2*Xytrue(:,1) + Xytrue(:,2) < 220,:) = [];
% gscatter(Xytrue(:,1),Xytrue(:,2),Xytrue(:,3));

%% False labelled data extraction
Xyfalse = Xy(y_orig==0,:);
Xyfalse(2*Xyfalse(:,1) + Xyfalse(:,2) > 200,:) = [];
% gscatter(Xyfalse(:,1),Xyfalse(:,2),Xyfalse(:,3));

%% Create reduced data-set with wide-separation
Xy_percep_ideal = [Xytrue;Xyfalse];
gscatter(Xy_percep_ideal(:,1),Xy_percep_ideal(:,2),Xy_percep_ideal(:,3));

save('Xy_percep_ideal.mat','Xy_percep_ideal');

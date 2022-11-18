clear all
close all
clc

%%define dataset path
%% addpaths
addpath(genpath('./funcs_sec2/myFuncs'));
addpath(genpath('./funcs_sec2/detectors/'));
addpath(genpath('./funcs_sec2/descriptors/'));
addpath(genpath('./funcs_sec2/toolbox/'));
addpath(genpath('./results1/'));
addpath(genpath('./results2/'));

%Suggested:'DoH', 'SURF', 'KAZE','SIFT'
%Suggested:'SIFT', 'SURF', 'KAZE','DSP-SIFT'
%% Set triplets
clear all
close all

detectors = {'DoH', 'SURF', 'KAZE','SIFT'};
descriptors = {'SIFT', 'SURF', 'KAZE','DSP-SIFT'};
pairs = {'p01','p02','p03','p04','p05','p06','p07','p08','p09','p10','p11'};

numCombinations = 11*4;
%% Run triplets

% c = 1;
% for dd = 4:4
%     for p = 4:4
%         params.Directory    = fullfile(strcat('pairs/',pairs{p},'/'));
%         params.detector     =  detectors{dd}; 
%         params.descriptor   =  descriptors{dd}; 
%         triplet{c} = tripletInitialize(params);
%         [imgs{c},points{c},features{c}, triplet{c}] = DetectDescribe(triplet{c});
%         matchingPoints{c} = matchPoints(imgs{c},points{c},features{c},triplet{c});
%         c = c+1;
%         close all
%     end
% end
% 
% % save('matchingPoints','features','triplet','points',''matchingPoints'')
%% Inliers triplets
% clear all
% % load('matchingPoints')
% load('ex2_fundamental_matrixes.mat')
% 
% triplet = {'p01','p02','p03','p04','p05','p06','p07','p08','p09','p10','p11',...
%     'p01','p02','p03','p04','p05','p06','p07','p08','p09','p10','p11',...
%     'p01','p02','p03','p04','p05','p06','p07','p08','p09','p10','p11',...
%     'p01','p02','p03','p04','p05','p06','p07','p08','p09','p10','p11'};
% 
% 
% for c = 1:size(matchingPoints,2)
%     params.Directory    = fullfile(strcat('pairs/',triplet{c},'/'));
%     myImgs = ReadImages(params);
%     myMatch = matchingPoints{c};
% %     [F{c},inliers{c},status{c}] = estimateFundamentalMatrix(myMatch{1},myMatch{2},'Method','RANSAC');
%     inliers_percentage(c) = sum(inliers{c})/length(inliers{c});
%     inliers_absolute(c) = sum(inliers{c});
% end
% 
% 
% inliers_perc_dd1 = (inliers_percentage(1:11));
% inliers_perc_dd2 = (inliers_percentage(12:22));
% inliers_perc_dd3 = (inliers_percentage(23:33));
% inliers_perc_dd4 = (inliers_percentage(34:44));
% 
% inliers_abs_dd1 = (inliers_absolute(1:11));
% inliers_abs_dd2 = (inliers_absolute(12:22));
% inliers_abs_dd3 = (inliers_absolute(23:33));
% inliers_abs_dd4 = (inliers_absolute(34:44));
% 
% m1 = mean(inliers_perc_dd1);
% m2 = mean(inliers_perc_dd2);
% m3 = mean(inliers_perc_dd3);
% m4 = mean(inliers_perc_dd4);
% 
% s1 = std(inliers_perc_dd1);
% s2 = std(inliers_perc_dd2);
% s3 = std(inliers_perc_dd3);
% s4 = std(inliers_perc_dd4);
% 
% 
% inliers_perc = [inliers_perc_dd1;inliers_perc_dd2;inliers_perc_dd3;inliers_perc_dd4];
% 
% mcameras_p = mean(inliers_perc);
% scameras_p = std(inliers_perc);
% 
% inliers_abs = [inliers_abs_dd1;inliers_abs_dd2;inliers_abs_dd3;inliers_abs_dd4];
% mdd_abs = mean(inliers_abs');
% sdd_abs = std(inliers_abs');
% mdd_perc = mean(inliers_perc');
% sdd_perc = std(inliers_perc');

% save('ex2_fundamental_matrixes')
%%
% load('ex2_fundamental_matrixes.mat')
% 
% 
% for c = 1:size(matchingPoints,2)
%     params.Directory    = fullfile(strcat('pairs/',triplet{c},'/'));
%     myImgs = ReadImages(params);
%     fig = vgg_gui_F(myImgs{1},myImgs{2},F{c});
% end

%% 
load('ex2_fundamental_matrixes.mat')
load('InternalParameters')
K(:,:,1) = Afinal;
K(:,:,2) = Afinal;

params.Directory    = fullfile(strcat('pairs/',triplet{37},'/'));
myImgs = ReadImages(params);
myF = F{37};
% E = K(:,:,1)'*myF*K(:,:,2);
fig = vgg_gui_F(myImgs{1},myImgs{2},myF);

clear all
close all

%% addpaths Detector-Descriptro
addpath(genpath('./funcs_sec1/'));
addpath(genpath('./funcs_sec2/myFuncs'));
addpath(genpath('./funcs_sec2/detectors/'));
addpath(genpath('./funcs_sec2/descriptors/'));
addpath(genpath('./funcs_sec2/toolbox/'));

%% addpaths section 3
addpath(genpath('./funcs_sec3/'));
addpath(genpath('./funcs_sec3/ACT_lite/'));
addpath(genpath('./funcs_sec3/allfns/'));
addpath(genpath('./funcs_sec3/extra_funs/'));
addpath(genpath('./funcs_sec3/myFuncs/'));
addpath(genpath('./results3/'));
addpath(genpath('./results1/'));

%% Extract points
%Suggested:'DoH', 'SURF', 'KAZE','SIFT'
%Suggested:'SIFT', 'SURF', 'KAZE','DSP-SIFT'

params.Directory    = fullfile(strcat('scenefinal/'));
params.detector     =  'SIFT'; 
params.descriptor   =  'DSP-SIFT'; 
params = tripletInitialize(params);
[ima,points,features,params] = DetectDescribe(params);

% save('detectedDescribedPoints','ima','points','features')
%% Point matching

load('detectedDescribedPoints')
MaxRatio = 0.8;
Metric  = params.Metric;
    
q_data = n_view_matching(points, features, ima, MaxRatio, Metric);
q_data = homogenize_coords(q_data);
npoints = size(q_data,2);
ncam = size(q_data,3);
% save('matchedPoints','q_data')

%%

%% Fundamental matrix first-last img
close all
clear all

load('matchedPoints')
npoints = size(q_data,2);
ncam = size(q_data,3);

q_2cams(:,:,1) = q_data(:,:,1); 
q_2cams(:,:,2) = q_data(:,:,ncam);

[F, P_2cam_est,Q_2cam_est,q_2cam_est] = MatFunProjectiveCalib(q_2cams);

figure
Q = un_homogenize_coords(Q_2cam_est);
scatter3(Q(1,:),Q(2,:),Q(3,:),[]);
disp(['Residual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_2cams,P_2cam_est,Q_2cam_est)/2 )]);
draw_reproj_error(q_2cams,P_2cam_est,Q_2cam_est);
%% Resection

P_Ncam_re = zeros(3,4,ncam);
P_Ncam_re(:,:,1) = P_2cam_est(:,:,1);
P_Ncam_re(:,:,ncam) = P_2cam_est(:,:,2);

for i = 2:ncam-1
    [P,cost]= PDLT_NA(q_data(:,:,i),Q_2cam_est);
    P_Ncam_re(:,:,i) = P;
end

disp(['Residual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_data,P_Ncam_re,Q_2cam_est)/2 )]);
draw_reproj_error(q_data,P_Ncam_re,Q_2cam_est);
%% Bundle

vp = ones(npoints,ncam);
[P_Ncam_bundle,Q_2cam_bundle,q_data_bundle] = BAProjectiveCalib(q_data,P_Ncam_re,Q_2cam_est,vp);

figure
Q = un_homogenize_coords(Q_2cam_bundle);
scatter3(Q(1,:),Q(2,:),Q(3,:),[]);

disp(['Residual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_data,P_Ncam_bundle,Q_2cam_bundle)/2)]);
draw_reproj_error(q_data,P_Ncam_bundle,Q_2cam_bundle);


%% Ex 4

xcam1 = 1;
xcam2 = ncam;
P_2cams_bundle{1} = P_Ncam_bundle(:,:,xcam1); 
P_2cams_bundle{2} = P_Ncam_bundle(:,:,xcam2);

q_2cams_bundle(:,:,1) = q_data_bundle(:,:,xcam1); 
q_2cams_bundle(:,:,2) = q_data_bundle(:,:,xcam2);

F_2cams_bundle = vgg_F_from_P(P_2cams_bundle);



%% EUCLIDEAN RECONSTRUCTION FROM ESSENTIAL MATRIX

%% load internal params
load('InternalParameters')
K(:,:,1) = Afinal;
K(:,:,2) = Afinal;

%% Obtain essential matrix
E = K(:,:,1)'*F_2cams_bundle*K(:,:,2);

%% Save the 4 solutions (R,t) in the structures Rcam(3,3,cam,sol), T(3,cam,sol),
[R_est,T_est] = factorize_E(E);  % Factorize the essential matrix with the 2 possible solutions for R and T

Rcam = zeros(3,3,2,4);
Tcam = zeros(3,2,4);

Rcam(:,:,1,1) = eye(3);
Rcam(:,:,1,2) = eye(3);
Rcam(:,:,1,3) = eye(3);
Rcam(:,:,1,4) = eye(3);

Rcam(:,:,2,1) = R_est(:,:,1);
Rcam(:,:,2,2) = R_est(:,:,1);
Rcam(:,:,2,3) = R_est(:,:,2);
Rcam(:,:,2,4) = R_est(:,:,2);
Tcam(:,2,1) =  T_est;
Tcam(:,2,2) = -T_est;
Tcam(:,2,3) =  T_est;
Tcam(:,2,4) = -T_est;


%% Obtain Euclidean Solution

% close all
figure
npoints = size(q_2cams_bundle,2);
Q_euc = zeros(4,npoints,2); % Variable for recontructed points
P_euc = zeros(3,4,2);       % Variable for projection matrices
figNo=figure;

for sol=1:4
    % Euclidean triangulation to obtain the 3D points (use TriangEuc)
    Q_euc = TriangEuc(Rcam(:,:,2,sol),Tcam(:,2,sol),K,q_2cams_bundle);
    
    % visualize 3D reconstruction
    figure();
    %draw_scene(Q_euc, K, Rcam(:,:,:,sol), Tcam(:,:,sol));
    draw_scene_cluster(Q_euc, K, Rcam(:,:,:,sol), Tcam(:,:,sol),8);
%     draw_3D_cube_segments(Q_euc)
    title(sprintf('Solution %d', sol));
     
    % Compute the projection matrices from K, Rcam, Tcam
    for k=1:2
       P_euc(:,:,k) = K(:,:,k)*([Rcam(:,:,k,sol),-Rcam(:,:,k,sol)*Tcam(:,k,sol)]);
    end
    
    % Obtain the re-projected points q_rep
    q_rep = project_points(P_euc,Q_euc);
    
    % Visualize reprojectd points to check that all solutions correspond to
    % the projected images
    q_rep = un_homogenize_coords(q_rep);
    
    for k=1:2
      figure(figNo); subplot(4,2,2*(sol-1)+k); scatter(q_rep(1,:,k),q_rep(2,:,k),30,[1,0,0]);
      title(sprintf('Reprojection %d, image %d', sol, k));
      daspect([1, 1, 1]);
      pbaspect([1, 1, 1]);
%       axis([-1000, 1000, -1000, 1000]);
    end
end

disp(['Residual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_2cams_bundle,P_euc,Q_euc)/2)]);
draw_reproj_error(q_2cams_bundle,P_euc,Q_euc);


disp(['Residual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_2cams,P_euc,Q_euc)/2)]);
draw_reproj_error(q_2cams,P_euc,Q_euc);

disp('************************************* END')

% C = imfuse(A,B)

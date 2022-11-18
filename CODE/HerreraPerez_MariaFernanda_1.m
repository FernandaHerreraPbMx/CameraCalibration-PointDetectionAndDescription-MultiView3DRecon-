clear all
close all

currentFolder = pwd
funcsPath = currentFolder + '\funcs_sec1\'; 
addpath(genpath(funcsPath));

%% Point measurement from captured images of checkboard 720
% 
% Np = 9;
% widhtP = 160;
% display = 1;
% 
% [coords ima_pattern]= get_real_points_checkerboard_vmmc(Np, widhtP, display);
% im_origin = 255*uint8(ima_pattern);
% 
% numImgs = 7;
% 
% for i = 1:numImgs
%     imgs{i} = imread(strcat('.\imgsCalibration\check720\im',num2str(i),'.jpg'));
%     xy{i} = get_user_points_vmmc(imgs{i});
% 
% %     H{i} = homography_solve_vmmc(coords', xy{i});
% %     [H{i}, rperr{i}] = homography_refine_vmmc(coords', xy{i}, H{i});     
% %     T{i} = maketform('projective',H{i}');
% %     im_target{i} = imtransform(im_origin,T{i});     
% %     figure
% %     subplot(1,2,1), imshow(imgs{i})
% %     title('Original image')
% %     subplot(1,2,2), imshow(im_target{i})
% %     title('Model transformed')
% end
% 
% checkBoard720.MeasuredPoints = xy;
% % save('checkBoard720_full_im1','checkBoard720');

%% Point measurement from captured images of checkboard 1080

% Np = 9;
% widhtP = 300;
% display = 1;
% 
% [coords ima_pattern]= get_real_points_checkerboard_vmmc(Np, widhtP, display);
% im_origin = 255*uint8(ima_pattern);
% 
% numImgs = 7;
% 
% for i = 1:numImgs
%     imgs{i} = imread(strcat('.\imgsCalibration\check1080\im',num2str(i),'.jpg'));
%     xy{i} = get_user_points_vmmc(imgs{i});
% 
% %     H{i} = homography_solve_vmmc(coords', xy{i});
% %     [H{i}, rperr{i}] = homography_refine_vmmc(coords', xy{i}, H{i});
% %     T{i} = maketform('projective',H{i}');
% %     im_target{i} = imtransform(im_origin,T{i});    
% %     figure
% %     subplot(1,2,1), imshow(imgs{i})
% %     title('Original image')
% %     subplot(1,2,2), imshow(im_target{i})
% %     title('Model transformed')
% end
% 
% checkBoard1080.MeasuredPoints = xy;
% % save('checkBoard1080_full_im1','checkBoard1080');

%% Checkboard 720 Internal Params and External Params
clear all
load('checkBoard720_full_im1');
Np = 9;
widhtP = 160;
display = 0;
[checkBoard720.RealPoints ~]= get_real_points_checkerboard_vmmc(Np, widhtP, display);

for i = 1:7
    H{i} = homography_solve_vmmc(checkBoard720.RealPoints', checkBoard720.MeasuredPoints{i});
    [H{i}, ~] = homography_refine_vmmc(checkBoard720.RealPoints', checkBoard720.MeasuredPoints{i}, H{i});
    if(i>2)
        H_all{i-2} = H;
    end
end

% Using 
for i = 1:5
    checkBoard720.A{i} = internal_parameters_solve_vmmc(H_all{i});
    [checkBoard720.R{i} checkBoard720.T{i}] = external_parameters_solve_vmmc(checkBoard720.A{i}, H_all{i});
end

save('checkBoard720_full_im1','checkBoard720');

%% Checkboard 1080 Internal Params and External Params
clear H_all
clear H
load('checkBoard1080_full_im1');
Np = 9;
widhtP = 300;
display = 0;
[checkBoard1080.RealPoints ~]= get_real_points_checkerboard_vmmc(Np, widhtP, display);

for i = 1:7
    H{i} = homography_solve_vmmc(checkBoard1080.RealPoints', checkBoard1080.MeasuredPoints{i});
    [H{i}, ~] = homography_refine_vmmc(checkBoard1080.RealPoints', checkBoard1080.MeasuredPoints{i}, H{i});
    if(i>2)
        H_all{i-2} = H;
    end
end

% Using 
for i = 1:5
    checkBoard1080.A{i} = internal_parameters_solve_vmmc(H_all{i});
    [checkBoard1080.R{i} checkBoard1080.T{i}] = external_parameters_solve_vmmc(checkBoard1080.A{i}, H_all{i});
end

save('checkBoard1080_full_im1','checkBoard1080');
%%
Afinal = checkBoard1080.A{5};
save('InternalParameters','Afinal')


%%
fx = Afinal(1,1);
s = Afinal(1,2);
angle = rad2deg(atan(s/fx));


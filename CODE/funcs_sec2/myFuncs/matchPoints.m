function [matchedPoints] = matchPoints(ima,points,features,params)


    %% PoI Matching (assumes two images, i.e. numImages == 2) %%
    mytitle1 = params.Scene.Files{1};
    mytitle1 = erase(mytitle1,'C:\Users\Fer\Documents\IPCV\UAM\VisionForMultiploOrMovingCameras\project\codev2\pairs\');
    mytitle2 = params.Scene.Files{2};
    mytitle2 = erase(mytitle2,'C:\Users\Fer\Documents\IPCV\UAM\VisionForMultiploOrMovingCameras\project\codev2\pairs\');
    
    mytitle = mytitle1 + " and " + mytitle2;
    numImages    = numel(params.Scene.Files);
    indexPairs       = matchFeatures(features{1},features{2},'MaxRatio',params.MaxRatio,'Metric',params.Metric) ;
    matchedPoints{1} = points{1}(indexPairs(:,1));
    matchedPoints{2} = points{2}(indexPairs(:,2));
    figure(numImages+1); showMatchedFeatures(ima{1},ima{2},matchedPoints{1},matchedPoints{2});
    legend('matched points 1','matched points 2');
    text(150,150,mytitle,'Color','red','FontSize',27);
    
    %% Homography estimation and warp %% 

    %% A) Estimate the transformation between ima(2) and ima(1).
    if numel(matchedPoints{2}.Scale) < 4
       sprintf('Unable to match enough points -> End of program')
       return;
    end
    tform21  = estimateGeometricTransform(matchedPoints{2}, matchedPoints{1},...
             'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

    warpedImage = imwarp(ima{2}, tform21, 'OutputView', imref2d(size(ima{1})));
    % show results
    ima2         = zeros(size(ima{1}));
    for ch=1:3
    ima2(:,:,ch) = imresize(ima{2}(:,:,ch),size(ima{1}(:,:,ch)));
    end
    multi = cat(4,ima{1},ima2,ima{1},warpedImage);
    figure(numImages+2);aa = montage(multi,'Size',[2,2]);
    result21 = aa.CData;
    disp  = 20;
    figure(numImages+2);clf,imshow(result21)
    text(disp,disp,'Image 1','Color','red','FontSize',14)
    text(disp + size(result21,2)/2,disp,'Image 2','Color','red','FontSize',14)
    text(disp,disp + size(result21,1)/2,'Image 1','Color','red','FontSize',14)
    text(disp + size(result21,2)/2,disp + size(result21,1)/2,'Image 2 to 1','Color','red','FontSize',14)

    %% B) Estimate the transformation between ima(1) and ima(2).
    tform12  = estimateGeometricTransform(matchedPoints{1}, matchedPoints{2},...
             'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

    warpedImage = imwarp(ima{1}, tform12, 'OutputView', imref2d(size(ima{2})));
    % show results
    for ch=1:3
    ima1(:,:,ch) = imresize(ima{1}(:,:,ch),size(ima{2}(:,:,ch)));
    end
    multi = cat(4,ima1,ima{2},warpedImage,ima{2});
    figure(numImages+3);aa = montage(multi,'Size',[2,2]);
    result12 = aa.CData;
    figure(numImages+3);clf,imshow(result12)
    text(disp,disp,'Image 1','Color','red','FontSize',14)
    text(disp + size(result12,2)/2,disp,'Image 2','Color','red','FontSize',14)
    text(disp,disp + size(result12,1)/2,'Image 1 to 2','Color','red','FontSize',14)
    text(disp + size(result12,2)/2,disp + size(result12,1)/2,'Image 2','Color','red','FontSize',14)

end


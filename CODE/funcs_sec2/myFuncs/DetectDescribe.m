function [ima,points,features,params] = DetectDescribe(params)

    %% preload dataset
    params.Scene = imageDatastore(params.Directory);
    numImages    = numel(params.Scene.Files);

    %% initialize (sort of)
    ima{numImages}           = [];
    points{numImages}        = [];
    decomposition{numImages} = [];
    features{numImages}      = [];

    %% get sigmas
    k = 1;
    params.sigmas = zeros(1,params.noctaves*params.nscales);
    for o = 0:params.noctaves-1
        params.sigmas(k:(k+params.nscales-1)) = params.sigma0.*pow2([0:(params.nscales-1)]/params.nscales + o);
        k = k+params.nscales;
    end

    %% detect & describe
    for j = 1:numImages
        %% Load and convert images %%
        ima{j}      =       readimage(params.Scene, j);
        gima        =      im2double(rgb2gray(ima{j}));

        %% PoI Detection %%
        sprintf('Detecting for image: %d',j)
        [points{j},decomposition{j}] =  myDetector(gima,params);

        %% PoI Description %%
        sprintf('Describing for image: %d',j)
        [features{j},points{j}]      =  myDescriptor(points{j},decomposition{j},params);

        %% show detections
        mytitle = params.Scene.Files{j};
        mytitle = erase(mytitle,'C:\Users\Fer\Documents\IPCV\UAM\VisionForMultiploOrMovingCameras\project\codev2\scenefinal\');
        figure(j)
        imshow(ima{j})
        text(150,150,mytitle,'Color','red','FontSize',20);
        hold on;
        plot(points{j},'showOrientation',true);
        
    end
end


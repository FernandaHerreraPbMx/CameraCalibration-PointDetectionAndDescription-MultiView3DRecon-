function [ima] = ReadImages(params)

    %% preload dataset
    params.Scene = imageDatastore(params.Directory);
    numImages    = numel(params.Scene.Files);

    %% initialize (sort of)
    ima{numImages}           = [];

    %% detect & describe
    for j = 1:numImages
        %% Load and convert images %%
        ima{j}      =       readimage(params.Scene, j);
    end
end

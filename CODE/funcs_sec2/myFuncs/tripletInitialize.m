function  params = tripletInitialize(params)

    
    %% params for linear detectors
    params.nscales      =        10;
    params.noctaves     =        3;
    params.sigma0       =      1.6; % as we are using Matlab functions this is the minimum value allowed
    params.npoints      =      300;
    params.th           =    0.001; % alternative to npoints.

    %%
    params.desOnDecom   =    false; % describe on scale-space (linear or non-linear) decomposition (if available)
    params.Upright      =   false; % set to true to avoid orientation estimation.
    % for DSP-SIFT
    params.dsp.ns       =      15;% number of sampled scales
    params.dsp.sc_min   =     1/6;% smallest scale (relative to detection)
    params.dsp.sc_max   =      7;% largest scale (relative to detection);    

    %% Matching parameters (see doc matchFeatures for explanation and additional parameters)
    params.MaxRatio     =   0.8;
    params.Metric       =  'SSD';
    
end


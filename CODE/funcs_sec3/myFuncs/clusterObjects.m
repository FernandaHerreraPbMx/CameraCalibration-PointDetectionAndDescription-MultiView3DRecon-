function C = clusterObjects(Q,numObjects)
    
%% Color maps
    c{1}  = [1,1,0];
    c{2}  = [0.635,0.078,0.184];
    c{3}  = [1,0,0];
    c{4}  = [0,1,1];
    c{5}  = [0,1,0];
    c{6}  = [0,0,1];
    c{7}  = [0,0,0];
    c{8}  = [0,0.75,0.75];
    
%%
    idx = clusterdata(Q',numObjects);
    
    for i = 1:length(idx)
        C(i,:) = c{idx(i)};
    end
        
end


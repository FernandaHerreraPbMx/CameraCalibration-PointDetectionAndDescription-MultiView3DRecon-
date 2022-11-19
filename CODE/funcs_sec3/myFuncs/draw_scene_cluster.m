
function draw_scene_cluster(Q,K,R,T,numObjects)

% Draw 3D points
Q = un_homogenize_coords(Q);
C = clusterObjects(Q,numObjects);
scatter3(Q(1,:),Q(2,:),Q(3,:),[],C);
daspect([1, 1, 1]); pbaspect([1, 1, 1]); axis vis3d;

ncam = size(K,3);

% Draw cameras
fig = figure; colormap('jet'); close(fig)
cmap = colormap;
Offset = 6; % lower color of the colormap
idx = round(linspace(1+Offset,size(cmap,1)-1-Offset,ncam));

global r;
for k=1:ncam
    color = cmap(idx(k),:);

    % Avg distanec of the cameras to the point centroid
    Cent = mean(Q,2);
    dist_med = mean( VectNorm(T-Cent(1:3,ones(1,ncam))) );
    if isempty(r)
        r = 0.5; 
    end
    draw_camera(K(:,:,k),R(:,:,k),T(:,k),dist_med*r,color);        
end



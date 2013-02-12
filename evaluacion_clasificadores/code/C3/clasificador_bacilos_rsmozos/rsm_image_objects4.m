function [segmented_images,npixels,edge_boundaries]=rsm_image_objects4(IM,nClusters,borderobj,ddebug,useonlygreen)
% Only canny edge detection
% In addition outputs all the clusters filled.
% In addition, returns, no conected objects.
% by default returns only objects completely inserted in the image, i.e., not
% touching the borders of the image
npixels=[];
segmented_images={};
edge_boundaries={};
try
    ddebug=ddebug;
catch
ddebug=0;
end
try
    nClusters=nClusters;
catch
    nClusters=4;
end
try
    useonlygreen=useonlygreen;
catch
    useonlygreen=0;
end
    
% try
%     NREP=NREP;
% catch
%     NREP=3;
% end

try 
    borderobj=borderobj;
catch
    borderobj=0;
end

tama=size(IM);
IM2=reshape(double(IM),tama(1)*tama(2),tama(3));

% Usando otra transformacion
% cform = makecform('srgb2lab');
% IM2 = applycform(IM,cform);
% ab = double(IM2(:,:,2:3));
% nrows = size(ab,1);
% ncols = size(ab,2);
% IM2 = reshape(ab,nrows*ncols,2);

%blind object indentification
%[cluster_idx cluster_center] = kmeans(IM2,nClusters,'distance','sqEuclidean', ...
%                                      'Replicates',NREP, 'EmptyAction','drop');
% This is kmeans++ from matlabcentral, it is much faster.
k2=1;
% %% This is kmeans object detection
% 
% cluster_idx=kmeanspp(IM2',nClusters);
%                                   
%                                   % labeling                             
% pixel_labels = reshape(cluster_idx,tama(1),tama(2));
% if ddebug
% figure(1),imshow(pixel_labels,[]), title('image labeled by cluster index');
% end
% 
% %segmentation
% %segmented_images = cell(1,3);
% 
% %rgb_label = repmat(pixel_labels,[1 1 3]);
% 
% for k = 1:nClusters
%     onecluster = pixel_labels;
%     % only one object per segment.
%     onecluster(pixel_labels ~= k) = 0;
%     onecluster(onecluster ~=0) =1;
%     L=bwlabel(logical(onecluster));  %it can be bwlabeln (they say it is faster)
%     for k3=1:max(unique(L))
%         AUX=L==k3;
%         if borderobj==0 && hasborder(AUX)
%             continue
%         end
%         AUX=imfill(AUX,'holes');
%         onecluster=IM;
%         onecluster(repmat(AUX,[1 1 3]) ~= 1) = 0;
%         % reject objects not totally in the image
% 
%         npixels(k2)=sum(sum(AUX));
%     segmented_images{k2} = onecluster;
%     edge_boundaries{k2}=bwperim(AUX);
% % [row,col]=find(AUX,1);
% % bo=bwtraceboundary(AUX,[row col],'SE');
% % AUX(:)=0;
% % AUX(sub2ind(size(AUX),bo(:,1),bo(:,2)))=1;
% %     edge_boundaries{k2}=AUX;
%     k2=k2+1;
%     end
% end

%edge (canny) detection
kedge=k2;
%[O,E]=rsm_check_edge_object(edge(rgb2gray(IM),'canny',[],.75),0,0,0);
if useonlygreen==0
[O,E]=rsm_check_edge_object(edge(rgb2gray(IM),'canny',[],.25),0,0,borderobj);
else
    % [O,E]=rsm_check_edge_object(edge(IM(:,:,2),'canny',[],.45),0,0,borderobj);
    % [O,E]=rsm_check_edge_object(edge(IM(:,:,2),'canny',[],.5),0,0,borderobj);
    [O,E]=rsm_check_edge_object(edge(IM(:,:,2),'canny',[],1),0,0,borderobj); %last
end
%L=bwlabel(edge(rgb2gray(IM),'sobel')); %let try sobel
    for k3=1:length(O)
        onecluster=IM;
        onecluster(repmat(O{k3},[1 1 3]) ~= 1) = 0;
        % reject objects not totally in the image

        npixels(k2)=sum(sum(O{k3}));
    segmented_images{k2} = onecluster;
    edge_boundaries{k2}=E{k3};
    k2=k2+1;
    end


if (ddebug)
for k=1:length(segmented_images)
figure(k+1),imshow(segmented_images{k}), title(['objects in cluster ' num2str(k)]);
if k>=kedge
    title(['objects in canny' num2str(k)]);
end
end
for k=1:length(edge_boundaries)
    if isempty(edge_boundaries{k})
        continue
    end
figure(k+length(segmented_images)+1),imshow(edge_boundaries{k}), title(['edges of cluster ' num2str(k)]);
if k>=kedge
    title(['edges in canny' num2str(k)]);
end
end
end

function y = hasborder(IM)


    suma=sum(IM(1,:))+sum(IM(end,:))+sum(IM(:,1))+sum(IM(:,end));

y=suma>0;

function [L,C] = kmeanspp(X,k)
%KMEANS Cluster multivariate data using the k-means++ algorithm.
%   [L,C] = kmeans(X,k) produces a 1-by-size(X,2) vector L with one class
%   label per column in X and a size(X,1)-by-k matrix C containing the
%   centers corresponding to each class.

%   Version: 21/09/10
%   Authors: Laurent Sorber (Laurent.Sorber@cs.kuleuven.be)
%
%   References:
%   [1] J. B. MacQueen, Some Methods for Classification and Analysis of 
%       MultiVariate Observations, in Proc. of the fifth Berkeley Symposium
%       on Mathematical Statistics and Probability, L. M. L. Cam and
%       J. Neyman, eds., vol. 1, UC Press, 1967, pp. 281?297.
%   [2] D. Arthur and S. Vassilvitskii, k-means++: The Advantages of
%       Careful Seeding, Technical Report 2006-13, Stanford InfoLab, 2006.

[d n] = size(X);
L = [];
L1 = 0;

while length(unique(L)) ~= k
     
    C = [X(:,ceil(n*rand)) zeros(d,k-1)];
    %C = [X(:,randi(n)) zeros(d,k-1)];
    L = ones(1,n);
    for i = 2:k
        D = X-C(:,L);
        D = sqrt(dot(D,D));
        C(:,i) = X(:,find(rand < cumsum(D)/sum(D),1));
        Ci = C(:,1:i);
        [nada,L] = max(bsxfun(@minus,Ci'*X,0.5*dot(Ci,Ci).'));
    end
    
    while any(L ~= L1)
        L1 = L;
        S = sparse(1:n,L,1,n,k,n);
        C = bsxfun(@times,X*S,1./sum(S));
        [nada,L] = max(bsxfun(@minus,C'*X,0.5*dot(C,C).'));
    end
    
end
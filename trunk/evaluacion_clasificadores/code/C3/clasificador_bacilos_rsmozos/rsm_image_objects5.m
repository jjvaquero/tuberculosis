function [segmented_images,npixels,edge_boundaries]=rsm_image_objects5(IM,nClusters,borderobj,ddebug)

try
    nClusters=nClusters;
catch
    nClusters=4;
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
try
    ddebug=ddebug;
catch
ddebug=0;
end
[segmented_images,npixels,edge_boundaries]=rsm_image_objects4(IM,nClusters,borderobj,ddebug,1);

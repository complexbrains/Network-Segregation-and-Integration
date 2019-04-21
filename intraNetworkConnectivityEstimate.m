function [intraNetworkConnectivity,grandLayerWiseAverageIntraNetworkConnectivity]= intraNetworkConnectivityEstimate(layerNum, pwd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script intraNetworkConnectivityEstimate.m
%
% Estimates the within network connectivity for each of the subnetworks/communities
% for single network layer for each of the subjects.
%
% Dependencies:
%    -No dependency
%
%
% Isil Bilgin 01/11/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for subjectNum=1:size(subjectPool,2)
    mainSubjectFolder =  fullfile(pwd, sprinf('Subject%s',subjectPool{subjectNum}));
    load(fullfile(mainSubjectFolder,'multilayeredMatrix.mat'));
    
    for layer=1:layerNum
        
        for subNetIndx=1:max(unique(nodeAssingment))
            subNetwork = find(nodeAssingment==subNetIndx);
            
            index =0; % index of each pair of connectivity between networks
            
            intraNetworkConnectivity{subjectNum,layer}(subNetIndx) = 0;
            
            for node1=1:size(subNetwork,2)-1
                for node2 =node1+1:size(subNetwork,2)
                    if multiMatrix{1,layer}(subNetwork(node1),subNetwork(node2))~=0 % only add the existing connections to the sum hence the mean
                        index=index+1;
                        
                        intraNetworkConnectivity{subjectNum,layer}(subNetIndx)  =  intraNetworkConnectivity{subjectNum,layer}(subNetIndx) + multiMatrix{1,layer}(subNetwork(node1),subNetwork(node2));
                    end
                end
            end
            intraNetworkConnectivity{subjectNum,layer}(subNetIndx) =  intraNetworkConnectivity{subjectNum,layer}(subNetIndx)/index;
        end
    end
end


%% Average Intra-network strenght estimate across the subjects

for layer=1:layerNum
    averageIntraNetworkConnectivity{layer} = zeros(1,max(unique(nodeAssingment)));
    
    for subjectNum=1:size(subjectPool,1)
        
        averageIntraNetworkConnectivity{layer} = averageIntraNetworkConnectivity{layer} +intraNetworkConnectivity{subjectNum,layer};
        
    end
    averageIntraNetworkConnectivity{layer} = averageIntraNetworkConnectivity{layer}/size(subjectPool,2);
    
end


for layer=1:layerNum
    grandLayerWiseAverageIntraNetworkConnectivity(layer) = mean(averageIntraNetworkConnectivity{layer});
end




save(fullfile(pwd, 'intraNetworkConnectivityEstimates.mat'),'intraNetworkConnectivity','averageIntraNetworkConnectivity','grandLayerWiseAverageIntraNetworkConnectivity')

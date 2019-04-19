function [interNetworkConnectivity,grandLayerWiseAverageInterNetworkConnectivity] = interNetworkConnectivityEstimate(layerNum, pwd)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script interNetworkConnectivityEstimate.m
%
% Estimates the between network connectivity across subnetworks/communities
% across network layers for each single subjects.
%
% Dependencies:
%    - No dependencies
%
%
% Isil Bilgin 01/11/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for subjectNum=1:size(subjectPool,2)
    mainSubjectFolder =  fullfile(pwd, sprinf('Subject%s',subjectPool{subjectNum}));
    load(fullfile(mainSubjectFolder,'multilayeredMatrix.mat'));
    
    for layer=1:layerNum
        
        for subNetIndx1=1:max(unique(nodeAssingment))-1
            
            for subNetIndx2=subNetIndx1+1:max(unique(nodeAssingment))
                index =0; % index of each pair of connectivity between networks
                
                subNetwork1 = find(nodeAssingment==subNetIndx1);
                                subNetwork2 = find(nodeAssingment==subNetIndx2);

                interNetworkConnectivity{subjectNum,layer}(subNetIndx1,subNetIndx2) = 0;

                for node1=1:size(subNetwork1,2)
                    for node2 =1:size(subNetwork2,2)
                        
                        if multiMatrix{1,layer}(subNetwork1(node1),subNetwork2(node2))~=0 % only add the existing connections to the sum hence the mean
                            index=index+1;
                            
                            interNetworkConnectivity{subjectNum,layer}(subNetIndx1,subNetIndx2)  =  interNetworkConnectivity{subjectNum,layer}(subNetIndx1,subNetIndx2)+ multiMatrix{1,layer}(subNetwork1(node1),subNetwork2(node2));
                        end
                    end
                end
                interNetworkConnectivity{subjectNum,layer}(subNetIndx1,subNetIndx2)   =  interNetworkConnectivity{subjectNum,layer}(subNetIndx1,subNetIndx2)/index;
            end
        end
    end
end

%% Average Inter-network strenght estimate across the subjects

for layer=1:layerNum
    averageInterNetworkConnectivity{layer} = zeros(max(unique(nodeAssingment)), max(unique(nodeAssingment)));
    
    for subjectNum=1:size(subjectPool,1)
        
        averageInterNetworkConnectivity{layer} = averageInterNetworkConnectivity{layer} + interNetworkConnectivity{subjectNum,layer} ;
        
    end
    averageInterNetworkConnectivity{layer} = averageInterNetworkConnectivity{layer} /size(subjectPool,1);
end


%% Average inter-network strenght within a layer
for layer=1:layerNum
    grandLayerWiseAverageInterNetworkConnectivity(layer) = 0;
    index=0;
for subNetIndx1=1:max(unique(nodeAssingment))-1
  for subNetIndx2=subNetIndx1+1:max(unique(nodeAssingment))
      index=index+1;
        grandLayerWiseAverageInterNetworkConnectivity(layer) = grandLayerWiseAverageInterNetworkConnectivity(layer) + averageInterNetworkConnectivity{layer}(subNetIndx1,subNetIndx2);       
    end
    grandLayerWiseAverageInterNetworkConnectivity(layer) = grandLayerWiseAverageInterNetworkConnectivity(layer) /index;
end
end



save(fullfile(pwd, 'interNetworkConnectivityEstimates.mat'),'interNetworkConnectivity','averageInterConnectivity','grandLayerWiseAverageInterNetworkConnectivity')

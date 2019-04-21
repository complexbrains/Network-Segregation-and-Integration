function systemSegregation = networkSegregation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script parameterOptimization.m 
%
% Estimates the segregation of network across layers, based on the inter
% and intra network connectivity strength between subnetworks/communities.
% If you are running the segregation estimation based on community partitions
% of a multilayered network, then you will need to feed the algorithm with
% the layerwise node assignment vector each time you run the segregation
% estimation on a new layer. Here we consider you have you run the
% estimation based on subnetworks (eg. Default mode networks, salience
% network, visual network etc.).
%
%
% Dependencies:   
%    - interNetworkConnectivityEstimate.m
%    - intraNetworkConnectivityEstimate.m
% 
%
% Isil Bilgin 10/07/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;
close all;
subjectPool={'01','02','03','04','05','06','07','08','09','10'};
pwd = ' '; % Add a main folder path
layerNum= 10; % set the number of layer
nodeAssingment = [1 1 1 1 2 2 2 2 2 2 3 3 4 4 4 4 5 3 3 4 4 2 2 1 1 1 5 5 5 5 ]; % Subnetwork/community assignment vector of nodes

for subjectNum=1:size(subjectPool,2)
mainSubjectFolder =  fullfile(pwd, sprinf('Subject%s',subjectPool{subjectNum}));
load(fullfile(mainSubjectFolder,'multilayeredMatrix.mat'));  

%% Estimate the between network strenght

[interNetworkConnectivity,grandLayerWiseAverageInterNetworkConnectivity] = interNetworkConnectivityEstimate(layerNum, pwd);

%% Estimate the within network strenght
[intraNetworkConnectivity,grandLayerWiseAverageIntraNetworkConnectivity]= intraNetworkConnectivityEstimate(layerNum, pwd);

%% Network segregation

  for layer=1:layerNum
        systemSegregation(1,layer) =   (grandLayerWiseAverageIntraNetworkConnectivity(layer) - grandLayerWiseAverageInterNetworkConnectivity(layer))/grandLayerWiseAverageIntraNetworkConnectivity(layer);
  end



% PARÂMETROS PARA CLASSIFICADORES - salva a partir da otimização

function [Param] = param_classifica()

% kNN
f1 = 'Distance';
v1 = {'euclidean'};
f2 = 'NumNeighbors';
v2 = [10 10 10];

f3 = 'DistributionNames';
v3 = 'normal';
f4 = 'Prior';
v4 = [1/4 1/8 1/62];

% arvoredo
f5 = 'TreeMinLeafSize';
v5 = 2;

% ensemble
f6 = 'Method';
f7 = 'NLearn';
f8 = 'MinLeafSize';
v6 = {'Bag'};
v7 = [0];
v8 = [0];

% SVM
f9 = 'BoxConstraints';
f10 = 'KScale';
v9 = [1];
v10 = [0.3 0.2 0.21];

% f11 = 'neuronios';
% v11 = {12 24 36 48 60 72 96 108 120 132 144 168 180 192 204};
f11 = 'ValChecks';
v11 = [100 100 100];

Param = struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7,f8,v8,f9,v9,f10,v10,f11,v11);


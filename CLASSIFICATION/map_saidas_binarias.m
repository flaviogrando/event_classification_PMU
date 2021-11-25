


function [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest)

C = unique(Ytrain);
num_classes = length(C);

% processa conjunto de treino
num_inst = length(Ytrain);
saidas_temp = zeros(num_inst,num_classes);
for i=1:num_classes
    I = find( Ytrain(:,1) == C(i));    
    saidas_temp(I,i) = 1;
end 
Ytrain = saidas_temp;

% processa conjunto de teste
num_inst = length(Ytest);
saidas_temp = zeros(num_inst,num_classes);
for i=1:num_classes
    I = find( Ytest(:,1) == C(i));    
    saidas_temp(I,i) = 1;
end 
Ytest = saidas_temp;
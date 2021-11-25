


function [Xtest,Ytest,Ztest,Xtrain,Ytrain,Ztrain]=seleciona_dados(entradas,saidas,labels,n,num_folds)

% n = índice do fold

% Detecta número de instâncias e número de classes
C = unique(saidas);
num_classes = length(C);
[num_inst, num_feat] = size(entradas);


fold_size = round(num_inst/num_folds); % Calcula tamanho do fold 
class_size = round(num_inst/num_classes);   % numero de inst por classe
class_fold_size = round(class_size/num_folds); % num de classes por fold

Xtest = [];
Ytest = [];
Ztest = [];
Xtrain = entradas;
Ytrain = saidas;
Ztrain = labels;

class_index =  class_fold_size*(n-1); % calcula indice do fold
% Extrair porção de cada classe
for i = 1:num_classes
    de = class_size*(i-1)+1 + class_index;
    ate = de + class_fold_size -1;
    % separa conjunto teste (minor)
    Xtest = [Xtest; entradas(de:ate,:)];
    Ytest = [Ytest; saidas(de:ate,:)];
    Ztest = [Ztest; labels(de:ate,:)];

    Xtrain(de:ate,:) = 0;
    Ytrain(de:ate,:) = 0;
    Ztrain(de:ate,:) = 0;
end
% separa conjunto treino (major)


% mapeia indices de zeros
I = find( Ytrain(:,1) == 0); 
% deleta linhas de zeros
Xtrain(I,:) = [];
Ytrain(I,:) = [];
Ztrain(I,:) = [];



% % Aloca major inputs
% j=0;
% while j<length(Xtrain(:,1)) % enquanto houver linhas para testar
%     j=j+1;                % incrementa indice
%     if Xtrain(j,1)==0   % testa se linha = 0;
%         Xtrain(j,:)=[]; % deleta linha de zeros
%         Ytrain(j,:)=[];
%         Ztrain(j,:)=[];
%         j=j-1;            % retorna o indice (linha deletada)
%     end
% end


% nf = num_feat  = número de features

% % Calcula índices para selecionar os dados
% ini = nf*(n-1) + 1; 
% fim = ini + nf - 1;
% 
% % Treino
% Xtest = in_cv(:,ini:fim);
% Ytest = out_cv(:,n);
% Ztest = label_cv(:,n);
% 
% % Separa dados de teste
% Xtemp = in_cv;
% Ytemp = out_cv;
% Ztemp = label_cv;
% 
% Xtemp(:,ini:fim) = [];
% Ytemp(:,n) = [];
% Ztemp(:,n) = [];
% 
% Xtrain = [];
% Ytrain = [];
% Ztrain = [];
% 
% % REMONTA DADOS
% for i=1:num_fold-1
%     
%     ini = nf*(i-1) + 1;
%     fim = ini + nf - 1;
%     
%     Xtrain = [Xtrain; Xtemp(:,ini:fim)];
%     Ytrain = [Ytrain; Ytemp(:,i)];
%     Ztrain = [Ztrain; Ztemp(:,i)];



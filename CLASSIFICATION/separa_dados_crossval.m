
% Dados devem estar ordenados por classe e embaralhados intraclasse!!!!!

function [entrada_cross_val, saida_cross_val, label_cross_val] = separa_dados_crossval(entradas,saidas,labels,num_folds)



% Será necessário ajuste nos tamanhos (divisões inteiras)

% Detecta número de instâncias e número de classes
C = unique(saidas);

[num_inst, num_feat] = size(entradas);

%num_inst = length(saidas);
num_classes = length(C);


% separar porções, proporcionalmente
entrada_cross_val = [];
saida_cross_val = [];
label_cross_val = [];

for i=1:num_classes
    I = find(saidas == C(i));     % identifica índices da classe
    num_inst_class = length(I);   % número de instâncias da classe
    % Extrai porção de um fold
    fold_out = reshape(saidas(I,:),[num_inst_class/num_folds, num_folds]);
    
    for j=1:num_feat
        fold_in = reshape(entradas(I,j),[num_inst_class/num_folds, num_folds]);
    end
    fold_label = reshape(labels(I,:),[num_inst_class/num_folds, num_folds]);
    
    % embaralha dados de intraclasse intrafold
    %[fold_in,fold_out,fold_label] = embaralha_dados(fold_in,fold_out,fold_label);
    
    entrada_cross_val = [entrada_cross_val; fold_in];
    saida_cross_val = [saida_cross_val; fold_out];
    label_cross_val = [label_cross_val; fold_label];

end


% fold_size = round(num_inst/num_folds); % Calcula tamanho do fold 
% class_size = round(num_inst/num_classes);   % numero de inst por classe
% class_fold_size = round(class_size/num_folds); % num de classes por fold
% 
% X_test = [];
% Y_test = [];
% Z_test = [];
% X_train = entradas;
% Y_train = saidas;
% Z_train = labels;
% 
% fold_index =  class_fold_size*(n-1); % calcula indice do fold
% % Extrair porção de cada classe
% for i = 1:num_classes
%     de = class_size*(i-1)+1 + fold_index;
%     ate = de + class_fold_size -1;
%     % separa conjunto teste (minor)
%     X_test = [X_test; entradas(de:ate,:)];
%     Y_test = [Y_test; saidas(de:ate,:)];
%     Z_test = [Z_test; labels(de:ate,:)];
% 
%     X_train(de:ate,:) = 0;
%     Y_train(de:ate,:) = 0;
%     Z_train(de:ate,:) = 0;
% end
% % separa conjunto treino (major)
% % Aloca major inputs
% j=0;
% while j<length(X_train(:,1)) % enquanto houver linhas para testar
%     j=j+1;                % incrementa indice
%     if X_train(j,1)==0   % testa se linha = 0;
%         X_train(j,:)=[]; % deleta linha de zeros
%         Y_train(j,:)=[];
%         Z_train(j,:)=[];
%         j=j-1;            % retorna o indice (linha deletada)
%     end
% end



function[matriz_entrada,matriz_saida,matriz_labels] = deleta_padroes(diretorio,dados)

% casos para deletar
Z = ["110", "144", "1500"];
L = ["78_80", "54_57", "52_53", "300_108", "35_40"];


load(strcat(diretorio,dados))          % carrega dados    
    
indice_faltas = find( matriz_saida(:,1) == 1);  % Idenfifica índices das faltas

i=0;
for n=1:length(indice_faltas)
    % Segmenta label
    splited_case = strsplit(matriz_labels(n), {'Z', 'I', 'L', 'T'});
    % Extrai valores
    Zn = splited_case{2};
    Ln = splited_case{4};
    
    
    if strcmp(Z(1),Zn) || strcmp(Z(2),Zn) || strcmp(Z(3),Zn)
        i = i + 1;
        idx_del(i) = n;
        
    elseif strcmp(L(1),Ln) || strcmp(L(2),Ln) || strcmp(L(3),Ln) || strcmp(L(4),Ln) || strcmp(L(5),Ln)
        i = i + 1;
        idx_del(i) = n;       
    end
        
end

matriz_entrada(idx_del,:) = [];
matriz_saida(idx_del,:) = []; 
matriz_labels(idx_del,:) = []; 
end

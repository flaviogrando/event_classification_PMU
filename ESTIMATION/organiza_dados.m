

% Organiza matrizes

function [matriz_entrada, matriz_saida, matriz_labels]= organiza_dados(matriz_entrada, matriz_saida, matriz_labels)

num_inst = length(matriz_labels);

% concatena string e converta pra num. Saída esperada tipo '1234'
for n=1:num_inst
    digito(n,1) = num2str(matriz_saida(n,1));
    digito(n,2) = num2str(matriz_saida(n,2));
    digito(n,3) = num2str(matriz_saida(n,3));
    digito(n,4) = num2str(matriz_saida(n,4));
    % Monta saídas:
    saidas(n,1) = matriz_saida(n,1);
    saidas(n,2) = str2num(strcat(digito(n,1),digito(n,2)));
    saidas(n,3) = str2num(strcat(digito(n,1),digito(n,2),digito(n,3)));
    saidas(n,4) = str2num(strcat(digito(n,1),digito(n,2),digito(n,3),digito(n,4)));
end


C = unique(saidas(:,4)); %Detecta classes

[saida_ordenada,I] = sort(saidas(:,4)); %ordena pela 4th coluna ?



X = matriz_entrada(I,:);   % ordena entradas

Y = saidas(I,:);     % ordena saídas

Z = matriz_labels(I,:);    % ordena labels

disp('Número de instâncias:')
num_inst = length(saidas(:,4))
disp('Número de classes:')
C = unique(saidas(:,4)); %Detecta classes
num_classes = length(C)
disp('Padrões por classe:')
inst_p_classe = num_inst/num_classes % 600

% EMBARALHA PADRÕES INTRACLASSE
for i=1:num_classes
    de = (i-1)*inst_p_classe + 1;
    ate = de + inst_p_classe - 1;
    
    [X(de:ate,:), Y(de:ate,:), Z(de:ate,:)] = embaralha_dados(X(de:ate,:), Y(de:ate,:), Z(de:ate,:));    
end

matriz_entrada = X;
matriz_saida = Y; 
matriz_labels = Z;
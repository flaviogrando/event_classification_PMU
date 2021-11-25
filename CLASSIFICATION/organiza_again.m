% organiza de novo (para menos classes)


function [matriz_entrada,matriz_saida,matriz_labels]=organiza_again(X,Y,Z,col)


num_inst = length(Y(:,1));  % numero de inst�ncias
C = unique(Y(:,col));       % identifica elementos (classes)
num_classes = length(C); % numero de classes
inst_p_classe = num_inst/num_classes;

% EMBARALHA PADR�ES INTRACLASSE
for i=1:num_classes
    de = (i-1)*inst_p_classe + 1;
    ate = de + inst_p_classe - 1;
    [X(de:ate,:), Y(de:ate,:), Z(de:ate,:)] = embaralha_dados(X(de:ate,:), Y(de:ate,:), Z(de:ate,:));    
end

matriz_entrada = X;
matriz_saida = Y;
matriz_labels = Z;
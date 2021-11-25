%%%       SELETOR: FASOR PRÉ E PÓS EVENTO



function [matriz_entrada] = monta_entradas(matriz_entrada, Fca, Fcb, Fcc, num_var, n, i)

pre = 1; % indice pre falta
pos = 2; % indice pos falta
% pre = 3; % indice pre falta
% pos = 5; % indice pos falta
%[num_cic, num_comp] = size(Fca);

% pré
matriz_entrada(n,i*3-2) = Fca(pre,1);
matriz_entrada(n,i*3-1) = Fcb(pre,1);
matriz_entrada(n,i*3) = Fcc(pre,1);
% pós
matriz_entrada(n,i*3-2 + num_var) = Fca(pos,1);
matriz_entrada(n,i*3-1 + num_var) = Fcb(pos,1);
matriz_entrada(n,i*3 + num_var) = Fcc(pos,1);

end
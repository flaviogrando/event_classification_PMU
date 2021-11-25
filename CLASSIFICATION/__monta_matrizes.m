% MONTA MATRIZES DE ENTRADA E SAÍDA
% EXTRAI CARACTERISTICAS E GERA MATRIZ DE ENTRADA COM TODOS OS DADOS
% DADOS NA ORDEM DOS ARQUIVOS (NECESSÁRIO ORDENAR = ARQUIVO 3)

clc
clear all
close all

% endereço de entrada:
dir_fasores = 'D:\fasores\FREQUENCIA\55Hz\';      
% endereço de saída para salvar features:
arquivo_saida = 'C:\Users\flavi\Google Drive\MATLAB\FINAIS\Dados\Freq\FFT\dados_55Hz';

list_arq = dir(dir_fasores);

list_arq(1) = [];                % deleta 1st elemento da lista
list_arq(1) = [];                % deleta 1st elemento da lista

matriz_entrada = []; % inicia matriz

for n=1:length(list_arq)
    
    arquivo = strcat(dir_fasores,list_arq(n).name); % monta nome do arquivo
    load(arquivo);          % carrega um arquivo por vez
    list_var = fieldnames(fasores);
    %list_var = who('-file',dados.); % lista nome das variáveis contidas no arq
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   EXTRAI CARACTERÍSTICAS
    num_pmus = length(list_var);
    for i=1:num_pmus
        
        fasor = fasores.(list_var{i});    % extrai fasores
        %diferenca = fasor(1)-fasor(2);    % extrai diferença pré pós
        %diferenca = fasor(1);
        dif_mag = abs(fasor(1))-abs(fasor(2));
        dif_ang = angle(fasor(1))-angle(fasor(2));
        
        %[ang, mag] = cart2pol(real(diferenca), imag(diferenca)); % converte pra polar
       
        matriz_entrada(n,i) = dif_mag; % magnitude na 1st metade
        matriz_entrada(n,num_pmus+i) = dif_ang; %angulos na 2nd metade
        
    end
    
        % -----------------------------------------------------------
    % MONTA DADOS DE SAÍDA
    a = strsplit(list_arq(n).name, {'T', '.'});
    name = a{2}; % coluna 2
    matriz_saida(n,1) = strcmp(name,'AGMN');
    matriz_saida(n,2) = strcmp(name,'BGMN');
    matriz_saida(n,3) = strcmp(name,'CGMN');
    matriz_saida(n,4) = strcmp(name,'ABMN');
    matriz_saida(n,5) = strcmp(name,'BCMN');
    matriz_saida(n,6) = strcmp(name,'CAMN');
    matriz_saida(n,7) = strcmp(name,'ABGMN');
    matriz_saida(n,8) = strcmp(name,'BCGMN');
    matriz_saida(n,9) = strcmp(name,'CAGMN');
    matriz_saida(n,10) = strcmp(name,'ABCGMN'); 
    %matriz_saida(n,11) = strcmp(name,'ABCGMN');
    
    matriz_saida123(n,1) = find(matriz_saida(n,:));
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ordena dados

[num_inst, num_classes] = size(matriz_saida);

num_int_class = num_inst/num_classes; % numero de instancias por classe

for n=0:num_classes-1
   cont(n+1) = n*(num_int_class); % índices
end

% Organiza classes em ordem
for n=1:length(matriz_saida) 
    % Busca qual coluna = 1 (classe)
    k = find(matriz_saida(n,:));
    % Determina o novo indice do padrão/classe
    cont(k) = cont(k)+1;
    % Carrega o padrão e classe no novo indice;
    novas_saidas(cont(k),:) = matriz_saida(n,:);
    novas_saidas123(cont(k),:) = matriz_saida123(n,:);
    novas_entradas(cont(k),:) = matriz_entrada(n,:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Embaralha padrões dentro de cada classe (classes em ordem)
for n=0:num_classes-1
   de = n*num_int_class+1;
   ate = de+num_int_class-1;
   X = novas_entradas(de:ate,:);
   Y = novas_saidas(de:ate,:);
   [X,Y] = embaralha_padroes(X,Y,num_int_class);
   matriz_entrada(de:ate,:) = X;
   matriz_saida(de:ate,:) = Y;
end
matriz_saida123 = novas_saidas123;

save(arquivo_saida, 'matriz_entrada', 'matriz_saida', 'matriz_saida123')
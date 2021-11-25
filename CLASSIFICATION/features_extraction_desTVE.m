

function [entradas, saidas, labels] = features_extraction_desTVE(diretorio, dados, grupo,f,col,erro,k)



if col <4 % se nívei de classe de 1 a 3, chama a função
    [matriz_entrada,matriz_saida,matriz_labels] = deleta_padroes(diretorio,dados);
    [matriz_entrada,matriz_saida,matriz_labels]=organiza_again(matriz_entrada,matriz_saida,matriz_labels,col);
else % segue o bailefe = 0.5:0.5:5;
    load(strcat(diretorio,dados));         % carrega dados
end

% matriz_entrada = gpuArray(matriz_entrada);
% matriz_saida = gpuArray(matriz_saida);
%matriz_labels = gpuArray(matriz_labels);

% %s = 200; % size do conjunto
% %%% teste de overfitting da rna
% [matriz_entrada,matriz_saida,matriz_labels]=organiza_again(matriz_entrada,matriz_saida,matriz_labels,col);
% cs = 8400; % class size
% sdel = cs - s; % tamanho do cojunto a ser deletado
% for i=1:4
%     ci = 4 - i;
%     ini = ci*cs+s+1;  % class_index*8400 + size + 1
%     fim = ini + sdel - 1; % 
%     matriz_entrada(ini:fim,:) = [];
%     matriz_saida(ini:fim,:) = [];
%     matriz_labels(ini:fim,:) = [];    
% end


%%%

num_inst = length(matriz_saida(:,1));  % numero de instâncias
C = unique(matriz_saida(:,col));       % identifica elementos (classes)
saidas = zeros(num_inst,1);            % cria saídas

% Converte coluna para valores contínuos 1 a N
for i=1:length(C)
    I = find( matriz_saida(:,col) == C(i));    
    saidas(I,1) = i; 
end 


labels = matriz_labels;

% Extrai diferenças pré - pós
%[D] = diferenca_pre_pos(matriz_entrada);
[D] = diferenca_pre_pos_freq_desTVE(matriz_entrada, f,erro,k);
%[D] = diferenca_entre_pmus(matriz_entrada, f); % !!!!!!!!!!!!!!!!!!!!!!!!!




switch grupo % SELECIONA GRUPO DE CARACTERÍSTICAS
    % A
    case 1
        entradas = [D.MT1];
    case 2
        entradas = [D.MT2];
    case 3
        entradas = [D.MT3];
    case 4
        entradas = [D.MT4];
    % B
    case 5
        entradas = [D.MT1 D.MT2];
    case 6
        entradas = [D.MT1 D.MT3];
    case 7
        entradas = [D.MT1 D.MT4];       
    % C
    case 8
        entradas = [D.MC1];  
    case 9
        entradas = [D.MC2];
    case 10
        entradas = [D.MC3];
    case 11
        entradas = [D.MC4]; %
    % D
    case 12
        entradas = [D.MC1 D.MC2]; 
    case 13
        entradas = [D.MC1 D.MC3]; 
    case 14
        entradas = [D.MC1 D.MC4 ]; %      
    % E
    case 15
        entradas = [D.MT1 D.MC1];  
    case 16
        entradas = [D.MT2 D.MC2];
    case 17
        entradas = [D.MT3 D.MC3];
    case 18
        entradas = [D.MT4 D.MC4]; % 
    % F      
    case 19
        entradas = [D.MT1 D.MT2 D.MC1 D.MC2]; 
    case 20
        entradas = [D.MT1 D.MT3 D.MC1 D.MC3]; 
    case 21
        entradas = [D.MT1 D.MT4 D.MC1 D.MC4]; % 
        
    % Magnitude e Angulos a parti daqui    
    % G
    case 22
        entradas = [D.MT1 D.AT1];
    case 23
        entradas = [D.MT2 D.AT2];    
    case 24
        entradas = [D.MT3 D.AT3];
    case 25
        entradas = [D.MT4 D.AT4];
    % H
    case 26
        entradas = [D.MT1 D.MT2 D.AT1 D.AT2];
    case 27
        entradas = [D.MT1 D.MT3 D.AT1 D.AT3];
    case 28
        entradas = [D.MT1 D.MT4 D.AT1 D.AT4];
   % I
    case 29
        entradas = [D.MC1 D.AC1]; 
    case 30
        entradas = [D.MC2 D.AC2]; 
    case 31
        entradas = [D.MC3 D.AC3]; 
    case 32
        entradas = [D.MC4 D.AC4]; % 
    % J    
    case 33
        entradas = [D.MC1 D.MC2 D.AC1 D.AC2]; 
    case 34
        entradas = [D.MC1 D.MC3 D.AC1 D.AC3];
    case 35
        entradas = [D.MC1 D.MC4 D.AC1 D.AC4 ]; % <<<       
    % K    
    case 36
        entradas = [D.MT1 D.MC1 D.AT1 D.AC1]; 
    case 37
        entradas = [D.MT2 D.MC2 D.AT2 D.AC2]; 
    case 38
        entradas = [D.MT3 D.MC3 D.AT3 D.AC3]; 
    case 39
        entradas = [D.MT4 D.MC4 D.AT4 D.AC4]; %
    % L    
    case 40
        entradas = [D.MT1 D.MT2 D.MC1 D.MC2 D.AT1 D.AT2 D.AC1 D.AC2]; 
    case 41
        entradas = [D.MT1 D.MT3 D.MC1 D.MC3 D.AT1 D.AT3 D.AC1 D.AC3];
    case 42
        entradas = [D.MT1 D.MT4 D.MC1 D.AT1 D.AT4 D.AC1];% <<<
    
    % Somente ângulos a parti daqui    
    % G
    case 43
        entradas = [D.AT1];
    case 44
        entradas = [D.AT2];    
    case 45
        entradas = [D.AT3];
    case 46
        entradas = [D.AT4];
    % H
    case 47
        entradas = [D.AT1 D.AT2];
    case 48
        entradas = [D.AT1 D.AT3];
    case 49
        entradas = [D.AT1 D.AT4];
   % I
    case 50
        entradas = [D.AC1]; 
    case 51
        entradas = [D.AC2]; 
    case 52
        entradas = [D.AC3]; 
    case 53
        entradas = [D.AC4]; % <<< D.AC4
    % J    
    case 54
        entradas = [D.AC1 D.AC2]; 
    case 55
        entradas = [D.AC1 D.AC3];
    case 56
        entradas = [D.AC1 ]; % D.AC4       
    % K    
    case 57
        entradas = [D.AT1 D.AC1]; 
    case 58
        entradas = [D.AT2 D.AC2]; 
    case 59
        entradas = [D.AT3 D.AC3]; 
    case 60
        entradas = [D.AT4 ]; % D.AC4
    % L    
    case 61
        entradas = [D.AT1 D.AT2 D.AC1 D.AC2]; 
    case 62
        entradas = [D.AT1 D.AT3 D.AC1 D.AC3];
    case 63
        entradas = [D.AT1 D.AT4 D.AC1]; % D.AC4
    otherwise
        disp('Caso não cadastrado')
end




% entradas = [matriz_entrada(:,16:18) matriz_entrada(:,40:42)
% matriz_entrada(:,28:30) matriz_entrada(:,31:33)]; % SM início e fim
% entradas = [matriz_entrada(:,19:27) matriz_entrada(:,34:39)]; % SM nas chaves
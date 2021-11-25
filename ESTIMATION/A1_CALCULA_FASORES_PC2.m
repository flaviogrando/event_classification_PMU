%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             PMU 
% Entrada: arquivos de oscilografias.
% Sa�das: dados fasoriais pr�/p�s evento
% 
% 1 - Carrega oscilografias
% 2 - Carrega variaeis
% 3 - Aplica ru�do
% 4 - Segmenta sinal (janelamento)
% 5 - Calcula fasores
% 6 - Armazena dados

clc
clear all
close all

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Inicializa��es de vetores
% num_cic = 12 - 1;
% Fca = zeros(1,num_cic);
% Fcb = zeros(1,num_cic);
% Fcc = zeros(1,num_cic);

%diretorio = 'D:\ATP_SIMULACOES_v2\dados_brutos\faltas\';
%diretorio = 'C:\DADOS_ATP\Eventos\';
diretorio = 'C:\DADOS\Eventos\';
%dir_saida = 'C:\Users\flavi\Google Drive\MATLAB\FINAIS\Dados\Eventos\';       % sa�da: fasores
dir_saida = 'C:\Users\LabA305 - 08\Google Drive\MATLAB\FINAIS\Dados\Eventos\HWFFT\';       % sa�da: fasores


% Par�metros
%freq = 45:1:55;
freq = [50.01 50.02 50.03 50.04 50.05 49.95 49.96 49.97 49.98 49.99];
f0 = 50;
num_feat = 30;    % n�mero de dados (futuras caracter�sticas)
%num_classes = 10; % n�mero de classes

for f=1:length(freq) % VARRE PASTAS DE FREQ
    
    % Atualiza dir_entrada
    pasta = strcat([num2str(freq(f)),'Hz\']);
    dir_entrada = strcat(diretorio,pasta);
    list_arq = dir(dir_entrada);

    list_arq(1) = [];                % deleta 1st elemento da lista
    list_arq(1) = [];                % deleta 1st elemento da lista

    % Inicializa vari�veis
    num_inst = length(list_arq);               % numero de instancias(arquivos)
    matriz_entrada = zeros(num_inst,num_feat); %
    matriz_saida = zeros(num_inst,1);%
    matriz_labels = strings([num_inst,1]);     %
    
    clock
    tic
    for n = 1:num_inst
        

        % 1- CARREGA ARQUIVOS
        arquivo = strcat(dir_entrada,list_arq(n).name); % monta nome do arquivo
        
       % arquivo = strcat(dir_entrada,'ECGQ30N0C100Z100I040LxTABCMx')
%         list_var = who(matfile(arquivo));
%        sinais = load(arquivo);          % carrega vari�veis em uma struct(s�o mtas)
        load(arquivo);          % carrega vari�veis em uma struct(s�o mtas)
%        list_var = who('-file',arquivo); % lista nome das vari�veis contidas no arq
        list_var = fieldnames(sinais);
        
        t = sinais.t;                          % extrai t para calc fasorial
        index_t = find(strcmp(list_var, 't')); % busca indice da variavel 't'
        list_var(index_t) = [];                % delete elemento 't' da lista
        num_var = length(list_var);            % n�mero de vari�veis (medidores)
        %num_var = length(list_arq(n).name);            % n�mero de vari�veis (medidores)
        
        % 2 - CARREGA VARI�VEIS (SINAIS)
        for i=1:(num_var/3) % 3 por vez = MEDI��ES TRIF�SICAS

            % 3 - APLICA RU�DO
            %sinal = sinais.(list_var{i});       % l� sinais
%             Va = awgn(eval(list_var{i*3-2}),60,'measured');          % insere ru�do
%             Vb = awgn(eval(list_var{i*3-1}),60,'measured');          % insere ru�do
%             Vc = awgn(eval(list_var{i*3}),60,'measured');          % insere ru�do
             Va = sinais.(list_var{i*3-2});   
             Vb = sinais.(list_var{i*3-1});      
             Vc = sinais.(list_var{i*3});          

            % 4 - CALCULO DO FASOR FUNDAMENTAL
            %[Fca, Fcb, Fcc] = E1_dft(Va, Vb, Vc, t, f0);
            [Fca, Fcb, Fcc] = E2_hwfft(Va, Vb, Vc, t, f0, freq(f));


            % 5 - MONTA MATRIZ: PR� P�S FALTA
            % itera colunas da matriz
            % aqui vai o pre e pos
            %[matriz_entrada] = monta_entradas(matriz_entrada, Fca, Fcb, Fcc, num_var, n, i);
            pre = 1; % indice pre falta
            pos = 2; % indice pos falta

            % pr�
            matriz_entrada(n,i*3-2) = Fca(pre,1);
            matriz_entrada(n,i*3-1) = Fcb(pre,1);
            matriz_entrada(n,i*3) = Fcc(pre,1);
            % p�s
            matriz_entrada(n,i*3-2 + num_var) = Fca(pos,1);
            matriz_entrada(n,i*3-1 + num_var) = Fcb(pos,1);
            matriz_entrada(n,i*3 + num_var) = Fcc(pos,1);

        end

        % 6 - MONTA DADOS DE SA�DA
        [matriz_saida, matriz_labels]=monta_saidas(matriz_saida, matriz_labels, list_arq, n);
        
  
    end
    toc
    
% ORGANIZA DADOS (ORDENA��O E EMBARALHAMENTO INTRACLASSE)
[matriz_entrada, matriz_saida, matriz_labels]=organiza_dados(matriz_entrada, matriz_saida, matriz_labels);    
    
% salva fasores
arquivo = strcat([dir_saida,'dados_',num2str(freq(f)),'Hz.mat']); % dir + nome do arquivo
save(arquivo, 'matriz_entrada','matriz_saida','matriz_labels');

end
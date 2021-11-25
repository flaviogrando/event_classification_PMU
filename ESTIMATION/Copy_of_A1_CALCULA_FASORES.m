%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             PMU 
%
% 1 - Carrega oscilografias
% 2 - Carrega variaeis
% 3 - Aplica ruído
% 4 - Segmenta sinal (janelamento)
% 5 - Calcula fasores
% 6 - Armazena dados

clc
clear all
close all

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Inicializações de vetores
% num_cic = 12 - 1;
% Fca = zeros(1,num_cic);
% Fcb = zeros(1,num_cic);
% Fcc = zeros(1,num_cic);

%diretorio = 'D:\ATP_SIMULACOES_v2\dados_brutos\faltas\';
diretorio = 'D:\ATP_SIMULACOES_v2\dados_brutos\FALTAS_C_ABERTO\';
dir_saida = 'C:\Users\Flavio\Google Drive\MATLAB\FINAIS\Dados\Freq\DFT\DatasetMS\';       % saída: fasores

% Parâmetros
freq = 45:1:55;
f0 = 50;
num_feat = 84;    % número de dados (futuras características)
num_classes = 10; % número de classes

for f=1:length(freq) % VARRE PASTAS DE FREQ
    
    % Atualiza dir_entrada
    pasta = strcat([num2str(freq(f)),'Hz\']);
    dir_entrada = strcat(diretorio,pasta);
    list_arq = dir(dir_entrada);

    list_arq(1) = [];                % deleta 1st elemento da lista
    list_arq(1) = [];                % deleta 1st elemento da lista

    % Inicializa variáveis
    num_inst = length(list_arq);               % numero de instancias(arquivos)
    matriz_entrada = zeros(num_inst,num_feat); %
    matriz_saida = zeros(num_inst,num_classes);%
    matriz_saida123 = zeros(num_inst,1);       %
    matriz_labels = strings([num_inst,1]);     %
    
    tic
    for n = 1:num_inst

        % 1- CARREGA ARQUIVOS
        arquivo = strcat(dir_entrada,list_arq(n).name); % monta nome do arquivo
        sinais = load(arquivo);          % carrega variáveis em uma struct(são mtas)
        list_var = who('-file',arquivo); % lista nome das variáveis contidas no arq

        t = sinais.t;                          % extrai vetor de tempo
        index_t = find(strcmp(list_var, 't')); % busca indice da variavel 't'
        list_var(index_t) = [];                % delete elemento 't' da lista
        num_var = length(list_var);            % número de variáveis (medidores)

        % 2 - CARREGA VARIÁVEIS (SINAIS)
        for i=1:(num_var/3) % 3 por vez = MEDIÇÕES TRIFÁSICAS

            % 3 - APLICA RUÍDO
            %sinal = sinais.(list_var{i});       % lê sinais
            Va = awgn(sinais.(list_var{i*3-2}),60,'measured');          % insere ruído
            Vb = awgn(sinais.(list_var{i*3-1}),60,'measured');          % insere ruído
            Vc = awgn(sinais.(list_var{i*3}),60,'measured');          % insere ruído


            % 4 - CALCULO DO FASOR FUNDAMENTAL
            [Fca, Fcb, Fcc] = E1_dft(Va, Vb, Vc, t, f0);
            %[Fca, Fcb, Fcc] = E2_hwfft(Va, Vb, Vc, t, f0, freq(f));

%             figure, hold on, grid on
%             plot(abs(Fca))
%             
%             figure, hold on, grid on
%             plot(angle(Fca))
%             
%             display(i)

            % 5 - MONTA MATRIZ: PRÉ PÓS FALTA
            % itera colunas da matriz
            [matriz_entrada] = monta_entradas(matriz_entrada, Fca, Fcb, Fcc, num_var, n, i);

        end

        % 6 - MONTA DADOS DE SAÍDA
        [matriz_saida, matriz_saida123, matriz_labels]=monta_saidas(matriz_saida, matriz_saida123, matriz_labels, list_arq, n);
  
    end
    toc
% salva fasores
arquivo = strcat([dir_saida,'dados_',num2str(freq(f)),'Hz']); % dir + nome do arquivo
save(arquivo, 'matriz_entrada','matriz_saida','matriz_saida123','matriz_labels');

end
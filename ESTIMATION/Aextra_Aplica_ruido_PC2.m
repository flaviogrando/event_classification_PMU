%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             PMU 
% Entrada: arquivos de oscilografias.
% Sa�das: mesmos arquivos, por�m, com ru�do

clc
clear all
close all



%diretorio = 'C:\DADOS_ATP\Eventos_semruido\';
diretorio = 'C:\DADOS\Eventos\';
%dir_saida = 'C:\DADOS_ATP\Eventos_semruido\';       % sa�da: fasores
dir_saida = 'C:\DADOS\Eventos\';       % sa�da: fasores


% Par�metros
%freq = 45:1:55;
freq = [50.02 50.03 50.04 49.96 49.97 49.98];
f0 = 50;
%num_feat = 78;    % n�mero de dados (futuras caracter�sticas)
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
%     matriz_entrada = zeros(num_inst,num_feat); %
%     matriz_saida = zeros(num_inst,1);%
%     matriz_labels = strings([num_inst,1]);     %
    clock
    tic
    for n = 1:num_inst

        % 1- CARREGA ARQUIVOS
        arquivo = strcat(dir_entrada,list_arq(n).name); % monta nome do arquivo
        sinais = load(arquivo);          % carrega vari�veis em uma struct(s�o mtas)
        list_var = who('-file',arquivo); % lista nome das vari�veis contidas no arq

        t = sinais.t;                          % extrai vetor de tempo
        index_t = find(strcmp(list_var, 't')); % busca indice da variavel 't'
        list_var(index_t) = [];                % delete elemento 't' da lista
        num_var = length(list_var);            % n�mero de vari�veis (medidores)

            
        % 2 - CARREGA VARI�VEIS (SINAIS)
        for i=1:(num_var) % 3 por vez = MEDI��ES TRIF�SICAS

            % 3 - APLICA RU�DO
            % acessa pelo campo da list_var
            % insere ru�do
            % converte pra single
            %sinais.(list_var{i}) = single(awgn(sinais.(list_var{i}),60,'measured'));
            sinais.(list_var{i}) = single(sinais.(list_var{i})); 

        end

        
    % salva fasores
    arquivo = strcat([dir_saida,num2str(freq(f)),'Hz\',list_arq(n).name]); % dir + nome do arquivo
    save(arquivo, 'sinais');
    
    end
    toc
   
end
%%%%                       CLASSIFICAÇÃO - validação cruzada

% ATUALIZAR DIRETORIOS
% conforme estimador (dados)
% saida de dados (modelo)

clc
clear all
close all

%load('C:\DADOS_ATP\Resultados\DFT\50Hz\R28-ann-g1-e0-k0.mat')
% Variavel
%tipo = 1:1:63;
%tipo = [2 3 4 9 10 16 17 23 24 25 30 31 37 38 44 45 46 51 52 58 59];
tipo = [42];

% Fixos
dados = 'dados_50Hz.mat';            % Entrada: Dados                  % Grupo de características
classificador = {'knn', 'nb', 'tree', 'ensemble','svm','ann90', 'svm_c'}; % 
% Parâmetros
freq = 50;

% % Diretório: 
%diretorio = 'C:\Users\Flavio\Google Drive\MATLAB\FINAIS\Dados\Freq\DFT\Dataset\';
%dir_dados = 'C:\Users\flavi\Google Drive\MATLAB\FINAIS\Dados\Freq\DFT\DatasetMS\';
dir_dados = 'C:\Users\EVERTON\Google Drive\MATLAB\FINAIS\Dados\Eventos\DFT\';
%dir_modelos = 'C:\MEGAsync\DADOS\Modelos\DFT_60dB\';
%dir_resultados  = 'C:\DADOS_ATP\Resultados\erros_dos_modelos\';
dir_resultados = 'C:\MEGAsync\DADOS\Resultados\42_DFT_varTVE\';

num_folds = 5;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
col = [1 2 4];                               %  SELECIONA COLUNA DE SAÍDAS

neuronios ={12 24 36 48 60 72 84 96 108 120 122 134 146 158};
[Param] = parametros_classificadores();

erro = [0 0.025 0.05 0.1 0.25 0.5 0.75 1 1.5 2 2.5 3];  % TVE
%erro = [2.5];

k = [16 8 4 3 2 1.5 1 0.5 0];%
%k = [1];%


for i=1:length(k)
    for f=1:length(erro)         
        t=1; % fixa o conjunto de características
        for cl = 1:3%:length(col) % Repete para cada agrupamento de classes 
            % Seleciona características
            [entradas,saidas,labels] = features_extraction_varTVE(dir_dados,dados,tipo(t),freq,col(cl),erro(f),k(i));        
            for c = [6] % CLASSIFICADOR:
                tic
                for n = 1:num_folds

                    disp([cl c n])  
                    % 1) Seleciona dados de teste e treino
                    [Xtest,Ytest,Ztest,Xtrain,Ytrain,Ztrain]=seleciona_dados(entradas,saidas,labels,n,num_folds); 

                    % 2) Embaralha padrões
                    [Xtrain,Ytrain,Ztrain] = embaralha_dados(Xtrain,Ytrain,Ztrain);
                    [Xtest,Ytest,Ztest] = embaralha_dados(Xtest,Ytest,Ztest);

                    % 3) Treino & teste
                    % adicionar função para escolher qual classificador
                    %[Yestimado,Ytest,Param,Mdl] = classifica_otimizacao(Xtrain,Ytrain,Xtest,Ytest,cl,c,Param);                    
                    [Yestimado,Ytest,Mdl] = classifica(Xtrain,Ytrain,Xtest,Ytest,cl,c);
%                     [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
%                     Ytrain = Ytrain.';                             % transpõe matriz
%                     Ytest = Ytest.';                               % transpõe matriz
%                     Xtrain = Xtrain.';                             % transpõe matriz
%                     Xtest = Xtest.';                               % transpõe matriz
%                     Mdl = patternnet(neuronios{f}, 'trainrp');                 % cria rede                       
%                     Mdl.trainParam.epochs = 150000;                 % muda n max de epocas
%                     Mdl.trainParam.max_fail = 100;
%                     Mdl = configure(Mdl, Xtrain, Ytrain);          % configura
%                     tic;
%                     Mdl = train(Mdl,Xtrain,Ytrain, 'useParallel','yes'); %treino
%                     toc;
%                     Yestimado = Mdl(Xtest);                       % teste
%                     close all
%                     clc

                    % 5) ERRO
                    [resultado(n,:)] = calcula_acc_classif(Yestimado,Ytest);


                end
                toc
                %result = strcat(['R28-',classificador{c},'-g',num2str(col(cl)),'-n',num2str(neuronios{f})]); % 
               result = strcat(['R42-',classificador{c},'-g',num2str(col(cl)),'-e',num2str(erro(f)),'-k',num2str(k(i)),'.mat']); % 
                %result = strcat(['R28-',classificador{c},'-g',num2str(col(cl)),'-rp']); % 
                %arquivo_saida = strcat(['M',num2str(t),'_',classificador{1}]);
               save(strcat(dir_resultados,result),'resultado')%,'Yestimado','Ytest','Ztest')
                
                % 6) Salva modelo
                % Modelo (M), caracterísica (28), fold (1-5),grupo de
               % classes (1,2 ou 4), classificador
%                  modelo = strcat(['M28-',classificador{c},'-g',num2str(col(cl)),'-e',num2str(erro(f)),'-k',num2str(k(i)),'.mat']); %
%                  save(strcat(dir_modelos,modelo),'Mdl')  
            end

        end
    end
end
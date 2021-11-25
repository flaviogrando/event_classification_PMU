%%%%                       CLASSIFICAÇÃO - validação cruzada

% ATUALIZAR DIRETORIOS
% conforme estimador (dados)
% saida de dados (modelo)

clc
clear all
close all

%load('C:\DADOS_ATP\Resultados\erros\ann\R28-ann-g2-e0.25-k0.5.mat')
% Variavel
%tipo = 1:1:63;
%tipo = [2 3 4 9 10 16 17 23 24 25 30 31 37 38 44 45 46 51 52 58 59];
tipo = [28];

% Fixos
dados = 'dados_50Hz';            % Entrada: Dados                  % Grupo de características
classificador = {'knn', 'nb', 'tree', 'ensemble','svm','ann', 'svm_c'}; % 
% Parâmetros
freq = 50;

% % Diretório: 
%diretorio = 'C:\Users\Flavio\Google Drive\MATLAB\FINAIS\Dados\Freq\DFT\Dataset\';
%dir_dados = 'C:\Users\flavi\Google Drive\MATLAB\FINAIS\Dados\Freq\DFT\DatasetMS\';
dir_dados = 'C:\Users\LabA305 - 08\Google Drive\MATLAB\FINAIS\Dados\Eventos\DFT\';
dir_modelos = 'F:\MEGAsync\DADOS\Modelos\DFT\';
dir_resultados = 'F:\MEGAsync\DADOS\Resultados\DFT\';
%dir_modelos = 'C:\Users\flavi\Google Drive\MATLAB\FINAIS\Dados\Modelos\';

num_folds = 5;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
col = [1 2 4];                               %  SELECIONA COLUNA DE SAÍDAS

neuronios ={120};
[Param] = parametros_classificadores();
erro = [0 0.025 0.05 0.1 0.25 0.5 0.75 1];
%erro = [0 0.05];
k = [16 8 4 3 2 1.5 1 0.5 0];
k = [2];

for i=1:length(k)
    for f=1:length(erro)         
        t=1; % fixa o conjunto de características
        for cl = 1:3%1:3%1:length(col) % Repete para cada agrupamento de classes 
            % Seleciona características
            [entradas,saidas,labels] = features_extraction(dir_dados,dados,tipo(t),freq,col(cl),erro(f),k(i));        
            
            for c = 7% CLASSIFICADOR:
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
    %                 [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
    %                 Ytrain = Ytrain.';                             % transpõe matriz
    %                 Ytest = Ytest.';                               % transpõe matriz
    %                 Xtrain = Xtrain.';                             % transpõe matriz
    %                 Xtest = Xtest.';                               % transpõe matriz
    %                 Mdl = feedforwardnet(neuronios{f}, 'trainrp');                 % cria rede                
    %                 Mdl = configure(Mdl, Xtrain, Ytrain);          % configura
    %                 Mdl.trainParam.epochs = 150000;                 % muda n max de epocas
    %                 tic;
    %                 Mdl = train(Mdl,Xtrain,Ytrain, 'useParallel','yes'); %treino
    %                 toc;
    %                 Yestimado = Mdl(Xtest);                       % teste
    %                 close all
    %                 clc

                    % 5) ERRO
                    [resultado(n,:)] = calcula_acc_classif(Yestimado,Ytest);

                    % 6) Salva modelo
                    % Modelo (M), caracterísica (28), fold (1-5),grupo de
                    % classes (1,2 ou 4), classificador
    %                 arquivo_modelo = strcat(['M28-',classificador{c},'-g',num2str(col(cl)),'-',num2str(n)]); %
    %                 save(strcat(dir_modelos,arquivo_modelo),'Mdl')             

                    %clear Mdl
                    %disp(n)
                end
                toc
                %result = strcat(['R28-',classificador{c},'-g',num2str(col(cl)),'-n',num2str(neuronios{f})]); % 
                result = strcat(['R28-',classificador{c},'-g',num2str(col(cl)),'-e',num2str(erro(f)),'-k',num2str(k(i)),'.mat']); % 
                %result = strcat(['R28-',classificador{c},'-g',num2str(col(cl)),'-rp']); % 
                %arquivo_saida = strcat(['M',num2str(t),'_',classificador{1}]);
                save(strcat(dir_resultados,result),'resultado')%,'Yestimado','Ytest','Ztest')
                
                % 6) Salva modelo
                % Modelo (M), caracterísica (28), fold (1-5),grupo de
                % classes (1,2 ou 4), classificador
%                 modelo = strcat(['M28-',classificador{c},'-g',num2str(col(cl)),'-e',num2str(erro(f)),'-k',num2str(k(i)),'.mat']); %
%                 save(strcat(dir_modelos,modelo),'Mdl') 
            end

        end
    end
end
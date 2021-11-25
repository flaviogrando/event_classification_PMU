%%%%          CLASSIFICAÇÃO - Aplicação de modelo previamente treinado


% 1 - ajustar diretorios (no inicio) % PASTAS DE MODELOS
% 2 - ajustar nomes da saida (final)

clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parâmetro: Frequência do sistema
freqs = [49.95 49.96 49.97 49.98 49.99 50 50.01 50.02 50.03 50.04 50.05];
freqs = [49.95 49.96 49.97 49.98 49.99 50 50.01 50.02 50.03 50.04 50.05 49.5 49.6 49.7 49.8 49.9 50.1 50.2 50.3 50.4 50.5 45 46 47 48 49 51 52 53 54 55];
% Características:
tipo = 28;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Diretórios


dir_dados = 'C:\Users\LabA305 - 08\Google Drive\MATLAB\FINAIS\Dados\Eventos\DFT\';
dir_modelo = 'F:\MEGAsync\DADOS\Modelos\DFT\';
dir_resultado = 'F:\MEGAsync\DADOS\Resultados\freq_DFT_k2\';
%dir_classificador = 'C:\Users\flavi\Google Drive\MATLAB\FINAIS\Dados\Freq\FFT\';
classificador = {'knn', 'nb', 'tree', 'ensemble','svm','ann72','svm_c'}; %
col = [1 2 4];
erro = [0 0.025 0.05 0.1 0.25 0.5 0.75 1];
k = 2;

num_folds = 5; % só para separar minor e major

for e=1:length(erro)
    for f=1:length(freqs) % varre parâmetros
        for cl=1:length(col)
            
            % 1) CARREGA DADOS
            dados = strcat(['dados_',num2str(freqs(f)),'Hz.mat']); 
            % 2) SELECIONA CARATERÍSTICAS
            [entradas,saidas,labels] = features_extraction(dir_dados,dados,tipo,freqs(f),col(cl),erro(e),k(1)); 

            for c = [7]%1:length(classificador)

                % 1) CARREGA MODELO
                arquivo = strcat(['M28-',classificador{c},'-g',num2str(col(cl)),'-e',num2str(erro(e)),'-k2.mat']); 
                load(strcat(dir_modelo,arquivo)) % carrega modelo
                tic
                for n = 1:num_folds

                    disp([cl c n])  
                    % 1) Seleciona dados de teste e treino
                    [Xtest,Ytest,Ztest,Xtrain,Ytrain,Ztrain]=seleciona_dados(entradas,saidas,labels,n,num_folds); 

                    % 2) Embaralha padrões
                    [Xtrain,Ytrain,Ztrain] = embaralha_dados(Xtrain,Ytrain,Ztrain);
                    [Xtest,Ytest,Ztest] = embaralha_dados(Xtest,Ytest,Ztest);

                    % 3) PREDIÇÃO
                    %Yestimado = predict(Mdl, Xtest);
                    [Yestimado,Ytest] = predictor(Mdl,Xtest,Ytrain,Ytest,cl,c);

                    % 4) ERRO
                    [resultado(n,:)] = calcula_acc_classif(Yestimado,Ytest);

                end % end fold
                toc
                % Salva resultados
                result = strcat(['R28-',classificador{c},'-g',num2str(col(cl)),'-e',num2str(erro(e)),'-k2','-f',num2str(freqs(f)),'.mat']); %
                save(strcat(dir_resultado,result), 'resultado')%,'Yestimado','Ytest','Ztest')
            end % end classificador
        end % end grupo de classes
    end % frequências
end % erro

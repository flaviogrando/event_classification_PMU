%%%%          CLASSIFICA��O - Aplica��o de modelo previamente treinado


% 1 - ajustar diretorios (no inicio) % PASTAS DE MODELOS
% 2 - ajustar nomes da saida (final)

clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Par�metro: Frequ�ncia do sistema
%freqs = [49.95 49.96 49.97 49.98 49.99 50 50.01 50.02 50.03 50.04 50.05 49.5 49.6 49.7 49.8 49.9 50.1 50.2 50.3 50.4 50.5 45 46 47 48 49 51 52 53 54 55];
%freqs = [49.5 49.6 49.7 49.8 49.9 50 50.1 50.2 50.3 50.4 50.5];
freqs = [50];
% Caracter�sticas:
tipo = 28;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Diret�rios


dir_dados = 'C:\Users\EVERTON\Google Drive\MATLAB\FINAIS\Dados\Eventos\DFT_60dB\';
dir_modelo = 'C:\MEGAsync\DADOS\Modelos\DFT_60dB\';
dir_resultado = 'C:\MEGAsync\DADOS\Resultados\DFT_60dB_k2_desFE\';
%dir_classificador = 'C:\Users\flavi\Google Drive\MATLAB\FINAIS\Dados\Freq\FFT\';
classificador = {'knn', 'nb', 'tree', 'ensemble','svm','ann72', 'svm_c'}; %
col = [1 2 4];

erro = 0:0.5:10; % mHz
%erro = [1];
%k = [16 8 4 3 2 1.5 1 0.5 0];
%k = [2];
fMu = [2:0.1:5];



num_folds = 5; % s� para separar minor e major

for e=1:length(erro)
    %for f=1:length(freqs) % varre par�metros
    for i=1:length(fMu) % varre par�metros
        
        for cl = 2 %:length(col)
            
            % 1) CARREGA DADOS
            dados = strcat(['dados_50Hz.mat']); 
            % 2) SELECIONA CARATER�STICAS
            [entradas,saidas,labels] = features_extraction_desFE(dir_dados,dados,tipo,freqs(1),col(cl),erro(e),fMu(i)); 

            for c = [1 2 3 4 6 7]%1:length(classificador)

                % 1) CARREGA MODELO
                arquivo = strcat(['M28-',classificador{c},'-g',num2str(col(cl)),'-e',num2str(erro(e)),'-k2.mat']); 
                load(strcat(dir_modelo,arquivo)) % carrega modelo
                tic
                for n = 1:num_folds

                    disp([cl c n])  
                    % 1) Seleciona dados de teste e treino
                    [Xtest,Ytest,Ztest,Xtrain,Ytrain,Ztrain]=seleciona_dados(entradas,saidas,labels,n,num_folds); 

                    % 2) Embaralha padr�es
                    [Xtrain,Ytrain,Ztrain] = embaralha_dados(Xtrain,Ytrain,Ztrain);
                    [Xtest,Ytest,Ztest] = embaralha_dados(Xtest,Ytest,Ztest);

                    % 3) PREDI��O
                    %Yestimado = predict(Mdl, Xtest);
                    [Yestimado,Ytest] = predictor(Mdl,Xtest,Ytrain,Ytest,cl,c);

                    % 4) ERRO
                    [resultado(n,:)] = calcula_acc_classif(Yestimado,Ytest);

                end % end fold
                toc
                % Salva resultados
                result = strcat(['R28-',classificador{c},'-g',num2str(col(cl)),'-e',num2str(erro(e)),'-k2','-fMu',num2str(fMu(i)),'.mat']); %
                save(strcat(dir_resultado,result), 'resultado')%,'Yestimado','Ytest','Ztest')
            end % end classificador
        end % end grupo de classes
    end % frequ�ncias
end % erro

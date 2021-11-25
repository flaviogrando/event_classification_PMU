% CLASSIFICADORES 

function[Y_estimado,Ytest,Param,Mdl] = classifica_otimizacao(Xtrain,Ytrain,Xtest,Ytest,cl,c,Param)

switch c    % seleciona classificador
    case 1
        Mdl = fitcknn(Xtrain, Ytrain,'OptimizeHyperparameters','auto'); 
        Y_estimado = predict(Mdl, Xtest);                               
        close all
        clc
    case 2
        Mdl = fitcnb(Xtrain, Ytrain,'OptimizeHyperparameters','auto'); 
        Y_estimado = predict(Mdl, Xtest);                               
        close all
        clc
    case 3
        Mdl = fitctree(Xtrain, Ytrain,'OptimizeHyperparameters','auto');
        Y_estimado = predict(Mdl, Xtest);
        close all
        clc
    case 4
        Mdl = fitcensemble(Xtrain, Ytrain, 'OptimizeHyperparameters','auto');
        Y_estimado = predict(Mdl, Xtest);
        close all
        clc
    case 5
        [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
        [linhas,colunas] = size(Ytrain);
        for i=1:colunas% one-vs-all
            disp(i)           
            classe(i) = {strcat('SVM',num2str(i))}; % Define um campo para struct
            Mdl.(classe{i}) = fitcsvm(Xtrain, Ytrain(:,i),'KernelFunction','rbf','BoxConstraint',1,'KernelScale','auto')
            Y_estimado(:,i) = predict(Mdl.(classe{i}),Xtest); % teste
%             Param(i).BoxConstraints = Mdl.(classe{i}).BoxConstraints(1);
%             Param(i).KScale = Mdl.(classe{i}).KernelParameters.Scale;
        end
        close all
        clc
    case 6                    
        [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
        Ytrain = Ytrain.';                             % transpõe matriz
        Ytest = Ytest.';                               % transpõe matriz
        Xtrain = Xtrain.';                             % transpõe matriz
        Xtest = Xtest.';                               % transpõe matriz
        Mdl = fitnet(120, 'trainscg');                 % cria rede
        Mdl = configure(Mdl, Xtrain, Ytrain);          % configura
        Mdl.trainParam.epochs = 15000;                 % muda n max de epocas
        tic;
        Mdl = train(Mdl,Xtrain,Ytrain, 'useParallel','yes'); %treino
        toc;
        Y_estimado = Mdl(Xtest);                       % teste
        close all
        clc
    case 7
         ks = Param.KScale(cl);
%        [Y,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
%         [linhas,colunas] = size(Ytrain);
        Mdl = fitcecoc(Xtrain,Ytrain);
        Yestimado = predict(Mdl, Xtest);
    otherwise
        
end

% if n==4
%     % No último fold salva o modelo (para ser usado com outras freqs)
%     dir_modelo = 'C:\DADOS_ATP\Modelos\';
%     arquivo_modelo = strcat(['M28','-',num2str(cl),'-',num2str(c)]); % 
%     save(strcat(dir_modelo,arquivo_modelo),'Mdl','Param')
%     
% end
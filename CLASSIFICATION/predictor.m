% CLASSIFICADORES 

function[Yestimado,Ytest] = predictor(Mdl,Xtest,Ytrain,Ytest,cl,c)

num_classes = [4 8 62];



switch c    % seleciona classificador
    case 1
        Yestimado = predict(Mdl, Xtest);                               
    case 2
        Yestimado = predict(Mdl, Xtest);                               
    case 3
        Yestimado = predict(Mdl, Xtest);
    case 4
        Yestimado = predict(Mdl, Xtest);
    case 5
        [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
        [linhas,colunas] = size(Ytest);

        colunas = num_classes(cl);
        for i=1:colunas% one-vs-all
            disp(i)           
            classe(i) = {strcat('SVM',num2str(i))}; % Define um campo para struct
            Yestimado(:,i) = predict(Mdl.(classe{i}),Xtest); % teste
        end
        close all
        clc
    case 6
%         val = Param.ValChecks(cl);
        [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
        Ytrain = Ytrain.';                             % transpõe matriz
        Ytest = Ytest.';                               % transpõe matriz
%         Xtrain = Xtrain.';                             % transpõe matriz
        Xtest = Xtest.';                               % transpõe matriz
%         Mdl = patternnet(72, 'trainrp');                 % cria rede
% %         Mdl = feedforwardnet(120);
% %         Mdl.trainFcn = 'trainrp';
% %         Mdl.performFcn = 'crossentropy';
%         Mdl.trainParam.epochs = 150000;                 % muda n max de epocas
%         Mdl.trainParam.max_fail = 100;
%         Mdl = configure(Mdl, Xtrain, Ytrain);          % configura
%         tic;
%         Mdl = train(Mdl,Xtrain,Ytrain, 'useParallel','yes','useGPU','yes'); %treino
%         toc;
        Yestimado = Mdl(Xtest);                       % teste       
    case 7
%         ks = Param.KScale(cl);
%         options = statset('UseParallel',true);
%         t = templateSVM('Standardize',true,'KernelFunction','gaussian',...
%             'BoxConstraint',1,'KernelScale','auto');
%         Mdl = fitcecoc(Xtrain,Ytrain, 'Learners',t,'Coding','onevsall','Options',options);
        Yestimado = predict(Mdl, Xtest);
    otherwise
        
end


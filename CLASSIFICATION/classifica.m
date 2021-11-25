% CLASSIFICADORES 

function[Yestimado,Ytest,Mdl] = classifica(Xtrain,Ytrain,Xtest,Ytest,cl,c)

[Param] = param_classifica();

% Xtrain = zscore(Xtrain); % fica uma bosta
% Xtest = zscore(Xtest);

switch c    % seleciona classificador
    case 1
        dist = Param.Distance;       % seleciona distância
        nn = Param.NumNeighbors(cl); % num de vizinhos conforme grupo de classe
        Mdl = fitcknn(Xtrain, Ytrain,'Distance',dist,'NumNeighbors',nn); 
        Yestimado = predict(Mdl, Xtest);                               
        close all
        clc
    case 2
        dist = Param.DistributionNames; % tipo de distribuição
        for i=1:length(unique(Ytrain))
            prior(i) = Param.Prior(cl);% distribuiçao de prob conforme grupo de classes
        end
        Mdl = fitcnb(Xtrain, Ytrain,'DistributionNames',dist,'Prior',prior); 
        Yestimado = predict(Mdl, Xtest);                               
        close all
        clc
    case 3
        leaf = Param.TreeMinLeafSize;
        for i=1:length(unique(Ytrain))
            prior(i) = Param.Prior(cl);% distribuiçao de prob conforme grupo de classes
        end
        Mdl = fitctree(Xtrain, Ytrain,'MinLeafSize',leaf,'Prior',prior);
        Yestimado = predict(Mdl, Xtest);
        close all
        clc
    case 4
        Mdl = fitcensemble(Xtrain, Ytrain, 'Method','Bag');
        Yestimado = predict(Mdl, Xtest);
        close all
        clc
    case 5
        ks = Param.KScale(cl);
        [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
        [linhas,colunas] = size(Ytrain);
        for i=1:colunas% one-vs-all
            disp(i)           
            classe(i) = {strcat('SVM',num2str(i))}; % Define um campo para struct
            Mdl.(classe{i}) = fitcsvm(Xtrain, Ytrain(:,i),'KernelFunction','rbf',...
                'BoxConstraint',1,'KernelScale','auto');
            Yestimado(:,i) = predict(Mdl.(classe{i}),Xtest); % teste
        end
        close all
        clc
    case 6
        val = Param.ValChecks(cl);
        [Ytrain,Ytest] = map_saidas_binarias(Ytrain,Ytest); % Converte saídas 0101
        Ytrain = Ytrain.';                             % transpõe matriz
        Ytest = Ytest.';                               % transpõe matriz
        Xtrain = Xtrain.';                             % transpõe matriz
        Xtest = Xtest.';                               % transpõe matriz
        Mdl = patternnet(90, 'trainrp');                 % cria rede
        Mdl.trainParam.epochs = 150000;                 % muda n max de epocas
        Mdl.trainParam.max_fail = 100;
        Mdl = configure(Mdl, Xtrain, Ytrain);          % configura
        tic;
        Mdl = train(Mdl,Xtrain,Ytrain, 'useParallel','yes','useGPU','yes'); %treino
        toc;
        Yestimado = Mdl(Xtest);                       % teste
    case 7
        ks = Param.KScale(cl);
        options = statset('UseParallel',true);
        t = templateSVM('Standardize',true,'KernelFunction','gaussian',...
            'BoxConstraint',1,'KernelScale','auto');
        Mdl = fitcecoc(Xtrain,Ytrain, 'Learners',t,'Coding','onevsall','Options',options);
        Yestimado = predict(Mdl, Xtest);
    otherwise
        
end


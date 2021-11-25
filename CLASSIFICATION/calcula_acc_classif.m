


function [resultado] = calcula_acc_classif(Y_estimado,Y_teste)

% Obtém matrizes dos targets e outputs (conversão vetor123->matriz010)
% Para o calculo da matriz confusao
[num_inst, num_classes] = size(Y_teste);

if num_classes ==1 % testa se é vetor
    C = unique(Y_teste);
    num_classes = length(C); %output123 => maior valor é o numero de classes
    
    for i=1:num_classes
        I = find( Y_estimado(:,1) == C(i));    
        saidas_temp_estim(I,i) = 1;
        
        I = find( Y_teste(:,1) == C(i));    
        saidas_temp_test(I,i) = 1;
    end 
    Y_estimado = saidas_temp_estim.';
    Y_teste = saidas_temp_test.';
         
elseif num_inst > num_classes 
    Y_estimado = Y_estimado.';
    Y_teste = Y_teste.';
end

for i=1:num_inst
    [M,I] = max(Y_estimado(:,i));
    Y_estimado(I,i) = 1;
end

% RESULTADOS
[erro, cm, ind, per] = confusion(Y_teste,Y_estimado);

%plotconfusion(matrix_output_minor',matrix_fold_result')

resultado = {erro cm ind per}; % armazena resultado do fold  

end
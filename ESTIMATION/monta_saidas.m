



function [matriz_saida, matriz_labels]=monta_saidas(matriz_saida, matriz_labels, list_arq, n)

% 6 - MONTA DADOS DE SAÍDA

splited_case = strsplit(list_arq(n).name, {'E', 'Q', 'T', 'M','.'});

splited_case2 = strsplit(splited_case{3},{'N', 'C',});

evento = splited_case{2};
fase = splited_case{4};
mec = splited_case{5};
bus = splited_case2{2};

% tipo = strsplit(list_arq(n).name, {'T', 'M'});
% mec = strsplit(list_arq(n).name, {'M', '.'});


switch evento
    % 1º nível
    case 'F'  % FALTAS
        matriz_saida(n,1) = 1;
        
        % 2º nível
        if mec == 'N' % falta cond fechado
            matriz_saida(n,2) = 1;         
            [matriz_saida] = label_fases_falta(matriz_saida,n,fase);
                       
        elseif mec == 'S' % falta cond aberto
            matriz_saida(n,2) = 2;
            [matriz_saida] = label_fases_falta(matriz_saida,n,fase);
        end

    case 'SL'
        matriz_saida(n,1) = 2;
        matriz_saida(n,2) = 1;
        [matriz_saida] = label_fases_genericas(matriz_saida, n,fase);       
    case 'SG'
        matriz_saida(n,1) = 2;
        matriz_saida(n,2) = 2;
        [matriz_saida] = label_fases_genericas(matriz_saida, n,fase);
    % CAPACITORES
    case 'CL' % Capacit Loss
        matriz_saida(n,1) = 3;
        matriz_saida(n,2) = 1;
        [matriz_saida] = label_fases_genericas(matriz_saida, n,fase);
    case 'CG'
        matriz_saida(n,1) = 3;
        matriz_saida(n,2) = 2;
        [matriz_saida] = label_fases_genericas(matriz_saida, n,fase);
    % CARGAS
    case 'LL' % Load Loss
        matriz_saida(n,1) = 4;
        matriz_saida(n,2) = 1;
        [matriz_saida] = label_fases_genericas(matriz_saida, n,fase);
    case 'LG' % Load Gain
        matriz_saida(n,1) = 4;
        matriz_saida(n,2) = 2;
        [matriz_saida] = label_fases_genericas(matriz_saida, n,fase);
    otherwise
        disp('classe não encontrada')
end

matriz_labels(n,1) = list_arq(n).name;

end
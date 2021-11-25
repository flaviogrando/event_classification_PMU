

function [matriz_saida] = label_fases_cap(matriz_saida,n,bus,fase)

switch bus
    case '83'
        matriz_saida(n,3) = 1;
        if fase == 'A'
            matriz_saida(n,4) = 1;
        elseif fase == 'B'
            matriz_saida(n,4) = 2;
        elseif fase == 'C'
            matriz_saida(n,4) = 3;
        end
    case '88'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 1;
    case '90'
        matriz_saida(n,3) = 3;
        matriz_saida(n,4) = 2;
    case '92'
        matriz_saida(n,3) = 4;
        matriz_saida(n,4) = 3;
    otherwise
end
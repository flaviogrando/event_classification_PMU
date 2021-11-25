

function [matriz_saida] = label_fases_falta(matriz_saida, n,fase)

switch fase
    % MONOFÁSICAS
    case 'AG'
        matriz_saida(n,3) = 1;
        matriz_saida(n,4) = 1;
    case 'BG'
        matriz_saida(n,3) = 1;
        matriz_saida(n,4) = 2;
    case 'CG'
        matriz_saida(n,3) = 1;
        matriz_saida(n,4) = 3;
    % BIFÁSICAS    
    case 'ABG'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 1;
    case 'BCG'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 2;
    case 'CAG'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 3;
    case 'AB'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 4;
    case 'BC'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 5;
    case 'CA'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 6;
    % TRIFÁSICAS
    case 'ABCG'
        matriz_saida(n,3) = 3;
        matriz_saida(n,4) = 1;
    case 'ABC'
        matriz_saida(n,3) = 3;
        matriz_saida(n,4) = 1;
    otherwise
        disp('fase desconhecida')
end
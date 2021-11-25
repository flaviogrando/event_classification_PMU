

function [matriz_saida] = label_fases_genericas(matriz_saida, n,fase)

switch fase
    % MONOF�SICAS
    case 'A'
        matriz_saida(n,3) = 1;
        matriz_saida(n,4) = 1;
    case 'B'
        matriz_saida(n,3) = 1;
        matriz_saida(n,4) = 2;
    case 'C'
        matriz_saida(n,3) = 1;
        matriz_saida(n,4) = 3;
    % BIF�SICAS    
    case 'AB'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 1;
    case 'BC'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 2;
    case 'CA'
        matriz_saida(n,3) = 2;
        matriz_saida(n,4) = 3;
    % TRIF�SICAS
    case 'ABC'
        matriz_saida(n,3) = 3;
        matriz_saida(n,4) = 1;
    otherwise
        disp('fase desconhecida')
end
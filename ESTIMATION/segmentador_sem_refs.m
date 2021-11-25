%%%% SEGMENTAÇÃO DOS SINAIS (JANELAMENTO) %%%%%

% N - tamanho da janela (numero de amostras)
% m - deslocamento da janela (numero de amostras)
% Va, Vb, Vc - sinais trifásicos
% t - vetor de tempo
% refs - vetor de referências

function [Va_seg, Vb_seg, Vc_seg, t_seg] = segmentador_sem_refs(Va, Vb, Vc, t, N, m)


ciclos = [1 6];     % <<<<< para o pré e pós evento/falta


% % normalmente, N = 256 e m = 256 (passo de 1 ciclo)
% if m == 0
%     m=1;
% end
%
% %[num_canais,dim] = size(refs);              % tamanho total
% %num_canais = 3;
% dim = length(Va);
% num_wins = fix(dim/m);      % numero de janelas
% 
% % correção para o final do janelamento
% if m<N
%     limite = fix(N/m) - 1;
% else
%     limite = 0;
% end

% Va_seg = zeros(num_wins - limite ,N);
% Vb_seg = zeros(num_wins - limite ,N);
% Vc_seg = zeros(num_wins - limite ,N);
% t_seg = zeros(num_wins - limite ,N);

%ref_seg = zeros(num_canais,num_wins - limite);





%%% Segmentação do sinal (janelamento)
for i=1:length(ciclos)   
    inicio = (ciclos(i)-1)*m + 1;     % indice inicial da janela
    fim = inicio + N-1;               % indice final da janela
    Va_seg(i,:) = Va(inicio:fim);     % segmentação(uma janela/linha)
    Vb_seg(i,:) = Vb(inicio:fim);     
    Vc_seg(i,:) = Vc(inicio:fim);
    t_seg(i,:) = t(inicio:fim);      % vetor de tempos
    
%     % segmentação das referências (relativo ao instante inicial da janela)
%     for j=1:num_canais;
%         ref_seg(j,i) = refs(j,inicio);
%     end
end
    

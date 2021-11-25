
function [D] = diferenca_pre_pos(matriz_entrada)
% D = diferença
% M = magnitude
% A = angulo
% T = tensão
% C = corrente

% 1 = subestação
% 2 = inicio, nó 13
% 3 = distribuído, chaves
% 4 = distribuido, finais

[num_inst, N] = size(matriz_entrada);

% extrai diferença pré - pós 
mag = abs(matriz_entrada(:,1:N/2)) - abs(matriz_entrada(:,N/2+1:N));
ang = angle(matriz_entrada(:,1:N/2)) - angle(matriz_entrada(:,N/2+1:N));

% CORREÇÃO NOS LIMITESD DO ÂNGULO
pos_idx = ang>pi;        % identifica indices >pi
n_pi_idx = pos_idx*(-2*pi);    % matriz de -pi
neg_idx = ang<(-pi);     % identifica indices <pi
p_pi_idx = neg_idx*(2*pi);       % matriz de +pi
ang = ang + n_pi_idx + p_pi_idx;




D.MT1 = mag(:,16:18);                % 1
D.MT2 = mag(:,19:27);                % 13 
D.MT3 = [mag(:,19:27) mag(:,34:36)]; % chaves: 13,18,60,151
D.MT4 = [mag(:,28:30) mag(:,37:42)]; % finais: 95,197,250

D.MC1 = mag(:,13:15); 
D.MC2 = mag(:,1:3);
D.MC3 = mag(:,1:12);
D.MC4 = zeros(num_inst,1);

D.AT1 = ang(:,16:18);   
D.AT2 = ang(:,19:27);
D.AT3 = [ang(:,19:27) ang(:,34:36)];
D.AT4 = [ang(:,28:30) ang(:,37:42)];

D.AC1 = ang(:,13:15);
D.AC2 = ang(:,1:3);
D.AC3 = ang(:,1:12);
D.AC4 = zeros(num_inst,1);

end
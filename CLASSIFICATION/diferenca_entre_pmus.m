



function [D] = diferenca_entre_pmus(matriz_entrada, f)

[num_inst, N] = size(matriz_entrada);

% Carrega dados da PMU de referência = BARRA 1
% % Pré falta
% pre_Vmag_ref(:,:) = abs(matriz_entrada(:,16:18));
% pre_Vang_ref(:,:) = angle(matriz_entrada(:,16:18));
% pre_Imag_ref(:,:) = abs(matriz_entrada(:,13:15));
% pre_Iang_ref(:,:) = angle(matriz_entrada(:,13:15));
% % Pós falta
% pos_Vmag_ref(:,:) = abs(matriz_entrada(:,58:60));
% pos_Vang_ref(:,:) = angle(matriz_entrada(:,58:60));
% pos_Imag_ref(:,:) = abs(matriz_entrada(:,55:57));
% pos_Iang_ref(:,:) = angle(matriz_entrada(:,55:57));
% Pré falta
pre_Vmag_ref(:,:) = abs(matriz_entrada(:,1:3));
pre_Vang_ref(:,:) = angle(matriz_entrada(:,1:3));
pre_Imag_ref(:,:) = abs(matriz_entrada(:,25:27));
pre_Iang_ref(:,:) = angle(matriz_entrada(:,25:27));
% Pós falta
pos_Vmag_ref(:,:) = abs(matriz_entrada(:,40:42));
pos_Vang_ref(:,:) = angle(matriz_entrada(:,40:42));
pos_Imag_ref(:,:) = abs(matriz_entrada(:,64:66));
pos_Iang_ref(:,:) = angle(matriz_entrada(:,64:66));

% Extrai QUEDAS DE TENSÃO e ABERTURA ANGULAR
% TENSÕES
for i = 1:8 % 
    % Pré falta
    step = (i-1)*3 + 1;
    in = 0 + step;
    dif_Vmag_pre(:,step:step+2)= pre_Vmag_ref - abs(matriz_entrada(:,in:in+2));  % Vmag_pre
    dif_Vang_pre(:,step:step+2) = pre_Vang_ref - angle(matriz_entrada(:,in:in+2));% Vang_pre
    % Pós falta
    in = 39 + step;
    dif_Vmag_pos(:,step:step+2) = pos_Vmag_ref - abs(matriz_entrada(:,in:in+2));  % Vmag_pre
    dif_Vang_pos(:,step:step+2) = pos_Vang_ref - angle(matriz_entrada(:,in:in+2));% Vang_pos
end
% CORRENTES
for i = 1:5 % inclusive a de referência
    % Pré falta
    step = (i-1)*3 + 1;
    in = 24 + step;
    dif_Imag_pre(:,step:step+2) = pre_Imag_ref - abs(matriz_entrada(:,in:in+2));  % Imag_pre
    dif_Iang_pre(:,step:step+2) = pre_Iang_ref - angle(matriz_entrada(:,in:in+2));% Iang_pre
    % Pós falta
    in = 63 + step;
    dif_Imag_pos(:,step:step+2) = pos_Imag_ref - abs(matriz_entrada(:,in:in+2));  % Vmag_pos
    dif_Iang_pos(:,step:step+2) = pos_Iang_ref - angle(matriz_entrada(:,in:in+2));% Iang_pos
end

% Extrai diferença pré / pós falta
 
mag = [(dif_Imag_pre - dif_Imag_pos) (dif_Vmag_pre - dif_Vmag_pos)]; % diferença de queda de tensão
ang = [(dif_Iang_pre - dif_Iang_pos) (dif_Vang_pre - dif_Vang_pos)]; % diferença de abertura angular

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CORRIGE DIFERENÇA ANGULAR, SUBSTAINDO DESVIO DE ANG PELA FREQ
ang = ang + 2*pi*0.04*(f-50); % volta ângulo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CORREÇÃO NOS LIMITESD DO ÂNGULO
pos_idx = ang>pi;        % identifica indices >pi
n_pi_idx = pos_idx*(-2*pi);    % matriz de -pi
neg_idx = ang<(-pi);     % identifica indices <pi
p_pi_idx = neg_idx*(2*pi);       % matriz de +pi
ang = ang + n_pi_idx + p_pi_idx;

% carrega dados na struct
D.MT1 = mag(:,1:3);                % NULO (PMU1 - ela mesma)
D.MT2 = mag(:,4:6);                % 13 
D.MT3 = [mag(:,4:9) mag(:,13:15) mag(:,19:21)]; % chaves: 13,18,60,151
D.MT4 = [mag(:,10:12) mag(:,16:18) mag(:,22:24)]; % finais: 95,197,250

D.MC1 = mag(:,25:27);             % NULO (PMU1 - ela mesma)
D.MC2 = mag(:,28:30);
D.MC3 = mag(:,28:39);
D.MC4 = ones(num_inst,3);

D.AT1 = ang(:,1:3);               % NULO (PMU1 - ela mesma)
D.AT2 = ang(:,4:6);
D.AT3 = [ang(:,4:9) ang(:,13:15) ang(:,19:21)];
D.AT4 = [ang(:,10:12) ang(:,16:18) ang(:,22:24)];

D.AC1 = ang(:,25:27);             % NULO (PMU1 - ela mesma)
D.AC2 = ang(:,28:30);
D.AC3 = mag(:,28:39);
D.AC4 = ones(num_inst,3);


end
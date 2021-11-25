
function [D] = diferenca_pre_pos_freq_desTVE(matriz_entrada, f,erro,fMu)
% D = diferença
% M = magnitude
% A = angulo
% T = tensão
% C = corrente

% 1 = subestação
% 2 = inicio, nó 13
% 3 = distribuído, chaves
% 4 = distribuido, finais

[M, N] = size(matriz_entrada);

mag = abs(matriz_entrada);           % extrai magnitude
ang = angle(matriz_entrada);         % extrai angulo

% Vmag =[mag(1:24,1:12) mag(1:24,16:27)];
% figure, hold on, grid on
% mesh(Vmag)

% INSERE ERRO


% erro percentual
% vmrand = von mises distribution normalizada por pi = (-1 1)
variancia = erro*(vmrand(0,2,[M,N])/pi); %VARIÂNCIA FIXA K=2

% figure, hold on, grid on
% histogram(variancia,50)

% acrescenta nível de erro proporcional aos dados
mag = mag + mag.*((variancia/2)/100);  % metade do tve na magnitude 
ang = ang + 0.01*(variancia/2);    % 0.01 rad * erro


% ADICIONA DESLOCAMENTO
ang(:,N/2+1:N) = ang(:,N/2+1:N) + (fMu/100);    % 0.01 rad * erro



mag =  mag(:,N/2+1:N) - mag(:,1:N/2);
ang =  ang(:,N/2+1:N) - ang(:,1:N/2);

% extrai diferença pré - pós 
% mag = abs(matriz_entrada(:,1:N/2)) - abs(matriz_entrada(:,N/2+1:N));
% ang = angle(matriz_entrada(:,1:N/2)) - angle(matriz_entrada(:,N/2+1:N));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CORRIGE DIFERENÇA ANGULAR, SUBSTRAINDO DESVIO DE ANG PELA FREQ
ang = ang - 2*pi*0.1*(f-50); % volta ângulo t=0.1 = 5 ciclos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CORREÇÃO NOS LIMITESD DO ÂNGULO
pos_idx = ang>pi;        % identifica indices >pi
n_pi_idx = pos_idx*(-2*pi);    % matriz de -pi
neg_idx = ang<(-pi);     % identifica indices <pi
p_pi_idx = neg_idx*(2*pi);       % matriz de +pi
ang = ang + n_pi_idx + p_pi_idx;

% Normalização
mag(:,1:12) = mag(:,1:12)/max(max(mag(:,1:12)));    % mag da tensão
mag(:,13:15) = mag(:,13:15)/max(max(mag(:,13:15))); % mag da corrente
ang = ang/pi;                                       % angulos




D.MT1 = mag(:,1:3);                % 1
%D.MT2 = mag(:,4:6);                % 13 
%D.MT3 = [mag(:,4:9) mag(:,13:15) mag(:,19:21)]; % chaves: 13,18,60,151
D.MT4 = [mag(:,4:12)]; % finais: 95,197,250

D.MC1 = mag(:,13:15); 
%D.MC2 = mag(:,28:30);
%D.MC3 = mag(:,28:39);
% D.MC4 = ones(num_inst,3);

D.AT1 = ang(:,1:3);
%D.AT2 = ang(:,4:6);
%D.AT3 = [ang(:,4:9) ang(:,13:15) ang(:,19:21)];
D.AT4 = [ang(:,4:12)];

D.AC1 = ang(:,13:15);   
% D.AC2 = ang(:,28:30);
% D.AC3 = mag(:,28:39);
% D.AC4 = ones(num_inst,3);

end
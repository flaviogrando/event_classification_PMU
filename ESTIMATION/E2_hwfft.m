%%%%               ESTIMADOR COMPLETO - HW-FFT

% Retorna fasores  da componente fundamental

% 1 - Segmenta sinal (janelamento)
% 2 - Calcula fasores
% 3 - Calcula frequência
% 4 - Corrige amostragem
% 5 - Extrai componente fundamental (qndo necessário)

function [Fca, Fcb, Fcc] = E2_hwfft(Va, Vb, Vc, t, f0, freq)

% 1 - atualiza vetor de tempos
% 2 - segmenta sinal
% seleciona segmento do proximo ciclo

% aplica reamostragem
% calcula dft
% calcula frequencia
% calcula taxa de amostragem ideal
% atualiza vetor de tempos 

Fs = 1/(t(2)-t(1));
Ts = 1/Fs;

% h = 1; % numero de harmonicos (para estimador de freq)
% % Inicializa anguglos anteriores
% p0 = 0;
% p1 = deg2rad(-120);
% p2 = deg2rad(-120);


% 4 - SEGMENTA SINAL - 1 CICLO
N = 500;
m = 250;
[Va_seg, Vb_seg, Vc_seg, t_seg] = segmentador_sem_refs(Va, Vb, Vc, t, N, m);

[num_seg,N]=size(Va_seg);

Mclock = 210000000;
countsFs = Mclock/Fs;

freq_final = ones(num_seg,1)*freq;
freq_ant = freq;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aplicar uma primeira vez para carregar os "dados anteriores"

for i=1:num_seg
    
    
    
    counts = Mclock/(freq_final(i)*(N/2)); % calcula periodo de amostratem
    Tsr = Ts*(counts/countsFs);                   % Novo periodo de amostragem
    tsr = t_seg(i,1):Tsr:(N/2)*Tsr-Tsr+t_seg(i,1);  % vetor de tempos  novo
    
    newVa = interp1(t_seg(i,:),Va_seg(i,:),tsr, 'spline');  % Nova amostragem!
    newVb = interp1(t_seg(i,:),Vb_seg(i,:),tsr, 'spline');  % Nova amostragem!
    newVc = interp1(t_seg(i,:),Vc_seg(i,:),tsr, 'spline');  % Nova amostragem!
    
    
%     figure, hold on, grid on
%     stem(t_seg(i,:), Va_seg(i,:))
%     stem(tsr, newVa)
    
    % 5 - CÁLCULO FASORIAL - DFT
    Fs = 1/(tsr(2)-tsr(1));
    [Sa, Sb, Sc] = estimador_dft_complx(newVa, newVb, newVc, Fs, f0); 
    % 5.1 - Extrai somente comp fundamental pré e pós
    %bin = 2;
    
%     figure, hold on, grid on
%     plot(phia, 'o-')

%     [freq_final(i)] = estimador_freq_deriv_ang_Ain(phia(1,2), phib(1,2), phic(1,2), f0, h, p0, p1, p2);
%     % Aplica media movel na freq
%     %freq_final(i) = (freq_final(i)+freq_ant)/2;
%     % Atualiza dados "anteriores"
%     freq_ant = freq_final(i);
%     p0 = phia(1,2);
%     p1 = phib(1,2);
%     p2 = phic(1,2);
    
    % SELECIONA FASOR FUNDAMENTAL (TODOS OS CICLOS)
    Fca(i,1) = Sa(:,2);
    Fcb(i,1) = Sb(:,2);
    Fcc(i,1) = Sc(:,2);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure, hold on, grid on, plot(freq_final, 'o-')
% display(freq_final)

end
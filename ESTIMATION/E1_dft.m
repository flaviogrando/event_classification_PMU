%%%%               ESTIMADOR COMPLETO - DFT

% Retorna fasores  da componente fundamental

% 1 - Segmenta sinal (janelamento)
% 2 - Calcula fasores
% 3 - Extrai componente fundamental (qndo necessário)

function [Fca, Fcb, Fcc] = E1_dft(Va, Vb, Vc, t, f0)

Fs = 1/(t(2)-t(1));


% 2 - SEGMENTA SINAL - 1 CICLO POR SEGMENTO
N = 250;
m = 250;
[Va_seg, Vb_seg, Vc_seg, t_seg] = segmentador_sem_refs(Va, Vb, Vc, t, N, m);

% 3 - CÁLCULO FASORIAL - DFT
[Sa, Sb, Sc] = estimador_dft_complx(Va_seg, Vb_seg, Vc_seg, Fs, f0); 
% 5.1 - Extrai somente comp fundamental pré e pós
bin = 2;

% 4 - SELECIONA FASOR FUNDAMENTAL (TODOS OS CICLOS)
Fca = Sa(:,2);
Fcb = Sb(:,2);
Fcc = Sc(:,2);
end
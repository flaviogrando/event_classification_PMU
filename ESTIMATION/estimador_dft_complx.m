%%% ESTIMAÇÃO FASORIAL - DFT

% Vx_seg - Sinais trifásicos segmentados (janelas)
% Sf - Spectro de frequência
% Ax - Magnitudes (abs)
% phix - Ângulos (angle)


function [Sa, Sb, Sc] = estimador_dft_complx(Va_seg, Vb_seg, Vc_seg, Fs, f0)

[num_wins,win_size] = size(Va_seg);
gran = Fs/win_size/f0;       % granularidade
bin = round(1/gran)+1;       % local da componente fundamental no espectro

Sa = zeros(num_wins,win_size);
Sb = zeros(num_wins,win_size);
Sc = zeros(num_wins,win_size);

% Amp_a = zeros(num_wins,win_size);
% Amp_b = zeros(num_wins,win_size);
% Amp_c = zeros(num_wins,win_size);
% 
% phi_a = zeros(num_wins,win_size);
% phi_b = zeros(num_wins,win_size);
% phi_c = zeros(num_wins,win_size);


% janelamentos
window = rectwin(win_size);
%window = triang(win_size);


%%%% Aplica DFT - Cálculo dos fasores
for i=1:num_wins
    

    
    % aplica janela
    Va_seg(i,:) = Va_seg(i,:).*window';
    Vb_seg(i,:) = Vb_seg(i,:).*window';
    Vc_seg(i,:) = Vc_seg(i,:).*window';
    
    
    % espectro  
    Sa(i,:) = 2*fft(Va_seg(i,:))/sum(window);
    Sb(i,:) = 2*fft(Vb_seg(i,:))/sum(window);
    Sc(i,:) = 2*fft(Vc_seg(i,:))/sum(window);
%     % amplitudes
%     Amp_a(i,:) = abs(Sa(i,:));
%     Amp_b(i,:) = abs(Sb(i,:));
%     Amp_c(i,:) = abs(Sc(i,:));
%     % fases
%     phi_a(i,:) = (angle(Sa(i,:)));
%     phi_b(i,:) = (angle(Sb(i,:)));
%     phi_c(i,:) = (angle(Sc(i,:)));
    
end

% % SELECIONA A COMPONENTE FUNDAMENTAL <<<<<<<< USADO NO PRONY
% % amplitudes (fundamental)
% Aa(1,:) = Amp_a(:,bin)';   
% Ab(1,:) = Amp_b(:,bin)';
% Ac(1,:) = Amp_c(:,bin)';
% % fases (fundamental)
% phia(1,:) = phi_a(:,bin)';  
% phib(1,:) = phi_b(:,bin)';  
% phic(1,:) = phi_c(:,bin)';
% 
% % SELECIONA TODAS AS COMPONENTES <<<<<<<< USADO NO ESPARSO
% % amplitudes (fundamental)
% Aa = Amp_a;   
% Ab = Amp_b;
% Ac = Amp_c;
% % fases (fundamental)
% phia = phi_a;  
% phib = phi_b;  
% phic = phi_c;  

end
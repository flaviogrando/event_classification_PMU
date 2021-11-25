

function [matriz_saida] = label_fases_cargas(matriz_saida, n,barra)

    
spot_loads = [      
1	40	20	0	0	0	0
2	0	0	20	10	0	0
4	0	0	0	0	40	20
5	0	0	0	0	20	10
6	0	0	0	0	40	20
7	20	10	0	0	0	0
9	40	20	0	0	0	0
10	20	10	0	0	0	0
11	40	20	0	0	0	0
12	0	0	20	10	0	0
16	0	0	0	0	40	20
17	0	0	0	0	20	10
19	40	20	0	0	0	0
20	40	20	0	0	0	0
22	0	0	40	20	0	0
24	0	0	0	0	40	20
28	40	20	0	0	0	0
29	40	20	0	0	0	0
30	0	0	0	0	40	20
31	0	0	0	0	20	10
32	0	0	0	0	20	10
33	40	20	0	0	0	0
34	0	0	0	0	40	20
35	40	20	0	0	0	0
37	40	20	0	0	0	0
38	0	0	20	10	0	0
39	0	0	20	10	0	0
41	0	0	0	0	20	10
42	20	10	0	0	0	0
43	0	0	40	20	0	0
45	20	10	0	0	0	0
46	20	10	0	0	0	0
47	35	25	35	25	35	25
48	70	50	70	50	70	50
49	35	25	70	50	35	20
50	0	0	0	0	40	20
51	20	10	0	0	0	0
52	40	20	0	0	0	0
53	40	20	0	0	0	0
55	20	10	0	0	0	0
56	0	0	20	10	0	0
58	0	0	20	10	0	0
59	0	0	20	10	0	0
60	20	10	0	0	0	0
62	0	0	0	0	40	20
63	40	20	0	0	0	0
64	0	0	75	35	0	0
65	35	25	35	25	70	50
66	0	0	0	0	75	35
68	20	10	0	0	0	0
69	40	20	0	0	0	0
70	20	10	0	0	0	0
71	40	20	0	0	0	0
73	0	0	0	0	40	20
74	0	0	0	0	40	20
75	0	0	0	0	40	20
76	105	80	70	50	70	50
77	0	0	40	20	0	0
79	40	20	0	0	0	0
80	0	0	40	20	0	0
82	40	20	0	0	0	0
83	0	0	0	0	20	10
84	0	0	0	0	20	10
85	0	0	0	0	40	20
86	0	0	20	10	0	0
87	0	0	40	20	0	0
88	40	20	0	0	0	0
90	0	0	40	20	0	0
92	0	0	0	0	40	20
94	40	20	0	0	0	0
95	0	0	20	10	0	0
96	0	0	20	10	0	0
98	40	20	0	0	0	0
99	0	0	40	20	0	0
100	0	0	0	0	40	20
102	0	0	0	0	20	10
103	0	0	0	0	40	20
104	0	0	0	0	40	20
106	0	0	40	20	0	0
107	0	0	40	20	0	0
109	40	20	0	0	0	0
111	20	10	0	0	0	0
112	20	10	0	0	0	0
113	40	20	0	0	0	0
114	20	10	0	0	0	0];


linha = find(spot_loads(:,1) == str2num(barra)); % busca linha da matriz

loads = find(spot_loads(linha,2:7)); % busca elementos n�o nulos

num_fases = length(loads)/2; % numero de fases


% Classe: N�mero de fases (mono, bi ou tri)
matriz_saida(n,3) = num_fases;

% Classe: Fases A, B, C, AB, BC, AC ou ABC (7 classes)
if num_fases == 1
    matriz_saida(n,4) = max(loads)/2; % A, B ou C
elseif num_fases == 2
    if loads(2) == 2 % A + alguma coisa
            matriz_saida(n,4) = loads(4)/2;% sempre 4/2 ou 6/2 =>  AB ou AC        
    elseif loads(2) == 4 % BC
        matriz_saida(n,4) = 2; % BC
    end
elseif num_fases == 3
    matriz_saida(n,4) = 1; % ABC
end


end
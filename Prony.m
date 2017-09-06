%% Metodo di Prony (HOYW con osservazioni invece che con correlazione)

clear all;
close all;
clc;

%Ampiezza e fasi variano casualmente

M=3; %sinusoidi complesse in gioco
N=500*M; %numero di campioni dell'osservazione, in realt� senza rumore basterebbero
%2M osservazioni per identificare M sinusoidi complesse, e 4M osservazioni
%per sinusoidi reali; qua sovradetermino il problema in modo da avere gioco
%sul rumore nella risoluzione LS

%sign=1; %Potenza totale del rumore gaussiano circolare complesso
sign=25:-1:2; %Potenza totale del rumore gaussiano circolare complesso
Amp=25;
SNR=20*log10(Amp./sign);
Mitr=10;


%s=raylrnd(repmat(Amp,M,1)).*exp(1i*(2*pi)*rand(M,1)); %vettore ampiezze complesse
s=repmat(Amp,M,1);
%delle sinusoidi

%chiaramente devo definire pulsazioni normalizzate comprese tra -pi e pi
w1=pi/2;
w2=pi/4;
w3=pi*(2/3);

vere=[w2;w1;w3];
%matrice A(w)

A=[exp(-1i*w1*[0:N-1]') exp(-1i*w2*[0:N-1]') exp(-1i*w3*[0:N-1]')];

%osservazioni

%w_tot=zeros(M,1);
for gg=1:length(sign)
    
    clear X;
    clear x_v;

    x=(A*s)'+ (sqrt(sign(gg)/2))*(randn(1,N)+1i*randn(1,N)); %modello osservazioni con rumore

    gamma_inv=eye(N-M)*(1/sign(gg)); %matrice di covarianza di rumore 

    %costruisco la matrice delle osservazioni
    for i=1:N-M
        X(i,:)=x(M+(i-1):-1:i); %riempio una riga della matrice
        x_v(i)=x(M+i); %riempio un pezzo del vettore
    end

    %Determino il filtro con soluzione LS

    b=-(X'*gamma_inv*X)\X'*gamma_inv*x_v';

    %sequenza della quale voglio calcolare i poli (radici)
    b=[1;b];

    %Calcolo i poli
    rad_LS=roots(b);


    w_LS(:,gg)=abs(angle(rad_LS));
    w_LS(:,gg)=sort(w_LS(:,gg));
    
    
    
end

figure,plot(SNR,w_LS.^2 - repmat(vere,1,length(sign)).^2)


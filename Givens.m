%% Triangolarizzazione di una matrice via rotazioni di Givens

clear all;
close all;
clc;

N=20;
M=20;

A=randint(N,M,20);
A_tri=A;
%rango (a meno di colonne o righe linearmente dipendenti)
rang=min(N,M);

for j=1:1:(rang-1)
    for i=rang:-1:(j+1)
        Q=eye(rang);
        the=atan(A_tri(i,j)/A_tri(j,j));
        c=cos(the);
        s=sin(the);
        Q(j,j)=c;
        Q(i,j)=-s;
        Q(j,i)=s;
        Q(i,i)=c;
        A_tri=Q*A_tri;
    end
end

A_tri


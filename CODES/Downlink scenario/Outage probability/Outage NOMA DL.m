clear all
clc
%%NOMA system
%A MIMO(2-2) WITH 2 USERS SYSTEM, BS SEND A MASSAGE BY THE TOTAL RESOURSES
%AND DIFFERENT POWER TO EACH USER ... SIMPLY THE OUTAGE IS THE PERCENTAGE THAT
%THE USER DIDNOT ACHIVE THE REQUIRED SPEED. 
%parameters
N=1e4;
neededse=5;
%parameters
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B)+f);
G1 = 14; % transmit antina gain 14 dB
G2 = 14;
eta = 3.5;                    %Path loss exponent
d1=100;a1=0.2;
d2=300;a2=1-a1;
pt=-50:2:16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R1=[];
R2=[];
po=[];
po2=[];
for p = pt
oo=0;
oo2=0;
for j=1:N
% large scale fading
l1=-31-10*eta*log10(d1) - 8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2) - 8*randn(1,1); %path 2 budgate with shadowing
P1 = 10*log10(a1)+p+G1+l1; 
P2 = 10*log10(a2)+p+G2+l2;
int=10*log10(a1)+p+l2; % power of interfaerance signal
P1=db2pow(P1);
P2=db2pow(P2);
int=db2pow(int);
% small scale fading & calculating capasity
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ht=conj(transpose(h));
            ha=ht*h;
            R1(j)=log2(det(eye(2,2)+P1*(1/n/2).*ha));
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ht=conj(transpose(h));
            ha=ht*h;
            R2(j)=log2(det(eye(2,2)+(P2/(1+int)/n/2).*ha));
            pp1=mean(abs(R1(j)));
            if pp1<neededse
                oo=oo+1;
            end
            pp2=mean(abs(R2(j)));
            if pp2<neededse
                oo2=oo2+1;
            end
end
po=[po oo/N];
po2=[po2 oo2/N];
end
p=pt+30;
hold on
semilogy(p,po,'b--','LineWidth',1,'DisplayName','Near user (d=100 a=0.2)');
semilogy(p,po2,'r^','LineWidth',1,'DisplayName','Far user (d=300 a=0.8)');
legend('show')
xlim([min(p) max(p)])
xlabel('Transmitted power (dBm)')
ylabel('Outage probility')
grid on
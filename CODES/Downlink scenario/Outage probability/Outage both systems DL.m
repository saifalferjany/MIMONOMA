clear all
clc
%%Noma system
%parameters
N=1e3;
neededse=5;
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B)+f);
G1 = 14; % transmit antina gain 14 dB
G2 = 14;
eta = 3.5;                  %Path loss exponent
d1=100;a1=0.2;
d2=300;a2=1-a1;pt=-50:2:16;
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
l1=-31-10*eta*log10(d1) +G1 -8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2) +G2 -8*randn(1,1); %path 2 budgate with shadowing
P1 = 10*log10(a1)+p+l1; 
P2 = 10*log10(a2)+p+l2;
int=10*log10(a1)+p+l2; % power of interfaerance signal
P1=db2pow(P1);
P2=db2pow(P2);
int=db2pow(int);
% small scale fading & calculating capasity
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ha=h'*h;
            R1(j)=log2(det(eye(2,2)+P1*(1/n/2).*ha));
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ha=h'*h;
            R2(j)=log2(det(eye(2,2)+(P2/(1+int)/n/2).*ha));
            pp1=abs(R1(j));
            if pp1<neededse
                oo=oo+1;
            end
            pp2=abs(R2(j));
            if pp2<neededse
                oo2=oo2+1;
            end
end
po=[po oo/N];
po2=[po2 oo2/N];
end
poutnoma=(po+po2)/2;
figure
p=pt+30;
semilogy(p,poutnoma,'LineWidth',1,'DisplayName','mean outage probilty of 2UEs NOMA');
hold on
%%oma system
%parameters
n = db2pow(-204+10*log10(B/2)+f);
a1=0.5;
a2=1-a1;
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
l1=-31-10*eta*log10(d1) +G1 - 8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2) +G2- 8*randn(1,1); %path 2 budgate with shadowing
P1 = 10*log10(a1)+p+l1; 
P2 = 10*log10(a2)+p+l2;
P1=db2pow(P1);
P2=db2pow(P2);
%small scale fading % calulating capasity
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ha=h'*h;
            R1(j)=1/2*log2(det(eye(2,2)+P1*(1/n/2).*ha));
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ha=h'*h;
            R2(j)=1/2*log2(det(eye(2,2)+(P2/n/2).*ha));
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
hold on
poutoma=(po+po2)/2
p=pt+30;
semilogy(p,poutoma,'r--','LineWidth',1,'DisplayName','mean outage probilty of 2UEs OMA');
legend('show')
xlim([min(p) max(p)])
xlabel('Transmitted power (dBm)')
ylabel('Outage probility')
grid on
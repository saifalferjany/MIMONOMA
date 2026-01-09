clear all
clc
%%Noma system
%parameters
N=1e5;
pcir=30;
B=10*10^6;                %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B)+f); 
G1 = 14; % transmit antina gain 14 dB
G2 = 14;
eta = 3.5;                    %Path loss exponent
d1=100;a1=1;a2=1;
d2=500;
pt=-60:2:-10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=[];
count = 1;
for p = pt
for j=1:N
% large scale fading
l1=-31-10*eta*log10(d1) +G1-8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2) +G2-8*randn(1,1); %path 2 budgate with shadowing
P1 = 10*log10(a1)+p+l1; 
P2 = 10*log10(a2)+p+l2;
int=10*log10(a1)+p+l2; % power of interfaerance signal
P1=db2pow(P1);
P2=db2pow(P2);
int=db2pow(int);
% small scale fading & calculating capasity
          h=randn(2,2)+sqrt(-1)*randn(2,2);
            ha=h'*h;
            R1(j)=log2(det(eye(2,2)+(P1/(n*(1+int)*2)).*ha));
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ha=h'*h;
            R2(j)=log2(det(eye(2,2)+(P2/n/2.*ha)));
end
R = R1 + R2;
R=mean(real(R));
Rtnoma(count) = (R/2);
count = count + 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%OMA system
B = 10*10^6; %bandwidth Hz
n = db2pow(-204+10*log10(B/2)+f); %-150 dBw/Hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=[];
count = 1;
for p=pt
for j=1:N
%large scale fading
l1=-31-10*eta*log10(d1) +G1- 8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2) +G1- 8*randn(1,1); %path 2 budgate with shadowing
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
end
R = R1 + R2;
R=mean(real(R));
Rtoma(count) = (R/2);
count = count + 1;
end
figure
hold on
p=pt+30;
plinear=db2pow(p);
EENOMA=B*Rtnoma./(plinear+pcir);
EEOMA=B*Rtoma./(plinear+pcir);
plot(p,EEOMA,'r-.','LineWidth',1,'DisplayName','EE OMA');
plot(p,EENOMA,'b-','LineWidth',1,'DisplayName','EE Noma');
xlim([min(p) max(p)])
xlabel('Transmitted power (dBm)')
ylabel('Energy Efficency (bit/joule)')
legend('show')
grid on
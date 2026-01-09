clear all
clc
%%oma system
%parameters
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B/2)+f);
G1 = 14; % transmit antina gain 14 dB
G2 = 14;
f=9;
eta = 3.5;                    %Path loss exponent
d1=100;
d2=500;
pt=-60:2:-10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=[];
count = 1;
for p=pt
for j=1:10000
%large scale fading
l1=-31-10*eta*log10(d1) -8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2) -8*randn(1,1); %path 2 budgate with shadowing
P1 = p+l1+G1; 
P2 = p+l2+G2;
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
R1=mean(real(R1));
R2=mean(real(R2));
Ru1(count) = (R1);
Ru2(count) = (R2);
count = count + 1;
end
p=pt+30;
hold on
plot(p,Ru1,'r--','LineWidth',1,'DisplayName','Near user (d=100)');
plot(p,Ru2,'r-.','LineWidth',1,'DisplayName','Far user (d=500)');
xlim([min(p) max(p)])
xlabel('Transmitted power (dBm)')
ylabel('Spectrum effiecncy (b/s/Hz)')
legend('show')
grid on
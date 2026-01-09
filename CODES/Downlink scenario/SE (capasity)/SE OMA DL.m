clear all
clc
%%oma system
%%THE SCIENARIO
%A MIMO(2-2) WITH 2 USERS SYSTEM, BS SEND A MASSAGE BY THE HALF RESOURSES(DL RESOURSES) AND SAME POWER TO EACH UE THEN WE CALCULATE THE CHANEL
%EFFECT (SMALL (H) AND LARGE SCALE) 1000 TIMES AND WE USE 3GPP RELATION TO CALCULATE THE MAXIMAU SPEED PER Hz.
%parameters
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B/2)+f);
G1 = 14; % transmit antina gain 14 dB
G2 = 14;
eta = 3.5;                  %Path loss exponent
d1=100;a1=0.5;
d2=500;a2=1-a1;
pt=-46:2.5:16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=[];
count = 1;count = 1;
for p=pt
for j=1:1000
%large scale fading
l1=-31-10*eta*log10(d1)-8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2)-8*randn(1,1); %path 2 budgate with shadowing
P1 = 10*log10(a1)+p+G1+l1; 
P2 = 10*log10(a2)+p+G2+l2;
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
%figure
p=pt+30;
hold on
plot(p,Ru1,'b--','LineWidth',1,'DisplayName','near user(1) achivable rate in OMA (d=100)');
plot(p,Ru2,'r+','LineWidth',1,'DisplayName','far user(2) achivable rate in OMA (d=500)');
xlim([min(p) max(p)])
xlabel('Transmitted power (dBm)')
ylabel('Spectrum effiecncy (b/s/Hz)')
legend('show')
grid on
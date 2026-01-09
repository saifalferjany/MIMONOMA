clear all
clc
%%Noma system
%parameters
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B)+f);
G1 = 14; % transmit antina gain 14 dB
G2 = 14;
eta = 3.2;                    %Path loss exponent
d1=100;a1=0.2;
d2=500;a2=1-a1;
pt=-46:2.5:16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=[];
count = 1;
for p = pt
for j=1:1000
% large scale fading
l1=-31-10*eta*log10(d1) +G1 - 8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2) +G2 - 8*randn(1,1); %path 2 budgate with shadowing
P1 = 10*log10(a1)+p+l1; 
P2 = 10*log10(a2)+p+l2;
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
end
R = R1 + R2;
R=mean(real(R));
Rt(count) = (R/2);
count = count + 1;
end
figure
p=pt+30;
plot(p,Rt,'b','LineWidth',1,'DisplayName','mean achivable rate NOMA');
Rt(1)
xlim([min(p) max(p)])
xlabel('transmitted power (dBm)')
ylabel('spectrum effiecncy (b/s/Hz)')
legend('show')
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%oma system
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B/2)+f);
a1=0.5;
a2=1-a1;
pt=-46:2.5:16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=[];
count = 1;
for p=pt
for j=1:1000
%large scale fading
l1=-31-10*eta*log10(d1) +G1- 8*randn(1,1); % path budgate with shadowing
l2=-31-10*eta*log10(d2) +G2- 8*randn(1,1); %path 2 budgate with shadowing
P1 = 10*log10(a1)+p+l1; 
P2 = 10*log10(a2)+p+l2;
P1=db2pow(P1);
P2=db2pow(P2);
%small scale fading % calulating capasity
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ht=conj(transpose(h));
            ha=ht*h;
            R1(j)=1/2*log2(det(eye(2,2)+P1*(1/n/2).*ha));
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ht=conj(transpose(h));
            ha=ht*h;
            R2(j)=1/2*log2(det(eye(2,2)+(P2/n/2).*ha));
end
R = R1 + R2;
R=mean(real(R));
Rt(count) = (R/2);
count = count + 1;
end
hold on
Rt(1)
p=pt+30;
plot(p,Rt,'r-.','LineWidth',1,'DisplayName','mean achivable rate OMA');
legend('show')
grid on
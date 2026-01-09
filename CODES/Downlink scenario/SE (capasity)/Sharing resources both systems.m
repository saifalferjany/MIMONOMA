clear all
clc
%%THE SCIENARIO
%COMPAIRING THE MAXIMUM SPEED/Hz THAT BOTH SYSTEN CAN ARRIVE STARTING BY THE
%SYSTEM IS BY ONE UE UNTILL ARIVING THE SYSTEM IS CARING JUST BY THE OTHER
%%Noma system
%parameters
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B)+f);
G1 = 14; % transmit antina gain 14 dB
G2 = 14;
eta = 3.2;                    %Path loss exponent
d1=100;
d2=300;
p=-40;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count = 1;
for a1=0:0.1:1
    a2=1-a1;
for j=1:10000
% large scale fading
l1=-31-10*eta*log10(d1) +G1; % path budgate with shadowing
l2=-31-10*eta*log10(d2) +G2; %path 2 budgate with shadowing
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
R1=mean(real(R1));
R2=mean(real(R2));
Ru1(count) = (R1);
Ru2(count) = (R2);
count = count + 1;
end
figure
plot(Ru1,Ru2,'b','LineWidth',1,'DisplayName','NOMA UEs');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%oma system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=[];
count = 1;
for a1=0:0.1:1
    a2=1-a1
B1 =a1*10*10^6; %bandwidth Hz
n1=db2pow(-204+10*log10(B1)+f);
B2=a2*10*10^6;
n2=db2pow(-204+10*log10(B2)+f);
for j=1:10000
%large scale fading
l1=-31-10*eta*log10(d1) +G1;% path budgate with shadowing
l2=-31-10*eta*log10(d2) +G2;%path 2 budgate with shadowing
P1 = p+l1; 
P2 = p+l2;
P1=db2pow(P1);
P2=db2pow(P2);
%small scale fading % calulating capasity
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ht=conj(transpose(h));
            ha=ht*h;
            R1(j)=a1*log2(det(eye(2,2)+P1*(1/n/2).*ha));
            h=randn(2,2)+sqrt(-1)*randn(2,2);
            ht=conj(transpose(h));
            ha=ht*h;
            R2(j)=a2*log2(det(eye(2,2)+(P2/n/2).*ha));
end
R1=mean(real(R1));
R2=mean(real(R2));
Ru1(count) = (R1);
Ru2(count) = (R2);
count = count + 1;
end
grid on
hold on
plot(Ru1,Ru2,'r-.','LineWidth',1,'DisplayName','OMA UEs');
xlabel('USER 1 SE(b/s/Hz)')
ylabel('USER 2 SE(b/s/Hz)')
legend('show')
legend('show')
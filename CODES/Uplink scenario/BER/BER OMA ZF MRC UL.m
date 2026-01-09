clear all
clc
%%%OMA system
% 2 users each has 1 antenna will send signal to BS witch has 2 antenna
%
%parameters
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B/2)+9);
G1 =14;  % transmit antina1 gain 14 dB
G2 =14;  % transmit antina2 gain 14 dB
eta = 3.5; %Path loss exponent
d1=100;
d2=400;
pt=-60:2:-10;%%%%%%%%%%%%%%%db tran power
%%%%%%%%%%%%%%%%%%%%%%%%%%
num=10;
epoc=1e4;
%%%%%%%%%%%%%%%%%%user one information devided to two streams
inf1=randi([0 1],1,num);
x1= pskmod(inf1,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
inf2=randi([0 1],1,num);
x2= pskmod(inf2,2);
%%%%%%%%%%%%%%%%
BER1=[];
BER2=[];
% % % % BER3=[];
% % % % BER4=[];
BER5=[];
BER6=[];
for p=pt
    err1mrc=[];
    err2mrc=[];
% % % % %     err3mmse=[];
% % % % %     err4mmse=[];
    err5zf=[];
    err6zf=[];
     for j=1:1:epoc
        %%%%%%%%%%%%large scale fading
        l1=db2pow(31+10*eta*log10(d1)+8*randn(1,1)); % path budgate with shadowing
        l2=db2pow(31+10*eta*log10(d2)+8*randn(1,1)); %path 2 budgate with shadowing
        P1=db2pow(p+G1);
        P2 =db2pow(p+G2);
        %%%%%%%%%%%%%%%%%%%%%%%%snall scale fading
        h1=(randn(2,1)+sqrt(-1)*randn(2,1))/sqrt(2)/sqrt(l1);%h matrix for near user
        h2=(randn(2,1)+sqrt(-1)*randn(2,1))/sqrt(2)/sqrt(l2);%h matrix for far user
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%mrc
        %%%%%%%%%%% near user reciver
        noise=sqrt(n)*randn(2,num)/sqrt(2);
        y1=[sqrt(P1)*h1.*x1+noise];y2=[sqrt(P2)*h2.*x2+noise];
        %%%%%%55mmmrrrccc
        wmrc1=h1/norm(h1)^2;wmrc1=wmrc1';
        wmrc2=h2/norm(h2)^2;wmrc2=wmrc2';
        %%%%%%%%%sic
        m1mrc=pskdemod(real(wmrc1*y1),2);
        m2mrc=pskdemod(real(wmrc2*y2),2);
        %%%555
        %%%%%%%%%%% BERat
        err1mrc=[err1mrc sum(m1mrc~=inf1)];
        err2mrc=[err2mrc sum(m2mrc~=inf2)];
%%%%%%%555mmmmmmmmmmmmmmmsssssssssssssseeeeeeeeeeeeeeeeeeee
%%%%%%%%%%%
%%mmmmmmssssssseeeeee
% % % % % % % %         wmmse11=(h1p'*h1p+n*sqrt(int1))^-1*h1p';
% % % % % % % %         wmmse12=(h1i'*h1i+n*sqrt(P1))^-1*h1i';
% % % % % % % %         %%%%%%%%%sic
% % % % % % % %         m2at1mmse=pskdemod(real(wmmse12*y1),2);
% % % % % % % %         x21mmse=pskmod(m2at1mmse,2);
% % % % % % % %         ynew1mmse=y1-sqrt(int1)*h1i*x21mmse;
% % % % % % % %         m1mmse=pskdemod(real(wmmse11*ynew1mmse),2);
% % % % % % % %         %%%555
% % % % % % % %         wmmse2=((h2p'*h2p+n*eye(1,1))^-1)*h2p';
% % % % % % % %         m2mmse=pskdemod(real(wmmse2*y2),2);
% % % % % % % %         %%%%%%%%%%% BERat
% % % % % % % % % % % % % %         err3mmse = [err3mmse sum(m1mmse~=inf1)];
% % % % % %         err4mmse=[err4mmse sum(m2mmse~=inf2)];
% % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%zeroforce
  wzf1=((transpose(h1)*h1)^-1)*(transpose(h1));;
        wzf2=((transpose(h2)*h2)^-1)*(transpose(h2));
        %%%%%%%%%sic
        m1zf=pskdemod(real(wzf1*y1),2);
        m2zf=pskdemod(real(wzf2*y2),2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         wzf11=((transpose(h1p)*h1p)^-1)*(transpose(h1p));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         wzf12=((transpose(h1i)*h1i)^-1)*(transpose(h1i));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %%%%%%%%%sic
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         m2at1zf=pskdemod(real(wzf12*y1),2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         x21zf=pskmod(m2at1zf,2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         ynew1zf=y1-sqrt(int1)*h1i*x21zf;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         m1zf=pskdemod(real(wzf11*ynew1zf),2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %%%555
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         wzf2=((transpose(h2p)*h2p)^-1)*(transpose(h2p));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         m2zf=pskdemod(real(wzf2*y2),2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %%%%%%%%%%% BERat
        err5zf = [err5zf sum(m1zf~=inf1)];
        err6zf=[err6zf sum(m2zf~=inf2)];
       end
    BER1=[BER1 mean(err1mrc)/num];
    BER2=[BER2 mean(err2mrc)/num];
% % %     BER3=[BER3 mean(err3mmse)/num];
% % %     BER4=[BER4 mean(err4mmse)/num];
    BER5=[BER5 mean(err5zf)/num];
    BER6=[BER6 mean(err6zf)/num];
end
figure
semilogy(pt+30,BER1,'r-','LineWidth',1,'DisplayName','near user in OMA (MRC)')
hold on
semilogy(pt+30,BER2,'r--','LineWidth',1,'DisplayName','far user in OMA (MRC)')
% % % semilogy(pt+30,BER3,'k*','LineWidth',1,'DisplayName','mmse near ber3')
% % % semilogy(pt+30,BER4,'k+','LineWidth',1,'DisplayName','mmse far ber4')
% semilogy(pt+30,BER5,'ro','LineWidth',1,'DisplayName','near user with ZF receive')
% % semilogy(pt+30,BER6,'r^','LineWidth',1,'DisplayName','far user with ZF receive')
legend('show')
xlim([min(pt+30) max(pt+30)])
xlabel('Transmitted power (dBm)')
ylabel('Bit error rate')
grid on
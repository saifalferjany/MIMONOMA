clear all
clc
%%%OMA system
%%%%BS has 2 antennas ... antenna 1 will send signal of user 1 (x1) ... and the 
%%%oder antenna will send  signal for user2 (x2),,,,, near reciver U(1) has 2 antennas ,, so 
%%%there is h1 for reciver 1 (2*2) ,,,, a part of h1 is multiplexd by x1
%%%and a part will multiplex x2..
%,,,, NO INTERFARENCE BETWEEN UEsIN THIS OMA SYSTEM 

%parameters
B = 10*10^6; %bandwidth Hz
f=9;
n = db2pow(-204+10*log10(B/2));
G1 =14 ; % transmit antina gain 14 dB
G2 =14;  % transmit antina2 gain 14 dB
eta = 3.5;                    %Path loss exponent
d1=150;a1=0.5;
d2=400;a2=1-a1;
pt=-50:2:16;%%%%%%%%%%%%%%%db tran power
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
BER3=[];
BER4=[];
BER5=[];
BER6=[];
for p=pt
    err1=[];
    err2=[];
    err3=[];
    err4=[];
    err5=[];
    err6=[];
     for j=1:1:epoc
        %%%%%%%%%%%%large scale fading
        l1=db2pow(31+10*eta*log10(d1)-G1+f+8*randn(1,1)); % path budgate with shadowing
        l2=db2pow(31+10*eta*log10(d2)-G2+f+8*randn(1,1)); %path 2 budgate with shadowing
        P1=db2pow(10*log10(a1)+p);
        P2 =db2pow(10*log10(a2)+p);
        %%%%%%%%%%%%%%%%%%%%%%%%snall scale fading
        h1=(randn(2,2)+sqrt(-1)*randn(2,2))/sqrt(2)/sqrt(l1);%h matrix for near user
        h2=(randn(2,2)+sqrt(-1)*randn(2,2))/sqrt(2)/sqrt(l2);%h matrix for far user
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%mrc
        %%%%%%%%%%% near user reciver
        h1p=h1(:,1);
        h2p=h2(:,1);
        noise=sqrt(n)*randn(2,num)/sqrt(2);
        y1=[sqrt(P1)*h1p.*x1+noise];
        noise=sqrt(n)*randn(2,num)/sqrt(2);
        y2=[sqrt(P2)*h2p.*x2+noise];
        %%%%%%55
        wmrc1=h1p'/(h1p'*h1p);
        %%%%%%%%%
        m1=pskdemod(real(wmrc1*y1),2);
        %%%%%%%%%%5% far user reciver
        wmrc2=h2p'/(h2p'*h2p);
        m2=pskdemod(real(wmrc2*y2),2);
        %%%%%%%%%%% BERat

   err1 = [err1 sum(m1~=inf1)];
   err2=[err2 sum(m2~=inf2)];
%%%%%%%555mmmmmmmmmmmmmmmsssssssssssssseeeeeeeeeeeeeeeeeeee
%%%%%%%%%%%
%%%%%%%%%%%%%%5
% % % % % % % % % % % % % % % %         wmmse1=((h1p'*h1p+n*eye(1,1))^-1)*h1p';
% % % % % % % % % % % % % % % %         %%%%%%%%%
% % % % % % % % % % % % % % % %         m1=pskdemod(wmmse1*y1/sqrt(P1),2);
% % % % % % % % % % % % % % % %         %%%%%%%%%%5% far user reciver
% % % % % % % % % % % % % % % %         wmmse2=((h2p'*h2p+n*eye(1,1))^-1)*h2p';
% % % % % % % % % % % % % % % %         m2=pskdemod(wmmse2*y2,2);
% % % % % % % % % % % % % % % %         %%%%%%%%%%% BERat
% % % % % % % % % % % % % % % %    err3 = [err3 sum(m1~=inf1)];
% % % % % % % % % % % % % % % %    err4=[err4 sum(m2~=inf2)];
%%%%%%%%%%mle
% % % % % % % % % % %  nr=sqrt(n)*randn(1,1)/sqrt(2);
% % % % % % % % % % %  y1p=sqrt(P1)*h1p*pskmod(0,2)+nr;y1p=wmrc1*y1p;
% % % % % % % % % % %  y2p=sqrt(P1)*h1p*pskmod(1,2)+nr;y2p=wmrc1*y1p;
% % % % % % % % % % %  y1pr=abs(y1p-wmrc1*y1);
% % % % % % % % % % %  y2pr=abs(y2p-wmrc1*y1);
% % % % % % % % % % %  if (y1pr<y2pr)
% % % % % % % % % % %  m1=1;
% % % % % % % % % % %  elseif (y2pr<y1pr)
% % % % % % % % % % %  m1=0;
% % % % % % % % % % %  end 
% % % % % % % % % % %  %%%%%%%%%%%%%%%%far user
% % % % % % % % % % %  nr=sqrt(n)*randn(1,1)/sqrt(2);
% % % % % % % % % % %  y1p=pskmod(1,2)sqrt(P2)*h2p*pskmod(0,2)+nr;y1p=wmrc2*y1p;
% % % % % % % % % % %  y2p=pskmod(1,2);%y2p=sqrt(P2)*h2p*pskmod(1,2)+nr;y1p=wmrc2*y1p;
% % % % % % % % % % %  y1pr=abs(y1p-wmrc2*y2);
% % % % % % % % % % %  y2pr=abs(y2p-wmrc2*y2);
% % % % % % % % % % %  if (y1pr<y2pr)
% % % % % % % % % % %  m2=0;
% % % % % % % % % % % elseif (y2pr<y1pr)
% % % % % % % % % % %  m2=1;
% % % % % % % % % % %  end
% % % % % % % % % % % err3=[err3 sum(m1~=inf1)];
% % % % % % % % % % % err4=[err4 sum(m2~=inf2)];
% % % % % % % % % % %       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%zeroforce
       w0f1=((transpose(h1p)*h1p)^-1)*(transpose(h1p));
        %%%%%%%%%
        m1=pskdemod(w0f1*y1/sqrt(P1),2);
        w0f2=((transpose(h2p)*h2p)^-1)*(transpose(h2p));
        m2=pskdemod(w0f2*y2,2);
        %%%%%%%%%%% BERat
   err5 = [err5 sum(m1~=inf1)];
   err6=[err6 sum(m2~=inf2)];
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%5
%%%%%%%%%%%%%%%%%
    end
    BER1=[BER1 mean(err1)/num];
    BER2=[BER2 mean(err2)/num];
    BER3=[BER3 mean(err3)/num];
    BER4=[BER4 mean(err4)/num];
    BER5=[BER5 mean(err5)/num];
    BER6=[BER6 mean(err6)/num];
end
figure
semilogy(pt+30,BER1,'r-','LineWidth',1,'DisplayName','near user in OMA (MRC)')
hold on
semilogy(pt+30,BER2,'r--','LineWidth',1,'DisplayName','far user in OMA (MRC)')
% % % % semilogy(pt+30,BER3,'k*','LineWidth',1,'DisplayName','mmse near ber3')
% % % % % semilogy(pt+30,BER4,'k+','LineWidth',1,'DisplayName','mmse far ber4')
% semilogy(pt+30,BER5,'r*','LineWidth',1,'DisplayName','near user with ZF reciver')
% semilogy(pt+30,BER6,'r+','LineWidth',1,'DisplayName','far user with ZF reciver')
% legend('show')
% xlim([min(pt+30) max(pt+30)])
% xlabel('Transmitted power (dBm)')
% ylabel('Bit error rate')
% grid on
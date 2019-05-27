clear

%orizoume to sima eisodou
X=randi(255,210000,1);

%metatrepoume se diadiki tin seira mas
B=dec2bin(X,8);

%to M gia kodikopoiisi M-PAM 
M=[4 8];


for I=1:2
    clear PAM_SYMBOLS B2 out;
   
    %ta symbola M-PAM
   m=1:M(I);
   PAM_SYMBOLS=2*m-1-M(I);
    
   %typosi ton symbolwn
    figure(I);
    plot(PAM_SYMBOLS,'*');
    title(sprintf('%d-PAM',M(I)));
    axis([0 M(I)+1 -10 10])
    grid
   
    
    K=log2(M(I));
    
    %diaxorismos tis seiras se K bit
     
     k=1:length(B)/K;
     for j=1:K
         i=j:K:length(B);
         B2(k,j)=B(i);
     end
    %pairnoume ta symbola
     X2=bin2dec(B2);

     %metatropi se bin me vasi ton gray code
     G=bin2gray(X2,'pam',M(I));
     
     %i eisodos me symbola gray pia
    X_SYMBOLS=dec2bin(G',K);
      
    X_GRAY_SYMB=bin2dec(X_SYMBOLS);
   
    %to sima pia me ta symbola
    signal=PAM_SYMBOLS(X_GRAY_SYMB+1);
    

    %oi posotites tou SNR
    SNR=0:2:30;
    clear y y1 y2 y3 y4 y5
    for SNR_i=1:length(SNR)
  
        %ypodigmatolipsia tou simatos
        for i=1:length(signal)
           y((i-1)*4+1:4*i)=[signal(i) 0 0 0 ];   
        end

        % to filtro me tin rcosfir
         h1=rcosfir(0.3,3,4,1,'sqrt');
       %synelixi tou filtrou me to sima mas
      
       y1=conv(h1,y);
       y2=y1(13:length(y1)-12);  
       
         %to filtro tou mi idanikou kanaliou
         h2=[ 0.04 0 0 0 -0.05 0 0 0 0.07 0 0 0 -0.21 0 0 0 -0.5 0 0 0 0.72 0 0 0 0.36 0 0 0 0 0 0 0 0.21 0 0 0 0.03 0 0 0 0.07];
   
       y1=conv(h2,y2);
       y2=y1(21:length(y1)-20);   
        %telos mi ian

        %dimiourgia thorivou
        PS  = sum((real(y2).^2)+imag(y2).^2)/(length(y2));
        sigma  = PS/(10^(SNR(SNR_i)/10));
        noise= sqrt(sigma)*(randn(1,length(y2))+randn(1,length(y2))*1j)/sqrt(2);

           %prosthiki thorivou
        y3 = y2+noise;
        y4=conv(h1,y3);
        y5=y4(13:length(y4)-12);

        %perinoume tin exodo
        signal_out=y5(1:4:length(y5));

        %ypologizoume to sosto symbolo me vasi tin apostasi
        for i=1:length(signal_out)

             d=real(signal_out(i)-PAM_SYMBOLS).^2+imag(signal_out(i)-PAM_SYMBOLS).^2;
            [mn symbol_out]=min(d);
               out(i,:)=dec2bin(symbol_out-1,K);
   
        end
        
        %ypologizoume to BER kai SER
        BER(SNR_i)=(sum(X_SYMBOLS(:)~=out(:)))/length(out(:));  
        out_bin=bin2dec(out);
        out2=gray2bin(out_bin,'pam',M(I));
        SER(SNR_i)=sum(X2~=out2)/length(X2);
    
     end   

    %provoli grafimatwn
    if (I==1)
        figure(3)
        semilogy(SNR,BER,'g*-')
        hold
        figure(4)
        semilogy(SNR,SER,'g*-')
        hold
      
    end

    if (I==2)
        figure(3)
        semilogy(SNR,BER,'r*-')
        legend('4-PAM','8-PAM');
        title ('BER vs SNR');
        xlabel('SNR');
        ylabel('BER');
        hold
        figure(4)
        semilogy(SNR,SER,'r*-')
        legend('4-PAM','8-PAM');
        title ('SER ver SNR');
        xlabel('SNR');
        ylabel('SER');
        hold
       
    end

end


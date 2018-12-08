function [freq,amp]=main_func(x)

nfft = length(x); % Length of FFT
% Take fft, padding with zeros so that length(X)is equal to nfft
X = fft(x,nfft); 
% As FFT is symmetric, so second half can be removed.
lenth=round(nfft/2);
X = X(1:lenth);
% Take the magnitude of fft of x
mx = (abs(X))/lenth;
% Frequency vector
f = (0:lenth-1)*44100/nfft;

 [~,j]=min(-mx);
 
 
 funda=fund_freq(j,mx);
 funda2=diff_fund(j,mx);
 
 if(funda2==0)
     funda2=funda;
 end
 if(round(f(funda)/f(j))==1)
     funda=j;
 end

  factor=1;
  if(round(f(funda)/f(funda2))==1 )
     freq=f(funda);
     amp=1;
  else 
  freq=f(funda2);
  amp=1;
  end
  if(freq<100 && f(funda)>100)
      freq=f(funda);
  else
      if(freq<100 && f(funda)<100 && f(j)>100)
          freq=f(j);
      end
  end
  
 fprintf(freqtonote(freq));
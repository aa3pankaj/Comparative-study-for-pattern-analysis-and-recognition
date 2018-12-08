function ind=fund_freq(maxind,data)
ind=2;

while(ind<=maxind)
    if(data(ind)>(0.1)*(data(maxind)) && data(ind)>data(ind+1) && data(ind)>data(ind-1))
        break;
    end
    ind=ind+1;
end
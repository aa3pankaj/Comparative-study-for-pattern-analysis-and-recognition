function freq=diff_fund(maxind,data)
factor=50;
var=round(maxind/factor)+1;

index=maxind-var;left_index=0;
while(index>1)
    if(data(index)>(0.1)*(data(maxind)) && data(index)>data(index+1) && data(index)>data(index-1))
        break;
    end
    index=index-1;
end
if(index~=1)
    left_index=index;
end
index=maxind+var;right_index=0;
while(index<length(data) && index<2*maxind)
    if(data(index)>(0.1)*(data(maxind)) && data(index)>data(index+1) && data(index)>data(index-1))
        break;
    end
    index=index+1;
end
if(index~=length(data) && index<2*maxind)
    right_index=index;
end
    if(left_index~=0 && right_index~=0)
        
        if(round((right_index-maxind)/(maxind-left_index))==1)
            freq=right_index-left_index;
            freq=round(freq/2);
        else
            %fprintf('not found \n');
            freq=0;
        end
    
    else if(right_index~=0)
            freq=right_index-maxind;
        else if(left_index~=0)
                freq=maxind-left_index;
            else
            freq=maxind;
            end
        end
    end
    
       
input='soundk.wav';
z=audioread(input);

z=z(44100*5:44100*10);
%z=(z(:,1)+z(:,2))/2;
% points = timeout(z,44100);
[max_notes, min_notes]=tofindnoteduration(z);
note=1;factor=1;
zz=z*0;

while(note<=length(max_notes))
    fprintf('------------------------->note number %d \n',note);
    x=z(max_notes(note):min_notes(note));
    %points = timeout2(x,44100,note);
    points = timeout(x,44100);
    
     fprintf('haha');
%[max_notes, min_notes]=tofindnoteduration(z);
subnote=1;test=1;
start=1;
cons=10;
while(subnote<=length(points) )
    if(points(subnote)>length(x)-round(length(x)/cons))
        fprintf('huhu \n');
        break;
    end
    if(points(subnote)>round(length(x)/cons)  )
    fprintf(' ---> \n  subnote number %d \n',test);
    xx=x(start:points(subnote));
    fprintf('hehe \n');
     [freq,amp]=compile(xx,note,test);
    sin_note=artificial(length(xx),freq,amp,factor);
zz(max_notes(note)+start-1:max_notes(note)+points(subnote)-1)=sin_note;
  start=points(subnote)+1;
test=test+1;
    end
  subnote=subnote+1;
end
if(isempty(points)||subnote==1)
    start=1;
else
    %start=points(subnote-1);
end
if(start~=length(x))
    fprintf(' ---> \n  subnote number %d \n',test);
    xx=x(start:length(x));
    [freq,amp]=compile(xx,note,test);
    sin_note=artificial(length(xx),freq,amp,factor);
  zz(max_notes(note)+start-1:max_notes(note)+length(x)-1)=sin_note;
end
note=note+1;
end
sound(zz,44100);
output=strcat('art_',input);
audiowrite(output,zz,44100);
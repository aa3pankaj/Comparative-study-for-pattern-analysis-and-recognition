function [maxLen] = compare()

output1=getappdata(0,'output1');
output2=getappdata(0,'output2');

filename=getappdata(0,'file');
filename1=getappdata(0,'file1');

file=fopen(output1,'r');
file1=fopen(output2,'r');
%file1=fopen('sa1.txt','r');
str1= fscanf(file,'%s');
str2= fscanf(file1,'%s');

fclose(file);
fclose(file1);

%---- code for comparison using dynamic programming ----------%
       m = length(str1);
	   n = length(str2);
 
		dp=zeros(m,n);
 
		maxLen = -999999;
        suffixEnd = -1;
		for  i=2:m+1
			for j=2:n+1
				if str1(i-1) == str2(j-1)
					dp(i,j) = dp((i-1),(j-1)) + 1;      
                    
					  if dp(i,j) > maxLen 
						maxLen = dp(i,j);
						suffixEnd = i;
                      end
                else
			    dp(i,j) = 0;
		              
                end
            end
        end
 
        
        s=str1(suffixEnd-maxLen:suffixEnd-1);
       
        
output='C:\Users\Pankaj Singh\Documents\MATLAB\project_new\output_notes\';
        
output=strcat(output,strcat(filename,'-'));
output=strcat(strcat(output,filename1),'.txt');
        
setappdata(0,'output',output);
        
file2=fopen(output,'w');


fprintf(file2,'%s',s);

fclose(file2);


end


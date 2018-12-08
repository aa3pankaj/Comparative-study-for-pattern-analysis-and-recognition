function str= freqtonote(freq)
n = round(12*log(freq/260)/log(2));       % formula used to convert frequency to note number.
            switch mod(n,12)
                case 0
                    str = 'C '; 
                case 1
                    str = 'C# ';
                case 2 
                    str = 'D ';
                case 3 
                    str = 'D# ';
                case 4 
                    str = 'E';
                case 5 
                    str = 'F ';
                case 6 
                    str = 'F# ';
                case 7 
                    str = 'G ';
                case 8 
                    str = 'G# ';
                case 9 
                    str = 'A ';
                case 10 
                    str = 'A# ';
                case 11 
                    str = 'B ';
                otherwise
                    str='note not detected';
            end        


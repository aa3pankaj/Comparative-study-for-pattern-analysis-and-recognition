function varargout = project_final_layout(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_final_layout_OpeningFcn, ...
                   'gui_OutputFcn',  @project_final_layout_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before project_final_layout is made visible.
function project_final_layout_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project_final_layout (see VARARGIN)

% Choose default command line output for project_final_layout
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project_final_layout wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_final_layout_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in proceed_button.
function proceed_button_Callback(hObject, eventdata, handles)
% hObject    handle to proceed_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if(getappdata(0,'pathname')==0)
   pathname='C:\Users\Pankaj Singh\Documents\MATLAB\project_new\test audio\' ;
else
    pathname=getappdata(0,'pathname')
end

filename=get(handles.edit1,'String');
 
setappdata(0,'file',filename);

s =strcat(pathname,filename)
[y,fs]= audioread(s); %reads input audio file
y=(y(:,1)+y(:,2))/2;  % if input contains two streams

setappdata(0,'y',y);
setappdata(0,'fs',fs);

if pathname~=0
    set(handles.panel2,'visible','on');
end



set(handles.show_fs, 'String', fs);

cla(handles.plot,'reset');
%cla(handles.str,'reset');


%set(handles.freq_tip,'visible','off');
%set(handles.freq_tip,'Data',[]);


h = waitbar(0,'Please wait...');
points = timeout(y,fs);   %detects the points where there is a note change

note=2;factor=1;
zz=y*0;
str_prev='';
final=' ';

while(note<length(points))
     x=y(points(note):points(note+1)); %audio segment containing the note.
    
         
     [freq,amp]=main_func(x);  %stores the frequency and aplitutde calculated from discreate fourier analysis.
     
     
     s=freqtonote(freq);    %stores the note name returned by the function freqtonote().
     if(note~=2)
        str=strcat(',',s);
     else
        str=s;
     end
    
     if(~(strcmp(str_prev,s)))
        final=strcat(final,str);   
     end
str_prev=s;

note=note+1;
  
waitbar(note/length(points))
  
end

if(strcmp(final,' '))
    final='null';
end

output1='C:\Users\Pankaj Singh\Documents\MATLAB\project_new\output_notes\';

output1=strcat(output1,strcat(filename,'.txt'));
setappdata(0,'output1',output1);

fileID=fopen(output1,'w');
fprintf(fileID,'%s',final);
fclose(fileID);
close(h) 





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pathname=0;
setappdata(0,'pathname',pathname);


% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double





% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



[filename pathname]=uigetfile({'*.wav'},'file selector');


setappdata(0,'pathname',pathname);
setappdata(0,'fname',filename);
set(handles.edit1,'String',filename);









% --- Executes on button press in time_button.
function time_button_Callback(hObject, eventdata, handles)
% hObject    handle to time_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%fs=44100;
%y=(y(:,1)+y(:,2))/2;


%y=y(44100*5:44100*40);

%{
for k=1:length(y)
    m=y(k);
    
    if(abs(m)>0.03)
        
        while(abs(m)>0.02)
            
            newArray=newArray+m;
            
            m=y(k);
        end
        
        break;
        
    end
    
    
end
%}


y=getappdata(0,'y');
fs=getappdata(0,'fs');
t=linspace(0,length(y)/fs,length(y));
plot(t,y);
xlabel('time(sec)');
ylabel('Magnitude');




% --- Executes on button press in freq_button.
function freq_button_Callback(hObject, eventdata, handles)
% hObject    handle to freq_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=1024;
flag=1;
setappdata(0,'flag',flag);

y=getappdata(0,'y');
fs=getappdata(0,'fs');
%f=linspace(0,fs,n/2);
G=abs(fft(y,n));
f=(0:n/2-1)*fs/n;
plot(f,G(1:n/2));
xlabel('freq(Hz)');
ylabel('Magnitude');


%-------edited-----------------------------------------------------




%-----------------------------------------------------------------------

% --- Executes on button press in stft_button.
function stft_button_Callback(hObject, eventdata, handles)
% hObject    handle to stft_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  
 


%% Chroma Feature Analysis and Synthesis
%
% Chroma features are an interesting and powerful representation 
% for music audio in which the entire spectrum is projected onto 
% 12 bins representing the 12 distinct semitones (or chroma) of 
% the musical octave.  Since, in music, notes exactly one octave 
% apart are perceived as particularly similar, knowing the
% distribution of chroma even without the absolute frequency
% (i.e. the original octave) can give useful musical information
% about the audio -- and may even reveal perceived musical
% similarity that is not apparent in the original spectra.
%
% We provide several routines for calculating chroma
% representations from audio, as well as functions to do the
% reverse -- to synthesize audio from a chroma representation.
% Although mapping spectra to chroma loses information (since all
% octaves are mapped onto one another), it is still interesting to
% convert chroma back into an audio signal to hear a representation
% of what information has been preserved.  We use "Shepard Tones",
% which consist of a mixture of all sinusoids carrying a particular
% chroma, for resynthesis.

%% Chroma Analysis
% The main routine <chromagram_IF.m chromagram_IF> 
% operates much like a spectrogram, 
% taking an audio input and generating a sequence of short-time 
% chroma frames (as columns of the resulting matrix).
% chromagram_IF uses instantaneous frequency estimates from the
% spectrogram (extracted by <ifgram.m ifgram>, 
% and pruned by <ifptrack.m ifptrack>) to
% obtain high-resolution chroma profiles. (We also provide
% alternative implementations 
% <chromagram_E.m chromagram_E> 
% and <chromagram_P.m chromagram_P>, which
% use the simpler procedure of mapping each STFT bin directly to
% chroma, after selecting only spectral peaks in chromagram_P.  The
% mapping matrix is constructed by <fft2chromamx.m fft2chromamx>).
% Here, we read in a chromatic scale played on a piano and convert
% it to chroma:

% Read an audio waveform
d= getappdata(0,'y');
sr=getappdata(0,'fs');
% Calculate the chroma matrix.  Use a long FFT to discriminate
% spectral lines as well as possible (2048 is the default value)
cfftlen=2048;
C = chromagram_IF(d,sr,cfftlen);
% The frame advance is always one quarter of the FFT length.  Thus,
% the columns  of C are at timebase of fftlen/4/sr
tt = [1:size(C,2)]*cfftlen/4/sr;
% Plot spectrogram using a shorter window
%{
subplot(311)
sfftlen = 512;
specgram(d,sfftlen,sr);
% Always use a 60 dB colormap range
caxis(max(caxis)+[-60 0])
% .. and look only at the bottom 4 kHz of spectrum
axis([0 length(d)/sr 0 4000])
title('Original Sound')
% Now the chromagram, also on a dB magnitude scale
subplot(312)
%}
imagesc(tt,[1:12],20*log10(C+eps));
axis xy
caxis(max(caxis)+[-60 0])
title('Chromagram')
xlabel('time(sec)');
ylabel('C    C#    D    D#    E   F   F#   G   G#    A    A#   B');

%% Chroma Synthesis
% The chroma representation tells us the intensity of each of the 
% 12 distinct musical chroma of the octave at each time frame.  We
% can turn this back into an audio signal simply by using the 12
% chroma values to modulate 12 sinusoids, tuned to cover one
% octave.  However, that octave would be arbitrary, so instead, 
% in <chromasynth.m chromasynth>, 
% we use each chroma value to modulate an
% ensemble of sinusoids, with frequencies that are related by
% powers of two, all of which share the same chroma.  By applying a
% smooth rolloff to these sinusoids at high and low extremes of the
% spectrum, these tones carry chroma without a clear sense of
% octave.  They are known as "Shepard Tones" for Roger Shepard, the
% Stanford psychologist who first investigated their perceptual
% properties.  chromasynth.m relies on  
% <synthtrax.m synthtrax> to convert
% frequency/magnitude vector pairs into waveform. 

% chromsynth takes a chroma matrix as the first argument, the
% *period* (in seconds) corresponding to each time frame, and 
% the sampling rate for the waveform to be generated.

%{
x = chromsynth(C,cfftlen/4/sr,sr);
Plot this alongside the others to see how it differs
subplot(313)
specgram(x,sfftlen,sr);
caxis(max(caxis)+[-60 0])
axis([0 length(d)/sr 0 4000])
title('Shepard tone resynthesis')
 Of course, the main point is to listen to the resynthesis:
soundsc(x,sr);
wavwrite(x,sr,'piano-shepard.wav');
%}
%% Download
% You can download all the code and data for these examples here:
% <chroma-ansyn.tgz chroma-ansyn.tgz>.
%
% Last updated: $Date: 2007/04/21 14:03:14 $
% Dan Ellis <dpwe@ee.columbia.edu>










% --- Executes on button press in notes_button.
function notes_button_Callback(hObject, eventdata, handles)
% hObject    handle to notes_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
note_interface;



function str_Callback(hObject, eventdata, handles)
% hObject    handle to str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of str as text
%        str2double(get(hObject,'String')) returns contents of str as a double


% --- Executes during object creation, after setting all properties.
function str_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stft.
function stft_Callback(hObject, eventdata, handles)
% hObject    handle to stft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

d=getappdata(0,'y');
fs=44100;
sr=getappdata(0,'fs');
sfftlen = 512;

specgram(d,sfftlen,sr);

caxis(max(caxis)+[-60 0])

axis([0 length(d)/sr 0 4000])

title('Original Sound')


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

y=getappdata(0,'y');
Fs=getappdata(0,'fs');
wavplay(y,Fs,'async');
%snd = audioplayer(y, Fs);
%playblocking(snd);



% --- Executes on button press in speed.
function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


fs=getappdata(0,'fs');

fs=1.5*fs;
%fs=get(handles.slide,'Value');
setappdata(0,'fs',fs);





set(handles.show_fs, 'String', fs);



% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 clear playsnd
%wavplay(0,48000);

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in slow.
function slow_Callback(hObject, eventdata, handles)
% hObject    handle to slow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs=getappdata(0,'fs');

fs=fs/1.5;
setappdata(0,'fs',fs);



set(handles.show_fs, 'String', fs);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 y=getappdata(0,'y');
 fs=getappdata(0,'fs');
 filename=getappdata(0,'file');
 h = waitbar(0,'Please wait...');
 points = timeout(y,fs);

 note=2;factor=1;
 zz=y*0;
 str_prev='';
 final=' ';
while(note<length(points))
    x=y(points(note):points(note+1));
         
    [freq,amp]=main_func(x);
    s=freqtonote(freq);
    if(note~=2)
      str=strcat(',',s);
    else
        str=s;
    end
    
    if(~(strcmp(str_prev,s)))
      final=strcat(final,str);
    end
    str_prev=s;

    note=note+1;
  
    waitbar(note/length(points))
  
end

if(strcmp(final,' '))
    final='null';
end

output='C:\Users\Pankaj Singh\Documents\MATLAB\project_new\output_notes\';
output=strcat(output,strcat(num2str(fs),'_'));

output=strcat(output,strcat(filename,'.txt'))

setappdata(0,'output1',output);
fileID=fopen(output,'w');
 
fprintf(fileID,'%s',final);
fclose(fileID);
close(h) 








% --- Executes on slider movement.
function slide_Callback(hObject, eventdata, handles)
% hObject    handle to slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
fs=getappdata(0,'fs');

%fs=1.5*fs;
fs=get(handles.slide,'Value');
setappdata(0,'fs',fs);





set(handles.show_fs, 'String', fs);

% --- Executes during object creation, after setting all properties.
function slide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.




if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in compare_button.
function compare_button_Callback(hObject, eventdata, handles)
% hObject    handle to compare_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pankaj=getappdata(0,'pathname1')
if(getappdata(0,'pathname1')==0)
   hahah=0
pathname1='C:\Users\Pankaj Singh\Documents\MATLAB\project_new\test audio\' ;
else
    pathname1=getappdata(0,'pathname1')
end
pathname1

 filename1=get(handles.edit2,'String');
 filename1
setappdata(0,'file1',filename1);

s =strcat(pathname1,filename1)
[y1,fs1]= audioread(s);
y1=(y1(:,1)+y1(:,2))/2;
setappdata(0,'y1',y1);
setappdata(0,'fs1',fs1);








%cla(handles.str,'reset');


%set(handles.freq_tip,'visible','off');
%set(handles.freq_tip,'Data',[]);


h = waitbar(0,'Please wait...');
points = timeout(y1,fs1);

note=2;factor=1;
zz=y1*0;
str_prev='';
final=' ';
while(note<length(points))
    x=y1(points(note):points(note+1));
         
    [freq,amp]=main_func(x);
    s=freqtonote(freq);
    if(note~=2)
      str=strcat(',',s);
    else
        str=s;
    end
    
    if(~(strcmp(str_prev,s)))
       final=strcat(final,str);
    end
    str_prev=s;

    note=note+1;
  
    waitbar(note/length(points))
  
end
if(strcmp(final,' '))
    final='null';
end

output2='C:\Users\Pankaj Singh\Documents\MATLAB\project_new\output_notes\';

output2=strcat(output2,strcat(filename1,'.txt'));
setappdata(0,'output2',output2);


fileID=fopen(output2,'w');
fprintf(fileID,'%s',final);
fclose(fileID);
close(h) 


maxLen=compare();


compare_interface;


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
pathname1=0;
setappdata(0,'pathname1',pathname1);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filename1 pathname1]=uigetfile({'*.wav'},'file selector');


setappdata(0,'pathname1',pathname1);
setappdata(0,'fname1',filename1);
set(handles.edit2,'String',filename1);


% --- Executes during object creation, after setting all properties.
function show_fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=getappdata(0,'y1');
Fs1=getappdata(0,'fs1');
wavplay(y1,Fs1,'async');

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

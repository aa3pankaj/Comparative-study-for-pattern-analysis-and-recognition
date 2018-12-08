function varargout = note_interface(varargin)
% NOTE_INTERFACE MATLAB code for note_interface.fig
%      NOTE_INTERFACE, by itself, creates a new NOTE_INTERFACE or raises the existing
%      singleton*.
%
%      H = NOTE_INTERFACE returns the handle to a new NOTE_INTERFACE or the handle to
%      the existing singleton*.
%
%      NOTE_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOTE_INTERFACE.M with the given input arguments.
%
%      NOTE_INTERFACE('Property','Value',...) creates a new NOTE_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before note_interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to note_interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help note_interface

% Last Modified by GUIDE v2.5 10-Apr-2017 02:00:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @note_interface_OpeningFcn, ...
                   'gui_OutputFcn',  @note_interface_OutputFcn, ...
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


% --- Executes just before note_interface is made visible.
function note_interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to note_interface (see VARARGIN)

% Choose default command line output for note_interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes note_interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = note_interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


filename=getappdata(0,'output1');
file= fopen(filename,'r');

f=fscanf(file,'%s');


set ( hObject, 'String' ,f) 

%% Name: Harshini Gangapuram
%  Access ID: fr8393
%  Assignment: 3

%%
function varargout = assignment3(varargin)
% ASSIGNMENT3 MATLAB code for assignment3.fig
%      ASSIGNMENT3, by itself, creates a new ASSIGNMENT3 or raises the existing
%      singleton*.
%
%      H = ASSIGNMENT3 returns the handle to a new ASSIGNMENT3 or the handle to
%      the existing singleton*.
%
%      ASSIGNMENT3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGNMENT3.M with the given input arguments.
%
%      ASSIGNMENT3('Property','Value',...) creates a new ASSIGNMENT3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before assignment3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to assignment3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help assignment3

% Last Modified by GUIDE v2.5 13-Apr-2015 02:58:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @assignment3_OpeningFcn, ...
                   'gui_OutputFcn',  @assignment3_OutputFcn, ...
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


% --- Executes just before assignment3 is made visible.
function assignment3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to assignment3 (see VARARGIN)

% Choose default command line output for assignment3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes assignment3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = assignment3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%Loading Fixed Image and selecting the the desired points

% --- Executes on button press in fixed.
function fixed_Callback(hObject, eventdata, handles)
% hObject    handle to fixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im2 x1 y1
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
    end
im=imread(path);
im2=im;
handles.img1=im;
handles.fixedimage=imshow(im);
%Selecting points on the fixed image
[x1,y1]=ginput(4) %Without semicolon it displays the points we selected
%Updating handle structures
guidata(hObject, handles);



%% Loading Moving Image and selecting the desired points

% --- Executes on button press in moving.
function moving_Callback(hObject, eventdata, handles)
% hObject    handle to moving (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1 im3 x2 y2
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
    end
im1=imread(path);
im3=im1;
handles.img2=im3;
movingimage=imshow(im1);
%Selecting points on the moving image
[x2,y2]=ginput(4); %Without semicolon it displays the points we selected
%Updating handles structures
guidata(hObject, handles);


%% Optimising the image with the help of fminsearch

% --- Executes on button press in optimise.
function optimise_Callback(hObject, eventdata, handles)
% hObject    handle to optimise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Here we give initial guesses for s, theta, tx and ty and find the minimum
%error possible with the help of fminsearch in objective_function
%The values that q stores is the new values of fminsearch. We use those
%values and find the new transformation matrix.

global j
%Initial Guesses of s,theta,tx,ty
%I observed that with the change in the initial guesses my optimization is
%changing. I have try with different values of s, theta, tx and ty and
%ended up with these values
[parameters]=[94;0;2;-3];
%fminsearch of parameters
[q]=fminsearch('objective_function',[parameters])

%New translation matrix
tt=[1 0 q(3); 0 1 q(4); 0 0 1];

%New rotation matrix
tr=[cos(q(2)) sin(q(2)) 0; -sin(q(2)) cos(q(2)) 0; 0 0 1];

%New scaling matrix
ts=[q(1) 0 0; 0 q(1) 0; 0 0 1];

%New Transformation matrix and also displays new transformation matrix
t=ts*tr*tt

IM1=handles.img1; %Fixed image
IM2=handles.img2; %Moving image

%Assigning fixed image, moving image and transformation matrix into transformation image function
j=transform_image(IM1, t, IM2);

%Shows the final image
imshow(j)

%Updating handles structres
guidata(hObject, handles);


% --- Executes on button press in fix.
function fix_Callback(hObject, eventdata, handles)
% hObject    handle to fix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
imshow(im)

% --- Executes on button press in move.
function move_Callback(hObject, eventdata, handles)
% hObject    handle to move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1
imshow(im1)

% --- Executes on button press in opti.
function opti_Callback(hObject, eventdata, handles)
% hObject    handle to opti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global j
imshow(j)


function varargout = GUIAssignment(varargin)
% GUIASSIGNMENT MATLAB code for GUIAssignment.fig
%      GUIASSIGNMENT, by itself, creates a new GUIASSIGNMENT or raises the existing
%      singleton*.
%
%      H = GUIASSIGNMENT returns the handle to a new GUIASSIGNMENT or the handle to
%      the existing singleton*.
%
%      GUIASSIGNMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIASSIGNMENT.M with the given input arguments.
%
%      GUIASSIGNMENT('Property','Value',...) creates a new GUIASSIGNMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIAssignment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIAssignment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIAssignment

% Last Modified by GUIDE v2.5 03-Nov-2019 00:07:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIAssignment_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIAssignment_OutputFcn, ...
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


% --- Executes just before GUIAssignment is made visible.
function GUIAssignment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIAssignment (see VARARGIN)

% Choose default command line output for GUIAssignment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIAssignment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIAssignment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadImage.
function LoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path] = uigetfile({'*.jpg';'*.png';'*.bmp';'*.tif' });
fullFileName = fullfile(path, file);
A = imread(fullFileName);
axes(handles.axes1);
imshow(A);
axes(handles.axes2);
imshow(A);
setappdata(handles.axes1, 'img', A);
setappdata(handles.axes2, 'img2', A);


% --------------------DARKEN IMAGE-------------------------------
% --- Executes on button press in DarkenImage.
function DarkenImage_Callback(hObject, eventdata, handles)
% hObject    handle to DarkenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%B = getimage(handles.axes2);
B = getappdata(handles.axes2, 'img2');
B_adj = imdivide(B, 3.0);       %to darken the image
                                %B_adj =immultiply(img,0.5);
bw = im2uint8(roipoly(B)); 
bw_cmp = bitcmp(bw);    

roi = bitor(B_adj, bw_cmp);  
not_roi = bitor(B, bw);  
new_B = bitand(roi, not_roi); 

axes(handles.axes2);
imshow(new_B);
setappdata(handles.axes2, 'img2', new_B);


% --------------------BLUR IMAGE-------------------------------
% --- Executes on button press in BlurImage.
function BlurImage_Callback(hObject, eventdata, handles)
% hObject    handle to BlurImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%B = getappdata(handles.DarkenImage, 'img2');
B = getappdata(handles.axes2, 'img2');
H =fspecial('disk', 20);
blurred = imfilter(B, H);       %to blur the image
                                %also can use blurred = imgaussfilt(B,20);
bw = im2uint8(roipoly(B)); 
bw_cmp = bitcmp(bw);    

roi = bitor(blurred, bw_cmp);  
not_roi = bitor(B, bw);  
new_B = bitand(roi, not_roi); 

axes(handles.axes2);
imshow(new_B);
setappdata(handles.axes2, 'img2', new_B);


% --------------------SHARPEN IMAGE-------------------------------
% --- Executes on button press in SharpenImage.
function SharpenImage_Callback(hObject, eventdata, handles)
% hObject    handle to SharpenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%B = getappdata(handles.DarkenImage, 'img2');
B = getappdata(handles.axes2, 'img2');
sharpB = imsharpen(B);          %to sharp the image

bw = im2uint8(roipoly(B)); 
bw_cmp = bitcmp(bw);    

roi = bitor(sharpB, bw_cmp);  
not_roi = bitor(B, bw);  
new_B = bitand(roi, not_roi); 

axes(handles.axes2);
imshow(new_B);
setappdata(handles.axes2, 'img2', new_B);



% --------------------BRIGHTEN IMAGE-------------------------------
% --- Executes on button press in BrightenImage.
function BrightenImage_Callback(hObject, eventdata, handles)
% hObject    handle to BrightenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%B = getappdata(handles.DarkenImage, 'img2');
B = getappdata(handles.axes2, 'img2');
brightB = immultiply(B,1.5);        %to brighten the image
                                    %also can use brightB = imdivide(B,0.5);
bw = im2uint8(roipoly(B)); 
bw_cmp = bitcmp(bw);    

roi = bitor(brightB, bw_cmp);  
not_roi = bitor(B, bw);  
new_B = bitand(roi, not_roi); 

axes(handles.axes2);
imshow(new_B);
setappdata(handles.axes2, 'img2', new_B);


% --------------------SAVE IMAGE-------------------------------
% --- Executes on button press in SaveImage.
function SaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imsave(handles.axes2);

function varargout = GUI_NIT(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_NIT_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_NIT_OutputFcn, ...
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
function GUI_NIT_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = GUI_NIT_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
function load_image_Callback(~, ~, ~)
[filename, pathname] = uigetfile({' *.jpg';'*png';'*bmp';'Bir resim secin'});
    if isequal(filename,0) || isequal(pathname,0)
        
       warndlg('Lutfen bir resim seciniz!');
       
    else
       global c_image; 
      c_image=strcat(pathname,filename);     
      imshow(c_image);
      disp(c_image)
    
    end
function detect_ball_Callback(~, ~, handles)
global c_image;
detecting_image(c_image, handles);

function detecting_image(file_name, handles)
rgb = imread(file_name);
axes(handles.pick_image);
imshow(rgb)
d = imdistline;
delete(d);
gray_image = rgb2gray(rgb);
imshow(gray_image);
[centers, radii] = imfindcircles(rgb,[20 200],'ObjectPolarity','dark', ...
    'Sensitivity',0.9,'Method','twostage');
imshow(rgb);

h = viscircles(centers,radii);

function exit_button_Callback(~, ~, ~)
closereq();

function histogram_button_Callback(~, ~, handles)
global c_image;
I=imread(c_image);
I=rgb2gray(I);
imhist(I);
axes(handles.histogram_image);

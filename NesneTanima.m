function varargout = NesneTanima(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NesneTanima_OpeningFcn, ...
                   'gui_OutputFcn',  @NesneTanima_OutputFcn, ...
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

function NesneTanima_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
set(handles.histogrammed_ball,'Enable','off')
set(handles.detect_object,'Enable','off')
set(handles.pick_an_image_text, 'Visible', 'on')

function varargout = NesneTanima_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function load_image_Callback(~, ~, handles)
[filename, pathname] = uigetfile({'*.*';});
    if isequal(filename,0) || isequal(pathname,0)
       warndlg('Lutfen bir resim seciniz!')
    else
      global pickedImage
      pickedImage = strcat(pathname,filename);
      imshow(pickedImage, 'Parent', handles.pick_image)
      set(handles.histogrammed_ball,'Enable','on')
      set(handles.detect_object,'Enable','on')
      set(handles.pick_an_image_text, 'Visible', 'off')
    end

function detect_object_Callback(~, ~, handles)
global pickedImage
fprintf('resim secimi yapildi\n')
detecting_image(pickedImage, handles)

function detecting_image(file_name, ~)
fprintf('objeler tanimlaniyor\n')
rgb = imread(file_name);
figure('Name','Nesne Tanima','NumberTitle','off');
fprintf('resim acildi\n')
imshow(rgb)
d = imdistline;
delete(d)
gray_image = rgb2gray(rgb);
fprintf('resmin gri renk donusumu yapiliyor\n')
imshow(gray_image)
[centers, radii] = imfindcircles(rgb,[20 200],'ObjectPolarity','dark', ...
    'Sensitivity',0.9,'Method','twostage');
imshow(rgb)
fprintf('objeler tanimlandi\n')
h = viscircles(centers,radii);

function exit_button_Callback(~, ~, ~)
closereq();

function histogrammed_ball_Callback(~, ~, ~)
global pickedImage;
pureImage = imread(pickedImage);
figure('Name','Histogram Grafigi','NumberTitle','off');
imhist(pureImage)

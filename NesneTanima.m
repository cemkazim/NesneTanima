% Bu program bir Nesne Tanima uygulamasidir. Bu uygulama, Yapay Gorme ve Oruntu Tanimaya
% Giris dersinin final odevi icin Cem Kazim Genel tarafindan yazilmistir.

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
set(handles.histogrammed_image_button,'Enable','off')
set(handles.detect_object_button,'Enable','off')
set(handles.pick_an_image_text, 'Visible', 'on')

function varargout = NesneTanima_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function load_image_button_Callback(~, ~, handles)
global pickedImage
[filename, pathname] = uigetfile({'*.*';});
    if isequal(filename,0) || isequal(pathname,0)
       warndlg('bir resim secimi yapilmadi!')
    else
      pickedImage = strcat(pathname,filename);
      imshow(pickedImage, 'Parent', handles.pick_image)
      set(handles.histogrammed_image_button,'Enable','on')
      set(handles.detect_object_button,'Enable','on')
      set(handles.pick_an_image_text, 'Visible', 'off')
    end

function detect_object_button_Callback(~, ~, handles)
global pickedImage
detecting_image(pickedImage, handles)

function detecting_image(file_name, ~)
detectedImage = imread(file_name);
nnet = alexnet;
figure('Name', 'Tanimlanan Nesneler' ,'NumberTitle' ,'off');
image(detectedImage);
picture = imresize(detectedImage, [227,227]);
label = classify(nnet, picture);
title(upper(char(label)));

function exit_button_Callback(~, ~, ~)
closereq();

function histogrammed_image_button_Callback(~, ~, ~)
global pickedImage;
pureImage = imread(pickedImage);
figure('Name','Histogram Grafigi','NumberTitle','off');
imhist(pureImage)

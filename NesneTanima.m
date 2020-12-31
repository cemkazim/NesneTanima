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

function varargout = NesneTanima_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function load_image_Callback(~, ~, handles)
[filename, pathname] = uigetfile({' *.jpg';'*png';'*bmp';'Bir resim secin'});
    if isequal(filename,0) || isequal(pathname,0)
       warndlg('Lutfen bir resim seciniz!');
    else
       global pickedImage; 
      pickedImage = strcat(pathname,filename);
      imshow(pickedImage, 'Parent', handles.pick_image);
    end

function detect_ball_Callback(~, ~, handles)
global pickedImage;
detecting_image(pickedImage, handles);

function detecting_image(file_name, ~)
rgb = imread(file_name);
figure
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

function histogrammed_ball_Callback(~, ~, ~)
global pickedImage;
pureImage = imread(pickedImage);
workedImage = rgb2gray(pureImage);
figure
imhist(workedImage)

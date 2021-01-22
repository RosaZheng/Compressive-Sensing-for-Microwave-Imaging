function varargout = CS3(varargin)
% CS3 MATLAB code for CS3.fig
%      CS3, by itself, creates a new CS3 or raises the existing
%      singleton*.
%
%      H = CS3 returns the handle to a new CS3 or the handle to
%      the existing singleton*.
%
%      CS3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CS3.M with the given input arguments.
%
%      CS3('Property','Value',...) creates a new CS3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CS3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CS3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

%   (c) Zengli Yang 2011

% Edit the above text to modify the response to help CS3

% Last Modified by GUIDE v2.5 19-Jun-2011 15:54:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CS3_OpeningFcn, ...
                   'gui_OutputFcn',  @CS3_OutputFcn, ...
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


% --- Executes just before CS3 is made visible.
function CS3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CS3 (see VARARGIN)

% Choose default command line output for CS3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes CS3 wait for user response (see UIRESUME)
 %uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = CS3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.jpg;*.gif;*.tif;*.tiff');

if  filename~=0
    file=strcat(pathname,filename);
    cla(handles.axesLoad);cla(handles.axes1);
    cla(handles.axes2);cla(handles.axes3);
    axes(handles.axesLoad);
    img=imread(file);
    if size(img,3)~=1
        img=img(:,:,1);
    end
    handles.img=img;
    imshow(handles.img,[]);
    guidata(hObject,handles);
    set(handles.imgPanel,'Visible','on');
end


% --- Executes on button press in pushbuttonStart.
function pushbuttonStart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbuttonSAR2D,'String','2D SAR');
set(handles.waitText,'Visible','on');
pause(0.1);

addpath(strcat(pwd,'/utils'));

axes(handles.axesLoad);
if isreal(handles.img)
    imshow(handles.img,[]);
else
    imshow(abs(handles.img),[]);
end

handles.pctg1=str2double(get(handles.editPctg1,'String'))*0.01;
handles.pctg2=str2double(get(handles.editPctg2,'String'))*0.01;
handles.pctg3=str2double(get(handles.editPctg3,'String'))*0.01;

contents = cellstr(get(handles.popupXfm1,'String'));
handles.xfm1=contents{get(handles.popupXfm1,'Value')};
handles.xfm2=contents{get(handles.popupXfm2,'Value')};
handles.xfm3=contents{get(handles.popupXfm3,'Value')};

% obtain the block size for local DCT
contents = cellstr(get(handles.popupBlocksize,'String'));
param_input.blocksize=contents{get(handles.popupBlocksize,'Value')};
if ~strcmp(param_input.blocksize,'N/A')
    param_input.blocksize=str2double(param_input.blocksize);
else
    param_input.blocksize=size(handles.img,1);
end

% obtain the wavelet basis for wavelet
contents = cellstr(get(handles.popupBasis,'String'));
param_input.waveletBasis=contents{get(handles.popupBasis,'Value')};

% obtain the wavelet scale for wavelet
param_input.waveletScale=get(handles.popupScale,'Value')+1;

% obtain the threhsold for bandelet
param_input.tBand=str2double(get(handles.editTBand,'String'));
param_input.sBand=str2double(get(handles.editSBand,'String'));
param_input.maxNBand=str2double(get(handles.editMaxNBand,'String'));
param_input.Jmin=str2double(get(handles.editJmin,'String'));
param_input.single_qt=get(handles.checkboxSingleQT,'Value');

% obtain the parameter for 2D SAR
freq=44.56;
mu=2; % step size for x and y
z1=34; % 34mm, 65mm, 81mm
DN=size(handles.img);
k=2*pi*freq*1e9/3e11; % wavenumber
kx=linspace(-pi/mu,pi/mu,DN(1));
ky=linspace(-pi/mu,pi/mu,DN(2));
kz=zeros(DN);
for u=1:DN(1)
    for v=1:DN(2)
        kz(u,v)=sqrt(4*k*k-kx(u)*kx(u)-ky(v)*ky(v));
        if ~isreal(kz(u,v))
            kz(u,v)=0;
        end
    end
end
handles.kz_exp=exp(1i*kz*z1);
param_input.kz_exp=handles.kz_exp;

% obtain the sampling domain
param_input.saDomain=get(handles.popupSaDomain,'Value');

% obtain the parameter for CS3
param_input.xfmWeight=str2double(get(handles.editXfmWeight,'String'));
param_input.TVWeight=str2double(get(handles.editTVWeight,'String'));
param_input.Itnlim=str2double(get(handles.editItnlim,'String'));
param_input.maxN=str2double(get(handles.editMaxN,'String'));

P=str2double(get(handles.editP,'String'));  
% generally, 20 for variable density random sampling;
        % 100 for uniform density random sampling.

if isfield(handles,'img')
    if handles.pctg1>0 && handles.pctg1<=1 && ~strcmp(handles.xfm1,'N/A')
        if ~isfield(param_input,'mask')
            pdf = genPDF(size(handles.img),P,handles.pctg1,2,0,0);
            param_input.mask = genSampling(pdf,500,2);
        end
        [img_rec,pctg_rec]=perform_CS(handles.img,handles.xfm1,handles.pctg1,param_input);
        axes(handles.axes1);
        if isreal(img_rec)
            imshow(img_rec,[]);
        else
            imshow(abs(img_rec),[]);
        end
        pause(0.1);
        handles.img_rec1=img_rec;
        set(handles.editPctg1,'String',num2str(pctg_rec*100));
    end
    
    if handles.pctg2>0 && handles.pctg2<=1 && ~strcmp(handles.xfm2,'N/A')
        if ~isfield(param_input,'mask') || handles.pctg2~=handles.pctg1
            pdf = genPDF(size(handles.img),P,handles.pctg2,2,0,0);
            param_input.mask = genSampling(pdf,500,2);
        end
        [img_rec,pctg_rec]=perform_CS(handles.img,handles.xfm2,handles.pctg2,param_input);
        axes(handles.axes2);
        if isreal(img_rec)
            imshow(img_rec,[]);
        else
            imshow(abs(img_rec),[]);
        end
        pause(0.1);
        handles.img_rec2=img_rec;
        set(handles.editPctg2,'String',num2str(pctg_rec*100));
    end
    
    if handles.pctg3>0 && handles.pctg3<=1 && ~strcmp(handles.xfm3,'N/A')
        if ~isfield(param_input,'mask') || handles.pctg3~=handles.pctg1
            pdf = genPDF(size(handles.img),P,handles.pctg3,2,0,0);
            param_input.mask = genSampling(pdf,500,2);
        end        
        [img_rec,pctg_rec]=perform_CS(handles.img,handles.xfm3,handles.pctg3,param_input);
        axes(handles.axes3);
        if isreal(img_rec)
            imshow(img_rec,[]);
        else
            imshow(abs(img_rec),[]);
        end
        pause(0.1);
        handles.img_rec3=img_rec;
        set(handles.editPctg3,'String',num2str(pctg_rec*100));
    end
end
guidata(hObject,handles);
set(handles.waitText,'Visible','off');


function editPctg_Callback(hObject, eventdata, handles)
% hObject    handle to editPctg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPctg as text
%        str2double(get(hObject,'String')) returns contents of editPctg as a double
set(handles.editPctg1,'String',get(hObject,'String'));
set(handles.editPctg2,'String',get(hObject,'String'));
set(handles.editPctg3,'String',get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function editPctg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPctg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editPctg3_Callback(hObject, eventdata, handles)
% hObject    handle to editPctg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPctg3 as text
%        str2double(get(hObject,'String')) returns contents of editPctg3 as
%        a double

% --- Executes during object creation, after setting all properties.
function editPctg3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPctg3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editPctg2_Callback(hObject, eventdata, handles)
% hObject    handle to editPctg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPctg2 as text
%        str2double(get(hObject,'String')) returns contents of editPctg2 as a double
handles.pctg2=str2double(get(hObject,'String'))*0.01;

% --- Executes during object creation, after setting all properties.
function editPctg2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPctg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPctg1_Callback(hObject, eventdata, handles)
% hObject    handle to editPctg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPctg1 as text
%        str2double(get(hObject,'String')) returns contents of editPctg1 as
%        a double

% --- Executes during object creation, after setting all properties.
function editPctg1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPctg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupXfm3.
function popupXfm3_Callback(hObject, eventdata, handles)
% hObject    handle to popupXfm3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupXfm3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupXfm3

% --- Executes during object creation, after setting all properties.
function popupXfm3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupXfm3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupXfm2.
function popupXfm2_Callback(hObject, eventdata, handles)
% hObject    handle to popupXfm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupXfm2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupXfm2


% --- Executes during object creation, after setting all properties.
function popupXfm2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupXfm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupXfm1.
function popupXfm1_Callback(hObject, eventdata, handles)
% hObject    handle to popupXfm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupXfm1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupXfm1


% --- Executes during object creation, after setting all properties.
function popupXfm1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupXfm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTBand_Callback(hObject, eventdata, handles)
% hObject    handle to editTBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTBand as text
%        str2double(get(hObject,'String')) returns contents of editTBand as a double


% --- Executes during object creation, after setting all properties.
function editTBand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupBlocksize.
function popupBlocksize_Callback(hObject, eventdata, handles)
% hObject    handle to popupBlocksize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupBlocksize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupBlocksize


% --- Executes during object creation, after setting all properties.
function popupBlocksize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupBlocksize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupBasis.
function popupBasis_Callback(hObject, eventdata, handles)
% hObject    handle to popupBasis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupBasis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupBasis


% --- Executes during object creation, after setting all properties.
function popupBasis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupBasis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupScale.
function popupScale_Callback(hObject, eventdata, handles)
% hObject    handle to popupScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupScale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupScale


% --- Executes during object creation, after setting all properties.
function popupScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function LoadMATItem_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMATItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.mat');

if  filename~=0
    file=strcat(pathname,filename);
    cla(handles.axesLoad);cla(handles.axes1);
    cla(handles.axes2);cla(handles.axes3);
    axes(handles.axesLoad);
    img=importdata(file);
    if size(img,3)~=1
        img=img(:,:,1);
    end
    handles.img=img-mean(img(:));
    if isreal(img)
        imshow(handles.img,[]);
    else
        imshow(abs(handles.img),[]);
    end
    guidata(hObject,handles);
    set(handles.imgPanel,'Visible','on');
end


% --- Executes on button press in pushbuttonSAR2D.
function pushbuttonSAR2D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSAR2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

kz_exp = handles.kz_exp;

buttonSAR2D = get(hObject,'String');
if strcmp(buttonSAR2D,'2D SAR')
    issar = 1;
    set(hObject,'String','2D invSAR');
else
    issar = 0;
    set(hObject,'String','2D SAR');
end

cla(handles.axesLoad);cla(handles.axes1);
cla(handles.axes2);cla(handles.axes3);
if isfield(handles,'img') 
    
    axes(handles.axesLoad);
    if issar
        img=sar2d(handles.img,kz_exp);
    else
        img = handles.img;
    end
    imshow(abs(img),[]);
    
    if handles.pctg1>0 && handles.pctg1<=1 && ~strcmp(handles.xfm1,'N/A')
        axes(handles.axes1);
        if issar
            img=sar2d(handles.img_rec1,kz_exp);
        else
            img=handles.img_rec1;
        end
        imshow(abs(img),[]);
    end
    
    if handles.pctg2>0 && handles.pctg2<=1 && ~strcmp(handles.xfm2,'N/A')
        axes(handles.axes2);
        if issar
            img=sar2d(handles.img_rec2,kz_exp);
        else
            img=handles.img_rec2;
        end
        imshow(abs(img),[]);
    end
    
    if handles.pctg3>0 && handles.pctg3<=1 && ~strcmp(handles.xfm3,'N/A')
        axes(handles.axes3);
        if issar
            img=sar2d(handles.img_rec3,kz_exp);
        else
            img=handles.img_rec3;
        end
        imshow(abs(img),[]);
    end     
end

% --- Executes on selection change in popupSaDomain.
function popupSaDomain_Callback(hObject, eventdata, handles)
% hObject    handle to popupSaDomain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupSaDomain contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupSaDomain


% --- Executes during object creation, after setting all properties.
function popupSaDomain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupSaDomain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editXfmWeight_Callback(hObject, eventdata, handles)
% hObject    handle to editXfmWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXfmWeight as text
%        str2double(get(hObject,'String')) returns contents of editXfmWeight as a double


% --- Executes during object creation, after setting all properties.
function editXfmWeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXfmWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTVWeight_Callback(hObject, eventdata, handles)
% hObject    handle to editTVWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTVWeight as text
%        str2double(get(hObject,'String')) returns contents of editTVWeight as a double


% --- Executes during object creation, after setting all properties.
function editTVWeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTVWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editItnlim_Callback(hObject, eventdata, handles)
% hObject    handle to editItnlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editItnlim as text
%        str2double(get(hObject,'String')) returns contents of editItnlim as a double


% --- Executes during object creation, after setting all properties.
function editItnlim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editItnlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMaxN_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxN as text
%        str2double(get(hObject,'String')) returns contents of editMaxN as a double


% --- Executes during object creation, after setting all properties.
function editMaxN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editP_Callback(hObject, eventdata, handles)
% hObject    handle to editP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editP as text
%        str2double(get(hObject,'String')) returns contents of editP as a double


% --- Executes during object creation, after setting all properties.
function editP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMaxNBand_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxNBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxNBand as text
%        str2double(get(hObject,'String')) returns contents of editMaxNBand as a double


% --- Executes during object creation, after setting all properties.
function editMaxNBand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxNBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editJmin_Callback(hObject, eventdata, handles)
% hObject    handle to editJmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editJmin as text
%        str2double(get(hObject,'String')) returns contents of editJmin as a double


% --- Executes during object creation, after setting all properties.
function editJmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editJmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkboxSingleQT.
function checkboxSingleQT_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSingleQT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSingleQT



function editSBand_Callback(hObject, eventdata, handles)
% hObject    handle to editSBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSBand as text
%        str2double(get(hObject,'String')) returns contents of editSBand as a double


% --- Executes during object creation, after setting all properties.
function editSBand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSBand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

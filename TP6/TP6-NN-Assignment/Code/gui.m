function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 10-Dec-2018 15:15:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


function [handles] = define_network(handles)
% define the structure of the network
handles.Sigmas = {'sigmoid', 'sigmoid', 'sigmoid', 'sigmoid'};
handles.Layers = {2, 5, 5, 5, 4};

handles.SigmasView = handles.Sigmas;
handles.LayersView = handles.Layers;

handles.initialize = 'random';
handles.CostFunction = 'LogLoss';
handles.BatchSize = 100;
handles.LearningRate = 0.3;


function [handles] = set_output_layer(handles)
switch handles.Sigmas{end}
    case 'sigmoid'
        handles.Layers{end} = 1;
    case 'softmax'
        handles.Layers{end} = length(unique(handles.Y));
end
handles = init_and_plot(handles);


function [handles] = set_layer_size(layer, lsize, handles)
handles.SigmasViews{layer} = lsize;


function [handles] = set_activation(layer, actFunction, handles)
handles.Sigmas{layer} = actFunction;
handles = init_and_plot(handles);


function [handles] = init_network(handles)
handles.CtrainPlot = [];
handles.CtestPlot = [];
% create and initialize the network
handles.Network = MyNeuralNetwork(handles.Layers, handles.Sigmas);
initialize_weights(handles.Network, handles.initialize)

function [handles] = reset_dataset(handles)
[handles.X, handles.Y, handles.Xtrain, handles.Ytrain, handles.Xtest, handles.Ytest] = split_dataset(handles.dataset);
handles = set_output_layer(handles);
switch handles.Sigmas{end}
    case 'sigmoid'
        handles.Ytrain = handles.Ytrain-1;
        handles.Ytest = handles.Ytest-1;
    case 'softmax'
        handles.Ytrain = ind2vec(handles.Ytrain);
        handles.Ytest = ind2vec(handles.Ytest);
end

function plot_network(handles)
rotate = rotate3d;
rotate.enable = 'on';

Net = handles.Network;
Layers = handles.Layers;
dotsize = 15;
scatter(handles.input, handles.X(1,:), handles.X(2,:), dotsize, handles.Y(1,:));
setAllowAxesRotate(rotate, handles.input, false);

% feed the network with a meshgrid
maxTrain = max(handles.X, [], 2);
minTrain = min(handles.X, [], 2);
xplot = linspace(minTrain(1), maxTrain(1), 400)';
yplot = linspace(minTrain(2), maxTrain(2), 400)';
[Xs, Ys] = meshgrid(xplot,yplot);
X = [Xs(:), Ys(:)]';
handles.Network.feedforward(X);
osize = size(Xs);

for l=2:length(Layers)-1
    for i=1:Layers{l}
        a = Net.plot_activation(l, i, osize);
        h = handles.(strcat('a', num2str(l-1), num2str(i)));
        s = surf(h, Xs, Ys, a);
        set(s,'LineStyle','none')
        colormap(h,winter)
    end
end
            
% plot the output layer
for i=1:Layers{end}
    a = Net.plot_activation(length(Layers), i, osize);
    h = handles.(strcat('o', num2str(i)));
    contourf(h, Xs, Ys, a)
    setAllowAxesRotate(rotate, h, false);
end
% plot the cost functions
plot(handles.ctrain, handles.CtrainPlot)
plot(handles.ctest, handles.CtestPlot)
setAllowAxesRotate(rotate, handles.ctest, false);
setAllowAxesRotate(rotate, handles.ctrain, false);


function handles = init_and_plot(handles)
arrayfun(@cla,findall(0,'type','axes'))
handles = init_network(handles);
plot_network(handles);


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

clc
addpath(genpath("../utils"))

% Choose default command line output for gui
handles.output = hObject;

handles = define_network(handles);
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function [X, Y, Xtrain, Ytrain, Xtest,Ytest] = split_dataset(dataset)
switch dataset
    case 'halfkernel'
        data = halfkernel();
    case 'clusterincluster'
        data = clusterincluster();
    case 'corners'
        data = corners();
    case 'outlier'
        data = outlier();
    case 'twospirals'
        data = twospirals();
    case 'crescentfullmoon'
        data = crescentfullmoon();
end
X = data(:,1:2)';
Y = (data(:,3) + 1)';
% define training and test sets
[Xtrain, Ytrain, Xtest, Ytest] = split_data(X, Y, 0.5);


% --- Executes on selection change in ldataset.
function ldataset_Callback(hObject, eventdata, handles)
% hObject    handle to ldataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
contents = cellstr(get(hObject,'String'));
dataset = contents{get(hObject,'Value')};
handles.dataset = dataset;
handles = reset_dataset(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ldataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ldataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lactivation1.
function lactivation1_Callback(hObject, eventdata, handles)
% hObject    handle to lactivation1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
actFunction = contents{get(hObject,'Value')};
handles = set_activation(1, actFunction, handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lactivation1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lactivation1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lactivation2.
function lactivation2_Callback(hObject, eventdata, handles)
% hObject    handle to lactivation2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
actFunction = contents{get(hObject,'Value')};
handles = set_activation(2, actFunction, handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lactivation2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lactivation2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lactivation3.
function lactivation3_Callback(hObject, eventdata, handles)
% hObject    handle to lactivation3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lactivation3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lactivation3
contents = cellstr(get(hObject,'String'));
actFunction = contents{get(hObject,'Value')};
handles = set_activation(3, actFunction, handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lactivation3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lactivation3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in breset.
function breset_Callback(hObject, eventdata, handles)
% hObject    handle to breset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = init_and_plot(handles);
guidata(hObject, handles);


% --- Executes on button press in breset.
function btrain_Callback(hObject, eventdata, handles)
% hObject    handle to breset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
while get(hObject,'Value')
    [Ctrain, Ctest] = handles.Network.train(handles.Xtrain, handles.Ytrain, handles.Xtest, handles.Ytest,...
                                            100, handles.BatchSize, handles.LearningRate, handles.CostFunction);
    handles.CtrainPlot = [handles.CtrainPlot; Ctrain];
    handles.CtestPlot = [handles.CtestPlot; Ctest];
    plot_network(handles)

    % compute the accuracies
    YHatTrain = handles.Network.feedforward(handles.Xtrain);
    YHatTrain = vec2ind(YHatTrain >= (1/handles.Layers{end}));
    accTrain = my_accuracy(vec2ind(handles.Ytrain), YHatTrain);

    YHatTest = handles.Network.feedforward(handles.Xtest);
    YHatTest = vec2ind(YHatTest >= (1/handles.Layers{end}));
    accTest = my_accuracy(vec2ind(handles.Ytest), YHatTest);
    guidata(hObject, handles);
    drawnow()
end


function lrate_Callback(hObject, eventdata, handles)
% hObject    handle to lrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LearningRate = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function bsize_Callback(hObject, eventdata, handles)
% hObject    handle to bsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.BatchSize = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lsize1_Callback(hObject, eventdata, handles)
% hObject    handle to lsize1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lsize = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function lsize1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsize1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lsize2_Callback(hObject, eventdata, handles)
% hObject    handle to lsize2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lsize = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function lsize2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsize2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lsize3_Callback(hObject, eventdata, handles)
% hObject    handle to lsize3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lsize = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function lsize3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lsize3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in loutput.
function loutput_Callback(hObject, eventdata, handles)
% hObject    handle to loutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
lastLayer = strsplit(contents{get(hObject,'Value')}, '-');
handles.Sigmas{end} = lastLayer{1};
handles.CostFunction = lastLayer{2};
handles = reset_dataset(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function loutput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in normalize.
function normalize_Callback(hObject, eventdata, handles)
% hObject    handle to normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalize


% --- Executes on selection change in linit.
function linit_Callback(hObject, eventdata, handles)
% hObject    handle to linit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.initialize = contents{get(hObject,'Value')};
handles = init_and_plot(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function linit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

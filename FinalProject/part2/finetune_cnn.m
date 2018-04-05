function [net, info, expdir] = finetune_cnn(varargin)

%% Define options


% run(fullfile(fileparts(mfilename('fullpath')), ...
%   '..', '..', '..', 'matlab', 'vl_setupnn.m')) ;

% I had to change the above lines into what is below make it work.
run(fullfile(fileparts(mfilename('fullpath')), ...
  'matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

opts.train.gpus = [1];



%% update model

net = update_model();

%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB() ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end
end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB()
% -------------------------------------------------------------------------
% Prepare the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};


%% TODO: Implement your loop here, to create the data structure described in the assignment
directory = '..\Caltech4\ImageData'
subdirectories = dir(directory);
data = [];
sets = [];
labels = [];

for i = 3:length(subdirectories)
    subdirectory = subdirectories(i).name;
    class = round((i - 2) / 2); % numerical translation to class index.
    set = mod(i, 2) + 1; % numerical translation to set index.
    
    strcat(directory, '\', subdirectory, '\*.jpg');
    images = dir(strcat(directory, '\', subdirectory, '\*.jpg'));
    
    for j = 1:length(images)
        fullfileName = fullfile(directory, subdirectory, images(j).name);
        image = im2single(imread(fullfileName));
        % Concatenate grayscale images to obtain 3 channels.
        if size(image, 3) == 1
            image = cat(3, image, image, image);
        end
        image_resized = imresize(image, [32 32]);
        data = cat(4, data, image_resized);
    end
    % Add the labels and sets corresponding to the subdirectory.
    sets = [sets, ones(1, j) * set];
    labels = [labels, ones(1, j) * class];
end

%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = data ;
imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);
end

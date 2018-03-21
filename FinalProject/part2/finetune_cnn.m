function [net, info, expdir] = finetune_cnn(varargin)

%% Define options
% run(fullfile(fileparts(mfilename('fullpath')), ...
%     '..', '..', '..', 'matlab', 'vl_setupnn.m')) ;

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



%% Update model
net = update_model();

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
% Preapre the imdb structure, returns image data with mean image subtracted

% initialize structs
imdb = struct;
imdb.images = struct;
imdb.meta = struct;

% define class names and execution phases
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

% reading files
prefix = '../Caltech4/ImageData/';
airplane_train_paths = read_lines('../Caltech4/ImageSets/airplanes_train.txt', prefix);
airplane_test_paths = read_lines('../Caltech4/ImageSets/airplanes_test.txt', prefix);
motorbike_train_paths = read_lines('../Caltech4/ImageSets/motorbikes_train.txt', prefix);
motorbike_test_paths = read_lines('../Caltech4/ImageSets/motorbikes_test.txt', prefix);
face_train_paths = read_lines('../Caltech4/ImageSets/faces_train.txt', prefix);
face_test_paths = read_lines('../Caltech4/ImageSets/faces_test.txt', prefix);
cars_train_paths = read_lines('../Caltech4/ImageSets/cars_train.txt', prefix);
cars_test_paths = read_lines('../Caltech4/ImageSets/cars_test.txt', prefix);

% aggregate paths
train_paths = [airplane_train_paths; cars_train_paths; face_train_paths; motorbike_train_paths];
test_paths = [airplane_test_paths; cars_test_paths; face_test_paths; motorbike_test_paths ];

% conveniency variables
n_images = length(train_paths) + length(test_paths);
n_classes = length(classes);

% allocate memory
imdb.images.data = zeros(32, 32, 3, n_images);
imdb.images.labels = zeros(1, n_images);
imdb.images.set = zeros(1, n_images);

% resize images
train_images = vl_imreadjpeg(train_paths, 'Resize', [32, 32]);

for i = 1:length(train_paths)
    
    img = train_images{i};
    
    % if image is grayscale image, replicate channel 3 times
    if size(img, 3) == 1 
        img = repmat(img, 1, 1, 3);
    end
    
    % store image
    imdb.images.data(:,:,:,i) = img;
    
    % assign label based on file path
    for l = 1:n_classes
        if strfind(train_paths{i}, classes{l}) > 1
            imdb.images.labels(i) = l;
            break;
        end
    end
    
    % set training flag (1)
    imdb.images.set(i) = 1;
end


% resize images
test_images = vl_imreadjpeg(test_paths, 'Resize', [32, 32]);

for i = 1:length(test_paths)
    
    img = test_images{i};
    
    % if image is grayscale image, replicate channel 3 times
    if size(img, 3) == 1 
        img = repmat(img, 1, 1, 3);
    end
    
    % store image
    imdb.images.data(:,:,:, i + length(train_paths)) = img;
    
    % assign label based on file path
    for l = 1:length(classes)
        if strfind(test_paths{i}, classes{l}) > 1
            imdb.images.labels(i + length(train_paths)) = l;
            break;
        end
    end
    
    % set testing flag (2)
    imdb.images.set(i + length(train_paths)) = 2;
end

% subtract mean
dataMean = mean(imdb.images.data(:, :, :, imdb.images.sets == 1), 4);
data = bsxfun(@minus, imdb.images.data, dataMean);

imdb.images.data = data ;
% imdb.images.labels = single(classes);
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end

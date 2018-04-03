%% Computer Vision 1


%% Fine-tune CNN
[net, info, expdir] = finetune_cnn();


%% Hyper Parameter Tuning
clear, clc
expdir = 'data/lenet-bsz120_ep100/';

batch_sizes = [40, 80, 120];
nums_epochs = [50, 100];

res_cell = {};
idx = 1;

% for num_epochs = nums_epochs
%     for batch_size = batch_sizes
%         nets.fine_tuned = load(fullfile(expdir, strcat('bsz', num2str(batch_size),'_ep', num2str(num_epochs), '.mat')));

nets.fine_tuned = load(fullfile(expdir, 'net-epoch-100.mat'));
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat'));
nets.pre_trained = nets.pre_trained.net;
data = load(fullfile(expdir, 'imdb-caltech.mat'));
data.images.data = single(data.images.data);

vl_simplenn_display(nets.pre_trained)

train_svm(nets, data)

 
%% T-SNE
expdir = 'data/lenet-bsz120_ep100/';

% Load networks
nets.fine_tuned = load(fullfile(expdir, 'net-epoch-100.mat'));
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat'));
nets.pre_trained = nets.pre_trained.net;
nets.pre_trained.layers{end}.type = 'softmax';
nets.fine_tuned.layers{end}.type = 'softmax';

% Load data
data = load(fullfile(expdir, 'imdb-caltech.mat'));

% Extract features
[svm.pre_trained.trainset, svm.pre_trained.testset] = get_svm_data(data, nets.pre_trained);
[svm.fine_tuned.trainset,  svm.fine_tuned.testset] = get_svm_data(data, nets.fine_tuned);

addpath('tsne')

% size(svm.pre_trained.trainset.features)
% size(svm.pre_trained.testset.features)
% size(svm.pre_trained.trainset.labels)
% size(svm.pre_trained.testset.labels)

% Run TSNE
% figure1 = figure('Color',[1 1 1]);
% tsne_pre = tsne(vertcat(svm.pre_trained.trainset.features',svm.pre_trained.testset.features'));
% gscatter(tsne_pre(:,1), tsne_pre(:,2), vertcat(svm.pre_trained.trainset.labels, svm.pre_trained.testset.labels));
% savefig('results/tsne_pre.fig')
figure2 = figure('Color',[1 1 1]);
tsne_fine = tsne(vertcat(svm.fine_tuned.trainset.features', svm.fine_tuned.testset.features'));
gscatter(tsne_fine(:,1), tsne_fine(:,2), vertcat(svm.fine_tuned.trainset.labels, svm.fine_tuned.testset.labels));
savefig('results/tsne_fine.fig')


% %% Data Augmentation
%
% expdir = 'data/cnn_assignment-lenet';
% nets.fine_tuned = load(fullfile(expdir, 'b100_e80.mat'));
% nets.fine_tuned = nets.fine_tuned.net;
% nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat'));
% nets.pre_trained = nets.pre_trained.net;
% data = load(fullfile(expdir, 'imdb-caltech.mat'));
% train_svm(nets, data);
%
% %% Freezing Early Layers
%
% expdir = 'data/cnn_assignment-lenet';
% nets.fine_tuned = load(fullfile(expdir, 'frozen.mat'));
% nets.fine_tuned = nets.fine_tuned.net;
% nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat'));
% nets.pre_trained = nets.pre_trained.net;
% data = load(fullfile(expdir, 'imdb-caltech.mat'));
% train_svm(nets, data);
%
% %% Dropout
%
% expdir = 'data/cnn_assignment-lenet';
% nets.fine_tuned = load(fullfile(expdir, 'dropout.mat'));
% nets.fine_tuned = nets.fine_tuned.net;
% nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat'));
% nets.pre_trained = nets.pre_trained.net;
% data = load(fullfile(expdir, 'imdb-caltech.mat'));
% train_svm(nets, data);
%

%% Filter Visualization

% Fine-tuned
expdir = 'data/lenet-bsz120_ep100/';
net = load(fullfile(expdir, 'net-epoch-100.mat'));

figure1 = figure('Color', [1 1 1]) ; clf ; colormap gray ;
vl_imarraysc(squeeze(net.net.layers{1}.weights{1}), 'spacing', 2)
axis equal ;
title('Fine-Tuned - Filters in the first layer') ;


function [trainset, testset] = get_svm_data(data, net)

trainset.labels = [];
trainset.features = [];

testset.labels = [];
testset.features = [];
data.images.data = single(data.images.data);
for i = 1:size(data.images.data, 4)
    
    res = vl_simplenn(net, data.images.data(:, :,:, i));
    feat = res(end-3).x; feat = squeeze(feat);
    
    if(data.images.set(i) == 1)
        trainset.features = [trainset.features feat];
        trainset.labels   = [trainset.labels;  data.images.labels(i)];
    else
        testset.features = [testset.features feat];
        testset.labels   = [testset.labels;  data.images.labels(i)];
    end
    
end
end
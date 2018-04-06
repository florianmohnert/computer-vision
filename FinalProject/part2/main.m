%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Image Classification with convolutional neural networks %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Fine-tune CNN
[net, info, expdir] = finetune_cnn();


%% Hyperparameter tuning
clear
expdir = 'data/lenet-bsz120_ep100/';

res_cell = {};
idx = 1;

nets.fine_tuned = load(fullfile(expdir, 'net-epoch-100.mat'));
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat'));
nets.pre_trained = nets.pre_trained.net;
data = load(fullfile(expdir, 'imdb-caltech.mat'));
data.images.data = single(data.images.data);

vl_simplenn_display(nets.pre_trained)

train_svm(nets, data)

 
%% T-SNE
clear
expdir = 'data/lenet-bsz120_ep100/';

% Load pretrained and fine-tuned networks
nets.fine_tuned = load(fullfile(expdir, 'net-epoch-100.mat'));
nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat'));
nets.pre_trained = nets.pre_trained.net;
nets.pre_trained.layers{end}.type = 'softmax';
nets.fine_tuned.layers{end}.type = 'softmax';

% Load data from imdb struct
data = load(fullfile(expdir, 'imdb-caltech.mat'));

% Extract features to feed into an SVM
[svm.pre_trained.trainset, svm.pre_trained.testset] = get_svm_data(data, nets.pre_trained);
[svm.fine_tuned.trainset,  svm.fine_tuned.testset] = get_svm_data(data, nets.fine_tuned);



% Run TSNE
addpath('tsne')

figure1 = figure('Color', [1 1 1]);
tsne_pre = tsne(vertcat(svm.pre_trained.trainset.features',svm.pre_trained.testset.features'));
gscatter(tsne_pre(:,1), tsne_pre(:,2), vertcat(svm.pre_trained.trainset.labels, svm.pre_trained.testset.labels));

figure2 = figure('Color',[1 1 1]);
tsne_fine = tsne(vertcat(svm.fine_tuned.trainset.features', svm.fine_tuned.testset.features'));
gscatter(tsne_fine(:,1), tsne_fine(:,2), vertcat(svm.fine_tuned.trainset.labels, svm.fine_tuned.testset.labels));


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
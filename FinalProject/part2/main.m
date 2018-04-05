%% main function 


%% fine-tune cnn

[net, info, expdir] = finetune_cnn();

%% extract features and train svm

% TODO: Replace the name with the name of your fine-tuned model
nets.fine_tuned = load(fullfile(expdir, 'net-epoch-120.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-caltech.mat'));


%%
[pre_labels, pre_features, fine_labels, fine_features] = train_svm(nets, data);

%% get the features of the training sets and visualize them

mappedX = tsne(full(pre_features));
figure;
gscatter(mappedX(:,1), mappedX(:,2), pre_labels);

mappedX = tsne(full(fine_features));
figure;
gscatter(mappedX(:,1), mappedX(:,2), fine_labels);

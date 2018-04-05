%% Adapted version of the get_svm_data function from train_svm.m
%  Returns the labels and features of the training set directly.
function [labels, features] = get_svm_labels_features(data, net)

trainset.labels = [];
trainset.features = [];

for i = 1:size(data.images.data, 4)
    
    res = vl_simplenn(net, data.images.data(:, :,:, i));
    feat = res(end-3).x; feat = squeeze(feat);
    
    if(data.images.set(i) == 1)
        
        trainset.features = [trainset.features feat];
        trainset.labels   = [trainset.labels;  data.images.labels(i)];        
    end
    
end
labels = double(trainset.labels);
features = sparse(double(trainset.features'));
end

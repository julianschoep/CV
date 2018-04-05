function [image_set, set_idx] = sample_images_test(num_samples,varargin)
    num_datasets = size(varargin,2);
    % Make sure not too sample more images than available in the imagesets.
    % Number of samples will be the minimum number available in each class,
    % thus resulting in a balanced amount of samples per class.
    for i = 1:num_datasets
       dataset = varargin{i}
       max_samples = size(dataset,1);
       num_samples = min(max_samples, num_samples);
    end
    varargout = cell(num_datasets,1);
    image_set = cell(num_datasets*num_samples,1);
    set_idx = zeros(num_datasets*num_samples,1);
    idx = 0
    for i = 1:num_datasets
       dataset_i = varargin{i} 
       [dataset_sample, I] = datasample(dataset_i,num_samples,'Replace',false);
       missIndex = setdiff(1:size(dataset_i, 1), I);
       varargout{i} = dataset_i(missIndex);
       for j= 1:num_samples
          idx = idx + 1;
          image_set{idx} = dataset_sample{j};
          set_idx(idx) = I(j)+((i-1)*num_samples);
       end
    end
end
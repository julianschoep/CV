function [image_set] = sample_images(num_samples,varargin)
    num_datasets = size(varargin,2);
    image_set = cell(num_datasets*num_samples,1);
    idx = 0
    for i = 1:num_datasets
       dataset_i = varargin{i} 
       dataset_sample = datasample(dataset_i,num_samples,'Replace',false);
       for j= 1:num_samples
          idx = idx + 1;
          image_set{idx} = dataset_sample{j};
       end
    end
end
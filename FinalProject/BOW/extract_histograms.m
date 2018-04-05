function [hist_matrix] = extract_histograms(image_set,vocabulary, func, dense)
    n = size(image_set,1);
    h_cells = cell(n,1);
    parfor i = 1:n
        im = image_set{i};
        word_histogram = get_visual_word_hist(im, vocabulary, func, dense);
        h_cells{i} = word_histogram;
    end
    vocabulary_size = size(vocabulary,2);
    hist_matrix = zeros(n,vocabulary_size);
    for i = 1:n
       hist_matrix(i,:) = h_cells{i};
    end
    disp('Done constructing histograms of images');
end
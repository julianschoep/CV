function [H] = get_visual_word_hist(im, vocabulary,func, dense)
ch = size(im,3);
% In the case of grayscale images, still extract graySIFT descriptors
if ch == 3
    im_descriptors = func(im,dense);
else
    im_descriptors = graySIFT(im,dense);
end
[im_labels] = get_visual_words(im_descriptors,vocabulary);
vocabulary_size = size(vocabulary,2);
H = hist(im_labels, vocabulary_size);
H = H/sum(H);
end
% Demo script that combines all the Bag-Of-Words classification method

% To figure out: The only difference between the sift and dense sift
% implementation of for example OpponentSift lies in the way the keypoints
% are generated; either using vl_sift() of vl_dsift(). I throw away the
% descriptors that are returned by these two functions and recompute these
% per image channel for opponent, normalized and RGB. Not sure if that's
% right.

% LOAD VL FEAT
%run('/usr/src/vlfeat-0.9.21/toolbox/vl_setup')

%% Load images.
airplanes_path = '../Caltech4/ImageData/airplanes_train/'
cars_path = '../Caltech4/ImageData/cars_train/'
faces_path = '../Caltech4/ImageData/faces_train/'
motorbikes_path = '../Caltech4/ImageData/motorbikes_train/'

airplanes = load_img_dir(airplanes_path,500)
cars = load_img_dir(cars_path,500)
faces = load_img_dir(faces_path,500)
motorbikes = load_img_dir(motorbikes_path,500)

% Random sample from these four datasets.

%% % Get keypoints.
%d = OpponentSIFT(im,densebool);

%% 

% DO K-means clustering
[centers, assignments] = vl_kmeans(descriptors, vocabularySize);




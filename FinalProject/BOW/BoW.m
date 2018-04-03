% Demo script that combines all the Bag-Of-Words classification method

% Another thing to figure out:
% The SIFT three channel variants (RGB, opponent etc) return n descriptors
% per channel. I concat these descriptors along the third dimension, so you
% get 128xnx3 descriptor objects back. This is not clusterable however (I
% think?). So now I just throw all the descriptors in one long list (of
% 128x(n*3). I'm not sure if this is the right way. Issue on piazza: https://piazza.com/class/jd4nm7yg2wt7of?cid=87

%% PARAMETERS

SIFT_func            = @OpponentSIFT; % SIFT version (any of: @OpponentSIFT, @RGBSIFT, @rgb_SIFT, @graySIFT)
V                    = 400          ; % Vocabulary size. (400, 800, 1600, 2000, 4000)

                                      % Training set sizes: Sum cannot exceed 500
num_train_vocabulary = 250          ; % Number of images of each class to construct vocabulary from.
num_train_svm        = 150           ; % Number of images of each class to train SVM on.
                        
dense_bool           = false        ; % Whether to extract descriptors from dense keypoints or points of interest.

SIFT_METHOD_NAME = 'OpponentSIFT keypoints' ; %string containing sift description'
V_frac = num_train_vocabulary / (num_train_vocabulary/num_train_svm);%vocabulary fraction

%% LOAD VL FEAT
run('/usr/src/vlfeat-0.9.21/toolbox/vl_setup')
% LOAD LIBLINEAR
addpath(genpath('/home/julian/MScAI/CV/liblinear-2.20/matlab/'))

%addpath(genpath('usr/local/MATLAB/R2017b/toolbox/nnet/nnet/@network/train.m'))
%% Load training images.
airplanes_path = '../Caltech4/ImageData/airplanes_train/'
cars_path = '../Caltech4/ImageData/cars_train/'
faces_path = '../Caltech4/ImageData/faces_train/'
motorbikes_path = '../Caltech4/ImageData/motorbikes_train/'

[airplanes, notused] = load_img_dir(airplanes_path);
[cars,notused ]= load_img_dir(cars_path);
[faces,notused ]= load_img_dir(faces_path);
[motorbikes, notused ]= load_img_dir(motorbikes_path);

%% Sample images
% sample_images(num_samples, [datasets]*)
% Randomly samples (without replacement) <num_samples> images from each of
% the datasets. A total of 1000 for building the vocabulary and a total of
% 200 for training the SVM.
%
[vocab_set, airplanes, cars, faces, motorbikes] = sample_images(num_train_vocabulary,airplanes, cars, faces, motorbikes);
[svm_set, airplanes, cars, faces, motorbikes] = sample_images(num_train_svm,airplanes, cars, faces, motorbikes);

save vocab_set
save svm_set
%% LOAD VOCABULARY AND IMAGE SETS
%load vocab_set
%load svm_set
%load vocabulary

 


%% % Building Vocabulary.
% getDescriptors(@sift_function, image_set, useDenseKeypoints)
% available sift functions:
% - OpponentSIFT
% - RGBSIFT
% - rgb_SIFT
% - graySIFT
% useDenseKeypoints is a boolean specifying whether to use dense keypoints,
% or use keypoints as returned by vl_sift.

% REMEMBER TO FILTER OUT GRAY IMAGES WHEN USING 3 CHANNEL SIFT
tic

disp('Image set filtered');
% Get descriptors
descriptors = getDescriptors(SIFT_func, vocab_set, dense_bool);
%d = OpponentSIFT(im,densebool);
disp('Descriptor set build');
toc
disp('Clustering words into vocabulary');
% Takes 7.5 mins for 1000 images and 400 words.
% DO K-means clustering to construct vocabulary
tic
[vocabulary, assignments] = vl_kmeans(double(descriptors), V);
toc
save vocabulary
%random image for testing
%sample = datasample(image_set,1);

%% Setting up svm
disp('Producing labels and trainingset for svm');
tic

train_matrix = [];
labels_planes = zeros((4*num_train_svm),1);
labels_planes(1:num_train_svm) = 1;

labels_cars = zeros((4*num_train_svm),1);
labels_cars((num_train_svm+1):(2*num_train_svm)) = 1;

labels_faces = zeros((4*num_train_svm),1);
labels_faces((2*num_train_svm+1):(3*num_train_svm))= 1;

labels_motorbikes = zeros((4*num_train_svm),1);
labels_motorbikes((3*num_train_svm+1):end) = 1;

train_matrix = extract_histograms(svm_set, vocabulary, SIFT_func, dense_bool);

disp('Done producing dataset of histograms');
toc

%% Training the Support Vector Machines
disp('Training binary classifiers');
%shuffle_idx = datasample(1:200,200,'Replace',false);
tic
model_planes = train(double(labels_planes), sparse(train_matrix), '-c 50 -s 2');
model_cars = train(double(labels_cars), sparse(train_matrix), '-c 50 -s 2');
model_faces = train(double(labels_faces), sparse(train_matrix), '-c 50 -s 2');
model_motorbikes = train(double(labels_motorbikes), sparse(train_matrix), '-c 50 -s 2');
toc
disp('DONE.');

%% Load testing images.
airplanes_path = '../Caltech4/ImageData/airplanes_test/'
cars_path = '../Caltech4/ImageData/cars_test/'
faces_path = '../Caltech4/ImageData/faces_test/'
motorbikes_path = '../Caltech4/ImageData/motorbikes_test/'

[airplanes_test, airplane_test_names] = load_img_dir(airplanes_path);
[cars_test, cars_test_names] = load_img_dir(cars_path);
[faces_test, faces_test_names]= load_img_dir(faces_path);
[motorbikes_test,motorbikes_test_names] = load_img_dir(motorbikes_path);

filenames ={airplane_test_names{:},cars_test_names{:},faces_test_names{:},motorbikes_test_names{:}};

[test_set, I] = sample_images_test(50,airplanes_test, cars_test, faces_test, motorbikes_test);

test_set_filenames = filenames(I)';

%% Get histograms of test set
%To classify a new image, you should calculate its visual
%words histogram as described in Section 2.4 and use the trained SVM classifier to
%assign it to the most probable object class.
disp("Constructing histogram set of test images");
tic
test_matrix = extract_histograms(test_set, vocabulary, SIFT_func, dense_bool);
toc

%% TEST predicions
test_labels_planes  = zeros(200,1); test_labels_planes(1:50) =1;
test_labels_cars  = zeros(200,1); test_labels_cars(51:100) =1;
test_labels_faces  = zeros(200,1); test_labels_faces(101:150) =1;
test_labels_motorbikes  = zeros(200,1); test_labels_motorbikes(151:200) =1;

[l, acc, prob_planes] = predict(test_labels_planes, sparse(test_matrix), model_planes, '-b 1')
[l, acc, prob_cars] = predict(test_labels_cars, sparse(test_matrix), model_cars, '-b 1')
[l, acc, prob_faces] = predict(test_labels_faces, sparse(test_matrix), model_faces, '-b 1')
[l, acc, prob_motorbikes] = predict(test_labels_motorbikes, sparse(test_matrix), model_motorbikes, '-b 1')

% LIBLINEAR reverse labels when the first label is non-positive (which is
% the case for all but planes).
prob_cars = prob_cars*-1;
prob_faces = prob_faces*-1;
prob_motorbikes = prob_motorbikes * -1;



%% Calculate average precisions



[AP_planes, rank_idx_planes] = average_precision(prob_planes, test_labels_planes,50);
[AP_cars, rank_idx_cars] = average_precision(prob_cars, test_labels_cars,50);
[AP_faces, rank_idx_faces] = average_precision(prob_faces, test_labels_faces,50);
[AP_motorbikes, rank_idx_motorbikes] = average_precision(prob_motorbikes, test_labels_motorbikes,50);

MAP = mean([AP_planes,AP_cars,AP_faces,AP_motorbikes]);

ranked_filenames_planes = test_set_filenames(rank_idx_planes);
ranked_filenames_cars = test_set_filenames(rank_idx_cars);
ranked_filenames_faces = test_set_filenames(rank_idx_faces);
ranked_filenames_motorbikes = test_set_filenames(rank_idx_motorbikes);

ranked_filenames = [ranked_filenames_planes,ranked_filenames_cars,ranked_filenames_faces,ranked_filenames_motorbikes];


%% MAKE HTML FILE
html_filename = 'put_your_filename_here.html';
% Read html into cell A
fid = fopen('Template_Result.html','r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);


% Edit values in html
last_idx = 0;
photo_template = '';
for j = 1:size(A,2)
   line = A{j};
   if ischar(line)
       if contains(line, "SIFT step size")
           if dense_bool
                newLine = strrep(line,'XXX',num2str(10));
           else
               newLine = strrep(line,'XXX','(no step size since not dense) -');
           end
           A{j} = newLine;
       elseif contains(line, 'SIFT method')
           newLine = strrep(line,'XXX',SIFT_METHOD_NAME);
           A{j} = newLine;
       elseif contains(line, 'Vocabulary size')
           newLine = strrep(line,'XXX',num2str(V));
           A{j} = newLine;
       elseif contains(line, 'Vocabulary fraction')
           newLine = strrep(line,'XXX',num2str(V_frac));
           A{j} = newLine;
       elseif contains(line, 'SVM training data')
           newLine = strrep(line,'XXX',num2str(num_train_svm));
           newLine = strrep(newLine,'YYY',num2str(num_train_svm*3));
           A{j} = newLine;  
       elseif contains(line, '(MAP')
           newLine = strrep(line,'XXX',num2str(MAP))
           A{j} = newLine;
       elseif contains(line, '(AP')
           newLine = strrep(line,'AAA',num2str(AP_planes));
           newLine = strrep(newLine,'BBB',num2str(AP_cars));
           newLine = strrep(newLine,'CCC',num2str(AP_faces));
           newLine = strrep(newLine,'DDD',num2str(AP_motorbikes));
           A{j} = newLine;
       elseif contains(line, '<tbody>')
          last_idx = j;
       elseif contains(line, 'src="AAA"')
          photo_template = line;
       end
   end
end
n = 200;
for i = 1:n
    ith_rank = ranked_filenames(i,:);
    planes_no = ith_rank{1};
    cars_no = ith_rank{2};
    faces_no = ith_rank{3};
    motorbikes_no = ith_rank{4};
    newLine = strrep(photo_template, 'AAA',planes_no);
    newLine = strrep(newLine, 'BBB',cars_no);
    newLine = strrep(newLine, 'CCC',faces_no);
    newLine = strrep(newLine, 'DDD',motorbikes_no);
    disp(newLine);
    A{last_idx+i} = newLine;
end

A{last_idx+200+1} = '</tbody>';
A{last_idx+200+2} = '</table>';
A{last_idx+200+3} = '</body>';
A{last_idx+200+4} = '</html>';
A{last_idx+200+5} = [-1];
% Write cell A into new html
fid = fopen(html_filename, 'w');
for i = 1:numel(A)
    if A{i+1} == -1
        fprintf(fid,'%s', A{i});
        break
    else
        fprintf(fid,'%s\n', A{i});
    end
end
disp("DONE generating HTML");


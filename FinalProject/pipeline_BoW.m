%% Parameters
colorspace = 'RGB';
detector = 'keypoints';
sample_size = 3;
vocab_size = 5;
train_set_size = 3;


%% Build the vocabulary
images_airplanes = load_image_stack('Caltech4/ImageData/airplanes_train', sample_size + train_set_size);
images_cars = load_image_stack('Caltech4/ImageData/cars_train', sample_size + train_set_size);
images_faces = load_image_stack('Caltech4/ImageData/faces_train', sample_size + train_set_size);
images_motorbikes = load_image_stack('Caltech4/ImageData/motorbikes_train', sample_size + train_set_size);

images_vocab_building = [images_airplanes(1:sample_size), ...
                         images_cars(1:sample_size),      ...
                         images_faces(1:sample_size),     ...
                         images_motorbikes(1:sample_size) ...
                        ];

descriptors = sift_descriptors(images_vocab_building, colorspace, detector);
descriptors = normc(double(descriptors));  % normalize descriptors

[~, centroids] = kmeans(descriptors, vocab_size);


%% Create image features

images_train = [images_airplanes(sample_size+1:end), ...
                images_cars(sample_size+1:end),      ...
                images_faces(sample_size+1:end),     ...
                images_motorbikes(sample_size+1:end) ...
               ];

[histograms] = histograms_of_words(images_train, centroids, colorspace, detector);

airplanes_train = histograms([1 : train_set_size], :); 
cars_train = histograms([train_set_size+1 : 2*train_set_size], :); 
faces_train = histograms([2*train_set_size+1 : 3*train_set_size], :); 
motorbikes_train = histograms([3*train_set_size+1 : 4*train_set_size], :); 

train_sets = {airplanes_train, cars_train, faces_train, motorbikes_train};
n_classes = length(train_sets);

classifiers = {};
for k = 1:n_classes
   X = [];
   Y = zeros(n_classes * train_set_size, 1);
   
   % Separate data in two classes
   correct = cell2mat(train_sets(k));
   wrong = reshape(                                            ...
                  cell2mat(train_sets(1:end ~= k)),            ...
                  [train_set_size * (n_classes-1), vocab_size] ...
           );
   
   X = cat(1, X, correct);
   X = cat(1, X, wrong);
   Y([1:train_set_size]) = 1;

   
   % Shuffle
   rand_indices = randperm(length(X));
   X = X(rand_indices, :); 
   Y = Y(rand_indices);
   
   classifier{k} = fitcsvm(X, Y);
end

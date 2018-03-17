%% Parameters
colorspace = 'RGB';
detector = 'keypoints';
sample_size = 5;
vocab_size = 5;
train_set_size = 2;


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
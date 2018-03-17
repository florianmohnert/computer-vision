%% Parameters
colorspace = 'RGB';
detector = 'keypoints';
sample_size = 5;
vocab_size = 5;
train_set_size = 2;


%% Build the vocabulary
images_airplanes = load_image_stack('Caltech4/ImageData/airplanes_train', sample_size);
images_cars = load_image_stack('Caltech4/ImageData/cars_train', sample_size);
images_faces = load_image_stack('Caltech4/ImageData/faces_train', sample_size);
images_motorbikes = load_image_stack('Caltech4/ImageData/motorbikes_train', sample_size);

images = [images_airplanes, images_cars, images_faces, images_motorbikes];

descriptors = sift_descriptors(images, colorspace, detector);
descriptors = normc(double(descriptors));  % normalize descriptors

[~, centroids] = kmeans(descriptors, vocab_size);


%% Create image features
images_airplanes = load_image_stack('Caltech4/ImageData/airplanes_train', train_set_size);
images_cars = load_image_stack('Caltech4/ImageData/cars_train', train_set_size);
images_faces = load_image_stack('Caltech4/ImageData/faces_train', train_set_size);
images_motorbikes = load_image_stack('Caltech4/ImageData/motorbikes_train', train_set_size);

images = [images_airplanes, images_cars, images_faces, images_motorbikes];

[histograms] = histograms_of_words(images, centroids, colorspace, detector);
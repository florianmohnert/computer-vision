
images_airplanes = load_image_stack('Caltech4/ImageData/airplanes_train',10);
images_cars = load_image_stack('Caltech4/ImageData/cars_train',10);
images_faces = load_image_stack('Caltech4/ImageData/faces_train',10);
images_motorbikes = load_image_stack('Caltech4/ImageData/motorbikes_train',10);


images = [images_airplanes,images_cars, images_faces, images_motorbikes];

descriptors = sift_descriptors(images,'RGB','keypoints');

[~,centroids] = kmeans(normc(double(descriptors)),100);
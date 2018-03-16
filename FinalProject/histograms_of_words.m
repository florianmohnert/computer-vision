function[histograms] = histograms_of_words(centroids)

images_airplanes = load_image_stack('Caltech4/ImageData/airplanes_train',50);
images_cars = load_image_stack('Caltech4/ImageData/cars_train',50);
images_faces = load_image_stack('Caltech4/ImageData/faces_train',50);
images_motorbikes = load_image_stack('Caltech4/ImageData/motorbikes_train',50);

images = [images_airplanes,images_cars, images_faces, images_motorbikes];

for i = 1:length(images)
    
    im = im2single(cell2mat(images(i)));
    
    if (colorspace == 'RGB')
        descriptors = sift3d(im,feature_detector);
        
    elseif (colorspace == 'rgb')
        im = RGB2rgb(im);
        descriptors = sift3d(im,feature_detector);
        
    elseif (colorspace == 'opponent')
        im = rgb2opponent(im);
        descriptors = sift3d(im,feature_detector);
    end
    
    centroid_hist = zeros(size(centroids,1),1);
    for descr_idx=1:size(descriptors,1)
        max_distance = 0;
        centroid = 0;
        for centroid_idx= 1: size(centroids,1)
            
            dist = pdist(descriptors(cescr_idx),centroids(centroid_idx));
            
            if dist > max_distance
                max_distance = dist;
                centroid = centroid_idx;
            end
              
        end
        centroid_hist(centroid) = centroid_hist(centroid) + 1;
        
    end
    
    centroid_hist = normc(centroid_hist);
    
end

end
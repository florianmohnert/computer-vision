function[maps] = map(classifiers, centroids, colorspace, detector)
%%%%%%%%%%%%%%%%%%%%%%%
% classifiers: 4 trained classifiers
% test_data: test_data 
% Returns array of map for all classifiers
%%%%%%%%%%%%%%%%%%%%%%%

test_set_size = 50;
n_test_sets = 4;

images_airplanes = load_image_stack('Caltech4/ImageData/airplanes_test', test_set_size);
images_cars = load_image_stack('Caltech4/ImageData/cars_test', test_set_size);
images_faces = load_image_stack('Caltech4/ImageData/faces_test',  test_set_size);
images_motorbikes = load_image_stack('Caltech4/ImageData/motorbikes_test', test_set_size);

images_test = [images_airplanes, images_cars,images_faces,images_motorbikes];

[histograms] = histograms_of_words(images_test, centroids, colorspace, detector);

airplanes_test = histograms([1 : test_set_size], :); 
cars_test = histograms([test_set_size+1 : 2*test_set_size], :); 
faces_test = histograms([2*test_set_size+1 : 3*test_set_size], :); 
motorbikes_test = histograms([3*test_set_size+1 : 4*test_set_size], :); 

test_sets = {airplanes_test, cars_test, faces_test, motorbikes_test};
n_classes = length(test_sets);
maps = {};

for svm_idx = 1:length(classifiers)
    labels = zeros(test_set_size*n_test_sets, 1);
    scores = {};
    pred_labels = {};
    
    for k = 1:length(test_sets) 
        classifier = classifiers{svm_idx};
        [pred_labels_svm, scores_svm] = predict(classifier, ...
                                                cell2mat(test_sets(k)) ...
                                            );
        scores = [scores, {scores_svm(:,1)'}];
        pred_labels = [pred_labels, {pred_labels_svm'}];
        
        if k == 1
            labels(1:test_set_size) = 1;
            labels(test_set_size+1:end) = 0;
        end
    end 
    
    results = [labels'; cell2mat(scores); cell2mat(pred_labels)];
    results = sortrows(results', 2, 'descend');
    
    pres = 0;
    frac = 0;
    for n = 1:test_set_size * n_classes
        if results(n,1) == 1
            pres = pres + 1;
            frac = frac + pres/n;  
        end   
    end
    
    maps{svm_idx} = frac / test_set_size;
end





   
   







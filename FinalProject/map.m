function [maps] = map(images_test, test_set_size, classifiers, centroids, colorspace, detector, vocab_size, kernel)
%%%%%%%%%%%%%%%%%%%%%%%
% classifiers: 4 trained classifiers
% test_data: test_data
% Returns array of map for all classifiers
%%%%%%%%%%%%%%%%%%%%%%%

[histograms] = histograms_of_words(images_test, centroids, colorspace, detector);


airplanes_test = histograms([1 : test_set_size], :);
cars_test = histograms([test_set_size+1 : 2*test_set_size], :);
faces_test = histograms([2*test_set_size+1 : 3*test_set_size], :);
motorbikes_test = histograms([3*test_set_size+1 : 4*test_set_size], :);

test_sets = {airplanes_test, cars_test, faces_test, motorbikes_test};
img_indices = {1:50, 51:100, 101:150, 151:200};

n_classes = length(test_sets);
maps = {};

file_out = fopen('html_output.txt', 'a');
fprintf(file_out, '%s %s %d %s\n', detector, colorspace, vocab_size, kernel);

indices_html = [];

for svm_idx = 1:length(classifiers)
    labels = zeros(test_set_size*n_classes, 1);
    scores = {};
    pred_labels = {};
    
    other_class_sets = cell2mat(test_sets(1:end ~= svm_idx));

    test_sets_ = {cell2mat(test_sets(svm_idx)), ...
                  other_class_sets(:,1:vocab_size), ...
                  other_class_sets(:,vocab_size+1:2*vocab_size), ...
                  other_class_sets(:,2*vocab_size+1:3*vocab_size)};
              
    img_indices_ = cat(2, cell2mat(img_indices(svm_idx)), cell2mat(img_indices(1:end ~= svm_idx)));
    
    for k = 1:length(test_sets)
        classifier = classifiers{svm_idx};
        
        [pred_labels_svm, scores_svm] = predict(classifier, ...
                                                cell2mat(test_sets_(k)) ...
                                        );
                                    
        scores = [scores, {scores_svm(:,1)'}];
        pred_labels = [pred_labels, {pred_labels_svm'}];
        
        if k == 1
            labels(1:test_set_size) = 1;
            labels(test_set_size+1:end) = 0;
        end
    end
    
    results = [labels'; cell2mat(scores); cell2mat(pred_labels); img_indices_];
    results = sortrows(results', 2, 'descend');
    indices_html = cat(2, indices_html, results(:,4));
    
    pres = 0;
    frac = 0;
    for n = 1:test_set_size * n_classes
        if results(n, 1) == 1
            pres = pres + 1;
            frac = frac + pres/n;
        end
    end
    
    maps{svm_idx} = frac / test_set_size;
end

fprintf(file_out, '%f %f %f %f %f\n', cell2mat(maps), mean(cell2mat(maps)));
fprintf(file_out, '%d %d %d %d\n', indices_html)

fclose(file_out);
end











function [map_values] = BoW(centroids, images_train, ...
                            images_test, colorspace, detector, ...
                            vocab_size, train_set_size, ...
                            test_set_size, kernel)

% Create image features
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
   rand_indices = randperm(size(X, 1));
   X = X(rand_indices, :); 
   Y = Y(rand_indices);
   
   classifiers{k} = fitcsvm(X, Y, 'KernelFunction', kernel);
end

map_values = map(images_test, test_set_size, classifiers, centroids, ...
                 colorspace, detector, vocab_size, kernel);

end

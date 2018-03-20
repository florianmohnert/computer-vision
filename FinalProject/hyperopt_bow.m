%% Fix parameters
sample_size = 250;
train_set_size = 50;
test_set_size = 50;
n_classes = 4;


%% Hyperparameters
detector_types = ["keypoints", "dense"];
colorspace = ["RGB", "rgb", "opponent"];
vocab_sizes = [400, 800, 1600, 2000, 4000];
kernels = {'linear', 'RBF'};


%% Image loading

% Training set
images_airplanes = load_image_stack('Caltech4/ImageData/airplanes_train', sample_size + train_set_size);
images_cars = load_image_stack('Caltech4/ImageData/cars_train', sample_size + train_set_size);
images_faces = load_image_stack('Caltech4/ImageData/faces_train', sample_size + train_set_size);
images_motorbikes = load_image_stack('Caltech4/ImageData/motorbikes_train', sample_size + train_set_size);


images_vocab_building = [images_airplanes(1:sample_size), ...
    images_cars(1:sample_size),      ...
    images_faces(1:sample_size),     ...
    images_motorbikes(1:sample_size) ...
    ];

images_train = [images_airplanes(sample_size+1:end), ...
    images_cars(sample_size+1:end),      ...
    images_faces(sample_size+1:end),     ...
    images_motorbikes(sample_size+1:end) ...
    ];

% Test set
images_airplanes = load_image_stack('Caltech4/ImageData/airplanes_test', test_set_size);
images_cars = load_image_stack('Caltech4/ImageData/cars_test', test_set_size);
images_faces = load_image_stack('Caltech4/ImageData/faces_test',  test_set_size);
images_motorbikes = load_image_stack('Caltech4/ImageData/motorbikes_test', test_set_size);

images_test = [images_airplanes, images_cars, images_faces, images_motorbikes];


%% Optimisation
settings = {};
map_values = {};
setting_idx = 1;

for detector_idx = 1:length(detector_types)
    detector = detector_types(detector_idx);
    
    for descriptor_idx = 1:length(colorspace)
        colorspace = colorspace(descriptor_idx);
        
        if detector == "dense" && colorspace == "rgb"
            continue;
        end
        
        for vocab_size_idx = 1:length(vocab_sizes)
            vocab_size = vocab_sizes(vocab_size_idx);
            
            for kernel_idx = 1:length(kernels)
                kernel = cell2mat(kernels(kernel_idx));
                
                t = cputime;
               
                settings{setting_idx} = {detector, colorspace, vocab_size, kernel};
                disp(settings{setting_idx});
                
                map_values{setting_idx} = BoW(images_vocab_building, images_train, ...
                                              images_test, colorspace, detector, ...
                                              vocab_size, train_set_size, ...
                                              test_set_size, kernel);
                disp(map_values{setting_idx});
                disp(mean(cell2mat(map_values{setting_idx})));
                setting_idx = setting_idx + 1;
                
                disp(cputime - t);
            end
        end
    end
end

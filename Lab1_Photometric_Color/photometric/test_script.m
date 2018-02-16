files = dir('photometrics_images/SphereGray5');
image_stack_ = zeros(512,512,5);
for file = 3:length(files)
    
    
    I = imread(strcat(files(file).folder,'/', files(file).name)) ;
    
    % -2 because we ignored the files . and ..
    image_stack_(:,:,file-2) = I(:,:,1);
    
end


V = [0,0;1,1;1,-1;-1,1;-1,-1];
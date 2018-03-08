function[] = make_video(folder)
video = VideoWriter('feature_tracking.avi'); %create the video object
open(video); %open the file for writing
number_frames = length(dir(folder));
filenames = dir([folder +'/*.jpg']);
for k = 1 : number_frames-2
    disp(k)
    filename = filenames(k).name;
    foldername = filenames(k).folder;
    I = imread(strcat(strcat(foldername,'/'),filename));
    writeVideo(video,I); %write the image to file
    
end



end


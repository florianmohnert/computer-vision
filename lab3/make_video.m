function[] = make_video(folder)
video = VideoWriter('feature_tracking.avi'); %create the video object
video.FrameRate = 20;
open(video); %open the file for writing

for k = 3 : length(dir('video_frames'))-1
    disp(k)
    filename = strcat(num2str(k),'.jpg');
    foldername = 'video_frames';
    I = imread(strcat(strcat(foldername,'/'),filename));
    writeVideo(video,I); %write the image to file
    
end



end


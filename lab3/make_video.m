function [] = make_video(video_title)

video = VideoWriter(video_title); %create the video object
video.FrameRate = 10;
open(video); %open the file for writing

for k = 3 : length(dir('video_frames'))-1
    filename = strcat(num2str(k), '.jpg');
    foldername = 'video_frames';
    I = imread(strcat(strcat(foldername,'/'), filename));
    writeVideo(video, I); %write the image to file
end

disp("Video saved.");
end


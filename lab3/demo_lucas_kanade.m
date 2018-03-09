%
% Optical flow estimation
%

% params:
%   img_path1 - frame at timestep t
%   img_path2 - frame at timestep t + 1
%   window_size - the image is divided in square regions of this size 
%   sigma - the stdev of the gaussian smoothing filter (0 -> no smoothing)
%   visualise - 'true' to show images with optical flow vectors

lucas_kanade('sphere1.ppm', 'sphere2.ppm', 15, 0, true);

lucas_kanade('synth1.pgm', 'synth2.pgm', 15, 0, true);
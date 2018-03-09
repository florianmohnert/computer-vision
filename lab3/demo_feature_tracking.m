%                 
% Feature tracking
%

% params:
%   100000 - cornerness threshold in the Harris corner detector
%   11 - neighborhood size in the Harris corner detector to check if point
%        is local maximum 
%   0 - no Gaussian smoothing before taking temporal partial derivatives
%       (sigma > 0 -> Gaussian smoothing) in Lukas-Kanade
%   15 - the region size in Lukas-Kanade
%   10 - scaling factor for flow vectors
%   [0 0] - no thresholding of flow vectors
%   false - do not save output images to folder

tracking('person_toy', 100000, 11, 0, 15, 10, [0 0], false);


% params:
%   100000 - cornerness threshold in the Harris corner detector
%   31 - neighborhood size in the Harris corner detector to check if point
%        is local maximum 
%   0 - no Gaussian smoothing before taking temporal partial derivatives
%       (sigma > 0 -> Gaussian smoothing) in Lukas-Kanade
%   5 - the region size in Lukas-Kanade
%   10 - scaling factor for flow vectors
%   [0 0] - no thresholding of flow vectors
%   false - do not save output images to folder

% tracking('pingpong', 100000, 31, 0, 5, 10, [0 0], false);
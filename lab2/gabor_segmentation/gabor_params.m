%% Design array of Gabor Filters
% In this code section, you will create a Gabor Filterbank. A filterbank is
% a collection of filters with varying properties (e.g. {shape, texture}).
% A Gabor filterbank consists of Gabor filters of distinct orientations
% and scales. We will use this bank to extract texture information from the
% input image. 

[numRows, numCols, ~] = size(img);

% Estimate the minimum and maximum of the wavelengths for the sinusoidal
% carriers. 
% ** This step is pretty much standard, therefore, you don't have to
%    worry about it. It is cycles in pixels. **   
lambdaMin = 4/sqrt(2);
lambdaMax = hypot(numRows,numCols);

% Specify the carrier wavelengths.  
% (or the central frequency of the carrier signal, which is 1/lambda)
n = floor(log2(lambdaMax/lambdaMin));
lambdas = 2.^(0:(n-2)) * lambdaMin;

% Define the set of orientations for the Gaussian envelope.
dTheta      = pi/4;                  % \\ the step size
orientations = 0:dTheta:(pi/2);       

% Define the set of sigmas for the Gaussian envelope. Sigma here defines 
% the standard deviation, or the spread of the Gaussian. 
sigmas = [1]; 

% Now you can create the filterbank. We provide you with a MATLAB struct
% called gaborFilterBank in which we will hold the filters and their
% corresponding parameters such as sigma, lambda and etc. 
% ** All you need to do is to implement createGabor(). Rest will be handled
%    by the provided code block. **
tic
filterNo = 1;
for ii = 1:length(lambdas)
    for jj  = 1:length(sigmas)
        for ll = 1:length(orientations)
            % Filter parameter configuration for this filter.
            lambda = lambdas(ii);
            sigma  = sigmas(jj);            
            theta  = orientations(ll);
            psi    = 0;
            gamma  = 0.5;
            
            % Create a Gabor filter with the specs above. 
            % (We also record the settings in which they are created. )
            % // TODO: Implement the function createGabor() following
            %          the guidelines in the given function template.
            %          ** See createGabor.m for instructions ** //
            createGabor( sigma, theta, lambda, psi, gamma );

        end
    end
end
ctime = toc; 
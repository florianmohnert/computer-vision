% theta

dTheta      = pi/8;                  % \\ the step size
orientations = pi/4:dTheta:(pi/2);  
n = length(orientations);

for i=1:n
    gaborFilter = createGabor(1, orientations(i), 4, 0, 0.5);
%         subplot(2, n/2, i), imshow(gaborFilter(:,:,1),[]);
        subplot(1, n, i), imshow(gaborFilter(:,:,2),[]);
%     if thetas(i) == 1
%         title("π");
%     elseif thetas(i) == -1
%         title("- π");
%     elseif thetas(i) < 0
%         title("- π / " + -thetas(i));
%     else
%         title("π / " + thetas(i));
%     end
end
% 
% sigma
% 
% sigmas = [0.5 0.75 1 1.25 1.5 2];
% n = length(sigmas);
% 
% for i = 1:n
%     gaborFilter = createGabor(sigmas(i), pi/4, 4, 0, 0.5);
% %     subplot(2, n/2, i), imshow(gaborFilter(:,:,1),[]);
%     subplot(2, n/2, i), imshow(gaborFilter(:,:,2),[]);
%     title(sigmas(i));
% end

%% gamma

% gammas = [0.1 0.2 0.4 0.6 0.8 1];
% n = size(gammas, 2);
% 
% for i=1:n
%     gaborFilter = createGabor(1, pi/4, 4, 0, gammas(i));
%     subplot(2, n/2, i), imshow(gaborFilter(:,:,1),[]);
%     title(gammas(i));
% end

function[matches,scores,f1,f2] = keypoint_matching(im1,im2)


im1 = single(im1) ;
im2 = single(im2) ;
[f1, d1] = vl_sift(im1) ;
[f2, d2] = vl_sift(im2) ;
[matches, scores] = vl_ubcmatch(d1, d2) ;
[~,num_matches] = size(matches);
% matches returs indexes of points, coordinates can then be found in f1
% and f2

figure(1)
imshowpair(im1, im2, 'montage')
hold on
rand_matches = randi(num_matches,1,50);

for i = 1:50
    
    match = matches(:,rand_matches(i));
    
    % features vecs for both points
    im1_feat = f1(: , match(1));
    im2_feat = f2(: , match(2));
    
    % coordinates
    im1_feat_x = im1_feat(1);
    im1_feat_y = im1_feat(2);
    
    im2_feat_x = im2_feat(1) + 650 ;
    im2_feat_y = im2_feat(2) ;
    
    
    
    plot([im2_feat_x,im1_feat_x],[im2_feat_y,im1_feat_y])
    
end






end
clc
clear all
close all

%Reading both the source image and target image
source_im = im2double(imread('Source.jpg'));
target_im = im2double(imread('Target.jpg'));

%Reshaping the array in order to obtain R,G and B in each row
rgb_source = reshape(source_im,[],3)';
rgb_target = reshape(target_im,[],3)';

% Calculation of Mean of source and target images
source_mean = mean(rgb_source,2)
target_mean = mean(rgb_target,2)

% Calculation of Covariance of Source and target images
source_cov = cov(rgb_source')
target_cov = cov(rgb_target')

% Decomposing Covariances using the singular value decomposition
[U_s,A_s,V_s] = svd(source_cov)%U is used as a rotation matrix 
[U_t,A_t,V_t] = svd(target_cov)

rgbh_s = [rgb_source;ones(1,size(rgb_source,2))]; %appending ones to match array size for calculation


%Calculating Translation of source and target
Trans_source = eye(4); 
Trans_source(1:3,4) = -source_mean
Trans_target = eye(4); 
Trans_target(1:3,4) = target_mean

% Rotations of target and source
Rot_target = blkdiag(U_t,1)
Rot_source = blkdiag(inv(U_s),1)

% Scaling of both the source and target
Scal_target = diag([sqrt(diag(A_t));1]);
Scal_source = diag([sqrt(diag(A_s)).^-1;1]);

est_rgb_im = Trans_target*Rot_target*Scal_target*Scal_source*Rot_source*Trans_source*rgbh_s; % estimated RGBs
esti_im = est_rgb_im(1:3,:);%removing the ones appended 

Resultant_im = reshape(esti_im',size(source_im));

figure(1); imshow(source_im); title('Source Image'); 
figure(2); imshow(target_im); title('Target Image'); 
figure(3); imshow(Resultant_im); title('Resultant Image'); 


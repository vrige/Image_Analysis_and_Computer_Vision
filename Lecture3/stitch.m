% Giacomo Boracchi
% course Computer Vision and Pattern Recognition, USI Spring 2020
%
% February 2020

close all
clear
clc

%%

im1=imread('im1.jpg');
im2=imread('im2.jpg');
im1f=figure; imshow(im1);
im2f=figure; imshow(im2);
%% We manually :-( pick four points in the first image, and four corresponding points on the second image

figure(im1f), [x1,y1]=getpts
figure(im1f), hold on, plot(x1,y1,'oy', 'LineWidth', 5, 'MarkerSize', 10);
figure(im2f), [x2,y2]=getpts
figure(im2f), hold on, plot(x2,y2,'oy', 'LineWidth', 5, 'MarkerSize', 10);

%% Homography estimation using our codes

a = [x1(1); y1(1); 1];
b = [x1(2); y1(2); 1];
c = [x1(3); y1(3); 1];
d = [x1(4); y1(4); 1];
X = [a, b, c, d];

ap = [x2(1); y2(1); 1];
bp = [x2(2); y2(2); 1];
cp = [x2(3); y2(3); 1];
dp = [x2(4); y2(4); 1];
XP = [ap, bp, cp, dp];


% apply preconditioning to ease DLT algorithm
% Tp and TP are similarity trasformations
[pCond, Tp] = precond(X);
[PCond, TP] = precond(XP);

% estimate the homography among transformed points
Hc = homographyEstimation(pCond, PCond);

% adjust the homography taking into account the similarities
H = inv(TP) * Hc * Tp; % the trasnformation to be applied

%% Let's see the result

% apply the homography to the red channel of the first image
% J is the transformed image rendered in a canvas with the same dimension
% of image2
J = imwarpLinear(im1(:,:,1), H, [1, 1, 1600, 1200]);

figure(23);
subplot(2,2,1)
imagesc(im1(:,:,1)), title('image 1 (original)'), colormap gray;
subplot(2,2,2)
imagesc(J), title('image 1 transformed'), colormap gray;
subplot(2,2,3)
imagesc(im2(:,:,1)), title('image 2 (target)'), colormap gray;
subplot(2,2,4)
imagesc(im2(:,:,1)+ uint8(J)), title('image 2 + image 1 transformed'), colormap gray;
% we have lost part of the image content using imwarplinear!

%% Let's try to see both the images

% create an homography that shift the image to the right
shift = 1000;
H2 = [1 0 shift; 0 1 0; 0 0 1];
im2_shifted = imwarpLinear(im2(:,:,1), H2, [1, 1, size(im2,2) + shift, size(im2,1)]);

% now we have to transform im1 and we need to account for the shifting
J_shifted = imwarpLinear(im1(:,:,1), H2*H, [1, 1, size(im2,2) + shift, size(im2,1)]);
figure(26)
subplot(1,2,1)
imagesc(J_shifted), title('image 1 transformed and shifted'), colormap gray;
subplot(1,2,2)
imagesc(im2_shifted), title('image 2 shifted'), colormap gray;
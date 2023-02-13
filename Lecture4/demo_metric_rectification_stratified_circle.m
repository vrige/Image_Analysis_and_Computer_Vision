clear;
close all;
img = imread('img2.png');
img = imresize(img,1);
figure; imshow(img);

%% preprocessing
imgGray = rgb2gray(img);
% morphological operators
th = 90;
bw = imgGray < th;
se = strel('disk',5);
bw = imclose(bw,se);
bw = imopen(bw,se);

% get the two biggest connected components

CC = bwconncomp(bw);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~, sortedIdx] = sort(numPixels,'descend');
bw = double(bw);
for i =1:numel(numPixels)
    currentPixels = CC.PixelIdxList{sortedIdx(i)};
    if(i==1 || i==2)
        bw(currentPixels) = i;
    else
        bw(currentPixels) = 0;
    end
end
figure;
imshow(imfuse(img,double(bw)));


%% from connected component to boundaries
B = bwboundaries(bw ==1,'noholes');
ellipse1.x = B{1}(:,2);
ellipse1.y = B{1}(:,1);

B = bwboundaries(bw ==2,'noholes');
ellipse2.x = B{1}(:,2);
ellipse2.y = B{1}(:,1);
figure;
imshow(img); hold all;
plot(ellipse1.x, ellipse1.y, 'r', 'LineWidth', 2);
plot(ellipse2.x, ellipse2.y, 'b', 'LineWidth', 2);

%% form boundaries to conics
A1 =[ ellipse1.x.^2 ellipse1.x.*ellipse1.y ellipse1.y.^2 ellipse1.x ellipse1.y ones(size(ellipse1.x))];
[~,~,v1]=svd(A1);
cc1 = v1(:, end);
cc1 = cc1./norm(cc1);
[a1, b1, c1, d1, e1, f1] = deal(cc1(1),cc1(2),cc1(3),cc1(4),cc1(5),cc1(6));
C1=[a1 b1/2 d1/2; b1/2 c1 e1/2; d1/2 e1/2 f1];

A2 =[ ellipse2.x.^2 ellipse2.x.*ellipse2.y ellipse2.y.^2 ellipse2.x ellipse2.y ones(size(ellipse2.x))];
[~,~,v2]=svd(A2);
cc2 = v2(:, end);
cc2 = cc2./norm(cc2);
[a2, b2, c2, d2, e2, f2] = deal(cc2(1),cc2(2),cc2(3),cc2(4),cc2(5),cc2(6));
C2 =[a2 b2/2 d2/2; b2/2 c2 e2/2; d2/2 e2/2 f2];

%% sanity check
figure;
imshow(img); hold all;
%plot_conic(C1,[ellipse1.x, ellipse1.y]','r');
%plot_conic(C2,[ellipse2.x, ellipse2.y]','b');

%intersect ellipses
syms x y;

eq1 = a1*x^2 + b1*x*y + c1*y^2 + d1*x + e1*y + f1;
eq2 = a2*x^2 + b2*x*y + c2*y^2 + d2*x + e2*y + f2;

eqns = [eq1 ==0, eq2 ==0];
S = solve(eqns, [x,y]);

%% Solutions
s1 = [double(S.x(1));double(S.y(1));1];
s2 = [double(S.x(2));double(S.y(2));1];
s3 = [double(S.x(3));double(S.y(3));1];
s4 = [double(S.x(4));double(S.y(4));1];
II = s3;
JJ = s4;
imDCCP = II*JJ' + JJ*II';
imDCCP = imDCCP./norm(imDCCP);

%% compute the rectifying homography
[U,D,V] = svd(imDCCP);
D(3,3) = 1;
A = U*sqrt(D);
H = inv(A); % rectifying homography
tform = projective2d(H');
J = imwarp(img,tform);
figure;
imshow(J);
axis equal;
imwrite(J,'images/imgCirclesRectified.JPG');
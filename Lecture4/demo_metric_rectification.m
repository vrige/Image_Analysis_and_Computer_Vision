% Metric rectification from orthogonal lines
% perform metric rectification of an image. Given at least 5 pairs of image
% of orthogonal lines, the script finds the image of the dual conic to circular
% points and computes the homography that brings it back to its canonical form
clear;
close all;
img = imread('img1.png');
figure;
imshow(img);
numConstraints = 10; %>=5
hold all;

%%
fprintf('Draw 5 pairs of orthogonal segments\n');
count = 1;
A = zeros(numConstraints,6);

% select pairs of orthogonal segments
while (count <=numConstraints)
    figure(gcf);
    title(['Draw ', num2str(numConstraints),' pairs of orthogonal segments: step ',num2str(count) ]);
    col = 'rgbcmykwrgbcmykw';
    segment1 = drawline('Color',col(count));
    segment2 = drawline('Color',col(count));

    l = segToLine(segment1.Position);
    m = segToLine(segment2.Position);

    % each pair of orthogonal lines gives rise to a constraint on the image
    % of the dual conic of principal points imDCCP
    % [l(1)*m(1),0.5*(l(1)*m(2)+l(2)*m(1)),l(2)*m(2),0.5*(l(1)*m(3)+l(3)*m(1))
    %  0.5*(l(2)*m(3)+l(3)*m(2)), l(3)*m(3)]*v = 0
    % store the constraints in a matrix A
    A(count,:) = [l(1)*m(1),0.5*(l(1)*m(2)+l(2)*m(1)),l(2)*m(2),...
        0.5*(l(1)*m(3)+l(3)*m(1)),  0.5*(l(2)*m(3)+l(3)*m(2)), l(3)*m(3)];
    count = count+1;
end

%% Compute the imDCCP image of the dual conic to circular points
[~,~,v] = svd(A); %
% the following ones are the coefficents of the image of the dual conic 
% at inifinity
sol = v(:,end); %sol = (a,b,c,d,e,f)  [a,b/2,d/2; b/2,c,e/2; d/2 e/2 f];
% C_inifinity_*'
imDCCP = [sol(1)  , sol(2)/2, sol(4)/2;...
    sol(2)/2, sol(3)  , sol(5)/2;...
    sol(4)/2, sol(5)/2  sol(6)];

%% compute the rectifying homography
[U,D,V] = svd(imDCCP);
D(3,3) = 1; % since i need an invertible matrix
A = U*sqrt(D);

% c is the absolute conic of circular points
C = [eye(2),zeros(2,1);zeros(1,3)];
min(norm(A*C*A' - imDCCP),norm(A*C*A' + imDCCP))

H = inv(A); % rectifying homography
min(norm(H*imDCCP*H'./norm(H*imDCCP*H') - C./norm(C)),norm(H*imDCCP*H'./norm(H*imDCCP*H') + C./norm(C)))

%%
tform = projective2d(H');
J = imwarp(img,tform);

figure;
imshow(J);

%% rectify the image and show the result
function [l] = segToLine(pts)
% convert the endpoints of a line segment to a line in homogeneous
% coordinates.
%
% pts are the endpoits of the segment: [x1 y1;
%                                       x2 y2]

% convert endpoints to cartesian coordinates
a = [pts(1,:)';1];
b = [pts(2,:)';1];
l = cross(a,b);
l = l./norm(l);
end
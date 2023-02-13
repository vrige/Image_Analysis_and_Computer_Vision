%% homework Manuel Peracci 10824742 

% 1) extract the two lines and the two conics from the image
clc
clear;
close all;

img = imread('img1-homework.png');
figure;
imshow(img);
size_ = size(img);
hold on;
% a conic has only five degrees of freedom (not 6 because one is the scale 
% factor -> homogeneous matrix)

disp('click 5 points on the top conic, then enter');
%[x, y]=getpts;
x = [69,78,140,233,252]';
y = [158,132,119,125,150]';

FNT_SZ = 28;
text(x(1), y(1), 'a', 'FontSize', FNT_SZ, 'Color', 'b')
text(x(2), y(2), 'b', 'FontSize', FNT_SZ, 'Color', 'b')
text(x(3), y(3), 'c', 'FontSize', FNT_SZ, 'Color', 'b')
text(x(4), y(4), 'd', 'FontSize', FNT_SZ, 'Color', 'b')
text(x(5), y(5), 'e', 'FontSize', FNT_SZ, 'Color', 'b')

disp('click 5 points on the bottom conic, then enter');
%[x1, y1]=getpts;
x1 = [96,228,159,131,191]';
y1 = [304,311,301,309,313]';

FNT_SZ = 15;
text(x1(1), y1(1), 'a1', 'FontSize', FNT_SZ, 'Color', 'b')
text(x1(2), y1(2), 'b1', 'FontSize', FNT_SZ, 'Color', 'b')
text(x1(3), y1(3), 'c1', 'FontSize', FNT_SZ, 'Color', 'b')
text(x1(4), y1(4), 'd1', 'FontSize', FNT_SZ, 'Color', 'b')
text(x1(5), y1(5), 'e1', 'FontSize', FNT_SZ, 'Color', 'b')

%

A=[x.^2 x.*y y.^2 x y ones(size(x))]
A1=[x1.^2 x1.*y1 y1.^2 x1 y1 ones(size(x1))]
% A is 5x6: we find the parameter vector (containing [a b c d e f]) as the
% right null space of A.
% This returns a vector N such that A*N=0.  Note that this expresses the
% fact that the conic passes through all the points we inserted.
N = null(A);
N1 = null(A1);
% Let's assign the values to variables and build the 3x3 conic matrix (which is symmetrical)
cc = N(:, 1);
cc1 = N1(:, 1);
% change the name of variables
[apex b c d e f] = deal(cc(1),cc(2),cc(3),cc(4),cc(5),cc(6));
[a1 b1 c1 d1 e1 f1] = deal(cc1(1),cc1(2),cc1(3),cc1(4),cc1(5),cc1(6));
% here is the matrix of the conic: off-diagonal elements must be divided by two
C=[apex b/2 d/2; b/2 c e/2; d/2 e/2 f];
C1=[a1 b1/2 d1/2; b1/2 c1 e1/2; d1/2 e1/2 f1];
%
% We pick every pixel, and compute the incidence relation.
im=zeros(size_(1:2));
im1=zeros(size_(1:2));
for i=1:size_(1)
    for j=1:size_(2)
        im(i,j)=[j i 1]*C*[j i 1]'; % this is an algebraic error
        im1(i,j)=[j i 1]*C1*[j i 1]';
    end
end
%figure; imshow(im); title('Algebraic error');
%figure; imshow(im1); title('Algebraic error');
% Draw the conic 

% top ellipse
im_b =zeros(size_(1:2));
im_b(abs(im) <= 0.0011) = 1;
%imshow(im_b)
 
% bottom ellipse
im_b1 =zeros(size_(1:2));
im_b1(abs(im1) <= 0.00005) = 1;
%imshow(im_b1)
%scatter(x1,y1,100,'filled');

% merge of the two ellipse
merge = max(im_b1,im_b);
%figure(1), imshow(merge);
%hold on;

% points on l1 and l2
% column, row, homog
m = (find(max(im_b'), 1,"last") + find(max(im_b'), 1))/2;
L1 = [find(max(im_b), 1),m,1]';
L2 = [find(max(im_b), 1,"last"),m,1]';
L3 = [find(max(im_b1), 1),find(max(im_b1'), 1,"last")-12,1]';
L4 = [find(max(im_b1), 1,"last"),find(max(im_b1'), 1,"last")-2,1]';

%L_x = [L1(1),L2(1),L3(1),L4(1)]';
%L_y = [L1(2),L2(2),L3(2),L4(2)]';

%scatter(L_x,L_y,100,"filled")
figure(1), imshow(imfuse(img,double(merge)));
hold on;
plot([L1(1), L3(1)], [L1(2), L3(2)], 'w');
plot([L2(1), L4(1)], [L2(2), L4(2)], 'w');
hold off;

%% vanishing points are the result of the intersection of the two ellipses

syms x y;

eq1 = apex*x^2 + b*x*y + c*y^2 + d*x + e*y + f;
eq2 = a1*x^2 + b1*x*y + c1*y^2 + d1*x + e1*y + f1;

eqns = [eq1 ==0, eq2 ==0];
S = solve(eqns, [x,y]);

% Solutions
s1 = [double(S.x(1));double(S.y(1));1];
s2 = [double(S.x(2));double(S.y(2));1];
s3 = [double(S.x(3));double(S.y(3));1];
s4 = [double(S.x(4));double(S.y(4));1];
%%
II = s1;
JJ = s2;
imDCCP = II*JJ' + JJ*II'; % absolute conic
imDCCP = imDCCP./norm(imDCCP);

merge1 = merge;
merge1(merge == 1) = 0;
merge1(merge == 0) = 1;

figure(1), imshow(double(merge1));
hold on;
plot([L1(1), L3(1)], [L1(2), L3(2)], 'black');
plot([L2(1), L4(1)], [L2(2), L4(2)], 'black');

%%
line_inf = cross(II,JJ);
line_inf = line_inf/line_inf(3);
%plot([II(1), JJ(1)], [II(2), JJ(2)], 'b--');

t = -400:size_(2)+400;
e = -(line_inf(1)/line_inf(2))*t - line_inf(3)/line_inf(2);
plot(t,e,'b--') % horizon

%% 2. From 𝑙1, 𝑙2, 𝐶1, 𝐶2 find the image projection 𝑎 of the cone axis.
% a is the line that passes through both the centers of the two ellipses and the
% apex

% l1 and l2 vectors
l1 = cross(L1,L3);
l2 = cross(L2,L4);

% cone apex
apex = cross(l1,l2);
apex = apex/apex(3);

scatter(apex(1),apex(2),100,"filled");
plot([L3(1), apex(1)], [L3(2), apex(2)], 'r');
plot([L4(1), apex(1)], [L4(2), apex(2)], 'r');

% ellipses' centers
elips_c = [(L1(1)+L2(1))/2,(L1(2)+L2(2))/2,1];
elips_c1 = [(L3(1)+L4(1))/2,(L3(2)+L4(2))/2,1];
scatter(elips_c(1),elips_c(2),30,"filled");
scatter(elips_c1(1),elips_c1(2),30,"filled");

% cone axis
cone_axis = cross(elips_c,elips_c1);

% checking if a belongs to the cone axis
cone_axis * elips_c'; % 0
cone_axis * elips_c1';  % 0
%cone_axis * apex'; %-495 -> nope

plot([elips_c(1), apex(1)], [elips_c(2), apex(2)], 'r');
plot([elips_c1(1), apex(1)], [elips_c1(2), apex(2)], 'r');
% however, checking it in the plot, it passes through

%% 3. From 𝑙1, 𝑙2, 𝐶1, 𝐶2 (and possibly ℎ and 𝑎), find the calibration matrix 𝐾
% we first need to find the image of the absolute conic
% it is a symmetric matrix 3x3, so it has 6 constraints
% but we can reduce them to 4 constraints because it has squared pixels
% fx=fy and it is a natural camera s= 0. In this case w11 = w22 and
% w12=w21=0
% then, we need to find other 4 constraints

ellips_big_ax = cross(L1,L2);
ellips_big_ax_1 = cross(L3,L4);

ellips_big_ax = ellips_big_ax/ellips_big_ax(3);
ellips_big_ax_1 = ellips_big_ax_1/ellips_big_ax_1(3);

ellips_sma_ax = [-ellips_big_ax(2),ellips_big_ax(1),1];
ellips_sma_ax_1 =[-ellips_big_ax_1(2),ellips_big_ax_1(1),1];

% all these vanishing points are perpendicular to the cone axis (VP5)
VP1 = cross(ellips_big_ax,line_inf);
VP2 = cross(ellips_sma_ax,line_inf);
VP3 = cross(ellips_big_ax_1,line_inf);
VP4 = cross(ellips_sma_ax_1,line_inf);
VP5 = cross(cone_axis,line_inf);

VP1 = VP1/VP1(3);
VP2 = VP2/VP2(3);
VP3 = VP3/VP3(3);
VP4 = VP4/VP4(3);
VP5 = VP5/VP5(3);

% plotting them
scatter(VP1(1),VP1(2),30,"filled");
scatter(VP2(1),VP2(2),30,"filled");
scatter(VP3(1),VP3(2),30,"filled");
scatter(VP4(1),VP4(2),30,"filled");
scatter(VP5(1),VP5(2),30,"filled");

%%
% w = | w1  w2  w4 |
%     | w2  w3  w5 |
%     | w4  w5  w6 |
syms w [6 1];

% we are going to set all the constraints in the form a^T w = 0
eq1 = w(2); % natural camera
eq2 = w(1); % squared pixels
% a = (v1u1, v1u2 + v2u1, v2u2, v1u3 + v3u1, v2u3 + v3u2, v3u3)^T
eq3 = perpendConstraint(VP1,VP5) * w;
eq4 = perpendConstraint(VP2,VP5) * w;
eq5 = perpendConstraint(VP3,VP5) * w;
eq6 = perpendConstraint(VP4,VP5) * w;
eqns = [eq1 == 0, eq2 == w(3), eq3 == 0, eq4 == 0, eq5 == 0, eq6 == 0];
S = solve(eqns, w);

% w = | w1  w2  w4 |
%     | w2  w3  w5 |
%     | w4  w5  w6 |
w_img = [S.w1,S.w2,S.w4;S.w2,S.w3,S.w5;S.w4,S.w5,S.w6];
% w_inv = inv(w_img);
% K = chol(w_inv);

%%

% aT w = 0 and uT ω v = 0,
% u = (u1, u2, u3)T  and v = (v1, v2, v3)T
% a = (v1u1, v1u2 + v2u1, v2u2, v1u3 + v3u1, v2u3 + v3u2, v3u3)^T
function a = perpendConstraint(v,u)
    a = [v(1)*u(1), v(1)*u(2)+v(2)*u(1), v(2)*u(2), v(1)*u(3)+v(3)*u(1), v(2)*u(3)+v(3)*u(2), v(3)*u(3)];
end






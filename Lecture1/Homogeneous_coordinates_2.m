clear
close all
clc

figure(1), imshow(imread('simplecube-letters.png'));
FNT_SZ = 28;

%%
figure(2),
imshow(imread('buildingSmall.png'))
% imshow(imread('cube.jpeg'))
hold on;
[x y]=getpts
plot(x,y,'.w','MarkerSize',12, 'LineWidth', 3); % plots points clicked by user with red circles
a=[x(1) y(1) 1]';
text(a(1), a(2), 'a', 'FontSize', FNT_SZ, 'Color', 'w')
b=[x(2) y(2) 1]';
text(b(1), b(2), 'b', 'FontSize', FNT_SZ, 'Color', 'w')
c=[x(3) y(3) 1]';
text(c(1), c(2), 'c', 'FontSize', FNT_SZ, 'Color', 'w')
e=[x(4) y(4) 1]';
text(e(1), e(2), 'e', 'FontSize', FNT_SZ, 'Color', 'w')
%%
% Finding some lines
lab=cross(a,b)
lac=cross(a,c)
lae=cross(a,e)

%%

% check the indexes
lab'*a
lab'*b
lac'*a
lac'*c
lae'*a
lae'*e
%% We now need to compute the line parallel to ab and passing through c. In order to do this, we create the line at infinity:

linf=[0 0 1]';

%%

dab=cross(lab,linf)
dac=cross(lac,linf)
dae=cross(lae,linf)

%%

lbd=cross(b,dac);
lcd=cross(c,dab);

%%

d=cross(lbd,lcd);


%%
computeEuclideanAngles(lab, lac) % 45 degrees
computeEuclideanAngles(lab, lcd) % parallel
computeEuclideanAngles(lab, lad) % orghogonal

%%

lambda = rand(1);
mu = 1- lambda; % this is a convex combination. So points will be in between the two. The result holds for any combination

p = lambda * a + mu * b;
p' * lab

p = p/p(3);
text(p(1), p(2), 'p', 'FontSize', FNT_SZ, 'Color', 'b')

%%

vac = cross(lab, lcd)
vac = vac / vac(3) % look at this point, isn't it strange? It is a point at the infinity!
vab = cross(r1, r500)
vad = cross(c1, c500)

hold off

%%

function angle = computeEuclideanAngles(l_a, l_b)
    %COMPUTEEUCLIDEANANGLES Returns the angle between two lines
    %   Given two lines, the function returns the angle between them
    angle = acos((l_a(1)*l_a(2)+l_b(1)*l_b(2))/(sqrt((l_a(1)^2+l_b(1)^2)*(l_a(2)^2+l_b(2)^2))));
    angle = 180*angle/pi;
end
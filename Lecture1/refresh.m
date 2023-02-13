% this is a refresh of matlab fro Boracchi's page
close all
clear
clc

disp('For enquiry, please send an email to giacomo.boracchi@polimi.it');
fprintf('there is also a C-like printing function\n%s %dst, %d', 'October', 1, 2018);
%%
% variables are created by assignements
v = 3
c = 'k'
size(v)

% use ; at the end of instruction not to display results
% in command line
v = 7;

%% data types are automatically defined depending on the
% assigned value
whos v

%% variables have datatypes (usually you can forget,
% but not when dealing with images).  Most common types we
% will consider are:
% . double,(i.e. double-precision floating point),
% . uint8 (i.e. unsigned integers with 8 bits, [0 255] range),
% . logical (i.e. boolean)

%
% casting to 8-bit integers
v = uint8(v)
whos v

%% ARRAYs
r=[1, 2, 3, 4]
size(r)

% a column vector
c=[1; 2; 3; 4]
size(c)

%% you can define vectors by regular increment operator
% [start : step : end]
a = [1 : 2 : 10];

% when omitted, step is equal to 1
a = [1 : 10];

%% a matrix
v=[1 2; 3 4]
size(v)

%array conatenation
B=[v', v']

C = [v ; v]

%% this is not allowed
disp('K = [r,c]: this is not allowed')
%K = [r,c]

dim = size(C)

% other examples of array concatenation
my_vec1 = [1 2 3];
my_vec2 = 4:6;

my_matrix = [my_vec1; my_vec2]
size(my_matrix)

my_long_vector = [my_vec1 my_vec2]
size(my_long_vector)

%% C = cat(dim,A,B) concatenates B to the end of A along dimension dim when A and B have compatible sizes
my_matrix = cat(1,my_vec1,my_vec2)
my_long_vector = cat(2,my_vec1,my_vec2)

my_3d_matrix = cat(3,my_vec1,my_vec2)
size(my_3d_matrix)

%%
my_vec = (1:10)';
my_vec(1)

my_matrix = [1:4;5:8;9:12];

my_matrix(3,2)

%% coumn-wise linear indexing for matrices
my_matrix(6)

% you can reference single or multiple values in an array:
v(1,2) % first row and second column (row and column indices are 1-based)
v(:,2) % the second column of v
v(1,:) % the first row
B(:,2:4) % some of the columns
v(5,5) = 10 % you can extend vectors / matrices by assigning some element our of the range

my_matrix(1:3,3:4)

my_matrix(1:3,[2 4])

my_matrix(1:end,[2 4])

my_matrix(:,[2 4])

my_matrix(1:2,[2 4])

my_matrix(1:end-1,[2 4])

my_vector = my_matrix(:)

% operation on vectors are from linear algebra
v*v'

[1 2 3].*[4 5 6]

[1 2 3] + 5
[1 2 3] * 2 % no need to use element-wise operator with scalars
[1 2 3] .* 2 %explicit element-wise multiplication
[1 2 3] / 2
[1 2 3] ./ 2 %explicit element-wise division
[1 2 3] .^ 2 %explicit element-wise power

[1 2 3] * [4 5 6]' % this matrix product, returns a scalar (it is the inner product)

[1 2 3]' * [4 5 6] % this is the matrix product, returns a 3 x 3 matrix

%% rounding functions
ceil(10.56)
floor(10.56)
round(10.56)

ceil(0:0.1:1)

%% arithmetic functions
sum([1 2 3 4])
sum([1:4;5:8])
sum([1:4;5:8],2)

sum(sum([1:4;5:8]))

my_matrix = [1:4;5:8];
sum(my_matrix(:))

disp('Hello World!');
disp(['Hello ', 'World!']);

% string concatenation in printf.
disp(['number of columns in the matrix: ', num2str(size(my_matrix))]);

fprintf('number of columns in the matrix: %f\n',size(my_matrix,2));

b=v>2
whos b
function [F] = fit_fm(X)
%FIT_FM wrapper of the fund_lin function

m1 = X(1:2,:);
m2 = X(4:5,:);

F = fund_lin(m1,m2);
end


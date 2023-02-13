function [resi] = res_fm(F,x)
%RES_FM wrapper of the sampson_fund distance

m1 = x(1:3,:);
m2 = x(4:6,:);
resi = sampson_fund(F,m1,m2);
end


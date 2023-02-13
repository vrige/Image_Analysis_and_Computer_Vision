function [d] = dist_circle(param,X)
%DIST_CIRCLE Summary

center = param(1:2);
radius = param(3);


d= sqrt(sum((X - center).^2,1))-radius;

end


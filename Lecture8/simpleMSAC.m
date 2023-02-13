function [bestinliers, bestmodel] = simpleMSAC(x,modelfit, modeldist, p, t)
%simpleMSAC robust regression
% Input:
%      - x: data points
%      - modelfit: a function that fits the model on the data (with weights)
%      - modeldist: a function that evaluate the data-model distance
%      - p: the size of the minimum sample set
% Options are:
%      - MSAC: RANSAC improvement (provide inlier threshold)


n = size(x,2);
alpha = 0.99; % Desired probability of success
f = 0.1 ;     % Pessimistic estimate of inliers fraction

MaxIterations = 10000; % Max number of iterations
MinIterations = 1000;  % Min number of iterations
mincost =  Inf;

i = 0;
while  i < max(ceil(log(1-alpha)/log(1-f^p)), MinIterations)
    
    % Generate p random indicies in the range 1..n
    mss = randsample(n, p);
    
    % Fit model to this minimal sample set.
    model = modelfit(x(:,mss));
    
    % Evaluate distances between points and model
    sqres = modeldist(model, x).^2;
    inliers = sqres < (t^2);
    
    % Compute MSAc score
    cost = (sum(sqres(inliers)) + (n -sum(inliers)) * t^2);
    
    if cost < mincost
        mincost = cost;
        bestinliers = inliers;
        bestmodel = model;
        % Update the estimate of inliers fraction
        f = sum(bestinliers)/n;
    end
    i = i + 1;
    if (i > MaxIterations)
        break;
    end
end

end



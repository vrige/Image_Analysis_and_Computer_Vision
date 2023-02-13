function  [rs] = sampson_fund(F,m1,m2)
    %SAMPSON_FUND Sampson residual for F (and its Jacobian)
    
    m1=ensure_homogeneous(m1);
    m2=ensure_homogeneous(m2);
    Q = [1 0; 0 1; 0 0];
    rs = [];
    for i = 1:size(m1,2)
       ra = m2(:,i)'*F*m1(:,i); % algebraic residual
        
        v = [ m2(:,i)'*F*Q , m1(:,i)'*F'*Q ];   c = 1/(v*v');
        rs = [rs; norm(-v'*c * ra)];   % Sampson residual
    end
end


% Returns the sampson resisual, a 4-vector whose norm is an
% approximation of the distance from the 4d joint-space point
% [m1;m2] to the F manifold.
%
% Note: there are 4 residuals for each point

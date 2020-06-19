load dataForHyper3

posSum = sum(labels>0);
negSum = sum(labels<0);

for i=1:1:length(labels)
    if labels(i)>0
        labels(i) = 1/posSum;
    end
    if labels(i)<0
        labels(i) = -1/negSum;
    end
end

C = zeros(n_v,n_v);

for i=1:1:length(labels)
    if labels(i)~=0
        C(i,i) = 1;
    end
end



%before the first step
f = labels;
b = (1-alpha)*C'*labels;
cost = inf;
cost_crurrent = 10000;


% to get m
dv = diag(Dv);
de = diag(De);
m = zeros(n_e,1);
% get m
for ind_e = 1:1:n_e
    % in each e, compute 0.5* sum( f(u)/sqrt(d(u)) - f(v)/sqrt(d(v)) )./d_{e}'
    currentE = H(:,ind_e);
    Poses = find(currentE>0);
    sum_e = 0;
    for ind_pos = 1:1:length(Poses)
        for tempind = 1:1:length(Poses)
            sum_e = sum_e + (f(Poses(ind_pos))/sqrt(dv( Poses(ind_pos) ))  - f(Poses(tempind))/sqrt(dv( Poses(tempind) )))^2;
        end
    end
    m(ind_e) = 0.5*sum_e/de(ind_e);
end

laplacian = eye(n_v) - Dv^(-0.5)*H*W*De^(-1)*H'*Dv^(-0.5);
w = diag(W);
cost1 = f'*laplacian*f
cost2 = mu*sum((f-labels).^2)
cost3 = 0.5*w'*Q*w + m'*w
cost_crurrent = cost1 + cost2 + cost3;

dif = 1.e-8;
tol = 1.e-8;
maxiter = 1000;

iters = 1;

%while cost-cost_crurrent>dif
while 1
    cost = cost_crurrent;
    % the first step
    A = (1-alpha)*C'*C + alpha*laplacian;
    X = f;
    [X, relerr, niter] = jacobi(A, X, b, tol, maxiter);
    f = X(:,end);
    
    %the second step: quadratic programming
    %x = quadprog(H,m,A,b,Aeq,beq,lb,ub) returns a vector x that minimizes 1/2*x'*Q*x + m'*x
    %it defines a set of lower and upper bounds on the design variables, x, so
    %that the solution is in the range lb ? x ? ub
    %it solves the preceding problem satisfying the equality constraints Aeq*x = beq
    
    %our problem is: argmin_{w} Omega(f_{t},w) + rho* Psi(w)
    %where Omega(f_{t},w) = 0.5* sum( f(u)/sqrt(d(u)) - f(v)/sqrt(d(v)) )
    %./d_{e}'  * w_{e}, where we need to compute m
    %where Psi(w) = w^{T}* ( I - D_{sigma}^{-0.5}*A*D_{sigma}^(-0.5) ) *w  +
    % w^{T}* ( I - D_{sigma}^{-1}*A )( I - D_{sigma}^{-1}*A )^{T} *w
    % notice that here A is different with above A
    %we set rho = 1.
    
    % to get m
    dv = diag(Dv);
    de = diag(De);
    m = zeros(n_e,1);
    % get m
    for ind_e = 1:1:n_e
        % in each e, compute 0.5* sum( f(u)/sqrt(d(u)) - f(v)/sqrt(d(v)) )./d_{e}'
        currentE = H(:,ind_e);
        Poses = find(currentE>0);
        sum_e = 0;
        for ind_pos = 1:1:length(Poses)
            for tempind = 1:1:length(Poses)
                sum_e = sum_e + (f(Poses(ind_pos))/sqrt(dv( Poses(ind_pos) ))  - f(Poses(tempind))/sqrt(dv( Poses(tempind) )))^2;
            end
        end
        m(ind_e) = 0.5*sum_e/de(ind_e);
    end
    
    w = quadprog(Q,m,[],[],H,dv,0,inf);
    
    %update laplacian
    W = diag(w);
    laplacian = eye(n_v) - Dv^(-0.5)*H*W*De^(-1)*H'*Dv^(-0.5);
    cost1 = f'*laplacian*f
    cost2 = mu*sum((f-labels).^2)
    cost3 = 0.5*w'*Q*w + m'*w
    
    cost_crurrent = cost1+cost2+cost3
    
    iters = iters+1;
end
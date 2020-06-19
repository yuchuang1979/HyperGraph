function [X, relerr, niter] = jacobi(A, X, b, tol, maxiter)
%tol = 1.e-8; % preset tolerance (10?8)
%maxiter = 100; % maximum number of iterations
relerr = inf; % initialize relative error to large value
niter = 1; % initialize iteration counter
S = diag( diag(A) ); % diagonal of A
T = S - A; % off-diagonal of A
%X(:,1) = zeros(size(b)); % initial guess (x = 0)
%X(:,1) = b;
while relerr > tol & niter< maxiter, % iterate until convergence, or maximum iterations
X(:,niter+1) = S \ (b+T*X(:,niter));
relerr = norm(X(:,niter+1)-X(:,niter),inf)/norm(X(:,niter+1),inf);
niter = niter+1; % increment iteration counter
end
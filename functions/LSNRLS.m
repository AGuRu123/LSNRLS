%% min_{\theta,M,H,E} 1/2*||H*Y - \theta*X||_F^2 + \alpha*tr(HM^TM) + \beta*tr(KM^TM) + \lambda_1||\theta||_1 
%% + \lambda_2||E||_1 + \lambda_3||H||_1
%% s.t. E = Y - HY, H>=0, M = \theta o \theta

function [model,convergence] = LSNRLS(X,Y,optmParameter)
%X:d*n
%Y:q*n
%model:d*q
%initial M = theta.*theta
[d,n] = size(X);
[q,~] = size(Y);
Y = max(Y,0);
K = pdist2(X, X, 'cosine');
K(isnan(K))=0;K = max(K,0);
rho = optmParameter.rho;
mu = optmParameter.mu;
maxIter = optmParameter.maxIter;
tol = optmParameter.tol;
convergence = zeros(1,maxIter);

lambda_1 = optmParameter.lambda_1;
lambda_2 = optmParameter.lambda_2;
lambda_3 = optmParameter.lambda_3;
alpha = optmParameter.lambda_4;
beta = optmParameter.lambda_5;
rhoMax = optmParameter.rhoMax;

XXT = X*X';
YXT = Y*X';
theta = (YXT) / (XXT+ 0.1*eye(d));
M = theta.*theta; W = zeros(size(theta));
phi_1 = zeros(size(theta));psi_1 = zeros(size(theta));
E = zeros(q,n); 
H = zeros(q,q);%
J = zeros(size(H));
phi_2 = zeros(size(E));psi_2 = zeros(size(H));
B = (H+H')/2;
B = mapminmax(B,0,1);
B = 1 - B;
for i = 1:maxIter
    grad_theta = theta*XXT - H*YXT + 2*rho*(theta.*theta - M - phi_1/rho).*theta...
       +rho*(theta-W+psi_1/rho);
    grad_M = rho*(M-theta.*theta +phi_1/rho) + 2*alpha*B*M + 2*beta*M*K;
    grad_H = rho*(H*Y-Y+E-phi_2/rho)*Y'+rho*(H-J+psi_2/rho);
    %% Calculate theta
    theta = theta - calcTheta(theta,grad_theta,H,Y,X,M,phi_1,W,psi_1,rho)*grad_theta;
    %% Calculate W
    W = softthres(theta+psi_1/rho,lambda_1/rho);
    %% Calculate M
    M = M - calcM(M,grad_M,theta,phi_1,B,K,rho,alpha,beta)*grad_M;    
    M = max(M,0);
    %% Calculate E
    E = softthres(Y+phi_2/rho-H*Y,lambda_2/rho);
    %% Calculate H and B
    H = H - calcH(H,grad_H,Y,E,phi_2,J,psi_2,rho)*grad_H;
    H = max(H,0);
    B = (H+H')/2;
    B = mapminmax(B,0,1);
    B = 1 - B;
    %% Calculate J
    J = softthres(H+psi_2/rho,lambda_3/rho);
    %% Calculate dual variables
    phi_1 = phi_1 + rho*(M-theta.*theta);
    phi_2 = phi_2 + rho*(Y-H*Y-E);
    psi_1 = psi_1 + rho*(theta-W);
    psi_2 = psi_2 + rho*(H-J);
    rho = min(rho * mu,rhoMax);
    %% 
    MainLoss = 0.5*norm(H*Y-theta*X,'fro')^2;
    labelCorr = alpha*trace(B*M*M');
    FeaCorr = beta*trace(K*M'*M);
    R1 = lambda_1*norm(theta,1);
    R2 = lambda_2*norm(Y-H*Y,1);
    R3 = lambda_3*norm(H,1);
    
    ALoss = [MainLoss;FeaCorr;labelCorr;R1;R2;R3];
    convergence(i) = sum(ALoss);

    if i>1    
        fprintf('iteration: %d loss: %.6f value: %.6f \n ',...
            i, abs(convergence(i) - convergence(i-1)), convergence(i));
        if abs(convergence(i) - convergence(i-1)) <= tol * abs(convergence(i))
                break;
        end
    end
    if i>maxIter
        fprintf('exceed maximum iterations\n');
        break;  
    end
end
    plot(1:i,convergence(1:i));
    model = W';    
end
function W = softthres(W_t,lambda)
    W = max(W_t-lambda,0) - max(-W_t-lambda,0);
end
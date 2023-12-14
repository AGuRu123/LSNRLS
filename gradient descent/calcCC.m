function [stepsize] = calcCC(theta,grad_theta,H,Y,X,W,Y_1,rho,alpha,beta,B,K)
    c = 0.1;
    stepsize = 1;
    thetaN = theta - stepsize*grad_theta;
    oldobj = 0.5*norm(H*Y-theta*X,'fro')^2 + 2*alpha*B*theta + 2*beta*theta*K + ...
    0.5*rho*norm(theta-W+Y_1/rho,'fro')^2;
    newobj = 0.5*norm(H*Y-thetaN*X,'fro')^2 + 2*alpha*B*thetaN + 2*beta*thetaN*K + ...
    0.5*rho*norm(thetaN-W+Y_1/rho,'fro')^2;
    if newobj - oldobj > c*sum(sum(grad_theta.*(thetaN-theta)))
        while true
            stepsize = stepsize*0.1;  % armijo rule
            thetaN = theta - stepsize*grad_theta;
            newobj = 0.5*norm(H*Y-thetaN*X,'fro')^2 + 2*alpha*B*thetaN + 2*beta*thetaN*K + ...
            0.5*rho*norm(thetaN-W+Y_1/rho,'fro')^2;
            if newobj - oldobj <= c*sum(sum(grad_theta.*(thetaN-theta)))+eps
                break;
            end
        end
    else
        return;
    end
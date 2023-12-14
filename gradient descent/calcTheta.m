function [stepsize] = calcTheta(theta,grad_theta,H,Y,X,M,phi_1,W,Y_1,rho)
    c = 0.1;
    stepsize = 1;
    thetaN = theta - stepsize*grad_theta;
    oldobj = 0.5*norm(H*Y-theta*X,'fro')^2 + 0.5*rho*norm(M-theta.*theta+phi_1/rho,'fro')^2 + ...
    0.5*rho*norm(theta-W+Y_1/rho,'fro')^2;
    newobj = 0.5*norm(H*Y-thetaN*X,'fro')^2 + 0.5*rho*norm(M-thetaN.*thetaN+phi_1/rho,'fro')^2 + ...
    0.5*rho*norm(thetaN-W+Y_1/rho,'fro')^2;
    if newobj - oldobj > c*sum(sum(grad_theta.*(thetaN-theta)))
        while true
            stepsize = stepsize*0.1;  % armijo rule
            thetaN = theta - stepsize*grad_theta;
            newobj = 0.5*norm(H*Y-thetaN*X,'fro')^2 + 0.5*rho*norm(M-thetaN.*thetaN+phi_1/rho,'fro')^2 + ...
            0.5*rho*norm(thetaN-W+Y_1/rho,'fro')^2;
            if newobj - oldobj <= c*sum(sum(grad_theta.*(thetaN-theta)))+eps
                break;
            end
        end
    else
        return;
    end
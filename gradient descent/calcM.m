function [stepsize] = calcM(M,grad_M,theta,phi_1,B,K,rho,alpha,beta)
    c = 0.1;
    stepsize = 1;
    Mn = M - stepsize*grad_M;
    oldobj = 0.5*rho*norm(M-theta.*theta+phi_1/rho,'fro')^2 + alpha*trace(B*M*M') + beta*trace(K*M'*M);
    newobj = 0.5*rho*norm(Mn-theta.*theta+phi_1/rho,'fro')^2 + alpha*trace(B*Mn*Mn') + beta*trace(K*Mn'*Mn);
    if newobj - oldobj > c*sum(sum(grad_M.*(Mn-M)))
        while true
            stepsize = stepsize*0.1;  % armijo rule
            Mn = M - stepsize*grad_M;
            newobj = 0.5*rho*norm(Mn-theta.*theta+phi_1/rho,'fro')^2 + alpha*trace(B*Mn*Mn') + beta*trace(K*Mn'*Mn);
            if newobj - oldobj <= c*sum(sum(grad_M.*(Mn-M)))+eps
                break;
            end
        end
    else
        return;
    end
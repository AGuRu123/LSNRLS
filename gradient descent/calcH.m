function [stepsize] = calcH(H,grad_H,Y,E,phi_2,J,Y_2,rho)
    c = 0.1;
    stepsize = 1;
    Hn = H - stepsize*grad_H;
    oldobj = 0.5*rho*norm(Y-H*Y-E+phi_2/rho,'fro')^2 + 0.5*rho*norm(H-J+Y_2/rho,'fro')^2;
    newobj = 0.5*rho*norm(Y-Hn*Y-E+phi_2/rho,'fro')^2 + 0.5*rho*norm(Hn-J+Y_2/rho,'fro')^2;
    if newobj - oldobj > c*sum(sum(grad_H.*(Hn-H)))
        while true
            stepsize = stepsize*0.1;  % armijo rule
            Hn = H - stepsize*grad_H;
            newobj = 0.5*rho*norm(Y-Hn*Y-E+phi_2/rho,'fro')^2 + 0.5*rho*norm(Hn-J+Y_2/rho,'fro')^2;
            if newobj - oldobj <= c*sum(sum(grad_H.*(Hn-H)))+eps
                break;
            end
        end
    else
        return;
    end
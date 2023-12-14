function [optmParameter,modelparameter] = tuneParameter
    optmParameter.lambda_1 = 2^-5;%model parameter regularization                                 
    optmParameter.lambda_2 = 2^5;%label noise sparse regularization                   
    optmParameter.lambda_3 = 2^-5;%label correlation regularization                                
    optmParameter.lambda_4 = 2^-5;%manifold for label correlation alpha                           
    optmParameter.lambda_5 = 2^-3;%manifold for feature correlation beta                    
    optmParameter.rho = 0.5; % 
    optmParameter.mu = 1.01;%
    optmParameter.rhoMax = 3;%
    optmParameter.maxIter = 500; 
    optmParameter.tol = 1e-4;
    
    optmParameter.minimumLossMargin = 0.001;
    optmParameter.tune = 1;
    %% Model Parameters
    modelparameter.cv_num             = 5;% 5 or 10? %%
    modelparameter.split = 0.8;
    modelparameter.L2Norm             = 1; % {0,1}
    modelparameter.addOneColume = 1;
end

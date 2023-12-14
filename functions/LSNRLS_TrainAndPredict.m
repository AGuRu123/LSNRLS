function [Outputs,predict_target,time,convergence] = LSNRLS_TrainAndPredict(cv_train_data, cv_train_target,cv_real_target,cv_test_data,optmParameter)
% cv_train_data   : n by d data matrix
% cv_train_target : n by l label matrix
    start = tic;
    [W,convergence] = LSNRLS(cv_train_data',cv_train_target',optmParameter);
    Outputs = cv_test_data*W;
    Outputs = Outputs';
    if optmParameter.tune == 1
        [tau] = TuneThreshold((cv_train_data*W)', cv_real_target');
        predict_target = Predict(Outputs,tau);
    else    
        predict_target  = (Outputs>= 0.5);    
    end
    predict_target  = double(predict_target);
    time = toc(start);
end


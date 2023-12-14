clear all
clc
                                                                                                                                                                                                                                                                                            
addpath(genpath('.'));
NameList = {'emotions'};

ratio = [0.5 1 1.5];
for i = 1:length(NameList)
    name = NameList{i};
    mkdir([pwd '\\' name '\\']);%
    load ([name '.mat']);
    [optmParameter,modelparameter] = tuneParameter;
    if exist('train_data','var')==1
        data=[train_data;test_data];
        target=[train_target,test_target];
        clear train_data test_data train_target test_target
    end
    if exist('dataset','var')==1
        data=dataset;
        target=class;
        clear dataset class
    end    
    %% Normalization
    data  = double(data);
    temp_data = data + eps;
    num_data = size(data,1);
    if modelparameter.L2Norm == 1
        temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,1)),size(temp_data,1),1);
        if sum(sum(isnan(temp_data)))>0
            temp_data = temp_data+eps;
            temp_data = temp_data./repmat(sqrt(sum(temp_data.^2,1)),size(temp_data,1),1);
        end
    end
    
    if modelparameter.addOneColume
        temp_data = [temp_data,ones(num_data,1)];
    end
       
    Result_LSNRLS = zeros(15,modelparameter.cv_num);
    for k = ratio
        modelparameter.noisy_ratio = k;
        for j = 1:modelparameter.cv_num
            fprintf('Running Fold - %d/%d \n',j,modelparameter.cv_num);
            %% the training and test parts are generated by fixed spliting with the given random order
            [cv_train_data,cv_test_data,cv_train_target,cv_real_target,cv_test_target] = sampletool(temp_data,target',modelparameter);
            %% evaluation of LNRLS
            [Outputs, predict_target] = LSNRLS_TrainAndPredict(cv_train_data, cv_train_target,cv_real_target,cv_test_data,optmParameter);
            Result_LSNRLS(:,j) = EvaluationAll(predict_target,Outputs,cv_test_target');
        end
        %% the average results of LSNRLS  
        Avg_LSNRLS = zeros(15,2);
        Avg_LSNRLS(:,1)=mean(Result_LSNRLS,2);
        Avg_LSNRLS(:,2)=std(Result_LSNRLS,1,2);
        
        save([pwd '\\' name '\\' name  num2str(k) '.mat'],'Avg_LSNRLS');

  end   

end









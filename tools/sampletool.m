function [x,xt,y_p,y,yt]=sampletool(X,Y,modelparameter)
% Y = Y';
% Y_P = Y_P';
% % generate the train and the test by the split ratio and generate different types of noisy
% labels

[n,~]=size(Y);
number=ceil(n*modelparameter.split);

rand=randperm(n);
L_index=rand(1:number);
U_index=rand(number+1:n);
x=X(L_index,:);
xt=X(U_index,:);
y=Y(L_index,:);
yt=Y(U_index,:);
y_p = random_noisy(y,modelparameter.noisy_ratio);
end

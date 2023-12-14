function [y_noisy, noisy_nums] = random_noisy(y,noisy_ratio)%
% x :n*d
% y: n*q
% Produce the random noise
y_noisy=y;
N = size(y,1);
noisy_nums=zeros(N,1);
Num = length(find(y==1));
TotalNum = floor(noisy_ratio*Num);
cnt = 0;
while TotalNum>0&&cnt<N
    cnt = 0;
    for i=1:N
        
        u_idx=find(y_noisy(i,:)~=1);  %
        U_num=length(u_idx);
        if U_num > 1
            rand_idx=randperm(U_num);
            rand_label= u_idx(rand_idx(1));
            y_noisy(i,rand_label)=1;
            TotalNum = TotalNum - 1;
            noisy_nums(i)=noisy_nums(i)+1;
            if TotalNum == 0
                break;
            end

        elseif U_num ==1  
            y_noisy(i,u_idx)=1;
            TotalNum = TotalNum - 1;
            noisy_nums(i)=noisy_nums(i)+1;
            if TotalNum == 0
                break;
            end
        else
            cnt = cnt + 1;
        end
        
    end
    
end
    
end



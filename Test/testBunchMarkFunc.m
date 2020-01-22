% 测试脚本
clear all;
close all;

% BA算法参数
Iter  = 200;
P     = 60;
D     = 5;
Bound = [-10,10;-10,10;-10,10;-10,10;-10,10;];

% 显示参数
testNum      = 16;                      % 测试总次数
figurePerRow = round(sqrt(testNum));    % 一行画多少个图最好看

% 收敛过程图像显示
if testNum > 16
    graphFlg = 0;
else
    graphFlg = 1;
end

% 实际最优解 计算收敛成功率用
x_best = [zeros(1,D); zeros(1,D); ones(1,D); zeros(1,D); zeros(1,D)];

 % 选择测试的bunchmark function
for BMselect=[1]
	if graphFlg == 1
        figure();
    end
        
	cnt = 0;
	for i=1:testNum
        [Sol,Rst] = dBA(D,Iter,P,[0,2],0.9,0.9,Bound,BMselect);
            
        % 根据与最优解距离判断是否搜索成功
        if norm(x_best(BMselect,:) - Sol) < norm(ones(1,D) * 0.1)
            cnt = cnt + 1;
        end

        if graphFlg == 1
        % 显示迭代过程
            subplot(round(testNum / figurePerRow), figurePerRow,i),plot(Rst(5:Iter,1),'g');
            hold on;
            subplot(round(testNum / figurePerRow), figurePerRow,i),plot(Rst(5:Iter,2),'b');
            subplot(round(testNum / figurePerRow), figurePerRow,i),plot(Rst(5:Iter,3),'c');
            subplot(round(testNum / figurePerRow), figurePerRow,i),plot(Rst(5:Iter,P + 1),'r');
            xlabel(Rst(Iter,P+1));
            hold off;
        end
	end
    cnt
end


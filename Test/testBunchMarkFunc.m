% ���Խű�
clear all;
close all;

% BA�㷨����
Iter  = 200;
P     = 60;
D     = 5;
Bound = [-10,10;-10,10;-10,10;-10,10;-10,10;];

% ��ʾ����
testNum      = 16;                      % �����ܴ���
figurePerRow = round(sqrt(testNum));    % һ�л����ٸ�ͼ��ÿ�

% ��������ͼ����ʾ
if testNum > 16
    graphFlg = 0;
else
    graphFlg = 1;
end

% ʵ�����Ž� ���������ɹ�����
x_best = [zeros(1,D); zeros(1,D); ones(1,D); zeros(1,D); zeros(1,D)];

 % ѡ����Ե�bunchmark function
for BMselect=[1]
	if graphFlg == 1
        figure();
    end
        
	cnt = 0;
	for i=1:testNum
        [Sol,Rst] = dBA(D,Iter,P,[0,2],0.9,0.9,Bound,BMselect);
            
        % ���������Ž�����ж��Ƿ������ɹ�
        if norm(x_best(BMselect,:) - Sol) < norm(ones(1,D) * 0.1)
            cnt = cnt + 1;
        end

        if graphFlg == 1
        % ��ʾ��������
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


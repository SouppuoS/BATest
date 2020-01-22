% 解决2D问题 画出Bat的变化路线
clear all;
close all;

addpath(genpath('../'));

% 绘图控制
figureCfg = [0 0 0 1 0];

% BA算法参数
Iter  = 200;
P     = 60;
D     = 2;
Bound = [-10,10; -10,10];

for BMselect=[1]
    [Sol,Rst,TraceInfo] = BA(D,Iter,P,[0,2],0.9,0.9,Bound,BMselect);
    
    if figureCfg(1) == 1
        % 三只蝙蝠及最优的变化轨迹
        figure();
        subplot(2,2,1);
        drawTrace(TraceInfo,P,[-100 100 -100 100]);
        subplot(2,2,2);
        drawTrace(TraceInfo,P,[-20 20 -20 20]);
        subplot(2,2,3);
        drawTrace(TraceInfo,P,[-5 5 -5 5]);
        subplot(2,2,4);
        drawTrace(TraceInfo,P,[-1 1 -1 1]);
    end
    
    if figureCfg(2) == 1
        % A与r参数变化趋势
        figure();
        subplot(2,1,1);
        plot(TraceInfo.Ar.A(1,:),'g');
        hold on;
        plot(TraceInfo.Ar.A(2,:),'b');
        plot(TraceInfo.Ar.A(3,:),'r');
        xlabel('A (loudness)')
        hold off;
        subplot(2,1,2);
        plot(TraceInfo.Ar.r(1,:),'g');
        hold on;
        plot(TraceInfo.Ar.r(2,:),'b');
        plot(TraceInfo.Ar.r(3,:),'r');
        xlabel('r (emit frequency)');
        hold off;
    end

    if figureCfg(3) == 1
        % 所有蝙蝠运动趋势
        figure();
        hold on;
        for i=1:P
            plot(TraceInfo.Trace(i,1:sum(TraceInfo.TraceSum(1,:)),1),TraceInfo.Trace(i,1:sum(TraceInfo.TraceSum(1,:)),2),"--.");
        end
        xlabel(Sol);
        hold off;
    end
    
    if figureCfg(4) == 1
        figure();
        hold on;
        for i=1:P
            plot3(TraceInfo.TrySol(i,:,1),TraceInfo.TrySol(i,:,2),1:Iter + 1,"--.");
        end
        plot3(TraceInfo.TrySol(P + 1,:,1),TraceInfo.TrySol(P + 1,:,2),1:Iter + 1,"r",'LineWidth',2);
        xlabel(Sol);
        hold off;
    end
    
    if figureCfg(5) == 1
        figure();
        hold on;
        plot(TraceInfo.Choose(1:P,1),'r--x');
        plot(TraceInfo.Choose(1:P,2),'b--x');
        xlabel('red:exploit   blue:explore');
        hold off;
    end
end

% 绘制递归调用过程
function [] = drawTrace(TraceInfo,P,ax)
Trace  = TraceInfo.Trace;
Choose = TraceInfo.Choose;
lBSize = TraceInfo.TraceSum;

plot(Trace(P+1,1:lBSize,1),Trace(P+1,1:lBSize,2),"r--o");
hold on;
plot(Trace(1,1:sum(Choose(1,:)),1),Trace(1,1:sum(Choose(1,:)),2),"b--x");
plot(Trace(2,1:sum(Choose(2,:)),1),Trace(2,1:sum(Choose(2,:)),2),"g--x");
plot(Trace(3,1:sum(Choose(3,:)),1),Trace(3,1:sum(Choose(3,:)),2),"c--x");

% 初始点
plot(Trace(P+1,1,1),Trace(P+1,1,2),"ro",'MarkerSize',20);
plot(Trace(1,1,1),Trace(1,1,2),"bo",'MarkerSize',15);
plot(Trace(2,1,1),Trace(2,1,2),"go",'MarkerSize',15);
plot(Trace(3,1,1),Trace(3,1,2),"co",'MarkerSize',15);
hold off;

axis(ax);
end
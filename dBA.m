function [Sol,Rec,INFO_Trace] = BA(D,Iter,P,fRange,alpha,gamma,SBound, BMIdx)
global Bat_loc;             % Bat解
global Bat_eval;            % Bat解值
global Bat_A;               % A loudness
global Bat_r;               % r frequency
global Bat_v;               % v
global Bat_locBest;         % 全局较优解
global Bat_locBest_it;      % 当前迭代中的最优解
global BunchIdx;

addpath(genpath('./Func'));

dBA_Init(Iter,P);           % 初始化Bat的A和r

Bat_loc    = ones(P,D) .* SBound(:,1)' + rand(P,D) .* (SBound(:,2) - SBound(:,1))';     % 每个Bat的当前解
Bat_v      = zeros(P,D);
BunchIdx   = BMIdx;

for i = 1:P
    % 计算每个BAT当前解的解值
    Bat_eval(i) = evalBat(Bat_loc(i,:),BunchIdx); 
end

% 更新最优解值并记录当前最优解
[Bat_evalBest,idx] = min(Bat_eval);
Bat_locBest        = Bat_loc(idx,:);
Bat_locBest_it     = Bat_loc(idx,:);

% TraceInfo
INFO_Btrace   = zeros(P,Iter,D);         % 记录Bat的变化轨迹
INFO_try      = zeros(P + 1,Iter + 1,D); % 记录尝试过的区域
INFO_RstRec   = zeros(Iter + 1,P + 1);   % 记录Bat最优解的变化
INFO_choose   = zeros(P+1,2);            % 记录造成Bat实际移动(loc变化)的选择
                                        % sum(k,:) 即是第k个BAT最优解更新的次数
INFO_traSum   = 1;
for i = 1:P
    INFO_Btrace(i,1,:) = Bat_loc(i,:);
end
INFO_Btrace(P + 1,INFO_traSum,:) = Bat_locBest;
INFO_try(:,1,:)  = INFO_Btrace(:,1,:);
INFO_ArRec.A     = zeros(P,Iter);        % 记录每个Bat的A参数与r参数变化
INFO_ArRec.r     = zeros(P,Iter);

% 迭代过程
for i = 1:Iter 
    % 选择Bat
    for j = 1:P
        % 选择explore还是exploit过程
        if rand < Bat_r(j)

            % explore
            Bat_V_bak = Bat_v(j,:);                             % 对v做备份
            Bat_mv    = dBA_updateLoc(j,P,D,fRange);
            choose    = 2;
        else
            % exploit
            randWlk = dBA_randWalkSize(i,Iter,SBound);
            Bat_mv  = Bat_locBest_it + randWlk .* (rand(1,D) * 2 - 1);
            choose  = 1;
        end
        
        % 边界限制 修正Bat_mv
        Bat_mv = simplebound(Bat_mv(:),SBound);
        % 计算当前迭代的解值
        eval_mv = evalBat(Bat_mv,BunchIdx); 
        
        % 如果比这个Bat自己当前的最优解(Bat_loc)的解值更好 一定概率接受这个mv
        if eval_mv < Bat_eval(j) && rand < Bat_A(j)
            Bat_eval(j)  = eval_mv;
            Bat_loc(j,:) = Bat_mv;
            
            % 更新A和r
            % dBA优化 (13)(14)式 按文章推荐参数 r0=0.1 r∞=0.7 A0=0.9 A∞=0.6
            Bat_A(j) = dBA_calcFormula10(0.9,0.6,i,Iter);
            Bat_r(j) = dBA_calcFormula10(0.1,0.7,i,Iter);
            
            % TraceInfo
            INFO_choose(j,choose) = INFO_choose(j,choose) + 1;
            INFO_Btrace(j,1 + sum(INFO_choose(j,:)),:) = Bat_mv;
        else
            if choose == 2
                Bat_v(j,:) = Bat_V_bak;        % 如果没选择explore过程 把v还回去 避免叠加
            end
        end
        
        % 记录小于所有Bat的最优解
        if eval_mv < Bat_evalBest
            Bat_locBest  = Bat_mv;
            Bat_evalBest = eval_mv;
            
            % TraceInfo
            INFO_traSum  = INFO_traSum + 1;
            INFO_Btrace(P + 1,INFO_traSum,:) = Bat_locBest;
        end
        
        % TraceInfo
        INFO_RstRec(i,j)    = Bat_eval(j);
        INFO_try(j,i + 1,:) = Bat_mv;
        INFO_ArRec.A(j,i)   = Bat_A(j);
        INFO_ArRec.r(j,i)   = Bat_r(j);
    end
    
    [~,idx]         = min(Bat_eval);
    Bat_locBest_it  = Bat_loc(idx,:);
    
    % TraceInfo
    INFO_RstRec(i,P + 1)    = Bat_evalBest;
    INFO_try(P + 1,i + 1,:) = Bat_locBest;
end

% 返回迭代过程以及最优解
Sol  = Bat_locBest;
Rec  = INFO_RstRec;

% TraceInfo
INFO_Trace.Trace     = INFO_Btrace;
INFO_Trace.TrySol    = INFO_try;
INFO_Trace.Choose    = INFO_choose;
INFO_Trace.TraceSum  = INFO_traSum;
INFO_Trace.Ar        = INFO_ArRec;
end

% 简单矩形边界限制
% 将超过SBound限制的值改回边界
function loc = simplebound(x, SBound)
loc = max(min(x,SBound(:,2)),SBound(:,1))';
end


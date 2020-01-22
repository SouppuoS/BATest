%
% BA算法实现
% [Sol,Rec,INFO_Trace] = BA(D,Iter,P,fRange,alpha,gamma,SBound, BMIdx, OptFlg)
%
% D:            1*1     维数
% Iter:         1*1     迭代次数
% P:            1*1     population bat总数
% fRange        1*2     f的范围 
%                       fRange(1)<f<fRange(2)
% alpha         1*1     A参数的衰减系数α
% gamma         1*1     r参数的增加系数γ
% SBound:       D*2     simplebound 先实现简单矩形范围 
%                       SBound(d,1)<loc(d)<SBound(d,2)
% BMIdx         1*1     测试Bunchmark编号
%                           参考：Gandomi A H, Yang X S. Chaotic bat algorithm[J]. Journal of Computational Science, 2014, 5(2): 224-232.
%                       BM1: Sphere:        f(x) = x'x
%                       BM2: Schwefel:      f(x) = Σ|x|+prod(|x|)
%                       BM3: Rosenbrock:
%                       BM4: Ackley:
%                       BM5: Griewank:
%
% Sol           1*D     最优解
% Rec           Iter*P  每个Bat迭代过程中的最优解值
% INFO_Trace    stru    算法中间过程数据 用于分析 
%                       Trace       P*Iter*D:   每次更新的BAT位置
%                       TrySol      P*Iter*D:   尝试过的解
%                       Choose      P*2:        每个Bat对于explore和exploit的选择
%                       TraceSum    1*1:        全局最优位置更新的次数
%
% 参考:
%   Yang X S. A new metaheuristic bat-inspired algorithm[M]//Nature inspired cooperative strategies for optimization (NICSO 2010). Springer, Berlin, Heidelberg, 2010: 65-74.
%   Fister I, Yang X S, Fong S, et al. Bat algorithm: Recent advances[C]//2014 IEEE 15th International Symposium on Computational Intelligence and Informatics (CINTI). IEEE, 2014: 163-167.
%    
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

BA_Init(P,gamma);   % 初始化Bat的A和r

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
            Bat_mv    = BA_updateLoc(j,P,D,fRange);
            choose    = 2;
        else
            % exploit
            randWlk = BA_randWalkSize(i,Iter,SBound);
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
            BA_updateAr(i,Iter,P,sum(INFO_choose(j,:)) + 1,alpha,gamma,j);
            
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

% random walk的步长
% size:     1*D:    各维度上步长
function [step] = BA_randWalkSize(t,t_max,SBound)
global Bat_A;
step = ones(1,size(SBound,1)) * mean(Bat_A);
end

% 简单矩形边界限制
% 将超过SBound限制的值改回边界
function loc = simplebound(x, SBound)
loc = max(min(x,SBound(:,2)),SBound(:,1))';
end

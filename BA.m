%
% BA�㷨ʵ��
% [Sol,Rec,INFO_Trace] = BA(D,Iter,P,fRange,alpha,gamma,SBound, BMIdx, OptFlg)
%
% D:            1*1     ά��
% Iter:         1*1     ��������
% P:            1*1     population bat����
% fRange        1*2     f�ķ�Χ 
%                       fRange(1)<f<fRange(2)
% alpha         1*1     A������˥��ϵ����
% gamma         1*1     r����������ϵ����
% SBound:       D*2     simplebound ��ʵ�ּ򵥾��η�Χ 
%                       SBound(d,1)<loc(d)<SBound(d,2)
% BMIdx         1*1     ����Bunchmark���
%                           �ο���Gandomi A H, Yang X S. Chaotic bat algorithm[J]. Journal of Computational Science, 2014, 5(2): 224-232.
%                       BM1: Sphere:        f(x) = x'x
%                       BM2: Schwefel:      f(x) = ��|x|+prod(|x|)
%                       BM3: Rosenbrock:
%                       BM4: Ackley:
%                       BM5: Griewank:
%
% Sol           1*D     ���Ž�
% Rec           Iter*P  ÿ��Bat���������е����Ž�ֵ
% INFO_Trace    stru    �㷨�м�������� ���ڷ��� 
%                       Trace       P*Iter*D:   ÿ�θ��µ�BATλ��
%                       TrySol      P*Iter*D:   ���Թ��Ľ�
%                       Choose      P*2:        ÿ��Bat����explore��exploit��ѡ��
%                       TraceSum    1*1:        ȫ������λ�ø��µĴ���
%
% �ο�:
%   Yang X S. A new metaheuristic bat-inspired algorithm[M]//Nature inspired cooperative strategies for optimization (NICSO 2010). Springer, Berlin, Heidelberg, 2010: 65-74.
%   Fister I, Yang X S, Fong S, et al. Bat algorithm: Recent advances[C]//2014 IEEE 15th International Symposium on Computational Intelligence and Informatics (CINTI). IEEE, 2014: 163-167.
%    
function [Sol,Rec,INFO_Trace] = BA(D,Iter,P,fRange,alpha,gamma,SBound, BMIdx)

global Bat_loc;             % Bat��
global Bat_eval;            % Bat��ֵ
global Bat_A;               % A loudness
global Bat_r;               % r frequency
global Bat_v;               % v
global Bat_locBest;         % ȫ�ֽ��Ž�
global Bat_locBest_it;      % ��ǰ�����е����Ž�
global BunchIdx;

addpath(genpath('./Func'));

BA_Init(P,gamma);   % ��ʼ��Bat��A��r

Bat_loc    = ones(P,D) .* SBound(:,1)' + rand(P,D) .* (SBound(:,2) - SBound(:,1))';     % ÿ��Bat�ĵ�ǰ��
Bat_v      = zeros(P,D);
BunchIdx   = BMIdx;

for i = 1:P
    % ����ÿ��BAT��ǰ��Ľ�ֵ
    Bat_eval(i) = evalBat(Bat_loc(i,:),BunchIdx); 
end

% �������Ž�ֵ����¼��ǰ���Ž�
[Bat_evalBest,idx] = min(Bat_eval);
Bat_locBest        = Bat_loc(idx,:);
Bat_locBest_it     = Bat_loc(idx,:);

% TraceInfo
INFO_Btrace   = zeros(P,Iter,D);         % ��¼Bat�ı仯�켣
INFO_try      = zeros(P + 1,Iter + 1,D); % ��¼���Թ�������
INFO_RstRec   = zeros(Iter + 1,P + 1);   % ��¼Bat���Ž�ı仯
INFO_choose   = zeros(P+1,2);            % ��¼���Batʵ���ƶ�(loc�仯)��ѡ��
                                        % sum(k,:) ���ǵ�k��BAT���Ž���µĴ���
INFO_traSum   = 1;
for i = 1:P
    INFO_Btrace(i,1,:) = Bat_loc(i,:);
end
INFO_Btrace(P + 1,INFO_traSum,:) = Bat_locBest;
INFO_try(:,1,:)  = INFO_Btrace(:,1,:);
INFO_ArRec.A     = zeros(P,Iter);        % ��¼ÿ��Bat��A������r�����仯
INFO_ArRec.r     = zeros(P,Iter);

% ��������
for i = 1:Iter 
    % ѡ��Bat
    for j = 1:P
        % ѡ��explore����exploit����
        if rand < Bat_r(j)
            % explore
            Bat_V_bak = Bat_v(j,:);                             % ��v������
            Bat_mv    = BA_updateLoc(j,P,D,fRange);
            choose    = 2;
        else
            % exploit
            randWlk = BA_randWalkSize(i,Iter,SBound);
            Bat_mv  = Bat_locBest_it + randWlk .* (rand(1,D) * 2 - 1);
            choose  = 1;
        end
        
        % �߽����� ����Bat_mv
        Bat_mv = simplebound(Bat_mv(:),SBound);
        % ���㵱ǰ�����Ľ�ֵ
        eval_mv = evalBat(Bat_mv,BunchIdx); 
        
        % ��������Bat�Լ���ǰ�����Ž�(Bat_loc)�Ľ�ֵ���� һ�����ʽ������mv
        if eval_mv < Bat_eval(j) && rand < Bat_A(j)
            Bat_eval(j)  = eval_mv;
            Bat_loc(j,:) = Bat_mv;
            
            % ����A��r
            BA_updateAr(i,Iter,P,sum(INFO_choose(j,:)) + 1,alpha,gamma,j);
            
            % TraceInfo
            INFO_choose(j,choose) = INFO_choose(j,choose) + 1;
            INFO_Btrace(j,1 + sum(INFO_choose(j,:)),:) = Bat_mv;
        else
            if choose == 2
                Bat_v(j,:) = Bat_V_bak;        % ���ûѡ��explore���� ��v����ȥ �������
            end
        end
        
        % ��¼С������Bat�����Ž�
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

% ���ص��������Լ����Ž�
Sol  = Bat_locBest;
Rec  = INFO_RstRec;

% TraceInfo
INFO_Trace.Trace     = INFO_Btrace;
INFO_Trace.TrySol    = INFO_try;
INFO_Trace.Choose    = INFO_choose;
INFO_Trace.TraceSum  = INFO_traSum;
INFO_Trace.Ar        = INFO_ArRec;
end

% random walk�Ĳ���
% size:     1*D:    ��ά���ϲ���
function [step] = BA_randWalkSize(t,t_max,SBound)
global Bat_A;
step = ones(1,size(SBound,1)) * mean(Bat_A);
end

% �򵥾��α߽�����
% ������SBound���Ƶ�ֵ�Ļر߽�
function loc = simplebound(x, SBound)
loc = max(min(x,SBound(:,2)),SBound(:,1))';
end

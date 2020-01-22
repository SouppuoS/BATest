%
% 按公式更新BAT位置
%
% Bat_mv:   更新后的BatLoc
function [Bat_mv] = SAMBA_updateLoc(BatIdx,P,D,fRange)
global Bat_loc;
global Bat_locBest;
global Bat_v;
global BunchIdx;

global SAMBA_p;             % 选择第θ中mod的概率
global SAMBA_modSel;        % 每个Bat的mod选择

if isempty(SAMBA_p)
    SAMBA_p      = ones(2,1) * 0.5;
    SAMBA_modSel = zeros(P,1);
end

if BatIdx == 1
	% 更新Pθ
	SAMBA_updatePtheta(P);
        
	% 更新这一轮迭代中BAT的选择
	for i = 1:P
        mod_sel = rand;
        if (mod_sel < SAMBA_p(1))
            SAMBA_modSel(i) = 1;
        else
            SAMBA_modSel(i) = 2;
        end
	end
end
    
if SAMBA_modSel(BatIdx) == 1
	% 任选3个下标
	m_set = randperm(P,4);
	m_set(any(m_set == BatIdx,1)) = [];
        
	% mutation
	p       = rand(1,4);
	x_test  = Bat_loc(m_set(1),:) + p(1) * (Bat_loc(m_set(2)) - Bat_loc(m_set(3)));    % (5)
	x_test1 = zeros(D,1);
	x_test2 = zeros(D,1);
        
	% crossover
	for i = 1:D
        p = rand(1,4);
        if (p(2) < p(3))
            x_test1(i) = Bat_loc(BatIdx,i);
        else
            x_test1(i) = Bat_locBest(i);
        end
        if (p(3) < p(4))
            x_test2(i) = x_test(i);
        else
            x_test2(i) = Bat_locBest(i);
        end
    end
	xt1_eval = evalBat(x_test1,BunchIdx);
	xt2_eval = evalBat(x_test2,BunchIdx);
	Bat_mv   = x_test1;
	if xt1_eval > xt2_eval
        Bat_mv = x_test2;
    end
else
	% SAMBA中不使用m1变化则是标准BA
	Bat_f           = fRange(1) + rand * (fRange(2) - fRange(1));
	Bat_v(BatIdx,:) = Bat_v(BatIdx,:) + (Bat_loc(BatIdx,:) - Bat_locBest) * Bat_f;
	Bat_mv          = Bat_loc(BatIdx,:) + Bat_v(BatIdx,:);
end
end

% SAMBA中更新Pθ参数
% 参考:
%   Khooban M H, Niknam T. A new intelligent online fuzzy tuning approach for multi-area load frequency control: Self Adaptive Modified Bat Algorithm[J]. International Journal of Electrical Power & Energy Systems, 2015, 71: 254-261.
function [] = SAMBA_updatePtheta(P)
global SAMBA_modSel;
global SAMBA_p;
global Bat_eval;

% SAMBA将Bat当前解按解值排序
[~,sortIdx] = sortrows(Bat_eval');

Wt_div = sum(log(1:P));
Wt     = zeros(2,1);
n_Sel  = zeros(2,1);
for i = 1:P
    orgIdx = sortIdx(i);
    if SAMBA_modSel(orgIdx) > 0
        Wt(SAMBA_modSel(orgIdx))    = Wt(SAMBA_modSel(orgIdx)) + log(P - i + 1) / Wt_div;       % (8)
        n_Sel(SAMBA_modSel(orgIdx)) = n_Sel(SAMBA_modSel(orgIdx)) + 1;
    end
end
if (n_Sel(1) > 0)
    SAMBA_p(1) = SAMBA_p(1) + Wt(1) / n_Sel(1);     % (9)
end
if (n_Sel(2) > 0)
    SAMBA_p(2) = SAMBA_p(2) + Wt(2) / n_Sel(2);     % (9)
end

% 更新选择概率
SAMBA_p = SAMBA_p / sum(SAMBA_p);                   % (10)
end
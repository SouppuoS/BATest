%
% dBA初始化函数
%
function [] = dBA_Init(Iter,P)
global Bat_A;
global Bat_r;

% 默认参数
global def_r;        % 标准BA的默认r终值
def_r = 1;           % r参数的极限值

Bat_A = ones(P,1) * dBA_calcFormula10(0.9,0.6,1,Iter);
Bat_r = ones(P,1) * dBA_calcFormula10(0.1,0.7,1,Iter);

end


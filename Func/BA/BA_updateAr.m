%
% 更新A参数与r参数
%
function [] = BA_updateAr(t,Iter,P,changeTime,alpha,gamma,BatIdx)
global Bat_A;
global Bat_r;
global def_r;

Bat_A(BatIdx) = Bat_A(BatIdx) * alpha;
Bat_r(BatIdx) = def_r * (1 - exp(-gamma * changeTime));
end


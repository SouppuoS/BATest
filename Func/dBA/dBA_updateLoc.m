%
% 按公式更新BAT位置
%
% Bat_mv:   更新后的BatLoc
function [Bat_mv] = dBA_updateLoc(BatIdx,P,D,fRange)
global Bat_loc;
global Bat_locBest;
global Bat_eval;

Bat_f  = fRange(1) + rand * (fRange(2) - fRange(1));
Bat_mv = Bat_loc(BatIdx,:) + (Bat_locBest - Bat_loc(BatIdx,:)) * Bat_f;         % 当前最优解方向
selBat = 1 + mod(BatIdx - 1 + randi([1 P - 1]),P);                              % 任选一个不同的BAT

% 判断任选的BAT方向是否也存在更优解
if Bat_eval(selBat) < Bat_eval(BatIdx)
    Bat_f  = fRange(1) + rand * (fRange(2) - fRange(1));
    Bat_mv = Bat_mv + (Bat_loc(selBat,:) - Bat_loc(BatIdx,:)) * Bat_f;          % 叠加任选的方向到loc上
end

end
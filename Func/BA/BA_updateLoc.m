%
% 按公式更新BAT位置
%
% Bat_mv:   更新后的BatLoc
function [Bat_mv] = BA_updateLoc(BatIdx,P,D,fRange)
global Bat_loc;
global Bat_locBest;
global Bat_v;

global SAMBA_p;             % 选择第θ中mod的概率
global SAMBA_modSel;        % 每个Bat的mod选择

if isempty(SAMBA_p)
    SAMBA_p      = ones(2,1) * 0.5;
    SAMBA_modSel = zeros(P,1);
end

% 更新f与v
Bat_f           = fRange(1) + rand * (fRange(2) - fRange(1));
Bat_v(BatIdx,:) = Bat_v(BatIdx,:) + (Bat_loc(BatIdx,:) - Bat_locBest) * Bat_f;
Bat_mv          = Bat_loc(BatIdx,:) + Bat_v(BatIdx,:); 

end
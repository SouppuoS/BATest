%
% ����ʽ����BATλ��
%
% Bat_mv:   ���º��BatLoc
function [Bat_mv] = BA_updateLoc(BatIdx,P,D,fRange)
global Bat_loc;
global Bat_locBest;
global Bat_v;

global SAMBA_p;             % ѡ��ڦ���mod�ĸ���
global SAMBA_modSel;        % ÿ��Bat��modѡ��

if isempty(SAMBA_p)
    SAMBA_p      = ones(2,1) * 0.5;
    SAMBA_modSel = zeros(P,1);
end

% ����f��v
Bat_f           = fRange(1) + rand * (fRange(2) - fRange(1));
Bat_v(BatIdx,:) = Bat_v(BatIdx,:) + (Bat_loc(BatIdx,:) - Bat_locBest) * Bat_f;
Bat_mv          = Bat_loc(BatIdx,:) + Bat_v(BatIdx,:); 

end
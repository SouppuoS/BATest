%
% ����A������r����
%
function [] = SAMBA_updateAr(t,Iter,P,changeTime,alpha,gamma,BatIdx)
global Bat_A;
global Bat_r;
global def_r;

global SAMBA_modSel;
global SAMBA_p;

if isempty(SAMBA_p)
    SAMBA_p      = ones(2,1) * 0.5;
    SAMBA_modSel = zeros(P,1);
end

if SAMBA_modSel(BatIdx) == 2
	Bat_A(BatIdx) = Bat_A(BatIdx) * (1/(2*t))^(1/t);    % �ο�SAMBA����(7)ʽ
else
	Bat_A(BatIdx) = Bat_A(BatIdx) * alpha;              % ��׼BA
end
Bat_r(BatIdx) = def_r * (1 - exp(-gamma * changeTime)); % ��׼BA

end


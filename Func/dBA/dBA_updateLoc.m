%
% ����ʽ����BATλ��
%
% Bat_mv:   ���º��BatLoc
function [Bat_mv] = dBA_updateLoc(BatIdx,P,D,fRange)
global Bat_loc;
global Bat_locBest;
global Bat_eval;

Bat_f  = fRange(1) + rand * (fRange(2) - fRange(1));
Bat_mv = Bat_loc(BatIdx,:) + (Bat_locBest - Bat_loc(BatIdx,:)) * Bat_f;         % ��ǰ���Žⷽ��
selBat = 1 + mod(BatIdx - 1 + randi([1 P - 1]),P);                              % ��ѡһ����ͬ��BAT

% �ж���ѡ��BAT�����Ƿ�Ҳ���ڸ��Ž�
if Bat_eval(selBat) < Bat_eval(BatIdx)
    Bat_f  = fRange(1) + rand * (fRange(2) - fRange(1));
    Bat_mv = Bat_mv + (Bat_loc(selBat,:) - Bat_loc(BatIdx,:)) * Bat_f;          % ������ѡ�ķ���loc��
end

end
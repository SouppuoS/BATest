%
% dBA��ʼ������
%
function [] = dBA_Init(Iter,P)
global Bat_A;
global Bat_r;

% Ĭ�ϲ���
global def_r;        % ��׼BA��Ĭ��r��ֵ
def_r = 1;           % r�����ļ���ֵ

Bat_A = ones(P,1) * dBA_calcFormula10(0.9,0.6,1,Iter);
Bat_r = ones(P,1) * dBA_calcFormula10(0.1,0.7,1,Iter);

end


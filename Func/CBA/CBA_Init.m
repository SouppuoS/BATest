%
% ��ʼ��BA�㷨
%
function [] = CBA_Init(P)
global Bat_A;
global Bat_r;

% Ĭ�ϲ���
global def_r;        % ��׼BA��Ĭ��r��ֵ
def_r = 1;           % r�����ļ���ֵ
def_A = 2;           % A�����ĳ�ʼֵ

Bat_A = ones(P,1) * def_A;
Bat_r = rand(P,1); 
end

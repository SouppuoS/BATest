% random walk�Ĳ���
% size:     1*D:    ��ά���ϲ���
function [step] = dBA_randWalkSize(t,t_max,SBound)
% dBA�Ż� (10)
w0   = (SBound(:,2) - SBound(:,1))/4;
step = dBA_calcFormula10(w0,w0/100,t,t_max)';
end
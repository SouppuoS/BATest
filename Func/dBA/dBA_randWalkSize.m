% random walk的步长
% size:     1*D:    各维度上步长
function [step] = dBA_randWalkSize(t,t_max,SBound)
% dBA优化 (10)
w0   = (SBound(:,2) - SBound(:,1))/4;
step = dBA_calcFormula10(w0,w0/100,t,t_max)';
end
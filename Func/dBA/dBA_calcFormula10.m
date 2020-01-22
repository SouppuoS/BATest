%
% dBA�м������е����仯�ĸ�����
% v_0:      ������ֵ
% v_max:    ������ֵ
% t_max:    ʱ����ֵ
% t:        ��ǰʱ��
%
% �ο�: 
%   Chakri A, Khelif R, Benouaret M, et al. New directional bat algorithm for continuous optimization problems[J]. Expert Systems with Applications, 2017, 69: 159-175.
%   ����(10)(13)(14)ʽ
%
function [rst] = dBA_calcFormula10(v_0,v_max,t,t_max)
rst = (v_0 - v_max) ./ (1 - t_max) .* (t - t_max) + v_max;
end

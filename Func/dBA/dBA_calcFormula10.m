%
% dBA中计算自行单调变化的各参数
% v_0:      变量初值
% v_max:    变量终值
% t_max:    时间终值
% t:        当前时间
%
% 参考: 
%   Chakri A, Khelif R, Benouaret M, et al. New directional bat algorithm for continuous optimization problems[J]. Expert Systems with Applications, 2017, 69: 159-175.
%   其中(10)(13)(14)式
%
function [rst] = dBA_calcFormula10(v_0,v_max,t,t_max)
rst = (v_0 - v_max) ./ (1 - t_max) .* (t - t_max) + v_max;
end

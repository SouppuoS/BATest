%
% 初始化BA算法
%
function [] = CBA_Init(P)
global Bat_A;
global Bat_r;

% 默认参数
global def_r;        % 标准BA的默认r终值
def_r = 1;           % r参数的极限值
def_A = 2;           % A参数的初始值

Bat_A = ones(P,1) * def_A;
Bat_r = rand(P,1); 
end

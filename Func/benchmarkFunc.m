%
% 从BA.m中提出benchmark函数的实现
% x:        1*D 输入x
% method:   1*1 benchmark编号
%           	参考：Gandomi A H, Yang X S. Chaotic bat algorithm[J]. Journal of Computational Science, 2014, 5(2): 224-232.
%           BM1: Sphere:        f(x) = x'x
%           BM2: Schwefel:      f(x) = Σ|x|+prod(|x|)
%           BM3: Rosenbrock:
%           BM4: Ackley:
%           BM5: Griewank:
%
% rst:      1*1 函数值
%
function [rst] = benchmarkFunc(x,method)
switch method
    case 1
        rst = BM1(x);
    case 2
        rst = BM2(x);
    case 3
        rst = BM3(x);
    case 4
        rst = BM4(x);
    case 5
        rst = BM5(x);
end
end

% benchmark funcion 1 Sphere
function rst = BM1(x)
rst = x*x';
end

% benchmark funcion 2 Schwefel
function rst = BM2(x)
rst = sum(abs(x)) + prod(abs(x));
end

% benchmark funcion 3 Rosenbrock
function rst = BM3(x)
rst= 0;
for i = 1:size(x,2) - 1
    rst = rst + (x(i + 1) - x(i)^2)^2 + (x(i) - 1)^2;
end
end

% benchmark funcion 4 Ackley
function rst = BM4(x)
n   = size(x,2);
a   = 20;
rst = -a * exp(-0.02 * sqrt(x * x'/n)) - exp(sum(cos(2 * pi * x) / n)) + a + exp(1);
end

% benchmark funcion 5 Griewank
function rst = BM5(x)
n = size(x,2);
r = 1;
for i=1:n
    r = r * cos(x(i)/sqrt(i));
end
rst = 1 + x*x' / 4000 - r;
end
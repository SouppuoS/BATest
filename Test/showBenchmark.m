% 绘制2D问题下各benchmark的大概形状
clear all;
close all;

step = 0.1;
Bound = [-15 15;-15 15];

for idx = [1 2 3 4 5]
    figure();
    idxi = 0;
    val = zeros((Bound(1,2) - Bound(1,1)) / step, (Bound(2,2) - Bound(2,1)) / step);
    for i= Bound(1,1):step:Bound(1,2)
        idxi = idxi + 1;
        idxj = 0;
        for j = Bound(2,1):step:Bound(2,2)
            idxj = idxj + 1;
            val(idxi,idxj) = benchmarkFunc([i j],idx);
        end
    end
    mesh(Bound(1,1):step:Bound(1,2), Bound(2,1):step:Bound(2,2), val);
end


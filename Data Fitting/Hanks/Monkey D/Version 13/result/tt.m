Cmax = .5;
Cohr = 0: .05: 0.512;
gamma_arr = 0: 1: 10;

for i = 1:length(gamma_arr)
    V1 = 1 + Cmax * (1 - exp(-gamma_arr(i)*Cohr));
    plot(Cohr, V1); hold on;
end

% V2 = 1 - (1 - Cmax * exp(-gamma*Cohr));
% plot(V2);
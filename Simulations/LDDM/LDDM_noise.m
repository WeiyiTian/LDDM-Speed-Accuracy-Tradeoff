%% noise

% parameters
dt = .001;
tau = .2;
noise_tau = .5;
w1 = 1;
w2 = 1;
alpha = .9;
bata = 0;
V1 = 30;
V2 = 30;
dur = 2;
sgm = .5;

% initial values
R1 = 0;
R2 = 0;
G1 = 0;
G2 = 0;
D1 = 0;
D2 = 0;

noiseR1 = 0;
noiseR2 = 0;
noiseG1 = 0;
noiseG2 = 0;
noiseD1 = 0;
noiseD2 = 0;

% beta = 0 simulation
for ti = 2:(dur/dt)
    dR1 = (-R1(ti-1) + V1/(1+G1(ti-1)))*dt/tau;
    dR2 = (-R2(ti-1) + V2/(1+G2(ti-1)))*dt/tau;
    dG1 = (-G1(ti-1) + w1*R1(ti-1) + w2*R2(ti-1))*dt/tau;
    dG2 = (-G2(ti-1) + w1*R1(ti-1) + w2*R2(ti-1))*dt/tau;
    dD1 = (-D1(ti-1) + beta*R1(ti-1))*dt/tau;
    dD2 = (-D2(ti-1) + beta*R2(ti-1))*dt/tau;

    R1(ti) = max(R1(ti-1) + dR1, 0);
    R2(ti) = max(R2(ti-1) + dR2, 0);
    G1(ti) = max(G1(ti-1) + dG1, 0);
    G2(ti) = max(G2(ti-1) + dG2, 0);
    D1(ti) = max(D1(ti-1) + dD1, 0);
    D2(ti) = max(D2(ti-1) + dD2, 0);
end

R1 = R1(ti);
R2 = R2(ti);
G1 = G1(ti);
G2 = G2(ti);
D1 = D1(ti);
D2 = D2(ti);
beta = .9;

% disinhibitory model
for ti = 2:(dur/dt)
    dnoiseR1 = (-noiseR1(ti-1) + randn.*sqrt(dt).*sgm)/noise_tau*dt;
    dnoiseR2 = (-noiseR2(ti-1) + randn.*sqrt(dt).*sgm)/noise_tau*dt;
    dnoiseG1 = (-noiseG1(ti-1) + randn.*sqrt(dt).*sgm)/noise_tau*dt;
    dnoiseG2 = (-noiseG2(ti-1) + randn.*sqrt(dt).*sgm)/noise_tau*dt;
    dnoiseD1 = (-noiseD1(ti-1) + randn.*sqrt(dt).*sgm)/noise_tau*dt;
    dnoiseD2 = (-noiseD2(ti-1) + randn.*sqrt(dt).*sgm)/noise_tau*dt;

    dR1 = (-R1(ti-1) + (alpha*R1(ti-1)+V1) / (1+G1(ti-1)))*dt/tau;
    dR2 = (-R2(ti-1) + (alpha*R2(ti-1)+V2) / (1+G2(ti-1)))*dt/tau;
    dG1 = (-G1(ti-1) + w1*R1(ti-1) + w2*R2(ti-1) - D1(ti-1))*dt/tau;
    dG2 = (-G2(ti-1) + w1*R1(ti-1) + w2*R2(ti-1) - D2(ti-1))*dt/tau;
    dD1 = (-D1(ti-1) + beta*R1(ti-1))*dt/tau;
    dD2 = (-D2(ti-1) + beta*R2(ti-1))*dt/tau;

    noiseR1(ti) = noiseR1(ti-1) + dnoiseR1;
    noiseR2(ti) = noiseR2(ti-1) + dnoiseR2;
    noiseG1(ti) = noiseG1(ti-1) + dnoiseG1;
    noiseG2(ti) = noiseG2(ti-1) + dnoiseG2;
    noiseD1(ti) = noiseD1(ti-1) + dnoiseD1;
    noiseD2(ti) = noiseD2(ti-1) + dnoiseD2;

    R1(ti) = max(R1(ti-1) + dR1 + noiseR1(ti), 0);
    R2(ti) = max(R2(ti-1) + dR2 + noiseR2(ti), 0);
    G1(ti) = max(G1(ti-1) + dG1 + noiseG1(ti), 0);
    G2(ti) = max(G2(ti-1) + dG2 + noiseG2(ti), 0);
    D1(ti) = max(D1(ti-1) + dD1 + noiseD1(ti), 0);
    D2(ti) = max(D2(ti-1) + dD2 + noiseD2(ti), 0);
end

h = figure; hold on;
plot(R1,'k-','LineWidth',3);
plot(R2,'k--','LineWidth',2);
legend({'R1','R2'});
xlabel('t/msecs');
ylabel('Firing rates/Hz');
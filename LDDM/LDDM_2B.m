%% 2B

% parameters
dt = .001;
tau = .2;
w1 = 1;
w2 = 1;
beta = 0;
alpha = .9;
V1 = 30;
V2 = 10;
dur = 2;

% initial values
R1 = 0;
R2 = 0;
G1 = 0;
G2 = 0;
D1 = 0;
D2 = 0;

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
beta = .9;

% disinhibitory model
for ti = 2:(dur/dt)
    dR1 = (-R1(ti-1) + (alpha*R1(ti-1)+V1) / (1+G1(ti-1)))*dt/tau;
    dR2 = (-R2(ti-1) + (alpha*R2(ti-1)+V2) / (1+G2(ti-1)))*dt/tau;
    dG1 = (-G1(ti-1) + w1*R1(ti-1) + w2*R2(ti-1) - D1(ti-1))*dt/tau;
    dG2 = (-G2(ti-1) + w1*R1(ti-1) + w2*R2(ti-1) - D2(ti-1))*dt/tau;
    dD1 = (-D1(ti-1) + beta*R1(ti-1))*dt/tau;
    dD2 = (-D2(ti-1) + beta*R2(ti-1))*dt/tau;

    R1(ti) = max(R1(ti-1) + dR1, 0);
    R2(ti) = max(R2(ti-1) + dR2, 0);
    G1(ti) = max(G1(ti-1) + dG1, 0);
    G2(ti) = max(G2(ti-1) + dG2, 0);
    D1(ti) = max(D1(ti-1) + dD1, 0);
    D2(ti) = max(D2(ti-1) + dD2, 0);
end

h = figure; hold on;
plot(R1,'k-','LineWidth',3);
plot(R2,'k--','LineWidth',2);
plot(G1,'b-','LineWidth',2);
plot(G2, 'b--', 'Linewidth', 3);
plot(D1,'g-','LineWidth',2);
plot(D2, 'g--', 'Linewidth', 3);
legend({'R1','R2','G1', 'G2', 'D1', 'D2'});
xlabel('t/msecs');
ylabel('Firing rates/Hz');
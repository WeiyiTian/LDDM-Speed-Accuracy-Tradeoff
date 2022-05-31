%% 5A

% parameters
dt = .001;
tau = .2;
w1 = 1;
w2 = 1;
alpha = 0;
V1_1 = 30; V1_2 = 30; V1_3 = 30; V1_4 = 30; V1_5 = 30;
V2_1 = 30; V2_2 = 30; V2_3 = 30; V2_4 = 30; V2_5 = 30;
dur = 2;

% initial values
D1_1 = 0; D1_2 = 0; D1_3 = 0; D1_4 = 0; D1_5 = 0;
G1_1 = 0; G1_2 = 0; G1_3 = 0; G1_4 = 0; G1_5 = 0;
R1_1 = 0; R1_2 = 0; R1_3 = 0; R1_4 = 0; R1_5 = 0;
D2_1 = 0; D2_2 = 0; D2_3 = 0; D2_4 = 0; D2_5 = 0;
R2_1 = 0; R2_2 = 0; R2_3 = 0; R2_4 = 0; R2_5 = 0;
G2_1 = 0; G2_2 = 0; G2_3 = 0; G2_4 = 0; G2_5 = 0;

% bata  = 0 simulation
for ti = 2:(dur/dt)
    dR1_1 = (-R1_1(ti-1) + (alpha*R1_1(ti-1)+V1_1) / (1+G1_1(ti-1)))*dt/tau;
    dR1_2 = (-R1_2(ti-1) + (alpha*R1_2(ti-1)+V1_2) / (1+G1_2(ti-1)))*dt/tau;
    dR1_3 = (-R1_3(ti-1) + (alpha*R1_3(ti-1)+V1_3) / (1+G1_3(ti-1)))*dt/tau;
    dR1_4 = (-R1_4(ti-1) + (alpha*R1_4(ti-1)+V1_4) / (1+G1_4(ti-1)))*dt/tau;
    dR1_5 = (-R1_5(ti-1) + (alpha*R1_5(ti-1)+V1_5) / (1+G1_5(ti-1)))*dt/tau;

    dR2_1 = (-R2_1(ti-1) + (alpha*R2_1(ti-1)+V2_1) / (1+G2_1(ti-1)))*dt/tau;
    dR2_2 = (-R2_2(ti-1) + (alpha*R2_2(ti-1)+V2_2) / (1+G2_2(ti-1)))*dt/tau;
    dR2_3 = (-R2_3(ti-1) + (alpha*R2_3(ti-1)+V2_3) / (1+G2_3(ti-1)))*dt/tau;
    dR2_4 = (-R2_4(ti-1) + (alpha*R2_4(ti-1)+V2_4) / (1+G2_4(ti-1)))*dt/tau;
    dR2_5 = (-R2_5(ti-1) + (alpha*R2_5(ti-1)+V2_5) / (1+G2_5(ti-1)))*dt/tau;
    
    dG1_1 = (-G1_1(ti-1) + w1*R1_1(ti-1) + w2*R2_1(ti-1) - D1_1(ti-1))*dt/tau;
    dG1_2 = (-G1_2(ti-1) + w1*R1_2(ti-1) + w2*R2_2(ti-1) - D1_2(ti-1))*dt/tau;
    dG1_3 = (-G1_3(ti-1) + w1*R1_3(ti-1) + w2*R2_3(ti-1) - D1_3(ti-1))*dt/tau;
    dG1_4 = (-G1_4(ti-1) + w1*R1_4(ti-1) + w2*R2_4(ti-1) - D1_4(ti-1))*dt/tau;
    dG1_5 = (-G1_5(ti-1) + w1*R1_5(ti-1) + w2*R2_5(ti-1) - D1_5(ti-1))*dt/tau;

    dG2_1 = (-G2_1(ti-1) + w1*R1_1(ti-1) + w2*R2_1(ti-1) - D2_1(ti-1))*dt/tau;
    dG2_2 = (-G2_2(ti-1) + w1*R1_2(ti-1) + w2*R2_2(ti-1) - D2_2(ti-1))*dt/tau;
    dG2_3 = (-G2_3(ti-1) + w1*R1_3(ti-1) + w2*R2_3(ti-1) - D2_3(ti-1))*dt/tau;
    dG2_4 = (-G2_4(ti-1) + w1*R1_4(ti-1) + w2*R2_4(ti-1) - D2_4(ti-1))*dt/tau;
    dG2_5 = (-G2_5(ti-1) + w1*R1_5(ti-1) + w2*R2_5(ti-1) - D2_5(ti-1))*dt/tau;

    dD1_1 = (-D1_1(ti-1) + beta*R1_1(ti-1))*dt/tau;
    dD1_2 = (-D1_2(ti-1) + beta*R1_2(ti-1))*dt/tau;
    dD1_3 = (-D1_3(ti-1) + beta*R1_3(ti-1))*dt/tau;
    dD1_4 = (-D1_4(ti-1) + beta*R1_4(ti-1))*dt/tau;
    dD1_5 = (-D1_5(ti-1) + beta*R1_5(ti-1))*dt/tau;

    dD2_1 = (-D2_1(ti-1) + beta*R2_1(ti-1))*dt/tau;
    dD2_2 = (-D2_2(ti-1) + beta*R2_2(ti-1))*dt/tau;
    dD2_3 = (-D2_3(ti-1) + beta*R2_3(ti-1))*dt/tau;
    dD2_4 = (-D2_4(ti-1) + beta*R2_4(ti-1))*dt/tau;
    dD2_5 = (-D2_5(ti-1) + beta*R2_5(ti-1))*dt/tau;


    R1_1(ti) = max(R1_1(ti-1) + dR1_1, 0);
    R1_2(ti) = max(R1_2(ti-1) + dR1_2, 0);
    R1_3(ti) = max(R1_3(ti-1) + dR1_3, 0);
    R1_4(ti) = max(R1_4(ti-1) + dR1_4, 0);
    R1_5(ti) = max(R1_5(ti-1) + dR1_5, 0);
    
    R2_1(ti) = max(R2_1(ti-1) + dR2_1, 0);
    R2_2(ti) = max(R2_2(ti-1) + dR2_2, 0);
    R2_3(ti) = max(R2_3(ti-1) + dR2_3, 0);
    R2_4(ti) = max(R2_4(ti-1) + dR2_4, 0);
    R2_5(ti) = max(R2_5(ti-1) + dR2_5, 0);

    G1_1(ti) = max(G1_1(ti-1) + dG1_1, 0);
    G1_2(ti) = max(G1_2(ti-1) + dG1_2, 0);
    G1_3(ti) = max(G1_3(ti-1) + dG1_3, 0);
    G1_4(ti) = max(G1_4(ti-1) + dG1_4, 0);
    G1_5(ti) = max(G1_5(ti-1) + dG1_5, 0);

    G2_1(ti) = max(G2_1(ti-1) + dG2_1, 0);
    G2_2(ti) = max(G2_2(ti-1) + dG2_2, 0);
    G2_3(ti) = max(G2_3(ti-1) + dG2_3, 0);
    G2_4(ti) = max(G2_4(ti-1) + dG2_4, 0);
    G2_5(ti) = max(G2_5(ti-1) + dG2_5, 0);

    D1_1(ti) = max(D1_1(ti-1) + dD1_1, 0);
    D1_2(ti) = max(D1_2(ti-1) + dD1_2, 0);
    D1_3(ti) = max(D1_3(ti-1) + dD1_3, 0);
    D1_4(ti) = max(D1_4(ti-1) + dD1_4, 0);
    D1_5(ti) = max(D1_5(ti-1) + dD1_5, 0);

    D2_1(ti) = max(D2_1(ti-1) + dD2_1, 0);
    D2_2(ti) = max(D2_2(ti-1) + dD2_2, 0);
    D2_3(ti) = max(D2_3(ti-1) + dD2_3, 0);
    D2_4(ti) = max(D2_4(ti-1) + dD2_4, 0);
    D2_5(ti) = max(D2_5(ti-1) + dD2_5, 0);

end



% disinhibitory model simulation
%parameters
V1_1 = 50; V1_2 = 45; V1_3 = 40; V1_4 = 35; V1_5 = 30;
V2_1 = 5; V2_2 = 10; V2_3 = 15; V2_4 = 20; V2_5 = 25;
beta = .9;
dur = 2;

% initial values
R1_1 = R1_1(ti); R1_2 = R1_2(ti); R1_3 = R1_3(ti); R1_4 = R1_4(ti); R1_5 = R1_5(ti);
R2_1 = R2_1(ti); R2_2 = R2_2(ti); R2_3 = R2_3(ti); R2_4 = R2_4(ti); R2_5 = R2_5(ti);
G1_1 = G1_1(ti); G1_2 = G1_2(ti); G1_3 = G1_3(ti); G1_4 = G1_4(ti); G1_5 = G1_5(ti);
G2_1 = G2_1(ti); G2_2 = G2_2(ti); G2_3 = G2_3(ti); G2_4 = G2_4(ti); G2_5 = G2_5(ti);

for ti = 2:(dur/dt)
    dR1_1 = (-R1_1(ti-1) + (alpha*R1_1(ti-1)+V1_1) / (1+G1_1(ti-1)))*dt/tau;
    dR1_2 = (-R1_2(ti-1) + (alpha*R1_2(ti-1)+V1_2) / (1+G1_2(ti-1)))*dt/tau;
    dR1_3 = (-R1_3(ti-1) + (alpha*R1_3(ti-1)+V1_3) / (1+G1_3(ti-1)))*dt/tau;
    dR1_4 = (-R1_4(ti-1) + (alpha*R1_4(ti-1)+V1_4) / (1+G1_4(ti-1)))*dt/tau;
    dR1_5 = (-R1_5(ti-1) + (alpha*R1_5(ti-1)+V1_5) / (1+G1_5(ti-1)))*dt/tau;

    dR2_1 = (-R2_1(ti-1) + (alpha*R2_1(ti-1)+V2_1) / (1+G2_1(ti-1)))*dt/tau;
    dR2_2 = (-R2_2(ti-1) + (alpha*R2_2(ti-1)+V2_2) / (1+G2_2(ti-1)))*dt/tau;
    dR2_3 = (-R2_3(ti-1) + (alpha*R2_3(ti-1)+V2_3) / (1+G2_3(ti-1)))*dt/tau;
    dR2_4 = (-R2_4(ti-1) + (alpha*R2_4(ti-1)+V2_4) / (1+G2_4(ti-1)))*dt/tau;
    dR2_5 = (-R2_5(ti-1) + (alpha*R2_5(ti-1)+V2_5) / (1+G2_5(ti-1)))*dt/tau;
    
    dG1_1 = (-G1_1(ti-1) + w1*R1_1(ti-1) + w2*R2_1(ti-1) - D1_1(ti-1))*dt/tau;
    dG1_2 = (-G1_2(ti-1) + w1*R1_2(ti-1) + w2*R2_2(ti-1) - D1_2(ti-1))*dt/tau;
    dG1_3 = (-G1_3(ti-1) + w1*R1_3(ti-1) + w2*R2_3(ti-1) - D1_3(ti-1))*dt/tau;
    dG1_4 = (-G1_4(ti-1) + w1*R1_4(ti-1) + w2*R2_4(ti-1) - D1_4(ti-1))*dt/tau;
    dG1_5 = (-G1_5(ti-1) + w1*R1_5(ti-1) + w2*R2_5(ti-1) - D1_5(ti-1))*dt/tau;

    dG2_1 = (-G2_1(ti-1) + w1*R1_1(ti-1) + w2*R2_1(ti-1) - D2_1(ti-1))*dt/tau;
    dG2_2 = (-G2_2(ti-1) + w1*R1_2(ti-1) + w2*R2_2(ti-1) - D2_2(ti-1))*dt/tau;
    dG2_3 = (-G2_3(ti-1) + w1*R1_3(ti-1) + w2*R2_3(ti-1) - D2_3(ti-1))*dt/tau;
    dG2_4 = (-G2_4(ti-1) + w1*R1_4(ti-1) + w2*R2_4(ti-1) - D2_4(ti-1))*dt/tau;
    dG2_5 = (-G2_5(ti-1) + w1*R1_5(ti-1) + w2*R2_5(ti-1) - D2_5(ti-1))*dt/tau;

    dD1_1 = (-D1_1(ti-1) + beta*R1_1(ti-1))*dt/tau;
    dD1_2 = (-D1_2(ti-1) + beta*R1_2(ti-1))*dt/tau;
    dD1_3 = (-D1_3(ti-1) + beta*R1_3(ti-1))*dt/tau;
    dD1_4 = (-D1_4(ti-1) + beta*R1_4(ti-1))*dt/tau;
    dD1_5 = (-D1_5(ti-1) + beta*R1_5(ti-1))*dt/tau;

    dD2_1 = (-D2_1(ti-1) + beta*R2_1(ti-1))*dt/tau;
    dD2_2 = (-D2_2(ti-1) + beta*R2_2(ti-1))*dt/tau;
    dD2_3 = (-D2_3(ti-1) + beta*R2_3(ti-1))*dt/tau;
    dD2_4 = (-D2_4(ti-1) + beta*R2_4(ti-1))*dt/tau;
    dD2_5 = (-D2_5(ti-1) + beta*R2_5(ti-1))*dt/tau;


    R1_1(ti) = max(R1_1(ti-1) + dR1_1, 0);
    R1_2(ti) = max(R1_2(ti-1) + dR1_2, 0);
    R1_3(ti) = max(R1_3(ti-1) + dR1_3, 0);
    R1_4(ti) = max(R1_4(ti-1) + dR1_4, 0);
    R1_5(ti) = max(R1_5(ti-1) + dR1_5, 0);
    
    R2_1(ti) = max(R2_1(ti-1) + dR2_1, 0);
    R2_2(ti) = max(R2_2(ti-1) + dR2_2, 0);
    R2_3(ti) = max(R2_3(ti-1) + dR2_3, 0);
    R2_4(ti) = max(R2_4(ti-1) + dR2_4, 0);
    R2_5(ti) = max(R2_5(ti-1) + dR2_5, 0);

    G1_1(ti) = max(G1_1(ti-1) + dG1_1, 0);
    G1_2(ti) = max(G1_2(ti-1) + dG1_2, 0);
    G1_3(ti) = max(G1_3(ti-1) + dG1_3, 0);
    G1_4(ti) = max(G1_4(ti-1) + dG1_4, 0);
    G1_5(ti) = max(G1_5(ti-1) + dG1_5, 0);

    G2_1(ti) = max(G2_1(ti-1) + dG2_1, 0);
    G2_2(ti) = max(G2_2(ti-1) + dG2_2, 0);
    G2_3(ti) = max(G2_3(ti-1) + dG2_3, 0);
    G2_4(ti) = max(G2_4(ti-1) + dG2_4, 0);
    G2_5(ti) = max(G2_5(ti-1) + dG2_5, 0);

    D1_1(ti) = max(D1_1(ti-1) + dD1_1, 0);
    D1_2(ti) = max(D1_2(ti-1) + dD1_2, 0);
    D1_3(ti) = max(D1_3(ti-1) + dD1_3, 0);
    D1_4(ti) = max(D1_4(ti-1) + dD1_4, 0);
    D1_5(ti) = max(D1_5(ti-1) + dD1_5, 0);

    D2_1(ti) = max(D2_1(ti-1) + dD2_1, 0);
    D2_2(ti) = max(D2_2(ti-1) + dD2_2, 0);
    D2_3(ti) = max(D2_3(ti-1) + dD2_3, 0);
    D2_4(ti) = max(D2_4(ti-1) + dD2_4, 0);
    D2_5(ti) = max(D2_5(ti-1) + dD2_5, 0);

end

h = figure; hold on;
plot(R1_1,'k-','LineWidth',2);
plot(R2_1, 'k--','LineWidth',2);
plot(R1_2,'b-','LineWidth',2);
plot(R2_2,'b--','LineWidth',2);
plot(R1_3,'r-','LineWidth',2);
plot(R2_3,'r--','LineWidth',2);
plot(R1_4,'g-','LineWidth',2);
plot(R2_4,'g--','LineWidth',2);
plot(R1_5,'m-','LineWidth',2);
plot(R2_5,'m--','LineWidth',2);
xlabel('t/msecs');
ylabel('Firing rates/Hz');
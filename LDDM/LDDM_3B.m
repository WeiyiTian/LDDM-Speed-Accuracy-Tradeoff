%% 3B V1 increases

% parameters
dt = 0.001;
tau = 0.2;
w1 = 1;
w2 = 1;
dur = 2;
beta = 0;
alpha = .9;
V2 = 30;
V1_1 = 10; V1_2 = 20; V1_3 = 30; V1_4 = 40; V1_5 = 50;

% initial values
D1_1 = 0; D1_2 = 0; D1_3 = 0; D1_4 = 0; D1_5 = 0;
G1_1 = 0; G1_2 = 0; G1_3 = 0; G1_4 = 0; G1_5 = 0;
R1_1 = 0; R1_2 = 0; R1_3 = 0; R1_4 = 0; R1_5 = 0;
D2_1 = 0; D2_2 = 0; D2_3 = 0; D2_4 = 0; D2_5 = 0;
R2_1 = 0; R2_2 = 0; R2_3 = 0; R2_4 = 0; R2_5 = 0;
G2_1 = 0; G2_2 = 0; G2_3 = 0; G2_4 = 0; G2_5 = 0;

% simulation
for ti = 2:(dur/dt)

    dR1_1 = (-R1_1(ti-1) + (alpha*R1_1(ti-1)+V1_1) / (1+G1_1(ti-1)))*dt/tau;
    dR1_2 = (-R1_2(ti-1) + (alpha*R1_2(ti-1)+V1_2) / (1+G1_2(ti-1)))*dt/tau;
    dR1_3 = (-R1_3(ti-1) + (alpha*R1_3(ti-1)+V1_3) / (1+G1_3(ti-1)))*dt/tau;
    dR1_4 = (-R1_4(ti-1) + (alpha*R1_4(ti-1)+V1_4) / (1+G1_4(ti-1)))*dt/tau;
    dR1_5 = (-R1_5(ti-1) + (alpha*R1_5(ti-1)+V1_5) / (1+G1_5(ti-1)))*dt/tau;

    dR2_1 = (-R2_1(ti-1) + (alpha*R2_1(ti-1)+V2) / (1+G2_1(ti-1)))*dt/tau;
    dR2_2 = (-R2_2(ti-1) + (alpha*R2_2(ti-1)+V2) / (1+G2_2(ti-1)))*dt/tau;
    dR2_3 = (-R2_3(ti-1) + (alpha*R2_3(ti-1)+V2) / (1+G2_3(ti-1)))*dt/tau;
    dR2_4 = (-R2_4(ti-1) + (alpha*R2_4(ti-1)+V2) / (1+G2_4(ti-1)))*dt/tau;
    dR2_5 = (-R2_5(ti-1) + (alpha*R2_5(ti-1)+V2) / (1+G2_5(ti-1)))*dt/tau;
    
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
plot(R1_2,'b-','LineWidth',2);
plot(R1_3,'r-','LineWidth',2);
plot(R1_4,'g-','LineWidth',2);
plot(R1_5,'m-','LineWidth',2);
legend({'V1=10','V1=20','V1=30', 'V1=40', 'V1=50'});
xlabel('t/msecs');
ylabel('R1 Firing rates/Hz');

%% 3B V2 increases

% parameters
dt = 0.001;
tau = 0.2;
w1 = 1;
w2 = 1;
dur = 2;
alpha = .9;
beta = 0;
V1 = 30;
V2_1 = 10; V2_2 = 20; V2_3 = 30; V2_4 = 40; V2_5 = 50;

% initial values
D1_1 = 0; D1_2 = 0; D1_3 = 0; D1_4 = 0; D1_5 = 0;
G1_1 = 0; G1_2 = 0; G1_3 = 0; G1_4 = 0; G1_5 = 0;
R1_1 = 0; R1_2 = 0; R1_3 = 0; R1_4 = 0; R1_5 = 0;
D2_1 = 0; D2_2 = 0; D2_3 = 0; D2_4 = 0; D2_5 = 0;
R2_1 = 0; R2_2 = 0; R2_3 = 0; R2_4 = 0; R2_5 = 0;
G2_1 = 0; G2_2 = 0; G2_3 = 0; G2_4 = 0; G2_5 = 0;

% simulation
for ti = 2:(dur/dt)

    dR1_1 = (-R1_1(ti-1) + (alpha*R1_1(ti-1)+V1) / (1+G1_1(ti-1)))*dt/tau;
    dR1_2 = (-R1_2(ti-1) + (alpha*R1_2(ti-1)+V1) / (1+G1_2(ti-1)))*dt/tau;
    dR1_3 = (-R1_3(ti-1) + (alpha*R1_3(ti-1)+V1) / (1+G1_3(ti-1)))*dt/tau;
    dR1_4 = (-R1_4(ti-1) + (alpha*R1_4(ti-1)+V1) / (1+G1_4(ti-1)))*dt/tau;
    dR1_5 = (-R1_5(ti-1) + (alpha*R1_5(ti-1)+V1) / (1+G1_5(ti-1)))*dt/tau;

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
plot(R1_2,'b-','LineWidth',2);
plot(R1_3,'r-','LineWidth',2);
plot(R1_4,'g-','LineWidth',2);
plot(R1_5,'m-','LineWidth',2);
legend({'V2=10','V2=20','V2=30', 'V2=40', 'V2=50'});
xlabel('t/msecs');
ylabel('R1 Firing rates/Hz');
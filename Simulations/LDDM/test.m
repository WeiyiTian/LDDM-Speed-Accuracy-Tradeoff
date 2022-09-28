%% noise

% parameters
dt = .001;
tau = .1;
noise_tau = .002;
w1 = 1;
w2 = 1;
alpha = 15;
beta = 1.1;
dur = 10;
sgm = .5;
threshold = 70;
S = 10;

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

choice_time = 0;
choice = 0;

% simulation
for ri = 2:(1/dt)
    r = ri/1000;
    [choice(ri), choice_time(ri)] = ave_choice(r);

end

tiledlayout(2,1)

nexttile
plot(choice_time,'k-','LineWidth',3);
xlabel('Input Ratio');
ylabel('RT');
title('Choice Time')
set(gca, 'XTickLabel', 0:0.1:1)

nexttile
plot(choice,'k-','LineWidth',3);
xlabel('Input Ratio');
ylabel('Choice(%)');
title('Choice')
set(gca, 'XTickLabel', 0:0.1:1)

function [choice, choice_time] = ave_choice(r)
    % parameters
    dt = .001;
    tau = .1;
    noise_tau = .002;
    w1 = 1;
    w2 = 1;
    alpha = 15;
    beta = 1.1;
    dur = 10;
    sgm = .5;
    threshold = 70;
    S = 10;
    
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
    
    choice_time = 0;
    choice = 0;

    V1 = 2 * S * r;
    V2 = 2 * S - V1;
    
    for ri = 2:1024
        for ti = 2:dur/dt
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
    
            if R1(ti) > threshold
                choice = choice + 1;
                choice_time = choice_time + ti;
                break
            elseif R2(ti) > threshold
                choice_time = choice_time + ti;
                break
            end
        end

    end

    choice_time = choice_time / 1024;
    choice = choice /1024;

end    
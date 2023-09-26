%% Main file to fit Hanks data
% write your own help language here

%% set up directory
numNode = 1;
myCluster  = parcluster();
sortNum = 1;
%[sortNum, myCluster] = RndCtrl(numNode);
mypool = parpool(myCluster, myCluster.NumWorkers);

%% set path
addpath(genpath('../../'))
addpath(genpath('../'))
addpath(genpath('./bads-master'));
out_dir = './result';
if ~exist(out_dir,'dir')
    mkdir(out_dir);
end

%% Take data from Hanks, et al., 2014
% monkey D
dataBhvr = load_data("../../Empirical Data/behavData_dam.mat");

%% define the range of the parameters
% Define optimization starting point and bounds
%   a_acc,  b_acc, a_speed, b_speed, noiseInput, scale, Tau
LB = [0     0.1      0      0.1     0         .1*256  [.001,.001,.001]];
UB = [70    3	    70      3       2           20*256  [1,1,1]];
PLB = [15   .9	    15      .9      .8          1*256   [.01 .01 .01]];
PUB = [60   1.7	    60      1.7     1.2          8*256   [.2 .2 .2]];

% Randomize initial starting point inside plausible box
x0 = rand(1,numel(LB)) .* (PUB - PLB) + PLB;

%% define the negative loglikelihood function (nLLfun)
nLLfun = @(params) LDDM_Rndinput_fit(params, dataBhvr);

%% first attempt to evaluate the nLLfun
[fvalbest, ~, ~] = nLLfun(x0);
fprintf('test succeeded\n');

%% start to fit
Collect = [];
parfor i = 1:myCluster.NumWorkers*4
    !ping -c 1 www.amazon.com
    t = datenum(clock)*10^10 - floor(datenum(clock)*100)*10^8 + sortNum*10^7 + i*10^5;
    %num2str(t);
    rng(t);
    
    % Randomize initial starting point inside plausible box
    x0 = rand(1,numel(LB)) .* (PUB - PLB) + PLB;
    dlmwrite(fullfile(out_dir,'x0List.txt'),[sortNum, i, t, x0],'delimiter','\t','precision','%.6f','-append');
    % fit
    options = bads('defaults');     % Default options
    options.Display = 'iter';
    % For this optimization, we explicitly tell BADS that the objective is
    % noisy (it is not necessary, but it is a good habit)
    options.UncertaintyHandling = true;    % Function is stochastic
    % specify a rough estimate for the value of the standard deviation of the noise in a neighborhood of the solution.
    options.NoiseSize = 2.7;  % Optional, leave empty if unknown
    % We also limit the number of function evaluations, knowing that this is a
    % simple example. Generally, BADS will tend to run for longer on noisy
    % problems to better explore the noisy landscape.
    % options.MaxFunEvals = 3000;
    
    % Finally, we tell BADS to re-evaluate the target at the returned solution
    % with ** samples (10 by default). Note that this number counts towards the budget
    % of function evaluations.
    options.NoiseFinalSamples = 20;
    [xest,fval,~,output] = bads(nLLfun,x0,LB,UB,PLB,PUB,[],options);
    dlmwrite(fullfile(out_dir,'RsltList.txt'),[sortNum, i, t, xest fval],'delimiter','\t','precision','%.6f','-append');

    Collect(i).rndseed = t;
    Collect(i).x0 = x0;
    Collect(i).xest = xest;
    Collect(i).fval = fval;
    Collect(i).output = output;
end
t = datenum(clock)*10^10 - floor(datenum(clock)*100)*10^8 + sortNum*10^7 + i*10^5;
save(fullfile(out_dir,sprintf('CollectRslts%i.mat',t)),'Collect');

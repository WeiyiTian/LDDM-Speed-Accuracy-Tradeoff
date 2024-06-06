addpath('../../../utils')

monkey = 'Monkey E';
version = "Version 12";
filename = "Ev12";

sgmInput = 11.875469;
S = 309.729124;
amp = 0.776279;
gamma = 0.698394;
tauR = 0.035021;
tauG = 0.132645;
tauD = 0.131028;

params = [sgmInput, S, amp, gamma, tauR, tauG, tauD];

RT_heatmap(params, monkey, version, filename)
addpath('../../../utils')

monkey = 'Monkey D';
version = "Version 14";
filename = "Dv14";

sgmInput = 8.979492;
S = 306.750000;
amp = 0.895508;
gamma = 0.909521;
tauR = 0.037411;
tauG = 0.011934;
tauD = 0.176436;

params = [sgmInput, S, amp, gamma, tauR, tauG, tauD];

RT_heatmap(params, monkey, version, filename)
clear; close all; qs_paths;

huge_parameters(struct('N',30, 'M',90, 'T',3, 'W',3, 'steps',10, 'samples',500, 'gamma',.9, 'epsilon',.001, 'kernel', k_gaussian(k_norm(), .6)));

reward = kpirl_spd('huge');
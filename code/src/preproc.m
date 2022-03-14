% (C) Copyright 2019 Remi Gau

clear;
clc;

% Sets up the environment for the analysis and add libraries to the path
initEnv();

%% Set options
opt = preprocOption();

%% Run batches
bidsCopyInputFolder(opt);

bidsSpatialPrepro(opt);

% The following do not run on octave for now (because of spmup)
anatomicalQA(opt);
bidsResliceTpmToFunc(opt);
functionalQA(opt);

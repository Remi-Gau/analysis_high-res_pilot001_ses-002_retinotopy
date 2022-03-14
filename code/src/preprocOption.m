% (C) Copyright 2020 Remi Gau, Marco Barilari

function opt = preprocOption()
    %
    % returns a structure that contains the options chosen by the user to run
    % slice timing correction, pre-processing, subject and group level analysis.
    %
    % for more info see:
    % <https://cpp-bids-spm.readthedocs.io/en/latest/set_up.html#configuration-of-the-pipeline>
    % <https://cpp-bids-spm.readthedocs.io/en/latest/defaults.html#checkoptions>

    if nargin < 1
        opt = [];
    end

    % If the following fields are left empty then all subjects will be analyzed.
    
    opt.subjects = 'pilot001';

    % task to analyze
    opt.taskName = 'retinotopyDriftingBar';
    
    opt.pipeline.type = 'preproc';

    % The directory where the data are located
    opt.dir.raw = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'inputs', 'raw');
    % You can specify where you want the data to be saved if the default location
    % does not suit you.
    opt.dir.derivatives = fullfile(fileparts( ...
                                            mfilename('fullpath')), ...
                                  '..', ...
                                  '..', ...
                                  'outputs', ...
                                  'derivatives');
    
    opt.bidsFilterFile.bold.ses = '002';
    opt.bidsFilterFile.bold.dir = '';
    
    opt.bidsFilterFile.t1w.suffix = 'UNIT1'; 
    opt.bidsFilterFile.t1w.acq = '.*denoised'; 

    % If you use 'individual', then we stay in native space (that of the anat image)
    % set to 'MNI' to normalize data
    opt.space = 'individual';


    %% DO NOT TOUCH
    opt = checkOptions(opt);
    saveOptions(opt);

end

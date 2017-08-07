%% run_all_extraction_scripts 
% This script runs all of the extraction scripts.
% This must be run from the Paper folder -- "example_project/Paper"

% This adds the extraction scripts to your path.
addpath(genpath('extractionScripts/'))


% This script extracts dentist data
extract_dentist_data


% This script extracts z stack data
extract_zstacks


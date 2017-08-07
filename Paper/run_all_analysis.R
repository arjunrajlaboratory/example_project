# Run all analysis scripts

rm(list = ls())

# Navigate to your Paper folder in R.
wd_variable <- '~/Dropbox (RajLab)/Projects/example_project/Paper'
setwd(wd_variable)

# This runs the RNA FISH analysis plot script.
source('plotScripts/RNA_FISH_plot_scripts/RNA_FISH_plots.R')

# This runs the RNA seq analysis script.
source('plotScripts/RNAseq/analysis_script.R')

# source your other plot scripts here too....


% extract_dentist_data
% This script extracts dentist data.

% This path is relative to the main Paper folder. It will first navigate 
% up to the "example_project folder" then down
% into the data folder.
cd ..
cd('Data/dentistData/')
% Of note, most data sets are not small enough to be stored locally on the
% dropbox (and synced up all at once), thus this can also be a hard path to
% an external disk drive that contains the data. Ideally, however, this
% data is also on the dropbox and it's location is at least in the comments
% of the code.

% Load settings.
load('dentistData.mat');
load('dentistConfig.mat');
spotsAndCentroids = dentist.load();

% This extracts x and y positions for each of the cells.
centers = [spotsAndCentroids.getCentroids.xPositions,... 
    spotsAndCentroids.getCentroids.yPositions];

% This extracts RNA counts (from alexa and cy) for each of the cells.
data = [spotsAndCentroids.getNumSpotsForCentroids('alexa'),...
    spotsAndCentroids.getNumSpotsForCentroids('cy')];

% Build a table with all the cell positions and RNA counts.
tt = array2table([centers data],'VariableNames',...
    {'Xpos','Ypos', 'alexaRNA','cyRNA'});

% Navigate into the Paper folder to save the data in extractData:
cd ..
cd ..
cd('Paper/extractedData/RNA_FISH_data/')

% Extract the data to a comma separted file:
writetable(tt,'example_dentist_data.csv')

% Navigate back up to the main "example_project" folder:
cd ..
cd ..


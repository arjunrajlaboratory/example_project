% This script extracts the RNA FISH counts from the data in the folder
% "rawImageStackData". It makes a table of counts and saves it in **.

% This path is relative to the main Paper folder. It will first navigate 
% up to the "example_project folder" then down
% into the data folder.
cd ..
cd('Data/rawImageStackData/')
% Of note, most data sets are not small enough to be stored locally on the
% dropbox (and synced up all at once), thus this can also be a hard path to
% an external disk drive that contains the data. Ideally, however, this
% data is also on the dropbox and it's location is at least in the comments
% of the code.


% Launch data extractor.
dataExtractor = improc2.launchDataExtractor;

% Specify that the number of RNA spots in channels cy, alexa, tmr should be 
% extracted and put into columns named cy.RNACounts, 
% alexa.RNACounts, tmr.RNACounts respectively:
dataExtractor.extractFromProcessorData('cy.RNACounts', @getNumSpots, 'cy')
dataExtractor.extractFromProcessorData('alexa.RNACounts', @getNumSpots, 'alexa')
dataExtractor.extractFromProcessorData('tmr.RNACounts', @getNumSpots, 'tmr')

% Navigate into the Paper folder to save the data in extractData:
cd ..
cd ..
cd('Paper/extractedData/RNA_FISH_data/')

% Extract the data to a comma separted file:
dataExtractor.extractAllToCSVFile('example_RNAFISH_zstack.csv')

% Navigate back up to the main "example_project" folder:
cd ..
cd ..

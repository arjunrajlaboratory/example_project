% This script is an example that makes image overlays. Will try and
% annotate all the relevant decisions and so forth.
% The paths below are based on the current working directory being the location of this script, 
% if it's not you can set the working directory by doing cd('~/Dropbox(Rajlab)/Projects/example_project/Paper/plotScripts/imageOverlays/'). 
loadDirectory = '../../extractedData/rawImageData/';
writeDirectory = '../../plots/imageOverlays/';


%% Load image data

dapiIm  = readmm([loadDirectory 'dapi001.tiff']);
tmrIm   = readmm([loadDirectory 'tmr001.tiff']);
transIm = readmm([loadDirectory 'trans001.tiff']);
alexaIm = readmm([loadDirectory 'alexa001.tiff']);

% These variables (dapiIm, etc.) are structures. Now let's get out the image
% data itself:

dapiIm  = dapiIm.imagedata;
tmrIm   = tmrIm.imagedata;
transIm = transIm.imagedata;
alexaIm = alexaIm.imagedata;

% Now let's make max-merges of the images:
% (This also includes some slice selection as noted.)

maxAlexaIm = max(alexaIm,[],3); % The "[], 3" means take max in 3rd (z) dimension.
maxDapiIm  = max(dapiIm(:,:,[2:5]),[],3); % this takes just slices 2-5. Sometimes cleans things up a bit.
maxTmrIm   = max(tmrIm,[],3);
maxTransIm = max(transIm(:,:,4),[],3); % this takes just slice 3. Taking a max of trans doesn't really work.


%% Image display, cropping, scaling
% Try to show the image:
imshow(maxAlexaIm); % The image looks black because it's not showing anything
imshow(maxAlexaIm,[]); % the [] option tells imshow to contrast things.

% Okay, I like that cell in the top left, will get that and another as
% well.
% Use the (commented out) command getrect to allow for interactive
% selection.
%R = getrect

% Now what we do is just type "R" to get the values and copy them in
% manually to the script:
R = [88.3833   75.3965  312.3947  190.7102];

% I'll typically clean up the rect to give it better numbers.
% Remember that the values are top, left, width, height.
R = [88.3833   75.3965  299 189]; % Note that this will crop to 300x190

% Crop the images
cropMaxAlexaIm = imcrop(maxAlexaIm,R);
cropMaxDapiIm  = imcrop(maxDapiIm,R);
cropMaxTmrIm   = imcrop(maxTmrIm,R);
cropMaxTransIm = imcrop(maxTransIm,R);

% You can also crop a whole stack this way if you want:
% cropStack = rectcropmulti(dapiIm,R);

% Now let's scale the contrast of the image so that it's easier to play
% with.
scaledAlexa = scale(cropMaxAlexaIm);
scaledDapi  = scale(cropMaxDapiIm);
scaledTmr   = scale(cropMaxTmrIm);
scaledTrans = scale(cropMaxTransIm);

%% Making overlays

% Let's make a straight image of Alexa in white, DAPI in blue.

% Use makeColoredImage to make a colored version of the image.
% e.g. makeColoredImage(im,[1 0 0]) makes red.
% makeColoredImage(im,[1 1 1]) makes white.
% makeColoredImage(im,[0 1 1]) makes cyan.
alexaDapi = makeColoredImage(scaledAlexa,[1 1 1])*1.5 + makeColoredImage(scaledDapi,[0 0 1]);
imshow(alexaDapi);
% Note the "*1.5" above. That makes alexa brighter, giving it a bit more
% pop. Dots show up much better printed if slightly blown out on the
% screen.

% Trans and DAPI
transDapi = makeColoredImage(scaledTrans,[1 1 1]) + makeColoredImage(scaledDapi,[0 0 1]);
imshow(transDapi);

% Color alexa (orange) and tmr (cyan) and show an overlay.
alexaOrange = makeColoredImage(scaledAlexa,[0.9648, 0.5781, 0.1172]);
tmrCyan     = makeColoredImage(scaledTmr,  [0, 0.6797, 0.9336]);

% Note that tmrCyan has a bright transcription site and needs to be pumped
% up.
% Also alexaOrange has a bit of background, so subtracting that out, too.

alexaTmr = (alexaOrange-0.08)*2 + tmrCyan*3;
imshow(alexaTmr);

%% Okay, now let's actually write the files

% Use im2uint16 to convert to 16 bit image from double. This saves space
% and is generally more compatible across formats and devices.
imwrite(im2uint16(alexaDapi),[writeDirectory 'alexaDapi.tiff']);
imwrite(im2uint16(transDapi),[writeDirectory 'transDapi.tiff']);
imwrite(im2uint16(alexaTmr),[writeDirectory 'alexaTmr.tiff']);

% NOTE FOR SCALE BAR: our cameras are 13µm per pixel. This means, at 100x,
% 0.13µm = 130nm per pixel. Use this to calculate the 5µm scale bar. In
% Illustrator, if the image is 300px wide = 5.9cm (or whatever), then the
% scale bar can be calculated: 300px*0.13µm/px = 39µm -> scale bar length
% should be 5µm/39µm*5.9cm = 0.76cm.

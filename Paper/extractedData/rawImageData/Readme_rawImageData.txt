
Here’s raw image data that we will use to make a series of cropped overlays for inclusion in a figure. What you want to document is exactly where this data came from. In this case, we would make sure this readme has the following information:

SamplePaper/Data/rawImageStackData/*001.tiff
From worked example distributed with rajlabimagetools:
https://bitbucket.org/arjunrajlaboratory/rajlabimagetools/wiki/workedExample

That should document which experiment the raw data came from, preferably with some sort description.

One reasonable question would be why don’t we just pull straight from the raw data. The reason is that the Paper folder is what people are far more likely to examine. This way, the raw image data is in that folder so that they can see easily and directly what image transformations we did to make the images in the paper.
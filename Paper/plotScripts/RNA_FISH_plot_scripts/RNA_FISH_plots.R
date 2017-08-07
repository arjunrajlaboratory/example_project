
# Run this script from the main "Paper" folder:

# Here are some useful libraries. These will need to be installed prior to use.
library('dplyr')
library('ggplot2')
library('reshape2')

# Specify a plot directory where we will save all of our plots:
plot_directory <- 'plots/RNA_FISH_plots/'

################################
# Let's load up the z-stack data:
zstack_fish_data <- read.csv('extractedData/RNA_FISH_data/example_RNAFISH_zstack.csv')

# Remove objects that we labeled as not being "good".
zstack_fish_data <- filter(zstack_fish_data, isGood=='true')

# Melt data into long format.
# For more info on this, see here:
# http://seananderson.ca/2013/10/19/reshape.html
zstack_fish_data_melt <- melt(zstack_fish_data, id.vars = c('objArrayNum','objNum','isGood'))

# Make a plot and save it.
ggplot(zstack_fish_data_melt, aes(x=variable,y=value, color=variable))+
  geom_point()+
  theme_classic()
ggsave(paste0(plot_directory,'zstack_geompoint.pdf'), height=7, width=9)

# Make a different plot and save it too.
ggplot(zstack_fish_data_melt, aes(x=variable,y=value, color=variable))+
  geom_violin()+
  theme_classic()
ggsave(paste0(plot_directory,'zstack_violin.pdf'), height=7, width=9)

# Make a different plot and save it too.
ggplot(zstack_fish_data_melt, aes(x=variable,y=value, color=variable))+
  geom_boxplot()+
  theme_classic()+
  ylim(0,300)
ggsave(paste0(plot_directory,'zstack_boxplot.pdf'), height=7, width=9)

################
# Now some analysis on the dentist data:
dentist_data <- read.csv('extractedData/RNA_FISH_data/example_dentist_data.csv')

# Melt data into long format.
dentist_data_melt <- melt(dentist_data, id.vars = c('Xpos','Ypos'))

# Make a plot and save it.
ggplot(dentist_data_melt, aes(x=variable,y=value, color=variable))+
  geom_point()+
  theme_classic()
ggsave(paste0(plot_directory,'dentist_geompoint.pdf'), height=7, width=9)

# Make a different plot and save it too.
ggplot(dentist_data_melt, aes(x=variable,y=value, color=variable))+
  geom_violin()+
  theme_classic()
ggsave(paste0(plot_directory,'dentist_violin.pdf'), height=7, width=9)

# Make a boxplot.
ggplot(dentist_data_melt, aes(x=variable,y=value, color=variable))+
  geom_boxplot()+
  theme_classic()
ggsave(paste0(plot_directory,'dentist_boxplot.pdf'), height=7, width=9)


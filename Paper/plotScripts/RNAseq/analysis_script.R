
# This scripts gives a brief example of RNA seq analysis.

# Libraries ----------------
library(dplyr)
library(tidyr)
library(data.table)
library(ggplot2)
library(ineq)
library(DESeq2)
library(reshape2)
library(rmarkdown)
library(GenomicFeatures)
library(tidyverse)
library(data.table)
library(ggbiplot)
library(RColorBrewer)
library(VennDiagram)

# Directories ---------------------------
geneIDdir <- 'extractedData/RNA_seq_data/annotations/hg19gene_idToGeneSymbol.tsv' # we use this file to convert Ids to gene names.
hg19_GTF <- 'extractedData/RNA_seq_data/annotations/hg19_forHTSeq.gtf' # we use this file for gene lengths.
plot_dir <- 'plots/RNAseq_plots/'

# Load data ---------------------------
rnaseq_data <- read.csv('extractedData/RNA_seq_data/count_tables/wm9LdB_star_HTSeqCounts_full.tsv', sep='\t')
meta_data <- read.csv('extractedData/RNA_seq_data/meta_data/metaDataTableAllWM9LdB.csv')
# Remove 2 columns from the metadata that we don't need.
meta_data$fileNameLocally <- NULL
meta_data$fileNameOnGEO <- NULL

# Merge meta data with the main RNA seq data
rnaseq_data <- merge(rnaseq_data, meta_data, by = 'sampleID')

# Filter out entries in the table that are not genes.
rnaseq_data <- rnaseq_data %>%
  filter(gene_id != "__alignment_not_unique" & gene_id != "__ambiguous" & gene_id != "__no_feature" & gene_id != "__not_aligned" & gene_id != "__too_low_aQual")

# Make a table of gene lengths.
txdb <- makeTxDbFromGFF(file = hg19_GTF, 
                        format="gtf")
lengthsPergeneid <- sum(width(IRanges::reduce(exonsBy(txdb, by = "gene"))))
lengthtbl<-data.frame(
  gene_id = names(lengthsPergeneid),
  length = lengthsPergeneid
)
geneIDtoGeneName <- read.table(file = geneIDdir, sep = "\t", header = TRUE)
lengthtbl <- left_join(lengthtbl, geneIDtoGeneName, by = 'gene_id')

# Merge the length table with the main data set.
rnaseq_data <- left_join(rnaseq_data, lengthtbl, by='gene_id')

# Calculate RPM, RPK, TPM, RPKM:
rnaseq_data<-rnaseq_data %>%
  dplyr::group_by(sampleID) %>%
  dplyr::mutate(totalMappedReads = sum(counts), 
                rpm = 1000000*counts/totalMappedReads, 
                rpk = 1000*counts/length,
                rpkScalePerMillion = sum(rpk)/1000000,
                tpm = rpk/rpkScalePerMillion,
                rpkm = 1000*rpm/length)

# Make some plots:
plot_data <- filter(rnaseq_data, GeneSymbol=='EGFR' | GeneSymbol=='NGFR' | GeneSymbol=='AXL' | GeneSymbol=='WNT5A')
ggplot(plot_data, aes(x=resistant, y=tpm, fill=resistant))+
  geom_boxplot(alpha=0.99)+
  facet_wrap(~GeneSymbol,scales='free')+theme_classic()
ggsave(paste0(plot_dir,'rnaseq_boxplot_EGFR_AX_NGFR_WNT5A.pdf'),height=7, width=9)


ggplot(plot_data, aes(x=resistant, y=tpm, color=resistant))+
  geom_jitter(alpha=0.99)+
  facet_wrap(~GeneSymbol,scales='free')+theme_classic()
ggsave(paste0(plot_dir,'rnaseq_jitter_EGFR_AX_NGFR_WNT5A.pdf'),height=7, width=9)


# Heatmap 
# Filter out a list of genes of interest.
plot_data_2 <- filter(rnaseq_data, GeneSymbol=='EGFR' | GeneSymbol=='NRG1' | GeneSymbol=='AXL' | GeneSymbol=='WNT5A' | GeneSymbol=='LOXL2')

# Format the data as 1 big matrix with gene names in the rows and sample names for the columns.
heatmap_data <- acast(plot_data_2, 'GeneSymbol~sampleID', value.var='tpm')

# Colors for the heatmap
color4heatmap <- rev(brewer.pal(11,'RdYlBu'))

# Plot heatmap and save a PDF.
pdf(paste0(plot_dir,'heatmap_EGFR_NRG1_AXL_WNT5A_LOXL2.pdf'),width=7,height=10)
wm9heatmap <- gplots::heatmap.2(t(as.matrix(heatmap_data)), 
                                scale = 'column', 
                                #Colv = as.dendrogram(geneClustering), Rowv = FALSE,
                                #dendrogram = 'column',
                                col = color4heatmap,
                                density.info='none', 
                                symkey=FALSE, trace='none',
                                margins = c(7,12), cexCol=1)
dev.off()



## HNSCC summary of variation in genes of interest

install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot2")
library(dplyr)
library(tidyr)
library(ggplot2)

# import data
system("sed 's/(.*$//g' HNSCCgeneData.csv > temp")
dat <- read.delim("temp")

# plot by gene and type of mutation
ggplot(dat, aes(gene, fill=where_in_gene)) + geom_bar(position="dodge") + geom_bar(position="dodge", colour="black", show_guide=FALSE) + scale_fill_brewer(palette="Set1", name="location in\ngene") + ylab("number of mutations") + theme_bw()
ggsave(file="figures/mutations.pdf")

# plot by synonymous/nonsynonymous
CDS <- dat %>%
  select(gene, where_in_gene, annot_cancer) %>%
  filter(where_in_gene == "CDS")
CDS$annot_cancer <- gsub(".*->.*", "nonsynonymous", CDS$annot_cancer)
  
ggplot(CDS, aes(gene, fill=annot_cancer)) + geom_bar(position="dodge") + geom_bar(position="dodge", colour="black", show_guide=FALSE) + scale_fill_brewer(palette="Set1", name="") + ylab("number of mutations") + theme_bw()
ggsave(file="figures/synnonsyn.pdf")

# import filtered data
filt <- read.delim("HNSCCgeneTable.csv") 

ggplot(filt, aes(gene)) +geom_bar() + ylab("number of mutations") + theme_bw()
ggsave(file="figures/filterednonsyn.pdf")

# parse data by gene and type of mutation
geneType <- dat %>%
  group_by(gene, where_in_gene) %>%
  tally() %>%
  spread(where_in_gene, n) %>%
  transform(total=sum(2:7, na.rm=TRUE))
geneType <- transform(geneType, total=rowSums(geneType[,2:7], na.rm=TRUE))
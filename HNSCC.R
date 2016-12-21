## HNSCC summary of variation in genes of interest

#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("ggplot2")
#install.packages("stringr")
#install.packages("gridExtra")
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(gridExtra)

# import data
# complete data
dat <- read.delim("data/Ot6699_Ot6700_Santanu.Dasgupta_300-923_hEx-AV4_30x_01132013_Cancer_Nucleotide_Variation.csv")
# all somatic data
datSom <- read.delim("data/all_somatic.csv")
# target gene somatic data
datTarget <- read.delim("data/targetGenes.csv")
# target gene unique somatic data
datUnique <- read.delim("data/target_unique.csv")

# assess number of mutations across whole genome
str(datSom) #25045 somatic mutations in whole genome
# tally genome-wide somatic mutations by type (SNP, MNP, etc)
datSom %>%
  group_by(kind_cancer) %>%
  tally()
# tally CDS: 1868 somatic mutations in CDS
datSom %>%
  filter(where_in_gene == "CDS") %>%
  tally()
# tally CDS by gene: 1868 somatic mutations in CDS
allGeneTally <- datSom %>%
  filter(where_in_gene == "CDS") %>%
  group_by(gene) %>%
  tally()
allGeneTally %>%
  filter(n >5)
# evaluate syn, nonsyn, and frameshift (37) in all CDS
datSom %>%
  filter(where_in_gene == "CDS") %>%
  filter(str_detect(annot_cancer, "synonymous")) %>%
  tally() # 726 synonymous; 5 also listed as nonsyn so count as 721
datSom %>%
  filter(where_in_gene == "CDS") %>%
  filter(str_detect(annot_cancer, "frameshift")) %>%
  tally() # 37 frameshift
datSom %>%
  filter(where_in_gene == "CDS") %>%
  filter(str_detect(annot_cancer, "->")) %>%
  tally() # 1110 nonsynonymous

# assess number of somatic mutations per target gene
tarAll <- datTarget %>%
  group_by(gene) %>%
  tally()
tarCDS <- datTarget %>%
  filter(where_in_gene == "CDS") %>%
  group_by(gene) %>%
  tally()
tarNonsym <- datTarget %>%
  filter(where_in_gene == "CDS") %>%
  filter(str_detect(annot_cancer, "synonymous")) %>%
  group_by(gene) %>%
  tally()
tarUnique <- datTarget %>%
  filter(where_in_gene == "CDS") %>%
  filter(!str_detect(annot_cancer, "synonymous")) %>%
  filter(!str_detect(dbsnp, "rs")) %>%
  group_by(gene) %>%
  tally()
CDS.Nonsyn.Uniq.Target <- cbind(tarCDS, tarNonsym$n, tarUnique$n)

# A: somatic mutations in target genes based on location in gene
A <- ggplot(datTarget, aes(gene, fill=where_in_gene)) + 
  geom_bar(position="dodge", colour="black", show.legend=FALSE) + 
  scale_fill_brewer(palette="Set1", name="location in\ngene") + 
  ylab("number of somatic mutations") + 
  xlab("genes harboring mutations") + 
  theme_bw() + 
  theme(axis.text.x=element_text(size=8))
A
ggsave("figures/A.jpg")

# B: total somatic mutations in target genes
B <- ggplot(datTarget, aes(gene)) + 
  geom_bar(colour="black", show.legend=FALSE) + 
  ylab("number of total somatic mutations") + 
  xlab("genes harboring mutations") + 
  theme_bw() + 
  theme(axis.text.x=element_text(size=8))
B
ggsave("figures/B.jpg")

# C: somatic mutations in CDS by synonymous/nonsynonymous
CDS <- datTarget %>%
  select(gene, where_in_gene, annot_cancer) %>%
  filter(where_in_gene == "CDS")
CDS$annot_cancer <- sub("synonymous (.*)", "synonymous", CDS$annot_cancer)
CDS$annot_cancer <- gsub(".*->.*", "nonsynonymous", CDS$annot_cancer)

C <- ggplot(CDS, aes(gene, fill=annot_cancer)) + 
  geom_bar(position="dodge", colour="black", show.legend=FALSE) + 
  scale_fill_brewer(palette="Set1", name="") + 
  ylab("number of somatic CDS mutations") + 
  xlab("genes harboring mutations") + 
  theme_bw() + 
  theme(axis.text.x=element_text(size=8))
C
ggsave("figures/C.jpg")

# D: new somatic mutations in CDS of target genes
unique <- datTarget %>%
  filter(where_in_gene == "CDS") %>%
  filter(!str_detect(dbsnp, "rs"))
  
D <- ggplot(unique, aes(gene)) + 
  geom_bar(colour="black", show.legend=FALSE) + 
  ylab("number of new somatic CDS mutations") + 
  xlab("genes harboring mutations") +
  theme_bw() + 
  theme(axis.text.x=element_text(size=8))
D
ggsave("figures/D.jpg")

# combine plots
jpeg(file="figures/combined.jpg")
grid.arrange(A, B, C, D, ncol=2)
dev.off()

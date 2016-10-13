# HNSCCtargetGenes

Genomic analysis of HPV-induced oropharyngeal cancer (paired tumor/normal samples).

Workflow:
* sequencing, SNP calling and annotation performed by Otogenetics (http://www.otogenetics.com)
* raw sequence data can be found at NCBI SRA #SRP081299
* `data/` contains: (to be released with publication)
	* somatic SNP data (`1Ot6699_Ot6700_Santanu.Dasgupta_300-923_hEx-AV4_30x_01132013_Cancer_Nucleotide_Variation`)
	* SNP data from target genes (`HNSCCgeneData.csv`)
	* summarized, unique SNPs (`HNSCCgeneTable.csv`)
* `candidateGenes.lst` is a list of target genes
* `table.sh` is the script used to derive the `.csv` files in `data/`
* `HNSCC.R` is the R script used to obtain figures from parsed gene data
* `figures/` contains figures produced from `HNSCC.R` 

# HNSCCtargetGenes

Genomic analysis of HPV-induced oropharyngeal cancer (paired tumor/normal samples).

Raw data are available from NCBI SRA #SRP081299

Associated publication: [Kannan, A., Hertweck, K.L., Philley, J.V., Wells, R.B. and Dasgupta, S., 2017. Genetic Mutation and Exosome Signature of Human Papilloma Virus Associated Oropharyngeal Cancer. Scientific Reports, 7.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5382706/)a

Workflow:
* sequencing, SNP calling and annotation performed by Otogenetics (http://www.otogenetics.com)
* raw sequence data can be found at NCBI SRA #SRP081299
* `data/` contains:
	* `Ot6699_Ot6700_Santanu.Dasgupta_300-923_hEx-AV4_30x_01132013_Cancer_Nucleotide_Variation`: somatic variation, includes somatic variants and loss of heterozygotes (
	* `variantTypes.txt`: all possible variants (comparing normal and cancer)
	* `all_somatic.csv`: original file strictly filtered for only somatic variants (LOH removed)
	* `HNSCC_*.csv`: all somatic variants, filtered by CDS, nonsynonymous, then unique (not in dbSNP)
	* `target_*.csv`: somatic variants from target genes, filtered by CDS, nonsynonymous, then unique (not in dbSNP)
* `candidateGenes.lst` is a list of target genes
* `table.sh` is the script used to derive the `.csv` files in `data/`
* `HNSCC.R` is the R script used to obtain figures from parsed gene data
* `figures/` contains figures produced from `HNSCC.R` 

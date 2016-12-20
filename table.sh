## HNSSC
## Building table of non-synonymous somatic mutations for verified genes 
## Data formet
##	$DATA with the following columns: 1 chr, 2 left_cancer (position), 15 gene, 17 annot_cancer

DATA=~/Dropbox/cancerGenomics/HNSCC/data/Ot6699_Ot6700_Santanu.Dasgupta_300-923_hEx-AV4_30x_01132013_Cancer_Nucleotide_Variation.csv
SCRIPTS=~/GitHub/HNSCCtargetGenes

cd ~/Dropbox/cancerGenomics/HNSCC/analysis

## target genes
# extract all data from target genes
for x in `cat $SCRIPTS/candidateGenes.lst`
	do
		grep $x $DATA >> targetGenes.csv
done	

# extract CDS, nonsynonymous, unique	
head -1 $DATA > target_CDS.csv
grep CDS targetGenes.csv >> target_CDS.csv
# extract nonsynonymous from CDS
grep -v synonymous target_CDS.csv > target_nonsyn.csv
# extract unique from nonsynonymous
grep -v rs[0-9]* target_nonsyn.csv > target_unique.csv
# format for publication table
echo -e "gene\tchromosome\tposition\tmutation\ttype" > temp
cut -f 1,2,8,15,17 target_unique.csv | sed 's/(.*$//g' | awk -F "\t" 'BEGIN{OFS="\t"}{print $4,$1,$2,$5,$3}' >> temp
# clean up mutation types
sed 's/SNP/missense/' temp | sed 's/MNP/missense/' | sed 's/INS/frameshift/' | sed 's/DEL/frameshift/' > HNSCCgeneTable.csv
rm temp

## all data
# extract data from coding sequences
head -1 $DATA > HNSCC_CDS.csv
grep CDS $DATA >> HNSCC_CDS.csv
# extract nonsynonymous from CDS
grep -v synonymous HNSCC_CDS.csv > HNSCC_nonsyn.csv
# extract unique from nonsynonymous
grep -v rs[0-9]* HNSCC_nonsyn.csv > HNSCC_unique.csv

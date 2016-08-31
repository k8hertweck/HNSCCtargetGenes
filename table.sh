## HNSSC
## Building table of non-synonymous somatic mutations for verified genes 
## Dependencies
##	candidateGenes.lst
##	$DATA with the following columns: 1 chr, 2 left_cancer (position), 15 gene, 17 annot_cancer

DATA=data/Ot6699_Ot6700_Santanu.Dasgupta_300-923_hEx-AV4_30x_01132013_Cancer_Nucleotide_Variation.csv

echo -e "gene\tchromosome\tposition\tmutation\ttype" > temp

# compile data from all genes
for x in `cat candidateGenes.lst`
	do
		grep $x $DATA | grep CDS | grep -v synonymous | grep -v rs[0-9]* | cut -f 1,2,8,15,17 | sed 's/(.*$//g' | awk -F "\t" 'BEGIN{OFS="\t"}{print $4,$1,$2,$5,$3}' >> temp
	done

# clean up mutation types
sed 's/SNP/missense/' temp | sed 's/MNP/missense/' | sed 's/INS/frameshift/' | sed 's/DEL/frameshift/' > data/HNSCCgeneTable.csv
rm temp

# create table to import into R containing all data for genes of interest
head -1 $DATA > data/HNSCCgeneData.csv
for x in `cat candidateGenes.lst`
	do
		grep $x $DATA >> data/HNSCCgeneData.csv
	done

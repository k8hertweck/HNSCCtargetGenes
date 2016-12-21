## HNSSC
## Building table of non-synonymous mutations for targeted genes 
## Data format
##	$DATA with the following columns: 1 chr, 2 left_cancer (position), 15 gene, 17 annot_cancer

SCRIPTS=~/GitHub/HNSCCtargetGenes

cd $SCRIPTS/data

## all data
# extract all possible variants
cut -f 10,11 Ot6699*.csv | sort | uniq -c > variantTypes.txt

# extract all strictly somatic variants
awk '{if($10 == "a/a" || $10 == "c/c" || $10 == "t/t" || $10 == "g/g" || $10 == "/") next;
	else print $0}' Ot6699*.csv > all_somatic.csv

# extract CDS from somatic
head -1 all_somatic.csv > HNSCC_CDS.csv
grep "\tCDS\t" all_somatic.csv >> HNSCC_CDS.csv
# extract nonsynonymous from CDS
grep -v synonymous HNSCC_CDS.csv > HNSCC_nonsyn.csv
# extract unique from nonsynonymous 
grep -v rs[0-9]* HNSCC_nonsyn.csv > HNSCC_unique.csv

## target genes
# extract all data from target genes
head -1 all_somatic.csv > targetGenes.csv
for x in `cat $SCRIPTS/candidateGenes.lst`
	do
		grep $x Ot6699*.csv >> targetGenes.csv
done	
# extract CDS from somatic	
head -1 all_somatic.csv > target_CDS.csv
grep "\tCDS\t" targetGenes.csv >> target_CDS.csv
# extract nonsynonymous from CDS
grep -v synonymous target_CDS.csv > target_nonsyn.csv
# extract unique from nonsynonymous (inspect zygosity to ensure somatic)
grep -v rs[0-9]* target_nonsyn.csv > target_unique.csv
# format for publication table
echo -e "gene\tchromosome\tposition\tmutation\ttype" > temp
tail +2 target_unique.csv | cut -f 1,2,8,15,17 | sed 's/(.*$//g' | awk -F "\t" 'BEGIN{OFS="\t"}{print $4,$1,$2,$5,$3}' >> temp
# clean up mutation types
sed 's/SNP/missense/' temp | sed 's/MNP/missense/' | sed 's/INS/frameshift/' | sed 's/DEL/frameshift/' > HNSCCgeneTable.csv
rm temp

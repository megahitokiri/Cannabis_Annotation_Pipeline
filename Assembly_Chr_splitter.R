library(GenomicRanges)
library(Biostrings)
library(optparse)
library(rtracklayer)

#usage: R --vanilla < Assembly_Chr_splitter.R --args -f PK_hap2.09082021.fasta  -a PK_hap2
#https://cran.r-project.org/web/packages/optparse/readme/README.html

option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="Required -GFF3 file", metavar="Fasta_File"),
  make_option(c("-a", "--assembly"), type="character", default=NULL, 
              help="Required Assembly Name file", metavar="Assembly_File")
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

File_Name = opt$file
Assembly_Name = opt$assembly

#Read Assembly (UNMASKED)
Assembly <- readDNAStringSet(File_Name)

for (i in 1:10)
  {
  fasta_name = paste0(Assembly_Name,".",names(Assembly)[i],".fasta")
  writeXStringSet(Assembly[i],file=fasta_name)
}


print("Scaffold 11 contains all minor scaffolds")
fasta_name = paste0(Assembly_Name,".scaffold_11.fasta")
writeXStringSet(Assembly[11:length(Assembly)],file=fasta_name)





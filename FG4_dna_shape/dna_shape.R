# Get DNA shapes of 10 BP regions overlapping with variant
# Gets the shape of the wild-type regions with the ref allele

source("packages.R")
args <- commandArgs()
print(args)
# Reads in variant file in the format: "chrom", "pos", "end", "ref", "alt", "R", "driver_stat"
featureDir=args[6]
featureOutputDir=args[8]
variants = paste(featureDir, args[7], sep = "")
print(variants)

# Import variants for shaping
variants=read.table(variants, sep = "\t")
colnames(variants) =  c("chrom", "pos", "end", "ref_allele", "alt_allele", "R", "driver_stat")
varTable = variants

# Get the desired base pair range for DNA shape
variants[2] = variants[2]-10
variants[3] = variants[3]+10

# Make a GRRanges object
variants = makeGRangesFromDataFrame(variants)

# Get the 10bp fasta for each variant
getFasta(variants, BSgenome = Hsapiens, width = 20, filename = "hg38.fa")
fn <- "hg38.fa"

# Get the shape properties of each position for each variant
pred <- getShape(fn)

# Reduce all of the properties into a single matrix
dnaShape = Reduce("cbind", pred)

dnaShape = cbind(varTable, dnaShape)

colnames(dnaShape) = c(colnames(dnaShape)[1:7], paste(1:20, "MGW", sep = "_"), paste(1:19, "HelT", sep = "_"), paste(1:20, "ProT", sep = "_"),
                 paste(1:19, "Roll", sep = "_"), paste(1:20, "EP", sep = "_"))

dnaShape = dnaShape[-3]

# Write DNA shape properties to CSV
name = paste(featureOutputDir, "dnaShape.txt", sep = "")

# Remove columns where all values are NA
dnaShape = dnaShape[,colSums(is.na(dnaShape))<nrow(dnaShape)]

write.table(dnaShape, name, quote = FALSE, row.names = FALSE, sep = "\t")

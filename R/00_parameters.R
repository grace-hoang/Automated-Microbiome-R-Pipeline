# 0. Parameters
# Edit only this file before running the pipeline.

# Configuration ----------------------------------------------------------------

set.seed(1234)
SEED         <- 1234
N_THREADS    <- TRUE
FORCE_RERUN  <- FALSE

# Input ------------------------------------------------------------------------

# Root folder containing FASTQ files, metadata.csv and reference database.
project_dir  <- "C:/Users/Grace_Hoang/OneDrive/Desktop/bioinfor/Samples"

# Metadata file (first column must contain sample IDs).
metadata_file <- file.path(project_dir, "metadata.csv")

# Read metadata
metadata <- read.csv(metadata_file, stringsAsFactors = FALSE, check.names = FALSE)

# Column used for comparisons (must exist in metadata.csv)
group_column <- "Group"

# Reference level for differential abundance
reference_group <- "Lagoon_Amuricata"

# Check inputs
stopifnot(group_column %in% colnames(metadata))
stopifnot(reference_group %in% unique(metadata[[group_column]]))

# SILVA database ---------------------------------------------------------------

silva_ref_path <- file.path(
  project_dir,
  "Silva",
  "silva_nr99_v138.2_toGenus_trainset.fa.gz"
)

# Primers ----------------------------------------------------------------------

primer_fwd <- "GGATTAGATACCCTGGTA"
primer_rev <- "CRRCACGAGCTGACGAC"

# DADA2 ------------------------------------------------------------------------

trunc_qmin <- 30

mergepairs_strategy     <- "merge"
mergepairs_min_overlap  <- 12
mergepairs_max_mismatch <- 0

chimera_method <- "consensus"
max_ee         <- c(2, 2)
max_n          <- 0
trunc_q        <- 2
remove_phix    <- TRUE

# ASV length -------------------------------------------------------------------

asv_min_len <- 230
asv_max_len <- 280

# Taxonomic filtering ----------------------------------------------------------

remove_chloroplast <- TRUE
remove_mitochondria <- TRUE
remove_unassigned <- TRUE

target_kingdoms <- "Bacteria"

# Rarefaction ------------------------------------------------------------------

rarefaction_mode <- "auto_rarefy"

custom_rarefaction_depth <- 10000

max_sample_loss <- 0.10
plateau_gain    <- 0.01
plateau_samples <- 0.90
read_step        <- 1000

# Diversity --------------------------------------------------------------------

alpha_measures <- c("Observed", "Chao1", "Shannon", "Simpson")
beta_distances <- c("bray", "wunifrac", "unifrac")
permanova_permutations <- 999

# Relative abundance -----------------------------------------------------------

min_phylum_abundance <- 0.01
min_genus_abundance  <- 0.02

# Output -----------------------------------------------------------------------

dir_results <- "result"
dir_figures <- file.path(dir_results, "figures")
dir_tables  <- file.path(dir_results, "tables")
dir_rds     <- file.path(dir_results, "rds")
dir_logs    <- file.path(dir_results, "logs")

for (d in c(dir_results, dir_figures, dir_tables, dir_rds, dir_logs)) {
  dir.create(d, recursive = TRUE, showWarnings = FALSE)
}